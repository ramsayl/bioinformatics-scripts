#!/usr/bin/perl
use strict;


my $agp = $ARGV[0]; #standard AGP format file name
my $map = $ARGV[1]; #any tab-sep file with unitig positions
my $maputg = $ARGV[2]; # 0-based column number corresponding to unitig
my $mappos = $ARGV[3]; # 0-based column number corresponditing to position on unitig


my $href;

open(FH, $agp);
while(<FH>){
    chomp;
    my @a = split(/\t/, $_);
    if ($a[4] eq "W"){
        $href->{$a[5]}->{'chr'} = $a[0];
        if ($a[8] eq "-"){
            $href->{$a[5]}->{'start'} = $a[2];
        } else {
            $href->{$a[5]}->{'start'} = $a[1];
        }
        $href->{$a[5]}->{'direction'} = $a[8] ;
    }
}
close FH;

open(FH, $map);
while(<FH>){
    chomp;
    my @a = split(/\t/, $_);
    my $chr = $href->{$a[$maputg]}->{'chr'};
    my $pos;
    if ($href->{$a[$maputg]}->{'direction'} eq "-"){
       $pos = $href->{$a[$maputg]}->{'start'} - $a[$mappos] + 1;
    } else {
       $pos = $href->{$a[$maputg]}->{'start'} + $a[$mappos] -1;
    }
    print "$_\t$chr\t$pos\n";
}

