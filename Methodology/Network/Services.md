# Service Scanning
[**Back** to Methodologies](/Methodology#methodologies) | [**Next** to Service Version Exploits](/Methodology/Network/Service_Version_Exploits.md#service-version-exploits)

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
| 7 | [Echo](/Methodology/Services/echo.md#hacking-echo) | `nc -uvn $IP 7` | NA |
| 21 | FTP | `nc -vn $IP 21` | `nmap --script ftp-* -p 21 $IP` |
| 22 | SSH/SFTP| `nc -vn $IP 22` | `nmap -sC -sV --script ssh* -p 22 $IP` |
| 23 | Telnet| `nc -vn $IP 23` | `nmap -n -sV -Pn --script "*telnet* and safe" -p 23 $IP` |
| 25/465/587 | SMTP| `nc -vn $IP $PORT` | `nmap -p25 --script smtp-commands $IP` |
| 43 | WHOIS| `nc -vn $IP 43` | `whois -h $IP -p 43 "domain"` |
| 53 | DNS| `dig version.bind CHAOS TXT @$IP` | `nmap -n --script "(default and *dns*) or fcrdns or dns-srv-enum or dns-random-txid or dns-random-srcport" $IP` |
| 68 | DHCP | `nc -uvn $IP 68` | `nmap --script broadcast-dhcp-discover` |
| 69 | TFTP/Bittorrent-tracker| `nc -uvn $IP 69` | `nmap -n -Pn -sU -p69 -sV --script tftp-enum $IP` |
| 79 | Finger | `nc -vn $IP 79` | `finger @$IP` |
| 80/443 | Web | `nc -zv $IP $PORT` | Large Attack Surface, read Web section |
| 88 | Kerberos | `nc -nv $IP 88` | `nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm="$Domain",userdb=$Userlist $IP` |
| 110/995 | POP | `nc -nv $IP 110` OR if SSL `openssl s_client -connect $IP:995 -crlf -quiet` | `nmap --script "pop* -sV -p $PORT $IP` |
| 111 | Portmapper | `nc -uvn $IP 111` | `rpcinfo $IP` `nmap -sSUC -p 111 $IP` |
| 113 | Ident | `nc -vn $IP 113` | `nmap -sC -sV -p 113 $IP` |
| 123 | NTP | `ntpdc -n -c monlist $IP` | `nmap -sU -sV --script "ntp* and (discovery or vuln) and not (dos or brute)" -p 123 $IP` |
| 135/593 | MSRPC | `nc -vn $IP $PORT` | `rpcdump.py -p $PORT $IP`(from impacket) |
| 137/138/139 | NetBios | `nmblookup -A $IP` | `nbtscan $IP/30` `nmap -sU -sV -T4 --script nbstat.nse -p 137 -Pn -n $IP` |
| 139/445 | SMB | `enum4linux -a $IP` | `nbtscan $IP` Huge attack surface, too many commands to list here |
| 143/993 | IMAP | `nc -nv $IP 143` / `openssl s_client -connect $IP:993 -quiet` | `msfconsole -q -x 'use auxiliary/scanner/imap/imap_version; set RHOSTS $IP; set RPORT 143; run; exit'` |
| 161/162/10161/10162 | SNMP | `nc -uvn $IP $PORT` | `nmap --script "snmp* and not snmp-brute" $IP` |
| 194/6667/6660-7000 | IRC | `nc -vn $IP $PORT` / `openssl s_client -connect $IP:$PORT -quiet` | `nmap -sV --script irc* -p $PORT $IP` |
| 264 | Check Point FireWall-1 | `nc -nv $IP 264` | ` printf '\x51\x00\x00\x00\x00\x00\x00\x21\x00\x00\x00\x0bsecuremote\x00'` | `nc -q 1 x.x.x.x 264 | grep -a CN | cut -c 2-` |
| 389/636/3268/3269 | LDAP | `nmap -p 389 --script ldap-search -Pn $IP` | `nmap -n -sV --script "ldap* and not brute" $IP` |
| 500 | IPsec/IKE VPN | `nmap -sU -p 500 $IP` | `ike-scan -M $IP` |
| 502 | Modbus | `nc -nv $IP 502` | `nmap --script modbus-discover -p 502 $IP` |
| 512 | Rexec | `nc -nv $IP 512` | `nmap -sC -sV -p 512` |
| 513 | Rlogin | `nc -nv $IP 513` | `apt-get install rsh-client;rlogin $IP $username` |
| 514 | Rsh | `nc -nv $IP 514` | `rsh $IP $command` |
| 515 | LPD | `nc -nv $IP 515` | `lpdprint.py $hostname $command` |
| 548 | AFP | `nc -nv $IP 548` | `nmap -sV --script "afp-* and not dos and not brute" -p 548 $IP` |
| 554/8554 | RTSP | `DESCRIBE rtsp://$IP:$PORT RTSP/1.0\r\nCSeq: 2` | `nmap -sV --script "rtsp-*" -p $PORT $IP` |
| 623 | IPMI | `nmap -n (-sU) -p 623 $ip/24` | `msfconsole;use auxiliary/scanner/ipmi/ipmi_version` |
| 631 | IPP | `nc -vn $IP 631` | `nmap -sC -sV -p 631 $IP` |
| 873 | Rsync | `nc -vn $IP 873` | `nmap -sV --script "rsync-list-modules" -p 873 $IP` |
| 1026 | Ruserd | `nmap -sU -p 1026 $IP` | `rusers -l $IP` |
| 1080 | Socks | `nc -vn $IP 1080` | `nmap -p 1080 --script socks-auth-info $IP` |
| 1098/1099/1050 | Java RMI-RMI-IIOP | `nc -vn $IP $PORT` | `rmg enum $IP $PORT` |
| 1433 | Microsoft MsSQL | `nc -vn $IP 1098` | `nmap --script ms-sql* -sV -p 1433 $IP` |
| 1521/1522/1529 | Oracle TNS listener | `nmap --script "oracle-tns-version" -p 1521 -T4 -sV $IP` | `tnscmd10g version -p 1521 -h $IP` |
| 1723 | PPTP | `nc -vn $IP 1723` | `nmap –Pn -sSV -p1723 $IP` |
| 1883 | MQTT | `nc -vn $IP 1883` | `nmap -sC -sV -p1883 $IP` |
| 2049 | NFS | `nc -vn $IP 2049` | `nmap --script=nfs-ls.nse,nfs-showmount.nse,nfs-statfs.nse -p 2049 $IP` |
| 2301/2381 | Compaq/HP Insight Manager | `nc -vn $IP $PORT` | `nmap -sC -sV -p$PORT $IP` |
| 2375/2376 | Docker | `nc -vn $IP $PORT` | `nmap -sV --script "docker-*" -p $PORT $IP` |
| 3128 | [Squid](/Methodology/Services/squid#pentesting-squidproxy) | `nc -vn $IP $PORT` | `proxychains nmap -sT -n -p- localhost` |
| 3260 | ISCSI | `nc -vn $IP $PORT` | `nmap -sV --script=iscsi-info -p 3260 $IP` |
| 3299 | SAPRouter | `nc -vn $IP $PORT` | `msf> use auxiliary/scanner/sap/sap_service_discovery`|
