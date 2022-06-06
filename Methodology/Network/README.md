# Network Hacking 
[**Back** to Methodologies](/Methodology#methodologies)

# Discovering Hosts while outside the network

The Following protocols and commands can be used to discover hosts from outside the network.

## ICMP

*ping*: simple echo request
*fping*: echo request to a range
*nmap*: echo requests that can avoid common filters

```bash
ping -c 1 199.66.11.4    # Single echo request to a host
fping -g 199.66.11.0/24  # Multiple echo requests a range of ips
nmap -PEPM -sP -n 199.66.11.0/24 # Echo, Timestamp, and Subnet-mask requests
```
