---
title: '为Fedora21 aarch64制作RPM包（tengine） '
date: 2015-04-08 10:45:00
tags:
- aarch64
categories:
- aarch64
---

本文简单记录将tengine-2.10版本源码打为rpm包的步骤，此处是简单的封装了下二进制，没有做复杂的脚本配置和gpg校验等，待以后有时间继续研究。
1.安装必要包
```
$yum install -y gcc pcre-devel openssl-devel
```
2.创建tengine rpm构建目录，使用非root用户
```
$su - jefby
$mkdir -p tengine_rpm/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
```
3.编写spec文件，将源码放置到SOURCES目录下
```
$unzip tengine-master.zip
$mv tengine-master tengine-2.10
$tar -cjvf tengine-2.10.tar.bz2 tengine-2.10
$mv tengine-2.10.tar.bz2 SOURCES
$vi SPECS/tengine.spec
```
tengine.spec文件详细内容：
```
# This is a sample spec file for tengine

%define _topdir         /home/jefby/tengine_rpm
%define name            tengine
%define release         2
%define version         2.10
%define buildroot       %{_topdir}/%{name}-%{version}-root

BuildRoot:              %{buildroot}
Summary:                TAOBAO Tengine
License:                GPL
Name:                   %{name}
Version:                %{version}
Release:                %{release}
Source:                 %{name}-%{version}.tar.bz2
Prefix:                 /usr/local
Group:                  Development/Tools
BuildRequires:          gcc,make
Requires:               pcre,pcre-devel,openssl,openssl-devel,chkconfig >= 1.1.1

%description
Tengine is the webserver based nginx for taobao website

%prep #编译前准备，主要是解压缩源码，并进入压缩后的目录
%setup -q

%build #编译
./configure --prefix=/opt/nginx
make %{?_smp_mflags} #检查处理器核心数目，若为多核则使用多核编译

%install #安装，如果不设置DESTDIR，默认安装到prefix指定的目录
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}


#%post  #rpm安装后执行的脚本

#%preun #卸载前执行的脚本

#%postun #卸载后执行的脚本

%clean #清理，检查buildroot是否为根目录，如果不是直接删除
[ %{buildroot} != '/' ] && rm -rf %{buildroot}

%files #打包到rpm的文件，因为prefix指定为/opt/nginx，此时将整个文件夹打包
/opt/nginx
%defattr(-,root,root)#设置属性
```
目录结构
```
$tree .
├── BUILD
├── RPMS
├── SOURCES
│   └── tengine-2.10.tar.bz2
├── SPECS
│   └── tengine.spec
└── SRPMS
```
说明：
	BUILD	源代码解压后的存放目录
	RPMS    制作完成后的RPM包存放目录，里面有与平台相关的子目录
	SOURCES 软件源码及补丁
	SPECS   SPEC文件存放目录
	SRMPS   存放SRMPS生成的目录
4.编译制作rpm包
```
$rpmbuild -v -ba --clean SPEC/tengine.spec
其中-v表示Verbose，输出详细信息
-bb：构建二进制RPM包
-ba：构建二进制RPM和源码src.RPM包
-bp：运行到pre结束
-bc：执行到build结束
-bi：运行到install结束
-bl：检查有文件没包含
一般使用bb或者ba
--clean：
Remove the build tree after the packages are made.
```
成功会在RPMS目录下生成
tengine-xxx.rpm和tengine-debuginfo-xxx.rpm包，在SRPMS目录下生成src.rpm包
```
├── BUILD
├── RPMS
│   └── aarch64
│       ├── tengine-2.10-2.aarch64.rpm
│       └── tengine-debuginfo-2.10-2.aarch64.rpm
├── SOURCES
│   └── tengine-2.10.tar.bz2
├── SPECS
│   └── tengine.spec
└── SRPMS
    └── tengine-2.10-2.src.rpm
```
如此，RPM便制作OK，可以添加到私有repo中(暂时关闭掉gpg校验)，或者直接使用rpm方式安装：
```
$rpm -ivh tengine-2-10-2.aarch64.rpm
```
 补充：
 查看spec文件已定义的一些宏，可以搜索文件
 ```
 $cat /usr/lib/rpm/macro
 ```



