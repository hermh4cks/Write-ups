# Scavenger Hunt

Author: madStacks
Description

There is some interesting information hidden around this site http://mercury.picoctf.net:44070/. Can you find it?


## HTML

on main page within the HTML code:

`<!-- Here's the first part of the flag: picoCTF{t -->`



## CSS

and within CSS

`/* CSS makes the page look nice, and yes, it also has part of the flag. Here's part 2: h4ts_4_l0 */`

## Js

this one doesn't have the same flag as with the inpector challenge, instead it asks about search engine indexing

```js
function openTab(tabName,elmnt,color) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
	tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablink");
    for (i = 0; i < tablinks.length; i++) {
	tablinks[i].style.backgroundColor = "";
    }
    document.getElementById(tabName).style.display = "block";
    if(elmnt.style != null) {
	elmnt.style.backgroundColor = color;
    }
}

window.onload = function() {
    openTab('tabintro', this, '#222');
}

/* How can I keep Google from indexing my website? */
````


## Robots.txt

which is done via the robots.txt file on websites

```
User-agent: *
Disallow: /index.html
# Part 3: t_0f_pl4c
# I think this is an apache server... can you Access the next flag?

```

## Dirb

We can enumerate the directories using Dirb

```bash
└─$ dirb http://mercury.picoctf.net:44070/

-----------------
DIRB v2.22    
By The Dark Raver
-----------------

START_TIME: Sat Jan  8 15:07:58 2022
URL_BASE: http://mercury.picoctf.net:44070/
WORDLIST_FILES: /usr/share/dirb/wordlists/common.txt

-----------------

GENERATED WORDS: 4612                                                          

---- Scanning URL: http://mercury.picoctf.net:44070/ ----
+ http://mercury.picoctf.net:44070/.htaccess (CODE:200|SIZE:95)  
+ http://mercury.picoctf.net:44070/.DS_Store (CODE:200|SIZE:62)  
```

## .htaccess

```
# Part 4: 3s_2_lO0k
# I love making websites on my Mac, I can Store a lot of information there.
```

## .DS_Store

this is an invisible file on Macs

```
Congrats! You completed the scavenger hunt. Part 5: _7a46d25d}
```


## Flag


flag = picoCTF{th4ts_4_l0t_0f_pl4c3s_2_lO0k_7a46d25d}
