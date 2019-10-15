
# Genome	Annnotation: Gene prediction & functional annotation

### Remarks
 * Download the MAKER container using [this](https://github.com/Wilber/Genome-Annotation/blob/master/makerContainerBuild.sh) script.
* Analysis will be carried out on the Ohio Supercomputer Center. Make sure to name your working directory contained in /fs/scratch/PAS1582/ with the same name as your OSC user name. For instance, if my OSC username is **osu123**, then have your working directory as **/fs/scratch/PAS1582/osu123**
* You will be annotating one Scaffold from the Almond genome assembly. 
## MAKER :	A summary	of	steps
The following is a summary	of	steps	involved	in	genome	annotation	using	MAKER pipeline. Note that prior identification of repeat elements is essential for genome sequence masking, before predicting genes. This step has already been run, and we will therefore not cover in class. However, interested parties can use [this](https://github.com/Wilber/Genome-Annotation/blob/master/repeat_identification.sh) script for repeat identification (uses RepeatMasker). 
### 1.0 Initial	MAKER analysis (round 1  training):	
Gene model prediction	based	on	evidence (expression	data,	protein sequence data,	repeat	annotation). Resulting GFF used to train [SNAP](https://github.com/KorfLab/SNAP) gene finder.
Code: [1.0_annotation_training.sh](https://github.com/Wilber/Genome-Annotation/blob/master/1.0_annotation_training.sh)
### 1.1. Train SNAP (round 1)
Initial training of SNAP gene finder. This	generates an HMM file/classifier for the first round of gene prediction using SNAP and AUGUSTUS gene finders, next section.
Code: [1.1_train_SNAP_round1.sh](https://github.com/Wilber/Genome-Annotation/blob/master/1.1_train_SNAP_round1.sh)
### 2.0. Round 1 of maker prediction 
First iteration of gene predictions employing a bootstrap approach. Predict gene models using SNAP and AUGUSTUS gene finders, using the HMM classifier generated in section 1.1 above. The reulting GFFs will be used for re-training the HMM classifier. 
Code: [2.0_annotation_prediction_1.sh](https://github.com/Wilber/Genome-Annotation/blob/master/2.0_annotation_prediction_1.sh)
### 2.1. Train SNAP (round 2)
Round 2 of SNAP training. 
Code: [2.1_trains_SNAP_round2.sh](https://github.com/Wilber/Genome-Annotation/blob/master/2.1_train_SNAP_round2.sh)
Subsequent steps are iterations of predicting models and training HMM. A total of 3 training iterations recommended (to prevent overfitting).
### 3.0. Round 2 of maker prediction
Code: [3.0_annotation_prediction_2.sh](https://github.com/Wilber/Genome-Annotation/blob/master/3.0_annotation_prediction_2.sh)
### 3.1. Train SNAP (round 3)
Final iteration for training the HMM. 
Code: [3.1_train_SNAP_round3.sh](https://github.com/Wilber/Genome-Annotation/blob/master/3.1_train_SNAP_round3.sh)
### 4.0. Round 3 of maker prediction
Final round of MAKER gene model predictions.
Code: [4.0_annotation_prediction_3.sh](https://github.com/Wilber/Genome-Annotation/blob/master/4.0_annotation_prediction_3.sh)
### 5.0. Functional	annotation:
### 5.1. Uniprot/SwissProt blastp
Blast the	MAKER	generated	protein	sequences	to UniProt/SwissProt	with	blastp,	and	add	Uniprot results/functional	annotations	to	the	maker	GFF3 file as a	'Notes' attribute.
Code: [5.1_uniprot.sh](https://github.com/Wilber/Genome-Annotation/blob/master/5.1_uniprot.sh)
### 5.2. InterProScan
Search Pfam database for protein domains in the predicted proteins;	and	update	the	MAKER	generated GFF3	file	with	the	InterProScan	results.	This	is	important	for identifying	predicted	gene	models	lacking	evidence	(AED=1)	but containing	Pfam protein	domains	in	their	protein	sequence. Pfam search also provides GO terms, hence additional functional annotation.
Code: [5.2_interProScan.sh](https://github.com/Wilber/Genome-Annotation/blob/master/5.2_interProScan.sh)
### 6.0. Final gene models
Filter	gene	models	based	on	domain	content (pfam)	and	evidence support.	Visualize	models	on	a	genome	browser	such	as	[Jbrowse](http://jbrowse.org/).


## Software

### A)	Maker	bioconda	installation:

First	install	conda	(if	not	installed).
On	Linux,	run:

```sh
wget	https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh	Miniconda3-latest-Linux-x86_64.sh
```
Follow	the	instructions	in	the	installer.	If	you	encounter	problems,	refer to	the	[Miniconda](https://conda.io/en/latest/miniconda.html) documentation.
Add	conda	to	PATH	environment:

```sh
cd
```

```sh
nano	.bashrc
```
Add	the	following	to	the	opened	.bashrc:
```sh
export	PATH=$PATH:/path/to/miniconda3/bin
```
Close	.bashrc	(CTRL	+X)
Then	run:
```sh
source	.bashrc
conda	config	--add	channels	defaults
conda	config	--add	channels	bioconda
conda	config	--add	channels	conda-forge
```
Install	MAKER
NOTE:	It	seems	MAKER	uses	Python2.7,	not	3,	therefore	downgrade	the
Python	in	miniconda.
Run:
```sh
conda	install	python=2.
```
Follow	prompts,	accept	all.	Alternativey,	switch	between	Python	2	and	environments,	see	[here](https://docs.anaconda.com/anaconda/user-guide/tasks/switch-environment/).
Install	MAKER:
```sh
conda	install	maker
```
### B)	Maker	(bio)container	installation:
Make	sure	docker	is	installed	on	your	machine. On	your	machine,	run:
```sh
docker	pull	quay.io/biocontainers/maker:<tag>
```
see	maker/tags for	valid	values	for	<tag>
For	instance:
```sh
docker	pull	quay.io/biocontainers/maker:2.31.10--pl526_13
```
List	docker	iamges	on	your	machine:
```sh
docker	images
```
Run	the	image	(create	a	container)
```sh
docker	run	-d	-it	<image	ID	#>	/bin/bash
```
List	containers
```sh
docker	ps
```
Rename	container
```sh
docker	commit	<container	ID>	wilberzach/maker:biocontaine
rversion
```
Upload	to	dockerhub	repository

```sh
docker	login	-u	wilberzach	-p	<dockerhub	passwd>
docker	push	wilberzach/maker:biocontainerversion
```
Create/dowload	a	singularity	image	nn	OSC	(Linux	System). Since	the	image	is	large,	run	an	interactive	batch	for	downloading image	and	creating	a	Singularity	equivalent:

```sh
qsub	-l	nodes= 1 :ppn= 10	 -l	walltime= 00 : 45 : 00 	-A	<PROJECT	ID>
```
When	the	job	starts	running,	run:
```sh
singularity	pull	maker_biocontainer.sif	docker://wilberzach/maker:biocontainerversion
```
**Recommended reads**
* A beginner's guide on on genome assembly and annotation can be found [here](https://www.nature.com/articles/nrg3174).
* [What is a Hidden markov Model](https://www.nature.com/articles/nbt1004-1315)?
