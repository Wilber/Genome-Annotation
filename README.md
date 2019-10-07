# Dillinger

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)
# Genome	Annnotation

## Genome	Annotation	Pipeline:	A summary	of	steps
# DONE!!!
Summary	of	steps	involved	in	genome	annotation	using	MAKER
pipeline:

1. Repeat	annotation	( De	novo repeat	identification)
2. Initial	(round	1)	gene	feature	prediction	based	on	evidence
(expression	data,	homology,	repeat	annotation)
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
## Runninng	MAKER	annotation

## pipeline

[RepeatModeler](http://www.repeatmasker.org/RepeatModeler/) and	[RepeatMasker](http://www.repeatmasker.org/RepeatModeler/) with	all	dependencies
MAKER	or	MAKER	MPI	docker	image	(obtained	from	this repository)


Augustus	version	3.2.3.
BUSCO	version	2.0.1.
SNAP	version	2006-07-28.
BEDtools	version	2.17.0.

```
Import	a	HTML	file	and	watch	it	magically	convert	to	Markdown
Drag	and	drop	images	(requires	your	Dropbox	account	be
linked)
```
You	can	also:

```
Import	and	save	files	from	GitHub,	Dropbox,	Google	Drive	and
One	Drive
Drag	and	drop	markdown	and	HTML	files	into	Dillinger
Export	documents	as	Markdown,	HTML	and	PDF
```
Markdown	is	a	lightweight	markup	language	based	on	the	formatting
conventions	that	people	naturally	use	in	email.	As	John	Gruber writes	on
the	Markdown	site

```
The	overriding	design	goal	for	Markdown’s
formatting	syntax	is	to	make	it	as	readable
as	possible.	The	idea	is	that	a
Markdown-formatted	document	should	be
publishable	as-is,	as	plain	text,	without
looking	like	it’s	been	marked	up	with	tags
or	formatting	instructions.
```
This	text	you	see	here	is	 _actually_ written	in	Markdown!	To	get	a	feel	for


Markdown’s	syntax,	type	some	text	into	the	left	window	and	watch	the
results	in	the	right.

### Tech

Dillinger	uses	a	number	of	open	source	projects	to	work	properly:

```
AngularJS -	HTML	enhanced	for	web	apps!
Ace	Editor -	awesome	web-based	text	editor
markdown-it -	Markdown	parser	done	right.	Fast	and	easy	to
extend.
Twitter	Bootstrap -	great	UI	boilerplate	for	modern	web	apps
node.js -	evented	I/O	for	the	backend
Express -	fast	node.js	network	app	framework	@tjholowaychuk
Gulp -	the	streaming	build	system
Breakdance -	HTML	to	Markdown	converter
jQuery -	duh
```
And	of	course	Dillinger	itself	is	open	source	with	a	public	repository
on	GitHub.

### Installation

Dillinger	requires	Node.js v4+	to	run.

Install	the	dependencies	and	devDependencies	and	start	the	server.

```
$	cd	dillinger
```

```
$	npm	install	-d
$	node	app
```
For	production	environments...

```
$	npm	install	--production
$	NODE_ENV=production	node	app
```
### Plugins

Dillinger	is	currently	extended	with	the	following	plugins.	Instructions
on	how	to	use	them	in	your	own	application	are	linked	below.

```
Plugin README
Dropbox plugins/dropbox/README.md
GitHub plugins/github/README.md
Google	Drive plugins/googledrive/README.md
OneDrive plugins/onedrive/README.md
Medium plugins/medium/README.md
Google	Analytics plugins/googleanalytics/README.md
```
### Development

Want	to	contribute?	Great!


Dillinger	uses	Gulp	+	Webpack	for	fast	developing.
Make	a	change	in	your	file	and	instantanously	see	your	updates!

Open	your	favorite	Terminal	and	run	these	commands.

First	Tab:

```
$	node	app
```
Second	Tab:

```
$	gulp	watch
```
(optional)	Third:

```
$	karma	test
```
#### Building	for	source

For	production	release:

```
$	gulp	build	--prod
```
Generating	pre-built	zip	archives	for	distribution:

```
$	gulp	build	dist	--prod
```

### Docker

Dillinger	is	very	easy	to	install	and	deploy	in	a	Docker	container.

By	default,	the	Docker	will	expose	port	8080,	so	change	this	within	the
Dockerfile	if	necessary.	When	ready,	simply	use	the	Dockerfile	to	build
the	image.

```
cd	dillinger
docker	build	-t	joemccann/dillinger:${package.json.version
}	.
```
This	will	create	the	dillinger	image	and	pull	in	the	necessary
dependencies.	Be	sure	to	swap	out	${package.json.version} with	the
actual	version	of	Dillinger.

Once	done,	run	the	Docker	image	and	map	the	port	to	whatever	you
wish	on	your	host.	In	this	example,	we	simply	map	port	8000	of	the	host
to	port	8080	of	the	Docker	(or	whatever	port	was	exposed	in	the
Dockerfile):

```
docker	run	-d	-p	 8000 : 8080 	--restart="always"	<youruser>/d
illinger:${package.json.version}
```
Verify	the	deployment	by	navigating	to	your	server	address	in	your
preferred	browser.


##### 127.0.0.1: 8000

#### Kubernetes	+	Google	Cloud

See	KUBERNETES.md

### Todos

```
Write	MORE	Tests
Add	Night	Mode
```
## License

##### MIT

**Free	Software,	Hell	Yeah!**






| Plugin | README |
| ------ | ------ |
| Dropbox | [plugins/dropbox/README.md][PlDb] |
| GitHub | [plugins/github/README.md][PlGh] |
| Google Drive | [plugins/googledrive/README.md][PlGd] |
| OneDrive | [plugins/onedrive/README.md][PlOd] |
| Medium | [plugins/medium/README.md][PlMe] |
| Google Analytics | [plugins/googleanalytics/README.md][PlGa] |


### Development

Want to contribute? Great!

Dillinger uses Gulp + Webpack for fast developing.
Make a change in your file and instantanously see your updates!

Open your favorite Terminal and run these commands.

First Tab:
```sh
$ node app
```

Second Tab:
```sh
$ gulp watch
```

(optional) Third:
```sh
$ karma test
```
#### Building for source
For production release:
```sh
$ gulp build --prod
```
Generating pre-built zip archives for distribution:
```sh
$ gulp build dist --prod
```
### Docker
Dillinger is very easy to install and deploy in a Docker container.

By default, the Docker will expose port 8080, so change this within the Dockerfile if necessary. When ready, simply use the Dockerfile to build the image.

```sh
cd dillinger
docker build -t joemccann/dillinger:${package.json.version} .
```
This will create the dillinger image and pull in the necessary dependencies. Be sure to swap out `${package.json.version}` with the actual version of Dillinger.

Once done, run the Docker image and map the port to whatever you wish on your host. In this example, we simply map port 8000 of the host to port 8080 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
docker run -d -p 8000:8080 --restart="always" <youruser>/dillinger:${package.json.version}
```

Verify the deployment by navigating to your server address in your preferred browser.

```sh
127.0.0.1:8000
```

#### Kubernetes + Google Cloud

See [KUBERNETES.md](https://github.com/joemccann/dillinger/blob/master/KUBERNETES.md)


### Todos

 - Write MORE Tests
 - Add Night Mode

License
----

MIT


**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>

