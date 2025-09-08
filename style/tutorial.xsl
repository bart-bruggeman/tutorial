<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:map="http://www.w3.org/2005/xpath-functions/map"
	xmlns:tutorial="http://bruggeman.be/tutorial" 
	exclude-result-prefixes="tutorial">

	<xsl:param name="basedir" as="xs:string"/>	
	
	<xsl:include href="functions.xsl"/>

	<xsl:template match="tutorial">
		
		<xsl:variable name="fileURI" select="concat($basedir, '/', @filename)"/>

		<xsl:result-document href="{$fileURI}" method="html" indent="yes">
			<html xmlns:xs="http://www.w3.org/2001/XMLSchema" data-bs-theme="light">
				<head>
					<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
					<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
					<title>Tutorial - <xsl:value-of select="@name"/></title>
					<!-- Bootstrap core -->
					<link rel="stylesheet" href="assets/css/bootstrap.min.css"/>
					<!-- Bootstrap icons (list of icons @ https://icons.getbootstrap.com/) -->
					<link rel="stylesheet" href="assets/css/bootstrap-icons.min.css"/>
					<!-- Prism -->
					<link id="prism-light" rel="stylesheet" href="assets/css/prism.min.css"/>	
					<link id="prism-nord" rel="stylesheet" href="assets/css/prism-nord.min.css"/>
					<!-- tutorial -->
					<link rel="stylesheet" href="assets/css/tutorial.min.css"/>	
				</head>
				<body>
					<nav class="navbar navbar-expand-lg navbar-light py-2 border-bottom">
						<div class="container">
							<!-- logo -->
							<a class="navbar-brand" href="#"><xsl:value-of select="@name"/></a>
							<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
								<span class="navbar-toggler-icon"></span>
							</button>
							<!-- menu -->
							<div class="collapse navbar-collapse" id="navbarNav">
								<ul class="navbar-nav ms-auto">
									<!-- menu items -->
									<!-- light/dark mode toggle icon -->
									<li class="nav-item d-flex align-items-center">
										<a href="#" class="nav-link p-0" id="themeToggleLink" role="button" style="line-height: 1;">
											<i class="bi bi-toggle-on fs-4" style="vertical-align: middle;"></i>
										</a>
									</li>
								</ul>
							</div>
						</div>
					</nav>
					<!-- page content -->
					<div class="container mt-5" id="{@id}">
						<xsl:apply-templates/>
					</div>
					<!-- footer-->
					<footer class="text-center py-3 mt-5 border-top">
						<div class="container">
							<p class="mb-1 small text-muted"><xsl:value-of select="@name"/></p>
						</div>
					</footer>
					<!-- Bootstrap -->
					<script src="assets/js/bootstrap.bundle.min.js"></script>
					<!-- Prism core -->
					<script src="assets/js/prism.min.js"></script>
					<!-- Prism plugins (list of plugins @ https://cdn.jsdelivr.net/npm/prismjs@1.30.0/plugins/) -->
					<script src="assets/js/prism-normalize-whitespace.min.js"></script>
					<!-- Prism languages (list of languages @  https://cdn.jsdelivr.net/npm/prismjs@1.30.0/components/) -->
					<script src="assets/js/prism-java.min.js"></script>
					<script src="assets/js/prism-kotlin.min.js"></script>
					<script src="assets/js/prism-markup.min.js"></script>
					<!-- tutorial -->
					<script src="assets/js/tutorial.min.js"></script>
				</body>
			</html>
		</xsl:result-document>
		
	</xsl:template>

	<xsl:template match="section">
		<div class="section-card">
			<h2 class="section-title"><xsl:value-of select="@title"/></h2>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tabs">
		<xsl:if test="normalize-space('@info')">
			<p><xsl:value-of select="@info"/></p>
		</xsl:if>
		<ul class="nav nav-tabs" id="{@id}" role="tablist">
			<xsl:for-each select="tab">
				<xsl:variable name="is-active" select="position() = 1"/>
				<li class="nav-item" role="presentation">
					<a class="nav-link{if ($is-active) then ' active' else ''}" id="{@id}-tab" data-bs-toggle="tab" href="#{@id}" role="tab" aria-controls="{@label}" aria-selected="{if ($is-active) then 'true' else 'false'}">
						<xsl:value-of select="@label"/>
					</a>
				</li>
			</xsl:for-each>
    	</ul>
		<div class="tab-content" id="{@id}TabsContent">
			<xsl:for-each select="tab">
				<xsl:variable name="is-active" select="position() = 1"/>
				<div class="tab-pane fade{if ($is-active) then ' show active' else ''}" id="{@id}" role="tabpanel" aria-labelledby="{@label}-tab">
					<xsl:if test="normalize-space('@info')">
						<p><xsl:value-of select="@info"/></p>
					</xsl:if>
					<xsl:apply-templates/>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="codesnippet">
		<xsl:if test="normalize-space('@info')">
			<p><xsl:value-of select="@info"/></p>
		</xsl:if>
		<pre>
			<button class="copy-btn" onclick="copyCode(this)"><i class="bi bi-copy"></i></button>
			<code>
				<xsl:attribute name="class">
					<xsl:value-of select="map:get(tutorial:as_prism_type(), @language)"/>
				</xsl:attribute>
				<xsl:value-of select="."/>
			</code>
		</pre>
	</xsl:template>

	<!-- table -->
	<xsl:template match="table">
		<div class="section-card">
			<h2 class="section-title"><xsl:value-of select="@title"/></h2>
			<table class="table table-bordered">
				<xsl:apply-templates/>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="header">
		<thead>
			<tr>
				<xsl:apply-templates/>
			</tr>
		</thead>
	</xsl:template>

	<xsl:template match="headeritem">
		<th scope="col"><xsl:value-of select="."/></th>
	</xsl:template>

	<xsl:template match="data">
		<tbody>
			<tr>
				<xsl:apply-templates/>
			</tr>
		</tbody>
	</xsl:template>

	<xsl:template match="dataitem">
		<td><xsl:value-of select="."/></td>
	</xsl:template>

	<xsl:template match="dataitemlist">
		<td>
			<ul class="list-unstyled mb-0">
				<xsl:apply-templates/>
			</ul>
		</td>
	</xsl:template>

	<!-- list -->
	<xsl:template match="list">
		<ul class="list-unstyled mb-0">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="listitem">
		<li><xsl:apply-templates/></li>
	</xsl:template>

</xsl:stylesheet>
