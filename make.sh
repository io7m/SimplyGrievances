#!/bin/sh -ex

rm -rf out
mkdir -p out

rm -rf epub
mkdir -p epub

cp bookCover.jpg out/
cp ui_thread.png out/
cp document.css out/
cp document-epub.css out/
cp opds.xml out/feed.xml

saxon-xslt -s:main.xml -xsl:issues.xslt > issues.xml
saxon-xslt -s:main.xml -xsl:caches.xslt > caches.xml

java -jar com.io7m.xstructural.cmdline-1.3.0-SNAPSHOT-main.jar \
xhtml \
--outputDirectory out \
--sourceFile main.xml

java -jar com.io7m.xstructural.cmdline-1.3.0-SNAPSHOT-main.jar \
xhtml \
--outputDirectory out \
--stylesheet MULTIPLE_FILE \
--sourceFile main.xml

java -jar com.io7m.xstructural.cmdline-1.3.0-SNAPSHOT-main.jar \
epub \
--outputDirectory epub \
--sourceFile main.xml

cp epub/output.epub out/simplyGrievances.epub

rm out/trace.xml
rm out/messages.log

