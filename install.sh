# Set global values
STEPCOUNTER=false # Changes to true if user choose to install Tux Everywhere
YELLOW='\033[1;33m'
LIGHT_GREEN='\033[1;32m'
LIGHT_RED='\033[1;31m'
NC='\033[0m' # No Color

function install {
    printf "\033c"
    header "TUX REFIND THEME" "$1"
    echo "rEFInd does many things and one thing is that its presenting the boot options"
    echo "in a more graphical way. Using rEFInd makes it possible to have Tux on the"
    echo "Ubuntu Boot Drive for example. Install instructions can be found here:"
    echo "http://www.rodsbooks.com/refind/"
    echo ""
    echo "PS. If you're not booting different OSes on your PC, don't bother with rEFInd."
    echo ""
    printf "${LIGHT_GREEN}Already up and running with rEFInd?${NC}\n"
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes )
                printf " ${YELLOW}Initiating to copy folder tux-refind-theme.${NC}\n"
                check_sudo
                if [ -d "/boot/efi/EFI/refind/themes/" ]; then
                # Control will enter here if $DIRECTORY exists.
                    sudo rm -rf /boot/efi/EFI/refind/themes/tux-refind-theme
                    sudo mkdir -p /boot/efi/EFI/refind/themes
                    sudo cp -rf tux-refind-theme /boot/efi/EFI/refind/themes/tux-refind-theme
                    # Here we add a last line if it not already exists (If other themes exists doesn't matter since our line ends up last and will therefore be used)
                    sudo grep -q -F 'include themes/tux-refind-theme/theme.conf' /boot/efi/EFI/refind/refind.conf || echo 'include themes/tux-refind-theme/theme.conf' | sudo tee -a /boot/efi/EFI/refind/refind.conf
                    printf "${YELLOW}Successfully copied 'tux-refind-theme' to your rEFInd themes folder.${NC}\n"
                else
                    printf "\033c"
                    header "TUX REFIND THEME" "$1"
                    printf "${LIGHT_RED}Couldn't find rEFInd's theme folder${NC}\n"   
                    echo "If rEFInd is installed, check out our manual instructions at:"
                    echo "https://tux4ubuntu.org"
                    echo ""
                    echo "Otherwise, read the instructions more carefully before continuing :)"
                fi
                break;;
            No ) printf "\033c"
                header "TUX REFIND THEME" "$1"
                printf "${YELLOW}Exiting rEFInd installer.${NC}\n"

                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key

}

function uninstall { 
    printf "\033c"
    header "TUX REFIND THEME" "$1"
    printf "${LIGHT_RED}Are you sure you want to remove TUX REFIND THEME from your rEFInd?${NC}\n"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) header "TUX REFIND THEME" "$1"

                if [ -d "/boot/efi/EFI/refind/themes/tux-refind-theme" ]; then
                # Control will enter here if $DIRECTORY exists.

                    echo "Ok, rEFInd will be spared but Tux removed."
                    last_line="$(sudo awk '/./{line=$0} END{print line}' /boot/efi/EFI/refind/refind.conf)"                            
                    theme_line="include themes/tux-refind-theme/theme.conf"
                    if [ "$last_line" == "$theme_line" ] 
                    then
                        printf " ${YELLOW}Removing theme from rEFInd.${NC}\n"
                        sudo sed -i '$ d' /boot/efi/EFI/refind/refind.conf
                        sudo rm -f -r /efi/EFI/boot/refind/themes/tux-refind-theme
                        printf " Successfully removed the theme from rEFInd.\n"                      
                    else
                        printf "\033c"
                        header "TUX REFIND THEME" "$1"
                        echo "Seems like someone edited the refind.conf file. For more information and help:"
                        echo "https://tux4ubuntu.org"
                    fi

                else
                    printf "\033c"
                    header "TUX REFIND THEME" "$1"
                    printf "${LIGHT_RED}Couldn't find 'tux-refind-theme'-folder${NC}\n"
                    echo "If the theme is still installed, check out our manual instructions at:"
                    echo "https://tux4ubuntu.org"
                fi


                break;;
            No ) printf "\033c"
                header "Removing Tux to BOOT LOADER" "$1"
                echo " Awesome! Tux smiles and gives you a pat on the shoulder."
            break;;
        esac
    done

    
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function header {
    var_size=${#1}
    # 80 is a full width set by us (to work in the smallest standard terminal window)
    if [ $STEPCOUNTER = false ]; then
        # 80 - 2 - 1 = 77 to allow space for side lines and the first space after border.
        len=$(expr 77 - $var_size)
    else   
        # "Step X/X " is 9
        # 80 - 2 - 1 - 9 = 68 to allow space for side lines and the first space after border.
        len=$(expr 68 - $var_size)
    fi
    ch=' '
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    printf "║"
    printf " ${YELLOW}$1${NC}"
    printf '%*s' "$len" | tr ' ' "$ch"
    if [ $STEPCOUNTER = true ]; then
        printf "Step "${LIGHT_GREEN}$2${NC}
        printf "/7 "
    fi
    printf "║\n"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

function check_sudo {
    if sudo -n true 2>/dev/null; then 
        :
    else
        printf "${YELLOW}Oh, TUX will ask below about sudo rights to copy and install everything...${NC}\n\n"
    fi
}

function goto_tux4ubuntu_org {
    echo ""
    printf "${YELLOW}Launching website in your favourite browser...${NC}\n"
    x-www-browser https://tux4ubuntu.org/ &
    echo ""
    sleep 2
    read -n1 -r -p "Press any key to continue..." key
}

while :
do
    clear
    if [ -z "$1" ]; then
        :
    else
        STEPCOUNTER=true
    fi
    header "TUX REFIND THEME" "$1"
    # Menu system as found here: http://stackoverflow.com/questions/20224862/bash-script-always-show-menu-after-loop-execution
    cat<<EOF                                                                      
Type one of the following numbers/letters:
                                                         
1) Read Instructions                      - Open up tux4ubuntu.org      
2) Install                                - Install Boot Loader theme          
3) Uninstall                              - Uninstall Boot Loader theme       
--------------------------------------------------------------------------------   
Q) Skip                                   - Quit Boot Loader theme installation

(Press Control + C to quit the installer all together)
EOF
    read -n1 -s
    case "$REPLY" in
    "1")    goto_tux4ubuntu_org;;
    "2")    install $1;;
    "3")    uninstall $1;;
    "S")    exit                      ;;
    "s")    exit                      ;;
    "Q")    exit                      ;;
    "q")    exit                      ;;
     * )    echo "invalid option"     ;;
    esac
    sleep 1
done