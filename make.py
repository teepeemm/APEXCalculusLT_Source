#!/usr/bin/python3

# prc and web can be edited on und.edu by going to
# http://a.ou.und.edu/10/#oucampus/UND/sites/browse/staging/timothy.prescott

'''
    pdfsizeopt must use Python 2 because it uses old style print statements.
    This file should be version agnostic.  We generally have
    print(string,'')
    In Python 3, this prints the string and then an empty string.
    In Python 2, this prints the tuple that consists of the string and then
    the empty string.
    A different approach would be to use bash to invoke pdfsizeopt
    via Python 2 (I think)
    
    I'm also no longer using pdfsizeopt
'''

import argparse
import atexit
import collections
import glob
import html
import itertools
import os
import platform
import re
import shutil
import subprocess
import sys
import time
import traceback
from typing import Literal, Sequence, Union

ignorelist = frozenset(['AntiAbuse','AmericInn','Arial','Bernhard','Calc','CrossTenant','CrossTenantHeadersStamped',"Darboux's",
    'Friedrich',"Fubini's",'Georg','Hostname','Iiams','LHR',"Rolle's",'Schwarz',
    'antispam','myplot','nbsp','num','pos','proj','sinh','sqrt','tahoma','tanh','tdots',
    'xdots','xlabel','xmajorgrids','xmax','xmin','xminorgrids','xscale','xshift','xtick','xticklabel','xticklabels',
    'ylabel','ymajorgrids','ymax','ymin','yminorgrids','yscale','yshift','ytick','yticklabels',
    'zlabel','zmax','ztick',
])

failed_compilations = 0

loginfo: list[str] = []

@atexit.register
def printloginfo() -> None:
    print('Now in printloginfo')
    if loginfo:
        print('\n'.join(loginfo),'')

start = time.time()

parser = argparse.ArgumentParser(description='Compile document to a pdf.',
                                 epilog='If no options are given, '
                                 '--help is assumed.')

def addboolarg(key: str, help: str, parser=parser, shortkey: Union[str,None]=None) -> None:
    shortkey = shortkey or key[0]
    parser.add_argument('-'+shortkey,'--'+key,action='store_true',help=help)

addboolarg('all','Creates all versions. (Ignores other options. 6 hours.)')

parser.add_argument('-c','--calculus', type=int, choices=[0,1,2,3,4],
                    default=0,
                    help='Calculus semester 1, 2, 3, or (default) all. 2 or 4 hours.')

addboolarg('figures','Create 3D figures using Asymptote.')
addboolarg('matrices','Create matrix figures for LaTeXML.')
addboolarg('prc','Update 3D html.')
addboolarg('instructor','Create instructor solution manual.')
addboolarg('internet','Create interNet version (options x & w).',shortkey='n')
addboolarg('xml','Create xml version. (2 or 5 hours)') # 120, 90, 107
addboolarg('web','Convert xml version to html. (5 min)')
addboolarg('epub','Create epub version. (6 hours)')
parser.add_argument('--standalonen',action='store_true',
                    help='Create interNet version for standalone.tex')
parser.add_argument('--standalonex',action='store_true',
                    help='Create xml version for standalone.tex')
parser.add_argument('--standalonew',action='store_true',
                    help='Convert xml version to html for standalone.tex')
parser.add_argument('--standalonee',action='store_true',
                    help='Create epub version for standalone.tex')
addboolarg('todo','Update todo lists.')
addboolarg('overview','Create overview file.')
addboolarg('quit','Write options.tex and quit.')
parser.add_argument('--spelling',action='store_true',help='Run spellcheck')
parser.add_argument('--justprint',action='store_true',
                    help='Print the commands that would be executed, but do not execute them')

group = parser.add_mutually_exclusive_group()
addboolarg('blackwhite','Print static graphics in black and white (default is color).',parser=group)
addboolarg('static','Print static color graphics (default is interactive).',parser=group)

if len(sys.argv)==1:
    parser.print_help()
    sys.exit()

for dir in ('ApexPDFs','ApexPDFs/bigpdfs','logs','prc','todo','web'):
    try:
        os.mkdir(dir)
    except OSError:
        pass # the directory already exists

args = parser.parse_args()

def getTime() -> tuple[int, int]:
    end = time.time()
    totalSeconds = int(end-start)
    totalMinutes,seconds = totalSeconds//60,totalSeconds%60
    hours,minutes = totalMinutes//60,totalMinutes%60
    return (hours,minutes,seconds)

def makematrices() -> None:
    try:
        os.chdir('figures/matrices')
        for srcfile in glob.glob('*Src.tex'):
            root = srcfile.replace('Src.tex','')
            try:
                if os.path.getmtime(srcfile) < os.path.getmtime(root+'.pdf') :
                    continue
            except:
                pass
            with open('../../logs/compilationmatrix.log','w+') as mystdout:
                command = ['lualatex','-synctex=0','-jobname='+root,'matrix']
                if args.justprint:
                    print('run:',command,'2>','logs/compilationmatrix.log')
                else:
                    subprocess.check_call(command,stdout=mystdout,stderr=subprocess.STDOUT)
    finally:
        os.chdir('../../')

def makefigs() -> None:
    try:
        os.chdir('figures')
        for asyfile in glob.glob('*.asy'):
            if 'config' in asyfile:
                continue
            asyfile = asyfile[:-4]
            extops = {
                #'.pdf':   ['-noprc','-outformat','pdf'],
                '.prc':   ['-prc','-outformat','prc'],
                # -user apexbw=true runs that command in apexconfig.asy
                # using -bw instead causes the figure to be blacked out (?!)
                #'BW.pdf': ['-noprc','-user','apexbw=true','-outname',asyfile+'BW','-outformat','pdf'],
                'BW.png': ['-noprc','-user','apexbw=true','-outname',asyfile+'BW','-outformat','png','-render','4'],
                '.png':   ['-noprc','-outformat','png','-render','4'],
                '.html': ['-outformat','html']
            # for some reason, -render kills the png output
            }
            asyexe = 'asy' #'/usr/local/bin/asy'
            # version 2.44 has problems with the png
            # * it doesn't look as nice
            # * -render 4 causes the compilation to fail (https://github.com/vectorgraphics/asymptote/issues/96)
            # * the z-index is based on when they appear in the file, not the camera view
            # fixed by version 2.65?
            for ext,opt in extops.items():
                shouldrun = True
                try:
                    shouldrun = os.path.getmtime(asyfile+ext) <= os.path.getmtime(asyfile+'.asy')
                except OSError:
                    pass # file not found. leave shouldrun as True
                if shouldrun:
                    if args.justprint:
                        print('run:',[asyexe]+opt+[asyfile])
                    else:
                        subprocess.check_call([asyexe]+opt+[asyfile])
        for outfile in glob.iglob('*.out'):
            if ( os.path.getsize(outfile) == 0 ):
                os.remove(outfile)
    finally:
        os.chdir('..')

labeltypes = ('definition','example','figure','keyidea','theorem')
depths = {
    'Calc': 0,
    'C': 1,
    'S': 2
}

def get_depth(overview: str) -> int:
    for start,depth in depths.items():
        if overview.startswith(start):
            return depth
    return 3

def create_overview() -> None:
    overviewlist = shuffle_prereqs(overviewfromfile('Calculus.aux'))
    previous,previous_depth = None,-1
    with open('overview.html','w+') as overviewhtml:
        overviewhtml.write('<!doctype html>\n'
        '<html lang="en-US">\n'
        ' <head>\n'
        '  <meta charset="utf-8">\n'
        '  <title>Calculus Overview</title>\n'
        '  <style>\n'
        '   li { list-style-type: none; }\n'
        '   ul ul { display: none; }\n'
        '   li input:checked ~ ul { display: block; }\n'
        '   .overviewitem { display: none; }\n'
        +'\n'.join(f' #{labeltype[0].upper()}:checked ~ ul .{labeltype[0].upper()} {{ display: block; }}'
                   for labeltype in labeltypes )
        +'\n  </style>\n'
        ' </head>\n'
        ' <body>\n'
        '  <h1>Calculus Overview</h1>\n'
        +'\n'.join(f'  <input type="checkbox" value="{labeltype}" id="{labeltype[0].upper()}" />'
                   f'<label for="{labeltype[0].upper()}">{labeltype.title()}</label>'
                   for labeltype in labeltypes) )
        for overview in overviewlist:
            depth = get_depth(overview)
            if depth <= previous_depth:
                overviewhtml.write('</li>\n'+('</ul>\n</li>\n'*(previous_depth-depth)))
            else: #if previous_depth < depth:
                overviewhtml.write('<ul>\n'+('<li><input type="checkbox"><ul>\n'*(depth-previous_depth-1)))
            if depth == 3:
                overviewhtml.write(f'<li class="overviewitem {overview[0]}">\n{overview}')
            elif depth == 0:
                overviewhtml.write('<li>\n'
                    f'<input type="checkbox" id="{overview.replace(" ","_")}">'
                    f'<label for="{overview.replace(" ","_")}">{overview}</label>')
            else:
                overviewhtml.write('<li>\n'
                    f'<input type="checkbox" id="{overview.split()[0]}">'
                    f'<label for="{overview.split()[0]}">{overview}</label>')
            previous,previous_depth = overview,depth
        overviewhtml.write('</ul></li></ul></li></ul></li></ul></body></html>')

def shuffle_prereqs(overviewlist: list[str]) -> list[str]:
    ret = []
    delayqueue = []
    while overviewlist:
        nextitem = overviewlist.pop(0)
        if 'Chapter Prerequisites' in nextitem:
            while not nextitem.startswith('C'):
                delayqueue.append(nextitem)
                nextitem = overviewlist.pop(0)
        ret.append(nextitem)
        if delayqueue:
            ret.extend(delayqueue)
            delayqueue = []
    return ret

def overviewfromfile(filename: str) -> list[str]:
    with open(filename) as filein:
        overviewlist = []
        for line in filein:
            linepieces = re.split(r'\s*(?:{|})\s*',line)
            # I'm not sure why ?: is needed.  Without it, the { } show up in the matches
            if line.startswith(r'\@input{'): # }
                overviewlist.extend(overviewfromfile(linepieces[1]))
            if line.startswith(r'\@writefile{toc}{\contentsline {'): # } }
                if linepieces[4]=='part':
                    # eg: \@writefile {toc}
                    # { \contentsline {part}{Calculus I}{1}{part*.10}\protected@file@percent }
                    overviewlist.append( f'{linepieces[6]}: p{linepieces[8]}' )
                elif linepieces[4] in ('section','chapter') and 'numberline' in line:
                    # eg: \@writefile {toc}
                    # { \contentsline {section}{\numberline {8.7}Numerical Integration}{447}{section.8.7}\protected@file@percent }
                    overviewlist.append( f'{linepieces[4][0].upper()}{linepieces[7]}: p{linepieces[10]}: {linepieces[8]}' )
            if line.startswith(r'\newlabel{') and any( linepieces[-5].startswith(labeltype) for labeltype in labeltypes ): # }
                # eg: \newlabel {ex_der_num_approx}
                # { {2.1.3}{84}{Numerical Approximation of the Tangent Line}{example.2.1.3}{} }
                resplit = re.split(r'\s*(?:{|})\s*',line,maxsplit=8) # split again, with maxsplit
                rightsplit = [ piece.strip(' {') for piece in resplit[-1].rsplit('}',maxsplit=4) ]
                text = rightsplit[0]
                if text.endswith(r'\relax'):
                    text = text.rstrip('relax').rstrip('\\')
                overviewlist.append( f'{rightsplit[1][0].upper()}{resplit[4]}: p{resplit[6]}: {html.escape(rightsplit[0])}' )
            #elif  line.startswith(r'\newlabel{'):
            #    breakpoint()
        return overviewlist

Figure = collections.namedtuple('Figure',['num','file'])

def updateprc() -> None:
    prcdict = prcfromfile('Calculus.aux')
    with open('prc/index.html','w+') as prchtml:
        prchtml.write('<!doctype html>\n'
                      '<html>\n'
                      '<head>\n'
                      '<meta charset="utf-8">\n'
                      '<title>3d images</title>\n'
                      '<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">\n'
                      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>\n'
                      '<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>\n'
                      '<style>.box{display:inline-block;text-align:center;margin:1em}img{width:2in;}</style>\n'
                      '</head>\n'
                      '<body>\n'
                      '<h1>Interactive 3d Images From APEX Calculus LT</h1>\n'
                      '<div id="accordion">\n')
        chapters = sorted( prcdict.keys() , key=lambda x:float('inf') if x=='A' else int(x) )
        for chapter in chapters:
            writechapterprc(prcdict,prchtml,chapter)
        prchtml.write('</div>\n'
                      '<script>$("#accordion").accordion({collapsible:true,active:false,heightStyle:"content"});</script>\n'
                      '</body>\n'
                      '</html>\n')

def writechapterprc(prcdict: dict, prchtml, chapter: str) -> None:
    # solutions are recorded differently in the aux as well as the dict
    if chapter=='A':
        prchtml.write('<h3>Solutions</h3>\n')
    else:
        prchtml.write('<h3>Chapter '+str(chapter)+'</h3>\n')
    prchtml.write('<div>\n')
    sections = sorted( prcdict[chapter].keys() )
    for section in sections:
        if chapter=='A':
            # section is really chapter because of \prc@section@autoref in style file
            prchtml.write('<h4>Chapter '+section+'</h4>\n<ul>\n')
        else:
            prchtml.write(f'<h4>Section {chapter}.{section}</h4>\n<ul>\n')
        for figure in prcdict[chapter][section]:
            prchtml.write(f'<li><a href="{figure.file}.html">{figure.num}</a></li>\n')
            shutil.copy('figures/'+figure.file+'.html','prc')
        prchtml.write('</ul>\n')
    prchtml.write('</div>\n')

def prcfromfile(filename: str) -> dict:
    with open(filename) as filein:
        print('opening',filename)
        prcdict: dict[str, dict[str, list[Figure]]] = collections.defaultdict(lambda:collections.defaultdict(list))
        for line in filein:
            if line.startswith(r'\@input{'):
                prcdict.update(prcfromfile(line[len(r'\@input{'):-2]))
            if line.startswith('% prc file figures'):
                match = re.fullmatch(r'% prc file figures/(\S+) used in Section (A|\d+).(\d+) as ((Figure )?[.#\d+]+)\s*',line)
                if match:
                    prcdict[ match.group(2) ][ match.group(3) ].append(Figure(match.group(4),match.group(1)))
                else:
                    print('no match',line)
        return prcdict

def updatetodo() -> None:
    output = subprocess.check_output(['grep','todo','-I','--recursive','--line-number',
                                      '--exclude-dir=ApexPDFs','--exclude-dir=.git','--exclude-dir=todo',
                                      '--exclude-dir=hidden','--exclude-dir=mecmath','--exclude-dir=completed','.'])
    todos = output.decode('utf-8').split("\n")
    todos.sort()
    todosin = collections.defaultdict(list)
    for todo in todos:
        if re.match('./make.py',todo) or todo == '' or re.match(r'\S+.log',todo):
            continue
        if ' Tim ' in todo:
            key = 'tim'
        # put the next backwards, so that CalcII-UND gets sorted appropriately 
        elif re.match(r'\S*/1[0-4]',todo) or 'CalculusIII' in todo:
            key = 'calc3'
        elif re.match(r'\S*/0[5-9]',todo) or 'CalculusII' in todo:
            key = 'calc2'
        elif re.match(r'\S*/0[1-4]',todo) or 'CalculusI' in todo:
            key = 'calc1'
        else:
            key = 'tim'
        todo = re.sub(r'^\./(\S+):(\d+):\s*%?\s*',r'1. [\1 line \2](../\1#L\2): ',todo)
        todosin[key].append(todo)
    for filename,todolist in todosin.items():
        with open('todo/todo_'+filename+'.md','w+') as todofile:
            if (3, 0) <= sys.version_info[:2]:
                todofile.write('\n'.join(todolist)+'\n')
            else:
                todofile.write(('\n'.join(todolist)+'\n').encode('utf-8'))
    # and a few manual TeX commands instead of 'todo'
    with open('todo/todo_tex.txt','w+') as mystdout:
        for keywd in ('drawexampleline','enlargethispage','blue','pagebreak',
                      'newpage','clearpage','cleardoublepage','columnbreak',
                      'mfigure','myincludegraphics','addplot3','cdots','ldots'):
            grepcall = ['grep',keywd,'-I','--recursive','--files-with-matches','--exclude-dir=hidden']
            mystdout.write('\n\n'+keywd+':\n')
            mystdout.flush()
            try:
                subprocess.check_call(grepcall+['exercises'],stdout=mystdout)
            except:
                pass
            try:
                subprocess.check_call(grepcall+['text'],stdout=mystdout)
            except:
                pass
        mystdout.write('\n')

def writeoptions(args) -> None:
    with open('options.tex','w+') as options:
        title = 'Calculus'
        if args.calculus in (1,2,3):
            iii = 'I'*args.calculus
            title += ' '+iii
            options.write(r'\includeonly{Calculus'+iii+"}\n")
        options.write(r'\newcommand{\thetitle}{'+title+"}\n")
        if args.blackwhite:
            options.write('\\printinblackandwhite\n')
            options.write('\\usetwoDgraphics\n')
        elif args.static:
            options.write('\\printincolor\n')
            options.write('\\usetwoDgraphics\n')
        else:
            options.write('\\printincolor\n')
            options.write('\\usethreeDgraphics\n')

def getsuffix(args) -> str:
    if args.xml:
        return '_xml'
    elif args.standalonex:
        return '_sxml'
    elif args.web:
        return '_web'
    elif args.standalonew:
        return '_sweb'
    elif args.standalonee:
        return '_sepub'
    elif args.instructor:
        return '_answers'
    newsuffix = ''
    if args.calculus in (1,2,3):
        #iii = "I"*args.calculus
        newsuffix += '-'+str(args.calculus)
    if args.blackwhite:
        newsuffix += '-bw'
    elif args.static:
        newsuffix += '-color'
    return newsuffix

def getlatexmlbin(exe: str) -> str:
    locallatexml = os.path.join('..','LaTeXML','bin',exe)
    if os.path.isfile(locallatexml):
        return locallatexml
    else:
        return exe
    
def getlatexmlcommandline(base: str ='Calculus') -> list[str]:
    ret = [getlatexmlbin('latexml'),
            '--quiet','--quiet',#'--verbose','--verbose',##
           '--destination='+base+'.xml',
           '--nocomments',
           '--preload=headers/preload.ltxml',
           base]
    if platform.mac_ver()[0]:
        return ['caffeinate','-s'] + ret
        # prevent sleeping, if plugged in, until command finished
    if platform.win32_ver()[0]:
        ret[0] += '.bat'
    return ret

def getlatexmllog(base: str ='Calculus') -> str:
    return f'{base}.latexml.log'

def getlatexmlepubcommandline(base: str ='Calculus', destdir: str ='web') -> list[str]:
    ret = [getlatexmlbin('latexmlc'),
            '--quiet','--quiet',#'--verbose','--verbose',##
           '--destination='+destdir+'/'+base+'.epub',
           '--timeout=36000',
           '--css=style-narrow.css',
           '--nocomments',
           base]
    if platform.mac_ver()[0]:
        return ['caffeinate','-s'] + ret
        # prevent sleeping, if plugged in, until command finished
    if platform.win32_ver()[0]:
        ret[0] += '.bat'
    return ret

def getlatexmlepublog(base: str ='Calculus') -> str:
    return f'{base}.latexmlc.log'

def getlatexmlpostcommandline(base: str ='Calculus', destdir: str ='web') -> list[str]:
    #fixRefs()
    #shutil.copyfile('web/script.js','script.js')
    #shutil.copyfile('web/style.css','style.css')
    ret = [getlatexmlbin('latexmlpost'),
           '--split',#'--quiet',
           #'--stylesheet=web/apex.xsl',
           '--destination='+destdir+'/index.html',
           #'--xsltparam=USE_TWOCOLUMN_INDEX:true',
           base+'.xml']
    if platform.win32_ver()[0]:
        ret[0] += '.bat'
    return ret

def getlatexmlpostlog(base: str ='Calculus') -> str:
    return f'{base}.latexmlpost.log'

def getcommandline(args) -> Union[list[str], list[list[str]]]:
    if args.xml:
        return getlatexmlcommandline()
    if args.standalonex:
        return getlatexmlcommandline('standalone')
    if args.web:
        return getlatexmlpostcommandline()
    if args.standalonew:
        return getlatexmlpostcommandline('standalone','standaloneweb')
    if args.internet or args.standalonen:
        raise NotImplementedError('args.internet does not need a command line')
    if args.instructor:
        return ['latexmk','-lualatex','-interaction=batchmode','Answers']
    if args.epub:
        return getlatexmlepubcommandline()
    if args.standalonee:
        return getlatexmlepubcommandline('standalone','standaloneweb')
#    if args.calculus == 2:
#        return ['latexmk','-g','-lualatex','-interaction=batchmode','Calculus']
    # see https://tex.stackexchange.com/a/741777/107497
    return ['max_strings=2000000 hash_extra=2000000 latexmk -g -lualatex -interaction=batchmode Calculus']

def getlog(args) -> str:
    if args.xml:
        return getlatexmllog()
    if args.standalonex:
        return getlatexmllog('standalone')
    if args.web:
        return getlatexmlpostlog()
    if args.standalonew:
        return getlatexmlpostlog('standalone')
    if args.internet or args.standalonen:
        raise NotImplementedError('args.internet does not need a command line')
    if args.instructor:
        return 'Answers.log'
    if args.epub:
        return getlatexmlepublog()
    if args.standalonee:
        return getlatexmlepublog('standalone')
    return 'Calculus.log'

def minimizePdf(filename: str) -> None:
    '''
        pdfsizeopt forces Python 2 by using the old style print statement.
        It also prints to sys.stderr, which we can intercept using
        "with ... as sys.stderr" and reverting to sys.__stderr__ at the end.
        It also makes several calls to os.system, which prints to stderr in a way
        we can't intercept.  We intercept those calls by redefining os.system to
        use subprocess.check_call.  And even so, some calls get through.
        
        I'm going to drop this for now.  I'm mostly confident that pdfsizeopt would
        not preserve pdf accessibility.
    '''
    if (3, 0) <= sys.version_info[:2]:
        print('python 3 precludes pdfsizeopt','')
        shutil.copy('ApexPDFs/bigpdfs/'+filename,'ApexPDFs/smallpdfs/')
        return
    sys.path[:0] = ['../pdfsizeopt/lib']
    from pdfsizeopt import main  # type: ignore
    oldossystem = os.system
    try:
        os.remove('logs/ossystemerr.log')
    except:
        pass
    def ossystem(argstooss):
        with open('logs/ossystemerr.log','a+') as mystdout:
            if args.justprint:
                print('run:',argstooss,'2>','logs/ossystemerr.log')
            else:
                subprocess.check_call(argstooss,stdout=mystdout,stderr=subprocess.STDOUT,shell=True)
    os.system = ossystem
    with open('logs/minimizePdf.log','w+') as sys.stderr:
        main.main(['../pdfsizeopt/pdfsizeopt','--use-pngout=no',
                   '--use-jbig2=no','--use-multivalent=no',
                   'ApexPDFs/bigpdfs/'+filename,'ApexPDFs/smallpdfs/'+filename])
    sys.stderr = sys.__stderr__
    os.system = oldossystem
    for tmpfile in glob.iglob('ApexPDFs/smallpdfs/psotmp.*.parse.png'):
        os.remove(tmpfile)
    message = 'Minimizing pdf finished at '+"{0[0]:02d}:{0[1]:02d}:{0[2]:02d}".format(getTime())
    print(message,'')
    loginfo.append(message)

def lc(input: str) -> str:
    return input[0].lower()+input[1:]

def writemisspellings() -> None:
    with open('misspell.txt','w+') as misspellings:
        runningTotal: collections.Counter[str] = collections.Counter()
        texcommands = {
            'addplot': 'op',
            'autoeqref': 'p',
            'autopageref': 'p',
            'autoref': 'p',
            'axis': 'o',
            'boolean': 'p',
            'draw': 'o',
            'eqref': 'p',
            'exautoref': 'p',
            'ifbool': 'pPP',
            'iftoggle': 'pPP',
            'includecodegraphics': 'p',
            'hyperref': 'oP',
            'label': 'p',
            'lxAddClass': 'p',
            'mfigure': 'opPpp',
            'mtable': 'PpP',
            'myincludeasythree': 'ppp',
            'myincludegraphics': 'op',
            'pdfbookmark': 'OPp',
            'pgfkeysvalueof': 'p',
            'pdftooltip': 'pP',
            'ref': 'p',
            'youtubeVideo': 'pP'
        }
        print('Possible misspellings in tex files in this directory:',file=misspellings)
        for texfile in glob.glob('text/*.tex')+glob.glob('exercises/*.tex'):
            #if 'preface.tex' in texfile:
            #    continue
            with open(texfile) as filehandle:
                output = subprocess.run(['aspell --mode=tex --ignore=3 '+
                                        ' '.join([f'--add-tex-command="{k} {v}"' for k,v in texcommands.items()])+
                                        ' list'],
                                    stdin=filehandle,text=True,capture_output=True,shell=True)
                filemisspellings = collections.Counter(output.stdout.strip().split('\n'))
                filtered = collections.Counter({w:c for w,c in filemisspellings.items() if w and w not in ignorelist and lc(w) not in ignorelist})
                if filtered:
                    runningTotal += filtered
                    print('\n'+texfile+':',file=misspellings)
                    for word in sorted(filtered.keys()):
                        print(word+':',filtered[word],'time(s)',file=misspellings)
        print('\n\nMost common:\n',file=misspellings)
        for word,count in runningTotal.most_common(10):
            print(word+':',count,'time(s)',file=misspellings)

option_func = {
    'figures': makefigs,
    'matrices': makematrices,
    'todo': updatetodo,
    'prc': updateprc,
    'spelling': writemisspellings,
    'overview': create_overview
}

def compilewith(commands: Union[str, Literal[False]] =False) -> int:
    local_failed_compilations = 0
    print('running:',commands)
    #quit()
    if commands:
        args = parser.parse_args([''.join(commands)])
    else:
        args = parser.parse_args()
    for option,func in option_func.items():
        if getattr(args,option):
            func()
            return local_failed_compilations
    if args.calculus == 4:
        args.calculus = 0
    writeoptions(args)
    if args.quit:
        return local_failed_compilations
    if args.instructor:
        compilewith('-qsc0')
    elif args.internet:
        local_failed_compilations += compilewith('-x')
        local_failed_compilations += compilewith('-w')
        return local_failed_compilations
    elif args.standalonen:
        local_failed_compilations += compilewith('--standalonex')
        local_failed_compilations += compilewith('--standalonew')
        return local_failed_compilations
    local_failed_compilations += runcommands(args,commands)
    return local_failed_compilations

latexmk_commands = {
    'biber': 'B',
    'bibtex': 'b',
    'makeindex': 'I',
    'lualatex': 'L',
    'luatex': 'l',
    'pdflatex': 'P',
    'pdftex': 'p',
    'latex': 'T',
    'tex': 't',
    'xelatex': 'X',
    'xetex': 'x',
}

def runcommands(args, commands: Union[str, Literal[False]]) -> int:
    newsuffix = getsuffix(args)
    log = getlog(args)
    local_failed_compilations = 0
    latexmk_used = ''
    try:
        commandline = getcommandline(args)
        print('commandline is:',commandline)
        #breakpoint()
        if args.justprint:
            print('now run')
        # check_call(shell=False) tries to interpret the first thing as the program or file,
        # and fails with latexmk.  We use shell=True.  See file lab/maxstrings/maxstrings.py
        elif len(commandline) == 1:
            stdout = subprocess.check_output(commandline,shell=True)
            for line in stdout.decode().split('\n'):
                if line.startswith('Running '):
                    # if not for the repeated key, we could have this in one line as a comprehension
                    key = line.removeprefix("Running '").split(maxsplit=1)[0]
                    latexmk_used += latexmk_commands.get(key, f'?{key}?')
        else:
#            assert isinstance(commandline, list)
#            assert isinstance(commandline, Sequence)
            subprocess.check_call(commandline,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)  # type: ignore
    except Exception as exception:
        print(f'Exception caught: {type(exception)}; {exception}', file=sys.stderr)
        time = "{0[0]:02d}:{0[1]:02d}:{0[2]:02d}".format(getTime())
        local_failed_compilations += 1
        loginfomessage = 'At '+time+' failing command'
        if commands:
            loginfomessage += ': '+commands
        else:
            loginfomessage += ' line'
        loginfo.append(loginfomessage)
        print(loginfomessage, file=sys.stderr)
        traceback.print_exc()
    finally:
        shutil.copy(log,'logs/compilation'+newsuffix+'.log')
    time = "{0[0]:02d}:{0[1]:02d}:{0[2]:02d}".format(getTime())
    if commands:
        message = 'Command line: '+commands+' finished at '+time
        if latexmk_used:
            message += ' using '+latexmk_used
        print(message,'')
        loginfo.append(message)
    else:
        message = 'Command line finished at '+time
        print(message,'')
        loginfo.append(message)
    if args.instructor:
        shutil.copy('Answers.pdf','ApexPDFs/bigpdfs/answers.pdf')
#        minimizePdf('answers.pdf')
    elif not any((args.xml,args.web,args.standalonex,args.standalonew,args.epub,args.standalonee)):
        shutil.copy('Calculus.pdf','ApexPDFs/bigpdfs/calculus'+newsuffix+'.pdf')
#        minimizePdf('calculus'+newsuffix+'.pdf')
    return local_failed_compilations

if args.all:
    print('--all is true')
    #suffix = ' --justprint' if args.justprint else ''
    failed_compilations += compilewith('--figures')
    # having this first makes sure the index and toc are up to date
    failed_compilations += compilewith('-c0')
    failed_compilations += compilewith('--instructor')
    failed_compilations += compilewith('--prc')
#    failed_compilations += compilewith('-bc1')
#    failed_compilations += compilewith('-bc3')
    for part in range(1,4):
        failed_compilations += compilewith(f'-bc{part}')
#    print('--all completed, now causing error')
    # having '123' first means that doesn't change everytime, which may speed compilation
    #for part,size in itertools.product('123',['s','b']):
    #    compilewith('-'+size+'c'+part)
else:
    print('--all is false')
    failed_compilations += compilewith()

sys.exit(failed_compilations)
