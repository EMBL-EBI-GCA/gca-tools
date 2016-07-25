#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use Search::Elasticsearch;

my $es_host = 'ves-hx-e4:9200';

&GetOptions(
  'es_host=s' =>\$es_host,
);

my $elasticsearchserver = Search::Elasticsearch->new(nodes => "$es_host", client => '1_0::Direct');

my $scroll = $elasticsearchserver->scroll_helper(
  index       => 'igsr_beta',
  type        => 'sample',
  search_type => 'scan',
  size        => 500
);
SAMPLE:
while ( my $doc = $scroll->next ) {
  next SAMPLE if !$$doc{'_source'}{biosampleId};
  if ($$doc{'_source'}{name} =~ /^NA/){
    my $altname = $$doc{'_source'}{name};
    $altname =~ s/^NA/GM/;
    print $$doc{'_source'}{name}, "\t", $altname, "\t", $$doc{'_source'}{biosampleId}, "\n";
  }else{
    print $$doc{'_source'}{name}, "\t", "\t", $$doc{'_source'}{biosampleId}, "\n";
  }
}