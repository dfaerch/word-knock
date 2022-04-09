# Word Knock
A simple portknocking alternative, using a password and iptables.

Block eg. ssh port from brute-forcers, but allow a simple password to open the port, so real users can attempt login.
Upon recieving correct password, open the port for new connections, to the src-ip, in one hour. (existing
connections are still open outside this window) 

This is pure iptables stuff and doesnt require a userspace daemon or a custom made client. Password can 
be sent over UDP, eg. with netcat, and ICMP with the ping command (tested on Linux and Mac.)
 
## UDP example:
```
  $ echo open_sesame | nc -u my-server.example.com 22
```

## ICMP example:
Ping takes the password as hex, so we need to convert it first. use eg. an online "string to hex" converter or somthing from the command line, like xxd. Also note: ping allows up to 16 bytes max.
```
  $ echo -n open_sesame | xxd -ps
  6f70656e5f736573616d65
```

Now send that password
```
$ ping -p "6f70656e5f736573616d65" my-server.example.com
```

## Notes on security
- Word Knocking shouldn't be used *instead* of good authentication, but in addition to. 
- The password is sent unencrypted, so dont use something used for anything else, but still chose something hard to guess. 

