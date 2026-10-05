<?xml version="1.0" encoding="UTF-8"?>

<!-- Generic formatting of lists. Expand lists of the form

     <list>
       <item>a</item>
       <item>b</item>
       <item>c</item>
     </list>

     into a format such as "a, b, and c".

     The list tag has parameters:

     nil:        string to use when the list is empty.
     open:       string to use before the first item.
     close:      string to use after the last item.
     comma:      string to use between items
     open1:      if specified, string to use before the first item if
                 there is only one item.
     close1:     if specified, string to use after the first item if
                 there is only one item.
     open2:      if specified, string to use before the first item if
                 there are exactly two items.
     close2:     if specified, string to use after the first item if
                 there are exactly two items.
     firstcomma: if specified, string to use between first two items.
     lastcomma:  if specified, string to use between last two items.
     comma2:     if specified, string to use between items if there
                 are exactly two.

     For example,
     <list nil=""
           open=""
           close=". "
           comma=", "
           lastcomma=", and "
           comma2=" and ">
     results in the following formats:

      [] => (nothing)
      [a] => a.
      [a,b] => a and b.
      [a,b,c] => a, b, and c.
      [a,b,c,d] => a, b, c, and d.

     <list nil=""
           open1="Supervisor: "
           open="Supervisors: "
           close=". "
           comma=", ">
     results in the following formats:

      [] => (nothing)
      [a] => Supervisor: a.
      [a,b] => Supervisors: a, b.
      [a,b,c] => Supervisors: a, b, c.

     <list nil=""
           open="&lt;b&gt;"
           firstcomma=",&lt;/b&gt; "
           comma=", "
           close1=".&lt;/b&gt; "
           close=". ">
     results in a list with the first item (including punctuation) bold:

      [] => (nothing)
      [a] => <b>a.</b>
      [a,b] => <b>a,</b> b.
      [a,b,c] => <b>a,</b> b, c.

     See the file sample-lists.xml for worked examples. 

     Here is the general scheme for formatting:

      [] => nil
      [a] => open1 a close1
      [a,b] => open2 a comma2 b close2
      [a,b,c] => open a firstcomma b lastcomma c close
      [a,b,c,d] => open a firstcomma b comma c lastcomma d close

     nil, open, and close default to ""
     comma defaults to ", "
     open1 defaults to open
     close1 defaults to close
     open2 defaults to open
     close2 defaults to close
     firstcomma defaults to comma
     lastcomma defaults to comma
     comma2 defaults to firstcomma, if given, else lastcomma
    

-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="item">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="list">
    <!-- parse the parameters using appropriate defaults -->
    <xsl:variable name="nil">
      <xsl:choose>
        <xsl:when test="@nil">
          <xsl:value-of select="@nil"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="open">
      <xsl:choose>
        <xsl:when test="@open">
          <xsl:value-of select="@open"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="close">
      <xsl:choose>
        <xsl:when test="@close">
          <xsl:value-of select="@close"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="comma">
      <xsl:choose>
        <xsl:when test="@comma">
          <xsl:value-of select="@comma"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="open1">
      <xsl:choose>
        <xsl:when test="@open1">
          <xsl:value-of select="@open1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$open"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="close1">
      <xsl:choose>
        <xsl:when test="@close1">
          <xsl:value-of select="@close1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$close"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="open2">
      <xsl:choose>
        <xsl:when test="@open2">
          <xsl:value-of select="@open2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$open"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="close2">
      <xsl:choose>
        <xsl:when test="@close2">
          <xsl:value-of select="@close2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$close"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="firstcomma">
      <xsl:choose>
        <xsl:when test="@firstcomma">
          <xsl:value-of select="@firstcomma"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$comma"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="lastcomma">
      <xsl:choose>
        <xsl:when test="@lastcomma">
          <xsl:value-of select="@lastcomma"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$comma"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="comma2">
      <xsl:choose>
        <xsl:when test="@comma2">
          <xsl:value-of select="@comma2"/>
        </xsl:when>
        <xsl:when test="@firstcomma">
          <xsl:value-of select="@firstcomma"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$lastcomma"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- the length of the list -->
    <xsl:variable name="length">
      <xsl:value-of select="count(item)"/>
    </xsl:variable>

    <!-- list processing -->
    <xsl:choose>
      <xsl:when test="$length = 0">
        <xsl:value-of disable-output-escaping="yes" select="$nil"/>
      </xsl:when>
      <xsl:when test="$length = 1">
        <xsl:value-of disable-output-escaping="yes" select="$open1"/>
        <xsl:apply-templates select="item"/>
        <xsl:value-of disable-output-escaping="yes" select="$close1"/>
      </xsl:when>
      <xsl:when test="$length = 2">
        <xsl:value-of disable-output-escaping="yes" select="$open2"/>
        <xsl:apply-templates select="item[1]"/>
        <xsl:value-of disable-output-escaping="yes" select="$comma2"/>
        <xsl:apply-templates select="item[2]"/>
        <xsl:value-of disable-output-escaping="yes" select="$close2"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of disable-output-escaping="yes" select="$open"/>
        <xsl:apply-templates select="item[1]"/>
        <xsl:value-of disable-output-escaping="yes" select="$firstcomma"/>
        <xsl:for-each select="item[position()>1 and last()-1>position()]">
          <xsl:apply-templates select="."/>
          <xsl:value-of disable-output-escaping="yes" select="$comma"/>
        </xsl:for-each>
        <xsl:apply-templates select="item[last()-1]"/>
        <xsl:value-of disable-output-escaping="yes" select="$lastcomma"/>
        <xsl:apply-templates select="item[last()]"/>
        <xsl:value-of disable-output-escaping="yes" select="$close"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
