#!/bin/bash

GCA_TOOLS=/nfs/production/reseq-info/work/rseqpipe/perl_code/gca-tools

perl $GCA_TOOLS/literature_mining/scripts/literature_mining.ebisc.pl -user $IMS_USER -pass $IMS_PASS -outfile /nfs/production/reseq-info/work/rseqpipe/literature_mining_IDs/ebisc.tsv \
&& perl $GCA_TOOLS/literature_mining/scripts/literature_mining.hpscreg.pl -user $hPSCreg_USER -pass $hPSCreg_PASS -outfile /nfs/production/reseq-info/work/rseqpipe/literature_mining_IDs/hpscreg.tsv