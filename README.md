APEXCalculusLT_Source
===================

Source files for the APEX Calculus LT text.  The resulting pdf (or recent version thereof) is posted at https://arts-sciences.und.edu/academics/math/calc-1-texts.html

The main file is Calculus.tex, intended to be run with LuaLaTeX.

There are a variety of compilation options.
This is simplified by using make.py (a Python script) which calls latexmk.
Running `./make.py` will give the various options.
Compiling with a single set of options will take two hours or so for one semester, or 6--12 hours for all three semesters.
Running `./make.py -a` will create four different pdfs after 12--18 hours.
Running `./make.py -n` will use latexml to make a complete website version of the book after about three hours.

A solutions manual is available upon request.

This work is covered with a Creative Commons 4.0 By-NC copyright.

#### Rearrangements from ET
If you find an outside reference to Apex (for example, Webwork), it is likely referring to the original, early trancendentals, version.
Most of the exercises in one are also found in the other, although under different numbering (but often with the same parity).
The bigger change is to the section ordering.
|LT Section|ET Section|
|---|---|
|1.5|1.6|
|1.6|1.5|
|4.1-4.3|4.2-4.4|
|4.4|4.1|
|5.5|6.1|
|6.1-6.3|7.1-7.3|
|6.4-6.5|7.5-7.6|
|7.1||
|7.2|2.7|
|7.3||
|7.4|6.6|
|7.5|6.7|
|8.1-8.4|6.2-6.5|
|8.5||
|8.6|6.8|
|8.7|5.5|
|9.1-9.2|8.1-8.2|
|9.3-9.4|8.3|
|9.5|8.5|
|9.6|8.4|
|9.7||
|9.8-9.10|8.6-8.8|
|10.0|9.1|
|10.1|7.4|
|13.9||

With the noted exceptions, the introduction of LT chapter 7 means that ET chapter n = LT chapter (n+1), once n is at least 8.

#### Supporting programs
The following programs are used for compiling everything from start to finish:
* [LaTeX](https://www.tug.org/texlive/)
* [Python3](https://www.python.org/) to invoke make.py
* [LaTeXML](http://dlmf.nist.gov/LaTeXML/) to convert the book into a website
* [Asymptote](http://asymptote.sourceforge.net/) to create the three dimensional graphics

Enjoy.
