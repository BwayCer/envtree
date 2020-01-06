#!/bin/bash
# bashrcSource/docker.sh


##shStyle ###


# __ysBashPath
# __plantHomePath
# __envCode


##shStyle ###


# docker.ipa <容器 (Name|ID) ...>
alias docker.ipa="docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"

