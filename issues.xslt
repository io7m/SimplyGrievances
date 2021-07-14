<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:s="urn:com.io7m.structural:8:0"
                xmlns:k="urn:com.io7m.sg"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:output method="xml"
              exclude-result-prefixes="#all"
              indent="yes"/>

  <xsl:template match="s:Link"
                mode="copyLink">
    <xsl:element name="s:Link">
      <xsl:attribute name="target"
                     select="@target"/>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="s:Paragraph"
                mode="findIssueClass">
    <xsl:choose>
      <xsl:when test="starts-with(normalize-space(.), 'Issue class:')">
        <xsl:apply-templates select="s:Link"
                             mode="copyLink"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="s:Paragraph"
                mode="findIssueSeverity">
    <xsl:choose>
      <xsl:when test="starts-with(normalize-space(.), 'Issue class:')">
        <xsl:analyze-string select="normalize-space(.)"
                            regex="Severity: (.*)\.">
          <xsl:matching-substring>
            <xsl:value-of select="regex-group(1)"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:function name="k:severityOf"
                as="xsd:integer">
    <xsl:param name="nodes"
               as="element()+"/>
    <xsl:for-each select="$nodes">
      <xsl:choose>
        <xsl:when test="starts-with(normalize-space(.), 'Issue class:')">
          <xsl:analyze-string select="normalize-space(.)"
                              regex="Severity: (.*)\.">
            <xsl:matching-substring>
              <xsl:choose>
                <xsl:when test="regex-group(1) = 'Minor'">
                  <xsl:value-of select="0"/>
                </xsl:when>
                <xsl:when test="regex-group(1) = 'Major'">
                  <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:when test="regex-group(1) = 'Critical'">
                  <xsl:value-of select="2"/>
                </xsl:when>
              </xsl:choose>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:function>

  <xsl:template match="@*|node()"/>

  <xsl:template match="//s:Subsection[@type='issue']">
    <s:Row>
      <s:Cell type="cellIssue">
        <xsl:element name="s:Link">
          <xsl:attribute name="target"
                         select="@id"/>
          <xsl:value-of select="@title"/>
        </xsl:element>
      </s:Cell>
      <s:Cell type="cellClass">
        <xsl:apply-templates select="s:Paragraph"
                             mode="findIssueClass"/>
      </s:Cell>
      <s:Cell type="cellSeverity">
        <xsl:apply-templates select="s:Paragraph"
                             mode="findIssueSeverity"/>
      </s:Cell>
    </s:Row>
  </xsl:template>

  <xsl:template match="s:Document">
    <xsl:element name="s:Table">
      <xsl:attribute name="type"
                     select="'genericTable'"/>

      <xsl:element name="s:Columns">
        <xsl:element name="s:Column">Issue</xsl:element>
        <xsl:element name="s:Column">Class</xsl:element>
        <xsl:element name="s:Column">Severity</xsl:element>
      </xsl:element>

      <xsl:apply-templates select="//s:Subsection[@type='issue']">
        <xsl:sort select="k:severityOf(s:Paragraph)"
                  order="descending"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
