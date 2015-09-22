% ----- use the article class as a base -----
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{barag_resume}[09/21/2015 - Sean Barag's resume/cv class]

\RequirePackage{geometry}
\RequirePackage{fancyhdr}                % It's a fancy... wait for it... header!
\RequirePackage{mdwlist}                 % itemize* and friends are more compact
\RequirePackage{parskip}                 % Use whitespace to delimit paragraphs & prevent indentations
\RequirePackage{multicol}                % Multiple columns for computer skills section
\RequirePackage{hyperref}                % Hyperlinks and metadata
\RequirePackage{calc}                    % Calculate box lengths
\RequirePackage{tikz}                    % Draw a neat li'l timeline
\RequirePackage{etoolbox}                % Checks for definition of things
\RequirePackage{fontspec}                % Use fontspec for really nice fonts
\RequirePackage{fontawesome}             % Use icons from the fontawesome project

\usetikzlibrary{calc}                    % allows more precise layout in TikZ
\usepgflibrary{arrows}                   % loads nicer arrows in PGF for the timeline

% ----- set up fonts -----
\newfontfamily{\sspb}[Ligatures=TeX, UprightFont={* Semibold}]{Source Sans Pro}
\setsansfont
    [Ligatures=TeX, % recommended
     UprightFont={* Light},
     ItalicFont={* Italic},
     BoldFont={*},
     BoldItalicFont={* Semibold Italic}]
    {Source Sans Pro}
\newcommand{\sspbold}[1]{{\sspb#1}}

%\setsansfont
%    [Ligatures=TeX, % recommended
%     UprightFont={* Condensed},
%     ItalicFont={* Oblique},
%     BoldFont={* Bold},
%     BoldItalicFont={* Bold Oblique}]
%    {DejaVu Sans}
\renewcommand*\familydefault{\sfdefault} % apply linux biolinum (sans-serif)

% ----- set up document geometry -----
\geometry{top=.25in,
          bottom=.1in,
          hmargin=.4in,
          marginparwidth=.25\textwidth,
          marginparsep=.05\textwidth,
          includemp, reversemp,     % Enable mergin par and move it to the left side
          letterpaper,
          includehead, includefoot}

\urlstyle{same}                          % sans-serif URLs

% ----- hyperlink & metadata setup -----
\hypersetup{
    colorlinks=false,             % don't color any links
    pdfborder={0 0 0},            % and prevent ugly boxes around them
    pdfdisplaydoctitle=true,      % show title instead of filename
}

% ----- email helper command -----
\newcommand{\mailto}[1]{\href{mailto:#1}{#1}}

% ----- commands to set info for the header
% use the LaTeX standard "\author" for your name
\newcommand{\homeaddress}[1]{\def\@homeaddress{#1}}
\newcommand{\phonenumber}[1]{\def\@phonenumber{#1}}
\newcommand{\emailaddress}[1]{\def\@emailaddress{#1}}
\newcommand{\portfolio}[1]{\def\@portfolio{#1}}

% ----- fancyhdr setup -----
\fancyheadoffset[LO,LE]{\marginparsep+\marginparwidth}        % header goes across marginpar
\pagestyle{fancy}
\lhead{%
    \Huge \textbf{\@author}
}
\rhead{%
    \flushright
    \begin{tabular}{r c}
        \@ifundefined{@homeaddress} {}{\@homeaddress          & \faHome \\  } % house
        \@ifundefined{@phonenumber} {}{\@phonenumber          & \faPhone\\ } % telephone
        \@ifundefined{@emailaddress}{}{\mailto{\@emailaddress}& \faEnvelopeO \\    } % envelope
        \@ifundefined{@portfolio}   {}{\url{\@portfolio}      & \faGithub} % <>
    \end{tabular}\hspace{-1.5ex}
}
\cfoot{}

\addtolength{\headheight}{\baselineskip*2}  % add extra space after header rule
\renewcommand{\headrulewidth}{.6pt}         % thicken the header rule
\addtolength{\parskip}{4pt}                 % expand space between paragraphs just a touch
\setlength{\footskip}{0pt}

% ----- resume section titles -----
\renewcommand*{\section}[1]{%
    \hspace{0pt}\marginpar{\sspbold{#1}}\relax
}

% ----- job entries -----
\newenvironment{job}[4]
{\tikz \coordinate (#4);\relax
{\large\emph{#1}\ }{\small in #2} \\
       #3
\begin{itemize*}}
{\end{itemize*}}

% ----- project entries -----
\newenvironment{project}[3]
{\tikz \coordinate (#3);\relax
{\large\emph{#1}} --- #2\\}
{}

% ----- computer skills itemize -----
\newenvironment{csitemize}
{\begin{list}{\labelitemi}{\leftmargin=.5cm \itemindent=0em}}
{\end{list}}

% ----- tikz styles for `git log --graph`-like lines -----
\tikzstyle{every picture}+=[remember picture] % ensure overlay pictures can reference every other picture
\tikzstyle{bubble} = [draw, circle, left = 0.5ex, anchor=south east]
\usetikzlibrary{positioning} % use more accurate baseline calculations
