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
bashrcSourcePath="$k8sToolPath/bashrcSource"
binPath="$k8sToolPath/bin"

googleStorageUrl="https://storage.googleapis.com"


##shStyle ###


fnBuild_kubectl() {
    local latestVersion=`curl -s $googleStorageUrl/kubernetes-release/release/stable.txt`
    local remoteFileUrl="$googleStorageUrl/kubernetes-release/release/$latestVersion/bin/linux/amd64/kubectl"
    local storePath="$binPath/kubectl"
    local completionFilePath="$bashrcSourcePath/completion-kubectl"

    if [ ! -e "$storePath" ]; then
        curl -L "$remoteFileUrl" -o "$storePath"
        chmod 755 "$storePath"
    fi
    if [ ! -e "$completionFilePath" ]; then
        "$storePath" "completion" "bash" > "$completionFilePath"
        chmod 755 "$completionFilePath"
    fi
}

fnBuild_minikube() {
    local remoteFileUrl="$googleStorageUrl/minikube/releases/latest/minikube-linux-amd64"
    local storePath="$binPath/minikube"
    local completionFilePath="$bashrcSourcePath/completion-minikube"

    if [ ! -e "$storePath" ]; then
        curl -L "$remoteFileUrl" -o "$storePath"
        chmod 755 "$storePath"
    fi
    if [ ! -e "$completionFilePath" ]; then
        "$storePath" "completion" "bash" > "$completionFilePath"
        chmod 755 "$completionFilePath"
    fi
}


##shStyle ###


[ -d "$bashrcSourcePath" ] || mkdir -p "$bashrcSourcePath"
[ -d "$binPath"          ] || mkdir -p "$binPath"

fnBuild_kubectl
fnBuild_minikube

