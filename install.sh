# Set global values
STEPCOUNTER=false # Changes to true if user choose to install Tux Everywhere
RED='\033[0;31m'
NC='\033[0m' # No Color

function install {
    printf "\033c"
    header "Adding TUX REFIND THEME" "$1"
    printf "${RED}MAKE SURE rEFInd IS INSTALLED!${NC}\n"                       
    echo ""
    echo "rEFInd does many things and one thing is that its presenting the boot options"
    echo "in a more graphical way. Using rEFInd makes it possible to have Tux on the"
    echo "Ubuntu Boot Drive for example. Install instructions can be found here:"
    echo "http://www.rodsbooks.com/refind/"
    echo ""
    echo "PS. If you're not booting different OSes on your PC, don't bother with rEFInd."
    echo ""
    echo "Already up and running with rEFInd?"
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes )
                echo "Initiating to copy folder tux-refind-theme."
                check_sudo
                if [ -d "/boot/efi/EFI/refind/themes/" ]; then
                # Control will enter here if $DIRECTORY exists.
                    sudo rm -rf /boot/efi/EFI/refind/themes/tux-refind-theme
                    sudo mkdir -p /boot/efi/EFI/refind/themes
                    sudo cp -rf tux-refind-theme /boot/efi/EFI/refind/themes/tux-refind-theme
                    # Here we add a last line if it not already exists (If other themes exists doesn't matter since our line ends up last and will therefore be used)
                    sudo grep -q -F 'include themes/tux-refind-theme/theme.conf' /boot/efi/EFI/refind/refind.conf || echo 'include themes/tux-refind-theme/theme.conf' | sudo tee -a /boot/efi/EFI/refind/refind.conf
                    echo "Successfully copied 'tux-refind-theme' to your rEFInd themes folder."
                else
                    printf "\033c"
                    header "Adding TUX REFIND THEME" "$1"
                    printf "${RED}COULDN'T FIND REFIND THEMES FOLDER!${NC}\n"   
                    echo "If rEFInd is installed, check out our manual instructions at:"
                    echo "https://tux4ubuntu.org"
                    echo ""
                    echo "Otherwise, read the instructions more carefully before continuing :)"
                fi
                break;;
            No ) printf "\033c"
                header "Adding TUX REFIND THEME" "$1"
                echo "Exiting rEFInd installer."

                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key

}

function uninstall { 
    printf "\033c"
    header "Removing Tux in BOOT LOADER" "$1"
    echo "Are you sure you want to remove TUX REFIND THEME from your rEFInd?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) header "Removing Tux to BOOT LOADER" "$1"

                if [ -d "/boot/efi/EFI/refind/themes/tux-refind-theme" ]; then
                # Control will enter here if $DIRECTORY exists.

                    echo "Ok, rEFInd will be spared but Tux removed."
                    last_line="$(sudo awk '/./{line=$0} END{print line}' /boot/efi/EFI/refind/refind.conf)"                            
                    theme_line="include themes/tux-refind-theme/theme.conf"
                    if [ "$last_line" == "$theme_line" ] 
                    then
                        echo "Removing theme from rEFInd."
                        sudo sed -i '$ d' /boot/efi/EFI/refind/refind.conf
                        sudo rm -f -r /efi/EFI/boot/refind/themes/tux-refind-theme   
                        echo "Successfully removed the theme from rEFInd."                                 
                    else
                        printf "\033c"
                        header "Removing Tux to BOOT LOADER" "$1"
                        echo "Seems like someone edited the refind.conf file. For more information and help:"
                        echo "https://tux4ubuntu.org"
                    fi

                else
                    printf "\033c"
                    header "Adding TUX REFIND THEME" "$1"
                    printf "${RED}COULDN'T FIND REFIND TUX-REFIND-THEME FOLDER!${NC}\n"   
                    echo "If the theme is still installed, check out our manual instructions at:"
                    echo "https://tux4ubuntu.org"
                fi


                break;;
            No ) printf "\033c"
                header "Removing Tux to BOOT LOADER" "$1"
                echo "Awesome! Tux smiles and gives you a pat on the shoulder."
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
    printf " $1"
    printf '%*s' "$len" | tr ' ' "$ch"
    if [ $STEPCOUNTER = true ]; then
        printf "Step "$2
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
        echo "Oh, and Tux will need sudo rights to copy and install everything, so he'll ask" 
        echo "about that soon."
        echo ""
    fi
}

function goto_tux4ubuntu_org {
    echo ""
    echo "Launching website in your favourite browser."
    x-www-browser https://tux4ubuntu.org/ &
    read -n1 -r -p "Press any key to continue..." key
    echo ""
}

while :
do
    clear
    # Menu system as found here: http://stackoverflow.com/questions/20224862/bash-script-always-show-menu-after-loop-execution
    cat<<EOF    
╔══════════════════════════════════════════════════════════════════════════════╗
║ TUX REFIND THEME ver 1.0                                   © 2018 Tux4Ubuntu ║
║ Let's Bring Tux to Ubuntu                             https://tux4ubuntu.org ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   What do you wanna do today? (Type in one of the following numbers)         ║
║                                                                              ║
║   1) Read manual instructions                  - Open up tux4ubuntu.org      ║
║   2) Install                                   - Install the theme           ║
║   3) Uninstall                                 - Uninstall the theme         ║
║   ------------------------------------------------------------------------   ║
║   Q) Quit                                      - Quit the installer (Ctrl+C) ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    read -n1 -s
    case "$REPLY" in
    "1")    goto_tux4ubuntu_org;;
    "2")    install $1;;
    "3")    uninstall $1;;
    "Q")    exit                      ;;
    "q")    exit                      ;;
     * )    echo "invalid option"     ;;
    esac
    sleep 1
done