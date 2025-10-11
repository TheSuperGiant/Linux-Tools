#!/bin/bash

# Disclaimer message
echo "Warning: I am not responsible for any data loss if you choose the wrong disk!"
echo "Please double-check the disk you are selecting before proceeding."

echo -e "\n\n⚠️ WARNING: This will erase all data on that disk.⚠️\n\n"

while true; do
	while true; do
		if [[ $round == "1" ]];then
			clear
		fi
		#echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
		#lsblk -o NAME,TYPE,SIZE,LABEL | grep -E "^(.*) (disk|part) (.*)$"
		lsblk -o NAME,TYPE,SIZE,LABEL,MODEL | awk 'NR==1{print;next} $2=="disk" && NR>1{print "--------------------------------------------------"} $2=="disk" || $2=="part"{print}'
		echo "--------------------------------------------------"

		#lsblk -o NAME,TYPE,SIZE,LABEL,MODEL | awk 'NR==1 || $2=="disk" || $2=="part"'
		
		read -p "Enter the disk letter (e.g., 'c' for /dev/sdX): " disk_letter; disk_letter="${disk_letter,,}"
		DISK="/dev/sd${disk_letter}"
		if [ ! -e "$DISK" ]; then
			echo "You didn't provide an existing disk letter."
			echo
			echo
		else
			round=1
			break
		fi
	done
		
	clear
	echo "Disk information for $DISK:"
	echo "----------------------------------"
	lsblk -o NAME,TYPE,SIZE,LABEL,MODEL $DISK
	#lsblk -o NAME,TYPE,SIZE,LABEL | grep -E "^(.*) (disk|part) (.*)$"
	
	echo
	echo
	read -p "Are you sure you want to format disk $DISK? Type 'y' to proceed: " confirm; confirm="${confirm,,}"
	if [ $confirm = "y" ]; then
		disk_type=$(lsblk -d -o ROTA -n "$DISK")
		break
	fi
done

read -p "Disk Label: " label

sudo fdisk "$DISK" <<EOF
g
n



w
EOF

if [[ $disk_type == "1" ]];then #hdd
	sudo mkfs.ext4 -F -c -L $label "${DISK}1"
elif [[ $disk_type == "0" ]];then #flash drives
	sudo mkfs.ext4 -F -L $label "${DISK}1"
fi