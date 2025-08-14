<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:map="http://www.w3.org/2005/xpath-functions/map"
	xmlns:tutorial="http://bruggeman.be/tutorial"
	exclude-result-prefixes="tutorial">

	<xsl:function name="tutorial:as_prism_type" as="map(xs:string, xs:string)">
		<xsl:sequence select="map {
			'java'  : 'language-java',
			'kotlin': 'language-kotlin',
			'xml'   : 'language-markup'
		}"/>
	</xsl:function>

</xsl:stylesheet>