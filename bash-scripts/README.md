# cpu utilization high
ps -ef PID
top
htop ## for cpu high
iotop = proc waiting on disk

## large or deleted files
du -h # file system full 
du -sh /* | sort -h # find large dir
find / -type f -size +500M # large files

## server load high
uptime or top

## zombie proc = proc finished but parent hasn't read its exit status
ps -ef | grep top 
ps -ef | grep Z
if parent init(PID 1) it auto clean

## proc hung, with strace
strace -p PID
lsof -p PID ## to check open files and connection

## proc killed by OOM
dmesg | grep -i "killed process" ## it shows pid name and mem usage of terminated proc
then verify /var/log/messages or /var/log/syslog

# clear fs cache safe
free -m

## clean old log safe
find /var/log -type f -mtime+30 -delete

## ping ip works, hostname fail
/etc/resolv.conf ## for correct NS
and test with
nslookup hostname or dig hostname

# find proc using port
sudo netstat -tulnp | grep 8080

## ssh connection refused 
sudo ss -tlnp | grep 22
systemctl status sshd
restart service or fix sshd_config

## app cant reach db on port 3306
from app server - telnet db-host 3306
ss -tlnp | grep 3306

## ping = test reachability
traceroute = shows each hop path
mtr = combines ping + traceroute continuosly to show latency packet loss

## destination host unreachable
ip route  ## default gw or subnet route
ip link show ## interface status

## user cant login
passwd -S user ## account is locked
passwd -u user ## to unlock
/etc/passwd ## check shell access
/etc/ssh/sshd_config for allow user restriction and logs
/var/log/secure or /var/log/auth.log

## create user - useradd user
lock acc - passwd -l user
unlock - passwd -u user

## diff betw /etc/passwd & /etc/shadow
/etc/passwd stores usr info(username, uid gid, shell)
/etc/shadow - encrypted passwd & passwd ageing only root can read for security reaseon

## add user to multigroup
usermod -aG group1, group2

## permission denied for file access
ls -l # for ownership of file
chown user:group file 
chmod u+r file
for dir ensure exec permission(x)

# restrict ssh to certain user or group
edit /ect/ssh/sshd_config
AllowUser admin devops
AllowGroups sysadmin
systemctl restart sshd

## restart - stop & start svc
reload - apply config changes without stop
daemon-reload - reload systemd manager configs after edit .serveice file

## logs in real time
tail -f /var/log/messages

# filter logs by keyword or time
grep "erro" /var/log/messages

## rotate logs manually
compress and rename log
mv /var/log/app.log /var/log/app.log1
systemctl restart
gzip /var/log/app.log1

## untar file
tar -xzvf backup.tar.gz
tar -czvf backup.tar.gz /data
zip -r archive.zip /data

## copy folder excluding pattern
rsync -av --exclude='*.log' /source/ /destination/

## sync dir betw servers
rsync -avz /data/ user@remote:/backup/ (-afor archive, v=verbose, -z=compression)

## auto backup daily wiht cron
crontab -e
0 2 * * * rsync -az /data/ /backup/ >> /var/log/backup.log 2>&1

## delete files older than 30 days
find /backup -type f -mtime +30 -delete

## find recently modified files
find /var/log -type f -mtime 1

## compare rsync or scp
rsync - faster, support resume, compress, syncs only changes
scp = cp everything fresh each time no resume
prefer rsync for large or repititive transfer

## view cpu mem disk nic info
lscpu or cat /proc/cpuinfo ## cpu
free -h or cat /proc/meminfo - memory
lsblk - disk
ip addr show - network

## check system uptime & last boot
uptime

## logs stopped updating
df -h
logrotate # for log rotation

## monitor disk usage & alert at 80%
df -h | awk '{if ($5+0 > 80) print $0;}'
df -h | awk '{if($5+0 > 80) print$0;}' mail -s "Disk Alert" > email

## hard & sym link
ln file1 file2 ## hard link
ln -s file1 file2 # symlink

# proc vs thread vs job
ps -ef = for proc
top -H = threads
jobs = shell jobs

## purpose of /proc & /sys
/proc = virtual fs exposing kernel and proc info 
/proc/cpuinfo, /proc/meminfo
/sys = interface for device & kernel config 
/sys/class/net/eth0 = used for tuning & monitoring sys params

## >/dev/null2>&1 in cron
redirect all output ot nowhere
> redirect stdout
2>&1 redirects stderr to same place
so means ignore both output & errors
used to suppress unwanted cron logs

ps aux = show all proc
ip route - routing table
ip route show
du -sh * = folder size
fdisk -l = partition info
ps -el | grep Z = zombie process
df -h | grep /v tmpfs
du -sh /var/log/* ## disk full
iostat = io wait
ls -i  ## inode store file metadata
df -i 
