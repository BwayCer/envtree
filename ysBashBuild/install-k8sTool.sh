#!/bin/bash
# 安裝庫八司工具


##shStyle ###


# loxog

# _br
# __filename
# _dirsh
# _fileName

# ysPath
# envCode


##shStyle 共享變數


k8sToolPath=`realpath "$_dirsh/.."`
binPath="$k8sToolPath/bin"

googleStorageUrl="https://storage.googleapis.com"


##shStyle ###


fnBuild_kubectl() {
    local latestVersion=`curl -s $googleStorageUrl/kubernetes-release/release/stable.txt`
    local remoteFileUrl="$googleStorageUrl/kubernetes-release/release/$latestVersion/bin/linux/amd64/kubectl"
    local storePath="$binPath/kubectl"

    if [ ! -e "$storePath" ]; then
        curl -L "$remoteFileUrl" -o "$storePath"
        chmod 755 "$storePath"
    fi
}

fnBuild_minikube() {
    local remoteFileUrl="$googleStorageUrl/minikube/releases/latest/minikube-linux-amd64"
    local storePath="$binPath/minikube"

    if [ ! -e "$storePath" ]; then
        curl -L "$remoteFileUrl" -o "$storePath"
        chmod 755 "$storePath"
    fi
}


##shStyle ###


[ -d "$binPath"       ] || mkdir -p "$binPath"

fnBuild_kubectl
fnBuild_minikube

