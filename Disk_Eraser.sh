#!/bin/bash

# Disclaimer message
echo "Warning: I am not responsible for any data loss if you choose the wrong disk!"
echo "Please double-check the disk you are selecting before proceeding."
echo

while true; do
	while true; do
		lsblk -o NAME,SIZE,TYPE,MODEL | grep -E "^NAME|^sd"
		
		read -p "Enter the disk letter (e.g., 'c' for /dev/sdX): " disk_letter; disk_letter="${disk_letter,,}"
		DISK="/dev/sd${disk_letter}"
		if [ ! -e "$DISK" ]; then
			echo "You didn't provide an existing disk letter."
			echo
			echo
		else
			break
		fi
	done
		
	echo
	echo
	echo "Disk information for $DISK:"
	echo "----------------------------------"
	lsblk -o NAME,SIZE,TYPE,MODEL $DISK | grep -v "part"
	
	echo
	echo
	read -p "Are you sure you want to execute on disk $DISK? Type 'y' to proceed: " confirm; confirm="${confirm,,}"
	if [ $confirm = "y" ]; then
		break
	fi
	yes "" | head -n 9
done

ERROR_LIMIT=50
ERROR_COUNT=0

yes "" | head -n 9
echo "----------------------------------"

sudo shred -v -n 1 $DISK 2>&1 | while read line; do
    echo "$line"
    if echo "$line" | grep -q "Input/output error"; then
        ERROR_COUNT=$((ERROR_COUNT + 1))
        echo "Error $ERROR_COUNT detected"
    fi
    if [ "$ERROR_COUNT" -ge "$ERROR_LIMIT" ]; then
        echo "Reached error limit ($ERROR_LIMIT). Stopping."
        exit 1
    fi
done


if [ "$ERROR_COUNT" -eq "$ERROR_LIMIT" ]; then
	sudo shred -v -n 2 $DISK
else
	for i in {1..3}; do
		echo "Pass $i: Overwriting with random data..."
		#sudo dd if=/dev/urandom of=$DISK bs=1M conv=noerror,sync status=progress
		sudo timeout 3600 dd if=/dev/urandom of=$DISK bs=1M conv=noerror,sync status=progress
	done

	echo
	echo
	echo "----------------------------------"
	echo "WARNING: There were many disk errors. The errors on the disk have not been overwritten. It's better to destroy it, even physically."
fi
