#!/bin/bash
# bashrcSource/docker.sh


##shStyle ###


# __ysBashPath
# __envCode


##shStyle ###


# docker.ipa <容器 (Name|ID) ...>
alias docker.ipa="docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"

alias docker.once.mizarchRun="docker.once --image local/mizarch:latest --bwaycer --myhome --network host"
alias docker.once.mizarch="docker.once.mizarchRun bash"

