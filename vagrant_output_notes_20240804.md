# Vagrant Output Notes 20240804

Sample output

```txt
[  2:24PM ]  [ jac494@hp-laptop:~/Projects/devops_from_beginner(main✔) ]
 $ cd ~/
[  2:29PM ]  [ jac494@hp-laptop:~ ]
 $ mkch vagrant-vms
[  2:29PM ]  [ jac494@hp-laptop:~/vagrant-vms ]
 $ mkch ubuntu-trusty64
[  2:29PM ]  [ jac494@hp-laptop:~/vagrant-vms/ubuntu-trusty64 ]
 $ vagrant init ubuntu/trusty64
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
[  2:29PM ]  [ jac494@hp-laptop:~/vagrant-vms/ubuntu-trusty64 ]
 $ vagrant up
Bringing machine 'default' up with 'libvirt' provider...
==> default: Box 'ubuntu/trusty64' could not be found. Attempting to find and install...
    default: Box Provider: libvirt
    default: Box Version: >= 0
==> default: Loading metadata for box 'ubuntu/trusty64'
    default: URL: https://vagrantcloud.com/ubuntu/trusty64
The box you're attempting to add doesn't support the provider
you requested. Please find an alternate box or use an alternate
provider. Double-check your requested provider to verify you didn't
simply misspell it.

If you're adding a box from HashiCorp's Vagrant Cloud, make sure the box is
released.

Name: ubuntu/trusty64
Address: https://vagrantcloud.com/ubuntu/trusty64
Requested provider: [:libvirt]
```

Missing libvirt...

```txt
[  2:30PM ]  [ jac494@hp-laptop:~/vagrant-vms/ubuntu-trusty64 ]
 $ sudo dnf search libvirt
[sudo] password for jac494: 
Last metadata expiration check: 2:20:44 ago on Sun 04 Aug 2024 12:10:03 PM CDT.
===================================== Name Exactly Matched: libvirt ======================================
libvirt.x86_64 : Library providing a simple virtualization API
==================================== Name & Summary Matched: libvirt =====================================
ansible-collection-community-libvirt.noarch : Manages virtual machines supported by libvirt
buildbot-master-libvirt.noarch : Build/test automation system master -- libvirt support
fence-virtd-libvirt.x86_64 : Libvirt backend for fence-virtd
libvirt-cim.i686 : A CIM provider for libvirt
...
[  2:30PM ]  [ jac494@hp-laptop:~/vagrant-vms/ubuntu-trusty64 ]
 $ sudo dnf install libvirt
Copr repo for PyCharm owned by phracek                                    405  B/s | 341  B     00:00    
Errors during downloading metadata for repository 'phracek-PyCharm':
  - Status code: 404 for https://copr-be.cloud.fedoraproject.org/results/phracek/PyCharm/fedora-37-x86_64/repodata/repomd.xml (IP: 2600:1f18:8ee:ae00:d553:8ed5:d8b6:9f83)
Error: Failed to download metadata for repo 'phracek-PyCharm': Cannot download repomd.xml: Cannot download repodata/repomd.xml: All mirrors were tried
Hashicorp Stable - x86_64                                                 851  B/s | 346  B     00:00    
Errors during downloading metadata for repository 'hashicorp':
  - Status code: 404 for https://rpm.releases.hashicorp.com/fedora/37/x86_64/stable/repodata/repomd.xml (IP: 2600:9000:26c7:e600:18:566b:ecc0:93a1)
Error: Failed to download metadata for repo 'hashicorp': Cannot download repomd.xml: Cannot download repodata/repomd.xml: All mirrors were tried
Ignoring repositories: phracek-PyCharm, hashicorp
Last metadata expiration check: 2:20:53 ago on Sun 04 Aug 2024 12:10:03 PM CDT.
Dependencies resolved.
==========================================================================================================
 Package                                  Architecture     Version                Repository         Size
==========================================================================================================
Installing:
 libvirt                                  x86_64           8.6.0-5.fc37           updates            11 k
Installing dependencies:
 libvirt-daemon-config-nwfilter           x86_64           8.6.0-5.fc37           updates            24 k
 libvirt-daemon-driver-libxl              x86_64           8.6.0-5.fc37           updates           266 k
 libvirt-daemon-driver-lxc                x86_64           8.6.0-5.fc37           updates           278 k
 libvirt-daemon-driver-vbox               x86_64           8.6.0-5.fc37           updates           243 k

Transaction Summary
==========================================================================================================
Install  5 Packages

Total download size: 822 k
Installed size: 2.7 M
Is this ok [y/N]: y
Downloading Packages:
(1/5): libvirt-8.6.0-5.fc37.x86_64.rpm                                     53 kB/s |  11 kB     00:00    
(2/5): libvirt-daemon-config-nwfilter-8.6.0-5.fc37.x86_64.rpm              97 kB/s |  24 kB     00:00    
(3/5): libvirt-daemon-driver-libxl-8.6.0-5.fc37.x86_64.rpm                608 kB/s | 266 kB     00:00    
(4/5): libvirt-daemon-driver-lxc-8.6.0-5.fc37.x86_64.rpm                  1.1 MB/s | 278 kB     00:00    
(5/5): libvirt-daemon-driver-vbox-8.6.0-5.fc37.x86_64.rpm                 1.0 MB/s | 243 kB     00:00    
----------------------------------------------------------------------------------------------------------
Total                                                                     944 kB/s | 822 kB     00:00     
Running transaction check
...
Installed:
  libvirt-8.6.0-5.fc37.x86_64                        libvirt-daemon-config-nwfilter-8.6.0-5.fc37.x86_64   
  libvirt-daemon-driver-libxl-8.6.0-5.fc37.x86_64    libvirt-daemon-driver-lxc-8.6.0-5.fc37.x86_64        
  libvirt-daemon-driver-vbox-8.6.0-5.fc37.x86_64    

Complete!
```

Back to trying to run the ubuntu vm from the vagrantfile...

Ah so it's not that libvirt wasn't installed, the only provider that the ubuntu vm supported was virtualbox. Going to see if I can just find a vm that supports `libvirt` as the provider since I'd like to ideally spin this up on the hp dev laptop running Fedora.

Looks like [debian/jessie64-8.11.0](https://app.vagrantup.com/debian/boxes/jessie64/versions/8.11.0) supports libvirt provider

```txt
[  2:35PM ]  [ jac494@hp-laptop:~/vagrant-vms/ubuntu-trusty64 ]
 $ cd ..
[  2:37PM ]  [ jac494@hp-laptop:~/vagrant-vms ]
 $ mkch debian-jessie64-8.11.0
[  2:39PM ]  [ jac494@hp-laptop:~/vagrant-vms/debian-jessie64-8.11.0 ]
 $ vagrant init debian/jessie64 --box-version 8.11.0
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
[  2:40PM ]  [ jac494@hp-laptop:~/vagrant-vms/debian-jessie64-8.11.0 ]
 $ vagrant up
Bringing machine 'default' up with 'libvirt' provider...
==> default: Box 'debian/jessie64' could not be found. Attempting to find and install...
    default: Box Provider: libvirt
    default: Box Version: 8.11.0
==> default: Loading metadata for box 'debian/jessie64'
    default: URL: https://vagrantcloud.com/debian/jessie64
==> default: Adding box 'debian/jessie64' (v8.11.0) for provider: libvirt
    default: Downloading: https://vagrantcloud.com/debian/boxes/jessie64/versions/8.11.0/providers/libvirt/unknown/vagrant.box
==> default: Successfully added box 'debian/jessie64' (v8.11.0) for 'libvirt'!
==> default: Uploading base box image as volume into Libvirt storage...
==> default: Creating image (snapshot of base box volume).
==> default: Creating domain with the following settings...
==> default:  -- Name:              debian-jessie64-8.11.0_default
==> default:  -- Description:       Source: /home/jac494/vagrant-vms/debian-jessie64-8.11.0/Vagrantfile
==> default:  -- Domain type:       kvm
==> default:  -- Cpus:              1
==> default:  -- Feature:           acpi
==> default:  -- Feature:           apic
==> default:  -- Feature:           pae
==> default:  -- Clock offset:      utc
==> default:  -- Memory:            512M
==> default:  -- Management MAC:    
==> default:  -- Loader:            
==> default:  -- Nvram:             
==> default:  -- Base box:          debian/jessie64
==> default:  -- Storage pool:      default
==> default:  -- Image():     /home/jac494/.local/share/libvirt/images/debian-jessie64-8.11.0_default.img, 10G
==> default:  -- Disk driver opts:  cache='default'
==> default:  -- Kernel:            
==> default:  -- Initrd:            
==> default:  -- Graphics Type:     vnc
==> default:  -- Graphics Port:     -1
==> default:  -- Graphics IP:       127.0.0.1
==> default:  -- Graphics Password: Not defined
==> default:  -- Video Type:
...ran into some errors.
==> default: Creating shared folders metadata...
==> default: Starting domain.
/usr/share/gems/gems/fog-libvirt-0.8.0/lib/fog/libvirt/requests/compute/vm_action.rb:7:in `create': Call to virDomainCreateWithFlags failed: /usr/libexec/qemu-bridge-helper --use-vnet --br=virbr0 --fd=29: failed to communicate with bridge helper: stderr=failed to get mtu of bridge `virbr0': No such device (Libvirt::Error)
: Transport endpoint is not connected
        from /usr/share/gems/gems/fog-libvirt-0.8.0/lib/fog/libvirt/requests/compute/vm_action.rb:7:in `vm_action'
        from /usr/share/gems/gems/fog-libvirt-0.8.0/lib/fog/libvirt/models/compute/server.rb:76:in `start'
        from /usr/share/vagrant/gems/gems/vagrant-libvirt-0.7.0/lib/vagrant-libvirt/action/start_domain.rb:399:in `call'
        from /usr/share/vagrant/gems/gems/vagrant-2.2.19/lib/vagrant/action/warden.rb:48:in `call'
        from /usr/share/vagrant/gems/gems/vagrant-libvirt-0.7.0/lib/vagrant-libvirt/action/set_boot_order.rb:80:in `call'
...
[  2:40PM ]  [ jac494@hp-laptop:~/vagrant-vms/debian-jessie64-8.11.0 ]
 $ vagrant status
Current machine states:

default                   shutoff (libvirt)

The Libvirt domain is not running. Run `vagrant up` to start it.
```

Meh that didn't quite work but I get the point for now. seems cool and I'll probably just do some of this from my windows laptop next rather than spend too much time getting the hp laptop configured. I would also prefer to do the hp laptop setup from ansible anyway.

Going ahead and taking a moment to try from windows machine...

## `vagrant init` & `vagrant up`

```txt
PS C:\Users\jac49\Projects\vagrant-vms> cd .\ubuntu-trusty64\
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64> vagrant init ubuntu/trusty64
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'ubuntu/trusty64' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'ubuntu/trusty64'
    default: URL: https://vagrantcloud.com/ubuntu/trusty64
==> default: Adding box 'ubuntu/trusty64' (v20191107.0.0) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/20191107.0.0/providers/virtualbox/unknown/vagrant.box
```

... waiting on more output. just hanging out here for a bit. looks like it's going to take about 10 minutes but the download is working at least. I'll check back on this later.

```txt
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'ubuntu/trusty64' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'ubuntu/trusty64'
    default: URL: https://vagrantcloud.com/ubuntu/trusty64
==> default: Adding box 'ubuntu/trusty64' (v20191107.0.0) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/20191107.0.0/providers/virtualbox/unknown/vagrant.box
Download redirected to host: cloud-images.ubuntu.com
    default:
==> default: Successfully added box 'ubuntu/trusty64' (v20191107.0.0) for 'virtualbox'!
==> default: Importing base box 'ubuntu/trusty64'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'ubuntu/trusty64' version '20191107.0.0' is up to date...
==> default: Setting the name of the VM: ubuntu-trusty64_default_1722802093877_61683
==> default: Clearing any previously set forwarded ports...
Vagrant is currently configured to create VirtualBox synced folders with
the `SharedFoldersEnableSymlinksCreate` option enabled. If the Vagrant
guest is not trusted, you may want to disable this option. For more
information on this option, please refer to the VirtualBox manual:

  https://www.virtualbox.org/manual/ch04.html#sharedfolders

This option can be disabled globally with an environment variable:

  VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

or on a per folder basis within the Vagrantfile:

  config.vm.synced_folder '/host/path', '/guest/path', SharedFoldersEnableSymlinksCreate: false
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: The guest additions on this VM do not match the installed version of
    default: VirtualBox! In most cases this is fine, but in rare cases it can
    default: prevent things such as shared folders from working properly. If you see
    default: shared folder errors, please make sure the guest additions within the
    default: virtual machine match the version of VirtualBox you have installed on
    default: your host and reload your VM.
    default:
    default: Guest Additions Version: 4.3.40
    default: VirtualBox Version: 7.0
==> default: Mounting shared folders...
    default: /vagrant => C:/Users/jac49/Projects/vagrant-vms/ubuntu-trusty64
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64>
```

## `vagrant status`

```txt
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64> vagrant status
Current machine states:

default                   running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.
```

## `vagrant global-status`

```txt
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64> vagrant global-status
id       name    provider   state   directory
----------------------------------------------------------------------------------------
af72a71  default virtualbox running C:/Users/jac49/Projects/vagrant-vms/ubuntu-trusty64

The above shows information about all known Vagrant environments
on this machine. This data is cached and may not be completely
up-to-date (use "vagrant global-status --prune" to prune invalid
entries). To interact with any of the machines, you can go to that
directory and run Vagrant, or you can use the ID directly with
Vagrant commands from any directory. For example:
"vagrant destroy 1a2b3c4d"
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64>
```

## `vagrant halt`

```txt
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64> vagrant halt
==> default: Attempting graceful shutdown of VM...
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64>
```

## `vagrant destroy`

```txt
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64> vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Destroying VM and associated drives...
PS C:\Users\jac49\Projects\vagrant-vms\ubuntu-trusty64>
```
