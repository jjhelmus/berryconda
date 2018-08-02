{
  "${PREFIX}/bin/jupyter-nbextension" uninstall ipyleaflet --py --sys-prefix
} >>"${PREFIX}/.messages.txt" 2>&1
