#PBS -l walltime=00:30:00
#PBS -l nodes=1:ppn=10
#PBS -N container.build
#PBS -A PAS1582


cd /users/PAS0107/osu6702/project/annotation/annotation_class

singularity pull maker_version2.sif docker://wilberzach/maker:version2
