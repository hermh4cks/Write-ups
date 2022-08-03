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

![image](https://user-images.githubusercontent.com/83407557/182636819-bd2aa5ee-e26a-412e-88df-f2d24a3b8d74.png)


![image](https://user-images.githubusercontent.com/83407557/182636574-383c8d06-5143-42e0-ace2-cb46516f20a5.png)


![image](https://user-images.githubusercontent.com/83407557/182627129-1d949c55-e831-407a-8f25-e7b844e3e478.png)



Start a listener on 4444 and try and get a callback

![image](https://user-images.githubusercontent.com/83407557/182637948-96a31568-3022-4056-9863-d05166353f5c.png)

priv esc

![image](https://user-images.githubusercontent.com/83407557/182638865-83979a9e-66a2-4679-a3c9-48b655026d96.png)

from gtfobins
![image](https://user-images.githubusercontent.com/83407557/182639149-1745c0f2-1112-44fe-add5-fa4ff81d86dc.png)

![image](https://user-images.githubusercontent.com/83407557/182639643-eb5ff6b4-1d41-4c2a-9efe-46991ad8aa33.png)

