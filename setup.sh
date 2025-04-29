#!/bin/bash

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Setting up CryptApex...${NC}\n"

PC_MEGA="https://mega.nz/file/lX90UJjD#mVsVX_uDW1waGv1VSCgF_vKIiieQxJbMXzh3_a3BlPw"
TERMUX_64_MEGA="https://mega.nz/file/pDNWnB4L#JxF3qICR6myp0v-lAsyt5n0PeS_ZzFr0cAF8x5B7I8Q"
TERMUX_32_MEGA="https://mega.nz/file/ZbVmFDaS#xm80pIBw26WorC0C-UCgzZabbyQ3RtHGJPvzAR-Fz0I"

if [ -d "/data/data/com.termux" ]; then
    pkg update -y && pkg upgrade -y
    pkg install -y python rust ruby megatools
    pip install requests pyfiglet
    gem install lolcat
    
    ARCH=$(uname -m)
    if [[ $ARCH == "aarch64" ]]; then
        MEGA_URL=$TERMUX_64_MEGA
    else
        MEGA_URL=$TERMUX_32_MEGA
    fi
    PYTHON_CMD="python"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}Setup for MacOS${NC}"
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install python3 lolcat megatools
    MEGA_URL=$PC_MEGA
    PYTHON_CMD="venv/bin/python"
else
    echo -e "${YELLOW}Setup for Linux/WSL${NC}"
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip ruby megatools
    sudo gem install lolcat
    MEGA_URL=$PC_MEGA
    PYTHON_CMD="venv/bin/python"
fi

echo -e "⬇️ Downloading CryptApex..."
megadl "$MEGA_URL" --path .

for f in *.zip; do
    unzip "$f"
    rm "$f"
done

for d in */ ; do
    mv "$d"* .
    rm -r "$d"
done

if [ ! -d "/data/data/com.termux" ]; then
    python3 -m venv venv
    source venv/bin/activate
    pip install requests pyfiglet
fi

echo -e "\n${GREEN}Done ✅! Running CryptApex...${NC}\n"

$PYTHON_CMD cryptapex.py || {
    cho -e "\n${YELLOW}[ ! ] Oops, couldn't run CryptApex on your device at the moment but it's possible to solve!"
    echo "Copy Error Log & Send It For Assistance:"
    echo "Telegram: @CryptApexSupport"
    echo -e "Email address: cryptapex.team@gmail.com${NC}\n"
    exit 1
}
