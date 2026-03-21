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
# ~/.bash_aliases in a nice manner
#
# -------------------------------------

# Est. 2024-06-19 Happy BirthDay!

####################################################################
####################################################################
####################################################################
### GIT ALIASES ####################################################
####################################################################
####################################################################
####################################################################

# alias gs='git status '
# alias ga='git add '
# alias gap='git add --patch'
# alias gb='git branch '
# alias gc='git commit'
# alias gd='git diff'
# alias go='git checkout '
# alias gk='gitk --all&'
# alias gx='gitx --all'

#alias got='git '
#alias get='git '

####################################################################
### GIT ALIASES FOR LOG/TREE #######################################
####################################################################

alias gl='git log --oneline --graph --decorate --all'

# git config --global alias.tree 'log --oneline --graph --decorate --all'
# git config --global alias.tree
# git tree
# git tree -4

####################################################################
####################################################################
####################################################################
### OTHER ALIASES ##################################################
####################################################################
####################################################################
####################################################################

alias vi=vim

# OS-X SPECIFIC - the -G command in OS-X is for colors,
# in Linux it's no groups.
alias ls='ls -G1'

# alias docker=podman

alias python=python3
alias pip=pip3

alias edit=zed
# alias edit=subl

alias reboot="sudo reboot"
alias restart="sudo reboot"

alias shutdown="sudo shutdown now"
alias poweroff="sudo shutdown now"

alias show_background_tasks='sudo sfltool dumpbtm|egrep "^\W+(#\d+|Disposition:|Identifier:)"|cut -c -80'

# alias zed="/Applications/Zed.app/Contents/MacOS/cli"

alias mc="mc --nosubshell"

alias grep='grep --color=auto'
