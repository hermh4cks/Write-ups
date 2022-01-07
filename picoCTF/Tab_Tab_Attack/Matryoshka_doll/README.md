# Matryoshka doll

prompt:*Matryoshka dolls are a set of wooden dolls of decreasing size placed one inside another. What's the final one? Image: this*

hint 1)Wait, you can hide files inside files? But how do you find them?

hint 2)Make sure to submit the flag as picoCTF{XXXXX}


## getting the file

```bash
└─# wget https://mercury.picoctf.net/static/5ef2e9103d55972d975437f68175b9ab/dolls.jpg           
--2022-01-06 21:07:36--  https://mercury.picoctf.net/static/5ef2e9103d55972d975437f68175b9ab/dolls.jpg
Resolving mercury.picoctf.net (mercury.picoctf.net)... 18.189.209.142
Connecting to mercury.picoctf.net (mercury.picoctf.net)|18.189.209.142|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 651634 (636K) [application/octet-stream]
Saving to: ‘dolls.jpg’

dolls.jpg                    100%[=============================================>] 636.36K  1.74MB/s    in 0.4s    

2022-01-06 21:07:37 (1.74 MB/s) - ‘dolls.jpg’ saved [651634/651634]
    
```

## strings and file.

Using the `strings` and `file` doesn't net much in the way of results. However using `binwalk` I can see that it has a .zip file within the image.

```bash
└─# binwalk dolls.jpg 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 594 x 1104, 8-bit/color RGBA, non-interlaced
3226          0xC9A           TIFF image data, big-endian, offset of first image directory: 8
272492        0x4286C         Zip archive data, at least v2.0 to extract, compressed size: 378954, uncompressed size: 383940, name: base_images/2_c.jpg
651612        0x9F15C         End of Zip archive, footer length: 22

```

After that it is as simple as unzipping each layer of the matryoshka doll

```bash
─# unzip dolls.jpg                                                                                                
Archive:  dolls.jpg                                                                                                
warning [dolls.jpg]:  272492 extra bytes at beginning or within zipfile                                            
  (attempting to process anyway)                                                                                   
  inflating: base_images/2_c.jpg       

─# cd base_images                                                                                                 


└─# unzip 2_c.jpg                                                                                                  
Archive:  2_c.jpg                                                                                                  
warning [2_c.jpg]:  187707 extra bytes at beginning or within zipfile                                              
  (attempting to process anyway)                                                                                   
  inflating: base_images/3_c.jpg                                                                                   
                                       
─# cd base_images                                                                                                 
                                                                                                                                                   

└─# unzip 3_c.jpg 
Archive:  3_c.jpg
warning [3_c.jpg]:  123606 extra bytes at beginning or within zipfile
  (attempting to process anyway)
  inflating: base_images/4_c.jpg     

└─# cd base_images                                                                                             1 ⨯

└─# unzip 4_c.jpg 
Archive:  4_c.jpg
warning [4_c.jpg]:  79578 extra bytes at beginning or within zipfile
  (attempting to process anyway)
  inflating: flag.txt                 

└─# cat flag.txt                                                                                               1 ⨯
picoCTF{e3f378fe6c1ea7f6bc5ac2c3d6801c1f}                
                                          

```
