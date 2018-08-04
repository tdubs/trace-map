#!/usr/bin/perl
#
# apt-get install libnet-traceroute-perl
#
#
use Net::Traceroute;
use Getopt::Std;

my %args;
my %paths;

if ( @ARGV < 1 )
{
 print "-= TraceMap Usage =-\n";
 print " -x Scan 10.0.0.0/8 range\n";
 print " -y Scan 172.16.0.0/12 range\n";
 print " -z Scan 192.168.0.0/16 range\n";

}

getopt('a', \%args);

$ten = $args{x};
$oneseventwo = $args{y};
$oneninetwo = $args{z};


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

 print "[I] In trace function: $one.$two.$three.1\n";
 for ( $j = $one; $j <=$secOne; $j++ )
 {
  for ( $k = $two; $k <= $secTwo; $k++)
  {
   for ( $l = $three; $l <=$secThree; $l++)
   {
    $target = "$j" . ".$k" . ".$l" . ".1";
  $tr = Net::Traceroute->new(
        max_ttl => 5,
        queries => 1,
        host => $target);

  print "[I] Tracing to $target\n";
  
   if($tr->found) {
    my $hops = $tr->hops;
    $path = "";

    for ( $i = 0; $i <= $hops; $i++)
    {
        $path .= $tr->hop_query_host($i,0) . ",";
       # print "\t[-]Hop $i " . $tr->hop_query_host($i,0) . "\n";

    }
    print "Path: $path\n";
    $paths{$path} .= $target . ",";
    }
   }
  }
 }
}

