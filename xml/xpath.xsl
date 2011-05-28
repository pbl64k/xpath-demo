<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/">
    <div class="xml">
      <xsl:apply-templates select="@*|node()"/>
    </div>
  </xsl:template>
  <xsl:template match="*">
    <xsl:variable name="name" select="name()"/>
    <div class="xml" onClick="setContext (event , this) ;">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="namespc"/>
      <xsl:text>/&gt;</xsl:text>
    </div>
  </xsl:template>
  <xsl:template match="*[node()]">
    <div class="xml" onClick="setContext (event , this) ;">
      <xsl:variable name="name" select="name()"/>
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="namespc"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates select="node()"/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>&gt;</xsl:text>
    </div>
  </xsl:template>
  <xsl:template match="@*">
    <span class="attr xml"
      onClick="setContext (event , this) ;">
      <xsl:variable name="name" select="name()"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>=&quot;</xsl:text>
      <xsl:call-template name="outp"/>
      <xsl:text>&quot;</xsl:text>
    </span>
  </xsl:template>
  <xsl:template match="text()">
    <span class="xml"
      onClick="setContext (event , this) ;">
      <xsl:call-template name="outp"/>
    </span>
  </xsl:template>
  <xsl:template match="text()[normalize-space()='']">
    <xsl:call-template name="outp"/>
  </xsl:template>
  <xsl:template match="comment()">
    <span class="xml"
      onClick="setContext (event , this) ;">
      <xsl:text>&lt;!--</xsl:text>
      <xsl:call-template name="outp"/>
      <xsl:text>--&gt;</xsl:text>
      <xsl:if test="not(../..)">
      </xsl:if>
    </span>
  </xsl:template>
  <xsl:template name="namespc">
    <xsl:for-each select="namespace::*[name()!='xml']">
      <xsl:if
        test=
        "
          not
          (
            ../../namespace::*
            [
              name()=name(current()) and
              string()=string(current())
            ]
          )
        ">
        <xsl:text> xmlns:</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>=&quot;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&quot;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="outp">
    <xsl:param name="val" select="."/>
    <xsl:variable name="length"
      select="string-length($val)"/>
    <xsl:choose>
      <xsl:when test="$length &gt; 1">
        <xsl:variable name="mid"
          select="floor($length div 2)"/>
        <xsl:variable name="a"
          select="substring($val,1,$mid)"/>
        <xsl:variable name="b"
          select="substring($val,$mid+1)"/>
        <xsl:call-template name="outp">
          <xsl:with-param name="val" select="$a"/>
        </xsl:call-template>
        <xsl:call-template name="outp">
          <xsl:with-param name="val" select="$b"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$length=1">
        <xsl:call-template name="outpch">
          <xsl:with-param name="val" select="$val"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="outpch">
    <xsl:param name="val"/>
    <xsl:choose>
      <xsl:when test="$val='&amp;'">
        <xsl:text>&amp;amp;</xsl:text>
      </xsl:when>
      <xsl:when test="$val='&lt;'">
        <xsl:text>&amp;lt;</xsl:text>
      </xsl:when>
      <xsl:when test="$val='&gt;'">
        <xsl:text>&amp;gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$val='&quot;'">
        <xsl:text>&amp;quot;</xsl:text>
      </xsl:when>
      <xsl:when test='$val="&apos;"'>
        <xsl:text>&amp;apos;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
