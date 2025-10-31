@echo off
cls
setlocal enabledelayedexpansion

:: versions
set "SAXON_HE_VERSION=12.8"
set "XML_RESOLVER_VERSION=5.3.3"
set "XMLVALIDATOR_VERSION=1.0-SNAPSHOT"

:: directories
set "SAXON_HE_HOME=library\saxon-he-%SAXON_HE_VERSION%"
set "XMLVALIDATOR_HOME=library\xmlvalidator-%XMLVALIDATOR_VERSION%"
set "OUT_DIR=_generated"

:: jars
set "SAXON_HE_JAR=%SAXON_HE_HOME%\saxon-he-%SAXON_HE_VERSION%.jar"
set "XML_RESOLVER_JAR=%SAXON_HE_HOME%\xmlresolver-%XML_RESOLVER_VERSION%.jar"

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

:: validate and process all XML files
for %%F in (data\*.xml) do (
    echo Processing %%F...
    :: validate XML tutorial
    java -cp "%XMLVALIDATOR_HOME%" be.bruggeman.cv.XmlValidator data/schema/tutorial.xsd "%%F"
    if errorlevel 1 exit /b %errorlevel%
    :: generate HTML tutorial
    java -cp "%SAXON_HE_JAR%;%XML_RESOLVER_JAR%" net.sf.saxon.Transform -s:"%%F" -xsl:style/tutorial.xsl basedir=%OUT_DIR%
)

:: copy assets
xcopy /E /I /Y "assets" %OUT_DIR%\assets >nul

endlocal
exit /b
