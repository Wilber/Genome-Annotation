#PBS -l walltime=00:15:00
#PBS -l nodes=1:ppn=20
#PBS -N funcAnnoInterpro
#PBS -A PAS1582

module unload xalt

cd /fs/scratch/PAS1582/`whoami`

#######InterProScan: Search PfamA for protein domains in the predicted proteins
#outputs to a .tsv file
../HCS7194_Files/Genome_Annotation//interproscan-5.34-73.0/interproscan.sh -appl PfamA -iprlookup -goterms -f tsv -i Scaffold_1.maker.proteins.renamed.func.blast.fasta -cpu 20

#Update the MAKER generated GFF3 file with the InterProScan results using ipr_update_gff.
singularity exec  maker_version2.sif /usr/local/bin/maker/bin/ipr_update_gff Almond_pred3.all.maker.noseq.func.blast.gff Scaffold_1.maker.proteins.renamed.func.blast.fasta.tsv > Almond_pred3.all.maker.noseq.func.blast.ipr.gff 

####Get IPR report, for instance top 100 domains:
#Obtain script here: https://github.com/mscampbell/Genome_annotation/blob/master/pfam_domain_report.pl
#./pfam_domain_report.pl ../Almond_assembly_Dovetail.func.blast.ipr.standard.gff >pfam.domain.report
#Get descriptions for the pfam ids:
#cut -f5,6 Scaffold_1.maker.proteins.renamed.func.blast.fasta.tsv |  sort -k1 | uniq > pfam_descriptions.txt
#awk 'NR==FNR {h[$1] = $2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10; next} {print $1,$2,h[$1]}' pfam_descriptions.txt domain.report > domain.report.with.descrpn
