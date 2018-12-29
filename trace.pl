#!/usr/bin/perl
use Net::Traceroute::PurePerl;
use threads;
use Thread::Queue;

use Getopt::Std;

my %args;
my %paths :shared;

if ( @ARGV < 1 )
{
 print "   ---= TraceMap Usage =---\n";
 print " -x Scan 10.0.0.0/8 range\n";
 print " -y Scan 172.16.0.0/12 range\n";
 print " -z Scan 192.168.0.0/16 range\n";
 print "\n";
 print " -n X specify number of Threads, default is 20\n";
 print " -I use ICMP echo packets rather than UDP (requires root!)\n";
 print " -q X specify number of queries for a given hop, default is 1\n";
 print " -t X specify Max TTL, default is 5\n";
 print " -T use TCP SYN packets rather than UDP (requires root!)\n";
 print " -S scan range only scan every /24; e.g. 10.100.0.0-10.200.0.0\n";

}

getopt('qtnS', \%args);

my $DQ = Thread::Queue -> new();

$ten = $args{x};
$oneseventwo = $args{y};
$oneninetwo = $args{z};

$use_tcp = $args{T};
$use_icmp = $args{I};

$user_ttl = $args{t};
$queryCnt = $args{q};

$threadNum = $args{n};

$subnet = $args{S};

if ($subnet)
{
 #print "[I] target subnet: $subnet\n";
 @nets = split(/-/, $subnet);
 # print "subnet 1: $nets[0]\nsubnet 2: $nets[1]\n";

 @subOne = split(/\./, $nets[0]);
 #print " $subOne[0], $subOne[1], $subOne[2]\n";

 @subTwo = split(/\./, $nets[1]);
 #print " $subTwo[0], $subTwo[1], $subTwo[2]\n";

 #print " subOne: $subOne[0]\nsubOne: $subOne[1]\nsubOne: $subOne[2]\n
 #\nsubTwo: $subTwo[0]\nsubTwo: $subTwo[1]\nsubTwo: $subTwo[2]\n";

 print "[I] Configured to Scan $subnet\n";
 trace_class_c($subOne[0], $subOne[1], $subOne[2],$subTwo[0],$subTwo[1],$subTwo[2]);

}

$threads = 20;
if ($threadNum)
{
 $threads = $threadNum;
 print "[I] Threads: $threads\n";
}

$max_ttl = '5';
if ($user_ttl)
{
  $max_ttl = $user_ttl;
  print "[I] Max TTL: $user_ttl\n";

}

$queries = '1';
if ($queryCnt)
{
  $queries = $queryCnt;
  print "[I] Querying Each Host $queryCnt times\n";

}

if( $use_icmp)
{
  print "[I] Using ICMP Echo Packets\n";
  $use_icmp = "use_icmp";
}

if( $use_tcp)
{
  print "[I] Using TCP SYN Packets\n";
  $use_tcp = "use_tcp";
}

if ($oneninetwo)
{
 print "[I] Configured to Scan 192.168.0.0/16\n";
 trace_class_c('192', '168', '0', '192','168','255'); 
}
if ($oneseventwo)
{
 print "[I] Configured to Scan 172.16.0.0/12\n";
 trace_class_c('172', '16', '0', '172','31','255'); 

}
if ($ten)
{
 print "[I] Configured to Scan 10.0.0.0/8\n";
 trace_class_c('10', '0', '0', '10','255','255'); 

}


for ( 1..$threads)
{
  #print "[D] creating thread\n";
    $kid = threads->create(\&trace_host);
    #$kid -> detach();
}

while ($cur = $DQ->peek() )
{
 # print "[-] Still Looping: $cur\n";
 sleep (1);
}
foreach my $thr ( threads -> list() )
{
  #print "PLIK thread\n";
  $thr -> detach();
  #$thr -> join();
}

#foreach my $key (keys %hash) { ... }
print "======================\n";

my @list = keys %paths;
foreach $item (@list)
{
 print "Path $item\n";
 print "-- Nets:  $paths{$item}\n";
}


sub trace_class_c()
{
 my ($one, $two, $three, $secOne, $secTwo, $secThree) = @_;

 print "[I] In trace function: $one.$two.$three.1 - $secOne.$secTwo.$secThree.1\n";
 for ( $j = $one; $j <=$secOne; $j++ )
 {
  for ( $k = $two; $k <= $secTwo; $k++)
  {
   for ( $l = $three; $l <=$secThree; $l++)
   {
    $target = "$j" . ".$k" . ".$l" . ".1";
    #print "[I] added $target to queue\n";

    $DQ -> enqueue($target);

   }
  }
 }
 $DQ -> end();
 #print "[D] Ending Queue\n";
 #for ( 1..$threads )
 #{
 # $DQ -> end();
  #$DQ -> enqueue(undef);
 # }
}


sub trace_host()
{
 while ( $target = $DQ->dequeue_nb()){
 #my ($target) = @_;
     $tr = new Net::Traceroute::PurePerl(
     backend        => 'PurePerl', # this optional
     host           => $target,
     debug          => 0,
     max_ttl        => $max_ttl,
     query_timeout  => $queries,
     packetlen      => 40,
     protocol       => 'udp', # Or icmp
        );
  print "[I] Tracing to $target  ";
  $tr->traceroute;
   if($tr->found) {
    my $hops = $tr->hops;
    $path = "";

    for ( $i = 0; $i <= $hops; $i++)
    {
        $path .= $tr->hop_query_host($i,0) . ",";
        #print "\t[-]Hop $i " . $tr->hop_query_host($i,0) . "\n";

    }
    print "Path: $path\n";
    $paths{$path} .= $target . ",";
    }
 }
 #print "[D] Exiting Thread\n";
 return;
}
