#!/bin/sh


hexo clean
hexo g
hexo d
cp -rf public /tmp/
