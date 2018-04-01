# text mode (no graphical mode)
text

# do not configure X
skipx

# install
install

# installation url
url --url=https://mirrors.aliyun.com/centos/7.4.1708/os/x86_64/

# Language support
lang en_US

# Keyboard
keyboard us

# Network
network --device eth0 --bootproto static --ip 172.16.1.2 --netmask 255.255.0.0 --gateway 172.16.10.1 --nameserver 8.8.8.8 --noipv6 --hostname centos7

# auth config
auth --useshadow --enablemd5

# root password
rootpw --iscrypted CHANGEME

# SElinux
#selinux --disabled

# timezone
timezone  Asia/Shanghai

# bootloader
bootloader --location=mbr

# clear the MBR (Master Boot Record)
zerombr

# the Setup Agent is not started the first time the system boots
firstboot --disable

# Reboot after installation
reboot

# Logging lever
logging --level=info

# Remove all partitions
clearpart --all --initlabel

# create partitions on the system
part / --asprimary --fstype="xfs" --grow --size=1
part swap --recommended

# Packages installation
%packages
@core
wget
net-tools
--nobase
%end

%post
mkdir -p /root/.ssh
echo "MY_PUBLIC_SSH_KEY" > /root/.ssh/authorized_keys
%end
