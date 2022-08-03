# DC-1
## Offensive Security Proving Grounds Play | Write-up by Herman Detwiler

# Recon

```
 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100024  1          37701/tcp   status
|   100024  1          39759/udp6  status
|   100024  1          45295/tcp6  status
|_  100024  1          55275/udp   status
MAC Address: 00:50:56:BF:51:34 (VMware)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

NSE: Script Post-scanning.
NSE: Starting runlevel 1 (of 3) scan.
Initiating NSE at 09:34
Completed NSE at 09:34, 0.00s elapsed
NSE: Starting runlevel 2 (of 3) scan.
Initiating NSE at 09:34
Completed NSE at 09:34, 0.00s elapsed
NSE: Starting runlevel 3 (of 3) scan.
Initiating NSE at 09:34
Completed NSE at 09:34, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.62 seconds
           Raw packets sent: 1001 (44.028KB) | Rcvd: 1001 (40.040KB)

```
exploit from exploit db because we see that it is drupal 7

![image](https://user-images.githubusercontent.com/83407557/182623746-2461c6f2-949d-419c-bdc3-df10b89e1803.png)


With admin creds we can get code execution

turn on php filter and then make a php rev shell

![image](https://user-images.githubusercontent.com/83407557/182627129-1d949c55-e831-407a-8f25-e7b844e3e478.png)

