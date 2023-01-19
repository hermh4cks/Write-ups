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
	+ [21. HTTP reuest smuggling](#21-http-reuest-smuggling)
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
  
  + [Lab: Password reset broken logic](2.authentication/Password_reset_broken_logic.md#lab-password-reset-broken-logic)
  
  + [Lab: Password reset poisoning via middleware](2.authentication/Password_reset_poisoning_via_middleware.md#lab-password-reset-poisoning-via-middleware)
  
  + [Lab: Password brute-force via password change](2.authentication/Password_brute-force_via_password_change.md#lab-password-brute-force-via-password-change)

## 3. Directory traversal 
[Back to Index](#index)

  + [Lab: File path traversal, simple case](3.Directory_traversal/file_path_traversal_simple_case.md#lab-file-path-traversal-simple-case)
  
  + [Lab: File path traversal, traversal sequences blocked with absolute path bypass](3.Directory_traversal/File_path_traversal_traversal_sequences_blocked_with_absolute_path_bypass.md#lab-file-path-traversal-traversal-sequences-blocked-with-absolute-path-bypass)
  
  + [Lab: File path traversal, traversal sequences stripped with superfluous URL-decode](3.Directory_traversal/File_path_traversal_sequences_stripped_with_superfluous_URL-decode.md#lab-file-path-traversal-traversal-sequences-stripped-with-superfluous-url-decode)
  
  + [Lab: File path traversal, validation of start of path](3.Directory_traversal/validation_of_start_of_path.md#lab-file-path-traversal-validation-of-start-of-path)
  
  + [Lab: File path traversal, validation of file extension with null byte bypass](3.Directory_traversal/validation_of_file_extension_with_null_byte_bypass.md#lab-file-path-traversal-validation-of-file-extension-with-null-byte-bypass)
  
## 4. Command injection
[Back to Index](#index)

  + [Lab: OS command injection, simple case](4.OS_Command_Injection/OS_command_injection-simple_case.md#lab-os-command-injection-simple-case)
  
  + [Lab: Blind OS command injection with time delays](4.OS_Command_Injection/Blind_OS_command_injection_with_time_delays.md#lab-blind-os-command-injection-with-time-delays)
  
  + [Lab: Blind OS command injection with output redirection](4.OS_Command_Injection/Blind_OS_command_injection_with_output_redirection.md#lab-blind-os-command-injection-with-output-redirection)
  
  + [Lab: Blind OS command injection with out-of-band interaction](4.OS_Command_Injection/Blind_OS_command_injection_with_out-of-band_interaction.md#lab-blind-os-command-injection-with-out-of-band-interaction)
  
  + [Lab: Blind OS command injection with out-of-band data exfiltration](4.OS_Command_Injection/Blind_OS_command_injection_with_out-of-band_data_exfiltration.md#lab-blind-os-command-injection-with-out-of-band-data-exfiltration)

## 5. Business logic vulnerabilities
[Back to Index](#index)

  + ### 5.1 Excessive trust in client-side controls
    
    + [Lab: 2FA broken logic](2.authentication/2FA_Broken_Logic.md)
    
    + [Lab: Excessive trust in client-side controls](5.Business_logic_vulnerabilities/excessive_trust_in_client-side_controls.md#lab-excessive-trust-in-client-side-controls)
  
  + ### 5.2 Failing to handle unconventional input
  
    + [Lab: High-level logic vulnerability](5.Business_logic_vulnerabilities/High-levl_logic_vulnerability.md#lab-high-level-logic-vulnerability)
    
    + [Lab: Low-level logic flaw](5.Business_logic_vulnerabilities/Low-level_logic_flaw.md#lab-low-level-logic-flaw)
    
    + [Lab: Inconsistent handling of exceptional input](5.Business_logic_vulnerabilities/Inconsistent_handling_of_exceptional_input.md#lab-inconsistent-handling-of-exceptional-input)
  
  + ### 5.3 Making flawed assumptions about user behavior
  
    + [Lab: Inconsistent security controls](5.Business_logic_vulnerabilities/Inconsistent_security_controls.md#lab-inconsistent-security-controls)
    
    + [Lab: Weak isolation on dual-use endpoint](5.Business_logic_vulnerabilities/Weak_isolation_on_dual-use_endpoint.md#lab-weak-isolation-on-dual-use-endpoint)
    
    + [Lab: Password reset broken logic](2.authentication/Password_reset_broken_logic.md#lab-password-reset-broken-logic)
    
    + [Lab: 2FA simple bypass](2.authentication/2FA_simple_bypass.md#lab-2fa-simple-bypass)
    
    + [Lab: Insufficient workflow validation](5.Business_logic_vulnerabilities/Insufficient_workflow_validation.md#lab-insufficient-workflow-validation)
    
    + [Lab: Authentication bypass via flawed state machine](5.Business_logic_vulnerabilities/Authentication_bypass_via_flawed_state_machine.md#lab-authentication-bypass-via-flawed-state-machine)
  
  + ### 5.4 Domain-specific flaws
  
    + [Lab: Flawed enforcement of business rules](5.Business_logic_vulnerabilities/Flawed_enforcement_of_business_rules.md#lab-flawed-enforcement-of-business-rules)
    
    + [Lab: Infinite money logic flaw](5.Business_logic_vulnerabilities/Infinite_money_logic_flaw.md#lab-infinite-money-logic-flaw)
  
  + ### 5.5 Providing an encryption Oracle

## 6. Information disclosure
[Back to Index](#index)

  + [Lab: Information disclosure in error messages](6.Information_Disclosure/Information_disclosure_in_error_messages.md#lab-information-disclosure-in-error-messages)
  
  + [Lab: Information disclosure on debug page](6.Information_Disclosure/Information_disclosure_on_debug_page.md#lab-information-disclosure-on-debug-page)
  
  + [Lab: Source code disclosure via backup files](6.Information_Disclosure/Source_code_disclosure_via_backup_files.md#lab-source-code-disclosure-via-backup-files)
  
  + [Lab: Authentication bypass via information disclosure](6.Information_Disclosure/Authentication_bypass_via_information_disclosure.md#lab-authentication-bypass-via-information-disclosure)

## 7. Access control
[Back to Index](#index)

  + ### 7.1 Vertical Privilege Escalation 

    + [Lab: Unprotected admin functionality](7.Access_Control/unprotected_admin_functionality.md)
  
    + [Lab: Unprotected admin functionality with unpredictable URL](7.Access_Control/Unprotected_admin_functionality_with_unpredictable_URL.md#lab-unprotected-admin-functionality-with-unpredictable-url)

    + [Lab: User role controlled by request parameter](7.Access_Control/User_role_controlled_by_request_parameter.md#lab-user-role-controlled-by-request-parameter)
  
    + [Lab: User role can be modified in user profile](7.Access_Control/User_role_can_be_modified_in_user_profile.md#lab-user-role-can-be-modified-in-user-profile)
  
    + [Lab: URL-based access control can be circumvented](7.Access_Control/URL-based_access_control_can_be_circumvented.md#lab-url-based-access-control-can-be-circumvented)
    
  + ### 7.2 Horizontal Privilege Escalation
  
    + [Lab: User ID controlled by request parameter ](7.Access_Control/User_ID_controlled_by_request_parameter.md#lab-user-id-controlled-by-request-parameter)
    
    + [Lab: User ID controlled by request parameter, with unpredictable user IDs](7.Access_Control/User_ID_controlled_by_request_parameter%2C_with_unpredictable_user_IDs.md#lab-user-id-controlled-by-request-parameter-with-unpredictable-user-ids)
  
  + ### 7.3 Horizontal to Vertical Privilege Escalation
    
    + [Lab: User ID controlled by request parameter with password disclosure](7.Access_Control/User_ID_controlled_by_request_parameter_with_password_disclosure.md#lab-user-id-controlled-by-request-parameter-with-password-disclosure)
    
    + [Lab: Insecure direct object references](7.Access_Control/Insecure_direct_object_references.md#lab-insecure-direct-object-references)
    
    + [Lab: Multi-step process with no access control on one step](7.Access_Control/Multi-step_process_with_no_access_control_on_one_step.md#lab-multi-step-process-with-no-access-control-on-one-step)
    
    + [Lab: Referer-based access control](7.Access_Control/Referer-based_access_control.md#lab-referer-based-access-control)


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

  + ### 9.1 Common SSRF
  
    + [Lab: Basic SSRF against the local server](9.SSRF/Basic_SSRF_against_the_local_server.md#lab-basic-ssrf-against-the-local-server)
    
    + [Lab: Basic SSRF against another back-end system](9.SSRF/Basic_SSRF_against_another_back-end_system.md#lab-basic-ssrf-against-another-back-end-system)
  
  + ### 9.2 Circumventing common SSRF defenses
  
    + [Lab: SSRF with blacklist-based input filter](9.SSRF/SSRF_with_blacklist-based_input_filter.md#lab-ssrf-with-blacklist-based-input-filter)
    
    + [Lab: SSRF with whitelist-based input filter](9.SSRF/SSRF_with_whitelist-based_input_filter.md#lab-ssrf-with-whitelist-based-input-filter)
    
    + [Lab: SSRF with filter bypass via open redirection vulnerability](9.SSRF/SSRF_with_filter_bypass_via_open_redirection_vulnerability.md#lab-ssrf-with-filter-bypass-via-open-redirection-vulnerability)
  
  + ### 9.3 Blind SSRF
  
    + [Lab: Blind SSRF with out-of-band detection](9.SSRF/Blind_SSRF_with_out-of-band_detection.md#lab-blind-ssrf-with-out-of-band-detection)
    
    + [Lab: Blind SSRF with Shellshock exploitation](9.SSRF/Blind_SSRF_with_Shellshock_exploitation.md#lab-blind-ssrf-with-shellshock-exploitation)

## 10 XXE injection
[Back to Index](#index)

  + [Lab: Exploiting XXE using external entities to retrieve files](10.XXE/Exploiting_XXE_using_external_entities_to_retrieve_files.md#lab-exploiting-xxe-using-external-entities-to-retrieve-files)
  
  + [Lab: Exploiting XXE to perform SSRF attacks](10.XXE/Exploiting_XXE_to_perform_SSRF_attacks.md#lab-exploiting-xxe-to-perform-ssrf-attacks)
  
  + [Lab: Blind XXE with out-of-band interaction](10.XXE/Blind%20XXE_with_out-of-band_interaction.md#lab-blind-xxe-with-out-of-band-interaction)
  
  + [Lab: Blind XXE with out-of-band interaction via XML parameter entities](10.XXE/Blind_XXE_with_out-of-band_interaction_via_XML_parameter_entities.md#lab-blind-xxe-with-out-of-band-interaction-via-xml-parameter-entities)
  
  + [Lab: Exploiting blind XXE to exfiltrate data using a malicious external DTD](10.XXE/Exploiting%20blind%20XXE%20to%20exfiltrate%20data%20using%20a%20malicious%20external%20DTD.md#lab-exploiting-blind-xxe-to-exfiltrate-data-using-a-malicious-external-dtd)
  
  + [Lab: Exploiting blind XXE to retrieve data via error messages](10.XXE/Exploiting%20blind%20XXE%20to%20retrieve%20data%20via%20error%20messages.md#lab-exploiting-blind-xxe-to-retrieve-data-via-error-messages)
  
  + [Lab: Exploiting XXE to retrieve data by repurposing a local DTD](10.XXE/Exploiting%20XXE%20to%20retrieve%20data%20by%20repurposing%20a%20local%20DTD.md#lab-exploiting-xxe-to-retrieve-data-by-repurposing-a-local-dtd)
  
  + [Lab: Exploiting XInclude to retrieve files](10.XXE/Exploiting%20XInclude%20to%20retrieve%20files.md#lab-exploiting-xinclude-to-retrieve-files)
  
  + [Lab: Exploiting XXE via image file upload](10.XXE/Exploiting%20XXE%20via%20image%20file%20upload.md#lab-exploiting-xxe-via-image-file-upload)

# Client side attacks
---
## 11. Cross-site scripting (XSS)
[Back to Index](#index)

[Portswigger XSS Cheat sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet)

  + ### 11.1 Reflected XSS
  
    + [Lab: Reflected XSS into HTML context with nothing encoded](11.XSS/Reflected_XSS_no_encoding.md)
    
    + [Lab: Reflected XSS into HTML context with most tags and attributes blocked](11.XSS/Reflected%20XSS%20into%20HTML%20context%20with%20most%20tags%20and%20attributes%20blocked.md#lab-reflected-xss-into-html-context-with-most-tags-and-attributes-blocked)
    
    + [Lab: Reflected XSS into HTML context with all tags blocked except custom ones](11.XSS/Reflected%20XSS%20into%20HTML%20context%20with%20all%20tags%20blocked%20except%20custom%20ones.md#lab-reflected-xss-into-html-context-with-all-tags-blocked-except-custom-ones)
    
    + [Lab: Reflected XSS with event handlers and href attributes blocked](11.XSS/Reflected%20XSS%20with%20event%20handlers%20and%20href%20attributes%20blocked.md#lab-reflected-xss-with-event-handlers-and-href-attributes-blocked)
    
    + [Lab: Reflected XSS with some SVG markup allowed](11.XSS/Reflected%20XSS%20with%20some%20SVG%20markup%20allowed.md#lab-reflected-xss-with-some-svg-markup-allowed)
    
    + [Lab: Reflected XSS into attribute with angle brackets HTML-encoded](11.XSS/Reflected%20XSS%20into%20attribute%20with%20angle%20brackets%20HTML-encoded.md#lab-reflected-xss-into-attribute-with-angle-brackets-html-encoded)
    
    + [Lab: Reflected XSS in canonical link tag](11.XSS/Reflected%20XSS%20in%20canonical%20link%20tag.md#lab-reflected-xss-in-canonical-link-tag)
    
    + [Lab: Reflected XSS into a JavaScript string with single quote and backslash escaped](11.XSS/Reflected%20XSS%20into%20a%20JavaScript%20string%20with%20single%20quote%20and%20backslash%20escaped.md#lab-reflected-xss-into-a-javascript-string-with-single-quote-and-backslash-escaped)
    
    + [Lab: Reflected XSS into a JavaScript string with angle brackets HTML encoded](11.XSS/Reflected%20XSS%20into%20a%20JavaScript%20string%20with%20angle%20brackets%20HTML%20encoded.md#lab-reflected-xss-into-a-javascript-string-with-angle-brackets-html-encoded)
    
    + [Lab: Reflected XSS into a JavaScript string with angle brackets and double quotes HTML-encoded and single quotes escaped](11.XSS/Reflected%20XSS%20into%20a%20JavaScript%20string%20with%20angle%20brackets%20and%20double%20quotes%20HTML-encoded%20and%20single%20quotes%20escaped.md#lab-reflected-xss-into-a-javascript-string-with-angle-brackets-and-double-quotes-html-encoded-and-single-quotes-escaped)
    
    + [Lab: Reflected XSS into a template literal with angle brackets, single, double quotes, backslash and backticks Unicode-escaped](11.XSS/Reflected%20XSS%20into%20a%20template%20literal%20with%20angle%20brackets%2C%20single%2C%20double%20quotes%2C%20backslash%20and%20backticks%20Unicode-escaped.md#lab-reflected-xss-into-a-template-literal-with-angle-brackets-single-double-quotes-backslash-and-backticks-unicode-escaped)

  + ### 11.2 Stored XSS
  
    + [Lab: Stored XSS into HTML context with nothing encoded](11.XSS/Stored_XSS_into_html_no_encoding.md)

    + [Lab: Exploiting cross-site scripting to steal cookies](11.XSS/Exploiting%20cross-site%20scripting%20to%20steal%20cookies.md#lab-exploiting-cross-site-scripting-to-steal-cookies)
  
    + [Lab: Exploiting cross-site scripting to capture passwords](11.XSS/Exploiting%20cross-site%20scripting%20to%20capture%20passwords.md#lab-exploiting-cross-site-scripting-to-capture-passwords)
  
    + [Lab: Exploiting XSS to perform CSRF](11.XSS/Lab:%20Exploiting%20XSS%20to%20perform%20CSRF.md#lab-exploiting-xss-to-perform-csrf)
    
    + [Lab: Stored XSS into anchor href attribute with double quotes HTML-encoded](11.XSS/Stored%20XSS%20into%20anchor%20href%20attribute%20with%20double%20quotes%20HTML-encoded.md#lab-stored-xss-into-anchor-href-attribute-with-double-quotes-html-encoded)
    
    + [Lab: Stored XSS into onclick event with angle brackets and double quotes HTML-encoded and single quotes and backslash escaped](11.XSS/Stored%20XSS%20into%20onclick%20event%20with%20angle%20brackets%20and%20double%20quotes%20HTML-encoded%20and%20single%20quotes%20and%20backslash%20escaped.md#lab-stored-xss-into-onclick-event-with-angle-brackets-and-double-quotes-html-encoded-and-single-quotes-and-backslash-escaped)
  
  + ### 11.3 DOM Based XSS
  
    + [Lab: DOM XSS in document.write sink using source location.search](11.XSS/DOM_XSS_in_document.write_SINK_using_SOURCE_location.search.md)
  
    + [Lab: DOM XSS in innerHTML sink using source location.search](11.XSS/DOM_XSS_in_innerHTML_sink_using_source_location.search.md) 

    + [Lab: DOM XSS in document.write sink using source location.search inside a select element](11.XSS/DOM%20XSS%20in%20document.write%20sink%20using%20source%20location.search%20inside%20a%20select%20element.md#lab-dom-xss-in-documentwrite-sink-using-source-locationsearch-inside-a-select-element)
    
    + [Lab: DOM XSS in jQuery anchor href attribute sink using location.search source](11.XSS/DOM_XSS_in_jQuery_anchor_href_attribute_sink_using_location.search_source.md)
    
    + [Lab: DOM XSS in jQuery selector sink using a hashchange event](11.XSS/DOM%20XSS%20in%20jQuery%20selector%20sink%20using%20a%20hashchange%20event.md#lab-dom-xss-in-jquery-selector-sink-using-a-hashchange-event)
    
    + [Lab: DOM XSS in AngularJS expression with angle brackets and double quotes HTML-encoded](11.XSS/DOM%20XSS%20in%20AngularJS%20expression%20with%20angle%20brackets%20and%20double%20quotes%20HTML-encoded.md#lab-dom-xss-in-angularjs-expression-with-angle-brackets-and-double-quotes-html-encoded)
    
    + [Lab: Reflected DOM XSS](11.XSS/Reflected%20DOM%20XSS.md#lab-reflected-dom-xss)
    
    + [Lab: Stored DOM XSS](11.XSS/Stored%20DOM%20XSS.md#lab-stored-dom-xss)

## 12. Cross-site request forgery(CSRF)
[Back to Index](#index)

  + 12.1 CSRF with no Defenses

    + [Lab: CSRF vulnerability with no defenses](12.CSRF/CSRF%20vulnerability%20with%20no%20defenses.md#lab-csrf-vulnerability-with-no-defenses)

  + 12.2 Bypassing CSRF Token Validation
  
    + [Lab: CSRF where token validation depends on request method](12.CSRF/CSRF%20where%20token%20validation%20depends%20on%20request%20method.md#lab-csrf-where-token-validation-depends-on-request-method)
    
    + [Lab: CSRF where token validation depends on token being present](12.CSRF/CSRF%20where%20token%20validation%20depends%20on%20token%20being%20present.md#lab-csrf-where-token-validation-depends-on-token-being-present)
    
    + [Lab: CSRF where token is not tied to user session](12.CSRF/CSRF%20where%20token%20is%20not%20tied%20to%20user%20session.md#lab-csrf-where-token-is-not-tied-to-user-session)
    
    + [Lab: CSRF where token is tied to non-session cookie](12.CSRF/CSRF%20where%20token%20is%20tied%20to%20non-session%20cookie.md#lab-csrf-where-token-is-tied-to-non-session-cookie)
    
    + [Lab: CSRF where token is duplicated in cookie](12.CSRF/CSRF%20where%20token%20is%20duplicated%20in%20cookie.md#lab-csrf-where-token-is-duplicated-in-cookie)
  
  + 12.3 Bypassing CSRF SameSite Cookie 
  
    + [Lab: SameSite Strict bypass via client-side redirect](12.CSRF/SameSite%20Strict%20bypass%20via%20client-side%20redirect.md#lab-samesite-strict-bypass-via-client-side-redirect)
  
  + 12.4 Bypassing CSRF Referer-based defenses

## 13. Cross-origin resource sharing(CORS)
[Back to Index](#index)
## 14. Clickjacking
[Back to Index](#index)
## 15. DOM-based vulnerabilities
[Back to Index](#index)

  + [Lab: DOM XSS using web messages](15.DOM-Based_Vulnerabilities/Lab:%20DOM%20XSS%20using%20web%20messages.md#lab-dom-xss-using-web-messages)
  
  + [Lab: DOM XSS using web messages and a JavaScript URL](15.DOM-Based_Vulnerabilities/DOM%20XSS%20using%20web%20messages%20and%20a%20JavaScript%20URL.md#lab-dom-xss-using-web-messages-and-a-javascript-url)

## 16. WebSockets
[Back to Index](#index)

  + [Lab: Manipulating WebSocket messages to exploit vulnerabilities](16.WebSockets/Manipulating%20WebSocket%20messages%20to%20exploit%20vulnerabilities.md#lab-manipulating-websocket-messages-to-exploit-vulnerabilities)
  
  + [Lab: Manipulating the WebSocket handshake to exploit vulnerabilities](16.WebSockets/Manipulating%20the%20WebSocket%20handshake%20to%20exploit%20vulnerabilities.md#lab-manipulating-the-websocket-handshake-to-exploit-vulnerabilities)
  
  + [Lab: Cross-site WebSocket hijacking](16.WebSockets/Cross-site%20WebSocket%20hijacking.md#lab-cross-site-websocket-hijacking)


# Advanced Topics
---
## 17. Insecure deserialization
[Back to Index](#index)

  + [Lab: Modifying serialized objects](17.Insecure_deserialization/Modifying%20serialized%20objects.md#lab-modifying-serialized-objects)
  
  + [Lab: Modifying serialized data types](17.Insecure_deserialization/Modifying%20serialized%20data%20types.md#lab-modifying-serialized-data-types)

## 18. Server-side template injection
[Back to Index](#index)
## 19. Web cache poisoning
[Back to Index](#index)
## 20. HTTP Host header attacks
[Back to Index](#index)
## 21. HTTP reuest smuggling
[Back to Index](#index)
## 22. OAuth authentication

