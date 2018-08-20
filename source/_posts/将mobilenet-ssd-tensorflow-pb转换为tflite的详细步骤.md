---
title: 将mobilenet_ssd tensorflow.pb转换为tflite的详细步骤
date: 2018-08-20 00:47:34
tags:
- tensorflow
- machine learing
categories:
- ML
---


### 1.依赖工具及环境
* 下载tensorflow-models源码

	`git clone https://github.com/tensorflow/models`
	
* 按照提示配置环境
	注意在~/.bashrc添加上
	
	```
	# From tensorflow/models/research/
	export PYTHONPATH=$PYTHONPATH:xxxxxx/tensorflow-models/research:xxxx/tensorflow-models/research/slim
	```
	
* 下载tensorflow源码和android ndk r16b

	```
	https://github.com/tensorflow/tensorflow
	cd tensorflow
	git checkout r1.10
	```


	设置编译android demo需要的ndk
	进入tensorflow源码根目录，修改WORKSPACE增加如下行

	```
	android_sdk_repository(
	   name = "androidsdk",
	   api_level = 27,
	   build_tools_version = "27.0.2",
	   path = "/Users/xxxx/Library/Android/sdk",
	)

	# Android NDK r12b is recommended (higher may cause issues with Bazel)
	android_ndk_repository(
	   name="androidndk",
	   path="/Users/xxxx/Library/Android/sdk/android-ndk-r16b",
	   api_level=21
	) 
	```



	
### 2.生成tflite兼容的pb graph

#### 2.1) 设置变量
```
ROOT_PATH=xxxxx/tensorflow/pretrained_models
export CONFIG_FILE=${ROOT_PATH}/pipeline.config
export CHECKPOINT_PATH=${ROOT_PATH}/model.ckpt
export OUTPUT_DIR=/tmp/tflite
```

#### 2.2) 根据pb、checkpoint、pipeline.config等生成frozen graph

```
python object_detection/export_tflite_ssd_graph.py --pipeline_config_path $CONFIG_FILE  --trained_checkpoint_prefix $CHECKPOINT_PATH --output_directory /tmp/tflite/ --add_postprocessing_op=true
```

### 3.通过TOCO获取优化后的模型

TOCO: TensorFlow Lite Optimizing Converter

#### 3.1）如果想要整型[这块暂时没调通]

```
bazel run --config=opt tensorflow/contrib/lite/toco:toco -- \
--input_file=$OUTPUT_DIR/tflite_graph.pb \
--output_file=$OUTPUT_DIR/detect.tflite \
--input_shapes=1,300,300,3 \
--input_arrays=normalized_input_image_tensor \
--output_arrays='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3' \
--inference_type=QUANTIZED_UINT8 \
--mean_values=128 \
--std_values=128 \
--change_concat_input_ranges=false \
--allow_custom_ops
```
#### 3.2）如果想要浮点类型

```
bazel run --config=opt tensorflow/contrib/lite/toco:toco -- \
--input_file=$OUTPUT_DIR/tflite_graph.pb \
--output_file=$OUTPUT_DIR/detect.tflite \
--input_shapes=1,300,300,3 \
--input_arrays=normalized_input_image_tensor \
--output_arrays='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3'  \
--inference_type=FLOAT \
--allow_custom_ops
```

### 4. 集成到Android Studio工程中

#### 4.1）更新模型和配置文件
	
`cp /tmp/tflite/detect.tflite tensorflow/contrib/lite/examples/android/app/src/main/assets`

编辑tensorflow/contrib/lite/examples/android/BUILD，增加新的detect.tflite和color_pen_label.txt


```diff
@@ -37,9 +37,10 @@ android_binary(
         "@tflite_conv_actions_frozen//:conv_actions_frozen.tflite",
         "//tensorflow/contrib/lite/examples/android/app/src/main/assets:conv_actions_labels.txt",
         "@tflite_mobilenet_ssd//:mobilenet_ssd.tflite",
-        "@tflite_mobilenet_ssd_quant//:detect.tflite",
+        "//tensorflow/contrib/lite/examples/android/app/src/main/assets:detect.tflite",
         "//tensorflow/contrib/lite/examples/android/app/src/main/assets:box_priors.txt",
         "//tensorflow/contrib/lite/examples/android/app/src/main/assets:coco_labels_list.txt",
+        "//tensorflow/contrib/lite/examples/android/app/src/main/assets:color_pen_label.txt",
     ],
```

新建color_pen_label.txt内容为

```
???
color-pen
```

拷贝到demo/asset目录：

`cp color_pen_label.txt tensorflow/contrib/lite/examples/android/app/src/main/assets`

如果是float的话，按如下修改源码
tensorflow/contrib/lite/examples/android/app/src/main/java/org/tensorflow/demo/DetectorActivity.java

```diff
@@ -50,9 +50,9 @@ public class DetectorActivity extends CameraActivity implements OnImageAvailable

   // Configuration values for the prepackaged SSD model.
   private static final int TF_OD_API_INPUT_SIZE = 300;
-  private static final boolean TF_OD_API_IS_QUANTIZED = true;
+  private static final boolean TF_OD_API_IS_QUANTIZED = false;
   private static final String TF_OD_API_MODEL_FILE = "detect.tflite";
-  private static final String TF_OD_API_LABELS_FILE = "file:///android_asset/coco_labels_list.txt";
+  private static final String TF_OD_API_LABELS_FILE = "file:///android_asset/color_pen_label.txt";
```

如果是量化模型的话，按如下修改源码

```diff
@@ -50,9 +50,9 @@ public class DetectorActivity extends CameraActivity implements OnImageAvailable

   // Configuration values for the prepackaged SSD model.
   private static final int TF_OD_API_INPUT_SIZE = 300;
   private static final String TF_OD_API_MODEL_FILE = "detect.tflite";
-  private static final String TF_OD_API_LABELS_FILE = "file:///android_asset/coco_labels_list.txt";
+  private static final String TF_OD_API_LABELS_FILE = "file:///android_asset/color_pen_label.txt";
```

#### 4.2）编译tflite_demo app

```
bazel build --cxxopt=--std=c++11 //tensorflow/contrib/lite/examples/android:tflite_demo

# arm64版本
bazel build -c opt --config=android_arm64 --cxxopt='--std=c++11' //tensorflow/contrib/lite/examples/android:tflite_demo

```

#### 4.3）安装到Android设备

```
adb install -r bazel-bin/tensorflow/contrib/lite/examples/android/tflite_demo.apk
```

#### 4.4）运行TFL Detect App
