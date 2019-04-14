#!/bin/bash
# YAML 解析

#---
# 參考文件： https://github.com/jasperes/bash-yaml
#---


##shStyle ###


source shbase "#showHelp"


##shStyle 函式庫


[ -n "$_shBase_loadfile" ] \
    && fnSampleLib_fileName=`basename "$_shBase_loadfile"` \
    || fnSampleLib_fileName=`basename "$0"`

showHelpRecord "fnYamlParse" "\
YAML 解析
# 相關說明可見： https://github.com/jasperes/bash-yaml
[[USAGE]] <YAML 文件路徑> [參數前綴符]
"
fnYamlParse() {
    [ $# -eq 0 ] && showHelp "$fnSampleLib_fileName" "fnYamlParse"

    local yaml_file="$1"
    local prefix="$2"
    eval "$(fnYamlParse_handle "$yaml_file" "$prefix")"
}
fnYamlParse_handle() {
    local yaml_file="$1"
    local prefix="$2"
    local s
    local w
    local fs

    s='[[:space:]]*'
    w='[a-zA-Z0-9_.-]*'
    fs="$(echo @|tr @ '\034')"

    (
        sed -e '/- [^\“]'"[^\']"'.*: /s|\([ ]*\)- \([[:space:]]*\)|\1-\'$'\n''  \1\2|g' |

        sed -ne '/^--/s|--||g; s|\"|\\\"|g; s/[[:space:]]*$//g;' \
            -e "/#.*[\"\']/!s| #.*||g; /^#/s|#.*||g;" \
            -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
            -e "s|^\($s\)\($w\)${s}[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |

        awk -F "$fs" '{
            indent = length($1)/2;
            vname[indent] = $2;
            for (i in vname) {
                if (i > indent) {
                    delete vname[i]}
                }
                vv = $3;
                if (length(vv) > 0) {
                    vn = "'"$prefix"'";
                    for (i=0; i <= indent; i++) {
                        nameVal = vname[i];
                        if (length(nameVal) != 0) {
                            if (length(vn) != 0) {
                                vn=(vn)("_")(nameVal);
                            } else {
                                vn=(vn)(nameVal);
                            }
                        }
                    }

                    if (vv == "~") {
                        # null == ""
                        vv = "";
                    } else if (vv == "true") {
                        # true == "1"
                        vv = "1";
                    } else if (vv == "false") {
                        # false == "0"
                        vv = "0";
                    }
                    # 不建議在 Yaml 中使用 單引號 包覆文字
                    if (match(vv, /^\\".*\\"$/) != 0) {
                        vv = substr(vv, 3, (match(vv, /\\"$/) - 3));
                    }

                    printf("%s+=(\"%s\")\n", vn, vv);
                }
            }'
    ) < "$yaml_file"
}


##shStyle ###


if [ ! -n "$_shBase_loadfile" ]; then
    if [ $# -eq 0 ]; then
        fnYamlParse "$@"
    else
        if [ -f "$1" ] && ping -c 1 -W 1 8.8.8.8 &> /dev/null ; then
            tmpFlattenedJsonJs="
                function flattenedJson(jsonTxt) {
                    let json = JSON.parse(jsonTxt);
                    flattenedJson.handle(json, []);
                }
                flattenedJson.handle = function handle(data, nameChain) {
                    let outKey, outVal;
                    let isOutput = true;
                    let isStringType = false;
                    let isArray = false;

                    // Yaml 中不會出現 undefined
                    if (data === null) {
                        outVal = null;
                    }
                    else switch (data.constructor) {
                        case Array:
                            isArray = true;
                        case Object:
                            let key, val;
                            let lenNameChain = nameChain.length;
                            isOutput = false;
                            for (key in data) {
                                isArray || (nameChain[lenNameChain] = key);
                                handle(data[key], nameChain);
                            }
                            isArray || nameChain.pop();
                            break;
                        case String:
                            isStringType = true;
                            outVal = JSON.stringify(data);
                            break;
                        default:
                            outVal = data;
                    }

                    if (isOutput) {
                        outKey = nameChain.join('_');
                        outKey === '' && (outKey = '# _');
                        console.log(
                            isStringType
                                ? '%s+=\x1b[40m(\x1b[36m%s\x1b[00m\x1b[40m)\x1b[00m'
                                : '%s+=\x1b[40m(\x1b[35m%s\x1b[00m\x1b[40m)\x1b[00m',
                            outKey,
                            outVal
                        );
                    }
                };
            "
            tmp=$(
                curl -s --url "http://yaml-online-parser.appspot.com/ajax" \
                    --request "POST" \
                    --header "cache-control: no-cache" \
                    --header "content-type: application/x-www-form-urlencoded" \
                    --data-urlencode "yaml=$(cat $1)" \
                    --data-urlencode "type=json"
            )
            if type node &> /dev/null ; then
                node -e "$tmpFlattenedJsonJs flattenedJson($tmp);"
            else
                echo -e "$(sed 's/^"//; s/"$//;' <<< $tmp)" | sed -r 's/(\\")/"/g'
            fi
            echo -e "\n---\n"
        fi

        fnYamlParse_handle "$@"
    fi
fi

