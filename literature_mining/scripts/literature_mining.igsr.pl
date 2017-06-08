#!/usr/bin/env perl

#Creates text file of identifers conforming to convention in ../../README.md
#Obtains identifiers from IGSR ElasticSeach


use strict;
use warnings;
use Getopt::Long;
use Search::Elasticsearch;

my $es_host = 'ves-hx-e4:9200';
my $outfile;

&GetOptions(
  "es_host=s" =>\$es_host,
  "outfile=s" => \$outfile,
);
die "missing credentials" if !$es_host || !$outfile;

my $elasticsearchserver = Search::Elasticsearch->new(nodes => "$es_host", client => '1_0::Direct');

my $scroll = $elasticsearchserver->scroll_helper(
  index       => 'igsr',
  type        => 'sample',
  search_type => 'scan',
  size        => 500
);
open(my $fh, '>', $outfile) or die "Could not open file '$outfile' $!";
SAMPLE:
while ( my $doc = $scroll->next ) {
  next SAMPLE if !$$doc{'_source'}{biosampleId};
  if ($$doc{'_source'}{name} =~ /^NA/){
    my $altname = $$doc{'_source'}{name};
    $altname =~ s/^NA/GM/;
    print $fh $$doc{'_source'}{name}, "\t", $altname, "\t", $$doc{'_source'}{biosampleId}, "\n";
  }else{
    print $fh $$doc{'_source'}{name}, "\t", "\t", $$doc{'_source'}{biosampleId}, "\n";
  }
}
close($fh);