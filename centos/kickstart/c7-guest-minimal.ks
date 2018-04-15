#platform=x86, AMD64, or Intel EM64T

# @SEE https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-howto

# System authorization information
auth --enableshadow --passalgo=sha512

# Use CDROM installation media
cdrom
# Use network installation
#url --url="http://mirrors.aliyun.com/centos/7.4.1708/os/x86_64"

# Use graphical install
#graphical
# Use text mode install
text

# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=vda

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --noipv6 --activate --onboot=yes
network  --hostname=template

# Root password
rootpw --iscrypted $6$jo2ubBLAUcdPmGA8$ZscAGk1o5TRVWsKL4fZIMh8mYSZHuVlPEs4JbvnXpBoz2A8eaj.94BbMyP8yVBPQhYyMnB6fJ8uLOHpBMW9JB.
# System services
services --disabled="chronyd"

# System timezone
timezone Asia/Shanghai --isUtc --nontp

# System bootloader configuration
zerombr
bootloader --append=" console=ttyS0,115200n8 crashkernel=auto" --location=mbr --boot-drive=vda
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot --fstype="xfs" --ondisk=vda --size=256
part pv.01 --fstype="lvmpv" --ondisk=vda --size=1 --grow
volgroup sys --pesize=4096 pv.01
logvol swap --fstype="swap" --size=8192 --name=swap --vgname=sys
logvol /  --fstype="xfs" --size=1 --grow --name=root --vgname=sys

# Do not configure the X Window System
skipx

# Reboot after installtion
reboot

%packages
@minimal
@graphical-server-environment
#@gnome-desktop-environment

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
