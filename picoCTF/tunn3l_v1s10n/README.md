# tunn3l v1s10n

prompt: *We found this file. Recover the flag*

hint: Weird that it won't display right...

## Downloading

using `wget` I can download the file for further investigation

```bash
└─$ wget https://mercury.picoctf.net/static/da18eed3d15fd04f7b076bdcecf15b27/tunn3l_v1s10n
--2022-01-07 13:00:48--  https://mercury.picoctf.net/static/da18eed3d15fd04f7b076bdcecf15b27/tunn3l_v1s10n
Resolving mercury.picoctf.net (mercury.picoctf.net)... 18.189.209.142
Connecting to mercury.picoctf.net (mercury.picoctf.net)|18.189.209.142|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2893454 (2.8M) [application/octet-stream]
Saving to: ‘tunn3l_v1s10n’

tunn3l_v1s10n                100%[=============================================>]   2.76M  4.23MB/s    in 0.7s    

2022-01-07 13:00:50 (4.23 MB/s) - ‘tunn3l_v1s10n’ saved [2893454/2893454]

                                                                                          
```

I then want to see what I am dealing with using `file` and `strings` (in this case saving the output)

```bash
└─$ file tunn3l_v1s10n 
tunn3l_v1s10n: data
─$ strings tunn3l_v1s10n >strings.txt

```
running `hexeditor` on the file I see something off in the magic number "BM.&........" makes me want to run exiftool to see if this is actually a .bmp file.

![image](https://user-images.githubusercontent.com/83407557/148589710-6e3e58aa-a592-4d69-8b87-503cdebac166.png)

```bash
└─$ exiftool tunn3l_v1s10n 
ExifTool Version Number         : 12.36
File Name                       : tunn3l_v1s10n
Directory                       : .
File Size                       : 2.8 MiB
File Modification Date/Time     : 2021:03:15 14:24:47-04:00
File Access Date/Time           : 2022:01:07 13:02:12-05:00
File Inode Change Date/Time     : 2022:01:07 13:00:50-05:00
File Permissions                : -rw-r--r--
File Type                       : BMP
File Type Extension             : bmp
MIME Type                       : image/bmp
BMP Version                     : Unknown (53434)
Image Width                     : 1134
Image Height                    : 306
Planes                          : 1
Bit Depth                       : 24
Compression                     : None
Image Length                    : 2893400
Pixels Per Meter X              : 5669
Pixels Per Meter Y              : 5669
Num Colors                      : Use BitDepth
Num Important Colors            : All
Red Mask                        : 0x27171a23
Green Mask                      : 0x20291b1e
Blue Mask                       : 0x1e212a1d
Alpha Mask                      : 0x311a1d26
Color Space                     : Unknown (,5%()
Rendering Intent                : Unknown (826103054)
Image Size                      : 1134x306
Megapixels                      : 0.347
```

trying to open it in GIMP I get the following error

```
Opening 'tunn3l_v1s10n' failed: Error reading BMP file header
```

Okay, I think this may be something, lets look up more info bitmap graphic headers:

https://en.wikipedia.org/wiki/BMP_file_format#DIB_header_(bitmap_information_header)

okay So lets break down what we have in our header by looking at the header of a test .bmp file that i made in gimp (just a blank white canvas)

![image](https://user-images.githubusercontent.com/83407557/148592237-574e497c-7923-47c9-b16a-e9a02b2e9ceb.png)


So looking at the header I actually see the word BAD written twice, lets swap the values into our corrupt file

![image](https://user-images.githubusercontent.com/83407557/148592425-bb8cee43-f99a-4df0-bc42-1e94f1976627.png)


saving it as a .bmp file and opening it in gimp I get this:

![image](https://user-images.githubusercontent.com/83407557/148592616-67423267-0de6-437a-817f-274bd567650f.png)

Okay, so on the right track. Next I need to figure out how to change the bits per pixel 

from wiki:

![image](https://user-images.githubusercontent.com/83407557/148593687-e418a0ee-0173-4db3-920b-1bc70329bfc7.png)

I can also see that the compression values are wrong:

![image](https://user-images.githubusercontent.com/83407557/148593826-8ac77f87-5059-4908-81c9-700afdec7fed.png)


so I change the values at offset 1C and 1E and change the current values of `30, 01` to `40, 3` and save the file once again and open it in gimp:

and bingo:

![image](https://user-images.githubusercontent.com/83407557/148594085-27920884-df5e-4058-bde9-ba58c392e9c1.png)





