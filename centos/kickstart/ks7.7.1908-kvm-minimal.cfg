#platform=x86, AMD64, or Intel EM64T

# @SEE https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-howto

# System authorization information
auth --enableshadow --passalgo=sha512

# Use CDROM installation media
cdrom
# Use network installation
#url --url="http://mirrors.aliyun.com/centos/7.4.1708/os/x86_64"
#Configures additional yum repositories that can be used as sources for package installation
repo --name=aliyun --baseurl="http://mirrors.aliyun.com/centos/7.4.1708/os/x86_64"

# Use graphical install
#graphical
# Use text mode install
text

# if have dhcp network
#vnc

unsupported_hardware

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
bootloader --append=" ipv6.disable=1 console=ttyS0,115200n8 rootflags=uquota,gquota serial crashkernel=auto" --location=mbr --boot-drive=vda
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

eula --agreed

%packages
@^minimal
#@graphical-server-environment
#@gnome-desktop-environment
-iwl*
-abrt*
-*firmware
linux-firmware

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%post

# Update
############################
#yum -y update
yum clean all

# Log Setting
############################
{ cat << EOF > /etc/cron.weekly/clean_log.cron
source /etc/profile
for f in /var/log/{*,**/**,**/**/**};do
  if [ -f \$f ];then true > \$f;fi
  rm -rf /var/log/{*-201*,**/*-201*,**/**/*-201*,**/*.log.*[0-9]}
done
EOF
}
/bin/sh /etc/cron.weekly/clean_log.cron

# SSH Setting
############################
sed -ri \
-e 's/(^AllowTcpForwarding) (.*)/\1 no/' -e 's/^.(AllowTcpForwarding) (.*)/\1 no/' \
-e 's/(^X11Forwarding) (.*)/\1 no/' -e 's/^.(X11Forwarding) (.*)/\1 no/' \
/etc/ssh/sshd_config

# Kernel Setting
############################
{ cat << EOF > /etc/sysctl.d/vm.conf
vm.swappiness = 0
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv4.ip_forward = 1
EOF
}

# Firewall Setting
############################
for z in $(firewall-cmd --get-zones) ; do
    for s in 'dhcpv6-client' 'samba-client' 'mdns' ; do
      if [ $(firewall-cmd --query-service=$s --permanent --zone=$z) == 'yes' ]; then
        firewall-cmd --remove-service=$s --permanent --zone=$z
      fi
    done
done

# Digest core file
############################
(find /{etc,usr/bin,usr/lib/firewalld,usr/lib/systemd,usr/sbin} -type f -exec md5sum {} \; |sort -k2 && rpm -Va |sort -k3 ) > /opt/sys-digest.$(date +%Y.%m.%d).txt

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
