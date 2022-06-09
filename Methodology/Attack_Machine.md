# Your Hacking Computer
[**Back** to Methodologies](/Methodology#methodologies)

While you can truly start hacking on anything, certain settups will provide you with a more user friendly experience, and more features due to a large community of support. Personally, I like to do most of my hacking a mid-spec'd laptop running some flavor of linux. From a performance perspective, sometimes I need a little more bang, and also run a gaming PC. With this PC I often segment my activities through a series of VMs depending on my needs, but the underlying OS is Windows. Regardless of what you are the most comfortable using yourself, being well versed in multiple OS's is an requirement when pentesting. With that said, whatever you use, understanding how to more quickly inside a non-GUI shell will pay off greatly. Practice not using a desktop and watch your speed (and ability) increase.

+ [Linux](#linux)
  + [File System structure](#linux-file-system-structure)
  + [Files](#linux-files)
  + [System info](#linux-system-info)
  + [File Commands](#linux-file-commands)
  + [Network Commands](#linux-network-commands)
  + [Utility Commands](#linux-utility-commands)
  + [Cover your Tracks](#linux-cover-your-treacks)
  + [Misc Commands](#linux-misc-commands)
  + [Scripting](#linux-scripting)
[Windows](#windows)
[Networking]()
[Programing]()
[Tool Syntax]()


# Linux
---
# Linux File System stucture

| Files or Directories | Description |
| :-: | --- |
| / | The slash / character alone denotes the root of the filesystem tree. |
| /bin | Stands for binaries and contains certain fundamental utilities, such as ls or cp, that are needed to mount /usr, when that is a separate filesystem, or to run in one-user (administrative) mode when /usr cannot be mounted. In System V.4, this is a symlink to /usr/bin. Otherwise, it needs to be on the root filesystem itself.
| /boot | Contains all the files needed for successful booting process. In Research Unix, this was one file rather than a directory.[14] Nowadays usually on the root filesystem itself, unless the system, bootloader etc. require otherwise.|
| /dev | Stands for devices. Contains file representations of peripheral devices and pseudo-devices. See also: Linux Assigned Names and Numbers Authority. Needs to be on the root filesystem itself.|
| /etc | Contains system-wide configuration files and system databases; the name stands for et cetera[14] but now a better expansion is editable-text-configurations. Originally also contained "dangerous maintenance utilities" such as init,[6] but these have typically been moved to /sbin or elsewhere. Needs to be on the root filesystem itself.|
| /home | Contains user home directories on Linux and some other systems. In the original version of Unix, home directories were in /usr instead.[15] Some systems use or have used different locations still: macOS has home directories in /Users, older versions of BSD put them in /u, FreeBSD has /usr/home.|
| /lib | Originally essential libraries: C libraries, but not Fortran ones.[14] On modern systems, it contains the shared libraries needed by programs in /bin, and possibly loadable kernel module or device drivers. Linux distributions may have variants /lib32 and /lib64 for multi-architecture support.|
| /media | Default mount point for removable devices, such as USB sticks, media players, etc. By common sense, the directory itself, whose subdirectories are mountpoints, is on the root partition itself. |
| /mnt | Stands for mount. Empty directory commonly used by system administrators as a temporary mount point. By common sense, the directory itself, whose subdirectories are mountpoints, is on the root partition itself. |
| /opt| Contains locally installed software. Originated in System V, which has a package manager that installs software to this directory (one subdirectory per package).[16]|
| /proc | procfs virtual filesystem showing information about processes as files. |
| /root | The home directory for the superuser root - that is, the system administrator. This account's home directory is usually on the initial filesystem, and hence not in /home (which may be a mount point for another filesystem) in case specific maintenance needs to be performed, during which other filesystems are not available. Such a case could occur, for example, if a hard disk drive suffers failures and cannot be properly mounted. By convention, this directory is on the root partition itself; in any case, it is not a link to /home/root or any such thing. |
| /sbin | Stands for "system (or superuser) binaries" and contains fundamental utilities, such as init, usually needed to start, maintain and recover the system. Needs to be on the root partition itself. |
| /srv | Server data (data for services provided by system).|
| /sys | In some Linux distributions, contains a sysfs virtual filesystem, containing information related to hardware and the operating system. On BSD systems, commonly a symlink to the kernel sources in /usr/src/sys.|
| /tmp | A place for temporary files not expected to survive a reboot. Many systems clear this directory upon startup or use tmpfs to implement it.|
| /unix | The Unix kernel in Research Unix and System V.[14] With the addition of virtual memory support to 3BSD, this got renamed /vmunix.|
| /usr | The "user file system": originally the directory holding user home directories,[15] but already by the Third Edition of Research Unix, ca. 1973, reused to split the operating system's programs over two disks (one of them a 256K fixed-head drive) so that basic commands would either appear in /bin or /usr/bin.[17] It now holds executables, libraries, and shared resources that are not system critical, like the X Window System, KDE, Perl, etc. In older Unix systems, user home directories might still appear in /usr alongside directories containing programs, although by 1984 this depended on local customs.|
| /include | Stores the development headers used throughout the system. Header files are mostly used by the #include directive in C language, which historically is how the name of this directory was chosen.|
| /lib | Stores the needed libraries and data files for programs stored within /usr or elsewhere.|
| /libexec | Holds programs meant to be executed by other programs rather than by users directly. E.g., the Sendmail executable may be found in this directory.[18] Not present in the FHS until 2011;[19] Linux distributions have traditionally moved the contents of this directory into /usr/lib, where they also resided in 4.3BSD.|
| /local | Resembles /usr in structure, but its subdirectories are used for additions not part of the operating system distribution, such as custom programs or files from a BSD Ports collection. Usually has subdirectories such as /usr/local/lib or /usr/local/bin.| 
| /share | Architecture-independent program data. On Linux and modern BSD derivatives, this directory has subdirectories such as man for manpages, that used to appear directly under /usr in older versions.|
| /var | Stands for variable. A place for files that might change frequently - especially in size, for example e-mail sent to users on the system, or process-ID lock files.| 
| /log | Contains system log files.| 
| /mail | The place where all incoming mail is stored. Users (other than root) can access their own mail only. Often, this directory is a symbolic link to /var/spool/mail.| 
| /spool | Spool directory. Contains print jobs, mail spools and other queued tasks.| 
| /src | The place where the uncompiled source code of some programs is. | 
| /tmp | The /var/tmp directory is a place for temporary files which should be preserved between system reboots. |

# Linux Files

| Filename | Description |
| :-: | --- | 
| `/etc/shadow` | Local users' hashed passwords |
| `/etc/passwd` | Local users |
| `/etc/group` | Local groups |
| `/etc/rc.d` | Startup services |
| `/etc/init.d` | Services |
| `/etc/hosts` | Known hostnames and IPs |
| `/etc/HOSTNAME` | Full hostname with domain |
| `/etc/network/interfaces` | Network configuration |
| `/etc/profile` | System environment variables |
| `/etc/apt/sources.list` | Ubuntu sources list |
| `/etc/resolv.conf` | Nameserver configuration |
| `/home/<user>/.bash_history` | Bash history (also /root/) |
| `/usr/share/wireshark/manuf` | Vendor-MAC lookup |
