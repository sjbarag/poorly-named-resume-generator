% ----- use the article class as a base -----
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{barag_resume}[12/05/2015 - Sean Barag's resume/cv class]

\RequirePackage{geometry}
\RequirePackage{fancyhdr}                % It's a fancy... wait for it... header!
\RequirePackage{mdwlist}                 % itemize* and friends are more compact
\RequirePackage{parskip}                 % Use whitespace to delimit paragraphs & prevent indentations
\RequirePackage{multicol}                % Multiple columns for computer skills section
\RequirePackage[pdfusetitle]{hyperref}   % Hyperlinks and metadata
\RequirePackage{bookmark}                % Better bookmarks
\RequirePackage{calc}                    % Calculate box lengths
\RequirePackage{tikz}                    % Draw a neat li'l timeline
\RequirePackage{etoolbox}                % Checks for definition of things
\RequirePackage{fontspec}                % Use fontspec for really nice fonts
\RequirePackage[fixed]{fontawesome5}     % Use icons from the fontawesome project
\RequirePackage{textcomp}                % Provides better diacritics
\RequirePackage[default, lining]{sourcesanspro}

\usetikzlibrary{calc}                    % allows more precise layout in TikZ
\usepgflibrary{arrows}                   % loads nicer arrows in PGF for the timeline

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
    pdfsubject={Resume/CV},       % correctly categorize PDF
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
\fancyhead[L]{%
    \Huge \textbf{\@author}
}
\fancyhead[R]{%
    \begin{tabular}{r c}
        \@ifundefined{@homeaddress} {}{\@homeaddress          & \faHome \\  } % house
        \@ifundefined{@phonenumber} {}{\@phonenumber          & \faPhone\\ } % telephone
        \@ifundefined{@emailaddress}{}{\mailto{\@emailaddress}& \faEnvelope[regular] \\ } % envelope
        \@ifundefined{@portfolio}   {}{\url{\@portfolio}      & \faGithub} % github
    \end{tabular}\hspace{-1.5ex}
}
\fancyfoot{}

\addtolength{\headheight}{\baselineskip*2}  % add extra space after header rule
\renewcommand{\headrulewidth}{.6pt}         % thicken the header rule
\setlength{\footskip}{0pt}

% ----- resume section titles -----
\newcommand{\marginsection}[1]{
    \phantomsection
    \addcontentsline{toc}{section}{#1}
    \hspace{0pt}\marginpar{ %
        \textbf{#1}
    }\relax
}

% ----- job entries -----
\newenvironment{job}[4]
{\tikz \coordinate (#4);\relax
{\large\textbf{#1}}{\small\hfill#2} \\
        #3
}
{}

% ----- project entries -----
\newenvironment{project}[3]
{\tikz \coordinate (#3);\relax
{\large\textbf{#1}} --- #2\\}
{}

% ----- computer skills itemize -----
\newenvironment{csitemize}[1] {
    % put the entire list in a minipage so it doesn't get broken up
    \begin{minipage}{\textwidth}\relax
    \textbf{#1}
    \begin{list}{\labelitemi}{\leftmargin=.5cm \itemindent=0em}
} {
    \end{list}
    \end{minipage}
}

% ----- tikz styles for `git log --graph`-like lines -----
\tikzstyle{every picture}+=[remember picture] % ensure overlay pictures can reference every other picture
\tikzstyle{bubble} = [draw, circle, left=0.5ex, anchor=south east, inner sep=0, minimum size=1ex]
\usetikzlibrary{positioning} % use more accurate baseline calculations
