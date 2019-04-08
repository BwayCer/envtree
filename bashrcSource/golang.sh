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
# GOPATH --------- /home/user/path/to/go
# GOPROXY --------
# GORACE ---------
# GOROOT --------- /usr/lib/go
# GOTMPDIR -------
# GOTOOLDIR ------ /usr/lib/go/pkg/tool/linux_amd64
# GCCGO ---------- gccgo
# CC ------------- gcc
# CXX ------------ g++
# CGO_ENABLED ---- 1
# GOMOD ----------
# CGO_CFLAGS ----- -g -O2
# CGO_CPPFLAGS ---
# CGO_CXXFLAGS --- -g -O2
# CGO_FFLAGS ----- -g -O2
# CGO_LDFLAGS ---- -g -O2
# PKG_CONFIG ----- pkg-config
# GOGCCFLAGS ----- -fPIC -m64 -pthread -fmessage-length=0

case $__envCode in
    1 )
        export GOROOT="/usr/lib/go"
        export GOBIN="$__ysBashPath/gitman/golang/bin"
        export GOPATH="$__ysBashPath/gitman/golang"
        ;;
    2 )
        export GOBIN=` cygpath -w "$__ysBashPath/gitman/golang/bin"`
        export GOPATH=`cygpath -w "$__ysBashPath/gitman/golang"`
        ;;
esac

