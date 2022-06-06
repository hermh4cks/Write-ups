# Host Discovery 
[**Back** to Methodologies](/Methodology#methodologies)

## Index

[From Outside the Network](#discovering-hosts-while-outside-the-network)
  + [ICMP](#ICMP)
  + [TCP](#tcp-port-discovery)
  + [UPD](#udp-port-discovery)
  + [SCTP](#sctp-port-discovery)
  + [WiFi](#wifi-hacking)
 
[From Inside the Network](#discovering-hosts-from-inside-the-network)
  + [Passive](#passive)
  + [Active](#active)
  + [Active ICMP](#active-icmp)
  + [Wake On Lan](#wake-on-lan)

# Discovering Hosts while outside the network

The Following protocols and commands can be used to discover hosts from outside the network.

## ICMP

### Tools

**ping**: simple echo request

**fping**: echo request to a range

**nmap**: echo requests that can avoid common filters

### Commands

```bash
# Single echo request to a host
ping -c 1 199.66.11.4


# Multiple echo requests a range of ips
fping -g 199.66.11.0/24


# Echo, Timestamp, and Subnet-mask requests
nmap -PEPM -sP -n 199.66.11.0/24
```

## TCP Port discovery

Often **ICMP** packets will be filtered by the host, in that case a port scan is needed. There are **65,535 ports** on each host. This could make scanning every port on every host within the time constraints of an engagement near impossible if you have many hosts. In this case, scanning the most common "x" number of ports

### Tools

**nmap**: many features, slow when casting a wide net

**masscan**: Very fast, designed for casting a wide net

### Commands

*Using both tools can often get the best results*
```bash
#Using masscan to scan top20ports of nmap in a /24 range (less than 5min)
masscan -p20,21-23,25,53,80,110,111,135,139,143,443,445,993,995,1723,3306,3389,5900,8080 199.66.11.0/24
```

### HTTP port Discovery

If you are doing a TCP scan, for only HTTP services on the most common ports.

```bash
masscan -p80,443,8000-8100,8443 199.66.11.0/24
```

## UDP Port discovery

Hard to tell if they are filtered or open, and can be a little slow. However, from nmap documentation:

![image](https://user-images.githubusercontent.com/83407557/172182886-169f063d-b7f0-473e-8e56-25ffdf4ea9d0.png)

### Tools

[**udp-proto-scanner**](https://github.com/CiscoCXSecurity/udp-proto-scanner): Sends UPD probes to a list of targets

**nmap** Venerable port scanner

### Commands

*Testing the top 1000 UDP ports inside /24 range. Will take over 20 minutes.*
```bash
# -sV will make nmap test each possible known UDP service packet
# "--version-intensity 0" will make nmap only test the most probable
nmap -sU -sV --version-intensity 0 -F -n 199.66.11.53/24
```

## SCTP Port Discovery

Another transport layer protocol, not as widely used but still scannable with **Nmap**

```bash
nmap -T4 -sY -n --open -Pn 199.66.11.0/24
```

## Wifi

# ADD WIFI SECTION

# Discovering Hosts from inside the network

The above examples also work from inside the network, however once inside a network more options open up. The scanning performed here depends how visible you are trying to be on the network. If you are trying to evade detection, creating large ammounts of network traffic is not ideal.

## Passive

Passive host discovery is possible because of our possition in the network. We can listen to network traffic without dirrectly interacting with the target hosts. Seeing a host's traffic in transit on the network verifies their existance.

### Tools

**netdiscover** ARP reconnaissance tool

[**bettercap**](https://www.bettercap.org/): The Swiss Army knife for WiFi, Bluetooth Low Energy, wireless HID hijacking and IPv4 and IPv6 networks reconnaissance and MITM attacks.

**p0f** Performs passive OS detection based on SYN packets. Unlike nmap and queso, p0f does recognition without sending any data.

### Basic Commands

```bash
# netdiscover passive detection mode
netdiscover -p

# p0f outputting to file p0f.log
p0f -i eth0 -p -o /tmp/p0f.log

# Bettercap2
## Turning passive recon on or off
net.recon on/off
## Showing results
net.show
## Showing more info
set net.show.meta true
```

## Active

Active host discovery involves directly interacting with the target, all of these methods **Will create network traffic**.

### Tools

**nbtscan** scan networks for NetBIOS name information

**netdiscover** ARP reconnaissance tool

[**bettercap2**](https://www.bettercap.org/): The Swiss Army knife for WiFi, Bluetooth Low Energy, wireless HID hijacking and IPv4 and IPv6 networks reconnaissance and MITM attacks.

```bash
#ARP discovery
nmap -sn <Network> #ARP Requests (Discover IPs)
netdiscover -r <Network> #ARP requests (Discover IPs)

#NBT discovery
nbtscan -r 192.168.0.1/24 #Search in Domain

# Bettercap2 (By default ARP requests are sent) 
##Activate all service discover and ARP
net.probe on/off
##Search local mDNS services (Discover local)
net.probe.mdns
##Ask for NetBios name (Discover local)
net.probe.nbns
## Search services (Discover local)
net.probe.upnp
## Search Web Services Discovery (Discover local)
net.probe.wsd
##10ms between requests sent (Discover local)
net.probe.throttle 10 
```

## Active ICMP

Same things that can be done from outside the network, but from within we can use ICMP packets to do some new things using nmap and the built in ping command.

```bash
# broadcast address(255) ping of a subnet, where each host in subnet should respond
ping -b 10.10.5.255

# broadcast adddress(255) ping of a network to find hosts in another subnet
ping -b 255.255.255.255

# nmap doing ICMPv4 echo, timestamp and subnet mask requests
nmap -PEPM -sP –vvv -n 10.12.5.0/24
```

## Wake on LAN

Turns on computers via a network message containing a "magic packet". This magic packet is the **MAC Dst** repeated 16 times. These packest are normally sent over ethernet 0x0842 or UDP on port 9. If no MAC is given the packet is sent to broadcast ethernet, with the broadcast MAC then being the one repeated.


Can be done with bettercap 2
```bash
#WOL (without MAC is used ff:...:ff)
wol.eth [MAC] #Send a WOL as a raw ethernet packet of type 0x0847
wol.udp [MAC] #Send a WOL as an IPv4 broadcast packet to UDP port 9

```
