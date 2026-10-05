<?xml version="1.0" encoding="UTF-8"?>

<!-- Modified by Caroline Simpson, 2026-10-05: HTML head and embedded CSS.
     Copyright (C) 2026 Caroline Simpson (modifications).
     SPDX-License-Identifier: GPL-2.0-or-later; see COPYING. -->
<!-- Logical to visual formatting --> 

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:param name="css" select="''"/>

  <!-- Document root --> 
  <xsl:template match="/document">
    <html lang="en">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="@title"/></title>
        <style type="text/css"><xsl:value-of select="$css"/></style>
      </head>
      <body>
        <xsl:if test="@title">
          <h2>
            <xsl:value-of select="@title"/>
          </h2>
        </xsl:if>
        <xsl:if test="node() != ''">
          <xsl:apply-templates select="node()"/>
        </xsl:if>
      </body>
    </html>
  </xsl:template>

  <!-- Section --> 
  <xsl:template match="section">
    <xsl:if test="@title">
      <h3>
        <xsl:value-of select="@title"/>
      </h3>
    </xsl:if>
    <xsl:if test="node() != ''">
      <table border="0" cellspacing="0">
        <tr>
          <td width="15">
          </td>
          <td>
            <xsl:apply-templates select="node()"/>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>

  <!-- Subsection --> 
  <xsl:template match="subsection">
    <xsl:if test="@title">
      <h4>
        <xsl:value-of select="@title"/>
      </h4>
    </xsl:if>
    <xsl:if test="node() != ''">
      <table border="0" cellspacing="0">
        <tr>
          <td width="15">
          </td>
          <td>
            <xsl:apply-templates select="node()"/>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>

  <!-- Key-value table -->
  <xsl:template match="key-value-table">
    <table border="0" cellspacing="0">
      <xsl:for-each select="row">
        <tr>
          <th align="left" valign="top">
            <xsl:apply-templates select="key/node()"/>
          </th>
          <td width="10">
          </td>
          <td valign="top">
            <xsl:apply-templates select="value/node()"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Entry -->
  <xsl:template match="entry">
    <xsl:apply-templates/>
    <p/>
  </xsl:template>

  <!-- Annotation -->
  <xsl:template match="annotate">
    <p/>
    <table border="0" cellspacing="0">
      <tr>
        <td width="15">
        </td>
        <td>
          <xsl:apply-templates/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- Line break -->
  <xsl:template match="linebreak">
    <br/>
  </xsl:template>

  <!-- Bold -->
  <xsl:template match="bold">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>

  <!-- Italic -->
  <xsl:template match="italic">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>

  <!-- No linebreaks -->
  <xsl:template match="nobr">
    <nobr>
      <xsl:apply-templates/>
    </nobr>
  </xsl:template>

  <!-- URL -->
  <xsl:template match="url">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- Warning -->
  <xsl:template match="warning">
    <font color="red">
      <xsl:apply-templates/>
    </font>
  </xsl:template>

</xsl:stylesheet>
