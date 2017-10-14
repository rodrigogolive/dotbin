#!/bin/sh
# check for directories I did not take an action yet

for dir in */
do
    if [ ! -f "$dir"/.done ]
    then
        echo $dir
    fi
done
