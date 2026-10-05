<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright (C) 2026 Caroline Simpson.
     Added 2026-10-05: optional removal of personal information and blank
     fields, and Organization fallback. GPL-2.0-or-later; see COPYING. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8"/>
  <xsl:param name="clean" select="'no'"/>
  <xsl:template match="@*|node()">
    <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
  </xsl:template>
  <!-- Remove this after document formatting so the title retains the name. -->
  <xsl:template match="section[@title='Personal Information']">
    <xsl:if test="$clean != 'yes'"><xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy></xsl:if>
  </xsl:template>
  <xsl:template match="field">
    <xsl:variable name="filled" select="normalize-space(.) != '' or .//@value[normalize-space(.) != '']"/>
    <xsl:variable name="other" select="../field[@label='Other Organization'][normalize-space(.) != ''][1]"/>
    <xsl:choose>
      <xsl:when test="$clean != 'yes'"><xsl:copy-of select="."/></xsl:when>
      <xsl:when test="@label='Organization' and not($filled) and $other">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <value type="String"><xsl:value-of select="$other/value"/></value>
          <!-- Structured formatters read the organization from this attribute. -->
          <refTable><linkedWith label="Organization" value="{$other/value}"/></refTable>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="@label='Other Organization' and ../field[@label='Organization'][normalize-space(.) = '' and not(.//@value[normalize-space(.) != ''])]"/>
      <xsl:when test="$filled"><xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy></xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- Do not expose empty language variants as fallback annotations. -->
  <xsl:template match="bilingual/*[normalize-space(.)='']">
    <xsl:if test="$clean != 'yes'"><xsl:copy-of select="."/></xsl:if>
  </xsl:template>
</xsl:stylesheet>
