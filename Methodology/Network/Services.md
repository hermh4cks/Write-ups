# Service Scanning
While a service can have a **custom** port number, these are the common or **default** port numbers for the listed services.

*Note, all commands are run using the env variable (likst **$IP**) this can be set in linux using the following bash command to set that variable:*

```bash
# Setting variable
export IP=10.10.10.5
export DOMAIN=example.com
export USERLIST=/usr/share/wordlist/usernames.txt

# After export, variables in bash can be called wtih a $:
echo $IP $DOMAIN $USERLIST
10.10.10.5 example.com /usr/share/wordlist/usernames.txt
```

*Many of the commands will require root(sudo) privs to run.*

| Common Port Number | Service Name | Banner Grabbing | Basic enumeration |
| :-: | :-: | - | - |
| 7 | Echo | `nc -uvn $IP 7` | NA |
| 21 | FTP | `nc -vn $IP 21` | `nmap --script ftp-* -p 21 $IP` |
| 22 | SSH/SFTP| `nc -vn $IP 22` | `nmap -sC -sV --script ssh* -p 22 $IP` |
| 23 | Telnet| `nc -vn $IP 23` | `nmap -n -sV -Pn --script "*telnet* and safe" -p 23 $IP` |
| 25/465/587 | SMTP| `nc -vn $IP $PORT` | `nmap -p25 --script smtp-commands $IP` |
| 43 | WHOIS| `nc -vn $IP 43` | `whois -h $IP -p 43 "domain"` |
| 53 | DNS| `dig version.bind CHAOS TXT @$IP` | `nmap -n --script "(default and *dns*) or fcrdns or dns-srv-enum or dns-random-txid or dns-random-srcport" $IP` |
| 69 | TFTP/Bittorrent-tracker| NA | `nmap -n -Pn -sU -p69 -sV --script tftp-enum $IP` |
| 79 | Finger | `nc -vn $IP 79` | `finger @$IP` |
| 80/443 | Web | `nc -zv $IP $PORT` | Large Attack Surface, read Web section |
| 88 | Kerberos | `nc -nv $IP 88` | `nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm="$Domain",userdb=$Userlist $IP` |
| 110/995 | POP | `nc -nv $IP 110` OR if SSL `openssl s_client -connect $IP:995 -crlf -quiet` | `nmap --script "pop* -sV -p $PORT $IP` |
| 111 | Portmapper | `nc -uvn $IP 111` | `rpcinfo $IP` `nmap -sSUC -p 111 $IP` |
| 113 | Ident | `nc -vn $IP 113` | `nmap -sC -sV -p 113 $IP` |
| 123 | NTP | `ntpdc -n -c monlist $IP` | `nmap -sU -sV --script "ntp* and (discovery or vuln) and not (dos or brute)" -p 123 $IP` |
| 135/593 | MSRPC | `nc -vn $IP $PORT` | `rpcdump.py -p $PORT $IP`(from impacket) |
