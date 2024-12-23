# """""""""""""""""""""""""""""""
# " ./setup-scripts/packages.sh "
# """""""""""""""""""""""""""""""
#  ____________
# /\           \
# \_| PACKAGES |
#   |          |
#   |   _______|_
#    \_/_________/

BASE_PKGS=(
    mpv 
    ffmpeg 
    ranger 
    openssh 
    networkmanager 
    htop 
    vim 
    curl 
    zsh 
    kitty 
    neofetch 
    neovim 
    zellij 
    dhcp 
    dhcpcd 
    xclip 
    wpa_supplicant 
    udisks2 
    usbutils 
    sxhkd 
    aria2p  
    bluez
)

SERVICES=(
    NetworkManager 
    bluetooth 
    sshd 
    dhcpcd
)

FONT_PKGS=(
    ttf-fantasque-sans-mono
	ttf-jetbrains-mono
    ttf-fira-code 
	ttf-jetbrains-mono-nerd
	ttf-joypixels
    ttf-hack
    ttf-material-design-icons 
    ttf-symbola
    ttf-dejavu 
    ttf-liberation 
    noto-fonts 
    noto-fonts-cjk 
    noto-fonts-emoji 
    noto-fonts-extra
)

DWM_REQUIRED_PKGS=(
    fzf
    base-devel
    xorg
    xorg-xrandr
    picom-ftlabs-git
    nitrogen
    pywal
)

DWM_EXTRA_PKGS=(
    blueman-git
	bluez-utils
	dialog
    dust
    imagemagick
    jq
    kitty
    lsd
    netctl
	network-manager-applet
    polkit-kde-agent
    qt5ct
	sxiv
	telegram-desktop
    thunar
	thunar-archive-plugin
	unclutter
    wireless_tools
	xf86-input-synaptics
    youtube-dl
    yt-dlp
)

NVIDIA_PROPRITARY_DRIVERS=(
    nvidia-390xx 
    nvidia-390xx-utils 
    opencl-nvidia-390xx 
    nvidia-390xx-dkms 
    nvidia-390xx-settings 
    envycontrol nvtop
)
