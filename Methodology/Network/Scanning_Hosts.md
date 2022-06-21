# Scanning Discovered Hosts on a Network

[**Back** to Methodologies](/Methodology#methodologies) | [**Next** to Service Scanning](/Methodology/Network/Services.md#service-scanning)

---

[Scanning](#scanning)

[IDS/IPS evasion](#ids-and-ips-evasion)

[Sniffing](#sniffing)

[LAN Attacks](#lan-attacks)

[Spoofing](#spoofing)

---
# Scanning

With a list of **IP's** of the **Hosts** collected from the [previous](/Methodology/Network/README.md#host-discovery) phase of the engagement, it is time to perform a more in-depth scan of the target(s).

## TCP Scans

scanning TCP ports, the results will either be **open**, **closed** or **filtered**. You can scan them with SYN packets, and examine the results:

---

**OPEN ports** `SYN` --> `SYN/ACK` --> `RST`

---

**CLOSED ports** `SYN` --> `RST/ACK`

---

**Filtered ports** `SYN` --> No Response

---

**Filtered ports** `SYN` --> `ICMP message`

---

Automation of scans with **Nmap** and **Bettercap 2**

```bash
# Nmap fast scan for the most 1000tcp ports used
nmap -sV -sC -O -T4 -n -Pn -oA fastscan <IP> 

# Nmap fast scan for all the ports
nmap -sV -sC -O -T4 -n -Pn -p- -oA fullfastscan <IP> 

# Nmap fast scan for all the ports slower to avoid failures due to -T4
nmap -sV -sC -O -p- -n -Pn -oA fullscan <IP>

#Bettercap2 Scan
syn.scan 192.168.1.0/24 1 10000 #Ports 1-10000
```

## UDP

To see if a UDP port is open, there are two ways to go about it.

1. Send a UDP packet to try and get an ICMP response from the host letting you know it is open
2. Send a formatted datagram for a specific service and see if it responds

With method 1. ICMP may be filtered, resulting in false negative results. With method 2. if you dont send the correctly formated datagram you will also get a false negative. A combination of both is how most scanners test UDP ports.

Nmap UDP scanning
```bash
# Check if any of the most common udp services is running
udp-proto-scanner.pl <IP> 

# Nmap fast check if any of the 100 most common UDP services is running
nmap -sU -sV --version-intensity 0 -n -F -T4 <IP>

# Nmap check if any of the 100 most common UDP services is running and launch defaults scripts
nmap -sU -sV -sC -n -F -T4 <IP> 

# Nmap "fast" top 1000 UDP ports
nmap -sU -sV --version-intensity 0 -n -T4 <IP>
# You could use nmap to test all the UDP ports, but that will take a lot of time
```

## SCTP Scans

From Hacktricks:
*SCTP sits alongside TCP and UDP. Intended to provide transport of telephony data over IP, the protocol duplicates many of the reliability features of Signaling System 7 (SS7), and underpins a larger protocol family known as SIGTRAN. SCTP is supported by operating systems including IBM AIX, Oracle Solaris, HP-UX, Linux, Cisco IOS, and VxWorks.*

Two different scans for SCTP are offered by nmap: -sY and -sZ

```bash
# Nmap fast SCTP scan
nmap -T4 -sY -n -oA SCTFastScan <IP>

# Nmap all SCTP scan
nmap -T4 -p- -sY -sV -sC -F -n -oA SCTAllScan <IP>
```

# IDS and IPS evasion

Intrusion detection and provention system evasion

### Time to live manipulation

Trim ttl to hit ids/ips but not the target, then send actual payload to target and ids/ips may think they are repetitions.

```bash
#Nmap flag
--ttlvalue <value>
```

### Avoiding signatures

Just add junk data to packets to become more random

```bash
#Nmap flag
--data-length 25
```

### Fragmenting Packets

If ids/ips cant put the fragments back together it can be bypassed

```bash
#Nmap flag
-f
```

### Invalid checksum

From hacktricks:

*Sensors usually don't calculate checksum for performance reasons. __ So an attacker can send a packet that **will be interpreted by the sensor but rejected by the final host.** Example:*

*Send a packet with the flag RST and a invalid checksum, so then, the IPS/IDS may thing that this packet is going to close the connection, but the final host will discard the packet as the checksum is invalid.*

### Uncommon IP and TCP headers

Might be dropped by IDS/IPS but still accepted by target

### Overlapping

From Hacktricks

*It is possible that when you fragment a packet, some kind of overlapping exists between packets (maybe first 8 bytes of packet 2 overlaps with last 8 bytes of packet 1, and 8 last bytes of packet 2 overlaps with first 8 bytes of packet 3). Then, if the IDS/IPS reassembles them in a different way than the final host, a different packet will be interpreted.*
*Or maybe, 2 packets with the same offset comes and the host has to decide which one it takes.*

+ **BSD**: It has preference for packets with smaller offset. For packets with same offset, it will choose the first one.
+ **Linux**: Like BSD, but it prefers the last packet with the same offset.
+ **Windows**: First value that comes, value that stays.
+ **cisco**: Last value that comes, value that stays.

## Sniffing 

From Hacktricks:

*Sniffing you can learn details of IP ranges, subnet sizes, MAC addresses, and hostnames by reviewing captured frames and packets. If the network is misconfigured or switching fabric under stress, attackers can capture sensitive material via passive network sniffing.*

*If a switched Ethernet network is configured properly, you will only see broadcast frames and material destined for your MAC address.*

For a GUI program Wireshark with capture filters is the way to go, but for command line tools sniffing comes down to TCPDump or Bettercap2. For the pcap files that are created by these programs, [PCredz](https://github.com/lgandx/PCredz) can be used to parse out the desired infomation.

### TCPDump

```bash
#Listen to DNS request to discover what is searching the host
sudo tcpdump -i <INTERFACE> udp port 53

#Listen to icmp packets
tcpdump -i <IFACE> icmp

sudo bash -c "sudo nohup tcpdump -i eth0 -G 300 -w \"/tmp/dump-%m-%d-%H-%M-%S-%s.pcap\" -W 50 'tcp and (port 80 or port 443)' &"
```

### Bettercap2

```bash
net.sniff on
net.sniff stats
net.sniff.output #Output file
net.sniff.local #Accept packets from this machine
net.sniff.filter
net.sniff.regexp
```
### PCredz
[link to PCredz on github](https://github.com/lgandx/PCredz)

```bash
# extract credentials from a pcap file
python3 ./Pcredz -f file-to-parse.pcap

# extract credentials from all pcap files in a folder
python3 ./Pcredz -d /tmp/pcap-directory-to-parse/

# extract credentials from a live packet capture on a network interface (need root privileges)
python3 ./Pcredz -i eth0 -v
```

# LAN Attacks

## ARP spoofing

Done by sending malicious **ARPResponses** saying that a target **IP** has the **MAC** of our device. Victems of the attack will then change their ARP table, and then contact our machine whenever it tries to access the target **IP**.

### With Bettercap2

Turn on arp spoofing
```bash
arp.spoof on
```

Setting no ipv4-redirect
```bash
arp.ban on
```

Setting up targets
```bash
arp.spoof.targets
```

Setting up a whitelist
```bash
arp.spoof whitelist
```
Spoofed local connections (by default only Victim <--> Gateway)
```bash
arp.spoof.internal
```

### With Arpspoof

Turn on ipv4 forward(need root)
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```
forward $ip1 --> $ip2
```bash
arpspoof -t $ip1 $ip2
```
forward $ip2 --> $ip1
```bash
arpspoof -t $ip2 $ip1
```
Turn off ipv4 forward(need root)
```bash
echo 0 > /proc/sys/net/ipv4/ip_forward
```

## MAC Flooding - CAM overflow
