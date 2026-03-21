#                                                          .;;,
#                                     .,.               .,;;;;;,
#                                    ;;;;;;;,,        ,;;%%%%%;;
#                                     `;;;%%%%;;,.  ,;;%%;;%%%;;
#                                       `;%%;;%%%;;,;;%%%%%%%;;'
#                                         `;;%%;;%:,;%%%%%;;%%;;,
#                                            `;;%%%,;%%%%%%%%%;;;
#                                               `;:%%%%%%;;%%;;;'
#           ..,,,.                                 .:::::::.
#        .;;;;;;;;;;,.                                  s.
#        `;;;;;;;;;;;;;,                               ,SSSs.
#          `:.:.:.:.:.:.:.                            ,SSSSSSs.
#           .;;;;;;;;;;;;;::,                        ,SSSSSSSSS,
#          ;;;;;;;;;;;;;;;;:::%,                    ,SS%;SSSSSSsS
#         ;;;;;;,:,:::::::;::::%%,                  SS%;SSSSSSsSS
#         ;;;;;,::a@@@@@@a::%%%%%%%,.   ...         SS%;SSSSSSSS'
#         `::::::@@@@@@@@@@@a;%%%%%%%%%'  #;        `SS%;SSSSS'
#  .,sSSSSs;%%,::@@@@@@;;' #`@@a;%%%%%'   ,'          `S%;SS'
#sSSSSSSSSSs;%%%,:@@@@a;;   .@@@a;%%sSSSS'           .%%%;SS,
#`SSSSSSSSSSSs;%%%,:@@@a;;;;@@@;%%sSSSS'        ..,,%%%;SSSSSSs.
#  `SSSSSSSSSSSSs;%%,%%%%%%%%%%%SSSS'     ..,,%;sSSS;%;SSSSSSSSs.
#     `SSSSSSSSSSS%;%;sSSSS;""""   ..,,%sSSSS;;SSSS%%%;SSSSSSSSSS.
#         """""" %%;SSSSSS;;%..,,sSSS;%SSSSS;%;%%%;%%%%;SSSSSS;SSS.
#                `;SSSSS;;%%%%%;SSSS;%%;%;%;sSSS;%%%%%%%;SSSSSS;SSS
#                 ;SSS;;%%%%%%%%;%;%sSSSS%;SSS;%%%%%%%%%;SSSSSS;SSS
#                 `S;;%%%%%%%%%%%%%SSSSS;%%%;%%%%%%%%%%%;SSSSSS;SSS
#                  ;SS;%%%%%%%%%%%%;%;%;%%;%%%%%%%%%%%%;SSSSSS;SSS'
#                  SS;%%%%%%%%%%%%%%%%%%%;%%%%%%%%%%%;SSSSSS;SSS'
#                  SS;%%%%%%%%%%%%%%%%%%;%%%%%%%%%%%;SSSSS;SSS'
#                  SS;%%%%%%%%%%%%%;sSSs;%%%%%%%%;SSSSSS;SSSS
#                  `SS;%%%%%%%%%%%%%%;SS;%%%%%%;SSSSSS;SSSS'
#                   `S;%%%%%%%%%%%%%%%;S;%%%%%;SSSS;SSSSS%
#                    `S;%;%%%%%%%%%%%'   `%%%%;SSS;SSSSSS%.
#                  ,S;%%%%%%%%%%;'      `%%%%%;S   `SSSSs%,.
#                  ,%%%%%%%%%%;%;'         `%;%%%;     `SSSs;%%,.
#               ,%%%%%%;;;%;;%;'           .%%;%%%       `SSSSs;%%.
#            ,%%%%%' .%;%;%;'             ,%%;%%%'         `SSSS;%%
#          ,%%%%'   .%%%%'              ,%%%%%'             `SSs%%'
#        ,%%%%'    .%%%'              ,%%%%'                ,%%%'
#      ,%%%%'     .%%%              ,%%%%'                 ,%%%'
#    ,%%%%'      .%%%'            ,%%%%'                  ,%%%'
#  ,%%%%'        %%%%           ,%%%'                    ,%%%%
#  %%%%'       .:::::         ,%%%'                      %%%%'
#.:::::        :::::'       ,%%%'                       ,%%%%
#:::::'                   ,%%%%'                        %%%%%
#                        %%%%%'                         %%%%%
#                      .::::::                        .::::::
#                      ::::::'                        ::::::'

# -------------------------------------
#
# ~/.bash_functions in a nice manner
#
# -------------------------------------

# Est. 2024-06-13 Happy BirthDay!

####################################################################

function gi() { curl -sL "https://www.toptal.com/developers/gitignore/api/$@"; }

####################################################################
####################################################################
####################################################################
### printTable #####################################################
####################################################################
####################################################################
####################################################################

# https://github.com/alebelcor/dotfiles
# https://github.com/holman/dotfiles
# https://github.com/mathiasbynens/dotfiles
# https://github.com/gdbtek/linux-cookbooks/blob/main/libraries/util.bash

function printTable() {
    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]; then
        local -r numberOfLines="$(wc -l <<<"${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]; then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1)); do
                local line=''
                line="$(sed "${i}q;d" <<<"${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<<"${line}")"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]]; then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                # Add Header Or Body

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1)); do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<<"${line}")")"
                done

                table="${table}#|\n"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]; then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]; then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
    fi
}

function removeEmptyLines() {
    local -r content="${1}"

    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString() {
    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]; then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString() {
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]; then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString() {
    local -r string="${1}"

    sed 's,^[[:blank:]]*,,' <<<"${string}" | sed 's,[[:blank:]]*$,,'
}

####################################################################
####################################################################
####################################################################
### sqlite2csv #####################################################
####################################################################
####################################################################
####################################################################

function sqlite2csv-table() {
    local db="${1}" table="${2}" output="${3}"
    if [[ -z "$output" ]]; then
        output="${db%.*}_${table}.csv"
    fi
    [[ "$output" == *.csv ]] || output+='.csv'

    echo "sqlite2csv-table: outputting table '$table' to '$output'"
    sqlite3 -header -csv "$db" "select * from ${table};" > "$output" || return $?
}

function sqlite2csv() {
    local db="${1}" o="${2}"

    local tables
    tables=($(sqlite3 "$db" ".tables"))
    local table
    for table in "${tables[@]}"; do
        sqlite2csv-table "$db" "$table" "${o}_${table}.csv"
    done
}

# Usage:
# sqlite2csv some.db [/path/to/output]
