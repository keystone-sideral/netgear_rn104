This script is executed on boot.  

You need macchanger iostat fancontrol hdparm  :

````  
su -  
apt update && apt upgrade && apt install macchanger iostat fancontrol hdparm  
exit  
````  
Install WSDD:  
````  
git clone https://github.com/christgau/wsdd  
cd wsdd  
su -  
cp src/wsdd.py /usr/bin/wsdd  
cd /home/$USER  
````  
cp rc.local to /etc:  
````  
cp /home/$USER/netgear_rn104/config/etc/rc.local /etc/rc.local  
chmod +x /etc/rc.local  
````  
Don't forget to adjust rc.local for your need.  
