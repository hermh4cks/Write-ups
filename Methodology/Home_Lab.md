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


# Installing Active Directory Domain Services

Within the Server Manager Dashboard on the DC, select Add Roles and Features. Select the DC as an install destination, and check the box for AD DS:

![image](https://user-images.githubusercontent.com/83407557/174076728-c17f0324-4a9d-454a-ab71-9e7d7eab414a.png)

![image](https://user-images.githubusercontent.com/83407557/174076791-945892e3-16b7-4a47-af27-8a5f94d47982.png)

Installation will take some time

![image](https://user-images.githubusercontent.com/83407557/174077011-21df8a94-56eb-4139-9168-cc3bd41e0cb2.png)

## Promote DC(deploy AD)
In alerts now there is a link to promote the DC
![image](https://user-images.githubusercontent.com/83407557/174077725-46574108-3a0f-4bb2-a312-4bf6ea8f429b.png)

## Create a new forest (name domain)

Calling the Domain home.lab (name it whatever you wish), and creating a new forest.
![image](https://user-images.githubusercontent.com/83407557/174078171-1fd3c153-3290-4436-ab9b-95c1fa036000.png)

Setting the same password as for admin: Password123. Then click next until install is highlighted(ignore DNS warning)
![image](https://user-images.githubusercontent.com/83407557/174078354-22bf03c5-a304-4213-affc-3a2593a712d2.png)
Once done Computer will restart

# Making a new Domain Admin account.

As can be seen, now the login has the netbois name CONTROLLER\Administrator
![image](https://user-images.githubusercontent.com/83407557/174081410-fe1ebd78-970b-4599-bec6-98aa1f6c5bdb.png)


Once logged in, go to start->Active Directory Users and Computers

![image](https://user-images.githubusercontent.com/83407557/174081565-78433c73-5877-49ab-a842-227beb12a8f4.png)

Then Add a new Orginazational Unite to create an ADMINS OU, inside this OU create a new user and prefix the name with a- to signify an admin. I will use my own name just to remember it.

![image](https://user-images.githubusercontent.com/83407557/174082547-2aca731f-eab7-4d5a-8cf0-4861480dbd35.png)
![image](https://user-images.githubusercontent.com/83407557/174082721-b6b022af-b35c-4728-9d76-c2efb9521502.png)
![image](https://user-images.githubusercontent.com/83407557/174082841-cab9ac26-0ad0-4266-9ad2-04bee805ccbd.png)
I uncheck the change password on login option, and I make the password the same as the other's `Password123`
![image](https://user-images.githubusercontent.com/83407557/174083029-b14c5a8b-995a-4dd7-ac1d-713552f934af.png)
Then after creating in prop.(right click user) go to the member of tab, and add "domain admins" and hit check, then ok.
![image](https://user-images.githubusercontent.com/83407557/174083623-187dcfe0-a699-4006-b19f-97e494654693.png)

#### Logging in as new domain admin account 

sign out and then sign in as other user and enter a-hdetwiler and pass Password123

![image](https://user-images.githubusercontent.com/83407557/174084545-fa64ec02-d550-4f47-b0d1-100c2cd6e36e.png)


# Create RAS/NAT

This will let the Client computers get to the internet via the DC. In server Manager go to add roles and features and add remote access

![image](https://user-images.githubusercontent.com/83407557/174086290-9b89ab3d-3d07-4d12-a4bb-393065bb00a7.png)

Select top two options then hit next until install

![image](https://user-images.githubusercontent.com/83407557/174086489-a7ec80a8-c417-465d-bf40-99e3b3e0bf19.png)

Close when finished then go tools-> Routing and Remote Access

![image](https://user-images.githubusercontent.com/83407557/174087141-82058666-9dd4-4dd4-99d9-4c1aa1d8b8f0.png)

![image](https://user-images.githubusercontent.com/83407557/174087215-2ef62f10-b508-434b-81d5-e1aa65b0174f.png)

![image](https://user-images.githubusercontent.com/83407557/174087255-5a11d79f-78fd-43f7-8a85-1978298f601e.png)

![image](https://user-images.githubusercontent.com/83407557/174087333-33807175-500f-40c3-953d-edad0a9a84ec.png)

If configured correctly, the server status should now have a green up-arrow

![image](https://user-images.githubusercontent.com/83407557/174087875-50b3b4b2-6afe-43bb-9b94-cd3821bd8fd7.png)

# Setting up DHCP server

allows the clients to get an ip address on the internal network but still have an IP on the internet (Much like how our home computer's are NAT'd behind our routers)

add another feature, this time a DHCP server:

![image](https://user-images.githubusercontent.com/83407557/174088380-7f8e381e-91e4-455e-924b-0633a27d8d07.png)

Then click next until install, then install. When Done there should now be a DHCP pannel on the left of the server manager. Go to tools, DHCP. Right Click on IPv4 and add Scope, and name it descriptively. (We want our clients to get IPv4 addresses in range 172.16.0.100-172.16.0.200)

![image](https://user-images.githubusercontent.com/83407557/174123127-703f3ae1-9c89-4f53-8743-4a5b37dceb74.png)

make sure to set the net mask to length 24 and 255.255.255.0 because it wont be by default.

![image](https://user-images.githubusercontent.com/83407557/174123549-fa18f3fd-b0b2-4b05-9e0e-9fc579921b56.png)

Then keep hitting next until we can select yes, i want to configure DHCP options now. For Default Gateway use the router IP

![image](https://user-images.githubusercontent.com/83407557/174124157-2ebfdb4c-a178-4a9b-aae1-5caa7f6949fb.png)

After going through to finish, you need to authorize the DHCP by right clicking on the dc01.home.lab and then refresh the same way.

![image](https://user-images.githubusercontent.com/83407557/174124576-e0b14377-1fa1-4abb-8a76-c6a1276b09bb.png)

This makes the green checks appear

![image](https://user-images.githubusercontent.com/83407557/174124741-672383b2-0eae-4efe-9cac-db37f282beb4.png)

Then set the server as a router

![image](https://user-images.githubusercontent.com/83407557/174144181-edb36c49-0465-4a61-9189-05e650d74d6e.png)

then restart


# PowerShell Script to add X number of users

Josh Madakors powershell script

```powershell
# ----- Edit these Variables for your own Use Case ----- #
$PASSWORD_FOR_USERS   = "Password123"
$USER_FIRST_LAST_LIST = Get-Content .\names.txt
# ------------------------------------------------------ #

$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force
New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false

foreach ($n in $USER_FIRST_LAST_LIST) {
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToLower()
    $username = "$($first.Substring(0,1))$($last)".ToLower()
    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan
    
    New-AdUser -AccountPassword $password `
               -GivenName $first `
               -Surname $last `
               -DisplayName $username `
               -Name $username `
               -EmployeeID $username `
               -PasswordNeverExpires $true `
               -Path "ou=_USERS,$(([ADSI]`"").distinguishedName)" `
               -Enabled $true
}
```
To use, you also need to create a names.txt with a space between the first and last name. I changed his hardcoded password to my own as per the comment.
Feel free to make your own name.txt....but [here](https://github.com/joshmadakor1/AD_PS/blob/master/names.txt) is the one from Josh Madakor. Save this powershell script as user_add.ps1 and then names as names.txt within a folder on the DC desktop.

![image](https://user-images.githubusercontent.com/83407557/174135461-6c75663b-4de3-4b80-aa4b-fbfac2f7d815.png)

I add my own name, so I can also be a normal, non-admin user

![image](https://user-images.githubusercontent.com/83407557/174135765-a7920a45-0395-497f-adec-ea3e4a1110b0.png)

Before we can execute the script we need to change the execution policy within PowerShell. I plan to set this back to restricted, to harden the Lab's security after.

I then execute it with .\add_AD_users.ps1

![image](https://user-images.githubusercontent.com/83407557/174136338-7a130b9f-ba50-4633-9a28-0a009e56a9b1.png)
(i mislabeled names.txt as names.txt.txt(sorry used to linux), changed before executing)

![image](https://user-images.githubusercontent.com/83407557/174136679-a433a9c5-a2e1-4334-bc5a-4800dd45bcf6.png)

After completion I can see the users added in the USERS OU

![image](https://user-images.githubusercontent.com/83407557/174136986-70907244-dca5-4749-bdfc-2fe662425115.png)


# Creating CLIENT01

Create very much the same as the DC, but under network change from NAT to internal: lab



