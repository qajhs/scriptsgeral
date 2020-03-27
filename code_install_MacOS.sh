#!/bin/bash
if [[ $USER != "root" ]]; then
printf 'First of all, please be sudo.\n\n'
printf "Use 'sudo su' :D\n\n"
exit
fi

_install() {
    printf 'Configuring code command in path.\n'
    if [[ -f /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code ]]; then
       printf "Found command 'code' in VS Code APP!\n"
       echo $PATH | grep -iq '/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin'
            if [[ $? != 0 ]]; then
                printf "Inserting in \$PATH!\n"
                sudo echo '# Generate with code installer.sh' >> /etc/bashrc
                sudo echo 'export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin' >> /etc/bashrc
            else
                printf "Command 'code' already configured, exiting :P\n"
                exit
            fi
        printf "Done!\n"
        printf "Restart your computer or use:\n- source /etc/bashrc\nEnjoy :)"
        exit
        else
       printf "Not found 'code' command in VS Code APP!\nCheck your VS Code APP\n\nFile:\n/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code\n\nNot FOUND!.\n"
       exit
    fi
}

printf 'Checking Visual studio app in Applications folder.\n'
if [[ -d /Applications/Visual\ Studio\ Code.app ]]; then
   printf "Found!\n\nMoving on\n\n"
    else
   printf "Not found!\nApp name need to be 'Visual Studio Code.app' on applications folder.\n"
   exit
fi

which code > /dev/null 2>&1
if [[ $? == 0 ]]; then
   printf "Found command.\n"
        while true; do
           printf 'Want to configure $PATH even so?\n'
           read -p 'Answer: ' yn
            case "$yn" in
              [Yy] ) printf 'Ok, moving on! :D\n';_install;exit;;
              [Nn] ) printf 'Quitting :D\n';exit;;
               * ) printf 'Please enter (Yy)es or (Nn)o'
            esac
        done
    else
   printf "Not found command code going.\n"
   _install
fi
