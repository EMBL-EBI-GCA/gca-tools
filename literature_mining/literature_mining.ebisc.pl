#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
use ReseqTrack::EBiSC::IMS;
use ReseqTrack::EBiSC::XMLUtils qw(dump_xml);

my ($IMS_user, $IMS_pass);
my $outfile = '/nfs/production/reseq-info/work/rseqpipe/literature_mining_IDs/ebisc.tsv';

GetOptions("user=s" => \$IMS_user,
    "pass=s" => \$IMS_pass,
    "outfile=s" => \$outfile,
);

die "missing credentials" if !$IMS_user || !$IMS_pass;

my $IMS = ReseqTrack::EBiSC::IMS->new(
  user => $IMS_user,
  pass => $IMS_pass,
);

my @outlines;
open(my $fh, '>', $outfile) or die "Could not open file '$outfile' $!";
foreach my $line (@{$IMS->find_lines->{objects}}) {
  print $fh $line->{name}, "\t", join('###', @{$line->{alternative_names}}), "\t", $line->{biosamples_id}, "\n";
}
close($fh);