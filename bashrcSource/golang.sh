#!/bin/bash
# bashrcSource/golang.sh


##shStyle ###


# __ysBashPath
# __envCode


##shStyle ###


tmpPath="$__ysBashPath/gitman/golang/bin"
[[ ":$PATH:" =~ ":$tmpPath:" ]] || PATH="$PATH:$tmpPath"
unset tmpPath


##shStyle ###


# Go 相關設置

# http://wiki.jikexueyuan.com/project/go-command-tutorial/0.14.html

## 查看 go env
# GOARCH --------- amd64
# GOBIN ----------
# GOEXE ----------
# GOHOSTARCH ----- amd64
# GOHOSTOS ------- linux
# GOOS ----------- linux
# GOPATH --------- /home/user/go
# GORACE ---------
# GOROOT --------- /home/user/ys/capp/go
# GOTOOLDIR ------ /home/user/ys/capp/go/pkg/tool/linux_amd64
# GCCGO ---------- gccgo
# CC ------------- gcc
# GOGCCFLAGS ----- -fPIC -m64 -pthread -fmessage-length=0
# CXX ------------ g++
# CGO_ENABLED ---- 1
# CGO_CFLAGS ----- -g -O2
# CGO_CPPFLAGS ---
# CGO_CXXFLAGS --- -g -O2
# CGO_FFLAGS ----- -g -O2
# CGO_LDFLAGS ---- -g -O2
# PKG_CONFIG ----- pkg-config

case $__envCode in
    1 )
        export GOBIN="$__ysBashPath/gitman/golang/bin"
        export GOPATH="$__ysBashPath/gitman/golang"
        ;;
    2 )
        export GOBIN=` cygpath -w "$__ysBashPath/gitman/golang/bin"`
        export GOPATH=`cygpath -w "$__ysBashPath/gitman/golang"`
        ;;
esac

