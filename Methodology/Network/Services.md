# Service Scanning
While a service can have a **custom** port number, these are the common or **default** port numbers for the listed services.

*Note, all commands are run using the env variable **$IP** this can be set in linux using the following bash command to set that variable an example ipv4 address of 10.10.10.5:

```bash
# Setting the IP variable
export IP=10.10.10.5
# After export, variables in bash can be called wtih a $ like so:
echo $IP
10.10.10.5
```

| Common Port Number | Service Name | Banner Grabbing | Basic enumeration |
| :-: | :-: | - | - |
| 7 | Echo | `nc -uvn $IP 7` | NA |
| 21 | FTP | `nc -vn $IP 21` | `nmap --script ftp-* -p 21 $IP` |
| 22 | SSH/SFTP| `nc -vn $IP 22` | `nmap -sC -sV --script ssh* -p 22 $IP` |
| 23 | Telnet| `nc -vn $IP 23` | `nmap -n -sV -Pn --script "*telnet* and safe" -p 23 $IP` |
| 25/465/587 | SMTP| `nc -vn $IP 25` | `nmap -p25 --script smtp-commands $IP` |
| 43 | WHOIS| `nc -vn $IP 43` | `whois -h $IP -p 43 "domain"` |
| 53 | DNS| `dig version.bind CHAOS TXT @$IP` | `nmap -n --script "(default and *dns*) or fcrdns or dns-srv-enum or dns-random-txid or dns-random-srcport" $IP` |
| 69 | TFTP/Bittorrent-tracker| NA | `nmap -n -Pn -sU -p69 -sV --script tftp-enum $IP` |
| 79 | Finger | `nc -vn $IP 79` | `finger @$IP` |
| 80/443 | Web | `nc -zv $IP 80` | Large Attack Surface, read Web section |
| 88 | Kerberos | `nc -nv $IP 88` | `nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm="$Domain",userdb=$Userlist $IP` |
