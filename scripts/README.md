This script is used to display information about the system on the LCD screen.  
````  
su -  
mkdir -pv /usr/local/bin  
cp /home/$USER/netgear_rn104/scripts/dislay.sh /usr/local/bin/display.sh  
chmod +x /usr/local/bin/display.sh  
````  
Don't forget to adjust display.sh for your need:  
````  
# start time for lcd backlight
    begin=$(date --date="7:00" +%s)   <----- Turn on front screen at 7:00 am
    # end time for lcd backlight
    end=$(date --date="21:00" +%s)    <----- Turn off front screen at 9:00 pm
    now=$(date +%s)
    if [ "$begin" -le "$now" -a "$now" -le "$end" ]; then
        ton_screen
        home
        IPv4
        utime
        laverage
        memusage
        swapusage
        cputemp
        diskUsage  "/"                <----- Adjust 
        diskUsage  "/srv/raid5"       <----- Adjust 
        diskUsage  "/srv/ssd"         <----- Adjust 
        raidstatus "/dev/md0"         <----- Adjust 
        time_now
    else
        toff_screen
    fi
    ````  
