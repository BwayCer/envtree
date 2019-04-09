#!/bin/bash
# YAML 解析

#---
# 來源： https://github.com/jasperes/bash-yaml
#---


##shStyle ###


source shbase "#showHelp"


##shStyle 函式庫


[ -n "$_shBase_loadfile" ] \
    && fnSampleLib_fileName=`basename "$_shBase_loadfile"` \
    || fnSampleLib_fileName=`basename "$0"`

showHelpRecord "fnYamlParse" "\
YAML 解析
# 相關說明見： https://github.com/jasperes/bash-yaml
[[USAGE]] <YAML 文件路徑> [參數前綴符]
"
fnfnYamlParse() {
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

        awk -F"$fs" '{
            indent = length($1)/2;
            if (length($2) == 0) { conj[indent]="+";} else {conj[indent]="";}
            vname[indent] = $2;
            for (i in vname) {if (i > indent) {delete vname[i]}}
                if (length($3) > 0) {
                    vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                    printf("%s%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, conj[indent-1],$3);
                }
            }' |

        sed -e 's/_=/+=/g' |

        awk 'BEGIN {
                FS="=";
                OFS="="
            }
            /(-|\.).*=/ {
                gsub("-|\\.", "_", $1)
            }
            { print }'
    ) < "$yaml_file"
}


##shStyle ###


if [ ! -n "$_shBase_loadfile" ]; then
    [ $# -eq 0 ] \
        && fnfnYamlParse "$@" \
        || fnYamlParse_handle "$@"
fi

