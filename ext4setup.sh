ext4setup() {
	#!/bin/bash

	# Disclaimer message
	echo "Warning: I am not responsible for any data loss if you choose the wrong disk!"
	echo "Please double-check the disk you are selecting before proceeding."

	echo -e "\n\n⚠️ WARNING: This will erase all data on that disk.⚠️\n\n"

	while true; do
		while true; do
			lsblk -o NAME,TYPE,SIZE,LABEL,MODEL | awk 'NR==1{print;next} $2=="disk" && NR>1{print "--------------------------------------------------"} $2=="disk" || $2=="part"{print}'
			echo "--------------------------------------------------"

			read -p "Enter disk (e.g., 'a-z' for /dev/sdX or '0,1,..' for /dev/nvmeXn1): " disk_letter; disk_letter="${disk_letter,,}"
            if [[ $disk_letter =~ ^[a-z]$ ]];then
			    DISK="/dev/sd${disk_letter}"
            else
                DISK="/dev/nvme${disk_letter}n1"
            fi
			if [ ! -e "$DISK" ]; then
                clear
				echo "Disk not found. Try again."
				echo
				echo
			else
				round=1
                if [[ $disk_letter =~ ^[0-9]$ ]];then
                    DISK="${DISK}p"
                fi
				break
			fi
		done
			
		clear
		echo "Disk information for $DISK:"
		echo "----------------------------------"
		lsblk -o NAME,TYPE,SIZE,LABEL,MODEL $DISK
		
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
}
export -f ext4setup
ext4setup
