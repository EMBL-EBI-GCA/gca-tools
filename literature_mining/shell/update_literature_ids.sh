#!/bin/bash

SERVER1=$1

perl $GCA_TOOLS/literature_mining/scripts/literature_mining.ebisc.pl -user $IMS_USER -pass $IMS_PASS -outfile /nfs/production/reseq-info/work/rseqpipe/literature_mining_IDs/ebisc.tsv \
&& perl $GCA_TOOLS/literature_mining/scripts/literature_mining.hipsci.pl -es_host=$SERVER1:9200 \
#&& perl $GCA_TOOLS/literature_mining/scripts/literature_mining.hpscreg.pl -user $HPSCREG_USER -pass $HPSCREG_PASS -outfile /nfs/production/reseq-info/work/rseqpipe/literature_mining_IDs/hpscreg.tsv