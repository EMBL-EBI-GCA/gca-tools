#!/usr/bin/env perl

use strict;
use warnings;

use ReseqTrack::Tools::HipSci::ElasticsearchClient;
use List::Util qw();
use Data::Compare;
use Getopt::Long;

my $es_host = 'ves-pg-e3:9200';
my $outfile;

&GetOptions(
  "es_host=s" =>\$es_host,
  "outfile=s" => \$outfile,
);
die "missing credentials" if !$es_host || !$outfile;

my $elasticsearchserver = ReseqTrack::Tools::HipSci::ElasticsearchClient->new(host => $es_host);

my $scroll = $elasticsearchserver->call('scroll_helper',
  index       => 'hipsci',
  type        => 'cellLine',
  search_type => 'scan',
  size        => 500
);

open(my $fh, '>', $outfile) or die "Could not open file '$outfile' $!";
while ( my $doc = $scroll->next ) {
  if (defined $$doc{'_source'}{ebiscName}){
    print $fh $$doc{'_source'}{name}, "\t", (split /-/,$$doc{'_source'}{name})[-1], '###', $$doc{'_source'}{ebiscName}, "\t", $$doc{'_source'}{bioSamplesAccession}, "\n";
  }else{
    print $fh $$doc{'_source'}{name}, "\t", (split /-/,$$doc{'_source'}{name})[-1], "\t", $$doc{'_source'}{bioSamplesAccession}, "\n";
  }
}
close($fh);