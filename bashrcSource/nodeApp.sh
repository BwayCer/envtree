#!/bin/bash
# bashrcSource/nodeApp.sh


##shStyle ###


# __ysBashPath
# __envCode


##shStyle ###


tmpPath="$__ysBashPath/capp/lib/nodeApp/node_bin"
[[ ":$PATH:" =~ ":$tmpPath:" ]] || PATH="$PATH:$tmpPath"
unset tmpPath


## nvm
if [ $[$__envCode & 1] -ne 0 ]; then
    # 不加 &> /dev/null 這句的話每次載入就會跳出提示：
    # nvm is not compatible with the npm config "prefix" option:
    # currently set to "/path/to/.nvm/versions/node/v8.x.x"
    # Run `nvm use --delete-prefix v8.x.x --silent` to unset it.
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" &> /dev/null  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    alias nvm.enable="nvm use --delete-prefix node"
    # nvm use --delete-prefix node --silent
fi

