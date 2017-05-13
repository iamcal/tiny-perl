#!/usr/bin/perl -w
use strict;
##########################################
my $title = "Tiny Counter by cal";
my $root = 'counter';
##########################################
open(FH,"$root/count.txt") or die;
my $c = <FH>+1;
close(FH);
open(FH,">$root/count.txt") or die;
print FH $c;
close(FH);
print qq(content-type: text/html\n\n);
print qq(<html><head><title>$title</title></head><body><b>$title</b><hr>);
foreach(split(//,"$c")){print qq(<img src="counter/$_.gif">);}
print qq(<hr><a href="source.pl?script=count.pl">View the source</a></body></html>);