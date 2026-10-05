<?xml version="1.0" encoding="UTF-8"?>

<!-- Logical to visual formatting --> 

<!-- Modified by Caroline Simpson, 2026-10-05: render work descriptions.
     Copyright (C) 2026 Caroline Simpson (modifications).
     GPL-2.0-or-later; see COPYING. -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="text"/>

  <!-- Document root --> 
  <xsl:template match="/document">
    <xsl:text>
      \documentclass[11pt]{article}
      \usepackage{times}
      \usepackage{color}

      \usepackage{inputenc}
      \inputencoding{utf8}
      \DeclareUnicodeCharacter{00A0}{~}

      \textwidth=6.5in
      \textheight=9in
      \headheight=-.45in
      \headsep=0in
      \oddsidemargin=0in

      \parskip 0ex
      \parindent 0in

      \newcommand{\header}[1]{\par{\sc #1}\par}
      \newcommand{\subheader}[1]{\par{\bf #1}\par}
      \newenvironment{body}{\begin{list}{}{\parsep 1.4ex}\item}{\end{list}}
      \newenvironment{subbody}{\begin{list}{}{\parsep 1.4ex\leftmargin 2ex}\item}{\end{list}}
      \newenvironment{annotate}{\par\begin{list}{}{\parsep 1.4ex\leftmargin 2ex}\item}{\end{list}}
      \newcommand{\doctitle}[1]{\begin{center}\Large{\sc #1}\end{center}}
      \newcommand{\url}[1]{#1}
      \newcommand{\text}{% Disable most special TeX characters
         \catcode`\&lt;=12\catcode`\&gt;=12\catcode`\&amp;=12\catcode`\^=12%
         \catcode`\_=12\catcode`\#=12\catcode`\$=12\catcode`\~=12%
         \catcode`\%=12}

      \begin{document}
    </xsl:text>
    <xsl:if test="@title">
      \doctitle{<xsl:value-of select="@title"/>}
    </xsl:if>
    <xsl:if test="node() != ''">
      <xsl:apply-templates select="node()"/>
    </xsl:if>
    <xsl:text>
      \end{document}
    </xsl:text>
  </xsl:template>

  <!-- Section --> 
  <xsl:template match="section">
    <xsl:if test="@title">
      \header{<xsl:value-of select="@title"/>}
    </xsl:if>

    <xsl:if test="node() != ''">
      \begin{body}
      <xsl:apply-templates select="node()"/>
      \end{body}
    </xsl:if>
  </xsl:template>

  <!-- Subsection --> 
  <xsl:template match="subsection">
    <xsl:if test="@title">
      \subheader{<xsl:value-of select="@title"/>}
    </xsl:if>

    <xsl:if test="node() != ''">
      \begin{subbody}
      <xsl:apply-templates select="node()"/>
      \end{subbody}
    </xsl:if>
  </xsl:template>

  <!-- Key-value table -->
  <xsl:template match="key-value-table">
    <xsl:text>
      \begin{tabular}{@{}lp{4in}}
    </xsl:text>
    <xsl:for-each select="row">
      {\bf \text <xsl:apply-templates select="key/node()"/>} &amp;
      {\text <xsl:apply-templates select="value/node()"/>}
      \\[1ex]
    </xsl:for-each>
    <xsl:text>
      \end{tabular}
    </xsl:text>
  </xsl:template>

  <!-- Entry -->
  <xsl:template match="entry">
    {\text <xsl:apply-templates/>}
    <xsl:text>

    </xsl:text>
  </xsl:template>

  <!-- Annotation -->
  <xsl:template match="annotate">
    \begin{annotate}
    <xsl:apply-templates/>
    \end{annotate}
  </xsl:template>

  <!-- Line break -->
  <xsl:template match="linebreak">
    <xsl:text>\newline </xsl:text>
  </xsl:template>

  <!-- Bold -->
  <xsl:template match="bold">
    <xsl:text>{\bf </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Italic -->
  <xsl:template match="italic">
    <xsl:text>{\it </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- No linebreaks -->
  <xsl:template match="nobr">
    <xsl:text>\mbox{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- URL -->
  <xsl:template match="url">
    <xsl:text>\url{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Warning -->
  <xsl:template match="warning">
    <xsl:text>{\color{red} </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

<xsl:template match="work-description">
    <xsl:text>
\par
</xsl:text><xsl:apply-templates/><xsl:text>
\par
</xsl:text>
  </xsl:template>
<!-- Modified 2026-10-05: description lists and prose lines. -->
  <xsl:template match="bullet-list"><xsl:text>
\begin{itemize}
</xsl:text><xsl:apply-templates/><xsl:text>
\end{itemize}
</xsl:text></xsl:template>
  <xsl:template match="bullet-item"><xsl:text>
\item </xsl:text><xsl:apply-templates/></xsl:template>
  <xsl:template match="description-line"><xsl:apply-templates/><xsl:text>
\par
</xsl:text></xsl:template>
</xsl:stylesheet>
