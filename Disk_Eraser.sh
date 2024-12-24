#!/bin/bash

yes "" | head -n 20

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

ERROR_LIMIT=1
#ERROR_LIMIT=50
ERROR_COUNT=0

yes "" | head -n 9
echo "----------------------------------"

while read line; do
    echo "$line"
    if echo "$line" | grep -q "Input/output error"; then
        ERROR_COUNT=$((ERROR_COUNT + 1))
        echo "Error $ERROR_COUNT detected"
    fi
    if [ "$ERROR_COUNT" -ge "$ERROR_LIMIT" ]; then
        echo "Reached error limit ($ERROR_LIMIT). Stopping."
		break
    fi
done < <(sudo shred -v -n 1 $DISK 2>&1)


if ! [ "$ERROR_COUNT" -ge "$ERROR_LIMIT" ]; then
	sudo shred -v -n 2 $DISK
	yes "" | head -n 5
	echo "$ERROR_COUNT errors detected on your hard disk."
else
	#TIMEOUT=300
	#TIMEOUT=5
	for i in {1..3}; do
		echo "Pass $i: Overwriting with random data..."
		
		
		
		
		#sudo dd if=/dev/urandom of=$DISK bs=1M conv=noerror,sync status=progress &
		#--------------------------
		#sudo dd if=/dev/urandom of=$DISK bs=1M conv=noerror,sync status=progress &
		#watch -n 30 'sudo kill -USR1 $(pidof dd)'
		#while read line; do
			#LAST_PROGRESS_TIME=$(date +%s)
		#done & < <(sudo dd if=/dev/urandom of=$DISK bs=1M conv=noerror,sync status=progress)
		#done & < <(sudo dd if=/dev/urandom of=$DISK bs=1M conv=noerror,sync status=progress 2>&1)
		#sudo dd if=/dev/urandom of=$DISK bs=1M conv=noerror,sync status=progress
		#DD_PID=$!
		#DD_PID=$(pgrep -f 'sudo dd if.*of=$DISK')
		
		#while true; do
			#testing=$((testing + 1))
			#echo $testing
			#echo "$line test"
			
			#sleep 30

			#ELAPSED_TIME=$(( $(date +%s) - LAST_PROGRESS_TIME ))

			#if [ "$ELAPSED_TIME" -ge "$TIMEOUT" ]; then
				#echo "dd has not made progress in the last $TIMEOUT seconds. Killing the process."
				#sudo kill -9 $DD_PID
				#if [[ $DD_PID != "" ]]; then
					#sudo kill -9 $DD_PID
					#break
				#fi
			#fi
			#echo test
		#done
		
		
		
	#============================
	


		
		check_interval=10

		sudo dd if=/dev/urandom of=$disk bs=1M status=progress &
		dd_pid=$!

		last_progress=0
		elapsed_time=0

		while kill -0 $dd_pid 2>/dev/null; do
			current_progress=$(ps -p $dd_pid -o etimes=)

			if [ "$current_progress" == "$last_progress" ]; then
				((elapsed_time++))
				echo "No progress detected for $elapsed_time seconds."

				if [ $elapsed_time -ge $check_interval ]; then
					echo "No progress for $check_interval seconds, killing dd process."
					sudo kill $dd_pid
					wait $dd_pid
					exit 1
				fi
			else
				elapsed_time=0
			fi

			last_progress=$current_progress

			sleep 1
		done
		
		
	
	#--------------------------
	
	
	
	done
	
	echo
	echo
	echo "----------------------------------"
	echo "WARNING: There were many disk errors. The errors on the disk have not been overwritten. It's better to destroy it, even physically."
fi
