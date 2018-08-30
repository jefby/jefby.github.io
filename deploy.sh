#!/bin/sh


hexo clean
hexo g
hexo d
cp -rf public /tmp/
git co master
cp -rf /tmp/public/* .
