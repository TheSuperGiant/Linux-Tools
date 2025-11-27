# Linux-Tools
I will add some Linux tools here. They are small scripts for tasks you occasionally need and are easy to use.

# ext4setup
This will remove all partitions (if any) on the disk and format the whole disk with one partition (partition 1) using **ext4**.

It asks:
- Enter the disk letter or NVMe number (for example, type b for /dev/sdb or 0 for /dev/nvme0n1)
- Confirm if this is the correct disk (`y` for yes)
- Enter a label name for the disk

The rest runs automatically.

#### ⚠️ Warning:
This will overwrite all data on the selected disk. I am not responsible for any data loss if you choose the wrong disk!  
Please double-check the disk you are selecting before proceeding.
#### Execution
To run this script, use the following command in your terminal:
```bash
source <(curl -L https://raw.githubusercontent.com/TheSuperGiant/linux-tools/refs/heads/main/ext4setup.sh)
```
ext4setup is now available in this terminal session:
```bash
ext4setup
```

# Disk Eraser (Removed for now)
This tool erases a disk multiple times, making it nearly impossible for anyone to recover the data.
It will list all available disks (e.g., /dev/sda, /dev/sdb, /dev/sdc).
If you want to erase the disk labeled "sdc", simply type "c".
After that, there will be an additional confirmation step. If you have selected the correct disk, type "y" to proceed.
#### Warning:
I am not responsible for any data loss if you choose the wrong disk!    
Please double-check the disk you are selecting before proceeding.
#### Exection
To run this script directly from the internet, you can use the following command in your terminal:    
```bash
bash <(curl -L https://raw.githubusercontent.com/TheSuperGiant/Linux-Tools/refs/heads/Arch/Disk_Eraser.sh)
```
For example, live CDs like Ubuntu or Puppy OS.
```bash
bash <(wget -qO- https://raw.githubusercontent.com/TheSuperGiant/Linux-Tools/refs/heads/Arch/Disk_Eraser.sh)
```
#### bugs 

# Request for Solution: Hanging `dd` Process

## Issue
The `dd` command hangs and becomes unresponsive during execution without completing the task.

## Request
If you have encountered and solved this issue, please share any solutions or workarounds for resolving the hanging `dd` process.

## Requirements
- Solution should specifically address resolving the hang or freeze issue with `dd`.
- Please provide any relevant steps, commands, or tips that worked for you.

Thank you for your help!
