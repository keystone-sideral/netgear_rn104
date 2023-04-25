
This guide assumes that you have already installed and configured the RAID service.  

on RN104:

sudo apt update
sudo apt upgrade (if needed)
sudo apt install macchanger iostat fancontrol hdparm 

cd /home/$USER/netgear_rn104
sudo cp config/etc/rc.local /etc/rc.local  
sudo chmod +x /etc/rc.local  
sudo cp scripts/dislay.sh /usr/local/bin/display.sh 
sudo chmod +x /usr/local/bin/display.sh  

cd kernel-x.x.x <-- kernel you want (for exemple cd kernel-6.2.9)
sudo dpkg -i linux-headers-x.x.x.deb   
sudo dpkg -i linux-image-x.x.x.deb   
sudo dpkg -i linux-libc-x.x.x.deb  

cd /home/$USER/
git clone https://github.com/christgau/wsdd 
cd wsdd
sudo cp src/wsdd.py /usr/bin/wsdd
sudo chmod +x /usr/bin/wsdd

