# Building a Hacking Lab at home in order to sharpen your skills
[**Back** to Methodologies](/Methodology#methodologies)

Much of this is based originally from a [guide](https://www.youtube.com/watch?v=MHsI8hJmggI) by [Josh Madakor](https://www.youtube.com/c/JoshMadakor), so please do him a solid an go send him some love on his channels if any of this helps you. 

Reading up on topics, and even doing practical exercises on other people's servers can be great for learning. However, building a home lab and practicing in an environment you control can lead to an even deeper understanding of the topic. In all honesty the main purpose of my lab is to create an **Active Directory** environment in-which I can better prepare for my **OSCP** exam. However once set up, I am planning to use it in a similar fasion to learn about various other topics as my carreer progresses. With that being said let me go over the basic settup of my lab.

All machines will be running on **1 HOST machine** as virtual computers. There will be 1 Windows Server 2019 [Domain controller VM](#the-domain-controller), and 1 Windows 10 [Client VM](#the-client) for the Active Directory environment, and then the option to add any number of additional vulnerable VMs in the future. Atm I am capped locally at **16 Gigs** of **RAM** on the **HOST computer**, so I am going to try and not spin up too many boxes at one time. I am also planning on attacking this lab from a laptop running kali linux. I am going to treat my NAT'd home network as a mock internet, so as that any machine on that network will still be *External* from the *Internal* "lab" network. The stucture may change over time, but I wanted to make my notes public for completeness to these methodologies as being a *brain dump* of what I have learned about Pentesting and ethical hacking in general.

# The Domain controller

## VM Settup

Software Running VMs: Oracle's [VirtualBox](https://www.virtualbox.org/)

OS of VM: Microsoft's [Windows Server 2019 ISO](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019)

Empty Windows VM config, with shared clipboard and second network adapter set. (Add more cores or more RAM depending on your hardware limits)

![image](https://user-images.githubusercontent.com/83407557/172644562-b00ff0e9-7172-4781-923f-e612d6f6180d.png)

Selecting the option with a GUI

![image](https://user-images.githubusercontent.com/83407557/172645020-c86acadf-d99c-4b50-ab3b-0bfa66500679.png)

And Doing a custom install to format a new virtual disk with 50 Gigs of space

![image](https://user-images.githubusercontent.com/83407557/172645168-6d96956c-83e4-4700-a731-228f44af8bd0.png)

Since this lab is not going to be about password cracking, I will make all the passwords for the lab the same `Password123` 

![image](https://user-images.githubusercontent.com/83407557/172647498-ffef87f1-ca0b-4572-8dd4-23e2ad77f11e.png)

Quality of life, add a guest CD image. Virtualbox->Devices->Inseter guest CD image, then inside the VM:

![image](https://user-images.githubusercontent.com/83407557/172648832-6aa3f122-0b56-4b5d-8258-f43db1ae5a0b.png)

Intall from virtual D drive, then shutdown via windows start menu (not the virtualbox install prompt)

![image](https://user-images.githubusercontent.com/83407557/172649190-6a7ff43e-171a-4ba6-966c-5103517bb2f5.png)

Now the window will auto resize.

## IP settup

Visual diagram of lab network from Josh Madakor:

![image](https://user-images.githubusercontent.com/83407557/172651021-a986e902-0976-45a5-aa41-2ec4d80b1db5.png)


## Configuring the internal network for the lab

In network settings on the DC, I can see one adapter is connected to the outside internet. I will rename this one INTERNET and the other one INTERNAL_NETWORK just to be able to easily tell them apart
![image](https://user-images.githubusercontent.com/83407557/173960880-74e3036f-b21b-428c-83ae-ad841737ef78.png)

Changed

![image](https://user-images.githubusercontent.com/83407557/173961062-66bcf56d-82ee-4f8a-ac4a-1ab2e045e54c.png)

### Making a static ipv4 address, and making it so the DC uses itself as a DNS server.

![image](https://user-images.githubusercontent.com/83407557/173961457-79299b83-458b-49e6-a066-93a3691da3f0.png)

## Renaming the PC to DC01

Going to system settings (right-click start menu) *Doing so will reset the DC*

![image](https://user-images.githubusercontent.com/83407557/173961673-f72b462b-e851-4c6b-bb16-017fa33caa5d.png)





