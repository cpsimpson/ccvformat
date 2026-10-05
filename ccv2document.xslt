<?xml version="1.0" encoding="UTF-8"?>

<!-- Modified by Caroline Simpson, 2026-10-05: CV layout for non-academic work.
     Copyright (C) 2026 Caroline Simpson (modifications).
     GPL-2.0-or-later; see COPYING. -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent="yes" method="xml" encoding="utf8"/>

  <xsl:variable name="firstname">
    <xsl:value-of select="//section[@label='Identification']/record/field[@label='First Name']/value"/>
  </xsl:variable>
  <xsl:variable name="lastname">
    <xsl:value-of select="//section[@label='Identification']/record/field[@label='Family Name']/value"/>
  </xsl:variable>
  <xsl:variable name="myname">
    <xsl:if test="$lastname != '' or $firstname != ''">
      <xsl:value-of select="$firstname"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$lastname"/>
    </xsl:if>
  </xsl:variable>

  <!-- ============================================================ -->
  <!-- The root template for the document -->
  <xsl:template match="/">
    <xsl:variable name="firstname">
      <xsl:value-of select="//section[@label='Identification']/record/field[@label='First Name']/value"/>
    </xsl:variable>
    <xsl:variable name="lastname">
      <xsl:value-of select="//section[@label='Identification']/record/field[@label='Family Name']/value"/>
    </xsl:variable>

    <document>
      <xsl:attribute name="title">
        <xsl:text>Curriculum Vitae</xsl:text>
        <xsl:if test="$myname != ''">
          <xsl:text> &#x2013; </xsl:text>
          <xsl:value-of select="$myname"/>
        </xsl:if>
      </xsl:attribute>

      <xsl:apply-templates/>

    </document>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Generic catch-all formatting. This shows in red any information
       for which there are no specific formatting rules. -->
  <xsl:template match="section">
    <warning>
      <section>
        <xsl:attribute name="title">
          <xsl:value-of select="@label"/>
        </xsl:attribute>

        <xsl:apply-templates/>

      </section>
    </warning>
  </xsl:template>

  <xsl:template match="section/section">
    <warning>
      <subsection>
        <xsl:attribute name="title">
          <xsl:value-of select="@label"/>
        </xsl:attribute>

        <xsl:apply-templates/>

      </subsection>
    </warning>
  </xsl:template>

  <xsl:template match="record">
    <entry>
      <xsl:apply-templates/>
    </entry>
  </xsl:template>

  <xsl:template match="field">
    <warning>
      <bold><xsl:value-of select="@label"/></bold>
      <xsl:text>: </xsl:text>
      <xsl:variable name="content">
        <xsl:apply-templates/>
      </xsl:variable>
      <xsl:value-of select="normalize-space($content)"/>
    </warning>
    <linebreak/>
  </xsl:template>

  <xsl:template match="field[value and bilingual]">
    <warning>
      <bold><xsl:value-of select="@label"/></bold>
      <xsl:text>: </xsl:text>
      <xsl:variable name="value">
        <xsl:value-of select="value"/>
      </xsl:variable>

      <!-- Ignore any "bilingual" fields whose content just duplicates the
           "value" field. -->
      <xsl:value-of select="value"/>
      <xsl:for-each select="bilingual/*">
        <xsl:variable name="language">
          <xsl:value-of select="local-name(.)"/>
        </xsl:variable>
        <xsl:variable name="lang_value">
          <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:if test="$value != $lang_value">
          <annotate>
            <warning>
              <bold>
                <xsl:value-of select="$language"/>
                <xsl:text>: </xsl:text>
              </bold>
              <xsl:value-of select="$lang_value"/>
            </warning>
          </annotate>
        </xsl:if>
      </xsl:for-each>
    </warning>
    <linebreak/>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Personal Information -->

  <xsl:template match="section[@label='Personal Information']">
    <section>
      <xsl:attribute name="title">
        <xsl:value-of select="@label"/>
      </xsl:attribute>

      <key-value-table>
        <xsl:apply-templates/>
      </key-value-table>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Personal Information']/section[@label='Identification']">
    <xsl:for-each select="record">
      <row>
        <key>Name:</key>
        <value>
          <xsl:value-of select="field[@label='Title']/lov"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="field[@label='First Name']/value"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="field[@label='Middle Name']/value"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="field[@label='Family Name']/value"/>
        </value>
      </row>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="section[@label='Personal Information']/section[@label='Language Skills']">
    <!-- ignore -->
  </xsl:template>

  <xsl:template match="section[@label='Personal Information']/section[@label='Address']">
    <xsl:for-each select="record[@primaryIndicator='true']">
      <row>
        <key>Address:</key>
        <value>
          <xsl:variable name="line1">
            <xsl:value-of select="field[@label='Address - Line 1']/value"/>
          </xsl:variable>
          <xsl:variable name="line2">
            <xsl:value-of select="field[@label='Line 2']/value"/>
          </xsl:variable>
          <xsl:variable name="line3">
            <xsl:value-of select="field[@label='Line 3']/value"/>
          </xsl:variable>
          <xsl:variable name="line4">
            <xsl:value-of select="field[@label='Line 4']/value"/>
          </xsl:variable>
          <xsl:variable name="line5">
            <xsl:value-of select="field[@label='Line 5']/value"/>
          </xsl:variable>
          <xsl:variable name="city">
            <xsl:value-of select="field[@label='City']/value"/>
          </xsl:variable>
          <xsl:variable name="province">
            <xsl:value-of select="field[@label='Location']/refTable/linkedWith[@label='Subdivision']/@value"/>
          </xsl:variable>
          <xsl:variable name="country">
            <xsl:value-of select="field[@label='Location']/refTable/linkedWith[@label='Country']/@value"/>
          </xsl:variable>
          <xsl:variable name="pcode">
            <xsl:value-of select="field[@label='Postal / Zip Code']/value"/>
          </xsl:variable>

          <list comma="&lt;linebreak/&gt;">
            <xsl:if test="$line1 != ''">
              <item>
                <xsl:value-of select="$line1"/>
              </item>
            </xsl:if>
            <xsl:if test="$line2 != ''">
              <item>
                <xsl:value-of select="$line2"/>
              </item>
            </xsl:if>
            <xsl:if test="$line3 != ''">
              <item>
                <xsl:value-of select="$line3"/>
              </item>
            </xsl:if>
            <xsl:if test="$line4 != ''">
              <item>
                <xsl:value-of select="$line4"/>
              </item>
            </xsl:if>
            <xsl:if test="$line5 != ''">
              <item>
                <xsl:value-of select="$line5"/>
              </item>
            </xsl:if>
            <item>
              <list>
                <xsl:if test="$city != ''">
                  <item>
                    <xsl:value-of select="$city"/>
                  </item>
                </xsl:if>
                <xsl:if test="$province != '' and $province != 'Not Required'">
                  <item>
                    <xsl:value-of select="$province"/>
                  </item>
                </xsl:if>
              </list>
              <xsl:if test="$pcode != ''">
                <xsl:text>&#x00a0;&#x00a0;</xsl:text>
                <xsl:value-of select="$pcode"/>
              </xsl:if>
            </item>
            <xsl:if test="$country != ''">
              <item>
                <xsl:value-of select="$country"/>
              </item>
            </xsl:if>
          </list>
        </value>
      </row>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="section[@label='Personal Information']/section[@label='Telephone']">
    <xsl:for-each select="record[@primaryIndicator='true']">
      <row>
        <key>Phone:</key>
        <value>
          <xsl:variable name="ccode">
            <xsl:value-of select="field[@label='Country Code']/value"/>
          </xsl:variable>
          <xsl:variable name="acode">
            <xsl:value-of select="field[@label='Area Code']/value"/>
          </xsl:variable>
          <xsl:variable name="number">
            <xsl:value-of select="field[@label='Telephone Number']/value"/>
          </xsl:variable>
          <xsl:variable name="ext">
            <xsl:value-of select="field[@label='Extension']/value"/>
          </xsl:variable>
          <xsl:if test="$ccode != ''">
            <xsl:text>+</xsl:text>
            <xsl:value-of select="$ccode"/>
            <xsl:text>-</xsl:text>
          </xsl:if>
          <xsl:if test="$acode != ''">
            <xsl:value-of select="$acode"/>
            <xsl:text>-</xsl:text>
          </xsl:if>
          <xsl:if test="$number != ''">
            <xsl:choose>
              <xsl:when test="$ccode='1'">
                <xsl:value-of select="substring($number,1,3)"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring($number,4)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$number"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <xsl:if test="$ext != ''">
            <xsl:text> ext. </xsl:text>
            <xsl:value-of select="$ext"/>
          </xsl:if>
        </value>
      </row>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="section[@label='Personal Information']/section[@label='Email']">
    <xsl:for-each select="record[@primaryIndicator='true']">
      <row>
        <key>Email:</key>
        <value>
          <xsl:variable name="email">
            <xsl:value-of select="field[@label='Email Address']/value"/>
          </xsl:variable>
          <xsl:value-of select="$email"/>
        </value>
      </row>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="section[@label='Personal Information']/section[@label='Website']">
    <xsl:for-each select="record">
      <row>
        <key>Website:</key>
        <value>
          <xsl:variable name="url">
            <xsl:value-of select="field[@label='URL']/value"/>
          </xsl:variable>
          <xsl:value-of select="$url"/>
        </value>
      </row>
    </xsl:for-each>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Education -->

  <xsl:template match="section[@label='Education']">
    <section>
      <xsl:attribute name="title">
        <xsl:value-of select="@label"/>
      </xsl:attribute>

      <xsl:apply-templates/>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Education']/section[@label='Degrees']">
    <xsl:for-each select="record">
      <xsl:variable name="startdate">
        <xsl:value-of select="field[@label='Degree Start Date']/value"/>
      </xsl:variable>
      <xsl:variable name="enddate">
        <xsl:value-of select="field[@label='Degree Received Date']/value"/>
      </xsl:variable>
      <xsl:variable name="expdate">
        <xsl:value-of select="field[@label='Degree Expected Date']/value"/>
      </xsl:variable>
      <xsl:variable name="degtype">
        <xsl:value-of select="field[@label='Degree Type']/lov"/>
      </xsl:variable>
      <xsl:variable name="degname">
        <xsl:value-of select="field[@label='Degree Name']/value"/>
      </xsl:variable>
      <xsl:variable name="realdegname">
        <xsl:choose>
          <xsl:when test="$degname != ''">
            <xsl:value-of select="$degname"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$degtype"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="specialty">
        <xsl:value-of select="field[@label='Specialization']/value"/>
      </xsl:variable>
      <xsl:variable name="title">
        <xsl:value-of select="field[@label='Thesis Title']/value"/>
      </xsl:variable>

      <entry>
        <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
              close1=".&lt;/bold&gt; " close=". ">
          <xsl:apply-templates select="." mode="organization"/>
          <xsl:if test="concat($startdate,$enddate,$expdate) != ''">
            <item>
              <xsl:if test="$startdate != ''">
                <xsl:value-of select="substring-before(concat($startdate, '/'), '/')"/>
                <xsl:text>&#x2013;</xsl:text>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$enddate != ''">
                  <xsl:value-of select="substring-before(concat($enddate, '/'), '/')"/>
                </xsl:when>
                <xsl:when test="$expdate != ''">
                  <xsl:value-of select="substring-before(concat($expdate, '/'), '/')"/>
                  <xsl:text> (expected)</xsl:text>
                </xsl:when>
              </xsl:choose>
            </item>
          </xsl:if>
        </list>

        <linebreak/>

        <list close=". ">
          <xsl:if test="$realdegname != ''">
            <item>
              <xsl:value-of select="$realdegname"/>
            </item>
          </xsl:if>
          <xsl:if test="$specialty != ''">
            <item>
              <xsl:value-of select="$specialty"/>
            </item>
          </xsl:if>
        </list>
        <list open1="Supervisor: " open="Supervisors: " close=". ">
          <xsl:for-each select="section[@label='Supervisors']/record">
            <item>
              <xsl:value-of select="field[@label='Supervisor Name']/value"/>
            </item>
          </xsl:for-each>
        </list>

        <xsl:if test="$title != ''">
          <xsl:text>Thesis Title: </xsl:text>
          <xsl:value-of select="$title"/>
          <xsl:text>. </xsl:text>
        </xsl:if>
      </entry>

    </xsl:for-each>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Recognitions -->

  <xsl:template match="section[@label='Recognitions']">
    <section>
      <xsl:attribute name="title">
        <xsl:value-of select="@label"/>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="name">
          <xsl:value-of select="field[@label='Recognition Name']/value"/>
        </xsl:variable>
        <xsl:variable name="amount">
          <xsl:value-of select="field[@label='Amount']/value"/>
        </xsl:variable>
        <xsl:variable name="currency">
          <xsl:value-of select="field[@label='Currency']/value"/>
        </xsl:variable>
        <xsl:variable name="currencyamount">
          <xsl:choose>
            <xsl:when test="$currency != '' and $amount != ''">
              <xsl:value-of select="$currency"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="format-number($amount, '###,###.##')"/>
            </xsl:when>
            <xsl:when test="$amount != ''">
              <xsl:value-of select="format-number($amount, '$###,###.##')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Description']/value"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="date">
          <xsl:value-of select="field[@label='Effective Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="year">
          <xsl:value-of select="substring-before(concat($date, '/'), '/')"/>
        </xsl:variable>
        <xsl:variable name="endyear">
          <xsl:value-of select="substring-before(concat($enddate, '/'), '/')"/>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$name"/>
            </item>
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="$year != '' or $endyear != ''">
              <item>
                <xsl:if test="$year != ''">
                  <xsl:value-of select="$year"/>
                </xsl:if>
                <xsl:if test="$year != '' and $endyear != '' and $year != $endyear">
                  <xsl:text>&#x2013;</xsl:text>
                </xsl:if>
                <xsl:if test="$endyear != '' and $year != $endyear">
                  <xsl:value-of select="$endyear"/>
                </xsl:if>
              </item>
            </xsl:if>
          </list>

          <list close=". ">
            <xsl:if test="$currencyamount != ''">
              <item>
                <xsl:value-of select="$currencyamount"/>
              </item>
            </xsl:if>
          </list>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for User Profile: ignore it -->

  <xsl:template match="section[@label='User Profile']"/>

  <!-- ============================================================ -->
  <!-- Formatting for Employment -->

  <xsl:template match="section[@label='Employment']">
    <section>
      <xsl:attribute name="title">
        <xsl:value-of select="@label"/>
      </xsl:attribute>

      <xsl:apply-templates/>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Employment']/section[@label='Academic Work Experience']">
    <xsl:for-each select="record">
      <xsl:variable name="ptype">
        <xsl:value-of select="field[@label='Position Type']/lov"/>
      </xsl:variable>
      <xsl:variable name="ptitle">
        <xsl:value-of select="field[@label='Position Title']/value"/>
      </xsl:variable>
      <xsl:variable name="status">
        <xsl:value-of select="field[@label='Position Status']/lov"/>
      </xsl:variable>
      <xsl:variable name="rank">
        <xsl:value-of select="field[@label='Academic Rank']/lov"/>
      </xsl:variable>
      <xsl:variable name="startdate">
        <xsl:value-of select="field[@label='Start Date']/value"/>
      </xsl:variable>
      <xsl:variable name="enddate">
        <xsl:value-of select="field[@label='End Date']/value"/>
      </xsl:variable>
      <xsl:variable name="startyear">
        <xsl:value-of select="substring-before(concat($startdate, '/'), '/')"/>
      </xsl:variable>
      <xsl:variable name="endyear">
        <xsl:value-of select="substring-before(concat($enddate, '/'), '/')"/>
      </xsl:variable>
      <xsl:variable name="description">
        <xsl:call-template name="add_period">
          <xsl:with-param name="string" select="field[@label='Work Description']/value"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="dept">
        <xsl:value-of select="field[@label='Department']/value"/>
      </xsl:variable>
      <xsl:variable name="tenurestatus">
        <xsl:value-of select="field[@label='Tenure Status']/lov"/>
      </xsl:variable>
      <xsl:variable name="tenurestartdate">
        <xsl:value-of select="field[@label='Tenure Start Date']/value"/>
      </xsl:variable>
      <xsl:variable name="tenureenddate">
        <xsl:value-of select="field[@label='Tenure End Date']/value"/>
      </xsl:variable>

      <entry>
        <list close=". ">
          <item>
            <bold>
              <xsl:value-of select="$ptitle"/>
            </bold>
            <list open=" (" close=")">
              <xsl:if test="$ptitle != $rank and $rank != ''">
                <item>
                  <xsl:value-of select="$rank"/>
                </item>
              </xsl:if>
              <xsl:if test="$tenurestatus != ''">
                <item>
                  <xsl:choose>
                    <xsl:when test="$tenurestatus = 'Tenure'">
                      <xsl:text>Tenured</xsl:text>
                      <xsl:if test="$tenurestartdate != '' or $tenureenddate != ''">
                        <xsl:text>Tenured </xsl:text>
                      </xsl:if>
                      <xsl:if test="$tenurestartdate != ''">
                        <xsl:value-of select="$tenurestartdate"/>
                      </xsl:if>
                      <xsl:if test="$tenureenddate != ''">
                        <xsl:text>&#x2013;</xsl:text>
                        <xsl:value-of select="$tenureenddate"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$tenurestatus"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </item>
              </xsl:if>
            </list>
          </item>
          <xsl:if test="$status != 'Full-time'">
            <item>
              <xsl:value-of select="$status"/>
            </item>
          </xsl:if>

          <xsl:if test="$dept != ''">
            <item>
              <xsl:text>Department of </xsl:text>
              <xsl:value-of select="$dept"/>
            </item>
          </xsl:if>
          <xsl:apply-templates select="." mode="organization"/>

          <xsl:if test="$startyear != '' or $endyear != ''">
            <item>
              <xsl:if test="$startyear != ''">
                <xsl:value-of select="$startyear"/>
              </xsl:if>
              <xsl:if test="$startyear != $endyear">
                <xsl:text>&#x2013;</xsl:text>
              </xsl:if>
              <xsl:if test="$endyear != '' and $startyear != $endyear">
                <xsl:value-of select="$endyear"/>
              </xsl:if>
            </item>
          </xsl:if>
        </list>

        <!-- Modified 2026-10-05: include previously omitted work description. -->
        <xsl:if test="normalize-space(field[@label='Work Description']/value) != ''">
          <work-description><xsl:value-of select="field[@label='Work Description']/value"/></work-description>
        </xsl:if>
      </entry>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="section[@label='Employment']/section[@label='Affiliations']">
    <subsection title="Affiliations:">

      <xsl:for-each select="record">
        <xsl:variable name="ptitle">
          <xsl:value-of select="field[@label='Position Title']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="startyear">
          <xsl:value-of select="substring-before(concat($startdate, '/'), '/')"/>
        </xsl:variable>
        <xsl:variable name="endyear">
          <xsl:value-of select="substring-before(concat($enddate, '/'), '/')"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Work Description']/value"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dept">
          <xsl:value-of select="field[@label='Department']/value"/>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$ptitle"/>
            </item>

            <xsl:if test="$dept != ''">
              <item>
                <xsl:text>Department of </xsl:text>
                <xsl:value-of select="$dept"/>
              </item>
            </xsl:if>
            <xsl:apply-templates select="." mode="organization"/>

            <xsl:if test="$startyear != '' or $endyear != ''">
              <item>
                <xsl:if test="$startyear != ''">
                  <xsl:value-of select="$startyear"/>
                </xsl:if>
                <xsl:if test="$startyear != $endyear">
                  <xsl:text>&#x2013;</xsl:text>
                </xsl:if>
                <xsl:if test="$endyear != '' and $startyear != $endyear">
                  <xsl:value-of select="$endyear"/>
                </xsl:if>
              </item>
            </xsl:if>
          </list>
          <!-- Modified 2026-10-05: affiliations use Activity Description. -->
          <xsl:if test="normalize-space(field[@label='Activity Description']/value) != ''">
            <work-description><xsl:value-of select="field[@label='Activity Description']/value"/></work-description>
          </xsl:if>
        </entry>
      </xsl:for-each>
    </subsection>
  </xsl:template>

  <xsl:template match="section[@label='Employment']/section[@label='Leaves of Absence and Impact on Research']">
    <subsection title="Leaves:">

      <xsl:for-each select="record">
        <xsl:variable name="leavetype">
          <xsl:value-of select="field[@label='Leave Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Absence and Impact Description']/value"/>
          </xsl:call-template>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$leavetype"/>
            </item>

            <xsl:apply-templates select="." mode="organization"/>

            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>
    </subsection>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Research Funding History -->

  <xsl:template match="section[@label='Research Funding History']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Research Funding</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="type">
          <xsl:value-of select="field[@label='Funding Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Funding Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='Funding End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="startyear">
          <xsl:value-of select="substring-before(concat($startdate, '/'), '/')"/>
        </xsl:variable>
        <xsl:variable name="endyear">
          <xsl:value-of select="substring-before(concat($enddate, '/'), '/')"/>
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:value-of select="field[@label='Funding Title']/value"/>
        </xsl:variable>
        <xsl:variable name="granttype">
          <xsl:value-of select="field[@label='Grant Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Project Description']/value"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="status">
          <xsl:value-of select="field[@label='Funding Status']/lov"/>
        </xsl:variable>
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Funding Role']/lov"/>
        </xsl:variable>
        <xsl:variable name="uptake">
          <xsl:value-of select="field[@label='Research Uptake']/lov"/>
        </xsl:variable>

        <!-- todo: Funding by Year -->

        <entry>
          <list close=". ">
            <item>
              <bold>
                <xsl:choose>
                  <xsl:when test="$title != ''">
                    <xsl:value-of select="$title"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$type"/>
                  </xsl:otherwise>
                </xsl:choose>
              </bold>

              <list open=" (" close=")">
                <xsl:if test="$granttype != ''">
                  <item>
                    <xsl:value-of select="$granttype"/>
                  </item>
                </xsl:if>
                <xsl:if test="$status != '' and $status != 'Awarded'">
                  <item>
                    <xsl:value-of select="$status"/>
                  </item>
                </xsl:if>
              </list>
            </item>

            <xsl:if test="$startyear != '' or $endyear != ''">
              <item>
                <xsl:if test="$startyear != ''">
                  <xsl:value-of select="$startyear"/>
                </xsl:if>
                <xsl:if test="$startyear != $endyear">
                  <xsl:text>&#x2013;</xsl:text>
                </xsl:if>
                <xsl:if test="$endyear != '' and $startyear != $endyear">
                  <xsl:value-of select="$endyear"/>
                </xsl:if>
              </item>
            </xsl:if>
          </list>

          <xsl:choose>
            <xsl:when test="$role != ''">
              <list close=". ">
                <item>
                  <xsl:value-of select="$role"/>
                  <list open=", with ">
                    <xsl:apply-templates select="section[@label='Other Investigators']"/>
                  </list>
                </item>
              </list>
            </xsl:when>
            <xsl:otherwise>
              <list open="With " close=". ">
                <xsl:apply-templates select="section[@label='Other Investigators']"/>
              </list>
            </xsl:otherwise>
          </xsl:choose>

          <list comma="; " close=". ">
            <xsl:apply-templates select="section[@label='Funding Sources']">
              <xsl:with-param name="startyear1" select="$startyear"/>
              <xsl:with-param name="endyear1" select="$endyear"/>
            </xsl:apply-templates>
          </list>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Research Funding History']/record/section[@label='Other Investigators']">
    <xsl:for-each select="record">
      <xsl:sort select="field[@label='Investigator Name']/value"/>
      <xsl:variable name="name">
        <xsl:value-of select="field[@label='Investigator Name']/value"/>
      </xsl:variable>
      <xsl:variable name="fullname">
        <xsl:choose>
          <xsl:when test="contains($name, ',')">
            <xsl:value-of select="normalize-space(substring-after($name, ','))"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(substring-before($name, ','))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$name"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="role">
        <xsl:value-of select="field[@label='Role']/lov"/>
      </xsl:variable>

      <item>
        <xsl:value-of select="$fullname"/>
        <xsl:if test="$role != '' and $role != 'Co-applicant'">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="$role"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </item>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="section[@label='Research Funding History']/record/section[@label='Funding Sources']">
    <xsl:param name="startyear1"/>
    <xsl:param name="endyear1"/>
    <xsl:for-each select="record">
      <xsl:variable name="lovorg">
        <xsl:value-of select="field[@label='Funding Organization']/lov"/>
      </xsl:variable>
      <xsl:variable name="otherorg">
        <xsl:value-of select="field[@label='Other Funding Organization']/value"/>
      </xsl:variable>
      <xsl:variable name="org">
        <xsl:choose>
          <xsl:when test="$otherorg != ''">
            <xsl:value-of select="$otherorg"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lovorg"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="progname">
        <xsl:value-of select="field[@label='Program Name']/value"/>
      </xsl:variable>
      <xsl:variable name="amount">
        <xsl:value-of select="field[@label='Total Funding']/value"/>
      </xsl:variable>
      <xsl:variable name="currency">
        <xsl:value-of select="field[@label='Currency of Total Funding']/value"/>
      </xsl:variable>
      <xsl:variable name="currencyamount">
        <xsl:choose>
          <xsl:when test="$currency != '' and $amount != ''">
            <xsl:value-of select="$currency"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="format-number($amount, '###,###.##')"/>
          </xsl:when>
          <xsl:when test="$amount != ''">
            <xsl:value-of select="format-number($amount, '$###,###.##')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="portionamount">
        <xsl:value-of select="field[@label='Portion of Funding Received']/value"/>
      </xsl:variable>
      <xsl:variable name="portioncurrency">
        <xsl:value-of select="field[@label='Currency of Portion of Funding Received']/value"/>
      </xsl:variable>
      <xsl:variable name="portioncurrencyamount">
        <xsl:choose>
          <xsl:when test="$portioncurrency != '' and $portionamount != ''">
            <xsl:value-of select="$portioncurrency"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="format-number($portionamount, '###,###.##')"/>
          </xsl:when>
          <xsl:when test="$portionamount != ''">
            <xsl:value-of select="format-number($portionamount, '$###,###.##')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="startdate">
        <xsl:value-of select="field[@label='Funding Start Date']/value"/>
      </xsl:variable>
      <xsl:variable name="enddate">
        <xsl:value-of select="field[@label='Funding End Date']/value"/>
      </xsl:variable>
      <xsl:variable name="startyear">
        <xsl:value-of select="substring-before(concat($startdate, '/'), '/')"/>
      </xsl:variable>
      <xsl:variable name="endyear">
        <xsl:value-of select="substring-before(concat($enddate, '/'), '/')"/>
      </xsl:variable>
      <xsl:variable name="optstartyear">
        <xsl:if test="$startyear != $startyear1">
          <xsl:value-of select="$startyear"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="optendyear">
        <xsl:if test="$endyear != $endyear1">
          <xsl:value-of select="$endyear"/>
        </xsl:if>
      </xsl:variable>

      <item>
        <list>
          <item><xsl:value-of select="$org"/></item>
          <xsl:if test="$progname != ''">
            <item><xsl:value-of select="$progname"/></item>
          </xsl:if>
          <xsl:if test="$currencyamount != ''">
            <item>
              <xsl:value-of select="$currencyamount"/>
              <xsl:if test="$portioncurrencyamount != '' and $portioncurrencyamount != $currencyamount">
                <xsl:text> (my portion: </xsl:text>
                <xsl:value-of select="$portioncurrencyamount"/>
                <xsl:text>)</xsl:text>
              </xsl:if>
            </item>
          </xsl:if>
          <xsl:if test="$optstartyear != '' or $optendyear != ''">
            <item>
              <xsl:if test="$optstartyear != ''">
                <xsl:value-of select="$optstartyear"/>
              </xsl:if>
              <xsl:if test="$optstartyear != $optendyear">
                <xsl:text>&#x2013;</xsl:text>
              </xsl:if>
              <xsl:if test="$optendyear != '' and $optstartyear != $optendyear">
                <xsl:value-of select="$optendyear"/>
              </xsl:if>
            </item>
          </xsl:if>
        </list>
      </item>
    </xsl:for-each>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Activities -->

  <xsl:template match="section[@label='Activities']">
    <!-- Generate no section header; do this for each subsection -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Supervisory Activities -->

  <xsl:template match="section[@label='Activities']/section[@label='Supervisory Activities']">
    <section>
      <xsl:attribute name="title">
        <xsl:value-of select="@label"/>
      </xsl:attribute>

      <xsl:apply-templates/>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Supervisory Activities']/section[@label='Student/Postdoctoral Supervision']">
    <subsection>
      <xsl:attribute name="title">
        <xsl:text>In Progress:</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record[field[@label='Student Degree Status' and lov='In Progress']]">
        <xsl:sort select="field[@label='Supervision End Date']/value" order="descending"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>

    </subsection>

    <subsection>
      <xsl:attribute name="title">
        <xsl:text>Completed:</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record[field[@label='Student Degree Status' and lov!='In Progress']]">
        <xsl:sort select="field[@label='Supervision End Date']/value" order="descending"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>

    </subsection>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Supervisory Activities']/section[@label='Student/Postdoctoral Supervision']/record">
    <xsl:variable name="role">
      <xsl:value-of select="field[@label='Supervision Role']/lov"/>
    </xsl:variable>
    <xsl:variable name="startdate">
      <xsl:value-of select="field[@label='Supervision Start Date']/value"/>
    </xsl:variable>
    <xsl:variable name="enddate">
      <xsl:value-of select="field[@label='Supervision End Date']/value"/>
    </xsl:variable>
    <xsl:variable name="startyear">
      <xsl:value-of select="substring-before(concat($startdate, '/'), '/')"/>
    </xsl:variable>
    <xsl:variable name="endyear">
      <xsl:value-of select="substring-before(concat($enddate, '/'), '/')"/>
    </xsl:variable>
    <xsl:variable name="name">
      <xsl:value-of select="field[@label='Student Name']/value"/>
    </xsl:variable>
    <xsl:variable name="inst">
      <xsl:value-of select="field[@label='Student Institution']/value"/>
    </xsl:variable>
    <xsl:variable name="level">
      <xsl:value-of select="field[@label='Study / Postdoctoral Level']/lov"/>
    </xsl:variable>
    <xsl:variable name="status">
      <xsl:value-of select="field[@label='Student Degree Status']/lov"/>
    </xsl:variable>
    <xsl:variable name="degstartdate">
      <xsl:value-of select="field[@label='Student Degree Start Date']/value"/>
    </xsl:variable>
    <xsl:variable name="degenddate">
      <xsl:value-of select="field[@label='Student Degree Received Date']/value"/>
    </xsl:variable>
    <xsl:variable name="degexpdate">
      <xsl:value-of select="field[@label='Student Degree Expected Date']/value"/>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:value-of select="field[@label='Thesis/Project Title']/value"/>
    </xsl:variable>
    <xsl:variable name="description">
      <xsl:call-template name="add_period">
        <xsl:with-param name="string" select="field[@label='Project Description']/value"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="presentposition">
      <xsl:value-of select="field[@label='Present Position']/value"/>
    </xsl:variable>
    <xsl:variable name="titleordescription">
      <xsl:choose>
        <xsl:when test="$title != ''">
          <xsl:value-of select="$title"/>
        </xsl:when>
        <xsl:when test="$description != ''">
          <xsl:value-of select="$description"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <entry>
      <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
            close1=".&lt;/bold&gt; " close=". ">
        <item><xsl:value-of select="$name"/></item>
        <xsl:if test="$titleordescription != ''">
          <item>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$titleordescription"/>
            <xsl:text>"</xsl:text>
          </item>
        </xsl:if>
        <item>
          <xsl:value-of select="$level"/>
          <xsl:if test="($status != '' and $status != 'Completed' and $status != 'In Progress') or ($role != '' and $role != 'Principal Supervisor')">
            <xsl:text> (</xsl:text>
            <list>
              <xsl:if test="$status != '' and $status != 'Completed' and $status != 'In Progress'">
                <item>
                  <xsl:value-of select="$status"/>
                </item>
              </xsl:if>
              <xsl:if test="$role != '' and $role != 'Principal Supervisor'">
                <item>
                  <xsl:value-of select="$role"/>
                </item>
              </xsl:if>
            </list>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </item>
        <xsl:if test="$inst != ''">
          <item>
            <xsl:value-of select="$inst"/>
          </item>
        </xsl:if>
        <xsl:if test="$startyear != '' or $endyear != ''">
          <item>
            <xsl:if test="$startyear != ''">
              <xsl:value-of select="$startyear"/>
            </xsl:if>
            <xsl:if test="$startyear != $endyear">
              <xsl:text>&#x2013;</xsl:text>
            </xsl:if>
            <xsl:if test="$endyear != '' and $startyear != $endyear">
              <xsl:value-of select="$endyear"/>
            </xsl:if>
          </item>
        </xsl:if>
      </list>

      <xsl:if test="$presentposition != ''">
        <list open="Present Position: " close=". ">
          <item>
            <xsl:value-of select="$presentposition"/>
          </item>
        </list>
      </xsl:if>
    </entry>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Administrative Activities -->

  <xsl:template match="section[@label='Activities']/section[@label='Administrative Activities']">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Administrative Activities']/section[@label='Event Administration']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Conferences Organized</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Role']/value"/>
        </xsl:variable>
        <xsl:variable name="type">
          <xsl:value-of select="field[@label='Event Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="name">
          <xsl:value-of select="field[@label='Event Name']/value"/>
        </xsl:variable>
        <xsl:variable name="astartdate">
          <xsl:value-of select="field[@label='Activity Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="aenddate">
          <xsl:value-of select="field[@label='Activity End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="organizer">
          <xsl:value-of select="field[@label='Primary Event Organizer']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Event Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='Event End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Activity Description']/value"/>
          </xsl:call-template>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:if test="$name != ''">
              <item>
                <xsl:value-of select="$name"/>
              </item>
            </xsl:if>
            <xsl:if test="$organizer != ''">
              <item>
                <xsl:value-of select="$organizer"/>
                <xsl:text> (organizer)</xsl:text>
              </item>
            </xsl:if>
            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Administrative Activities']/section[@label='Editorial Activities']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Editorial Activities</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Role']/value"/>
        </xsl:variable>
        <xsl:variable name="pubtype">
          <xsl:value-of select="field[@label='Publication Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="pubname">
          <xsl:value-of select="field[@label='Publication Name']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="startyear">
          <xsl:value-of select="substring-before(concat($startdate, '/'), '/')"/>
        </xsl:variable>
        <xsl:variable name="endyear">
          <xsl:value-of select="substring-before(concat($enddate, '/'), '/')"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Activity Description']/value"/>
          </xsl:call-template>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:if test="$pubname != ''">
              <item>
                <xsl:value-of select="$pubname"/>
              </item>
            </xsl:if>
            <xsl:if test="$startyear != '' or $endyear != ''">
              <item>
                <xsl:if test="$startyear != ''">
                  <xsl:value-of select="$startyear"/>
                </xsl:if>
                <xsl:if test="$startyear != $endyear">
                  <xsl:text>&#x2013;</xsl:text>
                </xsl:if>
                <xsl:if test="$endyear != '' and $startyear != $endyear">
                  <xsl:value-of select="$endyear"/>
                </xsl:if>
              </item>
            </xsl:if>
          </list>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Advisory Activities -->

  <xsl:template match="section[@label='Activities']/section[@label='Advisory Activities']">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Advisory Activities']/section[@label='Mentoring Activities']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Mentoring</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Role']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Activity Description']/value"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="number">
          <xsl:value-of select="field[@label='Number of Mentorees']/lov"/>
        </xsl:variable>
        <xsl:variable name="mentorees">
          <xsl:value-of select="field[@label='Mentorees']/value"/>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="$mentorees != ''">
              <item>
                <xsl:text>Mentoree(s): </xsl:text>
                <xsl:value-of select="$mentorees"/>
              </item>
            </xsl:if>
            <xsl:if test="$number != ''">
              <item>
		<nobr>
                  <xsl:value-of select="$number"/>
                  <xsl:choose>
                    <xsl:when test="number($number) = 1">
                      <xsl:text> Mentoree</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text> Mentorees</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
		</nobr>
              </item>
            </xsl:if>
            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Assessment and Review Activities -->

  <xsl:template match="section[@label='Activities']/section[@label='Assessment and Review Activities']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Assessment and Reviewing</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates select="section[@label!='Graduate Examination Activities']"/>
    </section>
    <xsl:apply-templates select="section[@label='Graduate Examination Activities']"/>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Assessment and Review Activities']/section[@label='Journal Review Activities']">
    <subsection>
      <xsl:attribute name="title">
        <xsl:text>Journal Reviewing</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Role']/value"/>
        </xsl:variable>
        <xsl:variable name="type">
          <xsl:value-of select="field[@label='Review Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="journal">
          <xsl:value-of select="field[@label='Journal']/value"/>
        </xsl:variable>
        <xsl:variable name="press">
          <xsl:value-of select="field[@label='Press']/value"/>
        </xsl:variable>
        <xsl:variable name="number">
          <xsl:value-of select="field[@label='Number of Works Reviewed / Refereed']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:if test="$journal != ''">
              <item>
                <xsl:value-of select="$journal"/>
              </item>
            </xsl:if>
            <xsl:if test="$press != ''">
              <item>
                <xsl:value-of select="$press"/>
              </item>
            </xsl:if>
            <xsl:if test="$number != '' and number($number) != 1">
              <item>
		<nobr>
                  <xsl:value-of select="$number"/>
                  <xsl:text> Articles</xsl:text>
		</nobr>
              </item>
            </xsl:if>
            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
        </entry>
      </xsl:for-each>

    </subsection>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Assessment and Review Activities']/section[@label='Conference Review Activities']">
    <subsection>
      <xsl:attribute name="title">
        <xsl:text>Conference Reviewing</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Role']/value"/>
        </xsl:variable>
        <xsl:variable name="type">
          <xsl:value-of select="field[@label='Review Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="conference">
          <xsl:value-of select="field[@label='Conference']/value"/>
        </xsl:variable>
        <xsl:variable name="host">
          <xsl:value-of select="field[@label='Conference Host']/value"/>
        </xsl:variable>
        <xsl:variable name="number">
          <xsl:value-of select="field[@label='Number of Works Reviewed / Refereed']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:if test="$conference != ''">
              <item>
                <xsl:value-of select="$conference"/>
              </item>
            </xsl:if>
            <xsl:if test="$host != ''">
              <item>
                <xsl:value-of select="$host"/>
              </item>
            </xsl:if>
            <xsl:if test="$number != '' and number($number) != 1">
              <item>
		<nobr>
                  <xsl:value-of select="$number"/>
                  <xsl:text> Articles</xsl:text>
		</nobr>
              </item>
            </xsl:if>
            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
        </entry>
      </xsl:for-each>

    </subsection>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Assessment and Review Activities']/section[@label='Graduate Examination Activities']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Graduate Examination Activities</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Graduate Examination Activity Role']/lov"/>
        </xsl:variable>
        <xsl:variable name="department">
          <xsl:value-of select="field[@label='Department']/lov"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="name">
          <xsl:value-of select="field[@label='Student Name']/value"/>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:if test="$name != ''">
              <item>
                <xsl:value-of select="$name"/>
              </item>
            </xsl:if>
	  </list>
	  <list close=". ">
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="$department != ''">
              <item>
                <xsl:value-of select="$department"/>
              </item>
            </xsl:if>
            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Assessment and Review Activities']/section[@label='Research Funding Application Assessment Activities']">
    <subsection>
      <xsl:attribute name="title">
        <xsl:text>Assessment of Research Funding Applications</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Funding Reviewer Role']/lov"/>
        </xsl:variable>
        <xsl:variable name="atype">
          <xsl:value-of select="field[@label='Assessment Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="rtype">
          <xsl:value-of select="field[@label='Reviewer Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="committee">
          <xsl:value-of select="field[@label='Committee Name']/lov"/>
        </xsl:variable>
        <xsl:variable name="org">
          <xsl:value-of select="field[@label='Funding Organization']/value"/>
        </xsl:variable>
        <xsl:variable name="number">
          <xsl:value-of select="field[@label='Number of Applications Assessed']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:if test="$committee != ''">
              <item>
                <xsl:value-of select="$committee"/>
              </item>
            </xsl:if>
            <xsl:if test="$org != ''">
              <item>
                <xsl:value-of select="$org"/>
              </item>
            </xsl:if>
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="$number != '' and number($number) != 1">
              <item>
		<nobr>
                  <xsl:value-of select="$number"/>
                  <xsl:text> Applications</xsl:text>
		</nobr>
              </item>
            </xsl:if>
            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
        </entry>
      </xsl:for-each>

    </subsection>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Assessment and Review Activities']/section[@label='Organizational Review Activities']">
    <subsection>
      <xsl:attribute name="title">
        <xsl:text>Organizational Review</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Role']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>
	<xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Activity Description']/value"/>
          </xsl:call-template>
	</xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </subsection>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Participation Activities -->

  <xsl:template match="section[@label='Activities']/section[@label='Participation Activities']">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="section[@label='Activities']/section[@label='Participation Activities']/section[@label='Event Participation']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Event Participation</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Role']/value"/>
        </xsl:variable>
        <xsl:variable name="type">
          <xsl:value-of select="field[@label='Event Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="name">
          <xsl:value-of select="field[@label='Event Name']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="estartdate">
          <xsl:value-of select="field[@label='Event Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="eenddate">
          <xsl:value-of select="field[@label='Event End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Activity Description']/value"/>
          </xsl:call-template>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:if test="$name != ''">
              <item>
                <xsl:value-of select="$name"/>
              </item>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$startdate != '' or $enddate != ''">
                <item>
                  <xsl:call-template name="format_daterange">
                    <xsl:with-param name="startdate" select="$startdate"/>
                    <xsl:with-param name="enddate" select="$enddate"/>
                  </xsl:call-template>
                </item>
              </xsl:when>
              <xsl:when test="$estartdate != '' or $eenddate != ''">
                <item>
                  <xsl:call-template name="format_daterange">
                    <xsl:with-param name="startdate" select="$estartdate"/>
                    <xsl:with-param name="enddate" select="$eenddate"/>
                  </xsl:call-template>
                </item>
              </xsl:when>
            </xsl:choose>
          </list>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Memberships -->

  <xsl:template match="section[@label='Memberships']">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="section[@label='Memberships']/section[@label='Committee Memberships']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Committee Memberships:</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Role']/lov"/>
        </xsl:variable>
        <xsl:variable name="name">
          <xsl:value-of select="field[@label='Committee Name']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Membership Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='Membership End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Description']/value"/>
          </xsl:call-template>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:if test="$name != ''">
              <item>
                <xsl:value-of select="$name"/>
              </item>
            </xsl:if>
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Memberships']/section[@label='Other Memberships']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Other Memberships</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Role']/value"/>
        </xsl:variable>
        <xsl:variable name="startdate">
          <xsl:value-of select="field[@label='Membership Start Date']/value"/>
        </xsl:variable>
        <xsl:variable name="enddate">
          <xsl:value-of select="field[@label='Membership End Date']/value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Description']/value"/>
          </xsl:call-template>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$role"/>
            </item>
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="$startdate != '' or $enddate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$startdate"/>
                  <xsl:with-param name="enddate" select="$enddate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Contributions -->

  <xsl:template match="section[@label='Contributions']">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="section[@label='Contributions']/section[@label='Presentations']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Presentations</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:sort select="field[@label='Presentation Date']/value" order="descending"/>
        <xsl:variable name="title">
          <xsl:value-of select="field[@label='Presentation Title']/value"/>
        </xsl:variable>
        <xsl:variable name="conference">
          <xsl:value-of select="field[@label='Conference / Event Name']/value"/>
        </xsl:variable>
        <xsl:variable name="city">
          <xsl:value-of select="field[@label='City']/value"/>
        </xsl:variable>
        <xsl:variable name="province">
          <xsl:value-of select="field[@label='Location']/refTable/linkedWith[@label='Subdivision']/@value"/>
        </xsl:variable>
        <xsl:variable name="country">
          <xsl:value-of select="field[@label='Location']/refTable/linkedWith[@label='Country']/@value"/>
        </xsl:variable>
        <xsl:variable name="audience">
          <xsl:value-of select="field[@label='Main Audience']/lov"/>
        </xsl:variable>
        <xsl:variable name="invited">
          <xsl:value-of select="field[@label='Invited?']/lov"/>
        </xsl:variable>
        <xsl:variable name="keynote">
          <xsl:value-of select="field[@label='Keynote?']/lov"/>
        </xsl:variable>
        <xsl:variable name="competitive">
          <xsl:value-of select="field[@label='Competitive?']/lov"/>
        </xsl:variable>
        <xsl:variable name="date">
          <xsl:value-of select="field[@label='Presentation Date']/value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Description / Contribution Value']/value"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="url">
          <xsl:value-of select="field[@label='URL']/value"/>
        </xsl:variable>
        <xsl:variable name="co-presenters">
          <xsl:value-of select="field[@label='Co-Presenters']/value"/>
        </xsl:variable>

        <entry>
          <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
                close1=".&lt;/bold&gt; " close=". ">
            <item>
              <xsl:value-of select="$title"/>
            </item>
          </list>
          <xsl:choose>
            <xsl:when test="$invited = 'Yes' and $keynote = 'Yes'">
              <xsl:text>Invited keynote address. </xsl:text>
            </xsl:when>
            <xsl:when test="$invited = 'Yes'">
              <xsl:text>Invited talk. </xsl:text>
            </xsl:when>
            <xsl:when test="$keynote = 'Yes'">
              <xsl:text>Keynote address. </xsl:text>
            </xsl:when>
          </xsl:choose>
          <xsl:if test="$co-presenters != ''">
            <list open="With " close=". ">
              <xsl:value-of select="$co-presenters"/>
            </list>
          </xsl:if>
          <list close=". ">
            <xsl:if test="$conference != ''">
              <item>
                <xsl:value-of select="$conference"/>
              </item>
            </xsl:if>
            <xsl:if test="$city != ''">
              <item>
                <xsl:value-of select="$city"/>
              </item>
            </xsl:if>
            <xsl:if test="$province != '' and $province != 'Not Required'">
              <item>
                <xsl:value-of select="$province"/>
              </item>
            </xsl:if>
            <xsl:if test="$country != ''">
              <item>
                <xsl:value-of select="$country"/>
              </item>
            </xsl:if>
            <xsl:if test="$date != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$date"/>
                  <xsl:with-param name="enddate" select="$date"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
          <list open="With funding from: " close=". ">
            <xsl:apply-templates/>
          </list>
          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Contributions']/section[@label='Presentations']/record/section[@label='Funding Sources']">
    <xsl:for-each select="record">
      <xsl:variable name="org">
        <xsl:value-of select="field[@label='Funding Organization']/lov"/>
      </xsl:variable>
      <xsl:variable name="org2">
        <xsl:value-of select="field[@label='Other Funding Organization']/value"/>
      </xsl:variable>
      <xsl:variable name="organization">
        <xsl:choose>
          <xsl:when test="$org != ''">
            <xsl:value-of select="$org"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$org2"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="ref">
        <xsl:value-of select="field[@label='Funding Reference Number']/value"/>
      </xsl:variable>

      <item>
        <xsl:value-of select="$organization"/>
        <xsl:if test="$ref != ''">
          <xsl:text> (ref. </xsl:text>
          <xsl:value-of select="$ref"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </item>
    </xsl:for-each>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Media Relations -->

  <xsl:template match="section[@label='Contributions']/section[@label='Interviews and Media Relations']">
    <section>
      <xsl:attribute name="title">
        <xsl:text>Media Relations</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </section>
  </xsl:template>

  <xsl:template match="section[@label='Contributions']/section[@label='Interviews and Media Relations']/section[@label='Text Interviews']">
    
    <xsl:for-each select="record">
      <xsl:variable name="topic">
        <xsl:value-of select="field[@label='Topic']/value"/>
      </xsl:variable>
      <xsl:variable name="interviewer">
        <xsl:value-of select="field[@label='Interviewer']/value"/>
      </xsl:variable>
      <xsl:variable name="forum">
        <xsl:value-of select="field[@label='Forum']/value"/>
      </xsl:variable>
      <xsl:variable name="date">
        <xsl:value-of select="field[@label='Publication Date']/value"/>
      </xsl:variable>
      <xsl:variable name="description">
        <xsl:call-template name="add_period">
          <xsl:with-param name="string" select="field[@label='Description / Contribution Value']/value"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="url">
        <xsl:value-of select="field[@label='URL']/value"/>
      </xsl:variable>

      <entry>
        <list open="&lt;bold&gt;" firstcomma=",&lt;/bold&gt; " comma=", "
              close1=".&lt;/bold&gt; " close=". ">
          <item>
            <xsl:text>Interview</xsl:text>
            <xsl:if test="$topic != ''">
              <xsl:text> on </xsl:text>
              <xsl:value-of select="$topic"/>
            </xsl:if>
          </item>
          <xsl:if test="$interviewer != ''">
            <item>
              <xsl:text>by </xsl:text>
              <xsl:value-of select="$interviewer"/>
            </item>
          </xsl:if>
        </list>
        <list close=". ">
          <xsl:if test="$forum != ''">
            <item>
              <xsl:value-of select="$forum"/>
            </item>
          </xsl:if>
          <xsl:if test="$url != ''">
            <item>
              <url>
                <xsl:value-of select="$url"/>
              </url>
            </item>
          </xsl:if>
          <xsl:if test="$date != ''">
            <item>
              <xsl:call-template name="format_daterange">
                <xsl:with-param name="startdate" select="$date"/>
                <xsl:with-param name="enddate" select="$date"/>
              </xsl:call-template>
            </item>
          </xsl:if>
        </list>

        <xsl:if test="$description != ''">
          <annotate>
            <xsl:value-of select="$description"/>
          </annotate>
        </xsl:if>
      </entry>
    </xsl:for-each>

  </xsl:template>

  <!-- ============================================================ -->
  <!-- Formatting for Publications -->

  <xsl:template match="section[@label='Contributions']/section[@label='Publications']">
    <section>
      <xsl:attribute name="title">
        <xsl:value-of select="@label"/>
      </xsl:attribute>

      <xsl:apply-templates/>

    </section>
  </xsl:template>

  <xsl:template match="section[@label='Contributions']/section[@label='Publications']/section[@label='Journal Articles']">
    <subsection>
      <xsl:attribute name="title">
        <xsl:text>Journal Articles:</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:sort select="field[@label='Date']/value" order="descending"/>
        <xsl:variable name="title">
          <xsl:value-of select="field[@label='Article Title']/value"/>
        </xsl:variable>
        <xsl:variable name="journal">
          <xsl:value-of select="field[@label='Journal']/value"/>
        </xsl:variable>
        <xsl:variable name="volume">
          <xsl:value-of select="field[@label='Volume']/value"/>
        </xsl:variable>
        <xsl:variable name="issue">
          <xsl:value-of select="field[@label='Issue']/value"/>
        </xsl:variable>
        <xsl:variable name="pagerange">
          <xsl:value-of select="field[@label='Page Range']/value"/>
        </xsl:variable>
        <xsl:variable name="status">
          <xsl:value-of select="field[@label='Publishing Status']/lov"/>
        </xsl:variable>
        <xsl:variable name="date">
          <xsl:value-of select="field[@label='Date']/value"/>
        </xsl:variable>
        <xsl:variable name="publisher">
          <xsl:value-of select="field[@label='Publisher']/value"/>
        </xsl:variable>
        <xsl:variable name="province">
          <xsl:value-of select="field[@label='Publication Location']/refTable/linkedWith[@label='Subdivision']/@value"/>
        </xsl:variable>
        <xsl:variable name="country">
          <xsl:value-of select="field[@label='Publication Location']/refTable/linkedWith[@label='Country']/@value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Description / Contribution Value']/value"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="url">
          <xsl:value-of select="field[@label='URL']/value"/>
        </xsl:variable>
        <xsl:variable name="refereed">
          <xsl:value-of select="field[@label='Refereed?']/lov"/>
        </xsl:variable>
        <xsl:variable name="openaccess">
          <xsl:value-of select="field[@label='Open Access?']/lov"/>
        </xsl:variable>
        <xsl:variable name="synthesis">
          <xsl:value-of select="field[@label='Synthesis?']/lov"/>
        </xsl:variable>
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Contribution Role']/*"/>
        </xsl:variable>
        <xsl:variable name="numcontributors">
          <xsl:value-of select="field[@label='Number of Contributors']/value"/>
        </xsl:variable>
        <xsl:variable name="authors">
          <xsl:value-of select="field[@label='Authors']/value"/>
        </xsl:variable>
        <xsl:variable name="editors">
          <xsl:value-of select="field[@label='Editors']/value"/>
        </xsl:variable>

        <xsl:variable name="title_ends_with_punctuation">
          <xsl:call-template name="ends_with_punctuation">
            <xsl:with-param name="string" select="$title"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="title_close">
          <xsl:if test="$title_ends_with_punctuation != 'true'">
            <xsl:text>.</xsl:text>
          </xsl:if>
        </xsl:variable>

        <entry>
          <list firstcomma=", &lt;bold&gt;">
            <xsl:attribute name="close">
              <xsl:value-of select="concat($title_close, '&lt;/bold&gt; ')"/>
            </xsl:attribute>
            <xsl:attribute name="close1">
              <xsl:value-of select="concat($title_close, ' ')"/>
            </xsl:attribute>
            <item>
              <xsl:value-of select="$authors"/>
            </item>
            <item>
              <xsl:value-of select="$title"/>
            </item>
          </list>

          <list close=". ">
            <xsl:if test="$status != '' and $status != 'Published'">
              <item>
                <xsl:value-of select="$status"/>
              </item>
            </xsl:if>
            <xsl:if test="$journal != '' or $volume != '' or $pagerange != ''">
              <item>
                <list comma=" ">
                  <xsl:if test="$journal != ''">
                    <item>
                      <xsl:value-of select="$journal"/>
                    </item>
                  </xsl:if>
                  <xsl:if test="$volume != '' or $pagerange != ''">
                    <item>
                      <xsl:if test="$volume != ''">
                        <xsl:value-of select="$volume"/>
                        <xsl:if test="$issue != ''">
                          <xsl:text>(</xsl:text>
                          <xsl:value-of select="$issue"/>
                          <xsl:text>)</xsl:text>
                        </xsl:if>
                      </xsl:if>
                      <xsl:if test="$volume != '' and $pagerange != ''">
                        <xsl:text>:</xsl:text>
                      </xsl:if>
                      <xsl:if test="$pagerange != ''">
                        <xsl:value-of select="$pagerange"/>
                      </xsl:if>
                    </item>
                  </xsl:if>
                </list>
              </item>
            </xsl:if>
            <xsl:if test="$date != ''">
              <item>
                <xsl:call-template name="year_from_date">
                  <xsl:with-param name="date" select="$date"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </subsection>
  </xsl:template>

  <xsl:template match="section[@label='Contributions']/section[@label='Publications']/section[@label='Book Chapters']">
    <subsection>
      <xsl:attribute name="title">
        <xsl:text>Book Chapters:</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:sort select="field[@label='Date']/value" order="descending"/>
        <xsl:variable name="title">
          <xsl:value-of select="field[@label='Chapter Title']/value"/>
        </xsl:variable>
        <xsl:variable name="booktitle">
          <xsl:value-of select="field[@label='Book Title']/value"/>
        </xsl:variable>
        <xsl:variable name="edition">
          <xsl:value-of select="field[@label='Edition']/value"/>
        </xsl:variable>
        <xsl:variable name="volume">
          <xsl:value-of select="field[@label='Volume']/value"/>
        </xsl:variable>
        <xsl:variable name="pagerange">
          <xsl:value-of select="field[@label='Page Range']/value"/>
        </xsl:variable>
        <xsl:variable name="status">
          <xsl:value-of select="field[@label='Publishing Status']/lov"/>
        </xsl:variable>
        <xsl:variable name="date">
          <xsl:value-of select="field[@label='Date']/value"/>
        </xsl:variable>
        <xsl:variable name="publisher">
          <xsl:value-of select="field[@label='Publisher']/value"/>
        </xsl:variable>
        <xsl:variable name="city">
          <xsl:value-of select="field[@label='Publication City']/value"/>
        </xsl:variable>
        <xsl:variable name="province">
          <xsl:value-of select="field[@label='Publication Location']/refTable/linkedWith[@label='Subdivision']/@value"/>
        </xsl:variable>
        <xsl:variable name="country">
          <xsl:value-of select="field[@label='Publication Location']/refTable/linkedWith[@label='Country']/@value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Description / Contribution Value']/value"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="url">
          <xsl:value-of select="field[@label='URL']/value"/>
        </xsl:variable>
        <xsl:variable name="refereed">
          <xsl:value-of select="field[@label='Refereed?']/lov"/>
        </xsl:variable>
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Contribution Role']/*"/>
        </xsl:variable>
        <xsl:variable name="numcontributors">
          <xsl:value-of select="field[@label='Number of Contributors']/value"/>
        </xsl:variable>
        <xsl:variable name="authors">
          <xsl:value-of select="field[@label='Authors']/value"/>
        </xsl:variable>
        <xsl:variable name="editors">
          <xsl:value-of select="field[@label='Editors']/value"/>
        </xsl:variable>
        <xsl:variable name="status-in">
          <xsl:choose>
            <xsl:when test="$status = 'Submitted'">
              <xsl:text>Submitted to </xsl:text>
            </xsl:when>
            <xsl:when test="$status = 'Accepted'">
              <xsl:text>Accepted in </xsl:text>
            </xsl:when>
            <xsl:when test="$status = 'In Press'">
              <xsl:text>To appear in </xsl:text>
            </xsl:when>
            <xsl:when test="$status = 'Published' or $status=''">
              <xsl:text>In </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$status"/>
              <xsl:text>. In </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="title_ends_with_punctuation">
          <xsl:call-template name="ends_with_punctuation">
            <xsl:with-param name="string" select="$title"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="title_close">
          <xsl:if test="$title_ends_with_punctuation != 'true'">
            <xsl:text>.</xsl:text>
          </xsl:if>
        </xsl:variable>

        <entry>
          <list firstcomma=", &lt;bold&gt;">
            <xsl:attribute name="close">
              <xsl:value-of select="concat($title_close, '&lt;/bold&gt; ')"/>
            </xsl:attribute>
            <xsl:attribute name="close1">
              <xsl:value-of select="concat($title_close, ' ')"/>
            </xsl:attribute>
            <item>
              <xsl:value-of select="$authors"/>
            </item>
            <item>
              <xsl:value-of select="$title"/>
            </item>
          </list>

          <list close=". ">
            <xsl:choose>
              <xsl:when test="$booktitle != ''">
                <item>
                  <xsl:value-of select="$status-in"/>
                  <italic>
                    <xsl:value-of select="$booktitle"/>
                  </italic>
                </item>
              </xsl:when>
              <xsl:when test="$status != '' and $status != 'Published'">
                <item>
                  <xsl:value-of select="$status"/>
                </item>
              </xsl:when>
            </xsl:choose>
            <xsl:if test="$edition != ''">
              <item>
                <xsl:value-of select="$edition"/>
              </item>
            </xsl:if>
            <xsl:if test="$volume != ''">
              <item>
                <xsl:text>Volume </xsl:text>
                <xsl:value-of select="$volume"/>
              </item>
            </xsl:if>
            <xsl:if test="$pagerange != '' and $pagerange != '0'">
              <item>
                <xsl:choose>
                  <xsl:when test="contains($pagerange, '-')">
                    <xsl:text>pp. </xsl:text>
                    <xsl:value-of select="$pagerange"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>p. </xsl:text>
                    <xsl:value-of select="$pagerange"/>
                  </xsl:otherwise>
                </xsl:choose>
              </item>
            </xsl:if>
            <xsl:if test="$publisher != ''">
              <item>
                <xsl:value-of select="$publisher"/>
                <xsl:if test="$city != ''">
                  <xsl:value-of select="$city"/>
                </xsl:if>
                <xsl:if test="$province != '' and $province != 'Not Required'">
                  <xsl:value-of select="$province"/>
                </xsl:if>
                <xsl:if test="$country != ''">
                  <xsl:value-of select="$country"/>
                </xsl:if>
              </item>
            </xsl:if>
            <xsl:if test="$date != ''">
              <item>
                <xsl:call-template name="year_from_date">
                  <xsl:with-param name="date" select="$date"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
          <xsl:if test="$editors != ''">
            <item>
              <xsl:text>Edited by </xsl:text>
              <xsl:value-of select="$editors"/>
              <xsl:text>. </xsl:text>
            </item>
          </xsl:if>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </subsection>
  </xsl:template>

  <xsl:template match="section[@label='Contributions']/section[@label='Publications']/section[@label='Dissertations']">
    <subsection>
      <xsl:attribute name="title">
        <xsl:text>Theses:</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:sort select="field[@label='Date']/value" order="descending"/>
        <xsl:variable name="title">
          <xsl:value-of select="field[@label='Dissertation Title']/value"/>
        </xsl:variable>
        <xsl:variable name="supervisor">
          <xsl:value-of select="field[@label='Supervisor']/value"/>
        </xsl:variable>
        <xsl:variable name="date">
          <xsl:value-of select="field[@label='Completion Date']/value"/>
        </xsl:variable>
        <xsl:variable name="type"> 
          <xsl:value-of select="field[@label='Degree Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="numpages"> 
          <xsl:value-of select="field[@label='Number of Pages']/value"/>
        </xsl:variable>
        <xsl:variable name="description">
          <xsl:call-template name="add_period">
            <xsl:with-param name="string" select="field[@label='Description / Contribution Value']/value"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="url">
          <xsl:value-of select="field[@label='URL']/value"/>
        </xsl:variable>
        <xsl:variable name="name">
          <xsl:choose>
            <xsl:when test="$type = 'Doctorate'">
              <xsl:text>Doctoral Thesis</xsl:text>
            </xsl:when>
            <xsl:when test="$type != ''">
              <xsl:value-of select="$type"/>
              <xsl:text> Thesis</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="title_ends_with_punctuation">
          <xsl:call-template name="ends_with_punctuation">
            <xsl:with-param name="string" select="$title"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="title_close">
          <xsl:if test="$title_ends_with_punctuation != 'true'">
            <xsl:text>.</xsl:text>
          </xsl:if>
        </xsl:variable>

        <entry>
          <list firstcomma=", &lt;bold&gt;">
            <xsl:attribute name="close">
              <xsl:value-of select="concat($title_close, '&lt;/bold&gt; ')"/>
            </xsl:attribute>
            <xsl:attribute name="close1">
              <xsl:value-of select="concat($title_close, ' ')"/>
            </xsl:attribute>
            <item>
              <xsl:value-of select="$myname"/>
            </item>
            <item>
              <xsl:value-of select="$title"/>
            </item>
          </list>

          <list close=". ">
            <xsl:if test="$name != ''">
              <item>
                <xsl:value-of select="$name"/>
              </item>
            </xsl:if>
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="$numpages != ''">
              <item>
                <xsl:value-of select="$numpages"/>
                <xsl:choose>
                  <xsl:when test="number($numpages) = 1">
                    <xsl:text> page</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text> pages</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </item>
            </xsl:if>
            <xsl:if test="$date != ''">
              <item>
                <xsl:call-template name="year_from_date">
                  <xsl:with-param name="date" select="$date"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
          <list close=". ">
            <xsl:if test="$supervisor != ''">
              <item>
                <xsl:text>Supervisor: </xsl:text>
                <xsl:value-of select="$supervisor"/>
              </item>
            </xsl:if>
          </list>

          <xsl:if test="$description != ''">
            <annotate>
              <xsl:value-of select="$description"/>
            </annotate>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </subsection>
  </xsl:template>

  <xsl:template match="section[@label='Contributions']/section[@label='Publications']/section[@label='Conference Publications']">
    <subsection>
      <xsl:attribute name="title">
        <xsl:text>Conference Publications:</xsl:text>
      </xsl:attribute>

      <xsl:for-each select="record">
        <xsl:sort select="field[@label='Date']/value" order="descending"/>
        <xsl:variable name="type">
          <xsl:value-of select="field[@label='Conference Publication Type']/lov"/>
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:value-of select="field[@label='Publication Title']/value"/>
        </xsl:variable>
        <xsl:variable name="conference">
          <xsl:value-of select="field[@label='Conference Name']/value"/>
        </xsl:variable>
        <xsl:variable name="city">
          <xsl:value-of select="field[@label='City']/value"/>
        </xsl:variable>
        <xsl:variable name="province">
          <xsl:value-of select="field[@label='Conference Location']/refTable/linkedWith[@label='Subdivision']/@value"/>
        </xsl:variable>
        <xsl:variable name="country">
          <xsl:value-of select="field[@label='Conference Location']/refTable/linkedWith[@label='Country']/@value"/>
        </xsl:variable>
        <xsl:variable name="conferencedate">
          <xsl:value-of select="field[@label='Conference Date']/value"/>
        </xsl:variable>
        <xsl:variable name="published_in">
          <xsl:value-of select="field[@label='Published In']/value"/>
        </xsl:variable>
        <xsl:variable name="pagerange">
          <xsl:value-of select="field[@label='Page Range']/value"/>
        </xsl:variable>
        <xsl:variable name="status">
          <xsl:value-of select="field[@label='Publishing Status']/lov"/>
        </xsl:variable>
        <xsl:variable name="date">
          <xsl:value-of select="field[@label='Date']/value"/>
        </xsl:variable>
        <xsl:variable name="publisher">
          <xsl:value-of select="field[@label='Publisher']/value"/>
        </xsl:variable>
        <xsl:variable name="publisher_province">
          <xsl:value-of select="field[@label='Publisher Location']/refTable/linkedWith[@label='Subdivision']/@value"/>
        </xsl:variable>
        <xsl:variable name="publisher_country">
          <xsl:value-of select="field[@label='Publisher Location']/refTable/linkedWith[@label='Country']/@value"/>
        </xsl:variable>
        <xsl:variable name="url">
          <xsl:value-of select="field[@label='URL']/value"/>
        </xsl:variable>
        <xsl:variable name="refereed">
          <xsl:value-of select="field[@label='Refereed?']/lov"/>
        </xsl:variable>
        <xsl:variable name="invited">
          <xsl:value-of select="field[@label='Invited?']/lov"/>
        </xsl:variable>
        <xsl:variable name="role">
          <xsl:value-of select="field[@label='Contribution Role']/*"/>
        </xsl:variable>
        <xsl:variable name="numcontributors">
          <xsl:value-of select="field[@label='Number of Contributors']/value"/>
        </xsl:variable>
        <xsl:variable name="authors">
          <xsl:value-of select="field[@label='Authors']/value"/>
        </xsl:variable>
        <xsl:variable name="editors">
          <xsl:value-of select="field[@label='Editors']/value"/>
        </xsl:variable>

        <xsl:variable name="status-in">
          <xsl:choose>
            <xsl:when test="$status = 'Submitted'">
              <xsl:text>Submitted to </xsl:text>
            </xsl:when>
            <xsl:when test="$status = 'Accepted'">
              <xsl:text>Accepted in </xsl:text>
            </xsl:when>
            <xsl:when test="$status = 'In Press'">
              <xsl:text>To appear in </xsl:text>
            </xsl:when>
            <xsl:when test="$status = 'Published' or $status=''">
              <xsl:text>In </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$status"/>
              <xsl:text>. In </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="title_ends_with_punctuation">
          <xsl:call-template name="ends_with_punctuation">
            <xsl:with-param name="string" select="$title"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="title_close">
          <xsl:if test="$title_ends_with_punctuation != 'true'">
            <xsl:text>.</xsl:text>
          </xsl:if>
        </xsl:variable>

        <entry>
          <list firstcomma=", &lt;bold&gt;">
            <xsl:attribute name="close">
              <xsl:value-of select="concat($title_close, '&lt;/bold&gt; ')"/>
            </xsl:attribute>
            <xsl:attribute name="close1">
              <xsl:value-of select="concat($title_close, ' ')"/>
            </xsl:attribute>
            <item>
              <xsl:value-of select="$authors"/>
            </item>
            <item>
              <xsl:value-of select="$title"/>
            </item>
          </list>

          <list close=". ">
            <xsl:choose>
              <xsl:when test="$conference != ''">
                <item>
                  <xsl:value-of select="$status-in"/>
                  <italic>
                    <xsl:value-of select="$conference"/>
                  </italic>
                </item>
              </xsl:when>
              <xsl:when test="$status != '' and $status != 'Published'">
                <item>
                  <xsl:value-of select="$status"/>
                </item>
              </xsl:when>
            </xsl:choose>
            <xsl:if test="$city != ''">
              <item>
                <xsl:value-of select="$city"/>
              </item>
            </xsl:if>
            <xsl:if test="$province != '' and $province != 'Not Required'">
              <item>
                <xsl:value-of select="$province"/>
              </item>
            </xsl:if>
            <xsl:if test="$country != ''">
              <item>
                <xsl:value-of select="$country"/>
              </item>
            </xsl:if>
            <xsl:if test="$conferencedate != ''">
              <item>
                <xsl:call-template name="format_daterange">
                  <xsl:with-param name="startdate" select="$conferencedate"/>
                  <xsl:with-param name="enddate" select="$conferencedate"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>

          <list close=". ">
            <xsl:if test="$published_in != ''">
              <item>
                <xsl:value-of select="$published_in"/>
              </item>
            </xsl:if>
            <xsl:if test="$pagerange != '' and $pagerange != '0'">
              <item>
                <xsl:choose>
                  <xsl:when test="contains($pagerange, '-')">
                    <xsl:text>pp. </xsl:text>
                    <xsl:value-of select="$pagerange"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>p. </xsl:text>
                    <xsl:value-of select="$pagerange"/>
                  </xsl:otherwise>
                </xsl:choose>
              </item>
            </xsl:if>
            <xsl:if test="$publisher != ''">
              <item>
                <xsl:value-of select="$publisher"/>
                <xsl:if test="$publisher_province != '' and $publisher_province != 'Not Required'">
                  <xsl:value-of select="$publisher_province"/>
                </xsl:if>
                <xsl:if test="$publisher_country != ''">
                  <xsl:value-of select="$publisher_country"/>
                </xsl:if>
              </item>
            </xsl:if>
            <xsl:if test="$date != ''">
              <item>
                <xsl:call-template name="year_from_date">
                  <xsl:with-param name="date" select="$date"/>
                </xsl:call-template>
              </item>
            </xsl:if>
          </list>
          <xsl:if test="$editors != ''">
            <item>
              <xsl:text>Edited by </xsl:text>
              <xsl:value-of select="$editors"/>
              <xsl:text>. </xsl:text>
            </item>
          </xsl:if>
        </entry>
      </xsl:for-each>

    </subsection>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- A generic template for formatting an organization. If the
       parameter "bold" is true, make the school name bold -->

  <xsl:template mode="organization" match="node()">
    <xsl:variable name="academicschool">
      <xsl:value-of select="field[@label='Organization']/refTable/linkedWith[@label='Organization']/@value"/>
    </xsl:variable>
    <xsl:variable name="academicprovince">
      <xsl:value-of select="field[@label='Organization']/refTable/linkedWith[@label='Subdivision']/@value"/>
    </xsl:variable>
    <xsl:variable name="academiccountry">
      <xsl:value-of select="field[@label='Organization']/refTable/linkedWith[@label='Country']/@value"/>
    </xsl:variable>
    <xsl:variable name="otherschool">
      <xsl:value-of select="field[@label='Other Organization']/value"/>
    </xsl:variable>
    <xsl:variable name="otherprovince">
      <xsl:value-of select="field[@label='Other Organization Location']/refTable/linkedWith[@label='Subdivision']/@value"/>
    </xsl:variable>
    <xsl:variable name="othercountry">
      <xsl:value-of select="field[@label='Other Organization Location']/refTable/linkedWith[@label='Country']/@value"/>
    </xsl:variable>
    <xsl:variable name="school">
      <xsl:choose>
        <xsl:when test="$academicschool != ''">
          <xsl:value-of select="$academicschool"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$otherschool"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="province">
      <xsl:choose>
        <xsl:when test="$academicprovince != ''">
          <xsl:value-of select="$academicprovince"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$otherprovince"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="country">
      <xsl:choose>
        <xsl:when test="$academiccountry != ''">
          <xsl:value-of select="$academiccountry"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$othercountry"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$school != ''">
      <item>
        <xsl:value-of select="$school"/>
      </item>
    </xsl:if>
    <xsl:if test="$province != '' and $province != 'Not Required'">
      <item>
        <xsl:value-of select="$province"/>
      </item>
    </xsl:if>
    <xsl:if test="$country != ''">
      <item>
        <xsl:value-of select="substring-before(concat($country, ','), ',')"/>
      </item>
    </xsl:if>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Templates for formatting dates -->

  <!-- Generic template for formatting a date range -->
  <xsl:template name="format_daterange">
    <xsl:param name="startdate"/>
    <xsl:param name="enddate"/>

    <!-- Extract year, month, and day -->
    <xsl:variable name="startyear">
      <xsl:choose>
        <xsl:when test="contains($startdate, '-')">
          <xsl:value-of select="number(substring-before($startdate, '-'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(substring-before(concat($startdate, '/'), '/'))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="startmonth">
      <xsl:choose>
        <xsl:when test="contains($startdate, '-')">
          <xsl:value-of select="number(substring-before(substring-after($startdate, '-'), '-'))"/>
        </xsl:when>
        <xsl:when test="contains($startdate, '/')">
          <xsl:value-of select="number(substring-after($startdate, '/'))"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="startday">
      <xsl:choose>
        <xsl:when test="contains($startdate, '-')">
          <xsl:value-of select="number(substring-after(substring-after($startdate, '-'), '-'))"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="endyear">
      <xsl:choose>
        <xsl:when test="contains($enddate, '-')">
          <xsl:value-of select="number(substring-before($enddate, '-'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(substring-before(concat($enddate, '/'), '/'))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="endmonth">
      <xsl:choose>
        <xsl:when test="contains($enddate, '-')">
          <xsl:value-of select="number(substring-before(substring-after($enddate, '-'), '-'))"/>
        </xsl:when>
        <xsl:when test="contains($enddate, '/')">
          <xsl:value-of select="number(substring-after($enddate, '/'))"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="endday">
      <xsl:choose>
        <xsl:when test="contains($enddate, '-')">
          <xsl:value-of select="number(substring-after(substring-after($enddate, '-'), '-'))"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$startyear != $endyear">
        <xsl:if test="$startdate != ''">
          <xsl:if test="$startmonth != ''">
	    <xsl:call-template name="month_and_day">
	      <xsl:with-param name="month" select="$startmonth"/>
	      <xsl:with-param name="day" select="$startday"/>
	    </xsl:call-template>
	    <xsl:if test="$startday != ''">
	      <xsl:text>,</xsl:text>
	    </xsl:if>
	    <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:value-of select="$startyear"/>
        </xsl:if>
        <xsl:text> &#x2013; </xsl:text>
        <xsl:if test="$enddate != ''">
          <xsl:if test="$endmonth != ''">
	    <xsl:call-template name="month_and_day">
	      <xsl:with-param name="month" select="$endmonth"/>
	      <xsl:with-param name="day" select="$endday"/>
	    </xsl:call-template>
	    <xsl:if test="$endday != ''">
	      <xsl:text>,</xsl:text>
	    </xsl:if>
	    <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:value-of select="$endyear"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$startmonth != $endmonth">
        <xsl:call-template name="month_and_day">
          <xsl:with-param name="month" select="$startmonth"/>
          <xsl:with-param name="day" select="$startday"/>
	</xsl:call-template>
        <xsl:text> &#x2013; </xsl:text>
        <xsl:call-template name="month_and_day">
          <xsl:with-param name="month" select="$endmonth"/>
          <xsl:with-param name="day" select="$endday"/>
        </xsl:call-template>
	<xsl:if test="$endday != ''">
	  <xsl:text>,</xsl:text>
	</xsl:if>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$startyear"/>
      </xsl:when>
      <xsl:when test="$startday != $endday">
	<nobr>
          <xsl:call-template name="monthname">
            <xsl:with-param name="month" select="$startmonth"/>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$startday"/>
          <xsl:text>&#x2013;</xsl:text>
          <xsl:value-of select="$endday"/>
        </nobr>
	<xsl:text>, </xsl:text>
        <xsl:value-of select="$startyear"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="month_and_day">
          <xsl:with-param name="month" select="$startmonth"/>
          <xsl:with-param name="day" select="$startday"/>
        </xsl:call-template>
	<xsl:if test="$startday != ''">
          <xsl:text>,</xsl:text>
        </xsl:if>
	<xsl:text> </xsl:text>
        <xsl:value-of select="$startyear"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Generic template for formatting a month and day -->
  <xsl:template name="month_and_day">
    <xsl:param name="month"/>  <!-- an integer 1..12 -->
    <xsl:param name="day"/>    <!-- an integer 1..31, or '' -->

    <xsl:choose>
      <xsl:when test="$day != ''">
	<nobr>
	  <xsl:call-template name="monthname">
	    <xsl:with-param name="month" select="$month"/>
	  </xsl:call-template>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="$day"/>
	</nobr>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="monthname">
	  <xsl:with-param name="month" select="$month"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Generic template for converting a month to a name -->
  <xsl:template name="monthname">
    <xsl:param name="month"/>  <!-- an integer 1..12 -->
    <xsl:choose>
      <xsl:when test="$month = 1">
        <xsl:text>January</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 2">
        <xsl:text>Feburary</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 3">
        <xsl:text>March</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 4">
        <xsl:text>April</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 5">
        <xsl:text>May</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 6">
        <xsl:text>June</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 7">
        <xsl:text>July</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 8">
        <xsl:text>August</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 9">
        <xsl:text>September</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 10">
        <xsl:text>October</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 11">
        <xsl:text>November</xsl:text>
      </xsl:when>
      <xsl:when test="$month = 12">
        <xsl:text>December</xsl:text>
      </xsl:when>
      <otherwise>
        <xsl:message terminate="yes">
          <xsl:text>Error: bad month number </xsl:text>
          <xsl:value-of select="$month"/>
        </xsl:message>
      </otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="year_from_date">
    <xsl:param name="date"/>

    <!-- Extract year -->
    <xsl:variable name="year">
      <xsl:choose>
        <xsl:when test="contains($date, '-')">
          <xsl:value-of select="number(substring-before($date, '-'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(substring-before(concat($date, '/'), '/'))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$year"/>
  </xsl:template>

  <!-- ============================================================ -->
  <!-- Templates for dealing with punctuation at the end of strings -->

  <!-- determines whether a string ends with punctuation -->
  <xsl:template name="ends_with_punctuation">
    <xsl:param name="string"/>

    <xsl:variable name="stripped">
      <xsl:value-of select="normalize-space($string)"/>
    </xsl:variable>

    <xsl:variable name="length">
      <xsl:value-of select="string-length($stripped)"/>
    </xsl:variable>

    <xsl:variable name="lastchar">
      <xsl:value-of select="substring($stripped, $length, 1)"/>
    </xsl:variable>

    <xsl:variable name="secondlastchar">
      <xsl:value-of select="substring($stripped, $length - 1, 1)"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$lastchar = '&quot;'">
        <xsl:value-of select="contains('?!,.;:', $secondlastchar)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="contains('?!,.;:', $lastchar)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- add a period to the end of a string, if it does not end in
       punctuation. If the string is empty, do nothing. -->
  <xsl:template name="add_period">
    <xsl:param name="string"/>

    <xsl:variable name="string_ends_with_punctuation">
      <xsl:call-template name="ends_with_punctuation">
        <xsl:with-param name="string" select="$string"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$string != ''">
      <xsl:value-of select="normalize-space($string)"/>
      <xsl:if test="$string_ends_with_punctuation != 'true'">
        <xsl:text>.</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>


  <!-- Resume-style roles in source order; missing end dates are not inferred. -->
  <xsl:template match="section[@label='Non-academic Work Experience']">
    <subsection title="Non-academic Work Experience">
      <xsl:for-each select="record">
        <entry type="work">
          <bold><xsl:value-of select="field[@label='Position Title']/value"/></bold>
          <linebreak/>
          <list comma=" · " close="">
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="normalize-space(field[@label='Unit / Division']) != ''">
              <item><xsl:value-of select="field[@label='Unit / Division']/value"/></item>
            </xsl:if>
          </list>
          <xsl:variable name="start" select="normalize-space(field[@label='Start Date']/value)"/>
          <xsl:variable name="end" select="normalize-space(field[@label='End Date']/value)"/>
          <xsl:variable name="status" select="normalize-space(field[@label='Position Status'])"/>
          <xsl:if test="$start != '' or $end != '' or $status != ''">
            <linebreak/>
            <italic>
              <xsl:value-of select="$start"/>
              <xsl:if test="$start != '' and $end != '' and $start != $end"><xsl:text>–</xsl:text></xsl:if>
              <xsl:if test="$start != $end"><xsl:value-of select="$end"/></xsl:if>
              <xsl:if test="($start != '' or $end != '') and $status != ''"><xsl:text> · </xsl:text></xsl:if>
              <xsl:value-of select="$status"/>
            </italic>
          </xsl:if>
          <xsl:if test="normalize-space(field[@label='Work Description']/value) != ''">
            <work-description><xsl:value-of select="field[@label='Work Description']/value"/></work-description>
          </xsl:if>
          <!-- Preserve additional populated fields not represented above. -->
          <xsl:apply-templates select="field[not(@label='Position Title' or @label='Organization' or @label='Other Organization' or @label='Other Organization Location' or @label='Other Organization Type' or @label='Unit / Division' or @label='Start Date' or @label='End Date' or @label='Position Status' or @label='Work Description')][normalize-space(.) != '' or .//@value[normalize-space(.) != '']]"/>
        </entry>
      </xsl:for-each>
    </subsection>
  </xsl:template>

  <!-- Modified 2026-10-05: resume-style community and volunteer roles; missing end dates are not inferred. -->
  <xsl:template match="section[@label='Community and Volunteer Activities']">
    <subsection title="Community and Volunteer Activities">
      <xsl:for-each select="record">
        <entry type="work">
          <bold><xsl:value-of select="field[@label='Role']/value"/></bold>
          <linebreak/>
          <list comma=" · " close="">
            <xsl:apply-templates select="." mode="organization"/>
            <xsl:if test="normalize-space(field[@label='Unit / Division']) != ''">
              <item><xsl:value-of select="field[@label='Unit / Division']/value"/></item>
            </xsl:if>
          </list>
          <xsl:variable name="start" select="normalize-space(field[@label='Start Date']/value)"/>
          <xsl:variable name="end" select="normalize-space(field[@label='End Date']/value)"/>
          <xsl:variable name="status" select="normalize-space(field[@label='Position Status'])"/>
          <xsl:if test="$start != '' or $end != '' or $status != ''">
            <linebreak/>
            <italic>
              <xsl:value-of select="$start"/>
              <xsl:if test="$start != '' and $end != '' and $start != $end"><xsl:text>–</xsl:text></xsl:if>
              <xsl:if test="$start != $end"><xsl:value-of select="$end"/></xsl:if>
              <xsl:if test="($start != '' or $end != '') and $status != ''"><xsl:text> · </xsl:text></xsl:if>
              <xsl:value-of select="$status"/>
            </italic>
          </xsl:if>
          <xsl:if test="normalize-space(field[@label='Activity Description']/value) != ''">
            <work-description><xsl:value-of select="field[@label='Activity Description']/value"/></work-description>
          </xsl:if>
          <!-- Preserve additional populated fields not represented above. -->
          <xsl:apply-templates select="field[not(@label='Role' or @label='Organization' or @label='Other Organization' or @label='Other Organization Location' or @label='Other Organization Type' or @label='Unit / Division' or @label='Start Date' or @label='End Date' or @label='Position Status' or @label='Activity Description')][normalize-space(.) != '' or .//@value[normalize-space(.) != '']]"/>
        </entry>
      </xsl:for-each>
    </subsection>
  </xsl:template>

</xsl:stylesheet>
