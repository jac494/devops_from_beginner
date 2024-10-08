# Devops Beginner to Advanced With Projects

## Setup

[prereqs](https://github.com/devopshydclub/vprofile-project/blob/prereqs/Prereqs_doc.md)

### Signups

* `[x]` [Github - jac494](https://github.com/jac494)
* `[x]` [AWS - jac494](https://aws.amazon.com)
* `[x]` [domain - blinkingboxes.net](https://blinkingboxes.net)
* `[x]` [docker hub - u/jac494](https://hub.docker.com/u/jac494)
* `[ ]` [sonarcloud](https://www.sonarsource.com/products/sonarcloud/) ??

Sonarcloud wouldn't let me authorize my account. Idk. we'll see what happens with that and where it is needed later in the course. I'd imagine we might set it up as part of our jenkins pipeline to have sonarcloud scan our code before deployment

### AWS Setup

cloudwatch - AWS monitoring service
ACM - AWS Certificate Manager

## 3. VM Setup

### Vagrant

* create and manage VMs

Example of some vagrant commands:

```sh
mkdir vagrant-vm && cd vagrant-vm
# example vagrant cloud page for ubuntu:
# https://app.vagrantup.com/ubuntu/boxes/trusty64
vagrant init ubuntu/trusty64  # creates Vagrantfile
vagrant up                    # bring up vm (power on)
vagrant status                # check status of vm
vagrant box list              # list available boxes
vagrant ssh                   # log in to the vm
vagrant halt                  # power off vm
vagrant up
vagrant reload                # reboot vm
vagrant destroy               # delete vm
vagrant box list
vagrant global-status         # check status of all VMs
```

[Sample output notes](vagrant_output_notes_20240804.md)

## 4. Linux

So far it is very beginner. This is fine but I'm just watching through. I'll take some notes here if anything stands out.

### Introduction to Linux

#### Some Important Directories

One thing I've never known is the difference between the `bin` directories and `sbin` directories...

| type | paths | notes |
| ---- | ----- | ----- |
| Home directories | `/root`, `/home/<user>` | |
| user executable | `/bin`, `/usr/bin`, `/usr/local/bin` | |
| system executables | `/sbin`, `/usr/sbin`, `/usr/local/sbin` | things like `rpm` or `dpkg`, `useradd`, etc |
| other mountpoints | `/media`, `/mnt` | |
| configuration | `/etc` | |
| temporary files | `/tmp` | |
| kernels and bootloader | `/boot` | |
| server data | `/var`, `/srv` | |
| system information | `/proc`, `/sys` | |
| shared libraries | `/lib`, `/usr/lib`, `/usr/local/lib` | |

### Commands And Filesystems

#### `/etc/os-release`

```sh
$ cat /etc/os-release
NAME="Fedora Linux"
VERSION="37 (Workstation Edition)"
ID=fedora
VERSION_ID=37
VERSION_CODENAME=""
PLATFORM_ID="platform:f37"
PRETTY_NAME="Fedora Linux 37 (Workstation Edition)"
ANSI_COLOR="0;38;2;60;110;180"
LOGO=fedora-logo-icon
CPE_NAME="cpe:/o:fedoraproject:fedora:37"
DEFAULT_HOSTNAME="fedora"
HOME_URL="https://fedoraproject.org/"
DOCUMENTATION_URL="https://docs.fedoraproject.org/en-US/fedora/f37/system-administrators-guide/"
SUPPORT_URL="https://ask.fedoraproject.org/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_BUGZILLA_PRODUCT="Fedora"
REDHAT_BUGZILLA_PRODUCT_VERSION=37
REDHAT_SUPPORT_PRODUCT="Fedora"
REDHAT_SUPPORT_PRODUCT_VERSION=37
SUPPORT_END=2023-12-05
VARIANT="Workstation Edition"
VARIANT_ID=workstation
```

#### `uptime`

```sh
$ uptime
 16:19:55 up 294 days,  8:33,  1 user,  load average: 0.00, 0.02, 0.04

$ cat /proc/uptime
25432421.82 28797035.45
```

### File Types

| file type | first character in file listing | description | notes |
| --------- | ------------------------------- | ----------- | ----- |
| regular file | `-` | normal files such as text, data, or executable files | create with `touch` among others |
| directory | `d` | files that are lists of other files | create with `mkdir` |
| link | `l` | a shortcut that points to the location of the actual file | create with `ln`; `ln -s <dest> <link name>`; remove with `rm` or `unlink` |
| special file | `c` | mechanism used for input and output, such as files in `/dev` | |
| socket | `s` | a special file that provides inter-process networking protexted by the system's access control | |
| pipe | `p` | a psecial file that allows processes to communicate with each other without using network socket semantics | |

### IO Redirection

random sidenote, I always forget about `free`

```txt
$ free -hm
               total        used        free      shared  buff/cache   available
Mem:            15Gi       781Mi        13Gi       344Mi       1.7Gi        14Gi
Swap:          2.0Gi          0B       2.0Gi
```

most basic redirection, redirect stdout with right angle bracket: `>`

the most basic fds:

* 1: stdout
* 2: stderr

include error output to the redirect with ampersand...

Example file to write to both stdout and stderr:

```txt
$ cat stdout_stderr.sh
#!/usr/bin/env sh

echo "This is some output that should go to STDOUT";
>&2 echo "This is some output that should go to STDERR";
```

No redirection, all output of both stdout and stderr seen:

```txt
$ ./stdout_stderr.sh 
This is some output that should go to STDOUT
This is some output that should go to STDERR
```

Redirect only stdout, stderr still goes to terminal:

```txt
 $ ./stdout_stderr.sh > /dev/null
This is some output that should go to STDERR
```

Redirect only stderr, stdout still goes to terminal:

```txt
 $ ./stdout_stderr.sh 2> /dev/null 
This is some output that should go to STDOUT
```

Redirect both, no output goes to terminal:

```txt
 $ ./stdout_stderr.sh &> /dev/null
 <no output to show>
```

### Users & Groups

Types of users

| Type | Example | UID | GID | Home Dir | Shell |
| ---- | ------- | --- | --- | -------- | ----- |
| ROOT | root | 0 | 0 | `/root` | `/bin/bash` |
| Regular | jac494, vagrant | 1000-60000 | 1000-60000 | `/home/<username>` | `/bin/bash` |
| Service | ftp, ssh, apache | 1-999 | 1-999 | `/var/ftp`, etc (or none) | `/sbin/nologin` |

```txt
$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
chrony:x:994:992:chrony system user:/var/lib/chrony:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/usr/share/empty.sshd:/sbin/nologin
jac494:x:2010:2010:Drew Conner:/home/jac494:/usr/bin/zsh
dhcpcd:x:970:970:Minimalistic DHCP client:/var/lib/dhcpcd:/usr/sbin/nologin
```

User passwords are stored encrypted in `/etc/shadow`

Commands:

`useradd`, `usermod`, `groupadd`, `userdel`, `groupdel`, `passwd`, `su - <username>`

### File Permissions

```txt
$ ls -alh | grep "\.sh"
-rwxr-xr-x. 1 jac494 jac494  129 Aug  6 20:14 stdout_stderr.sh
-                            -file type, '-' = regular file
 rwx                         -user bits (read, write, execute)
    r-x                      -group bits (read, execute)
       r-x                   -Other/'world' bits (read, execute)
          .                  -?
            1                -?
              jac494         -user owner for the file
                     jac494  -group owner for the file
```

In the output above, I am curious about the period and the integer there, it's '1' a lot but sometimes not and idk what it means.

for a directory, `x`/execute permissions mean that you can change into that directory (`cd`); `r`/read means that you can read the listing of contents in the directory (`ls`); `w`/write means you can edit the directory (add and remove files) or delete the directory

for a link, the permissions are for the link, not for the actual file that it links to

### Sudo

* `/etc/sudoers`
* edit with `visudo`
* place additional custom files in `/etc/sudoers.d/` directory

```txt
## Some sudoers syntax
## Allow root to run any commands anywhere 
root    ALL=(ALL)       ALL
## Allow user (suser) to run commands with sudo, prompt for password
suser   ALL=(ALL)       ALL
## Allow user (nopuser) to run commands with sudo and do not
## prompt for password
nopuser ALL=(ALL)       NOPASSWD: ALL
## group devops group has sudo access
%devops ALL=(ALL)       NOPASSWD: ALL
```

### Package Management

* `rpm -qa`: list all packages installed on an rpm based system
* `dpkg -l`: list all packages installed on a debian based system
* `/etc/yum.repos.d`: directory for yum repos files
* `/etc/apt/sources.list`, `/etc/apt/sources.list.d/` for apt repos files

```txt
$ rpm -qa | head -5
gpg-pubkey-5323552a-6112bcdc
code-1.74.2-1671533504.el7.x86_64
gpg-pubkey-621e9f35-58ade481
docker-scan-plugin-0.23.0-3.fc37.x86_64
$ rpm -qa | wc -l
3209
```

```txt
$ dpkg -l | head -10
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                                       Version                                           Architecture Description
+++-==========================================-=================================================-============-================================================================================
ii  accountsservice                            22.07.5-2ubuntu1.5                                amd64        query and manipulate user account information
ii  acl                                        2.3.1-1                                           amd64        access control list - utilities
ii  acpi-support                               0.144                                             amd64        scripts for handling many ACPI events
ii  acpid                                      1:2.0.33-1ubuntu1                                 amd64        Advanced Configuration and Power Interface event daemon
ii  adduser                                    3.118ubuntu5                                      all          add and remove users and groups
$ dpkg -l | wc -l
1826
```

```txt
$ ls -1 /etc/yum.repos.d  
fedora.repo
fedora-updates.repo
fedora-updates-testing.repo
```

```txt
$ cat /etc/yum.repos.d/fedora.repo
[fedora]
name=Fedora $releasever - $basearch
#baseurl=http://download.example/pub/fedora/linux/releases/$releasever/Everything/$basearch/os/
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
enabled=1
countme=1
metadata_expire=7d
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False
```

```txt
$ cat /etc/apt/sources.list
#deb cdrom:[Ubuntu 22.04.3 LTS _Jammy Jellyfish_ - Release amd64 (20230807.2)]/ jammy main restricted

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://us.archive.ubuntu.com/ubuntu/ jammy main restricted
# deb-src http://us.archive.ubuntu.com/ubuntu/ jammy main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://us.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
# deb-src http://us.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
```

### Services

...video is basically a run through of `systemctl` basics; there's a whole set of man pages for that:

```txt
$ apropos systemd | grep "^systemd" | wc -l
253

$ apropos systemd | grep "^systemd" | head -10
systemd (1)          - systemd system and service manager
systemd-ac-power (1) - Report whether we are connected to an external power source
systemd-analyze (1)  - Analyze and debug system manager
systemd-ask-password (1) - Query the user for a system password
systemd-ask-password-console.path (8) - Query the user for system passwords on the console and v...
systemd-ask-password-console.service (8) - Query the user for system passwords on the console an...
systemd-ask-password-wall.path (8) - Query the user for system passwords on the console and via ...
systemd-ask-password-wall.service (8) - Query the user for system passwords on the console and v...
systemd-backlight (8) - Load and save the display backlight brightness at boot and shutdown
systemd-backlight@.service (8) - Load and save the display backlight brightness at boot and shut

$ apropos systemd | grep "^systemd" | grep -v "\.service" | wc -l
158

$ apropos systemd | grep "^systemd\."                                 
systemd.automount (5) - Automount unit configuration
systemd.device (5)   - Device unit configuration
systemd.directives (7) - Index of configuration directives
systemd.dnssd (5)    - DNS-SD configuration
systemd.environment-generator (7) - systemd environment file generators
systemd.exec (5)     - Execution environment configuration
systemd.generator (7) - systemd unit generators
systemd.image-policy (7) - Disk Image Dissection Policy
systemd.index (7)    - List all manpages from the systemd project
systemd.journal-fields (7) - Special journal fields
systemd.kill (5)     - Process killing procedure configuration
systemd.link (5)     - Network device configuration
systemd.mount (5)    - Mount unit configuration
systemd.negative (5) - DNSSEC trust anchor configuration files
systemd.net-naming-scheme (7) - Network device naming schemes
systemd.netdev (5)   - Virtual Network Device configuration
systemd.network (5)  - Network configuration
systemd.nspawn (5)   - Container settings
systemd.offline-updates (7) - Implementation of offline updates in systemd
systemd.path (5)     - Path unit configuration
systemd.pcrlock (5)  - PCR measurement prediction files
systemd.pcrlock.d (5) - PCR measurement prediction files
systemd.positive (5) - DNSSEC trust anchor configuration files
systemd.preset (5)   - Service enablement presets
systemd.resource-control (5) - Resource control unit settings
systemd.scope (5)    - Scope unit configuration
systemd.service (5)  - Service unit configuration
systemd.slice (5)    - Slice unit configuration
systemd.socket (5)   - Socket unit configuration
systemd.special (7)  - Special systemd units
systemd.swap (5)     - Swap unit configuration
systemd.syntax (7)   - General syntax of systemd configuration files
systemd.system-credentials (7) - System Credentials
systemd.target (5)   - Target unit configuration
systemd.time (7)     - Time and date specifications
systemd.timer (5)    - Timer unit configuration
systemd.unit (5)     - Unit configuration
```

I did learn one new thing - check for enabled status with `is-enabled` subcommand:

```txt
$ systemctl is-enabled sshd
enabled
```

### Processes

```txt
$ top -n 1
top - 17:09:22 up 1 day, 21:54,  2 users,  load average: 0.36, 0.17, 0.13
Tasks: 214 total,   1 running, 213 sleeping,   0 stopped,   0 zombie
%Cpu(s):  1.4 us,  2.9 sy,  0.0 ni, 95.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :  15864.2 total,   7340.4 free,   3786.1 used,   4737.8 buff/cache
MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.  10973.3 avail Mem

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
  38623 jac494    20   0   13224   4096   3328 R  12.5   0.0   0:00.02 top
      1 root      20   0  168168  13056   8192 S   0.0   0.1   0:04.64 systemd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.01 kthreadd
      3 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_gp
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_par_gp
      5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 slub_flushwq
      6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 netns
      8 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/0:0H-events_highpri
     11 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 mm_percpu_wq
```

* **load average**: measure of cpu wait time (1m,5m,15m in `top`)
* **zombie**: process is done but entry is still in the process table
* **orphan**: a child process whose parent process has been terminated but the child still exists

processes below in square brackets are kernel threads

```txt
$ ps aux | head -5
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.1  64468 26844 ?        Ss   Aug06   0:09 /usr/lib/systemd/systemd --switched-root --system --deserialize=41 rhgb
root           2  0.0  0.0      0     0 ?        S    Aug06   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        S    Aug06   0:00 [pool_workqueue_release]
root           4  0.0  0.0      0     0 ?        I<   Aug06   0:00 [kworker/R-rcu_gp]

$ ps aux | grep -v " \[" | head -5
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.1  64468 26844 ?        Ss   Aug06   0:09 /usr/lib/systemd/systemd --switched-root --system --deserialize=41 rhgb
root        7720  0.0  0.1 139964 28824 ?        Ss   Aug06   0:25 /usr/lib/systemd/systemd-journald
root        7752  0.0  0.0  16200  6356 ?        Ss   Aug06   0:01 /usr/lib/systemd/systemd-userdbd
root        7780  0.0  0.0  36932 12976 ?        Ss   Aug06   0:00 /usr/lib/systemd/systemd-udevd

$ ps -ef | grep -v " \[" | head -5 
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 Aug06 ?        00:00:09 /usr/lib/systemd/systemd --switched-root --system --deserialize=41 rhgb
root        7720       1  0 Aug06 ?        00:00:25 /usr/lib/systemd/systemd-journald
root        7752       1  0 Aug06 ?        00:00:01 /usr/lib/systemd/systemd-userdbd
root        7780       1  0 Aug06 ?        00:00:00 /usr/lib/systemd/systemd-udevd
```

just playing around with awk and grep, printing ppid, pid, and name of all processes that are direct children of pid 1

```txt
$ ps -ef | grep -v " \[" | awk '{print $3" "$2" "$8}' | grep "^1 "
1 7720 /usr/lib/systemd/systemd-journald
1 7752 /usr/lib/systemd/systemd-userdbd
1 7780 /usr/lib/systemd/systemd-udevd
1 7956 /usr/lib/systemd/systemd-oomd
1 7957 /usr/lib/systemd/systemd-resolved
1 7990 /usr/sbin/auditd
1 8002 /usr/bin/dbus-broker-launch
1 8016 /usr/libexec/bluetooth/bluetoothd
1 8020 /usr/libexec/low-memory-monitor
1 8021 /usr/sbin/mcelog
1 8022 /usr/lib/polkit-1/polkitd
1 8023 /usr/libexec/power-profiles-daemon
1 8026 /usr/libexec/rtkit-daemon
1 125422 sh
...
```

#### `kill`

* by default asks that process clean up children then terminate
* `-9` forces process closure, does not allow for cleaning up children

### Archiving

* `tar -czvf  <archive name>.tar.gz path_to_create_archive_from`
  * **c**: create
* `tar -xzvf <tarfile>`
  * **x**: extract
* **z**: filter through gzip = compress
* **v**: verbose
* **f**: file

## 5. Vagrant & Linux Servers

[Vagrant Docs](https://developer.hashicorp.com/vagrant/docs)

* Created centos and ubuntu machines
* interesting note - vagrant config is ruby

```txt
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ubuntu/trusty64'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'ubuntu/trusty64' version '20191107.0.0' is up to date...
==> default: Setting the name of the VM: ubuntu_default_1723299247442_81515
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
    default: Adapter 2: hostonly
    default: Adapter 3: bridged
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection reset. Retrying...
    default: Warning: Connection aborted. Retrying...
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Configuring and enabling network interfaces...
==> default: Mounting shared folders...
    default: /vagrant => C:/Users/jac49/vagrant_vms/ubuntu

$ vagrant status
Current machine states:

default                   running (virtualbox)

The VM is running. To stop this VM, ...

$ vagrant global-status
id       name    provider   state   directory
------------------------------------------------------------------------
c835c47  default virtualbox running C:/Users/jac49/vagrant_vms/ubuntu

The above shows information about all known Vagrant environments
on this machine. This data is cached and may not be completely
up-to-date (use "vagrant global-status --prune" to prune invalid
entries). To interact with any of the machines, you can go to that
directory and run Vagrant, or you can use the ID directly with
Vagrant commands from any directory. For example:
"vagrant destroy 1a2b3c4d"
```

### Sync Directories

Files are synced by default between the vagrant directory on the host and `/vagrant` on the guest VM

Only the Vagrantfile, no other files currently

```txt
$ ls


    Directory: C:\Users\jac49\vagrant_vms\ubuntu


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         8/10/2024   8:44 AM                .vagrant
-a----         8/10/2024   9:00 AM           3515 Vagrantfile


$ vagrant ssh
Welcome to Ubuntu 14.04.6 LTS (GNU/Linux 3.13.0-170-generic x86_64)

vagrant@vagrant-ubuntu-trusty-64:~$ ls /vagrant
Vagrantfile
vagrant@vagrant-ubuntu-trusty-64:~$ exit
logout
Connection to 127.0.0.1 closed.
```

Creating "test1.txt" on the host

```txt
$ ls


    Directory: C:\Users\jac49\vagrant_vms\ubuntu


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         8/10/2024   8:44 AM                .vagrant
-a----         8/10/2024   9:00 AM           3515 Vagrantfile

$ New-Item -ItemType File -Name "test1.txt"


    Directory: C:\Users\jac49\vagrant_vms\ubuntu


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         8/10/2024   9:20 AM              0 test1.txt


$ vagrant ssh
Welcome to Ubuntu 14.04.6 LTS (GNU/Linux 3.13.0-170-generic x86_64)

vagrant@vagrant-ubuntu-trusty-64:~$ ls /vagrant
test1.txt  Vagrantfile
vagrant@vagrant-ubuntu-trusty-64:~$
```

Create some files in the guest vm...

```txt
vagrant@vagrant-ubuntu-trusty-64:~$ touch /vagrant/test{2..4}.txt
vagrant@vagrant-ubuntu-trusty-64:~$ ls /vagrant
test1.txt  test2.txt  test3.txt  test4.txt  Vagrantfile
vagrant@vagrant-ubuntu-trusty-64:~$ exit
logout
Connection to 127.0.0.1 closed.
$ ls


    Directory: C:\Users\jac49\vagrant_vms\ubuntu


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         8/10/2024   8:44 AM                .vagrant
-a----         8/10/2024   9:20 AM              0 test1.txt
-a----         8/10/2024   9:24 AM              0 test2.txt
-a----         8/10/2024   9:24 AM              0 test3.txt
-a----         8/10/2024   9:24 AM              0 test4.txt
-a----         8/10/2024   9:00 AM           3515 Vagrantfile
```

Add a path from host ot guest:

```rb
config.vm.synced_folder "host_path", "guest_path"
```

```rb
config.vm.synced_folder "..\\sync_dir", "/vagrant_sync_dir"
```

```txt
$ ls ..


    Directory: C:\Users\jac49\vagrant_vms


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         8/10/2024   8:13 AM                centos
d-----         8/10/2024  11:30 AM                sync_dir
d-----         8/10/2024  11:31 AM                ubuntu
-a----         8/10/2024   8:42 AM             10 .gitignore

$ ls / | grep vagr
vagrant
vagrant_sync_dir
```

### [Multi-Machine](https://developer.hashicorp.com/vagrant/docs/multi-machine)

```rb
Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: "echo Hello"

  config.vm.define "web" do |web|
    web.vm.box = "apache"
  end

  config.vm.define "db" do |db|
    db.vm.box = "mysql"
  end
end
```

## 6. Variables, JSON, & YAML

Nothing really interesting or suprising here;

* [JSON Syntax - Wikipedia](https://en.wikipedia.org/wiki/JSON#Syntax)
* [YAML.org](https://yaml.org/)
* [Python Data Model - Objects, Values, and Types](https://docs.python.org/3/reference/datamodel.html#objects-values-and-types)

## 7. VProfile Project Setup Manual & Automated

## 8. Networking

## 9. Introducing Containers

## 10. Bash Scripting

## 11. AWS Part 1

## 12. AWS Cloud For Project Set Up | Lift & Shift

## 13. Re-Architecting Web App on AWS Cloud (PaaS & SaaS)

## 14. git

## 15. Maven

## 16. Continuous Integration With Jenkins

## 17. Python

## 18. Ansible

## 19. AWS Part 2

## 20. AWS CI/CD Project

## 21. Docker

## 22. Containerization

## 23. Kubernetes

## 24. App Deployment on Kubernetes Cluster

## 25. Terraform Tutorial

## 26. GitOps Project

## 27. CI/CD for Docker, Kubernetes Using Jenkins

## 28. Cloud Formation Tutorial

## 29. Conclusion
