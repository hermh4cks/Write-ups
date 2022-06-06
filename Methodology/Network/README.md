# Network Hacking 
[**Back** to Methodologies](/Methodology#methodologies)

## Index

[From Outside the Network](#discovering-hosts-while-outside-the-network)
  + [ICMP](#ICMP)
  + [TCP](#tcp-port-discovery)
  + [UPD](#udp-port-discovery)
  + [SCTP](#sctp-port-discovery)
  + [WiFi](#wifi-hacking)
 
[From Inside the Network](#discovering-hosts-from-inside-the-network)

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

*Testing the top 1000 UDP ports inside /24 range. Will take over 20 minutes.
```bash
# -sV will make nmap test each possible known UDP service packet
# "--version-intensity 0" will make nmap only test the most probable
nmap -sU -sV --version-intensity 0 -F -n 199.66.11.53/24
```

## SCTP Port Discovery


# Discovering Hosts from inside the network
