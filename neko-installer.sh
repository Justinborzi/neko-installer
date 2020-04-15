#!/bin/sh
echo "
 ___  ___          _   _      _____                        _ _ 
 |  \/  |         | | (_)    /  ___|                      | | |
 | .  . |_   _ ___| |_ _  ___\ `--.  ___  __ _  __ _ _   _| | |    \    /\
 | |\/| | | | / __| __| |/ __|`--. \/ _ \/ _` |/ _` | | | | | |     )  ( ')
 | |  | | |_| \__ \ |_| | (__/\__/ /  __/ (_| | (_| | |_| | | |    (  /  )
 \_|  |_/\__, |___/\__|_|\___\____/ \___|\__,_|\__, |\__,_|_|_|     \(__)|
          __/ |                                 __/ |          
         |___/                                 |___/    

"
echo -e "\e[93mThis script does not account for machine specific error,"
echo -e "\e[93mit does however do the base install of the n.eko panel"
echo "--------------------------------------------------------------"
echo -e "\e[34mInstalling docker with the latest stable release."
curl -sSL https://get.docker.com/ | CHANNEL=stable bash
sudo apt-get install ufw wget -y

if [ -x "$(command -v docker)" ]; then
    echo "Docker is installed!"
else
    echo "Docker is not installed or failed to install!"
fi

echo -e "\e[34mOpening port 80 getting the composer file, and building the project!"
ufw allow 80/tcp & wget https://raw.githubusercontent.com/nurdism/neko/master/docker-compose.yaml

echo "configure the docker-compose.yaml [Services > neko], Leave all blank if you don't know what you are doing."
read -p "image (nurdism/neko): " n_image
read -p "restart (always): " n_res
read -p "shm_size (2gb): " n_shm
read -p "ports (80:8080): " n_portSize
echo "End of Services > neko"

echo "Start Services > enviroment"
read -p "neko Display (0): " n_display
read -p "neko Width (1280): " n_width
read -p "neko Height (720): " n_height
read -p "neko Password (neko): " n_password
read -p "neko Bind (:8080)" n_port

echo '

' > docker-compose.yaml

echo -e "\e[92mStart the server? [y/n]: "
read ans
if [ans = "y"] then
    sudo docker run -p 8080:8080 -e NEKO_PASSWORD='secret' --shm-size=$n_shm nurdism/neko:latest
    docker-compose up -d
fi
