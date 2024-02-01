%%###############################################################################
%% Modified by Brandon Johns in 2023/2024
%% This version is not directly compatible with the previous versions. The whole set of files go together
%%
%% Key changes
%%   Lightly restyled preliminary pages (Still compliant with Monash University requirements)
%%   Added support for subsubsection to subparagraph depth
%%   Updated to modern packages which give better control: vmargin->geometry, natbib->biblatex, etc.
%%   Restyled headings, footers, contents, line/paragraph spacing, float placement
%%   Disabled hyphenation
%%   Remade twoside mode
%%   Reorganised this file and added comments
%%   Made the output PDF/A-2u compliant (well, somewhat compliant: figures and maths are like ugh)
%%   Added ability to restore hyperlinks within the embedded pdfs. Not fully automatic- the user has to help it along
%%   Completely redid the example scaffolding and example content
%%
%% Previous Header below
%%###############################################################################
%% Modified by James Saunderson to comply with thesis requirements for Monash University.
%%###############################################################################
%% Modified by Ricardo Garcia-Rosas to satisfy the rules established by Monash University's Research Higher Degrees Committee as of 4th of June 2019.
%% Guidelines can be found at: https://gradresearch.unimelb.edu.au/__data/assets/pdf_file/0004/2027839/Preparation-of-GR-theses-rules.pdf
%%
%% Original header:
%%
%% This is file `Thesis.cls', based on 'ECSthesis.cls', by Steve R. Gunn
%% generated with the docstrip utility.
%%
%% Created by Steve R. Gunn, modified by Sunil Patel: www.sunilpatel.co.uk
%%###############################################################################
%% Modified based on above sources, it is originally designed for The University of Melbourne, I have
%% done some amendment for Monash university usage.
%% amend by xingbod@gmail.com
%%###############################################################################
\NeedsTeXFormat{LaTeX2e}[1996/12/01]
\ProvidesClass{Thesis}[2023/08/25 v2.0 LaTeX document class]

\newif\if@thesistwoside
\@thesistwosidefalse %% Default to false
\DeclareOption{twoside}{\@thesistwosidetrue}
\DeclareOption{oneside}{\@thesistwosidefalse}
\if@thesistwoside
  \PassOptionsToClass{twoside}{book}
\else
  \PassOptionsToClass{oneside}{book}
\fi
\ProcessOptions\relax

%% openany (when used with twoside) allows chapters to start on (left or right) i.e. no blank pages are inserted
\LoadClass[a4paper,openany,12pt]{book}


%%###############################################################################
%% Core packages
%%#######################################
\usepackage[utf8]{inputenc}
\usepackage[australian]{babel}

%% Self-important packages
%% When using microtype, setspace should be loaded before hyperref
\usepackage{microtype} %% Subtle adjustments to improve readability
\usepackage{setspace} %% Change Linespacing

%% PDF/A compliance
%% Package pdfx automatically loads hyperref
\usepackage{colorprofiles}
\usepackage[a-2u,mathxmp]{pdfx}

%% Solves some font availability problems
\usepackage[T1]{fontenc}
\usepackage{lmodern}

\usepackage{xcolor}
\definecolor{thesisblue}{RGB}{0,0,192}  %% Colour for hyperlinks
\definecolor{thesisdarkgrey}{RGB}{25,25,25}  %% Colour for footer

%%###############################################################################
%% User commands: pagintation, margins, etc
%%#######################################
%% (twoside) Don't insert blank page after titlepage
%%   Based on definition, per the package documentation "7.2.4 Front Matter, Main Matter, and Back Matter"
%%   Changes \cleardoublepage to \clearpage
%%   DO NOT REDEFINE \mainmatter because changes to page numbering force resets the page to a right-page
\renewcommand{\frontmatter}{\clearpage\@mainmatterfalse\pagenumbering{roman}}

%% Use with pdfpages \includepdf[..., offset=\includepdfOffsetTwoside{} 0mm, ...]
%% When using the option twoside, this aligns included pdfs to the margins
\newcommand{\includepdfOffsetTwoside}{0mm} %% Value if oneside
\if@thesistwoside
    \renewcommand{\includepdfOffsetTwoside}{5mm} %% Value if twoside = 1/2 difference in margins
\fi


%%###############################################################################
%% Page dimensions, margins, line spacing, header, footer, headings
%%#######################################
\if@thesistwoside
  \usepackage[
    a4paper,
    twoside,
    inner=25mm, %% Inner margin. Changes must be reflected in \includepdfOffsetTwoside
    outer=15mm, %% Outer margin. Changes must be reflected in \includepdfOffsetTwoside
    vmargin=15mm,
    includeheadfoot, %% Contain within header and footer within the margins
    headheight=15pt
  ]{geometry}
\else
  \usepackage[
    a4paper,
    hmargin=25mm,
    vmargin=15mm,
    includeheadfoot, %% Contain within header and footer within the margins
    headheight=15pt
  ]{geometry}
\fi

%% Line and paragraph spacing
\raggedbottom
\onehalfspacing
\setlength{\parindent}{0pt}
\setlength{\parskip}{2.0ex plus0.5ex minus0.2ex}
\setlength{\topskip}{1\topskip \@plus 5\p@}

%% Heading and TOC formatting
\usepackage[nobottomtitles]{titlesec}
%% For the default values of the following, see the 'Standard Classes' from the titlesec documentation
%% SYNTAX: \titleformat{command}[preset 'shape']{format}{label}{sep}{before-code}[after-code]
\titleformat{\chapter}[hang]{\normalfont\huge\bfseries}{\thechapter}{20pt}{\Huge}[]
\titleformat{\paragraph}[hang]{\normalfont\normalsize\bfseries}{\theparagraph}{1em}{}
\titleformat{\subparagraph}[hang]{\normalfont\normalsize\bfseries}{\thesubparagraph}{1em}{}
%% SYNTAX: \titlespacing{command}{left margin}{sep before title}{sep after title}
\titlespacing*{\chapter}{0em}{1ex}{-1ex}
\titlespacing*{\section}{0em}{1ex}{-1ex}
\titlespacing*{\subsection}{0em}{1ex}{-1ex}
\titlespacing*{\subsubsection}{0em}{1ex}{-1ex}
\titlespacing*{\paragraph}{0em}{1ex}{-1ex}
\titlespacing*{\subparagraph}{0em}{1ex}{-1ex}
\renewcommand{\bottomtitlespace}{8\baselineskip} %% Minimum distance between a section heading and the bottom of a page

%% Header and footer formatting + more chapter heading formatting
%% The titlesec and fancyhdr work together
%%   Use \assignpagestyle to apply Header/footer style to TOC & first page in a chapter
\usepackage{fancyhdr}
\fancyhfinit{\color{thesisdarkgrey}} %% Change colour of header & footer
\let\defaultheadrule\headrule
\let\defaultfootrule\footrule

\fancypagestyle{preliminarypages}[fancydefault]{%%
  \fancyhf{}%% Clear header and footer
  \let\headrule\null\relax%%
  \let\footrule\null\relax%%
  \if@thesistwoside%%
    \fancyfoot[LE,RO]{\footnotesize \thepage}%%
  \else%%
    \fancyfoot[R]{\footnotesize \thepage}%%
  \fi%%
}

\fancypagestyle{core}[fancydefault]{%%
  \fancyhf{}%% Clear header and footer
  \let\headrule\null\relax%%
  \let\footrule\defaultfootrule%%
  \renewcommand{\footrulewidth}{0.4pt}%%
  \if@thesistwoside%%
    \fancyfoot[LE,RO]{\footnotesize \thepage}%%
    \fancyfoot[RE]{\footnotesize }%%
    \fancyfoot[LO]{\footnotesize \rightmark\ $\vert$\ \leftmark}%% Yes, I mix up left and right because latex is dumb
  \else%%
    \fancyfoot[R]{\footnotesize Page\ \thepage}%%
    \fancyfoot[L]{\footnotesize \rightmark\ $\vert$\ \leftmark}%% Yes, I switch left and right because latex is dumb
  \fi%%
  %% Chapter heading formatting
  \titleformat{\chapter}[hang]{\normalfont\huge\bfseries}{\thechapter}{20pt}{\Huge}[%%
    %% Lengths for double rule: r1=1.6pt, gap=1.6pt, r2=0.4pt
    \vspace*{-1\baselineskip}%%
    \rule{\textwidth}{0.4pt}\vspace*{-1\baselineskip}\vspace{3.2pt} %% r2, gap+r1
    \rule{\textwidth}{1.6pt} %% r1
  ]%%
}
\fancypagestyle{corefirst}[core]{}

\fancypagestyle{appfirst}[core]{}
\fancypagestyle{app}[appfirst]{}

\fancypagestyle{bibfirst}[core]{%%
  \if@thesistwoside%%
    \fancyfoot[RE]{\footnotesize }%%
    \fancyfoot[LO]{\footnotesize \nouppercase\leftmark}%%
  \else
    \fancyfoot[L]{\footnotesize \nouppercase\leftmark}%%
  \fi
}
\fancypagestyle{bib}[bibfirst]{}


%%###############################################################################
%% Text formatting, paragraph pagination
%%#######################################
\hyphenpenalty=10000 %% Prevent hyphenation (Part 1/2)
\exhyphenpenalty=10000 %% Prevent hyphenation (Part 2/2)
\doublehyphendemerits=10000 %% No consecutive line hyphens.
\brokenpenalty=10000 %% No broken words across columns/pages.
\widowpenalty=9999 %% Almost no widows at bottom of page.
\clubpenalty=9999 %% Almost no orphans at top of page.
\interfootnotelinepenalty=9999 %% Almost never break footnotes.

\emergencystretch 4em %% Having disabled hyphenation, drop long words to the next line instead of overflowing
\hfuzz=5mm %% Suppress warnings for \hbox overflow ("overfull \hbox") by up to given length
\hbadness=4000 %% range=[0,10000] Suppress warnings for underfull \hbox up to given badness level

\setlength{\footnotesep}{1\baselineskip} %% Space between footnotes
\setlength{\skip\footins}{1\baselineskip} %% Space between the text body and the footnotes

\usepackage[bottom]{footmisc} %% Glue footnotes to the bottom of the page

%% Hyperlinks
\hypersetup{pdfpagemode={UseOutlines},pdfstartview={FitV},pdfpagelayout={SinglePage},unicode,
  bookmarksopen=true,bookmarksopenlevel=0,bookmarksnumbered=true,hypertexnames=false,
  colorlinks,allcolors={thesisblue},
  breaklinks=true}

%% (Part of hyperref) When setting metadata and such, replace instances of "\\" with " "
\pdfstringdefDisableCommands{
  \let\\\space
}


%%###############################################################################
%% User commands: citations & bibliography
%%#######################################
\newcommand{\figref}[1]{Figure~\ref{#1}}
\newcommand{\tbref}[1]{Table~\ref{#1}}
%\newcommand{\eqref}[1]{Equation~\ref{#1}} %% Already defined by amsmath
\newcommand{\chapref}[1]{Chapter~\ref{#1}}
\newcommand{\secref}[1]{Section~\ref{#1}}
\newcommand{\appref}[1]{Appendix~\ref{#1}}

\newcommand{\algoref}[1]{Algorithm~\ref{#1}}
\newcommand{\algoRefLine}[1]{Line~\ref{#1}}
\newcommand{\algoRefLines}[2]{Lines~\ref{#1}\textbf{--}\ref{#2}}


%%###############################################################################
%% Misc
%%#######################################
\usepackage{enumitem} %% More control of lists
\usepackage{csquotes} %% Block quotations
\usepackage{changepage} %% Change margins for only a section

\usepackage{datetime} %% Print the current date in different formats


%%###############################################################################
%% Float pagination
%%#######################################
%% https://robjhyndman.com/hyndsight/latex-floats/index.html
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{.85}
\renewcommand{\textfraction}{0.1}
\renewcommand{\dbltopfraction}{.85}
\renewcommand{\floatpagefraction}{0.75}
\renewcommand{\dblfloatpagefraction}{.75}
\setcounter{topnumber}{9}
\setcounter{bottomnumber}{9}
\setcounter{totalnumber}{20}
\setcounter{dbltopnumber}{9}

%%###############################################################################
%% Maths
%%#######################################
\usepackage{amsmath,amssymb,amsfonts} %% Equations
\usepackage{bm} %% Apply bold to special symbols (only use on Greek letters, not normal letters)
\usepackage{commath} %% Derivatives, brackets
\usepackage{tensor} %% Left subscripts and left superscripts
\usepackage[ruled]{algorithm2e} %% Pseudocode Algorithms
\usepackage{textcomp, gensymb} %% Symbol: \degree
\usepackage{mathtools} %% Symbol: \coloneqq

%% This was in the old version of the class, but is not tested in this version
%\usepackage{amsthm}
%\theoremstyle{plain}
%\newtheorem{example}{Example}[chapter]
%\newtheorem{theorem}{Theorem}[chapter]
%\newtheorem{corollary}[theorem]{Corollary}
%\newtheorem{lemma}[theorem]{Lemma}
%\newtheorem{proposition}[theorem]{Proposition}
%\newtheorem{axiom}[theorem]{Axiom}
%\theoremstyle{definition}
%\newtheorem{definition}[theorem]{Definition}
%\theoremstyle{remark}
%\newtheorem{remark}[theorem]{Remark}


%%###############################################################################
%% Graphics
%%#######################################
\usepackage{graphicx}

%% Figures: General improvements and extends functionality with more options
\usepackage[
  justification=centerlast,
  font={normalsize,onehalfspacing},
  labelfont={bf},
]{caption}
\setlength{\captionmargin}{20pt}

%% Sub-figures
%%   When using with 'caption' package, include "caption" first
%%   To use this package, see the following
%%       https://tex.stackexchange.com/a/37597
%%       https://tex.stackexchange.com/a/128068
\usepackage[
  justification=centerlast,
  font={normalsize,onehalfspacing},
  labelfont={bf},
]{subcaption}
%\renewcommand{\thesubfigure}{\arabic{figure}\alph{subfigure}} %% Change numbering system. See lots of options in link
%%   http://www.peteryu.ca/tutorials/publishing/latex_captions

\usepackage{rotating} %% Rotate floats

%% Tables
\usepackage{booktabs}
\usepackage{multirow}
\usepackage{threeparttable} %% Use if needing table notes (footnotes for tables)
\usepackage{makecell} %% Line breaks in tables with \makecell

%% This was in the old version of the class, but is not tested in this version
%% Display formatted code blocks
%\usepackage{listings}
%\lstset{captionpos=b,
%        frame=tb,
%        basicstyle=\scriptsize\ttfamily,
%        showstringspaces=false,
%        keepspaces=true}
%\lstdefinestyle{matlab} {
%        language=Matlab,
%        keywordstyle=\color{blue},
%        commentstyle=\color[rgb]{0.13,0.55,0.13}\em,
%        stringstyle=\color[rgb]{0.7,0,0} }


%%###############################################################################
%% User commands: title page + metadata
%%#######################################
\newcommand*{\thesisUniversity}[1]{\def\printThesisUniversity{#1}}
\newcommand*{\thesisSchool}[1]{\def\printThesisSchool{#1}}
\newcommand*{\thesisDepartment}[1]{\def\printThesisDepartment{#1}}
\newcommand*{\thesisGradtime}[1]{\def\printThesisGradtime{#1}}
\newcommand*{\thesisDegree}[1]{\def\printThesisDegree{#1}}
\newcommand*{\thesisPriorDegrees}[1]{\def\printThesisPriorDegrees{#1}}
\newcommand*{\thesisAuthor}[1]{\def\printThesisAuthor{#1}}
\newcommand*{\thesisPublicationType}[1]{\def\printThesisPublicationType{#1}}
\newcommand*{\thesisLanguage}[1]{\def\printThesisLanguage{#1}}

\usepackage{xpatch}
\newcommand*{\thesisTitle}[1]{
  \title{#1}
  %% Create \printThesisTitleOneLine which replaces any line break "\\" with a space " "
  %% Because xstring and newfile don't get along, I have to use this roundabout method
  %% https://tex.stackexchange.com/a/433591
  \let\protected@iwrite\protected@write
  \xpatchcmd{\protected@iwrite}{\write}{\immediate\write}{}{}
  \newwrite\titlefile
  \immediate\openout\titlefile=\jobname.title
  \protected@iwrite\titlefile{\def\\{ }\def~{ }}{\@title}
  \immediate\closeout\titlefile
  \newread\inputstream
  \immediate\openin\inputstream=\jobname.title
  \immediate\read\inputstream to \printThesisTitleOneLine
}

%% Metadata for package pdfx
%% See: https://webpages.tuni.fi/latex/pdfa-guide.pdf
\usepackage{newfile}
\newcommand{\makemetadata}{
  \newoutputstream{thesisMetadataStream}
  \openoutputfile{\jobname.xmpdata}{thesisMetadataStream}
  \addtostream{thesisMetadataStream}{\protect\Title{\printThesisTitleOneLine}}
  \addtostream{thesisMetadataStream}{\protect\Author{\printThesisAuthor}}
  \addtostream{thesisMetadataStream}{\protect\Language{\printThesisLanguage}}
  \addtostream{thesisMetadataStream}{\protect\Subject{}}
  \addtostream{thesisMetadataStream}{\protect\Keywords{}}
  \addtostream{thesisMetadataStream}{\protect\Publisher{\printThesisUniversity}}
  \addtostream{thesisMetadataStream}{\protect\PublicationType{\printThesisPublicationType}}
  \closeoutputstream{thesisMetadataStream}
}

\renewcommand{\maketitle}{
  \newgeometry{vmargin=15mm,hmargin=25mm,includeheadfoot,headheight=15pt} %% (twoside) centre title page, ignoring binding margins
  \begin{titlepage}
    \null\vfil
    \begin{center}
      \setlength{\parskip}{0pt}
      {\includegraphics[width=1\textwidth]{Figures/monash-logo.pdf} \par}
      \vfill
      {\LARGE \bf \@title \par}
      \bigskip
      \bigskip
      \bigskip
      \bigskip
      {\LARGE \printThesisAuthor \par}
      \smallskip
      \printThesisPriorDegrees{}
      \vfill
      \vfill
      {\large A Thesis Submitted for the Degree of \printThesisDegree{} at \par}
      {\large\textbf{\printThesisUniversity} in \printThesisGradtime \par}
      {\large \printThesisDepartment \par}
      {\large \printThesisSchool \par}
      \bigskip
      \bigskip
      \bigskip
      \bigskip
    \end{center}
    \vfil\null
  \end{titlepage}
  \clearpage
  \restoregeometry
}


%%###############################################################################
%% Preliminary pages
%%#######################################
%% Adjust spacing within Contents
\newcommand{\tocLineSpace}{1.3}
\newlength{\tocLineSpaceSubtract}
\setlength{\tocLineSpaceSubtract}{-2\baselineskip}
\addtolength{\tocLineSpaceSubtract}{\tocLineSpace\baselineskip}
\addtolength{\tocLineSpaceSubtract}{0.8pt} %% Close enough to matching line spacing of subsections

 %% (twoside) even pages are always left-pages
 %%   I wish to place this on the back of the title page, so it should be even
 %%   But roman numerals have no zero, so it'd look dumb in the TOC
 %%   So I set the page number to 0, and don't include it in the TOC
\newcommand{\copyrightnotice}[1]{
  \thispagestyle{empty} %% No header/footer
  \setcounter{page}0 %% Set page number to 0
  %\addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  %\addtotoc{Copyright notice}
  {\large \bf{Copyright~notice}}\par
  {\normalsize #1}
  \vfil\vfil\null\clearpage
  \frontmatter %% Begin Roman style (i, ii, iii, iv...) page numbering
}

%% The Dedication page is not an standard Monash preliminary page. Use it only with authorisation from the graduate research office
\newcommand{\Dedication}[1]{
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{Dedication}
  \vspace*{\fill}
  \begin{center}
    \begin{minipage}{\textwidth}
      \begin{center}
        {\itshape #1}
      \end{center}
    \vspace{21pt} % Used trial and error to find the centre the text. Probably font dependent, but whatever
    \end{minipage}
  \end{center}
  \vspace*{\fill}\clearpage
}

\newcommand{\abstract}[1]{
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{Abstract}
  {\large \bf{Abstract}}\par
  {\normalsize #1}
  \vfil\vfil\null\clearpage
}

\newcommand{\Publicationslist}[1]{
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{Publications during enrolment}
  {\large \bf{Publications~during~enrolment}}\par
  {\normalsize #1}
  \vfil\vfil\null\clearpage
}

\newcommand{\Declarationpublication}[1]{
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{Thesis including published works declaration}
  {\large \bf{Thesis~including~published~works~declaration}}\par
  {\normalsize #1}
  \vfil\vfil\null\clearpage
}

\newcommand{\Declaration}[1]{
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{Declaration}
  {\large \bf{Declaration}}\par
  {\normalsize #1}
  \vfil\vfil\null\clearpage
}

\newcommand{\ack}[1]{
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{Acknowledgements}
  {\large \bf{Acknowledgements}}\par
  {\normalsize #1}
  \vfil\vfil\null\clearpage
}


%%###############################################################################
%% Contents
%%#######################################
%% Formatting & spacing of TOC items
\usepackage{titletoc}
\titlecontents{chapter}[0pt]{\vspace{1em}\bfseries}{\thecontentslabel\hspace{0.85em}}{}{\hfill\contentspage}[\vspace{2pt}]
%% SYNTAX: \dottedcontents{section}[left]{above-code}{label width}{leader width}
%% My pattern is to align the edge of the label (assuming single digit)
%% left = (previous left) + (previous label width)
%% label width = (previous label width) + 0.9
\dottedcontents{section}[3.8em]{}{2.3em}{1pc}
\dottedcontents{subsection}[6.1em]{}{3.2em}{1pc}
\dottedcontents{subsubsection}[9.3em]{}{4.1em}{1pc}
\dottedcontents{paragraph}[13.3em]{}{5.0em}{1pc}
\dottedcontents{subparagraph}[18.3em]{}{5.9em}{1pc}


\setcounter{secnumdepth}{6}
\setcounter{tocdepth}{6}
\newcounter{dummy} %% Oh hey! That's me!

\newcommand\addtotoc[1]{
  \refstepcounter{dummy}
  \addcontentsline{toc}{chapter}{#1}
}

\renewcommand{\tableofcontents}{
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{\contentsname}
  \begin{spacing}{\tocLineSpace}
    \setlength{\parskip}{0pt}
    \chapter*{\contentsname}
    \vspace*{-\tocLineSpaceSubtract} %% Undo the subtract for the first entry
    \@starttoc{toc}
  \end{spacing}
  \clearpage
}


%%###############################################################################
%% List of tables / figures
%%#######################################
%% Wrap these commands with code to add entries to the contents

%\renewcommand{\listfigurename}{List of Figures}
\let\defaultlistoffigures\listoffigures
\renewcommand{\listoffigures}{
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{\listfigurename}
  \begin{spacing}{1.5}
    \defaultlistoffigures
  \end{spacing}
  \clearpage
}

%\renewcommand{\listtablename}{List of Tables}
\let\defaultlistoftables\listoftables
\renewcommand{\listoftables}{
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{\listtablename}
  \begin{spacing}{1.5}
    \defaultlistoftables
  \end{spacing}
  \clearpage
}


%%###############################################################################
%% Additional preliminary pages
%%#######################################
\usepackage{longtable}

\newcommand{\listOfAbbreviationsHeading}{Abbreviations}
\newcommand{\listOfAbbreviations}[2]{
  \clearpage
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{\listOfAbbreviationsHeading}
  \begin{spacing}{1.5}
    \chapter*{\listOfAbbreviationsHeading}
    \begin{longtable}[l]{#1}#2\end{longtable}\par
  \end{spacing}
  \clearpage
}

\newcommand{\listOfConstantsHeading}{Constants}
\newcommand{\listOfConstants}[2]{
  \clearpage
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{\listOfConstantsHeading}
  \begin{spacing}{1.5}
    \chapter*{\listOfConstantsHeading}
    \begin{longtable}[l]{#1}#2\end{longtable}\par
  \end{spacing}
  \clearpage
}

\newcommand{\listOfNomenclatureHeading}{Symbols}
\newcommand{\listOfNomenclature}[2]{
  \clearpage
  \addtocontents{toc}{\vspace*{\tocLineSpaceSubtract}}
  \addtotoc{\listOfNomenclatureHeading}
  \begin{spacing}{1.5}
    \chapter*{\listOfNomenclatureHeading}
    \begin{longtable}[l]{#1}#2\end{longtable}\par
  \end{spacing}
  \clearpage
}


%%###############################################################################
%% Bib
%%#######################################
\renewcommand{\backmatter}{
  \addtotoc{\bibname}
  \@mainmatterfalse
}


%%###############################################################################
%% EOF
%%#######################################
\endinput
