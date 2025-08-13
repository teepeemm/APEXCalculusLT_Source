#!/usr/local/bin/python3

import re
from glob import glob

for exfilename in glob('text/*.tex'):
    with open(exfilename) as exfile:
        lines = exfile.read()
#    if re.search(r'\S( |\n)?\\mtable', lines):
#    if re.search(r'\S( |\n)?\\mtable[', lines):
    if re.search(r'\\mtable\[', lines):
        print(exfilename)
#    if r'begin{enumext}[start=1]' not in lines:
#        continue
#    print(exfilename)
#    if not re.search(r'(?<!\\pdftooltip{)\\begin{tikzpicture}(.*?)\\end{tikzpicture}', lines, re.DOTALL):
#        breakpoint()
#    quit()
    lines = re.sub(r'begin{enumext}\[start=1\]', r'begin{enumext}', lines)
#    lines = re.sub(r'\\pdftooltip{\\begin{tikzpicture}\[(.*?)\\end{tikzpicture}}{(.*?)}',
#                    r'\\begin{tikzpicture}[alt={\2},\1\\end{tikzpicture}',
#                    lines, flags=re.DOTALL)
#    lines = re.sub(r'\\pdftooltip{\\begin{tikzpicture}(.*?)\\end{tikzpicture}}{(.*?)}',
#                    r'\\begin{tikzpicture}[alt={\2}]\1\\end{tikzpicture}',
#                    lines, flags=re.DOTALL)
#    lines = re.sub(r'(?<!\\pdftooltip{)\\begin{tikzpicture}(.*?)\\end{tikzpicture}',
#                    r'\\pdftooltip{\\begin{tikzpicture}\1\\end{tikzpicture}}{ALT-' 'TEXT-TO-BE-DETERMINED}',
#                    lines, flags=re.DOTALL)
#    with open(exfilename, 'w') as exfile:
#        exfile.write(lines)
