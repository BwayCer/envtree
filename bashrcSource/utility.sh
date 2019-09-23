#!/bin/bash
# 實用工具


##shStyle ###


# __ysBashPath
# __envCode


##shStyle ###


alias date.RFC3339NanoZ08='date -u +"%Y-%m-%dT%H:%M:%S.%9NZ"'


# VirtualBox

alias vmtool.box.mount="sudo mount -t vboxsf -o uid=1000,gid=1000" # <資料夾名稱> <dirpath>


# protobuf

alias protoc.go="protoc --go_out"
alias protoc.js="protoc --js_out"

