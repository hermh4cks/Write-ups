# Building a Hacking Lab at home in order to sharpen your skills
[**Back** to Methodologies](/Methodology#methodologies)

Reading up on topics, and even doing practical exercises on other people's servers can be great for learning. However, building a home lab and practicing in an environment you control can lead to an even deeper understanding of the topic. In all honesty the main purpose of my lab is to create an **Active Directory** environment in-which I can better prepare for my **OSCP** exam. However once set up, I am planning to use it in a similar fasion to learn about various other topics as my carreer progresses. With that being said let me go over the basic settup of my lab.

All machines will be running on **1 HOST machine** as virtual computers. There will be **1 Windows Server 2019 Domain controller VM**, and **1 Windows 10 Client VM** for the Active Directory environment, and then the option to add any number of additional vulnerable VMs in the future. Atm I am capped locally at **16 Gigs** of **RAM** on the **HOST computer**, so I am going to try and not spin up too many boxes at one time. I am also planning on attacking this lab from a laptop running kali linux. I am going to treat my home network as a mock internet, so as that any machine on that network will still be *External* from the NAT'd lab domain. The stucture may change over time, but I wanted to make my notes public for completeness to these methodologies as being a *brain dump* of what I have learned about Pentesting and ethical hacking in general.

# The Domain controller

Software Running VMs: Oracle's [VirtualBox](https://www.virtualbox.org/)

OS of VM: Microsoft's [Windows Server 2019 ISO](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019)

