<?xml version="1.0" encoding="UTF-8"?>

<!-- 
The Canada Common CV xml format represents list of records
without an enclosing tag. For example:

 <section label="Recognitions" id="x" recordId="a"/>
 <section label="Recognitions" id="x" recordId="b"/>
 <section label="Recognitions" id="x" recordId="c"/>

This XSLT style sheet wraps such listings into an easier-to-parse
format, namely, a single section divided into multiple records:

 <section label="Recognitions" id="x">
   <record label="Recognitions" id="a"/>
   <record label="Recognitions" id="b"/>
   <record label="Recognitions" id="c"/>
 </section>

This implementation is based on ideas from
http://stackoverflow.com/questions/3962161/how-can-i-wrap-a-group-of-adjacent-elements-using-xslt
-->
  
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()[1]"/>
    </xsl:copy>
    <xsl:apply-templates select="following-sibling::node()[1]"/>
  </xsl:template>

  <!-- Wrap <section id="..." recordId="..."/> elements -->
  <xsl:template match="section[@id and @recordId]">
    <xsl:variable name="id">
      <xsl:value-of select="@id"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@id|@label"/>
      <xsl:call-template name="Record">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
    </xsl:copy>
    <xsl:apply-templates select="following-sibling::node()
                                 [not(self::section[@id=$id])][1]"/>
  </xsl:template>

  <xsl:template name="Record">
    <xsl:param name="id"/>
    <record>
      <xsl:attribute name="id">
        <xsl:value-of select="@recordId"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*[name()!='recordId' and
                                   name()!='id' and name()!='label']"/>
      <xsl:apply-templates select="node()[1]"/>
    </record>
    <xsl:for-each select="following-sibling::node()[1]
                                 /self::section[@id=$id and @recordId]">
      <xsl:call-template name="Record">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
