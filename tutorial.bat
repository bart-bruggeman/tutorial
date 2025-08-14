@echo off
cls
setlocal enabledelayedexpansion

:: versions
set "SAXON_HE_VERSION=12.8"
set "XML_RESOLVER_VERSION=5.3.3"
set "XMLVALIDATOR_VERSION=1.0-SNAPSHOT"
set "YUI_COMPRESSOR_VERSION=2.4.8"
set "HTML_COMPRESSOR_VERSION=1.5.2"

:: directories
set "SAXON_HE_HOME=library\saxon-he-%SAXON_HE_VERSION%"
set "XMLVALIDATOR_HOME=library\xmlvalidator-%XMLVALIDATOR_VERSION%"
set "YUI_COMPRESSOR_HOME=library\yuicompressor-%YUI_COMPRESSOR_VERSION%"
set "HTML_COMPRESSOR_HOME=library\htmlcompressor-%HTML_COMPRESSOR_VERSION%"
set "OUT_DIR=_generated"

:: jars
set "SAXON_HE_JAR=%SAXON_HE_HOME%\saxon-he-%SAXON_HE_VERSION%.jar"
set "XML_RESOLVER_JAR=%SAXON_HE_HOME%\xmlresolver-%XML_RESOLVER_VERSION%.jar"
set "YUI_COMPRESSOR_JAR=%YUI_COMPRESSOR_HOME%\yuicompressor-%YUI_COMPRESSOR_VERSION%.jar"
set "HTML_COMPRESSOR_JAR=%HTML_COMPRESSOR_HOME%\htmlcompressor-%HTML_COMPRESSOR_VERSION%.jar"

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

:: validate and process all XML files
for %%F in (data\*.xml) do (
    echo Processing %%F...
    :: validate XML tutorial
REM    java -cp "%XMLVALIDATOR_HOME%" be.bruggeman.cv.XmlValidator data/schema/tutorial.xsd "%%F"
    if errorlevel 1 exit /b %errorlevel%
    :: generate HTML tutorial
    java -cp "%SAXON_HE_JAR%;%XML_RESOLVER_JAR%" net.sf.saxon.Transform -s:"%%F" -xsl:style/tutorial.xsl basedir=%OUT_DIR%
    :: minify
    REM java -jar "%HTML_COMPRESSOR_JAR%" "%OUT_DIR%\cv.html" -o "%OUT_DIR%\cv.min.html"
    REM del "%OUT_DIR%\cv.html" /Q
    REM ren "%OUT_DIR_HTML%\cv.min.html" cv.html
)

:: copy assets
xcopy /E /I /Y "assets" %OUT_DIR%\assets >nul
:: minify
java -jar "%YUI_COMPRESSOR_JAR%" "%OUT_DIR%\assets\css\tutorial.css" -o "%OUT_DIR%\assets\css\tutorial.min.css"
java -jar "%YUI_COMPRESSOR_JAR%" "%OUT_DIR%\assets\js\tutorial.js" -o "%OUT_DIR%\assets\js\tutorial.min.js"
:: remove unminified files
del "%OUT_DIR%\assets\css\tutorial.css" /Q
del "%OUT_DIR%\assets\js\tutorial.js" /Q

endlocal
exit /b
