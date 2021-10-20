echo "VMware1!" | sudo -S ls
sudo -i -u root bash << EOF
echo "Starting scan"
echo 1>/sys/class/block/sda/device/rescan
EOF
echo "Scan completed"
echo "VMware1!" | sudo -S ls
op=$(df / --output=source)
lv=""
for word in $op
do
	lv=$word
done
echo "______"
echo $lv
echo "______"

pv=$(sudo pvs --noheadings -o pv_name)
nu=`echo $pv`
nu=$(echo $nu | fold -w 1)
num=""
for p in $nu
do
	num=`echo $p`
done
int=$(($num - 0))
echo "------------------"
echo $nu
echo "------------------"
sudo growpart /dev/sda $int
sudo resize2fs $pv
sudo pvresize $pv
sudo lvresize -l +100%FREE $lv
sudo resize2fs $lv
sudo fdisk -l

#sudo lvresize -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
#sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
