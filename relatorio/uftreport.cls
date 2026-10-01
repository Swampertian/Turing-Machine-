%% uftreport.cls
%% Classe LaTeX para Relatórios Técnicos, Manuais, Projetos e Trabalhos de Disciplinas
%% Curso de Ciência da Computação — Universidade Federal do Tocantins
%%
%% Inspirada em:
%%   - techrep-ic.sty (IC/UNICAMP, J. Stolfi et al.)
%%   - uftmanuais.cls (UFT/CC, v1.1.0)
%%   - uftreport.cls  (UFT/CC, v1.1.0)
%%
%% Versão: 1.2.0 — 2025
%%
%% Uso básico:
%%   \documentclass[report]{uftreport}     % trabalho de disciplina / relatório
%%   \documentclass[project]{uftreport}    % projeto (TCC, PIBIC, etc.)
%%   \documentclass[manual]{uftreport}     % manual técnico
%%   \documentclass[techreport]{uftreport} % relatório técnico numerado

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uftreport}[2025/06/01 v1.2.0 Classe UFT/CC para relatorios tecnicos]

% ============================================================
% OPÇÕES DE TIPO DE DOCUMENTO
% ============================================================
\newif\if@ismanual           \@ismanualfalse
\newif\if@istechreport       \@istechreportfalse
\newif\if@isprojectresearch  \@isprojectresearchfalse
\newif\if@isprojectextension \@isprojectextensionfalse
\newif\if@isreport           \@isreporttrue

\DeclareOption{manual}{%
  \@ismanualtrue
  \@isreportfalse
  \@istechreportfalse
  \@isprojectresearchfalse
  \@isprojectextensionfalse
}
\DeclareOption{techreport}{%
  \@istechreporttrue
  \@isreportfalse
  \@ismanualfalse
  \@isprojectresearchfalse
  \@isprojectextensionfalse
}
\DeclareOption{projectresearch}{%
  \@isprojectresearchtrue
  \@isreportfalse
  \@ismanualfalse
  \@istechreportfalse
  \@isprojectextensionfalse
}
\DeclareOption{projectextension}{%
  \@isprojectextensiontrue
  \@isreportfalse
  \@ismanualfalse
  \@istechreportfalse
  \@isprojectresearchfalse
}
\DeclareOption{report}{%
  \@isreporttrue
  \@ismanualfalse
  \@istechreportfalse
  \@isprojectresearchfalse
  \@isprojectextensionfalse
}

% Tamanho de fonte
\def\@@ptsize{12pt}
\DeclareOption{10pt}{\def\@@ptsize{10pt}}
\DeclareOption{11pt}{\def\@@ptsize{11pt}}
\DeclareOption{12pt}{\def\@@ptsize{12pt}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass[oneside,\@@ptsize]{book}

% ============================================================
% PACOTES ESSENCIAIS
% ============================================================
\RequirePackage[T1]{fontenc}
\RequirePackage[english,brazil]{babel}
\RequirePackage[utf8]{inputenc}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{geometry}
\RequirePackage{setspace}
\RequirePackage{indentfirst}
\RequirePackage{lastpage}
\RequirePackage{amsfonts,amsthm,amsopn,amssymb,latexsym}
\RequirePackage{booktabs}
\RequirePackage{multirow}
\RequirePackage{tabularx}
\RequirePackage{wrapfig}
\RequirePackage{listings}
\RequirePackage{ifthen}
\RequirePackage{hyphenat}
\RequirePackage{ltxcmds}
\RequirePackage{xstring}
\RequirePackage{tikz}
\RequirePackage{pdfpages}
\RequirePackage{wallpaper}
\RequirePackage[section]{placeins}
\RequirePackage{titlesec}
\RequirePackage{chngcntr}
\RequirePackage[nottoc,notlof,notlot,notbib]{tocbibind}
\RequirePackage{tocloft}
\RequirePackage{etoolbox}

% O tocloft renderiza os títulos do sumário/listas via \cfttoctitlefont,
% \cftloftitlefont e \cftlottitlefont — NÃO via \@makeschapterhead.
% Redefinimos esses comandos para usar o mesmo tikzpicture da classe,
% e zeramos o conteúdo "after title" para evitar espaço duplo.
% O \clearpage antes de cada lista é injetado via \pretocmd no
% \AtBeginDocument, depois que o tocloft terminou suas redefinições.

\newcommand{\uft@cfttitle}[1]{%
  \noindent
  {\color{uftazul}\bfseries\normalsize\MakeUppercase{#1}\par}%
  \noindent{\color{uftamarelo}\rule{\textwidth}{1.5pt}}\par
  \vspace{6pt}%
  \nobreak
}

\renewcommand{\cfttoctitlefont}[1]{\uft@cfttitle{#1}\ignorespaces}
\renewcommand{\cftloftitlefont}[1]{\uft@cfttitle{#1}\ignorespaces}
\renewcommand{\cftlottitlefont}[1]{\uft@cfttitle{#1}\ignorespaces}
\renewcommand{\cftaftertoctitle}{}
\renewcommand{\cftafterloftitle}{}
\renewcommand{\cftafterlottitle}{}
\setlength{\cftbeforetoctitleskip}{0pt}
\setlength{\cftbeforeloftitleskip}{0pt}
\setlength{\cftbeforelottitleskip}{0pt}
\setlength{\cftaftertoctitleskip}{6pt}
\setlength{\cftafterloftitleskip}{6pt}
\setlength{\cftafterlottitleskip}{6pt}

\AtBeginDocument{%
  \pretocmd{\tableofcontents}{\clearpage}{}{}%
  \pretocmd{\listoffigures}  {\clearpage}{}{}%
  \pretocmd{\listoftables}   {\clearpage}{}{}%
  % Garante que as referências aparecem no sumário independentemente
  % do pacote usado (abntex2cite, natbib, thebibliography manual).
  % O \addcontentsline é inserido antes do ambiente thebibliography,
  % que é o que todos esses pacotes usam internamente.
  \pretocmd{\thebibliography}{%
    \cleardoublepage
    \addcontentsline{toc}{chapter}{\bibname}%
  }{}{}%
}
\RequirePackage[savepos,totpages,titleref,dotfill,counter,user]{zref}
\RequirePackage[labelfont=bf,textfont=bf,labelsep=endash,
                singlelinecheck=false,justification=justified]{caption}
\RequirePackage[pdftex,unicode=true,plainpages=false,pdfpagelabels,
                colorlinks=true,
                citecolor=black,linkcolor=black,
                urlcolor=black,filecolor=black,
                bookmarksopen=true]{hyperref}

% ============================================================
% CORES INSTITUCIONAIS UFT
% ============================================================
\definecolor{uftazul}   {RGB}{0,74,128}
\definecolor{uftverde}  {RGB}{0,133,119}
\definecolor{uftamarelo}{RGB}{253,185,19}
\definecolor{uftcinza}  {RGB}{100,100,100}

% ============================================================
% GEOMETRIA DA PÁGINA
% ============================================================
\geometry{a4paper, top=3cm, bottom=2cm, left=3cm, right=2cm}

% ============================================================
% CONFIGURAÇÃO DE LISTINGS (código-fonte)
% ============================================================
\lstset{
  basicstyle=\sffamily\footnotesize,
  numbers=left,
  numberstyle=\tiny\color{uftcinza},
  stepnumber=1,
  numbersep=8pt,
  showspaces=false,
  showstringspaces=false,
  frame=single,
  captionpos=b,
  breaklines=true,
  breakatwhitespace=false,
  backgroundcolor=\color[rgb]{0.97,0.97,0.97},
  rulecolor=\color{uftverde},
  extendedchars=true,
  xleftmargin=10pt,
  xrightmargin=10pt,
  commentstyle=\color{uftcinza}\itshape,
  keywordstyle=\color{uftazul}\bfseries,
  stringstyle=\color{uftverde},
}

% ============================================================
% ESPAÇAMENTO E INDENTAÇÃO
% ============================================================
\renewcommand{\baselinestretch}{1.5}
\setlength{\parindent}{1.25cm}

% ============================================================
% BABEL — ajustes de nomes
% ============================================================
% Redefine \bibname diretamente, sem depender de \captionsbrazil,
% para garantir que sobrevive a qualquer redefinição de pacotes
% (abntex2cite, babel, etc.). Executado em dois momentos para
% cobrir tanto a inicialização quanto o início do documento.
\renewcommand{\bibname}{REFERÊNCIAS}
\AtBeginDocument{\renewcommand{\bibname}{REFERÊNCIAS}}
\AfterEndPreamble{\renewcommand{\bibname}{REFERÊNCIAS}}

% ============================================================
% CONTADORES SEM CAPÍTULO
% ============================================================
\counterwithout{equation}{chapter}
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}

% ============================================================
% FORMATAÇÃO DO SUMÁRIO
% ============================================================
\renewcommand{\cftfigpresnum}{Figura }
\renewcommand{\cftfignumwidth}{5.5em}
\renewcommand{\cftfigaftersnum}{ -- }

\renewcommand{\cfttabpresnum}{Tabela }
\renewcommand{\cfttabnumwidth}{5.5em}
\renewcommand{\cfttabaftersnum}{ -- }

% Entradas do sumário — preto, hierarquia pelo peso da fonte
\def\l@chapter#1#2{%
  \pagebreak[3]
  \vskip 0.3em plus 0pt
  \@tempdima 1.75cm
  \begingroup
    \parindent\z@ \rightskip\@pnumwidth
    \parfillskip -\@pnumwidth
    \color{black}\bfseries\leavevmode
    \uppercase{#1}\hfil\cftdotfill{\cftdotsep}%
    \hbox to\@pnumwidth{\hss #2}\medskip\par
  \endgroup}

\def\l@section#1#2{%
  \pagebreak[3]
  \vskip 0.0em plus 0pt
  \@tempdima 1.75cm
  \begingroup
    \parindent\z@ \rightskip\@pnumwidth
    \parfillskip -\@pnumwidth
    \color{black}\normalsize\bfseries\leavevmode
    #1\hfil\cftdotfill{\cftdotsep}%
    \hbox to\@pnumwidth{\hss #2}\medskip\par
  \endgroup}

\def\l@subsection#1#2{%
  \pagebreak[3]
  \vskip -0.2em plus -1pt
  \@tempdima 1.75cm
  \begingroup
    \parindent\z@ \rightskip\@pnumwidth
    \parfillskip -\@pnumwidth
    \color{black}\normalsize\leavevmode
    #1\hfil\cftdotfill{\cftdotsep}%
    \hbox to\@pnumwidth{\hss #2}\medskip\par
  \endgroup}

\def\l@subsubsection#1#2{%
  \pagebreak[3]
  \vskip -0.2em plus -1pt
  \@tempdima 1.75cm
  \begingroup
    \parindent\z@ \rightskip\@pnumwidth
    \parfillskip -\@pnumwidth
    \color{black}\normalsize\leavevmode
    #1\hfil\cftdotfill{\cftdotsep}%
    \hbox to\@pnumwidth{\hss #2}\medskip\par
  \endgroup}

% ============================================================
% FORMATAÇÃO DE SEÇÕES
% ============================================================
\setcounter{secnumdepth}{3}

\titleformat{\section}
  {\normalsize\bfseries\color{uftazul}}
  {\thesection}{1em}{}[{\color{uftazul}\titlerule[0.5pt]}]

\titleformat{\subsection}
  {\normalsize\bfseries\color{uftcinza}}
  {\thesubsection}{1em}{}

\titleformat{\subsubsection}
  {\normalsize\color{uftcinza}}
  {\thesubsubsection}{1em}{}

% ============================================================
% CABEÇALHO DE CAPÍTULO
%
% Manual    — barra azul com filete amarelo à esquerda (acento),
%             número grande separado do título por espaço generoso.
% Relatórios — título caixa-alta em azul UFT sobre uma régua
%              amarela fina; sem caixa preenchida.
% ============================================================

\if@ismanual
  % ── Manual: fundo azul cheio, acento amarelo lateral ──────────────────
  \def\@makechapterhead#1{%
    \vspace*{20pt}%
    \noindent
    \begin{tikzpicture}
      \fill[uftazul]    (0,0) rectangle (\textwidth, 1.1cm);
      \fill[uftamarelo] (0,0) rectangle (0.18cm, 1.1cm);
      \node[anchor=west, text=white, font=\bfseries\large]
        at (0.55cm, 0.55cm) {\thechapter\quad\MakeUppercase{#1}};
    \end{tikzpicture}%
    \vspace{10pt}%
  }
  \def\@makeschapterhead#1{%
    \vspace*{20pt}%
    \noindent
    \begin{tikzpicture}
      \fill[uftazul]    (0,0) rectangle (\textwidth, 1.1cm);
      \fill[uftamarelo] (0,0) rectangle (0.18cm, 1.1cm);
      \node[anchor=west, text=white, font=\bfseries\large]
        at (0.55cm, 0.55cm) {\MakeUppercase{#1}};
    \end{tikzpicture}%
    \vspace{10pt}%
  }
\else
  % ── Relatórios / projetos / techreport: texto azul + régua amarela ────
  \def\@makechapterhead#1{%
    \vspace*{0pt}%
    \noindent
    {\color{uftazul}\bfseries\normalsize
      \thechapter\quad\MakeUppercase{#1}\par}%
    \noindent{\color{uftamarelo}\rule{\textwidth}{1.5pt}}\par
    \vspace{8pt}%
  }
  \def\@makeschapterhead#1{%
    \vspace*{0pt}%
    \noindent
    {\color{uftazul}\bfseries\normalsize
      \MakeUppercase{#1}\par}%
    \noindent{\color{uftamarelo}\rule{\textwidth}{1.5pt}}\par
    \vspace{8pt}%
  }
\fi

% ============================================================
% COMANDOS PARA METADADOS DO DOCUMENTO
% ============================================================

% Instituição e localização (defaults UFT)
\newcommand\local@universityname{Universidade Federal do Tocantins}
\newcommand\local@campusname{Campus Universitário de Palmas}
\newcommand\local@deptstring{Curso}
\newcommand\local@cityname{Palmas}
\newcommand\local@statename{TO}
\newcommand\local@advisorstring{Professor(a) Orientador(a)}
\newcommand\local@coadvisorstring{Professor(a) Coorientador(a)}
\newcommand\glossaryname{Glossário}
\newcommand\listabbreviationname{Lista de Siglas}
\newcommand\listsymbolname{Lista de Símbolos}

% Tipo de documento
\if@ismanual
  \newcommand\local@doctype{Manual Técnico}
\else\if@istechreport
  \newcommand\local@doctype{Relatório Técnico}
\else\if@isprojectresearch
  \newcommand\local@doctype{Projeto de Pesquisa}
\else\if@isprojectextension
  \newcommand\local@doctype{Projeto de Extensão}
\else
  \newcommand\local@doctype{Relatório}
\fi\fi\fi\fi

% Curso
\newcommand\department[1]{%
  \ifthenelse{\equal{#1}{CC}}
    {\global\def\local@deptname{Ciência da Computação}
     \global\def\foreign@deptname{Computer Science}}{}%
  \ifthenelse{\equal{#1}{LC}}
    {\global\def\local@deptname{Licenciatura em Computação}
     \global\def\foreign@deptname{Bachelor's degree in Computing}}{}%
  \ifthenelse{\equal{#1}{EC}}
    {\global\def\local@deptname{Engenharia Civil}
     \global\def\foreign@deptname{Civil Engineering}}{}%
  \ifthenelse{\equal{#1}{EE}}
    {\global\def\local@deptname{Engenharia Elétrica}
     \global\def\foreign@deptname{Electrical Engineering}}{}%
}
\department{CC} % padrão

% Título
\renewcommand\title[1]{\global\def\local@title{#1}}
\newcommand\foreigntitle[1]{\global\def\foreign@title{#1}}

% Número do relatório técnico (apenas para techreport)
\newcommand\TRNumber[1]{\global\def\local@trnumber{#1}}
\TRNumber{000}

% Disciplina / turma
\newcount\@class\@class0
\newcommand\class[1]{%
  \global\def\local@class{#1}%
  \global\advance\@class by 1
}

% Autor(es)
\newcount\@uftauthor\@uftauthor0
\renewcommand\author[2]{%
  \global\def\@authname{#1}%
  \global\def\@authsurn{#2}%
  \global\@namedef{uftAuthor:\expandafter\the\@uftauthor}{#1\ #2}%
  \global\advance\@uftauthor by 1
}

% Orientador(es)
\newcount\@advisor\@advisor0
\newcommand\advisor[4]{%
  \global\@namedef{uftAdvisorTitle:\expandafter\the\@advisor}{#1}%
  \global\@namedef{uftAdvisorName:\expandafter\the\@advisor}{#2}%
  \global\@namedef{uftAdvisorSurname:\expandafter\the\@advisor}{#3}%
  \global\@namedef{uftAdvisorDegree:\expandafter\the\@advisor}{#4}%
  \global\advance\@advisor by 1
}

% Banca examinadora
\newcount\@examiner\@examiner0
\newcommand\examiner[3]{%
  \global\@namedef{uftExaminer:\expandafter\the\@examiner}{#1\ #2\ #3}%
  \global\advance\@examiner by 1
}

% Data
\renewcommand\date[3]{\day=#1 \month=#2 \year=#3}

% Palavras-chave
\newcounter{keywords}
\newcommand\keyword[1]{%
  \global\@namedef{uftKeyword:\expandafter\the\c@keywords}{#1}%
  \global\addtocounter{keywords}{1}
}
\newcount\@foreignkeyword\@foreignkeyword0
\newcommand\foreignkeyword[1]{%
  \global\@namedef{uftForeignkeyword:\expandafter\the\@foreignkeyword}{#1}%
  \global\advance\@foreignkeyword by 1
}

% Meses em português e inglês
\newcommand\local@monthname{\ifcase\month\or
  Janeiro\or Fevereiro\or Março\or Abril\or Maio\or Junho\or
  Julho\or Agosto\or Setembro\or Outubro\or Novembro\or Dezembro\fi}
\newcommand\foreign@monthname{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi}

% ============================================================
% PAGINAÇÃO
% ============================================================
\renewcommand\frontmatter{%
  \cleardoublepage
  \@mainmatterfalse
  \let\oldplain\ps@plain
  \let\ps@plain\ps@empty
  \pagestyle{empty}
  \pagebreak
}

\renewcommand*{\ps@plain}{%
  \let\@mkboth\@gobbletwo
  \let\@oddfoot\@empty
  \def\@oddhead{\reset@font\hfil\thepage}%
  \let\@evenfoot\@empty
  \let\@evenhead\@oddhead
}

\zref@newprop{chaptitle}{}
\zref@addprop{main}{chaptitle}

\newcommand*{\ChapterStart}[2]{%
  \cleardoublepage
  \def\current@chapid{#1}%
  \zref@setcurrent{chaptitle}{#2}%
  \zlabel{chap:#1}%
}

\renewcommand\mainmatter{%
  \cleardoublepage
  \@mainmattertrue
  \clearpage\thispagestyle{empty}
  \let\ps@plain\oldplain
  \pagestyle{plain}
  \pagenumbering{arabic}
  \setcounter{page}{\number\numexpr\zref@extract{chap:first}{abspage}\relax}
}

\renewcommand\backmatter{%
  \if@openright\cleardoublepage\else\clearpage\fi
}

% ============================================================
% CAPA  (\maketitle)  — estilo IC/UNICAMP adaptado para UFT/CC
%
% Layout em coordenadas mm sobre uma área de 190 × 254 mm
% (mesmas proporções do techrep-ic.sty de J. Stolfi).
%
%  • Moldura esquerda em azul UFT
%  • Moldura direita em amarelo UFT
%  • Cabeçalho: logo + nome da instituição
%  • Caixa central: título + autores
%  • Rodapé: tipo de documento / número TR / data
%  • Aviso de responsabilidade (bilíngue) na base
% ============================================================

% Dimensões internas da capa (em mm, para o ambiente picture)
\def\TR@CoverSX{190}   % largura total  (~7.5 in)
\def\TR@CoverSY{254}   % altura total   (10.0 in)

\renewcommand\maketitle{%
  \pagenumbering{alph}
  \ltx@ifpackageloaded{hyperref}{\uftcc@hypersetup}{}%
  \bgroup
  % ── fontes independentes do corpo do documento ──────────────────────────
  \newcommand{\CV@sf}[1]{{\usefont{T1}{cmss}{m}{n}##1}}
  \newcommand{\CV@bf}[1]{{\usefont{T1}{cmr}{bx}{n}##1}}
  \newcommand{\CV@it}[1]{{\usefont{T1}{cmr}{m}{it}##1}}
  \newcommand{\CV@Huge}{\fontsize{20}{24pt}\selectfont}
  \newcommand{\CV@Large}{\fontsize{14}{17pt}\selectfont}
  \newcommand{\CV@normal}{\fontsize{11}{13pt}\selectfont}
  \newcommand{\CV@small}{\fontsize{9}{11pt}\selectfont}
  % ────────────────────────────────────────────────────────────────────────
  % Caixa do banner (instituição + curso) — alinhado à esquerda
  \newsavebox{\CV@Banner}
  \savebox{\CV@Banner}{%
    \begin{minipage}[c]{110mm}
      \raggedright\setstretch{1}\parfillskip0pt\parskip0pt
      {\CV@Large\CV@sf{\MakeUppercase{\local@universityname}}\par}
      \vskip3pt
      {\CV@Large\CV@sf{\MakeUppercase{\local@campusname}}\par}
      \vskip3pt
      {\CV@Large\CV@sf{\MakeUppercase{\local@deptstring}\ DE\ \MakeUppercase{\local@deptname}}\par}
    \end{minipage}%
  }
  % ────────────────────────────────────────────────────────────────────────
  % Caixa de conteúdo unificada: título, autores, tipo/data, orientador
  % (ocupa de y=96 a y=194 na grade, largura 120 mm)
  \newsavebox{\CV@Content}
  \savebox{\CV@Content}{%
    \vbox to116mm{%
      \hsize=126mm \textwidth=\hsize \linewidth=\hsize
      \null\vfil
      % Título
      {\centering
        {\CV@Huge\CV@bf{\local@title\par}}%
      }%
      \vskip10pt
      % Autores
      {\centering\CV@normal\CV@it{%
        \setstretch{1.3}%
        \count1=0
        \@whilenum\count1<\@uftauthor\do{%
          \csname uftAuthor:\the\count1\endcsname\par
          \advance\count1 by 1}%
      }}%
      \vfil
      % Linha separadora fina
      {\color{uftamarelo}\hrule height 0.6pt}%
      \vskip5pt
      % Tipo / número TR / data
      {\centering\CV@normal\CV@sf{%
        \if@istechreport
          Relatório Técnico\ --\ UFT-CC-\number\year-\local@trnumber
          \ --\ \local@monthname\ de\ \number\year
        \else\if@ismanual
          Manual Técnico\ --\ \local@deptname\ --\ UFT%
          \par{\CV@small\local@campusname}%
        \else\if@isprojectresearch
          Projeto de Pesquisa\ --\ \local@deptname
          \ifnum\@class>0 \ --\ \local@class\fi
          \ --\ \local@monthname\ de\ \number\year
        \else\if@isprojectextension
          Projeto de Extensão\ --\ \local@deptname
          \ifnum\@class>0 \ --\ \local@class\fi
          \ --\ \local@monthname\ de\ \number\year
        \else
          \local@doctype
          \ifnum\@class>0 \ --\ \local@class\fi
          \ --\ \local@monthname\ de\ \number\year
        \fi\fi\fi\fi
      }\par}%
      % Orientador (se houver)
      \ifnum\@advisor>0
        \vskip4pt
        {\CV@small\CV@sf{%
          \local@advisorstring:\space
          \count1=0
          \@whilenum\count1<\@advisor\do{%
            \csname uftAdvisorDegree:\the\count1\endcsname\space
            \csname uftAdvisorName:\the\count1\endcsname\space
            \csname uftAdvisorSurname:\the\count1\endcsname
            \ifnum\count1<\numexpr\@advisor-1\relax,\ \fi
            \advance\count1 by 1}%
        }\par}%
      \fi
      \vskip3pt\null
    }%
  }
  % ────────────────────────────────────────────────────────────────────────
  % Monta a página de capa
  \c@page\z@
  \thispagestyle{empty}
  \hoffset0pt \voffset0pt
  \topmargin-0.5in \oddsidemargin-0.5in \evensidemargin-0.5in
  \headheight0pt \headsep0pt \topskip0pt
  \vtop to0pt{%
    \null
    \hbox to0pt{%
      \null
      \hbox{%
        \setlength{\unitlength}{1mm}%
        \begin{picture}(\TR@CoverSX,\TR@CoverSY)
          % ── Moldura esquerda — azul UFT ──────────────────────────────
          {%
            \color{uftazul}%
            \thicklines
            % bordas externas
            \put(-0.12,  0.0){\line(1,0){39.24}}   % base
            \put( 0.00, -0.12){\line(0,1){254.24}}  % lado esq
            \put(-0.12,254.0){\line(1,0){39.24}}    % topo
            % parede direita: trecho inferior (y=0..86)
            \put(39.0, -0.12){\line(0,1){86.24}}
            % recuo: x=39→29 na altura y=86 (borda superior da caixa)
            \put(28.88, 86.0){\line(1,0){10.24}}
            % parede recuada: y=86..206 (altura da caixa única)
            \put(29.0,  85.88){\line(0,1){120.24}}
            % recuo de volta: x=29→39 na altura y=206 (borda inferior da caixa)
            \put(28.88,206.0){\line(1,0){10.24}}
            % parede direita: trecho superior (y=206..254)
            \put(39.0, 205.88){\line(0,1){48.24}}
          }
          % ── Moldura direita — amarelo UFT ────────────────────────────
          {%
            \color{uftamarelo}%
            \thicklines
            % bordas externas
            \put(40.88,  0.0){\line(1,0){149.24}}   % base
            \put(190.0, -0.12){\line(0,1){254.24}}  % lado dir
            \put(40.88,254.0){\line(1,0){149.24}}   % topo
            % parede esquerda: trecho inferior (y=0..86)
            \put(41.0, -0.12){\line(0,1){86.24}}
            % recuo: x=41→161 na altura y=86
            \put(40.88, 86.0){\line(1,0){120.24}}
            % parede recuada: y=86..206
            \put(161.0, 85.88){\line(0,1){120.24}}
            % recuo de volta: x=161→41 na altura y=206
            \put(40.88,206.0){\line(1,0){120.24}}
            % parede esquerda: trecho superior (y=206..254)
            \put(41.0, 205.88){\line(0,1){48.24}}
          }
          % ── Logo UFT ─────────────────────────────────────────────────
          % Zona do cabeçalho: y=206..254 (48 mm).
          % height=28mm, ancoragem [bl] em y=216 → topo em y=244.
          % Fica centrado verticalmente na faixa, longe das bordas.
          \put(8,216){%
            \makebox(0,0)[bl]{%
              \IfFileExists{logos/logouft.pdf}{%
                \includegraphics[height=28mm]{logos/logouft}%
              }{%
                \IfFileExists{logos/logouft.png}{%
                  \includegraphics[height=28mm]{logos/logouft}%
                }{}%
              }%
            }%
          }
          % ── Banner institucional (alinhado à esquerda) ───────────────
          % Ancoragem [bl] em y=216: texto (~28 mm) sobe até y=244,
          % alinhado com o topo do logo.
          \put(43,218){%
            \makebox(0,0)[bl]{\usebox{\CV@Banner}}%
          }
          % ── Caixa de conteúdo unificada (título + autores + data + orientador)
          % Espaço recuado: x=29..161, y=86..206  →  132 × 120 mm
          % Margem interna: 3 mm em cada lado → hsize=126 mm
          \put(32,88){%
            \makebox(0,0)[bl]{\usebox{\CV@Content}}%
          }
          % ── Aviso de responsabilidade (base da capa) ─────────────────
          \put(12,14){%
            \makebox(0,0)[bl]{%
              \begin{minipage}[c]{168mm}
                \centering\setstretch{1}%
                {\CV@small\CV@sf{%
                  The contents of this report are the sole responsibility of the authors.\par
                  O conteúdo deste relatório é de única responsabilidade dos autores.%
                }}%
              \end{minipage}%
            }%
          }
        \end{picture}%
      }%
      \hss
    }%
    \vss\null
  }%
  \newpage
  \egroup
  \global\let\maketitle\relax
  \global\let\and\relax
}

% ============================================================
% FOLHA DE ROSTO  (\makefrontpage)
% ============================================================
\newcommand\frontpage@maintext{%
  \setstretch{1}%
  \if@istechreport
    Relatório técnico do \local@deptstring\ de \local@deptname,
    \local@universityname, \local@campusname.
  \else\if@ismanual
    Manual técnico desenvolvido no âmbito do \local@deptstring\ de \local@deptname,
    \local@universityname, \local@campusname.
  \else\if@isprojectresearch
    Projeto de pesquisa submetido ao \local@deptstring\ de \local@deptname,
    \local@universityname, \local@campusname.
    \ifnum\@advisor>0
      \par Orientador(a):
      \count1=0
      \@whilenum\count1<\@advisor\do{%
        \csname uftAdvisorDegree:\the\count1\endcsname\space
        \csname uftAdvisorName:\the\count1\endcsname\space
        \csname uftAdvisorSurname:\the\count1\endcsname
        \ifnum\count1<\numexpr\@advisor-1\relax,\ \fi
        \advance\count1 by 1}%
    \fi
  \else\if@isprojectextension
    Projeto de extensão submetido ao \local@deptstring\ de \local@deptname,
    \local@universityname, \local@campusname.
    \ifnum\@advisor>0
      \par Orientador(a):
      \count1=0
      \@whilenum\count1<\@advisor\do{%
        \csname uftAdvisorDegree:\the\count1\endcsname\space
        \csname uftAdvisorName:\the\count1\endcsname\space
        \csname uftAdvisorSurname:\the\count1\endcsname
        \ifnum\count1<\numexpr\@advisor-1\relax,\ \fi
        \advance\count1 by 1}%
    \fi
  \else
    Relatório apresentado como parte das atividades da disciplina
    \ifnum\@class>0 \local@class, \fi
    \local@deptstring\ de \local@deptname,
    \local@universityname.
  \fi\fi\fi\fi
}

\newcommand\frontpage@bottomtext{%
  \begin{center}
    {\MakeUppercase{\local@cityname\ / \local@statename}}\\
    {\number\year}
  \end{center}%
}

\newcommand\makefrontpage{%
  \begin{center}
    {\bfseries\@authname\ \@authsurn}\par
    \vfill
    \nohyphens{\bfseries\local@title}\par
  \end{center}
  \vfill
  \begin{flushright}
    \begin{minipage}{8.5cm}
      \setstretch{1}
      \frontpage@maintext
    \end{minipage}\par
  \end{flushright}
  \vfill
  \frontpage@bottomtext
}

% ============================================================
% HYPERREF SETUP
% ============================================================
\newcommand\uftcc@hypersetup{%
  \begingroup
    \toks@={}
    \count@=0
    \@whilenum\count@<\value{keywords}\do{%
      \ifcase\count@
        \toks@=\expandafter{\csname uftKeyword:\the\count@\endcsname}%
      \else
        \toks@=\expandafter\expandafter\expandafter{%
          \expandafter\the\expandafter\toks@
          \expandafter;\expandafter\ %
          \csname uftKeyword:\the\count@\endcsname}%
      \fi
      \advance\count@ by 1}%
    \edef\x{\endgroup
      \noexpand\hypersetup{pdfkeywords={\the\toks@}}}%
  \x
  \hypersetup{%
    pdfauthor={\@authname\ \@authsurn},
    pdftitle={\local@title},
    pdfsubject={\local@deptstring\ de \local@deptname\ -- UFT},
    pdfcreator={LaTeX with uftreport-cc},
    breaklinks=true,
    raiselinks=true,
    pageanchor=true,
  }%
}

% ============================================================
% DEDICATÓRIA, RESUMO, ABSTRACT, AGRADECIMENTOS
% ============================================================
\newcommand\dedication[1]{%
  \gdef\@dedic{#1}%
  \cleardoublepage
  \thispagestyle{empty}
  \vspace*{\fill}
  \begin{flushright}
    \begin{minipage}{60mm}
      \raggedleft\normalsize\@dedic
    \end{minipage}
  \end{flushright}%
}

\newenvironment{abstract}{%
  \cleardoublepage
  \thispagestyle{empty}
  \chapter*{Resumo}
  \setlength{\parindent}{0pt}
}{%
  \vspace{.5cm}\\
  \count1=0
  \noindent{\bfseries Palavras-chave}: 
  \noindent\nohyphens{%
    \@whilenum\count1<\value{keywords}\do{%
      \csname uftKeyword:\the\count1\endcsname.\ %
      \advance\count1 by 1}}\par
}

\newenvironment{foreignabstract}{%
  \cleardoublepage
  \thispagestyle{empty}
  \chapter*{Abstract}
  \setlength{\parindent}{0pt}
}{%
  \vspace{.5cm}\\
  \count1=0
  \noindent{\bfseries Keywords}: 
  \noindent\nohyphens{%
    \@whilenum\count1<\@foreignkeyword\do{%
      \csname uftForeignkeyword:\the\count1\endcsname.\ %
      \advance\count1 by 1}}\par
}

\newenvironment{acknowledgement}{%
  \cleardoublepage
  \thispagestyle{empty}
  \chapter*{Agradecimentos}
  \noindent
}{\vspace*{\fill}}

% ============================================================
% AMBIENTE QUOTE ESTENDIDO
% ============================================================
\renewenvironment{quote}{%
  \list{}{%
    \leftmargin=4cm
    \topsep=10pt
    \parsep\z@ \@plus\p@
  }\item\relax\small\ignorespaces
}{\endlist}

% ============================================================
% GLOSSÁRIO / LISTA DE ABREVIATURAS / LISTA DE SÍMBOLOS
% ============================================================
\newcommand\printlosymbols{%
  \renewcommand\glossaryname{\listsymbolname}%
  \@input@{\jobname.los}}

\def\makelosymbols{%
  \newwrite\@losfile
  \immediate\openout\@losfile=\jobname.syx
  \def\symbl{\@bsphack\begingroup\@sanitize\@wrlos}%
  \typeout{Writing index of symbols file \jobname.syx}%
  \let\makelosymbols\@empty
}
\@onlypreamble\makelosymbols

\AtBeginDocument{%
  \@ifpackageloaded{hyperref}{%
    \def\@wrlos#1#2{%
      \protected@write\@losfile{}%
        {\string\indexentry{[#1] #2|hyperpage}{\thepage}}%
      \endgroup\@esphack}%
  }{%
    \def\@wrlos#1#2{%
      \protected@write\@losfile{}%
        {\string\indexentry{[#1] #2}{\thepage}}%
      \endgroup\@esphack}%
  }%
}

\newcommand\printloabbreviations{%
  \renewcommand\glossaryname{\listabbreviationname}%
  \@input@{\jobname.lab}}

\def\makeloabbreviations{%
  \newwrite\@labfile
  \immediate\openout\@labfile=\jobname.abx
  \def\abbrev{\@bsphack\begingroup\@sanitize\@wrlab}%
  \typeout{Writing index of abbreviations file \jobname.abx}%
  \let\makeloabbreviations\@empty
}
\@onlypreamble\makeloabbreviations

\AtBeginDocument{%
  \@ifpackageloaded{hyperref}{%
    \def\@wrlab#1#2{%
      \protected@write\@labfile{}%
        {\string\indexentry{[#1] #2|hyperpage}{\thepage}}%
      \endgroup\@esphack}%
  }{%
    \def\@wrlab#1#2{%
      \protected@write\@labfile{}%
        {\string\indexentry{[#1] #2}{\arabic{page}}}%
      \endgroup\@esphack}%
  }%
}

\newenvironment{theglossary}{%
  \if@twocolumn\@restonecoltrue\onecolumn\else\@restonecolfalse\fi
  \@mkboth{\MakeUppercase\glossaryname}{\MakeUppercase\glossaryname}%
  \chapter*{\glossaryname}%
  \list{}{%
    \setlength{\listparindent}{0in}%
    \setlength{\labelwidth}{1.0in}%
    \setlength{\leftmargin}{1.5in}%
    \setlength{\labelsep}{0.5in}%
    \setlength{\itemindent}{0in}}%
  \sloppy
}{%
  \if@restonecol\twocolumn\fi\endlist
}

\renewenvironment{theindex}{%
  \if@twocolumn\@restonecolfalse\else\@restonecoltrue\fi
  \twocolumn[\@makeschapterhead{\indexname}]%
  \@mkboth{\MakeUppercase\indexname}{\MakeUppercase\indexname}%
  \thispagestyle{plain}\parindent\z@
  \addcontentsline{toc}{chapter}{\indexname}%
  \parskip\z@ \@plus.3\p@\relax
  \columnseprule\z@
  \columnsep 35\p@
  \let\item\@idxitem
}{%
  \if@restonecol\onecolumn\else\clearpage\fi
}

% ============================================================
% CAMPOS EXTRAS (área de pesquisa, etc.)
% ============================================================
\newcount\@fields\@fields0
\newcommand\field[1]{%
  \global\@namedef{uftfields:\expandafter\the\@fields}{#1}%
  \global\advance\@fields by 1
}

\ProcessOptions\relax
\endinput
%%
%% Fim de uftreport.cls