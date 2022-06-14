# Hacking Echo

[**BACK** to Service Scanning](/Methodology/Network/Services.md#service-scanning)

| Protocol | Default Port | Description |
| :-: | :-: | --- |
| UPD or TCP | 7 | Sends back any data it recieves, used for network testing. No longer widely used. Can be DoS'd by aiming two echo services at each other

Much like the command line program echo:
```bash
kali@kali:$ echo Hello World
Hello World
```

It just sends back the data it recieves:
```bash
kali@kali:$ nc -uvn 7 $remote_ip
Hello World
Hello World
```
