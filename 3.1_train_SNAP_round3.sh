#PBS -l walltime=00:10:00
#PBS -l nodes=1:ppn=14
#PBS -N trainSNAP_rnd3
#PBS -A PAS1582

module unload xalt

cd /fs/scratch/PAS1582/`whoami`
#mkdir snap
 
cd  snap 
mkdir round3
cd round3
export ZOE=/fs/scratch/PAS1582/HCS7194_Files/Genome_Annotation/bin/snap/Zoe 
# export 'ALL' gene models from MAKER and rename to something meaningful
singularity exec ../../maker_version2.sif /usr/local/bin/maker/bin/maker2zff -n -d ../../Almond_pred2.maker.output/Almond_pred2_master_datastore_index.log
#rename the 'genome.ann' and 'genome.dna' files:
#mv genome.ann Almd_rd1.zff.length50_aed0.25.ann
#mv genome.dna Almd_rd1.zff.length50_aed0.25.dna
export PATH=$PATH:/fs/scratch/PAS1582/HCS7194_Files/Genome_Annotation/bin/snap/
# gather some stats and validate
fathom genome.ann genome.dna -gene-stats > gene-stats.log 2>&1
fathom genome.ann genome.25.dna -validate > validate.log 2>&1
# collect the training sequences and annotations, plus 1000 surrounding bp for training
fathom genome.ann genome.dna -categorize 1000 > categorize.log 2>&1
fathom uni.ann uni.dna -export 1000 -plus > uni-plus.log 2>&1
# create the training parameters
mkdir params
cd params
forge ../export.ann ../export.dna > ../forge.log 2>&1
cd ..
# assembly the HMM
hmm-assembler.pl genome params > Almond_BC_rnd3.zff.hmm
