# Scanning Discovered Hosts on a Network

[**Back** to Methodologies](/Methodology#methodologies) | [**Next** to Service Scanning](/Methodology/Network/Services.md#service-scanning)

With a list of **IP's** of the **Hosts** collected from the [previous](/Methodology/Network/README.md#host-discovery) phase of the engagement, it is time to perform a more in-depth scan of the target(s).

## TCP Scans

scanning TCP ports, the results will either be **open**, **closed** or **filtered**. You can scan them with SYN packets, and examine the results.

---

**OPEN ports** `SYN` --> `SYN/ACK` --> `RST`

**CLOSED ports** `SYN` --> `RST/ACK`

**Filtered ports** `SYN` --> No Response

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
