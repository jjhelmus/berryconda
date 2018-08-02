@echo off

(
  "%PREFIX%\Scripts\jupyter-nbextension.exe" uninstall ipyleaflet --py --sys-prefix
) >>"%PREFIX%\.messages.txt" 2>&1
