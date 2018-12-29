# trace-map
Map a networks layer 3 subnets and paths utilizing traceroute and packet TTLs
Options to automatically scan all RFC1918 address ranges using a 24 bit subnet mask or specify a range.

# Necessary libraries:
apt-get install libnet-traceroute-pureperl-perl

```
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
```



# Example Trace Custom Rangees:
```
root@box:# ./trace.pl -n 90 -S 1.1.1.0-1.1.250.0 
[I] Configured to Scan 1.1.1.0-1.1.250.0
[I] In trace function: 1.1.1.1 - 1.1.250.1
[I] Threads: 90
[I] Tracing to 1.1.1.1  Path: 1.1.1.1,45.55.64.254,138.197.251.30,138.197.244.26,198.32.118.206,1.1.1.1,
[I] Tracing to 1.1.20.1  Path: 134.159.48.37,45.55.64.254,138.197.251.30,138.197.244.34,66.110.96.25,134.159.48.37,
[I] Tracing to 1.1.64.1  Path: 202.147.0.202,45.55.64.254,138.197.251.20,138.197.244.18,198.32.118.164,202.147.0.202,
```
