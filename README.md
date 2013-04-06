reloadfx
========

Vim script to reload Firefox web browser.


Install
=======

Put this file into $HOME/.vim/plugin directory. Add the following settings into .vimrc file as necessary.

````vim
let g:reload_fx_host = 'YOUR_HOST_NAME' (default: localhost)
let g:reload_fx_port = YOUR_PORT_NUMBER (default: 4242)
let g:reload_fx_script_language_type = 'SCRIPT_LANGUAGE_NAME' (defalult: ruby)
````

Usage
=======
````vim
:Reloadfx
````
