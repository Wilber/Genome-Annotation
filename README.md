
# Genome	Annnotation: Gene prediction & functional annotation


### Remarks
A beginner's guide [article](https://www.nature.com/articles/nrg3174) on genome assembly and annotation.
Download the MAKER container using [this](https://github.com/Wilber/Genome-Annotation/blob/master/makerContainerBuild.sh) script.
Analysis will be carried out on the Ohio Supercomputer Center. Make sure to name your working directory contained in /fs/scratch/PAS1582/ with the same name as your OSC user name. For instance, if my OSC username is **osu123**, then have your working directory as **/fs/scratch/PAS1582/osu123**
You will be annotating one Scaffold from the Almond genome assembly. 
## Genome	Annotation	Pipeline:	A summary	of	steps
The following is a summary	of	steps	involved	in	genome	annotation	using	MAKER pipeline. Note that prior identification of repeat elements is essential for genome sequence masking, before predicting genes. This step has already been run, and we will therefore not cover in class. However, interested parties can use [this](https://github.com/Wilber/Genome-Annotation/blob/master/repeat_identification.sh) script for repeat identification (uses RepeatMasker). 

1. Repeat	annotation	(De	novo repeat	identification). Already perfomed.
2. Initial	(round	1)	gene	feature	prediction	based	on	evidence
(expression	data,	homology,	repeat	annotation): 
3. Training	gene	prediction	software	(snap).	This	generates	a	snap
HMM	file
4. Run	MAKER	 ab	initio gene	prediction	(round	2)
5. Iteratively	Running	MAKER	to	Improve	Annotation:	repeat	step 3	(retrain	the	prediction	software)	and	step 4 ( ab	initio prediction).
A	couple	rounds	of	 ab	initio software	training	and	MAKER annotation	(	for	instance	3	rounds	total)	are	recommended.
6 .	Functional	annotation:
i)	Blast	the	MAKER	generated	protein	fasta	file	to
UniProt/SwissProt	with	blastp,	and	add	Uniprot results/functional	annotations	to	the	maker	GFF3	Notes
attribute.
ii)	Perform	InterProScan	and	update	the	MAKER	generated GFF3	file	with	the	InterProScan	results.	This	is	important	for identifying	predicted	gene	models	lacking	evidence	(AED=1)	but
containing	Pfam	protein	domains	in	their	protein	sequence.
7 .	Filter	gene	models	based	on	domain	content	and	evidence
support.	Visualize	models	on	a	genome	browser	such	as	IGV.
8 .	Estimate	proportion	of	genome	that	has	been	annotated,	using
BUSCO	(optional).

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


