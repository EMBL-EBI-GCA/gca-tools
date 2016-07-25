#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
use ReseqTrack::EBiSC::hESCreg; 

#FIXME Rewrite to read in data from BioSamples so that we know what is allowed to be public

my ($hPSCreg_user, $hPSCreg_pass, $outfile);

GetOptions("user=s" => \$hPSCreg_user,
    "pass=s" => \$hPSCreg_pass,
    "outfile=s" => \$outfile,
);

die "missing credentials" if !$hPSCreg_user || !$hPSCreg_pass || !$outfile;

my $hPSCreg = ReseqTrack::EBiSC::hESCreg->new(
  user => $hPSCreg_user,
  pass => $hPSCreg_pass,
);

open(my $fh, '>', $outfile) or die "Could not open file '$outfile' $!";
LINE:
foreach my $line_name (@{$hPSCreg->find_lines()}) {
  my $line = eval{$hPSCreg->get_line($line_name);};
  next LINE if !$line || $@;
  my $alt_name = $line->{alternate_name} ? join('###', @{$line->{alternate_name}}) : "";
  my $bioid = $line->{biosamples_id} ? $line->{biosamples_id} : "";
  print $fh $line_name, "\t", $alt_name, "\t", $bioid, "\n";
}
close($fh);
