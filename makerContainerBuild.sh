#PBS -l walltime=00:30:00
#PBS -l nodes=1:ppn=10
#PBS -N container.build
#PBS -A PAS1582

cd /fs/scratch/PAS1582/`whoami`

#these can be run without submitting job

#Download (from docker hub) and build maker image
singularity pull maker_version2.sif docker://wilberzach/maker:version2

#Copy maker control/configuration files to present working dir
cp ../HCS7194_Files/Genome_Annotation/maker_opts.training.ctl.* .
