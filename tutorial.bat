@echo off
cls
setlocal enabledelayedexpansion

:: check if a specific file parameter is given
if "%~1"=="" (
    :: no parameter, process all XML files
    set "XML_FILES=data\*.xml"
) else (
    :: parameter given, process only that file in data directory
    if exist "data\%~1.xml" (
        set "XML_FILES=data\%~1.xml"
    ) else (
        echo File data\%~1.xml not found!
        exit /b 1
    )
)

:: versions
set "SAXON_HE_VERSION=12.9"
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

:: validate and process XML files
for %%F in (%XML_FILES%) do (
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
