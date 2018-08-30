---
title: 'Tensorflow Lite C++动态库编译[Android]'
date: 2018-08-30 16:22:50
tags:
- tensorflow
- Android
categories:
- ML
---

在Android的jni中使用tflite c++ API做推理，以下是记录：

* 进入tensorflow源码根目录，修改WORKSPACE增加如下内容：

```
android_sdk_repository(
   name = "androidsdk",
   api_level = 27,
   build_tools_version = "27.0.2",
   path = "/Users/jefby/Library/Android/sdk",
)

# Android NDK r12b is recommended (higher may cause issues with Bazel)
android_ndk_repository(
   name="androidndk",
#   path="/Users/xxx/Library/Android/sdk/android-ndk-r16b",
   path="/Users/xxx/Library/Android/sdk/ndk-bundle",
   api_level=21
)
```


* 在tensorflow/contrib/lite/BUILD中增加如下内容，用于生成libtensorflowLite.so

```
cc_binary(
    name = "libtensorflowLite.so",
    linkopts = ["-shared", "-Wl,-soname=libtensorflowLite.so"],
    visibility = ["//visibility:public"],
    linkshared = 1,
    copts = tflite_copts(),
    deps = [
        ":framework",
        "//tensorflow/contrib/lite/kernels:builtin_ops",
    ],
)
```

* 编译，根据APP_ABI可自行设置为armeabi-v7a或者arm64-v8a

```
# build for armeabi-v7a
bazel build -c opt //tensorflow/contrib/lite:libtensorflowLite.so   --crosstool_top=//external:android/crosstool --cpu=armeabi-v7a --host_crosstool_top=@bazel_tools//tools/cpp:toolchain --cxxopt="-std=c++11" --verbose_failures


# build for arm64-v8a
bazel build -c opt //tensorflow/contrib/lite:libtensorflowLite.so   --crosstool_top=//external:android/crosstool --cpu=arm64-v8a --host_crosstool_top=@bazel_tools//tools/cpp:toolchain --cxxopt="-std=c++11" --verbose_failures

```

发现提示如下错误：

>jni_src/jni/src/utils/xxxxTFLite.cpp:41: error: undefined reference to 'tflite::InterpreterBuilder::operator()(std::__ndk1::unique_ptr<tflite::Interpreter, std::__ndk1::default_delete<tflite::Interpreter> >*)'

原因是ndk-r16b有问题，使用android studio自带的r17 ndk编译

重新编译会生成文件 `bazel-bin/tensorflow/contrib/lite/libtensorflowLite.so`

这个就是我们需要的动态库，可以通过Android.mk、Application.mk集成到Android工程中使用




