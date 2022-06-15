# Your Hacking Computer
[**Back** to Methodologies](/Methodology#methodologies)

While you can truly start hacking on anything, certain settups will provide you with a more user friendly experience, and more features due to a large community of support. Personally, I like to do most of my hacking a mid-spec'd laptop running some flavor of linux. From a performance perspective, sometimes I need a little more bang, and also run a gaming PC. With this PC I often segment my activities through a series of VMs depending on my needs, but the underlying OS is Windows. Regardless of what you are the most comfortable using yourself, being well versed in multiple OS's is an requirement when pentesting. With that said, whatever you use, understanding how to more quickly inside a non-GUI shell will pay off greatly. Practice not using a desktop and watch your speed (and ability) increase.

### Index

+ [Linux](#linux)
  + [Shells](#linux-shells)
  + [Command line Text-editors](#linux-command-line-text-editors)
  + [File System structure](#linux-file-system-structure)
  + [Files](#linux-files)
  + [System info](#linux-system-info)
  + [File Commands](#linux-file-commands)
  + [Searching and Manipulating Text](#Linux-searching-and-manipulating-text)
  + [Network Commands](#linux-network-commands)
  + [iptables](#iptables)
  + [Utility Commands](#linux-utility-commands)
  + [Cover your Tracks](#linux-cover-your-tracks)
  + [Misc Commands](#linux-misc-commands)
  + [Linux for Windows](#linux-for-windows)
  + [Scripting](#linux-scripting)
+ [Windows](#windows)
  + [Versions](#windows-versions)
  + [Windows Registry](#windows-registry)
  + [Startup Directories](#windows-startup-directories)
  + [Files](#windows-files)
  + [System info](#windows-system-info-commands)
  + [NET/Domain](#windows-netdomain-commands)
  + [Remote](#windows-remote-commands)
  + [Network](#windows-network-commands)
  + [Utility Commands](#windows-utility-commands)
  + [Misc Commands](#windows-misc-commands)
  + [WMIC](#WMIC)
  + [PowerShell](#powershell)
  + [Scripting](#windows-scripting)
+ [Networking]()
+ [Programing]()
+ [Tool Syntax]()


# Linux
---
# Linux Shells


A **shell** is a program that allows humans and other programs to interact with the underlying Operating System on the computer. Whereas a kernel is like the central seed program from which the OS can grow, the shell is named as such due to it being the outter most part of the OS. That is, like with a seed, the shell is the only part that you see from the outside. 

## GUI
In modern computers we have grown used to mostly using a **GUI** (**Graphical User Interface**). It is the classic computer Desktop or mobile home screen. However, not all systems are set up to run with **GUI**s. Furthermore when needing to perform more complex operations on a device, **GUI**s are very lacking unless you already have a program or script already set up to do the desired task within a GUI.  

## CLI
Because of the limits of a **GUI**, use of a **CLI** (**Command line interface**) is pretty much required when hacking. This is why getting comfortable on a terminal using a CLI will make you a better hacker. **CLI**s will take string input with a series of arguments, and can have the input and output redirected into other commands, arguments or even files. 

## Terminal
The is the another word that Linux systems use for the native **CLI**. Being entirely text based, there are some tricks when it comes to orginization of the data you are inputting and outputting via the **terminal**

## Multiplexers

One such way of oranizing this data is the use of a **multiplexer**. *A program that manipulates the terminal window.* It can create splits on the screen, make named tabs, and even have entire scripting languages built around them. They also contain keyboard-shortcuts that allow you to perform the tasks quickly, and with practice, the muscle memory makes CLI multiplexing the most effective way to use a computer. My personal favorite multiplexer is **tmux**, [ippsec](https://www.youtube.com/watch?v=Lqehvpe_djs&t=155s) has done some really good youtube videos on how he uses it. I only customized my tmux config slighty from his. Talks about how it creates its own process on the system instead of being tied to your session, which can help alot when shells start to die while you are hacking.

# Linux Command Line Text-Editors

Even With a command line multiplexer sometimes you want to edit text without having to perform complex scripting commands in a terminal. For this you can use a text editor that is build for a CLI. Certain systems will have one or the other of these usually installed by default. Because of this, learning all of the ones listed here will help in the long run. Honestly I use both locally just based on how complex the tast is that I want to do. The main editors are

## nano
**nano  is a small and friendly editor.**
```bash
# Open a new file in nano:
nano

# Open a specific file:
nano path/to/file

# Open a specific file, positioning the cursor at the specified line and column:
nano +line,column path/to/file

# Open a specific file and enable soft wrapping:
nano --softwrap path/to/file

# Open a specific file and indent new lines to the previous lines' indentation:
nano --autoindent path/to/file

# Open nano and create a backup file (`file~`) when saving edits:
nano --backup path/to/file                                    
```

## vim
**It can be used to edit all kinds of plain text.  It is especially useful for editing programs.**
```bash
# File management

:e              reload file
:q              quit
:q!             quit without saving changes
:w              write file
:w {file}       write new file
:x              write file and exit

# Movement

    k
  h   l         basic motion
    j

w               next start of word
W               next start of whitespace-delimited word
e               next end of word
E               next end of whitespace-delimited word
b               previous start of word
B               previous start of whitespace-delimited word
0               start of line
$               end of line
gg              go to first line in file
G               go to end of file
gk              move down one displayed line
gj              move up one displayed line

# Insertion
#   To exit from insert mode use Esc or Ctrl-C
#   Enter insertion mode and:

a               append after the cursor
A               append at the end of the line
i               insert before the cursor
I               insert at the beginning of the line
o               create a new line under the cursor
O               create a new line above the cursor
R               enter insert mode but replace instead of inserting chars
:r {file}       insert from file

# Editing

u               undo
yy              yank (copy) a line
y{motion}       yank text that {motion} moves over
p               paste after cursor
P               paste before cursor
<Del> or x      delete a character
dd              delete a line
d{motion}       delete text that {motion} moves over

# Search and replace with the `:substitute` (aka `:s`) command

:s/foo/bar/     replace the first match of 'foo' with 'bar' on the current line only
:s/foo/bar/g    replace all matches (`g` flag) of 'foo' with 'bar' on the current line only
:%s/foo/bar/g   replace all matches of 'foo' with 'bar' in the entire file (`:%s`)
:%s/foo/bar/gc  ask to manually confirm (`c` flag) each replacement

# Preceding a motion or edition with a number repeats it 'n' times
# Examples:
50k         moves 50 lines up
2dw         deletes 2 words
5yy         copies 5 lines
42G         go to line 42

# Multiple windows
:e filename      - edit another file
:split filename  - split window and load another file
ctrl-w up arrow  - move cursor up a window
ctrl-w ctrl-w    - move cursor to another window (cycle)
ctrl-w_          - maximize current window
ctrl-w=          - make all equal size
10 ctrl-w+       - increase window size by 10 lines
:vsplit file     - vertical split
:sview file      - same as split, but readonly
:hide            - close current window
:only            - keep only this window open
:ls              - show current buffers
:.! <command>    - shell out

# Buffers
# move to N, next, previous, first last buffers
:bn              - goes to next buffer
:bp              - goes to prev buffer
:bf              - goes to first buffer
:bl              - goes to last buffer
:b 2             - open buffer #2 in this window
:new             - open a new buffer
:vnew            - open a new vertical buffer
:bd 2            - deletes buffer 2
:wall            - writes al buffers
:ball            - open a window for all buffers
:bunload         - removes buffer from window
:taball          - open a tab for all buffers

# Pointers back
ctrl-o

# Pointers forward
ctrl-o

# Super search
ctrl-p

# Text Objects

ci"              - change inside double quotes
ca"              - change around double quotes
ci'              - change inside single quotes
ca'              - change around single quotes
ca)              - change around paranthesis
ci)              - change inside paranthesis
cit              - change inside a tag(Example an html)
cat              - change around a tag

di"              - delete inside double quotes
da"              - delete around double quotes
di'              - delete inside single quotes
da'              - delete around single quotes
da)              - delete around paranthesis
di)              - delete inside paranthesis
dit              - delete inside a tag(Example an html)
dat              - delete around a tag

 tldr:vim 
# vim
# Vim (Vi IMproved), a command-line text editor, provides several modes for different kinds of text manipulation.
# Pressing `i` enters insert mode. `<Esc>` enters normal mode, which enables the use of Vim commands.
# More information: <https://www.vim.org>.

# Open a file:
vim path/to/file

# Open a file at a specified line number:
vim +line_number path/to/file

# View Vim's help manual:
:help<Enter>

# Save and Quit:
:wq<Enter>

# Undo the last operation:
u

# Search for a pattern in the file (press `n`/`N` to go to next/previous match):
/search_pattern<Enter>

# Perform a regular expression substitution in the whole file:
:%s/regular_expression/replacement/g<Enter>

# Display the line numbers:
:set nu<Enter>

```

# Linux File System structure
[Index](#index)

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
[Index](#index)

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
| `~/.ssh/` | SSH keystore |
| `/var/log` | System log files (most linux) |
| `/var/adm` | System log files (Unix) |
| `/var/spool/cron` | List cron files |
| `/var/log/apache/access.log` | Apache connection log |
| `/etc/fstab` | Static file system info |

# Linux System Info
[Index](#index)

| Command | Description |
| :-: | --- | 
| `nbstat -A $IP` | Get hostname for $IP |
| `id` | Current username |
| `w` | Logged on users |
| `who -a` | User information |
| `last -a` | Last users logged on |
| `ps -ef` | Process listing (top) |
| `df -h` | Disk usage (free) |
| `uname -a` | Kernel version/CPU info |
| `mount` | Mounted file systems |
| `getent passwd` | Show list of users |
| `PATH=$PATH:/home/mypath` | Add to PATH variable |
| `kill <pid>` | Kills process with `<pid>` |
| `cat /etc/issue` | Show OS info |
| `cat /etc/*release*` | Show OS version info |
| `cat /proc/version` | Show kernel info |
| `rpm --query -all` | Installed pkgs (Redhat) |
| `rpm -ivh *.rpm` | Install RPM (Redhat)(`-e`=remove) |
| `dpkg -get-selections` | Installed pkgs (Ubuntu) |
| `dpkg -I *.deb` | Install DEB (Ubuntu) (`-r`=remove) |
| `pkginfo` | Installed pkgs (Solaris) |
| `which $executable` | Show the location of `$executable` |
| `chmod 750 <tcsh/csh/ksh>` | Disable `<shell>`, force bash |

# Linux File Commands
[Index](#index)


| Command | Description |
| :-: | --- |
| `diff file1 file2` | Compare files |
| `rm -rf $dir` | Force delete of $dir |
| `shred -f -u file1` | Overwrites/deletes file1 |
| `touch -r file1 file2` | Create file with matching timestamp |
| `touch -t YYYYMMDDHHSS file` | Create file with given timestamp |
| `sudo fdisk -l` | List connected drives |
| `mount /dev/sda# /mnt/usbkey` | Mount usb key |
| `md5sum -t file` | Compute md5 hash of file |
| `echo -n "str"` | Generate md5 hash of string |
| `sha1sum file` | Compute sha1 hash of file |
| `sort -u` | Sort and show unique lines |
| `grep -c "str" file` | Count lines in file with string |
| `tar cf file.tar files` | Create a .tar from files |
| `tar xf file.tar` | Extract .tar |
| `tar czf file.tar.gz files` | Create a .tar.gz |
| `tar xzf file.tar.gz` | Extract .tar.gz |
| `tar cjf file.tar.bz2 files` | Create a .tar.bz2 |
| `tar xjz file.tar.bz2` | Extract .tar.bz2 |
| `gzip file` | Compress/rename file |
| `gzip -d file.gz` | Decompress file.gz |
| `upx -9 -o packed.exe orig.exe` | upx packs orig.exe |
| `zip -r zipname.zip \Directory\*` | Create .zip |
| `dd skip=1000 count=2000 bs=8 if=file of=file` | Cut block 1k-3k from file |
| `split -b 9k \file $prefix` | Split file into 9k chunks |
| `awk 'sub("$"."\r")' unix.txt > win.txt` | Make Win compatible txt file |
| `find -i -name file -type *.pdf` | Find pdf named file |
| `find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} \;` | Search for setuid files |
| `dos2unix file` | convert to *nix* format |
| `file file` | Determine file type/info about file |
| `chattr (+/-)i file` | Set/Unset immutable bit |
  
# Linux Searching and Manipulating Text 
[Index](#index)

## Greps

```bash
#Extract emails from file
grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" file.txt

#Extract valid IP addresses
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" file.txt

#Extract passwords
grep -i "pwd\|passw" file.txt

#Extract users
grep -i "user\|invalid\|authentication\|login" file.txt

# Extract hashes
#Extract md5 hashes ({32}), sha1 ({40}), sha256({64}), sha512({128})
egrep -oE '(^|[^a-fA-F0-9])[a-fA-F0-9]{32}([^a-fA-F0-9]|$)' *.txt | egrep -o '[a-fA-F0-9]{32}' > md5-hashes.txt
#Extract valid MySQL-Old hashes
grep -e "[0-7][0-9a-f]{7}[0-7][0-9a-f]{7}" *.txt > mysql-old-hashes.txt
#Extract blowfish hashes
grep -e "$2a\$\08\$(.){75}" *.txt > blowfish-hashes.txt
#Extract Joomla hashes
egrep -o "([0-9a-zA-Z]{32}):(w{16,32})" *.txt > joomla.txt
#Extract VBulletin hashes
egrep -o "([0-9a-zA-Z]{32}):(S{3,32})" *.txt > vbulletin.txt
#Extraxt phpBB3-MD5
egrep -o '$H$S{31}' *.txt > phpBB3-md5.txt
#Extract Wordpress-MD5
egrep -o '$P$S{31}' *.txt > wordpress-md5.txt
#Extract Drupal 7
egrep -o '$S$S{52}' *.txt > drupal-7.txt
#Extract old Unix-md5
egrep -o '$1$w{8}S{22}' *.txt > md5-unix-old.txt
#Extract md5-apr1
egrep -o '$apr1$w{8}S{22}' *.txt > md5-apr1.txt
#Extract sha512crypt, SHA512(Unix)
egrep -o '$6$w{8}S{86}' *.txt > sha512crypt.txt

#Extract e-mails from text files
grep -E -o "\b[a-zA-Z0-9.#?$*_-]+@[a-zA-Z0-9.#?$*_-]+.[a-zA-Z0-9.-]+\b" *.txt > e-mails.txt

#Extract HTTP URLs from text files
grep http | grep -shoP 'http.*?[" >]' *.txt > http-urls.txt
#For extracting HTTPS, FTP and other URL format use
grep -E '(((https|ftp|gopher)|mailto)[.:][^ >"	]*|www.[-a-z0-9.]+)[^ .,;	>">):]' *.txt > urls.txt
#Note: if grep returns "Binary file (standard input) matches" use the following approaches # tr '[\000-\011\013-\037177-377]' '.' < *.log | grep -E "Your_Regex" OR # cat -v *.log | egrep -o "Your_Regex"

#Extract Floating point numbers
grep -E -o "^[-+]?[0-9]*.?[0-9]+([eE][-+]?[0-9]+)?$" *.txt > floats.txt

# Extract credit card data
#Visa
grep -E -o "4[0-9]{3}[ -]?[0-9]{4}[ -]?[0-9]{4}[ -]?[0-9]{4}" *.txt > visa.txt
#MasterCard
grep -E -o "5[0-9]{3}[ -]?[0-9]{4}[ -]?[0-9]{4}[ -]?[0-9]{4}" *.txt > mastercard.txt
#American Express
grep -E -o "\b3[47][0-9]{13}\b" *.txt > american-express.txt
#Diners Club
grep -E -o "\b3(?:0[0-5]|[68][0-9])[0-9]{11}\b" *.txt > diners.txt
#Discover
grep -E -o "6011[ -]?[0-9]{4}[ -]?[0-9]{4}[ -]?[0-9]{4}" *.txt > discover.txt
#JCB
grep -E -o "\b(?:2131|1800|35d{3})d{11}\b" *.txt > jcb.txt
#AMEX
grep -E -o "3[47][0-9]{2}[ -]?[0-9]{6}[ -]?[0-9]{5}" *.txt > amex.txt

# Extract IDs
#Extract Social Security Number (SSN)
grep -E -o "[0-9]{3}[ -]?[0-9]{2}[ -]?[0-9]{4}" *.txt > ssn.txt
#Extract Indiana Driver License Number
grep -E -o "[0-9]{4}[ -]?[0-9]{2}[ -]?[0-9]{4}" *.txt > indiana-dln.txt
#Extract US Passport Cards
grep -E -o "C0[0-9]{7}" *.txt > us-pass-card.txt
#Extract US Passport Number
grep -E -o "[23][0-9]{8}" *.txt > us-pass-num.txt
#Extract US Phone Numberss
grep -Po 'd{3}[s-_]?d{3}[s-_]?d{4}' *.txt > us-phones.txt
#Extract ISBN Numbers
egrep -a -o "\bISBN(?:-1[03])?:? (?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]\b" *.txt > isbn.txt
```
## Sed
```bash
# sed
# A stream editor. Used to perform basic text transformations

# Preview a file edit, via substitution.
sudo sed 's/Name=Xfce Session/Name=Xfce_Session/' FILE

# Replace the same string more than once per line (g flag)
sudo sed 's/Name=Xfce Session/Name=Xfce_Session/g' FILE

# Edit a file (adding -i flag), in-place; changes are made to the file(s).
sudo sed -i 's/Name=Xfce Session/Name=Xfce_Session/' FILE

# It can become necessary to escape special characters in your string.
sed -i 's/\/path\/to\/somewhere\//\/path\/to\/anotherplace\//' FILE

# Change your sed delimiter to a pipe to avoid escaping slashes.
sed -i 's|/path/to/somewhere/|/path/to/anotherplace/|' FILE

# Apply multiple find-replace expressions to a file:
sed -e 's/find/replace/' -e 's/find/replace/' filename

# Replace separator `/` by any other character not used in the find or replace patterns, e.g. `#`:
sed 's#find#replace#' filename

```
## Cut
```bash
# Cut out the first sixteen characters of each line of stdin:
cut -c 1-16

# Cut out the first sixteen characters of each line of the given files:
cut -c 1-16 file

# Cut out everything from the 3rd character to the end of each line:
cut -c 3-

# Cut out the fifth field of each line, using a colon as a field delimiter (default delimiter is tab):
cut -d':' -f5

# Cut out the 2nd and 10th fields of each line, using a semicolon as a delimiter:
cut -d';' -f2,10

# Cut out the fields 3 through to the end of each line, using a space as a delimiter:
cut -d' ' -f3-
                                                              
```

## Awk
```bash
# A versatile programming language for working on files.
# More information: <https://github.com/onetrueawk/awk>.

# Print the fifth column (a.k.a. field) in a space-separated file:
awk '{print $5}' filename

# Print the second column of the lines containing "foo" in a space-separated file:
awk '/foo/ {print $2}' filename

# Print the last column of each line in a file, using a comma (instead of space) as a field separator:
awk -F ',' '{print $NF}' filename

# Sum the values in the first column of a file and print the total:
awk '{s+=$1} END {print s}' filename

# Print every third line starting from the first line:
awk 'NR%3==1' filename

# Print different values based on conditions:
awk '{if ($1 == "foo") print "Exact match foo"; else if ($1 ~ "bar") print "Partial match bar"; else print "Baz"}' filename

# Print all lines where the 10th column value equals the specified value:
awk '($10 == value)'

# Print all the lines which the 10th column value is between a min and a max:
awk '($10 >= min_value && $10 <= max_value)'

# To sum integers from a file or stdin, one integer per line:
printf '1\n2\n3\n' | awk '{ sum += $1} END {print sum}'

# To use a specific character as separator to sum integers from a file or stdin:
printf '1:2:3' | awk -F ":" '{print $1+$2+$3}'

# To print a multiplication table:
seq 9 | sed 'H;g' | awk -v RS='' '{for(i=1;i<=NF;i++)printf("%dx%d=%d%s", i, NR, i*NR, i==NR?"\n":"\t")}'

# To specify an output separator character:
printf '1 2 3' | awk 'BEGIN {OFS=":"}; {print $1,$2,$3}'
```

# Linux Network Commands
[Index](#index)

| Command | Description |
| :-: | --- |
| `watch ss -tp` | Monitor Network Connections |
| `netstat -ant` | TCP connections (`-anu`=UDP) |
| `netstat -tulpn` | Connections with PIDs |
| `lsof -i` | Established connections |
| `smb://$IP/share` | Access windows smb share |
| `share user $IP c$` | Mount windows share |
| `cmbclient -U $USER \\\\$IP\\$SHARE` | SMB connect |
| `ifconfig eth# $IP/$CIDR` | Set IP and netmask |
| `ifconfig eth0:1 $IP/$CIDR` | Set virtual interface |
| `route add default gw $GW_IP` | Set GateWay |
| `ifconfig eth# mtu $SIZE` | Change MTU size |
| `export MAC=xx.xx.xx.xx.xx.xx` | Change MAC |
| `ifcong $INTERFACE hw either $MAC` | Change MAC |
| `macchanger -m $MAC $INTERFACE` | Backtrack(kali) MAC changer |
| `iwlist $INTERFACE scan` | Built-in wifi scanner |
| `dig -x $IP` | Domain lookup for IP |
| `host $IP` | Domain lookup for IP |
| `host -t SRV _$service_tcp.url.com` | Domain SRV lookup |
| `dig @$IP domain -t AXFR` | DNS zone transfer |
| `host -l $DOMAIN $NAMESERVER` | DNS zone transfer |
| `ip xfrm state list` | Print existing VPN keys |
| `ip addr add $IP/$CIDR dev eth0` | Adds 'hidden' interface |
| `cat /var/log/messages \| grep DHCP` | List DHCP assignments |
| `tpckill host $IP and port $PORT` | Block ip:port |
| `echo "1" > /proc/sys/net/ipv4/ip_forward` | Turn on IP forwarding |
| `echo "namserver $IP" > /etc/resolv.conf` | Add DNS server |

# IPtables
[Index](#index)
*use **ip6tables** for IPv6 rules*
```bash
#List all iptables rules with affected line numbers
iptables -L -v --line-numbers

#Flust all iptables rules
iptables -F

#Dump iptables with counters, rules to STOUT
iptables-save -c > file

#Restore iptables rules
iptables-restore file

#Delete curent rules and chains
iptables --flush
iptables --delete-chain

#allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#drop ICMP
iptables -A INPUT -p icmp -m icmp --icmp-type any -j DROP
iptables -A OUTPUT -p icmp -j DROP

#allow ICMP outbound
iptales -A OUTPUT -i $interface -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -o $interface -p icmp --icmp-type echo-reply -j ACCEPT

#allow established connections
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

#allow ssh, http, https, dns
iptables -A INPUT -s 10.10.10.10/24 -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p udp -m udp --sport 53 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 53 -j ACCEPT

#allow ssh on Port 22 Outbound
iptables -A OUTPUT -o $interface -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i $interface -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

#allow only 10.10.10.0/24, ports 80,443 and log DROPs to /var/log/messages
iptables -A INPUT -s 10.10.10.0/24 -m state --state RELATED,ESTABLISHED,NEW -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -P INPUT DROP
iptables -A OUTPUT -o eth0 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A LOGGING -m limit --limit 4/min 0j LOG --log-prefix "DROPPED "
iptables -A LOGGING -j DROP

#default policies
iptables -P INPUT DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

#changing policies
iptables -P INPUT/FORAWRD/OUTPUT DROP/ACCEPT/REJECT

#Port Forward
##Turning on
echo "1" > /proc/sys/net/ipv4/ip_forward
####Can also be done using:#####
sysctl net.ipv4.ip_forward=1
##iptables rules
iptables -t nat -A PREROUTING -p tcp -i eth0 -j DNAT -d $pivot_IP --dport 443 -to-destination $attack_IP:443
iptables -t nat -A POSTROUTING -p tcp -i eth0 -j SNAT -s $target_subnet_CIDR -d $attack_IP --dport 443 -to-source $pivot_IP
iptables -t filter -I FORWARD 1 -j ACCEPT
```


# Linux Utility Commands
[Index](#index)

| Command | Description |
| :-: | --- |
| `wget http://$URL -O url.txt -o /dev/null` | Grab url |
| `rdesktop $IP` | Remote desktop to ip |
| `xfreerdp /v:$IP /u:$username /p:$password` | Better remote desktop, with credentials |
| `scp /tmp/file user@$IP:/tmp/file` | Put File |
| `scp user@$RemoteIP:/tmp/file /tmp/file` | Get File |
| `useradd -m $username` | Add user |
| `passwd $username` | Change user password |
| `rmuser $username` | Remove user |
| `script -a $outfile` | Record shell: Ctrl-D stops |
| `apropos $topic` | Find related command |
| `history` | View users command history |
| `!$line` | Executes line number in history |

# Linux Cover Your Tracks
[Index](#index)

| Command | Description |
| :-: | --- |
| `echo "" > /var/log/auth.log` | Clear auth.log file |
| `echo "" > ~/.bash_history` | Clear current user's bash history |
| `rm ~/.bash_history -rf` | Delete .bash_history file |
| `history -c` | Clear current session history |
| `export HISTFILESIZE=0` | Set history max lines to 0 |
| `export HISTSIZE=0` | Set history max commands to 0 |
| `unset HISTFILE` | Disable history logging (Need logout to take effect) |
| `kill -9 $$` | Kills current session |
| `in /dev/null ~/.bash_history -sf` | Permanently send all bash history commands to /dev/null |

# Linux Misc Commands
[Index](#index)

| Command | Description |
| :-: | --- |
| `ssh user@$ip arecord - \| aplay -` | Record remote mic |
| `gcc -o outfile myfile.c` | compile C,C++ |
| `init 6` | Reboot |
| `init 0` | Shutdown |
| `cat /etc/*syslog*.conf \| grep -v "^#"` | List of log files |
| `grep 'href=' $file \|cut -d"/" -f3 \| grep <url> \| sort -u` | Stip links in url.com |
| `dd if=/dev/urandom of=$file bs 3145728 count=100` | Make random 3MB file |

# Linux Scripting
[Index](#index)

### Ping Sweep

```bash
for x in {1..254..1}; do ping -c 1 1.1.1.$x |grep "64 b" |cut -d" " -f4 >> ips.txt;done
```

### Automated Domain name Resolve Bash Script

```bash
#!/bin/bash
echo "Enter Class C Range: i.e. 192.168.3"
read range
for ip in {1..254..1};do
host $range.$ip |grep "name pointer" |cut -d" " -f5
done
```

### Fork BOMB (Creates Processes Until System "Crashes")

```bash
:(){:|:&};:
```

### DNS Reverse Lookup

```bash
for ip in {1..254..1}; do dig -x 1.1.1.$ip | grep $ip >> dns.txt;done;
```

### IP Banning Script

```bash
#!/bin/bash
# Bans any IP in the /24 subnet for 192.168.1.0 starting at 2
# Assumes 1 is the router and does not ban IPs .20, .21, .22
i=2
while [ $i -le 253 ]
do
	if [ $i -ne 20 -a $i -ne 21 -a $i -ne 22 ]; then
		echo "BANNED: arp -s 192.168.1.$i"
		arp -s 192.168.1.$i 00.00.00.00.00.0a
	else
		echo "IP NOT BANNED: 192.168.1.$i************"
		echo "***************************************"
	fi
	i-`expr $i +1`
done
```
---
# Windows

# Windows Versions
[Index](#index)

| New Technology ID | Version | Release Date |
| :-: | :-: | :-: |
| NT 3.1 | `Windows NT 3.1` | July 27, 1993 |
| NT 3.5 | `Windows NT 3.5` | Sept 21, 1994 |
| NT 3.51 | `Windows NT 3.51` | May 30, 1995 |
| NT 4.0 | `Windows NT 4.0` | Aug 24, 1996 |
| NT 5.0 | `Windows 2000` | Feb 17, 2000 |
| NT 5.1 | `Windows XP` | Oct 25, 2001 |
| NT 5.2 | `Windows XP 64-bit` `Windows Server 2003` `Windows Server 2003 R2` `Windows Home Server` | March 28, 2003 |
| NT 6.0 | `Windows Vista` `Windows Server 2008` | Nov 30, 2006 |
| NT 6.1 | `Windows 7` `Windows Server 2008 R2` `Windows Home Server 2011` `Windows Thin PC` | Oct 22, 2009 |
| NT 6.2 | `Windows 8` `Windows Server 2012` | Oct 18, 2013 |
| NT 6.3 | `Windows 8.1` `Windows Server 2012 R2` | Oct 18, 2013 |
| NT 10 | `Windows 10` `Windows Server 2016` `Windows Server 2019` `Windows Server 2022` `Windows 11` | July 29, 2015-Oct 5, 2021 |

# Windows Registry
[Index](#index)

Database for low level system settings and user actions. Personally, I compare it to the registers on a processor but in a software sense, instead of hardware.
The Registry can be used to get information as well as change it, here are some usefull locations. For more in-depth usage check the [Docs](https://docs.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users). To view in windows, I always just use the built in GUI reg editor. In the terminal(needs admin privs) type:

```cmd
regedit
```

| Reg Location | Description |
| :-: | --- |
| `HKLM\Software\Microsoft\Windows NT\CurrentVersion` | Os information, Product Name, Date of Install, Reigstered Owner, System Root |
| `HKLM\System\CurrentControlSet\Control\TimeZoneInformation` | Time Zone info |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU` | Mapped Network Drives |
| `HKLM\SYSTEM\CurrentControlSet\Enum\USBSTOR` | USB devices |
| `HKLM\Security\Policy\Secrets` `HKCU\Software\Microsoft\Windows NT\CUreentVersion\Winlogon\autoadminlogon` | Password Keys |


---
# Windows Startup Directories
[Index](#index)

## NT 6.0-10


All users

`%SystemDrive%"\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"`

Specific User

`%SystemDrive%"\Users\%UserName%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"`

## NT 5.0-5.2
`%SystemDrive%"Documents and Settings\All Users\Start MenuPrograms\Startup"`
## Win9x
`%SystemDrive%"\wmiOWS\Start Menu\Programs\Startup"`
## NT 3.5-4.0
`%SystemDrive%"\WINNT\Profiles\All Users\Start Menu\Programs\Startup"`

# Windows Files
[Index](#index)

| Location | Description |
| :-: | --- |
| `%SYSTEMROOT%` | Usually C:\Windows |
| `type %SYSTEMROOT%\System32\drivers\etc\hosts` | Windows version of /etc/hosts |
| `type %SYSTEMROOT%\System32\drivers\etc\networks` | Network Settings |
| `%SYSTEMROOT%\System32\config\SAM` | location of User & Password Hashes |
| `type %SYSTEMROOT%\System32\repair\SAM` | Backup copy of SAM |
| `type %SYSTEMROOT%\System32\config\RegBack\SAM` | Backup copy of SAM |
| `type %WINDIR%\system32\config\AppEvent.Evt` | Application Log |
| `type %WINDIR%\system32\config\SecEvent.Evt` | Security Log |
| `%AllUSERSPROFILE%"\Start Menu\Programs\Startup\` | Startup Location (all) |
| `%USERPROFILE%"\Start Menu\Programs\Startup\` | Startup Location (user) |
| `%SYSTEMROOT%\Prefetch` | Prefetch directory (exe logs) |

# Windows System Info Commands
[Index](#index)

* If you see an environment variable like %ip% in the command, you need to use set to declare the variable first. Example below for ip 192.168.1.5:

```cmd
#setting a variable
set ip=192.168.1.5

#calling a variable (wrap it in %s)
echo %ip%
192.168.1.5
```

| Command | Description |
| :-: | --- |
| `ver` | OS Version info |
| `sc query state=all` | Show services |
| `tasklist /svc` | Processes and Services |
| `tasklist /m` | Processes and DLLs |
| `tasklist /S %ip% /v` | Remote process listing |
| `taskkill /PID %PID% /F` | Force process to terminate |
| `systeminfo /S %ip% /U domain\user /P Pwd` | Remote system info |
| `reg query \\%ip%\%Regdomain%\%key% /v %value%` | Query Remote registry (/s=all) |
| `reg query HKLM /f password /t REG_SZ /s` | Search registry for password |
| `fsutil fsinfo drives` | List drives as Admin |
| `dir /a /s /b c:\*.pdf*` | Search for all PDFs |
| `dir /a /b c:\windows\kb*` | Seartch for Patches |
| `findstr /si password *.txt\| *.xml\| *.xls` | Search files for password |
| `tree /F /A c:\ > tree.txt` | Directory listing of C: to saved to disk |
| `reg save HKLM\Security security.hive` | Save security hive to file |
| `echo %USERNAME%` | Display current User |
| `net users` | Local users |
| `net localgroups` | Local Groups |
| `net accounts` | password policy |
| `net sessions` | Sessions |
| `net share` | SMB Shares |
| `net configure server` | Server configuration information |
| `net configure workstation` | Workstation configuration information |

# Windows Net/Domain Commands
[Index](#index)

| Command | Description |
| :-: | --- | 
| `net view /domain`| Hosts in current Domain |
| `net view /domain:%target_domain%` | Hosts in target Domain |
| `net user /domain` | All users in current domain |
| `net user %username% %password% /add` | Add user with password |
| `net localgroup "Administrators" %username% /add` | Add user to Administrators group |
| `net accounts /domain` | Domain's password policy |
| `net localgroup "Administrators"` | List local admins |
| `net group /domain` | List Domain groups |
| `net group "Domain Admins" /donain` | List Domain admins |
| `net group "Domain Controllers" /domain` | List of DCs in current Domain |
| `net session \| find / "\\"` | Active SMB sessions |
| `net user %username% /ACTIVE:yes /domain` | Unlock Domain user account |
| `net user %username% %newpassword% /domain` | Change Domain user password |
| `net share %share% c:\share /GRANT:Everyone,FULL` | Share folder with everyone |

# Windows Remote Commands
[Index](#index)

| Command | Description |
| :-: | --- |
| `tasklist /S %ip% /v` | Remote process listing |
| ` ` |  |

# Windows Network Commands
[Index](#index)

# Windows Utility Commands
[Index](#index)

# Windows Misc Commands
[Index](#index)

# WMIC
[Index](#index)

# powershell
[Index](#index)

# Windows Scripting
[Index](#index)

# Networking

# Programing

# Tool Syntax
