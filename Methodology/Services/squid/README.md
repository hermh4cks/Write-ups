# Pentesting squidproxy

## Default port:3128


*Squid is a caching and forwarding HTTP web proxy. It has a wide variety of uses, including speeding up a web server by caching repeated requests, caching web, DNS and other computer network lookups for a group of people sharing network resources, and aiding security by filtering traffic. Although primarily used for HTTP and FTP, Squid includes limited support for several other protocols including Internet Gopher, SSL, TLS and HTTPS. Squid does not support the SOCKS protocol, unlike Privoxy, with which Squid can be used in order to provide SOCKS support.*-wiki


From an attacker's perspective, finding squid exposed means that you can portscan the internal network.

(still need to verify this)

1. Can be done with nmap and proxychains, after adding `http <target-ip> <port-for-squid>` to /etc/proxychains4.conf

2. There is a metasploit module: `auxiliary/scanner/http/squid_pivot_scanning`

3. There is a tool written in python (my prefered method so far) [spose](https://github.com/aancw/spose)


## Network scanning via squid using spose:

```bash
└─$ python3 spose.py --proxy http://192.168.175.189:3128 --target 127.0.0.1
Using proxy address http://192.168.175.189:3128
127.0.0.1 3306 seems OPEN 
127.0.0.1 8080 seems OPEN 
```

Once services are found many tools that allow proxy options can be used to interact with the squid service.

If a web server was found like above as an example:

- dirb and wfuzz can both use thier proxy options to target the remote squid service to dir bust
- firefox using foxy-proxy plugin can interact directly with the webapp
- curl can be used with the `curl -x or --proxy flags`
- nikto can scan through a proxy with the `--useproxy` flag

For individual services found via squid, use the write-up's for those respective services for info on how to scan them through proxies.
