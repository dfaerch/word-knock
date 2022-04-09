#!/bin/sh
# Word Knocking - Portknocking alternative. 

# ------ Settings -------

# The port you want to open - also the port you send your UDP request.
PORT="22"
# Password that opens up the port
PASSWORD="open_sesame"


# -----------

# This script first deletes its own iptables entires, so i can run it again and again while playing around with it
# -- Cleanup and setup
# Delete the hooks from input
iptables -D INPUT -p TCP -m multiport --dports $PORT -j KNOCKING
iptables -D INPUT -p UDP -m multiport --dports $PORT -j KNOCKING

# Create and/or flush KNOCKING chain
iptables -N KNOCKING
iptables -F KNOCKING

# Destroy & Create the ipset
ipset destroy whitelist 
ipset create whitelist hash:ip timeout 3600
#--------


# Install "knocking"
# -------------------
# Create hooks in INPUT table
iptables -A INPUT -p TCP -m multiport --dports $PORT -j KNOCKING
iptables -A INPUT -p UDP -m multiport --dports $PORT -j KNOCKING
iptables -A INPUT -p ICMP -j KNOCKING

# allow password over UDP
iptables -A KNOCKING -p UDP -m string --algo bm --string $PASSWORD --to 256 -j SET --add-set whitelist src
iptables -A KNOCKING -p UDP -j RETURN

# allow password over ICMP
iptables -A KNOCKING -p ICMP -m string --algo bm --string $PASSWORD --to 256 -j SET --add-set whitelist src
iptables -A KNOCKING -p ICMP -j RETURN

# If IP is in whitelist-set, allow
iptables -A KNOCKING -m set --match-set whitelist src -j ACCEPT
# Else reject
iptables -A KNOCKING -p TCP -m state --state NEW -j REJECT




