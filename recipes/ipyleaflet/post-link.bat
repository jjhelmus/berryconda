@echo off

(
  "%PREFIX%\Scripts\jupyter-nbextension.exe" enable ipyleaflet --py --sys-prefix
) >>"%PREFIX%\.messages.txt" 2>&1
