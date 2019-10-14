#PBS -l walltime=00:20:00
#PBS -l nodes=1:ppn=20
#PBS -N funcAnnoUniprot
#PBS -A PAS1582

module unload xalt

cd /fs/scratch/PAS1582/`whoami`


#create a mapping file for renaming gene IDs:
singularity exec maker_version2.sif /usr/local/bin/maker/bin/maker_map_ids --prefix PDul_ --justify 8 Almond_pred3.all.maker.noseq.gff > genome.id.map

#Load blast
module load blast/2.4.0+ 

#Functional annotation based on protein homology
#create a Uniprot protein db
cp ../HCS7194_Files/Genome_Annotation/uniprot_sprot.fasta .
makeblastdb -in uniprot_sprot.fasta -input_type fasta -dbtype prot

##get the protein sequences from gff files:
cd Almond_pred3.maker.output
#for i in `grep "FINISHED" Almond_pred3_master_datastore_index.log | cut -f2`; do cat "$i"*.maker.proteins.fasta >>maker.proteins.fasta ; done
# mv maker.proteins.fasta ../
dir=`cut -f2 Almond_pred3_master_datastore_index.log | head -1`  
cp $dir*maker.proteins.fasta ../
cd ../

#Blast the MAKER generated protein fasta file to UniProt/SwissProt with blastp
blastp -db uniprot_sprot.fasta -query Scaffold_1.maker.proteins.fasta -out maker.proteins.blastp -evalue .0001 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -max_hsps 1 -num_threads 20

#Rename IDs in blast output, maker gff, and maker proteins. First, create copies, renames inplace 
cp Almond_pred3.all.maker.noseq.gff Almond_pred3.all.maker.noseq.renamed.gff
cp Scaffold_1.maker.proteins.fasta Scaffold_1.maker.proteins.renamed.fasta
cp maker.proteins.blastp maker.proteins.renamed.blastp

singularity exec maker_version2.sif /usr/local/bin/maker/bin/map_gff_ids genome.id.map Almond_pred3.all.maker.noseq.renamed.gff
singularity exec maker_version2.sif /usr/local/bin/maker/bin/map_fasta_ids genome.id.map Scaffold_1.maker.proteins.renamed.fasta
singularity exec maker_version2.sif /usr/local/bin/maker/bin/map_data_ids genome.id.map maker.proteins.renamed.blastp

##Update the annotation gff file & protein fasta file with functional info:
#Functional annotation included as a "Note:" in gff file
singularity exec maker_version2.sif /usr/local/bin/maker/bin/maker_functional_gff uniprot_sprot.fasta maker.proteins.renamed.blastp Almond_pred3.all.maker.noseq.renamed.gff > Almond_pred3.all.maker.noseq.func.blast.gff 
singularity exec maker_version2.sif /usr/local/bin/maker/bin/maker_functional_fasta uniprot_sprot.fasta  maker.proteins.renamed.blastp Scaffold_1.maker.proteins.renamed.fasta > Scaffold_1.maker.proteins.renamed.func.blast.fasta 
#singularity exec maker_version2.sif /usr/local/bin/maker_functional_fasta ../functionalAnno/uniprot_sprot.fasta maker.proteins.blastp  maker.transcripts.fasta > maker.transcripts.func_blast.fasta
