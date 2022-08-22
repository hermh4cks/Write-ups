# Brainstorm From TryHackMe

Write-up by Herman Detwiler

### Briefing

Deploy the machine and scan the network to start enumeration!

Please note that this machine does not respond to ping (ICMP) and may take a few minutes to boot up.


## Recon


The first step is to scan the machine to see which services have open ports that I can further enumerate. To scan all ports with nmap I use the following flags:


```bash
nmap 10.10.52.192 -p- -Pn -T4 -oA nmap/all-ports
```

- `-p-` To scan ALL ports

- `-Pn` To treat the target as online (skipping the ping scan since we were told the machine will not respond)

- `-oA nmap/all-ports` to output in all formats into files named all-port.*

- `-T4` to speed up the scan with more threads


