#!/bin/bash

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Setting up CryptApex...${NC}\n"

PC_MEGA="https://mega.nz/file/gC9zkT4I#Vi6FG5hnLwYQZdV6R4KoaXoqmR4yzUCllnKgXzbCC50"
TERMUX_64_MEGA="https://mega.nz/file/FXtSXLiI#7Zi8D_HYbhWn6MyPG9gJabLvT7wNW6xK9OLjNhqlKO8"
TERMUX_32_MEGA="https://mega.nz/file/of1BHJ7J#j3_BE5AsAP7NyBx-h_ItKDH4FDPNG7cs1U8fHMROp-0"

if [ -d "/data/data/com.termux" ]; then
    echo -e "${YELLOW}Setup for Termux${NC}"
    pkg install -y python rust ruby megatools
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
    echo -e "\n${YELLOW}[ ! ] Oops, couldn't run CryptApex on your device at the moment but it's possible to solve!"
    echo "Copy Error Log & Send It For Assistance:"
    echo "Telegram: @CryptoApexSupport"
    echo -e "Email address: cryptapex.team@gmail.com${NC}\n"
    exit 1
}
