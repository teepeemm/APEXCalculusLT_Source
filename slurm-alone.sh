#!/bin/bash -l
#-----------------------------------
# David Apostal
# UND Computational Research Center
#
# Timothy Prescott
# UND Math Dept
#
# Submit:
#   sbatch this-file.sh
#
# Check status:
#   squeue | grep [userid]
#   squeue -u $USER
#   squeue -j [jobid]
#-----------------------------------

# use
# git pull origin master
# to make sure the code is up to date

#SBATCH --job-name=latexml
#SBATCH --partition=talon

# Sets the maximum time the job can run (hh:mm:ss).
#SBATCH --time=1:00:00

# Specifies nodes for the job.
#SBATCH --nodes=1

# Sets the output file name. %x = job-name, %j = job-id
#SBATCH --output=./%x.%j.out.txt
#SBATCH --error=./%x.%j.err.txt

# Job events (mail-type): begin, end, fail, all.
#SBATCH --mail-type=all
#SBATCH --mail-user=timothy.prescott@und.edu

# load required modules here
module load apptainer
# print the loaded modules
#module list

echo ""
echo "Job started at $(date)"
echo ""

export LATEXML_KPSEWHICH=$HOME/.tex/texlive/2021/bin/x86_64-linux/kpsewhich

base="standalone"
latexmlscripts="$HOME/git/LaTeXML/blib/script"
#latexmlscripts="$HOME/.cpan/sources/authors/id/B/BR/BRMILLER/LaTeXML-0.8.6/blib/script"
singularitydir="$HOME/latexml"
printf '\\newcommand{\\thetitle}{Calculus}\n\\printincolor\n\\usethreeDgraphics\n\\renewcommand{\\monthYear}{June 2023}\n' > options.tex

singularity exec $singularitydir/latexml.sif $latexmlscripts/latexml --destination=lab/moverMunder/moverMunder.xml --nocomments lab/moverMunder/moverMunder

singularity exec $singularitydir/latexml.sif $latexmlscripts/latexmlc --destination=lab/moverMunder/moverMunderC.xhtml --nocomments lab/moverMunder/moverMunder

singularity exec $singularitydir/latexml.sif $latexmlscripts/latexmlpost --destination=lab/moverMunder/moverMunder.html lab/moverMunder/moverMunder.xml

singularity exec $singularitydir/latexml.sif $latexmlscripts/latexmlpost --destination=lab/moverMunder/moverMunder.xhtml lab/moverMunder/moverMunder.xml

singularity exec $singularitydir/latexml.sif $latexmlscripts/latexmlpost --destination=lab/moverMunder/moverMunderS.xhtml --stylesheet=apexepub.xsl lab/moverMunder/moverMunder.xml

#singularity exec $singularitydir/latexml.sif $latexmlscripts/latexmlpost --destination=lab/moverMunder/moverMunder.epub lab/moverMunder/moverMunder.xml

exit 0

singularity exec $singularitydir/latexml.sif $latexmlscripts/latexml --destination=$base.xml --nocomments $base

exit_code=$?

echo ""
echo "latexml finished at $(date)"
echo ""

if [ "$exit_code" -ne "0" ]; then
    echo "latexml failed"
    exit "$exit_code"
fi

singularity exec $singularitydir/latexml.sif $latexmlscripts/latexmlpost --split --destination=standaloneweb/index.html --javascript=LaTeXML-maybeMathJax.js $base.xml
# --javascript=LaTeXML-maybeMathJax.js

exit_code=$?

echo ""
echo "latexmlpost finished at $(date)"
echo ""

if [ "$exit_code" -ne "0" ]; then
    echo "latexmlpost failed"
    exit "$exit_code"
fi

singularity exec $singularitydir/latexml.sif $latexmlscripts/latexmlpost --split --destination=standaloneweb/epub.xhtml --stylesheet=apexepub.xsl $base.xml

exit_code=$?

echo ""
echo "latexmlpost epub finished at $(date)"
echo ""

if [ "$exit_code" -ne "0" ]; then
    echo "latexmlpost epub failed"
    exit "$exit_code"
fi

tar czf standaloneweb.tar.gz standaloneweb/
