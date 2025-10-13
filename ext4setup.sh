#!/bin/bash
ext4setup() {
	error() {
		echo -e "\e[1;91m$1\e[0m"
	}
	label_check(){

		while true; do

			read -p "Disk Label: " label

			if [[ "$label" =~ ^("root"|"home"|"swap"|"boot") || ! "$label" =~ ^[A-Za-z0-9_-]{1,16}$ ]];then
				clear
				error "$label: is not allowed! \nAllowed: 1–16 letters, numbers, - or _ (no spaces or special characters)\nnot allowed names: root home swap boot\n\n"
			else
				return
			fi
		done
	}

    clear

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

	clear
	label_check
    
    partitions=$(ls ${DISK}* | grep -E "^${DISK}[0-9]$" | wc -l)
    
    for ((i=1; i<=partitions; i++)); do
        printf "d\n$i\n" | fdisk "$DISK"
    done
    echo -e "g\nn\n\n\n\nw" | fdisk "$DISK"
    
    if [[ $disk_letter =~ ^[0-9]$ ]];then
        DISK="${DISK}p"
    fi

	if [[ $disk_type == "1" ]];then #hdd
		sudo mkfs.ext4 -F -c -L $label "${DISK}1"
	elif [[ $disk_type == "0" ]];then #flash drives
		sudo mkfs.ext4 -F -L $label "${DISK}1"
	fi
}
export -f ext4setup
ext4setup
