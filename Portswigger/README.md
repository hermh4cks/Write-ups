# [Portswigger Academy](https://portswigger.net/)

[back to write-ups](/README.md#write-ups--by-herman-detwiler)

Portswigger Academy is split into three sections. Server side attacks, Client side attacks, and advanced attacks. The entire course is focused on webapp hacking. It is designed to be completed using burp suite web proxy, however as at the time of writing this I am also preparing for my OSCP exam, I am going to be trying to do the labs using python after each completion as an appended section of the write-up. Each of those write-ups can be found linked within this readme file. 

# INDEX

+ [Server Side Attacks](#server-side-attacks)
  
  + [1. SQL injection](#1-sql-injection)
  + [2. Authentication](#2-authentication)
  + [3. Directory traversal](#3-directory-traversal)
  + [4. Command injection](#4-command-injection)
  + [5. Business logic vulnerabilities](#5-business-logic-vulnerabilities)
  + [6. Information disclosure](#6-information-disclosure)
  + [7. Access control](#7-access-control)
  + [8. File upload vulnerabilities](#8-file-upload-vulnerabilities)
  + [9. Server-side request forgery(SSRF)](#9-server-side-request-forgeryssrf)
  + [10. XXE injection](#10-xxe-injection)

+ [Client Side Attacks](#client-side-attacks)
	+ [11. Cross-site scripting (XSS)](#11-cross-site-scripting-xss)
	+ [12. Cross-site request forgery(CSRF)](#12-cross-site-request-forgerycsrf)
	+ [13. Cross-origin resource sharing(CORS)](#13-cross-origin-resource-sharingcors)
	+ [14. Clickjacking](#14-clickjacking)
	+ [15. DOM-based vulnerabilities](#15-dom-based-vulnerabilities)
	+ [16. WebSockets](#16-websockets)

+ [Advanced Topics](#advanced-topics)
	+ [17. Insecure deserialization](#17-insecure-deserialization)
	+ [18. Server-side template injection](#18-server-side-template-injection)
	+ [19. Web cache poisoning](#19-web-cache-poisoning)
	+ [20. HTTP Host header attacks](#20-http-host-header-attacks)
	+ [21. HTTP reuest smuggling](#21-http-request-smuggling)
	+ [22. OAuth authentication](#22-oauth-authentication)

# Server side Attacks
---
## 1. SQL injection
[Back to Index](#index)
+ ### 1.1 SQLi

  + [Cheatsheat: SQL injection](https://portswigger.net/web-security/sql-injection/cheat-sheet)

  + [Lab: SQL injection vulnerability in WHERE clause allowing retrieval of hidden data](1.SQLi/hidden_data.md)

  + [Lab: SQL injection vulnerability allowing login bypass](1.SQLi/login_bypass.md)

+ ### 1.2 Union Attacks

  + [Lab: SQL injection UNION attack, determining the number of columns returned by the query](1.SQLi/num_of_col.md)

  + [Lab: SQL injection UNION attack, finding a column containing text](1.SQLi/column_with_txt.md)


  + [Lab: SQL injection UNION attack, retrieving data from other tables](1.SQLi/data_from_other_tables.md)

  + [Lab: SQL injection UNION attack, retrieving multiple values in a single column](1.SQLi/mult_values_single_column.md)

+ ### 1.3 Examining the Database

  + [Lab: SQL injection attack, querying the database type and version on Oracle](1.SQLi/database_type_and_version_Oracle.md)

  + [Lab: SQL injection attack, querying the database type and version on MySQL and Microsoft](1.SQLi/database_type_and_version_MySQL_and_Microsoft.md)

  + [Lab: SQL injection attack, listing the database contents on non-Oracle databases](1.SQLi/list_tables_non_Oracle.md)

  + [Lab: SQL injection attack, listing the database contents on Oracle](1.SQLi/database_content_Oracle.md)

+ ### 1.4 Blind SQLi

  + [Lab: Blind SQL injection with conditional responses](1.SQLi/Blind_with_conditional_responses.md)

  + [Lab: Blind SQL injection with conditional errors](1.SQLi/Blind_with_conditional_errors.md)
  
  + [Lab: Blind SQL injection with time delays and information retrieval](1.SQLi/Blind_with_time_delays_and_information_retrieval.md)
  
  + [Lab: Blind SQL injection with out-of-band interaction](1.SQLi/Blind_SQL_injection_with_out-of-band_interaction.md#blind-sql-injection-with-out-of-band-interaction)
  
  + [Lab: Blind SQL injection with out-of-band data exfiltration](1.SQLi/Blind_SQL_injection_with_out-of-band_data_exfiltration.md#blind-sql-injection-with-out-of-band-data-exfiltration)
  
  + [Lab: SQL injection with filter bypass via XML encoding](1.SQLi/SQL_injection_with_filter_bypass_via_XML_encoding.md#lab-sql-injection-with-filter-bypass-via-xml-encoding)
  

## 2. Authentication

[Back to Index](#index)

+ ### 2.1 Authentication: Password-based login

  + [Lab: Username enumeration via different responses](2.authentication/username_enumeration_via_different_responses.md)

  + [Lab: Username enumeration via subtly different responses](2.authentication/username_enumeration_via_subtly_different_responses.md)

  + [Lab: Username enumeration via response timing](2.authentication/username_enumeration_via_response_timing.md)
  
  + [Lab: Broken brute-force protection, IP block](2.authentication/Broken_brute-force_protection_with_IP_block.md#lab-broken-brute-force-protection-ip-block)
  
  + [Lab: Username enumeration via account lock](2.authentication/Username_enumeration_via_account_lock.md#lab-username-enumeration-via-account-lock)
  
  + [Lab: Broken brute-force protection, multiple credentials per request](2.authentication/Broken_brute-force_protection_multiple_credentials_per_request.md#lab-broken-brute-force-protection-multiple-credentials-per-request)

+ ### 2.2 Authentication: Multi-factor

  + [Lab: 2FA simple bypass](2.authentication/2FA_simple_bypass.md)

  + [Lab: 2FA broken logic](2.authentication/2FA_Broken_Logic.md)

  + [Lab: 2FA bypass using a brute-force attack](2.authentication/Lab:%202FA_bypass_brute-force.md)
  

+ ### 2.3 Authentication: Other Mechanisms

  + [Lab: Brute-forcing a stay-logged-in cookie](2.authentication/Brute_forcing_stay-logged-in_cookie.md)
  
  + [Lab: Offline password cracking](2.authentication/offline_password_cracking.md#lab-offline-password-cracking)

## 3. Directory traversal 
[Back to Index](#index)
## 4. Command injection
[Back to Index](#index)
## 5. Business logic vulnerabilities
[Back to Index](#index)
## 6. Information disclosure
[Back to Index](#index)
## 7. Access control
[Back to Index](#index)

  + [Lab: Unprotected admin functionality](7.Access_Control/unprotected_admin_functionality.md)

## 8. File upload vulnerabilities
[Back to Index](#index)

  + [Lab: Remote code execution via web shell upload](8.File_Upload_Vulns/RCE_via_webshell.md)

  + [Lab: Web shell upload via Content-Type restriction bypass](8.File_Upload_Vulns/WebShell_Content-Type_Restriction_Bypass.md)

  + [Lab: Web shell upload via path traversal](8.File_Upload_Vulns/WebShell_Upload_Directory_Traversal.md)

  + [Lab: Web shell upload via extension blacklist bypass](8.File_Upload_Vulns/WebShell_Extension_Blacklist_Bypass-Apache.md)

  + [Lab: Web shell upload via obfuscated file extension](8.File_Upload_Vulns/Webshell_via_obfuscated_file_extension.md)

  + [Lab: Remote code execution via polyglot web shell upload](8.File_Upload_Vulns/RCE_via_Polyglot_WebShell.md)

  + [Lab: Web shell upload via race condition](8.File_Upload_Vulns/WebShell_upload_via_race_condition.md)

## 9. Server-side request forgery(SSRF)
[Back to Index](#index)
## 10 XXE injection
[Back to Index](#index)
# Client side attacks
---
## 11. Cross-site scripting (XSS)
[Back to Index](#index)

[Portswigger XSS Cheat sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet)

  + [Lab: Reflected XSS into HTML context with nothing encoded](11.XSS/Reflected_XSS_no_encoding.md)

  + [Lab: Stored XSS into HTML context with nothing encoded](11.XSS/Stored_XSS_into_html_no_encoding.md)
  
  + [Lab: DOM XSS in document.write sink using source location.search](11.XSS/DOM_XSS_in_document.write_SINK_using_SOURCE_location.search.md)
  
  + [Lab: DOM XSS in innerHTML sink using source location.search](11.XSS/DOM_XSS_in_innerHTML_sink_using_source_location.search.md) 

  + [Lab: DOM XSS in jQuery anchor href attribute sink using location.search source](11.XSS/DOM_XSS_in_jQuery_anchor_href_attribute_sink_using_location.search_source.md)

## 12. Cross-site request forgery(CSRF)
[Back to Index](#index)
## 13. Cross-origin resource sharing(CORS)
[Back to Index](#index)
## 14. Clickjacking
[Back to Index](#index)
## 15. DOM-based vulnerabilities
[Back to Index](#index)
## 16. WebSockets
[Back to Index](#index)
# Advanced Topics
---
## 17. Insecure deserialization
[Back to Index](#index)
## 18. Server-side template injection
[Back to Index](#index)
## 19. Web cache poisoning
[Back to Index](#index)
## 20. HTTP Host header attacks
[Back to Index](#index)
## 21. HTTP reuest smuggling
[Back to Index](#index)
## 22. OAuth authentication

