#!/bin/bash
# 數組陣列 - 連接


##shStyle 函式庫


# fnIntervalTime <方法 (echo|record)>
fnIntervalTime() {
    local method="$1"
    local now=`date -u +"%M%S%3N"`
    case "$method" in
        record )
            fnEchoIntervalTime_prevStamp=$now
            ;;
        echo )
            echo "$[now - echoIntervalTime_prevStamp]ms"
            ;;
    esac
}
fnEchoIntervalTime_prevStamp=0

