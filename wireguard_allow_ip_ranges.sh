#!/bin/sh
################################################################################
# This script was created by: MDK - mdk@qtrnn.io                               #
# https://qtrnn.io                                                             #
#                                                                              #
# Simple script to update wireguard PostUp and PreDown iptables rules,         #
# allowing private IP ranges                                                   #
#                                                                              #
# WARNING:                                                                     #
# - As this will modify the config files in place, I recommend have a backup   #
# of the original files                                                        #
# - This do not check if the rule were already applied, it will run and update #
# with the same info all the time (appending the rule at the end of PostUp and #
# PreDown lines)                                                               #
################################################################################

print_usage(){
    echo "Usage: $0 [PATH] <IP_RANGE(s)>"
    echo
    echo "    PATH:     where the configuration files are located (default: current folder)"
    echo "    IP_RANGE: range of IP address to allow
              multiple IP addresses can be specified, separated by an space

              Example:
              $ $0 wireguard/ 172.16.16.0/24 172.18.18.0/24"
    echo
}

if [ -d "$1" ]
then
    WORKDIR=$1
    shift
else
    WORKDIR=$(pwd)
fi
echo "Looking for files on $WORKDIR"

if [ "$#" -lt 1 ]
then
    echo "ERROR: IP address(es) not set"
    echo
    print_usage
    exit
fi
IP_RANGE=$(echo "$@" | tr ' ' ',' | sed 's/\//\\\//g')

# PostUp rule
URULE="iptables -I OUTPUT -d $IP_RANGE -j ACCEPT"
# PreDown rule
DRULE="iptables -D OUTPUT -d $IP_RANGE -j ACCEPT"

echo "Applying PostUp rule: $URULE"
find "$WORKDIR" -name \*.conf -exec sed -i '/PostUp/ s/$/ \&\& '"$URULE"'/' {} \;

echo "Applying PreDown rule: $DRULE"
find "$WORKDIR" -name \*.conf -exec sed -i '/PreDown/ s/$/ \&\& '"$DRULE"'/' {} \;

echo "Done"
