<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:s="urn:com.io7m.structural:8:0"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:output method="xml"
              exclude-result-prefixes="#all"
              indent="yes"/>

  <xsl:template match="@*|node()"/>

  <xsl:template match="//s:Subsection[@type='cache']">
    <s:Item>
      <xsl:element name="s:Link">
        <xsl:attribute name="target" select="@id"/>
        <xsl:value-of select="@title"/>
      </xsl:element>
    </s:Item>
  </xsl:template>

  <xsl:template match="s:Document">
    <xsl:element name="s:ListUnordered">
      <xsl:apply-templates select="//s:Subsection[@type='cache']"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
