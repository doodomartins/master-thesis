% vim:et:sw=2

%% ufsc-thesis.cls, a template that abides to changes introduced by RN 46/2019/CPG.
%%
%% Original authors and maintainers:
%% Alexis Huf <alexishuf@gmail.com>
%% Gustavo Zambonin <gustavo.zambonin@posgrad.ufsc.br>
%%
%% This class file was based on https://github.com/mateusduboli/ufsc-thesis-latex
%% - @rn46 The RN document: https://repositorio.ufsc.br/handle/123456789/197121
%% - @buDoc MS Word template: https://repositorio.ufsc.br/handle/123456789/197457
%% - @buDocTCC MS Word Formatting guide for TCCs: https://repositorio.ufsc.br/handle/123456789/174345
%% - @buWord MS Word Formatting guide: https://repositorio.ufsc.br/handle/123456789/198045
%% - buResumo MS Word template for "Resumo Estendido": https://repositorio.ufsc.br/handle/123456789/197458
%% - @buABNT ABNT NBR 14721:2011 : https://repositorio.ufsc.br/handle/123456789/180829
%% - @ABNT ABNT NBR 14721:2011

% Define versão necessária do LaTeX
\NeedsTeXFormat{LaTeX2e}

% Prove acesso a classe 'ufsc-thesis'
\ProvidesClass{ufsc-thesis}[2019/08/02 v0.2snapshot ufsc-thesis]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Declarações e tratamento inicial de opções                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [english]
% Ativa nomes de elementos (pré)textuais em inglês (secion, contents, table, figure, ...)
\newif\ifufscthesis@eng
\DeclareOption{english}{%
  \ufscthesis@engtrue%
  \PassOptionsToPackage{english}{babel}%
  \PassOptionsToClass{\CurrentOption}{abntex2}%
}

% [brazil]
% Por padrão, assume-se pt_BR, por isso a opção é ignorada
\DeclareOption{brazil}{\OptionNotUsed}

% [oneside]
% Por padrão o documento será twosided, mas o usuário pode pedir isso
% se estiver fazendo EQM/SAD/EQD no PPGCC onde há limites hard
% (20/40/60) no número de páginas do documento (o que inclui páginas
% em branco).
\newif\ifufscthesis@oneside
\DeclareOption{oneside}{%
  \ufscthesis@onesidetrue%
  \PassOptionsToClass{\CurrentOption}{abntex2}%
}

% [lmodern] [times] [arial]
% Escolhe a fonte: lmodern, times (default), ou arial.
%Veja cada um dos \newif para detalhes
\newif\ifufscthesis@lmodern % [lmodern] O ápice da tipografia. A maioria das
                            % pessoas vai achar que é Times

\newif\ifufscthesis@times % [times] Um clone da Times New Roman. Por razões
                          % legais a fonte não pode ser distribuída livremente.
                          % Se você usa windows ou ilegalmente roubou arquivos
                          % TTF, chame a fonte TTF no seu main.tex

\newif\ifufscthesis@arial % [arial] Como no caso da times, problemas de licença
                          % impedem a distribuição da fonte. Se você (ou quem te
                          % mandou usar) pediu arial, você na verdade não se
                          % importa com a fonte e vai ganhar uma helvetica.
                          % Se roubou o TTF ou está no windows,
                          % faça a configuração no main.tex
\ufscthesis@timestrue
\DeclareOption{lmodern}{\ufscthesis@lmoderntrue \ufscthesis@timesfalse \ufscthesis@arialfalse}
\DeclareOption{times}{\ufscthesis@lmodernfalse \ufscthesis@timestrue \ufscthesis@arialfalse}
\DeclareOption{arial}{\ufscthesis@lmodernfalse \ufscthesis@timesfalse \ufscthesis@arialtrue}

% [embeddedlogo]
% Se ativa, essa opção usa um logo da UFSC de alta qualidade que está
% embutido em base64 dentro do próprio arquivo .cls. Essa funcionalidade
% faz com que o arquivo .cls seja stand-alone.
% Esse desempacotamento depende de compilação com -shell-escape e de um
% ambiente UNIX-like. Sem essa opção, você deve manter o ufsc.pdf
% desse repositório para que seja incluído via \includegraphics{ufsc.pdf}
\newif\ifufscthesis@embeddedlogo
\DeclareOption{embeddedlogo}{%
  \ufscthesis@embeddedlogotrue%
}

% [nocapautoref]
% Por padrão \autoref será configurado para produzir Seção/Section ao invés de seção/section
% Passando essa opção, essa classe não irá alterar o comportamento padrão
\newif\ifufscthesis@nocapautoref
\DeclareOption{nocapautoref}{%
  \ufscthesis@nocapautoreftrue%
}

% [noabntexcite]
% Por padrão o abntex2cite é carregado, incluindo algumas opções pré-definidas
% (veja logo abaixo). Para desativar esse carregamento automático (por exemplo,
% para evitar algumas dessas opções, use a opção noabntex2cite
\newif\ifufscthesis@noabntexcite
\DeclareOption{noabntexcite}{%
  \ufscthesis@noabntexcitetrue%
}

% [nohidelinks]
% Por padrão essa classe desativa cor e bordas no links do documento (hyperref)
% Use essa opção para que hidelinks não seja passado ao hyperref por essa classe
\newif\ifufscthesis@nohidelinks
\DeclareOption{nohidelinks}{%
  \ufscthesis@nohidelinkstrue%
}

% [noplainurl] 
% Como informado pela BU, a ABNT NBR 6023:2018 não utiliza mais <>
% em URLs nas referências. A NBR 14724:2011 não apresenta nenhuma
% URL. Logo, visando a uniformização de estilo, <>'s são removidos do
% comando \url{}
\newif\ifufscthesis@noplainurl
\DeclareOption{noplainurl}{%
  \ufscthesis@noplainurltrue%
}

% [nocleanheader]
% O @buDoc apresenta headers mais limpos que o padrão do abnTeX2. Por padrão, esta
% classe coloca headers conforme o @buDoc. Use essa opção para restaurar os headers
% padrão do abnTex2
\newif\ifufscthesis@nocleanheader
\DeclareOption{nocleanheader}{%
  \ufscthesis@nocleanheadertrue%
}

% [embeddedlogo]
% Se ativa, essa opção usa um logo da UFSC de alta qualidade que está
% embutido em base64 dentro do próprio arquivo .cls. Essa funcionalidade
% faz com que o arquivo .cls seja stand-alone.
% Esse desempacotamento depende de compilação com -shell-escape e de um
% ambiente UNIX-like. Sem essa opção, você deve manter o ufsc.pdf
% desse repositório para que seja incluído via \includegraphics{ufsc.pdf}
\newif\ifufscthesis@embeddedlogo
\DeclareOption{embeddedlogo}{%
  \ufscthesis@embeddedlogotrue%
}

% [nopretextualbookmarks]
% Se ativa essa opção impede o abnTeX de gerar bookmarks para
% elementos pré-textuais. Bookmarks são o que dão origem às entradas
% constituem o table of contents exibido pelos leitores PDF,
% usualmente em barras laterais.
\newif\ifufscthesis@nopretextualbookmarks
\DeclareOption{nopretextualbookmarks}{%
  \ufscthesis@nopretextualbookmarkstrue%
}

% [nocleardoublepage]
% Por padrão, os comandos \tableofcontents \listoftables, \listoffigures,
% \listoflistings (se estiver definido) são modificados logo após
% o \begin{document} para que realizem um \cleardoublepage (portanto sendo
% impressos garantidamente em uma nóva página que ficará no anverso).
% Essa opção desativa a injeção dessa alteração
\newif\ifufscthesis@nocleardoublepage
\DeclareOption{nocleardoublepage}{%
  \ufscthesis@nocleardoublepagetrue%
}


% Todas as opções que não foram listadas anteriormente são redirecionadas para o abntex2
\DeclareOption*{%
 \PassOptionsToClass{\CurrentOption}{abntex2}%
}

% Faz a mágica acontecer
\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Carregar abnTeX2 e outros pacotes                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% O abnTeX2 faz \RequirePackage do babel após o hyperref. Em situações
% normais (fora da abntex). Isso realmente faria com que o \autoref{}
% continuasse usando nomes não-localizados. Mas usando abntex fora da
% nossa classe, algo evitava o bug. Esse algo parou de funcionar então
% é preciso pedir pelo babel antes mesmo do abntex2.
%
% Outro detalhe: brazil sempre precisa ser carregado (vide abntex2)
% Outro detalhe(2): english sempre precisa ser carregado, devido ao abstract
\RequirePackage[brazil,english]{babel}

% Carrega como base a classe 'abntex2'
\ifufscthesis@eng\else
  % Isso precisa ser feito antes do LoadClass[]{abntex2}
  \PassOptionsToClass{brazil}{abntex2}
\fi
\ifufscthesis@oneside
  \PassOptionsToClass{oneside}{abntex2} % violação consciente
\else
  \PassOptionsToClass{twoside}{abntex2} % @buABNT
\fi
\LoadClass[%
  12pt, %@buWord, @buABNT, @buDoc
  a4paper, %@rn46
  chapter=TITLE, % Caixa alta @buDoc @buWord
  section=TITLE  % Caixa alta @buDoc @buWord
                 % Capitalizado para subseção e menor @buDoc @buWord
]{abntex2}

\ifufscthesis@lmodern
  \RequirePackage{lmodern}
\fi
\ifufscthesis@times
  \RequirePackage{mathptmx}
\fi
\ifufscthesis@arial
  \RequirePackage{helvet}
  \renewcommand{\familydefault}{\sfdefault}
\fi

% Identação do primeiro paragráfo
\RequirePackage{indentfirst}

% Número da última página
\RequirePackage{lastpage}

% Citações
\ifufscthesis@noabntexcite\else
  % @buDoc e @buABNT mostram títulos destacados em negrito
  \PassOptionsToPackage{alf,abnt-emphasize=bf,abnt-doi=doi,abnt-url-package=url}{abntex2cite}
  \ifufscthesis@eng
    % Em inglês, usa & no lugar de "e"
    \PassOptionsToPackage{abnt-and-type=&}{abntex2cite}
  \else
    \PassOptionsToPackage{abnt-and-type=e}{abntex2cite}
  \fi
  \RequirePackage{abntex2cite}
\fi

\ifufscthesis@nohidelinks\else
  % abntex2 já chama o hyperref
  \AtBeginDocument{\hypersetup{hidelinks}}
\fi

\ifufscthesis@noplainurl\else 
  % remove os <> do \url{X} para consistencia com as referencias (cf. NBR 6023:2018)
  \DeclareUrlCommand\url{\def\UrlLeft{}\def\UrlRight{}}
  \renewcommand{\nolinkurl}[1]{#1}
\fi

% Usado para incluir o logo da UFSC
\RequirePackage{graphicx}

% Usado para incluir a ficha catalográfica
\RequirePackage{pdfpages}

% Coisas usadas para truques aqui na classe
\RequirePackage{etoolbox}
\RequirePackage{ifthen}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% i18n                                                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifufscthesis@eng
  % Nomeclatura de orientador e Coorientador cf @buWord e @buABNT
  % Esses nomes devem permanecer em pt_BR mesmo para trabalhos escritos em inglês
  \addto\captionsenglish{%
    \renewcommand{\orientadorname}{Orientador:}%
    \renewcommand{\coorientadorname}{Coorientador:}%
  }

  % Ativa o idioma em cada uma das partes
  \appto{\pretextual}{\selectlanguage{english}}
  \appto{\textual}{\selectlanguage{english}}
  \appto{\postextual}{\selectlanguage{english}}
  \selectlanguage{english}
\else
  \addto\captionsbrazil{%
    % abntex2 não algumas macros dentro da linguagem BR. Após fazer
    % essa sequência de trocas: br -> en -> br, \essas macros permanecem
    % em en, quando deveriam ter voltado para br.
    \renewcommand{\orientadorname}{Orientador:}%
    \renewcommand{\coorientadorname}{Coorientador:}%
    \renewcommand{\epigraphname}{Ep\'igrafe}%
    \renewcommand{\dedicatorianame}{Dedicat\'oria}%
    \renewcommand{\agradecimentosname}{Agradecimentos}%
    \renewcommand{\anexoname}{ANEXO}%
    \renewcommand{\anexosname}{Anexos}%
    \renewcommand{\apendicename}{AP\^ENDICE}%
    \renewcommand{\apendicesname}{Ap\^endices}%
    \renewcommand{\listadesiglasname}{Lista de abreviaturas e siglas}%
    \renewcommand{\listadesimbolosname}{Lista de s\'imbolos}%
    \renewcommand{\fontename}{Fonte}%
    \renewcommand{\notaname}{Nota}%
  }
  % Ativa o idioma em cada uma das partes
  \appto{\pretextual}{\selectlanguage{brazil}}
  \appto{\textual}{\selectlanguage{brazil}}
  \appto{\postextual}{\selectlanguage{brazil}}
  \selectlanguage{brazil}
\fi

% \*name's que só existem nessa classe
\providecommand{\listadesimbolosname}{Lista de S\'imbolos}%
\addto\captionsenglish{
  \renewcommand{\listadesimbolosname}{List of Symbols}%
}
\addto\captionsbrazil{
  \renewcommand{\listadesimbolosname}{Lista de S\'imbolos}%
}

\ifufscthesis@nocapautoref\else
  \addto\captionsenglish{%
    \renewcommand{\chapterautorefname}{Chapter}%
    \renewcommand{\sectionautorefname}{Section}%
    \renewcommand{\subsectionautorefname}{Subsection}%
    \renewcommand{\subsubsectionautorefname}{Subsubsection}%
  }
  \addto\captionsbrazil{%
    \renewcommand{\chapterautorefname}{Cap\'{i}tulo}%
    \renewcommand{\sectionautorefname}{Se\c{c}\~{a}o}%
    \renewcommand{\subsectionautorefname}{Subse\c{c}\~{a}o}%
    \renewcommand{\subsubsectionautorefname}{Subsubse\c{c}\~{a}o}%
  }
  % Usando abntex2 \subsubsection e \paragraph são dois comandos para
  % mesma coisa. No caso de subsection, o autoref não recebe os nomes
  % do babel
  \def\HyLang@english{
      % O abnTeX2 explicitamente configura subsubsubsection em en
      \def\paragraphautorefname{Subsubsubsection}%
  }
  \def\HyLang@portuges{
      % O abnTeX2 explicitamente configura subsubseção em pt_BR
      \def\paragraphautorefname{Subsubse\c{c}\~{a}o}%
  }
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Comandos gerais                                                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%\captionsource{<text>} 
% Comando removido! use \fonte{}, do abnTeX


% O @buDoc usa extensivamente linhas em branco como recurso estético
\newcommand{\ufscthesis@lbreak}[0]{\par\vspace{\baselineskip}\par}

% \ifufscthesis@oneside
%   \newcommand{\ufscthesis@cleardoublepage}[0]{\clearpage}
% \else
%   \newcommand{\ufscthesis@cleardoublepage}[0]{\cleardoublepage}
% \fi

\providecommand{\imprimirfichacatalografica}[0]{%
\clearpage\begingroup\centering\bfseries %
  \vspace*{\fill}%
  A ficha catalogr\'{a}fica deve ser gerada usando o sistema da BU em
  \url{https://ficha.bu.ufsc.br/}. Posteriormente o PDF deve ser inclu\'{i}do via
  \textbackslash{}includepdf{nome.pdf}%
  \vspace*{\fill}%
\endgroup\clearpage}

% \incluirfichacatalografica{<pdf>}
% Inclui ficha catalográfica gerada no site http://ficha.bu.ufsc.br/
\newcommand{\incluirfichacatalografica}[1]{%
  \clearpage % força troca de página. Importante fazer isso antes do includepdf
  \includepdf{#1}%
  \clearpage%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Comandos de dados                                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comandos de dados - programa
\providecommand{\imprimirprograma}{}
\newcommand{\programa}[1]{\renewcommand{\imprimirprograma}{#1}}

% \titulode{Doutor em Ciência da Computação}
% Define o título ao qual o trabalho corresponde
\newtoggle{ufscthesishastitulode}
\providecommand{\imprimirtitulode}{}
\newcommand{\titulode}[1]{\toggletrue{ufscthesishastitulode}\renewcommand{\imprimirtitulode}{#1}}
\newcommand{\ufscthesis@titulode}[0]{%
  \iftoggle{ufscthesishastitulode}%
    {\imprimirtitulode}%
    {\begingroup \bfseries Erro: chame \textbackslash{}titulode\endgroup}%
}%

% \tese
% \dissertacao
% \tcc
% Define o tipo de trabalho. Você pode usar o \tipotrabalho definido no abnTeX2,
% mas alguns defaults dessa classe deixarão de ser computados.
% O mais importante deles é o \preambulo
\newtoggle{ufscthesistese}
\newtoggle{ufscthesistcc}
\newcommand{\tese}[0]{%
  \toggletrue{ufscthesistese}
  \renewcommand{\imprimirtipotrabalho}{Tese}%
}
\newcommand{\dissertacao}[0]{\renewcommand{\imprimirtipotrabalho}{Dissertação}}
\newcommand{\tcc}[0]{%
  \toggletrue{ufscthesistcc}%
  \renewcommand{\imprimirtipotrabalho}{Trabalho de Conclusão do Curso}%
}

% \nivel{<mestrado/doutorado/graduação>}
% Nível do trabalho. Usado na folha de certificação cf. @buDoc e @buABNT
% O valor padrão é inferido pelo uso de \tese, \dissertacao ou \tcc
\providecommand{\imprimirnivel}{%
  \iftoggle{ufscthesistese}%
    {doutorado}%
    {\iftoggle{ufscthesistcc}%
      {gradua\c{c}\~{a}o}%
      {mestrado}}%
}
\newcommand{\nivel}[1]{\renewcommand{\imprimirnivel}{#1}}

% \centro{<centro>}
% Configura o nome do centro da UFSC
\providecommand{\imprimircentro}{}
\newcommand{\centro}[1]{\renewcommand{\imprimircentro}{#1}}

% \departamento{<departamento>}
% Configura o nome do departamento (apenas para TCCs (\tcc))
\providecommand{\imprimirdepartamento}%
  {\begingroup \bfseries Erro: chame \textbackslash{}departamento\{...\}\endgroup}
\newcommand{\departamento}[1]{\renewcommand{\imprimirdepartamento}{#1}}

% \curso{<curso>}
% Configura o nome do curso (apenas para TCCs (\tcc))
\providecommand{\imprimircurso}%
  {\begingroup \bfseries Erro: chame \textbackslash{}curso\{...\}\endgroup}
\newcommand{\curso}[1]{\renewcommand{\imprimircurso}{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Banca e coordenação (folha de certificação)                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Uso interno. Lista de membros da banca
\newcommand*\ufscthesis@banca{}
% Uso interno. Lista de membros da banca
\newcommand{\ufscthesis@membrobanca}[2]{#1\par#2}
% 6.61cm medido no template oficial @buWord
\newcommand{\ufscthesis@certificador}[3][]{\rule{6.61cm}{1pt}\par#2\par#3\par\ifblank{#1}{}{#1\par}}

% \membrobanca[<papel>]{<nome>}{<Universidade>}
% \membrabanca{<nome>}{<Universidade>}
%
% Adiciona um membro da banca.
% O argumento opcional <papel> só é utilizado para TCCs (\tcc) e o seu valor
% padrão é Avaliador. No caso de avaliadoras, é possível alterar esse argumento
% ou usar o comando \mebrabanca.
\newcommand{\membrobanca}[3][Avaliador]{%
  \listadd{\ufscthesis@banca}{%
    \iftoggle{ufscthesistcc}%
    {\rule{6.61cm}{1pt}\par#2\par#1\par#3}
    {#2\par#3}
  }%
}
\newcommand{\membrabanca}[2]{\membrobanca[Avaliadora]{#1}{#2}}

% \coordenador[a]{<nome>}
% Configura o nome do(a) Coordenador(a) do programa
% @buDoc @buABNT mostram nesse caso o Dr. antes do nome.
\newcommand{\imprimircoordenador}[0]{}
\newcommand{\coordenador}[2][]{%
  \renewcommand{\imprimircoordenador}%
    {\ufscthesis@certificador{#2}{Coordenador#1 do \iftoggle{ufscthesistcc}{Curso}{Programa}}}%
}
\newcommand{\coordenadora}[1]{\coordenador[a]{#1}}

% \orientadora
% \coorientadora
%
% Versões femininas dos comandos abnTeX2
\newtoggle{ufscthesisfemsupervisor}
\newcommand{\orientadora}[1]{
  \toggletrue{ufscthesisfemsupervisor}
  \orientador[Orientadora:]{#1}
}
\newtoggle{ufscthesisfemcosupervisor}
\newcommand{\coorientadora}[1]{%
  \toggletrue{ufscthesisfemcosupervisor}
  \coorientador[Coorientadora:]{#1}
}

% \afiliacaoorientador{<universidade/empresa/instituição>}
% \afiliacaoorientadora{<universidade/empresa/instituição>}
% \afiliacaocoorientador{<universidade/empresa/instituição>}
% \afiliacaocoorientadora{<universidade/empresa/instituição>}
%
% Define a afiliação do orientador e coorientador. Por padrão a afiliação de
% ambos é Universidade Federal de Santa Catarina. A afiliação apenas é exibida
% em TCCs, configurados com \tcc.
\newcommand{\imprimirafiliacaoorientador}{Universidade Federal de Santa Catarina}%
\newcommand{\imprimirafiliacaocoorientador}{Universidade Federal de Santa Catarina}%
\newcommand{\afiliacaoorientador}[1]{%
  \renewcommand{\imprimirafiliacaoorientador}{#1}%
}
\newcommand{\afiliacaocoorientador}[1]{%
  \renewcommand{\imprimirafiliacaocoorientador}{#1}%
}
\newcommand{\afiliacaoorientadora}[1]{\afiliacaoorientador{#1}}
\newcommand{\afiliacaocoorientadora}[1]{\afiliacaocoorientador{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Padrões para Comandos de dados do abnTeX2                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \preambulo{<texto>}
% Texto padrão conforme @buABNT. Esse default só é configurado se os comandos
% dessa classe, \tese ou \dissertacao, foram usados
\renewcommand{\imprimirpreambulo}{%
  \iftoggle{ufscthesistcc}%
  {%
    \imprimirtipotrabalho~do Curso de Gradua\c{c}\~{a}o em %
    \imprimircurso~do \imprimircentro~da Universidade Federal de Santa Catarina %
    como requisito para obten\c{c}\~{a}o do t\'{i}tulo de %
    \ufscthesis@titulode{}.%
  }{%
    \imprimirtipotrabalho~submetida~ao \imprimirprograma{} para a %
    obten\c{c}\~{a}o do t\'{i}tulo de \ufscthesis@titulode{}.%
  }%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Comandos para configurar data                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \data{1 de janeiro de 2019}
% \dia{<dia>}
% \mes{<mes>}
% \ano{<ano>}
% @buDoc e @buABNT usam a data em duas situações.
% - O ano, na capa e folha de rosto
% - "\dia de \mes de \ano" na folha de certificação
% Por padrão esses três componentes são extraídos da data atual
% Se o usuário usar o comando \data{} esse comando irá
% sobreescrever a data usada na ficha de certificação. Uma leve
% bruxaria faz um parsing porco para extrair o ano e usar na
% capa e folha de rosto.
\providecommand{\imprimirano}{\the\year}
\providecommand{\imprimirmes}{%
  \ifcase \month \or Janeiro\or Fevereiro\or Março%
  \or Abril\or Maio\or Junho\or Julho\or Agosto%
  \or Setembro\or Outubro\or Novembro\or Dezembro\fi%
}
\providecommand{\imprimirdia}{\the\day}
\newcommand{\ano}[1]{\renewcommand{\ano}{\#1}}
\newcommand{\mes}[1]{\renewcommand{\mes}{\#1}}
\newcommand{\dia}[1]{\renewcommand{\dia}{\#1}}
\renewcommand{\imprimirdata}{\imprimirano} % engana abnTeX2

% Uso na folha de certificação
\newcommand{\imprimirdataext}{\imprimirdia{} de \imprimirmes{} de \imprimirano}

% https://tex.stackexchange.com/a/236213
\newcommand*\ufscthesislastword[1]{\expandafter\xreverseit\expandafter{\expandafter}#1 \relax}
\def\xreverseit#1#2 #3{%
  \ifx\relax#3%
  #2%
  \expandafter\xthree
  \fi
  \xreverseit{#1 #2}#3%
}
\def\xthree#1#2#3{}

% Configura data como no abnTeX2. Forneça a data completa, como
% irá aparecer na folha de certificação. O ano *deveria* ser extraído
\renewcommand{\data}[1]{%
  \renewcommand{\imprimirdataext}{#1}%
  \renewcommand{\imprimirano}{\ufscthesislastword{#1}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Formatação                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Margens
\setlrmarginsandblock{3cm}{2cm}{*}  % {left}{right} no anverso (p. ímpar) @buABNT
\setulmarginsandblock{3cm}{2cm}{*}  % {upper}{lower}                      @buABNT
\checkandfixthelayout%

% Cabeçalho e Rodapé
%   - @buWord diz 2 cm para ambos, com alinhamento vertical superior
%   - Essas configs não tem efeito visual perceptível, provaveis defaults do abnTeX2
\setheadfoot{2cm}{1cm} % {header height}{footsep (from bottom of text)}
\setlength\headsep{1cm} % sep from header bottom to text upper margin
% Aplica mudanças de layout
\checkandfixthelayout%

% Altera o estilo do cabeçalho
\ifufscthesis@nocleanheader\else
  %https://github.com/abntex/abntex2/wiki/HowToCustomizarCabecalhoRodape
  \makepagestyle{estiloufsctextual}
    %%cabeçalhos
    \makeevenhead{estiloufsctextual} %%pagina par
       {\footnotesize \thepage}{}{}
    \makeoddhead{estiloufsctextual} %%pagina ímpar ou com oneside
       {}{}{\footnotesize \thepage}
    %% rodapé
    \makeevenfoot{estiloufsctextual}
       {}{}{}
    \makeoddfoot{estiloufsctextual} %%pagina ímpar ou com oneside
       {}{}{}
  % Aplica o estilo no modo textual
  \appto{\textual}{\pagestyle{estiloufsctextual}}
\fi

% Remove numeração de página) @buDoc.
\AtBeginDocument{
  \protect\pagestyle{empty}
  \addtocontents{toc}{\protect\thispagestyle{empty}}
}
\AtEndDocument{\addtocontents{toc}{\protect\thispagestyle{empty}}}

% Tamanhos e estilos de fontes para chapter e (sub)*section
% Também aplica \noindent @buWord[p.10]
% Para títulos de capítulo ainda parece existir 1em de recuo na esquerda, mas parece ser algo do memoir
\renewcommand{\ABNTEXchapterfont}{\bfseries} % @buDoc @buWord[p. 8]
\renewcommand{\ABNTEXchapterfontsize}{\normalsize}    % @buDoc @buWord
\renewcommand{\ABNTEXsectionfont}{\noindent\normalfont} % @buDoc @buWord
\renewcommand{\ABNTEXsectionfontsize}{\normalsize}      % @buDoc @buWord
\renewcommand{\ABNTEXsubsectionfont}{\noindent\bfseries} % @buDoc @buWord
\renewcommand{\ABNTEXsubsectionfontsize}{\normalsize}    % @buDoc @buWord
%@buDoc possívelmente contem um erro pois inverte a formatação de subsubsection
%com subsubsubsection indicada no @buWord, além de não estar numerado
%corretamente (falta um ".1")
\renewcommand{\ABNTEXsubsubsectionfont}{\noindent\itshape} % @buWord
\renewcommand{\ABNTEXsubsubsectionfontsize}{\normalsize}   % @buWord
\renewcommand{\ABNTEXsubsubsubsectionfont}{\noindent\normalfont} % @buWord
\renewcommand{\ABNTEXsubsubsubsectionfontsize}{\normalsize}      % @buWord

% Estilos de fonte usados no sumário devem corresponder aos estilos usados
% no títulos @buWord @buDoc

% seções em caixa alta
\let\oldcontentsline\contentsline
\def\contentsline#1#2{%
  \expandafter\ifx\csname l@#1\endcsname\l@section
    \expandafter\@firstoftwo
  \else
    \expandafter\@secondoftwo
  \fi
  {%
    \oldcontentsline{#1}{\MakeUppercase{#2}}%
  }{%
    \oldcontentsline{#1}{#2}%
  }%
}

\renewcommand{\cftsectionfont}{\normalfont}                 % @buDoc @buWord
\renewcommand{\cftsubsectionfont}{\normalfont\bfseries}     % @buDoc @buWord
\renewcommand{\cftsubsubsectionfont}{\normalfont\itshape}   % @buWord
\renewcommand{\cftparagraphfont}{\normalfont}               % @buWord

% Tamanho de fonte em cabeçalhos e rodapés. @buWord, @buDoc
% (o default do abntex2 (footnotesize) já parecia ser 10, mas foi preciso fazer força para afetar figure e table)
\renewcommand{\footnotesize}{\fontsize{10pt}{12pt}\selectfont}
\renewcommand{\ABNTEXfontereduzida}{\footnotesize}
\AtBeginDocument{%
  \captionnamefont{\footnotesize}%
  \captiontitlefont{\footnotesize}%
}

% Espaçamento depois do título
%  - @buDoc deixa sempre 1 linha com esp. 1,5 em branco após chapter, section e subsection. Em LaTeX 1em equivale a altura de uma linha, por isso 1.5em. Com normalsize sendo 12pt, 1em=18pt=0.6326cm. O ufsc-thesis do Mateus Dubiela usava 0.38cm para chapskip e deixava o padrão para os demais
\setlength{\afterchapskip}{1.5em}
\setlength{\aftersecskip}{1.5em}
\setlength{\aftersubsecskip}{1.5em}
% - Essa prática do @buDoc não é estéticamente agradável. Mas foi mantida pois o template a utiliza até subseções (não há exemplos para os níveis inferiores). Como por algum motivo não é possível controlar o espaçamento de sub-sub-subseção (o chapskip é usado), optou-se por aplicar o mesmo espaçamento para tudo que pode ser configurado
\setlength{\aftersubsubsecskip}{1.5em}

% Espaçamento depois dos paragráfos @buDoc @buWord
\setlength{\parskip}{0.0cm}
% De acordo com @buABNT, na bibliografia deve haver uma linha em branco entre entradas
\let\ufscthesis@oldthebibliography\thebibliography
\let\ufscthesis@url\url
%\renewcommand{\htmladdnormallink}[2]{\href{#2}{#2}}
\renewcommand{\thebibliography}[1]{%
  % @bibliotecaria: em email privado a BU informou que a NBR 6023:2018
  % não usa <> em referências. Isso causa o desaparecimento dos <>
  % caso \url{} seja usado no bib. Como o abntex2cite foi configurado
  % para usar \url, ele também será afetado
  \DeclareUrlCommand\url{\def\UrlLeft{}\def\UrlRight{}}%
  % Em um mundo ideal o comando acima deveria ser suficiente. No entanto, \url
  % está teimando em transformar _ e # em \_ e \#. A gambiarra abaixo evita isso.
  % Surpreendentemente continua funcionando quando o usuário coloca # e _ não 
  % escapados no campo url.
  \def\url#1{\href{#1}{#1}}
  % o +.2 é o interlineskip, pra criar a ilusão de que o autor cometeu a
  % heresia de separar as entradas com uma quebra de parágrafo isso é exigência do @buABNT
  \setlength{\parskip}{\baselineskip}%
  \ufscthesis@oldthebibliography{#1}%
}
\let\url\ufscthesis@url
% Indent da primeira linha do parágrafo @buDoc @buWord
\setlength{\parindent}{1.5cm}
% Espaçamento entre linhas de 1,5 @buDoc @buWord @buABNT
\OnehalfSpacing
% Lugares que exigem espaçamento entre linhas simples @buWord[p. 7]
% - Floats (figure/table): Fracassei em alterar, mas default já é SingleSpacing
% - footnotes: Fracassei em alterar, mas default já é SingleSpacing
% - referencias: Nem tentei alterar, mas o default já é SingleSpacing


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Comandos para gerar elementos especiais                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifufscthesis@embeddedlogo
  % 
  \newcommand{\ufscthesis@logo}{\jobname-logo.pdf}
  \AtBeginDocument{%
    \immediate\write18{base64 --decode \jobname.64 > \jobname-logo.pdf}
  }
\else
  % Alguns caminhos possíveis onde o aluno poderia ter nos largado
  % O pacote currfile não permite pegar o diretório/arquivo da classe por
  % isso esse trabalho em volta. Quem ler o README não deveria sofre (muito)
  \graphicspath{%
    {.}%
    {ufsc-thesis/}%
    {../ufsc-thesis/}%
    {ufsc-thesis/}%
    {../ufsc-thesis/}%
  }
  \newcommand{\ufscthesis@logo}{tex/pre_tex/logo-ufsc.pdf}
\fi

% alterando a capa
\renewcommand{\imprimircapa}{%
  \begin{capa}
    \begin{center}
      \selectlanguage{brazil}
      \iftoggle{ufscthesistcc}%
        {}%
        {\includegraphics[height=2.54cm,width=1.84cm]{\ufscthesis@logo}}

      {
        \ABNTEXsectionfont
        \MakeTextUppercase{\imprimirinstituicao}

        \MakeTextUppercase{\imprimircentro}
        
        \iftoggle{ufscthesistcc}{
          \MakeTextUppercase{\imprimirdepartamento}

          \MakeTextUppercase{\imprimircurso}
        }{
          \MakeTextUppercase{\imprimirprograma}
        }
      }
      \vspace*{4cm}

      {
        \ABNTEXsectionfont
        \imprimirautor
      }
      \vspace*{5cm}

      {
        \ABNTEXchapterfont
        \imprimirtitulo
      }
      \vfill

      \imprimirlocal

      \imprimirano
      \vspace*{1cm}
    \end{center}
  \end{capa}
  \setcounter{page}{1}
}


% Folha de rosto segundo modelo novo da BU
\renewcommand{\folhaderostocontent}{
  \begin{center}
    \selectlanguage{brazil} 
    % Nome do autor em caixa baixa sem negrito
    {\ABNTEXchapterfont\textmd\imprimirautor}
    \vspace*{\fill}
    % Título do trabalho em caixa alta e negrito
    \begin{center}
      {\ABNTEXchapterfont\bfseries\large\imprimirtitulo}
    \end{center}
    \vspace*{1cm}
    % Preâmbulo seguido de nomes do orientador e coorientador com recuo
    \abntex@ifnotempty{\imprimirpreambulo}{%
      \hspace{.45\textwidth}
      \begin{minipage}{.5\textwidth}
        \ABNTEXfontereduzida
        \SingleSpacing
        \imprimirpreambulo
        % Nomes do orientador e coorientador
        {\par \imprimirorientadorRotulo~\imprimirorientador\par}
        \abntex@ifnotempty{\imprimircoorientador}{%
           {\par\imprimircoorientadorRotulo~\imprimircoorientador}%
        }%
      \end{minipage}%
      \vspace*{\fill}
    }%
    \vspace*{\fill}

    % Local e data em caixa baixa sem negrito
    {\imprimirlocal}
    \par{\imprimirano}
    \vspace*{1cm}
  \end{center}
  \newpage
}

% Origem: @buDoc e @buABNT Atenção o uso de \vspace*{\fill} nos
% locais usados foi uma advinhação do autor que vos fala. Não há
% nenhuma instrução da BU sobre os espaçamentos verticais na folha de
% certificação.  Em contato com a BU, a estratégia adotada foi:
% 1. Separar membros da banca com uma linha (\ufscthesis@lbreak)
% 2. Aplicar \fill em todos os demais espaçamentos, usando o 
%    dobro de força nos casos onde o @buDoc usava 2+ linhas
\newcommand{\folhadecertificacaocontent}{
  \begin{center}
    \selectlanguage{brazil} 
    \normalsize
    \OnehalfSpacing %usado na folha inteira
    % Nome do autor em caixa baixa sem negrito
    {\imprimirautor} \par
    % Apenas 1,5 de espaço Título em negrito (e subtitulo sem)
    {\centering\bfseries \imprimirtitulo} \par
    \vspace*{\fill}
    %\ufscthesis@lbreak % uma linha em branco
    O presente trabalho em n\'{i}vel de \imprimirnivel{} foi avaliado e aprovado por banca examinadora composta pelos seguintes membros:
    % Imprime os membros (sem linhas para assinatura)
    \forlistloop{\ufscthesis@lbreak}{\ufscthesis@banca} \par
    \vspace*{\fill}
    Certificamos que esta \'{e} a {\bfseries vers\~{a}o original e final} do trabalho
      de conclus\~{a}o que foi julgado adequado para obten\c{c}\~{a}o do t\'{i}tulo de \ufscthesis@titulode. \par
    \vspace*{\fill}
    \vspace*{\fill}
    % Pessoas que assinam o documento (por isso eles tem a linha)
    \imprimircoordenador
    \vspace*{\fill}
    \vspace*{\fill}
    \ufscthesis@certificador{\imprimirorientador}{
      Orientador\iftoggle{ufscthesisfemsupervisor}{a}{}
    }
    \vspace*{\fill}
    \vspace*{\fill}
    % Local e data em caixa baixa sem negrito
    % Em algum momento de setembro ou outubro (hoje é 14 do 10 de
    % 2019) a BU trocou a data extensa (\imprimirdataext) por
    % simplemente ano (\imprimirano) no template docx.
    \imprimirlocal, \imprimirano.
  \end{center}
}

% Mesma origem que \folhadecertificacaocontent e adicionalmente, @buDocTCC.
% Usado apenas com TCCs
\newcommand{\folhadeaprovacaocontent}{
  \begin{center}
    \selectlanguage{brazil} 
    \normalsize
    \OnehalfSpacing %usado na folha inteira
    % Nome do autor em caixa baixa sem negrito
    {\imprimirautor} \par
    % Apenas 1,5 de espaço Título em negrito (e subtitulo sem)
    {\centering\bfseries \imprimirtitulo} \par
    \vspace*{\fill}
    %\ufscthesis@lbreak % uma linha em branco
    Este \imprimirtipotrabalho{} foi julgado adequado para obten\c{c}\~{a}o do T\'{i}tulo de \ufscthesis@titulode{} e aprovado em sua forma final pelo curso de Gradua\c{c}\~{a}o em \imprimircurso. \par
    \vspace{1em}
    % Para TCCs, tanto @buABNT quanto @buDocTCC usam a data por extenso
    \imprimirlocal, \imprimirdataext. \par
    \vspace*{\fill}
    % Imprime coordenador
    \imprimircoordenador
    % Imprime a banca (incluindo orientador e coorientador
    \vspace*{\fill}
    \vspace*{\fill}
    {\centering\bfseries Banca Examinadora: \par}%
    \vspace*{\fill}
    \ufscthesis@certificador%
      [\imprimirafiliacaoorientador]%
      {\imprimirorientador}%
      {Orientador\iftoggle{ufscthesisfemsupervisor}{a}{}}%
    \vspace*{\fill}
    \abntex@ifnotempty{\imprimircoorientador}{%%
      \ufscthesis@certificador%
        [\imprimirafiliacaocoorientador]%
        {\imprimircoorientador}%
        {Coorientador\iftoggle{ufscthesisfemcosupervisor}{a}{}}%
    }%
    \forlistloop{\ufscthesis@lbreak}{\ufscthesis@banca} \par
  \end{center}
}

% \imprimirfolhadecertificacao
% \imprimirfolhadeaprovacao 
%
% Ambos são equivalentes. O tipo de folha (aprovação ou certificação) será
% definido de acordo com tipo de trabalho definido (via \tcc, \dissertacao ou
% \tese). TCCs usam "Folha de aprovação" enquando teses e dissertações usam
% folha de certificação.
\newcommand{\imprimirfolhadecertificacao}[0]{%
  \cleardoublepage%
  \iftoggle{ufscthesistcc}%
    {\folhadeaprovacaocontent}%
    {\folhadecertificacaocontent}%
  \cleardoublepage%
}
\newcommand{\imprimirfolhadeaprovacao}[0]{\imprimirfolhadecertificacao}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ambientes modificados                                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Desativa bookmarks para elementos pré-textuais
\ifufscthesis@nopretextualbookmarks
  \apptocmd{\pretextual}{%
    \let\ufscthesis@oldPRIVATEbookmarkthis\PRIVATEbookmarkthis
    \renewcommand{\PRIVATEbookmarkthis}[1]{}
  }{}{}
  \apptocmd{\textual}{%
    \renewcommand{\PRIVATEbookmarkthis}[1]{\ufscthesis@oldPRIVATEbookmarkthis{#1}}
  }{}{}  
\fi

% @buABNT O texto deve ficar na parte inferior da página e alinhado a direita O
% recuo de 5cm foi medido no @buDoc
\apptocmd{\dedicatoria}{%
  \selectlanguage{brazil}
  \vspace*{\fill}%
  \flushright%
  \minipage{\dimexpr\linewidth-5cm\relax}%
  \noindent\flushright%
}{}{}
\pretocmd{\enddedicatoria}{\endminipage}{}{} 

% @buABNT O texto deve ficar na parte inferior da página e alinhado a direita O
% @buDoc diz que devem ser usadas as regras da ABNT NBR 10520, e aplica todas as
% regras do ambiente citacao, exceto pelo tamanho da fonte, 11, ao invés de
% 10. Provavelmente um acidente. Portanto aplicamos todas as regras do ambiente
% citacao O recuo de 4cm foi medido no @buDoc
\apptocmd{\epigrafe}{%
  \selectlanguage{brazil}
  \vspace*{\fill}%
  \flushright%
  \minipage{\dimexpr\linewidth-5cm\relax}%
  \SingleSpacing\ABNTEXfontereduzida%
  \noindent\flushright%
}{}{}
\pretocmd{\endepigrafe}{\endminipage}{}{} 

% @buDoc e @buResumo exigem para os resumos (incluindo o estendido e o
% abstract) espaçamento simples e paragrafos sem indentação Como a
% abnTeX2 define resumo em cima de \begin{abstract}, essas coisas
% podem ser aplicadas diretamenteo no abstract. No caso do resumo
% estendido o @buResumo mostra que não deve ser aplicado o
% espaçamento após os títulos. Como resumo chama abstract e uma
% implementação usando \AtBeginEnvironment estava muito fŕagil, os
% ambientes do abnTeX2 foram refeitos
\newenvironment{ufscthesisresumo}[2]{%
  \pretextualchapter{#1}%
  \begingroup
  % remove espaçamentos após seções (resumo estendido -- @buResumo)
  \setlength{\afterchapskip}{1pt}% 0pt tirar a quebra de linha!
  \setlength{\aftersecskip}{1pt}%
  \setlength{\aftersubsecskip}{1pt}%
  \setlength{\aftersubsubsecskip}{1pt}%
  % @buResumo adota formatação de subsection no maior nível. Caso o
  % aluno use section, formate como subsection
  \boolfalse{ABNTEXuppersection}%
  \renewcommand{\ABNTEXsectionfont}{\noindent\bfseries}% @buDoc @buWord
  % Altera linguagem e aplica formatação @buDoc e @buResumo
  \selectlanguage{#2}%
  \setlength{\parindent}{0pt}% 
  \SingleSpacing%
  \ignorespaces% evita typeset de espaços antes do texto
}{\endgroup}
\renewenvironment{resumo}[1][Resumo]{%
  % Se o aluno originalmente escreveu seu documento para o abnTeX2,
  % ele vai tentar passar Abstract aqui esperando que a linguagem seja
  % inglês...
  \ifstrequal{#1}{Abstract}{\def\ufscthesis@resumoabstract{1}}{}%
  \ifstrequal{#1}{ABSTRACT}{\def\ufscthesis@resumoabstract{1}}{}%
  \ifdef{\ufscthesis@resumoabstract}%
    {\begin{ufscthesisresumo}{#1}{english}}%
    {\begin{ufscthesisresumo}{#1}{brazil}}%
}{\end{ufscthesisresumo}}
\renewenvironment{abstract}[0]%
  {\begin{ufscthesisresumo}{Abstract}{english}}
  {\end{ufscthesisresumo}}

% \begin{listadesimbolos}[symbolwdith]
%   $\neg$ & Logical negation \\
%   .....
% \end{listadesimbolos}
% 
% Ambiente tabular para construção de Lista de Símbolos
% A coluna da esquerda deve conter os símbolos e terá largura symbolwidth, que
% por default é 5em (equivalente a mmmmm)
\providecommand{\listadesimboloslabel}{list-of-symbols}
\newenvironment{listadesimbolos}[1][4em]%
  {%
    \chapter*{\listadesimbolosname}%
    \label{\listadesimboloslabel}%
    \noindent
    \begin{tabular}{p{#1}p{\dimexpr 12cm-\tabcolsep-#1\relax}}%
  }%
  {\end{tabular}}

\ifufscthesis@nocleardoublepage\else
  \AtBeginDocument{
    \preto{\listoftables}{\cleardoublepage}
    \preto{\listoffigures}{\cleardoublepage}
    \preto{\listadesimbolos}{\cleardoublepage}
    \preto{\tableofcontents}{\cleardoublepage}
    \ifdef{\listoflistings}{\preto{\listoflistings}{\cleardoublepage}}{}
  }
\fi

\endinput
