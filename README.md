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
