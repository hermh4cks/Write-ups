# Redeemer from Hack The Box

## tags:
Linux, Redis, Enumeration, Penatration Tester level 1, Attacks/Anonymous/Guest access.


## Settup

1. Connect to startingpoint VPN
2. Spawn machine
3. Store machine ip in a variable for further use

```bash
export ip=10.129.183.54
```

## Tasks

### 1.) Which TCP port is open on the machine.

This can be done by performing an nmap port scan on the target of the top 1000 ports

```bash
sudo nmap $ip
```
```
Nmap scan report for 10.129.183.54
Host is up (0.083s latency).
All 1000 scanned ports on 10.129.183.54 are in ignored states.
Not shown: 1000 closed tcp ports (reset)

Nmap done: 1 IP address (1 host up) scanned in 7.72 seconds
                                                                 
```
As this scan did not find any open ports, a follow-up scan of all ports can be performed.

```
sudo nmap -p- $ip
```

```
Nmap scan report for 10.129.183.54
Host is up (0.065s latency).
Not shown: 65534 closed tcp ports (reset)
PORT     STATE SERVICE
6379/tcp open  redis

Nmap done: 1 IP address (1 host up) scanned in 60.18 seconds
```

This shows me that there is 1 open tcp port: `6379`

### 2.)  Which service is running on the port that is open on the machine? 

While the basic scan shows that redis is running on tcp port 6379, a service scan will verify this finding:

```bash
sudo nmap -p 6379 -sC -sV $ip
```
```
Nmap scan report for 10.129.183.54
Host is up (0.054s latency).

PORT     STATE SERVICE VERSION
6379/tcp open  redis   Redis key-value store 5.0.7

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 12.43 seconds

```
This confirms `Redis` running on port 6379

### 3.)  What type of database is Redis? Choose from the following options: (i) In-memory Database, (ii) Traditional Database 

Doing some googling we can find the redis website at https://redis.io/ and find the following quote on the homepage:

*The open source, in-memory data store used by millions of developers as a database, cache, streaming engine, and message broker.*


further reading may be helpful, so I also take note of the docs url https://redis.io/docs/

However, I can be pretty certain that this is an `in-memory database`


### 4.)  Which command-line utility is used to interact with the Redis server? Enter the program name you would enter into the terminal without any arguments. 

From the docs under tools I can find that the most popular CLI is called `redis-cli`

### 5.)  Which flag is used with the Redis command-line utility to specify the hostname? 

After confirming that redis-cli is part of the kali repo, I am able to get commands with `redis-cli -h` and no other arguments to bring up a help menu

```
└─$ redis-cli -h                                                                                                    
redis-cli 6.0.16                                                                                                    
                                                                                                                    
Usage: redis-cli [OPTIONS] [cmd [arg [arg ...]]]                                                                    
  -h <hostname>      Server hostname (default: 127.0.0.1).                                                          
  -p <port>          Server port (default: 6379).                                                                   
  -s <socket>        Server socket (overrides hostname and port).                                                   
  -a <password>      Password to use when connecting to the server.                                                 
                     You can also use the REDISCLI_AUTH environment                                                 
                     variable to pass this password more safely                                                     
                     (if both are used, this argument takes precedence).                                            
  --user <username>  Used to send ACL style 'AUTH username pass'. Needs -a.                                         
  --pass <password>  Alias of -a for consistency with the new --user option.                                        
  --askpass          Force user to input password with mask from STDIN.                                             
                     If this argument is used, '-a' and REDISCLI_AUTH                                               
                     environment variable will be ignored.                                                          
  -u <uri>           Server URI.                                                                                    
  -r <repeat>        Execute specified command N times.                                                             
  -i <interval>      When -r is used, waits <interval> seconds per command.                                         
                     It is possible to specify sub-second times like -i 0.1.                                        
  -n <db>            Database number.                                           
```
From this output I can see that hostname can be set with the `-h` flag

### 6.)  Once connected to a Redis server, which command is used to obtain the information and statistics about the Redis server? 

Again from reading the docs I can see that the command is `info` however first I need to connect to this redis server with `readis-cli -h 10.129.183.54:6379`

```bash
redis-cli -h 10.129.183.54:6379> info                                                                                            
# Server                                                                                                            
redis_version:5.0.7                                                                                                 
redis_git_sha1:00000000                                                                                             
redis_git_dirty:0                                                                                                   
redis_build_id:66bd629f924ac924                                                                                     
redis_mode:standalone                                                                                               
os:Linux 5.4.0-77-generic x86_64                                                                                    
arch_bits:64                                                                                                        
multiplexing_api:epoll                                                                                              
atomicvar_api:atomic-builtin                                                                                        
gcc_version:9.3.0                                                                                                   
process_id:751                                                                                                      
....ect                                                                                              
```                                              

### 7.)  What is the version of the Redis server being used on the target machine? 

From the info command that I ran, I can see the redis version is `5.0.7`

### 8.)  Which command is used to select the desired database in Redis? 


From the docs I find I can select a database with the `select` command

### 9.)  How many keys are present inside the database with index 0? 

From the info command, I can see this information present:

```
#Keyspace
db0:keys=4,expires=0,avg_ttl=0

```


So the number of keys is `4`

### 10.)  Which command is used to obtain all the keys in a database? 


From google
```
Redis KEYS command
The Redis KEYS command returns all the keys in the database that match a pattern (or all the keys in the key space). Similar commands for fetching all the fields stored in a hash is HGETALL and for all fetching the members of a SMEMBERS. The keys in Redis themselves are stored in a dictionary (aka a hash table).Nov 1, 2016
```

so `KEYS *` returns all keys

```bash
10.129.183.54:6379> KEYS *
1) "temp"
2) "numb"
3) "flag"
4) "stor"
10.129.183.54:6379> 
```

### 11.) Submit root flag


Since I can see there is a key titled "flag" I can get the value for that key with the `GET` command

```
10.129.183.54:6379> GET flag
"03e1d2b376c37ab3f5319922053953eb"
10.129.183.54:6379> 

```

So the root flag is `03e1d2b376c37ab3f5319922053953eb`
