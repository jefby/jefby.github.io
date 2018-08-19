---
title: 创建aarch64 docker
date: 2015-12-08 13:10:29
tags: 
- aarch64
categories:
- aarch64
---

在官方的docker image中没有centos的image，所以我想自己做一个
参考资料：
[https://wiki.centos.org/zh/Cloud/Docker](https://wiki.centos.org/zh/Cloud/Docker)

#### 1. 拷贝ami-creator代码库

```bash
git clone [https://github.com/katzj/ami-creator](https://github.com/katzj/ami-creator)
```

#### 2. 编译安装ami-creator

执行命令python setup.py build，发现提示以下错误

```
#python setup.py build
Traceback (most recent call last):
File "setup.py", line 21, in <module>
from ez_setup import use_setuptools
ImportError: No module named ez_setup
```

解决方法：
```bash
wget https://bootstrap.pypa.io/ez_setup.py
python ez_setup.py
cp ez_setup.py /usr/lib/python2.7/site-packages/
cd ami-creator/
python setup.py build
python setup.py install
```
此时运行ami-creator –help还是出现异常，提示
```
ImportError: No module named imgcreate
```
应该是缺少imgcreate文件？？
```
yum install -y python-imgcreate
```

但是目前python-imgcreate不支持aarch64架构，所以需要添加patch，修改/usr/lib/python2.7/site-packages/imgcreate/live.py内容如下:

```
elif arch.startswith('arm'):
  LiveImageCreator = LiveImageCreatorBase
elif arch.startswith('aarch64'):
  LiveImageCreator = LiveImageCreatorBase
else:
  raise CreatorError("Architecture not supported!")
```

此时ami-creator已经可以使用了，如下图所示：

[![PfXgGF.md.png](https://s1.ax1x.com/2018/08/19/PfXgGF.md.png)](https://imgchr.com/i/PfXgGF)

#### 3. 克隆代码库sig-cloud-instance-build，并编译出image

`git clone [https://github.com/CentOS/sig-cloud-instance-build`，克隆制作docker image的ks文件，这个ks文件相比正常的ks文件，精简了体积，只保持系统到70M左右，果然很牛B
```
ami-creater -c centos7-arm64.ks//如果顺利会生成centos7-arm64-xxxx.img
img2tar.sh centos7-arm64-xxxx.img//会在/tmp目录下生成一个tar.bz2的文件
docker import /tmp/centos7-arm64-xxxx.img.tar.bz2 jefby/centos-arm64
```

#### 4. docker制作

```
yum install -y libguestfs-tools
docker import centos-7-arm64.img.tar.bz2 jefby/centos-arm64
docker run -i -t jefby/centos-arm64 /bin/bash //获取到进入系统后的xxxx-id，或者使用docker ps -l方法找到image的xxxx-id
docker commit -m "init for centos arm64 images" -a "jefby" xxxx-id//保存container的修改到image
docker push jefby/centos-arm64//推送新的image
由于v1.8.0和v1.8.1之间可能有一些API发生了改变，所以需要重新编译docker 
git remote add docker https://github.com/docker/docker/
git pull docker
git co v1.8.1
cd docker
./hack/make.sh dynbinary
设置环境变量将心编译的docker放到前面去：
export PATH=new-docker-path:$PATH
docker --version查看版本
```

继续 `docker push jefby/centos-arm64`将工作保存下来


