#!/bin/sh

rm -rf out
mkdir -p out

rm -rf epub
mkdir -p epub

cp bookCover.jpg out/
cp ui_thread.png out/
cp document.css out/
cp document-epub.css out/

java -jar com.io7m.xstructural.cmdline-1.3.0-SNAPSHOT-main.jar \
xhtml \
--outputDirectory out \
--sourceFile main.xml

java -jar com.io7m.xstructural.cmdline-1.3.0-SNAPSHOT-main.jar \
epub \
--outputDirectory epub \
--sourceFile main.xml