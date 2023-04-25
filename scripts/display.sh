#!/bin/bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# This script is used to display system information on the front screen. 
# It should be rewritten, but it works!
# Feel free to suggest something better ;)
#
# https://github.com/keystone-sideral/netgear_rn104/


# functions

# Clear the display (send "\f" to /dev/lcd)
clear_screen () {
    printf "\f" > /dev/lcd
}

# Back light off (send "\E[L-" to /dev/lcd)
toff_screen () {
    printf "\E[L-" > /dev/lcd
    sleep 60
}

# Back light on (send "\E[L+" to /dev/lcd)
ton_screen () {
    printf "\E[L+" > /dev/lcd
    printf "\f" > /dev/lcd
    sleep 1
}

# uptime
utime () {
    for i in $(seq 0 60) 
    do
        printf "     Uptime     \n" > /dev/lcd
        printf "%s $(uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/){if ($9=="min") {d=$6;m=$8} else {d=$6;h=$8;m=$9}} else {h=$6;m=$7}}} {print d+0,"d,",h+0,"h,",m+0,"m"}') \n" > /dev/lcd
        sleep 1
    done
} 

# time (HH:MM:SS)
time_now () {
    for i in $(seq 0 600) 
    do
        printf " \n" > /dev/lcd
        printf "%s    $(date +"%H:%M:%S")\n" > /dev/lcd
        sleep 1
    done
}

# load average
laverage () {
    for i in $(seq 0 120) 
    do
        printf "  Load Average  \n" > /dev/lcd
        printf "%s $(cut -d" " -f1-3 /proc/loadavg) \n" >/dev/lcd
        sleep 1
    done
} 

# ram Usage
memusage () {
    for i in $(seq 0 60) 
    do
        printf " Memory Usage  \n" > /dev/lcd
        printf "%s $(free -m | awk 'NR==2{printf "%sMB / %sMB \n", $3,$2 }') \n" >/dev/lcd
        sleep 1
    done
}

# swap Usage
swapusage () {
    for i in $(seq 0 20) 
    do
        printf "  Swap Usage  \n" > /dev/lcd
        printf "%s  $(free -m | awk 'NR==3{printf "%sMB / %sMB \n", $3,$2 }') \n" >/dev/lcd
        sleep 1
    done
}


# home screen
home () {
    printf " Debian %s $(cat /etc/os-release | grep 'VERSION_ID='| sed 's/VERSION_ID=\s*//g' | sed 's/"\s*//g') \n" > /dev/lcd
    printf "%s $(uname -r) \n" >/dev/lcd
    sleep 10
} 



# cpu temperature
cputemp () {
        for i in $(seq 0 120) 
        do
            printf " CPU Temp   %s $(echo $(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000)))C \n" >/dev/lcd
            sensor="/sys/class/thermal/thermal_zone0/temp"
            temp=$(cat "$sensor")

            if [ $temp -le 47000 ]
                then 
                    printf "[..............]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 47001 ] && [ $temp -le 48000 ]
                then
                    printf "[#.............]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 48001 ] && [ $temp -le 49000 ]
                then
                    printf "[##............]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 49001 ] && [ $temp -le 50000 ]
                then
                    printf "[###...........]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 50001 ] && [ $temp -le 51000 ]
                then
                    printf "[####..........]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 51001 ] && [ $temp -le 52000 ]
                then 
                    printf "[#####.........]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 52001 ] && [ $temp -le 53000 ]
                then
                    printf "[######........]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 53001 ] && [ $temp -le 54000 ]
                then 
                    printf "[#######.......]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 54001 ] && [ $temp -le 55000 ]
                then 
                    printf "[########......]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 55001 ] && [ $temp -le 56000 ]
                then 
                    printf "[#########.....]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 56001 ] && [ $temp -le 57000 ]
                then 
                    printf "[##########....]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 57001 ] && [ $temp -le 58000 ]
                then 
                    printf "[###########...]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 58001 ] && [ $temp -le 59000 ]
                then 
                    printf "[############..]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 59001 ] && [ $temp -le 60000 ]
                then 
                    printf "[#############.]\n" >/dev/lcd
                    sleep 1
            elif [ $temp -ge 60001 ]
                then 
                    printf "[##############]\n" >/dev/lcd
                    sleep 1
            fi
        done
}


# Raid Status
# use "/dev/mdx" at first input parameters $1
# for exemple: raidstatus "/dev/md0"
raidstatus () {
        for i in $(seq 0 120) 
        do
                printf "   Raid Status  \n" > /dev/lcd
                printf "%s$(mdadm -D $1 | grep 'Working Devices' | sed 's/\s*Working/Work/g' | sed 's/\s*Devices/ Dev/g') \n" >/dev/lcd
                sleep 2
                printf "   Raid Status  \n" > /dev/lcd
                printf "%s$(mdadm -D $1 | grep 'Failed Devices' | sed 's/\s*Failed/Fail/g' | sed 's/\s*Devices/ Dev/g') \n" >/dev/lcd
                sleep 2
                printf "   Raid Status  \n" > /dev/lcd
                printf "%s$(mdadm -D $1 | grep 'State :' | sed 's/\s*State/Stat/g') \n" >/dev/lcd
                sleep 2
        done
}

# disk usage
# use "/mount/point" at first input parameters $1
# for exemple: diskUsage "/srv/smb"
diskUsage () {
        for i in $(seq 0 60) 
        do
            pcent_=$(df --output=pcent $1 | sed '1d;s/^ //;s/%//')
            sleep 1
            if [ "$pcent_" -le "6" ] 
                then
                    printf "%s $1 \n" > /dev/lcd
                    printf "[..............]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "6" ] && [ "$pcent_" -le "10" ]
                then
                    printf "%s $1 \n" > /dev/lcd
                    printf "[#.............]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "10" ] && [ "$pcent_" -le "19" ]
                then
                    printf "%s $1 \n" > /dev/lcd
                    printf "[##............]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "19" ] && [ "$pcent_" -le "25" ]
                then
                    printf "%s $1 \n" > /dev/lcd
                    printf "[###...........]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "25" ] && [ "$pcent_" -le "33" ]
                then
                    printf "%s $1 \n" > /dev/lcd
                    printf "[####..........]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "33" ] && [ "$pcent_" -le "40" ]
                then 
                    printf "%s $1 \n" > /dev/lcd
                    printf "[#####.........]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "40" ] && [ "$pcent_" -le "45" ]
                then 
                    printf "%s $1 \n" > /dev/lcd
                    printf "[######........]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "45" ] && [ "$pcent_" -le "51" ]
                then 
                    printf "%s $1 \n" > /dev/lcd
                    printf "[#######.......]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "51" ] && [ "$pcent_" -le "55" ]
                then 
                    printf "%s $1 \n" > /dev/lcd
                    printf "[########......]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "55" ] && [ "$pcent_" -le "60" ]
                then
                    printf "%s $1 \n" > /dev/lcd
                    printf "[#########.....]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "60" ] && [ "$pcent_" -le "69" ]
                then
                    printf "%s $1 \n" > /dev/lcd
                    printf "[##########....]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "69" ] && [ "$pcent_" -le "77" ]
                then 
                    printf "%s $1 \n" > /dev/lcd
                    printf "[###########...]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "77" ] && [ "$pcent_" -le "85" ]
                then 
                    printf "%s $1 \n" > /dev/lcd
                    printf "[############..]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "85" ] && [ "$pcent_" -le "95" ]
                then 
                    printf "%s $1 \n" > /dev/lcd
                    printf "[#############.]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            elif [ "$pcent_" -gt "95" ]
                then 
                    printf "%s $1 \n" > /dev/lcd
                    printf "[##############]\n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "%s $(df -h  $1  | awk '{ print $3 }' | tail -n 1| cut  -f1) - %s$(df -h  $1  | awk '{ print $2 }' | tail -n 1| cut  -f1) \n" >/dev/lcd
                    sleep 2
                    printf "%s $1 \n" > /dev/lcd
                    printf "    %s$pcent_ pcent \n" > /dev/lcd
                    sleep 2
            fi
        done
}

# IPv4 address
IPv4 () {
    for i in $(seq 0 120) 
        do
            printf "      IPv4      \n" > /dev/lcd
            rn104_ip4_addrs="$(ip addr | grep 'inet ' | grep -v '127.0.0.1/8' | awk '{print $2}' | cut -f1 -d'/' |wc -l)"
            if [ "${rn104_ip4_addrs}" -eq "0" ]
                then
                    # No IPv4 address available
                    printf "IPv4 addr=N/A \n" > /dev/lcd
            elif [ "${rn104_ip4_addrs}" -eq "1" ]
                then
                    # One IPv4 address is available
                    printf "%s $(ip addr | grep 'inet ' | grep -v '127.0.0.1/8' | awk '{print $2}' | cut -f1 -d'/' | head -n 1) \n" >/dev/lcd
            fi
        done
}

# main
clear_screen
# main loop
while true
do
    # start time for lcd backlight
    begin=$(date --date="7:00" +%s)
    # end time for lcd backlight
    end=$(date --date="21:00" +%s)
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
        diskUsage  "/"
        diskUsage  "/srv/raid5"
        diskUsage  "/srv/ssd"
        raidstatus "/dev/md0"
        time_now
    else
        toff_screen
    fi
done
