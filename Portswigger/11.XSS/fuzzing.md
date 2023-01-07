# Fuzzing for XSS

These are based off of the [XSS Cheat Sheet](https://portswigger.net/web-security/cross-site-scripting/cheat-sheet). If testing for tags, events within HTML context use that following to see what isn't going to be blocked. Note the fuzzing method will need to be modified if angle brackets (`<>`) are being blocked, but the concept is very similar

# Step 1 Fuzz for allowed tags

This can be done using [this file](11.XSS/tags), where you send a payload such as:

```html
<FUZZ>
```

Then using burp intruder or a cli program like wfuzz and set the fuzzing position to the word fuzz. The requests that return status code 200 are not blocked and therefore will be tags that can be used for your payload.

# Step 2 Fuzz for allowed events

Lets say for example the following returned a 200 response and wasn't blocked:

```html
<svg><animatetransform>
```
To test for events use [this file](11.XSS/events) containing all events and build a second fuzzing payload with the following format, recplacing FUZZ with the payloads from the events list:

```html
<svg><animatetransform%20FUZZ=1>
```

The events that return a response code of 200 are not being blocked and will be valid for the POC payload to find XSS.
