# trace-map
Map a networks layer 3 subnets and paths utilizing traceroute and packet TTLs
Options to automatically scan all RFC1918 address ranges using a 24 bit subnet mask or specify a range.

# Necessary libraries:
apt-get install libnet-traceroute-pureperl-perl

'''
root@box:# ./trace.pl 
   ---= TraceMap Usage =---
 -x Scan 10.0.0.0/8 range
 -y Scan 172.16.0.0/12 range
 -z Scan 192.168.0.0/16 range

 -n X specify number of Threads, default is 20
 -I use ICMP echo packets rather than UDP (requires root!)
 -q X specify number of queries for a given hop, default is 1
 -t X specify Max TTL, default is 5
 -T use TCP SYN packets rather than UDP (requires root!)
 -S scan range only scan every /24; e.g. 10.100.0.0-10.200.0.0
'''
