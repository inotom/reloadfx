" reloadfx.vim
"
" file created in 2006/10/05 08:22:45.
" LastUpdated :2013/04/06 22:14:59.
" Author: iNo
" Version: 1.0
" License: MIT license
"
" Description: Reload Firefox when file (*.html, *.htm, *.php, *.js, *.css) is saved.
" This script requires MozLab (http://dev.hyperstruct.net/trac/mozlab) extension.
"
" Installation: Put this file into $HOME/.vim/plugin directory. Add the following settings into .vimrc file as necessary.
" let g:reload_fx_host = 'YOUR_HOST_NAME' (default: localhost)
" let g:reload_fx_port = YOUR_PORT_NUMBER (default: 4242)
" let g:reload_fx_script_language_type = 'SCRIPT_LANGUAGE_NAME' (defalult: ruby)
"
" Usage:
" :Reloadfx
"

if exists('g:reload_fx_cmd')
  finish
endif

if !exists('g:reload_fx_host')
  let g:reload_fx_host = 'localhost'
endif

if !exists('g:reload_fx_port')
  let g:reload_fx_port = 4242
endif

if !exists('g:reload_fx_script_language_type')
  let g:reload_fx_script_language_type = 'ruby'
endif

command -nargs=0 Reloadfx :call s:ToggleAutoCmdReloadFx()

function! s:TelnetByPerl()
  :perl <<EOF
    use strict;
    use warnings;
    use Net::Telnet;

    my $host = VIM::Eval('g:reload_fx_host');
    my $port = VIM::Eval('g:reload_fx_port');
    my $prompt = '/[repl>]/';

    my $telnet = new Net::Telnet(
      Host => $host,
      Port => $port,
      Timeout => 10,
      Prompt => $prompt,
    );

    $telnet->open($host);
    $telnet->cmd("content.location.reload(true)\n");
    $telnet->cmd("repl.quit()\n");
    $telnet->close;
EOF
endfunction

function! s:TelnetByPython()
  :python <<EOF
    import telnetlib
    telnet = telnetlib.Telnet(vim.eval('g:reload_fx_host'), vim.eval('g:reload_fx_port'))
    telnet.read_until("repl>")
    telnet.write("content.location.reload(true)\n")
    telnet.write("repl.quit()\n")
    telnet.close()
EOF
endfunction

function! s:TelnetByRuby()
  :ruby <<EOF
  require "net/telnet"

  telnet = Net::Telnet.new({
    "Host" => VIM::evaluate('g:reload_fx_host'),
    "Port" => VIM::evaluate('g:reload_fx_port')
  })

  telnet.puts("content.location.reload(true)\n")
  telnet.puts("repl.quit()\n")
  telnet.close
EOF
endfunction

function! ReloadFirefox()
  if g:reload_fx_script_language_type ==? 'ruby' && has('ruby')
    :call s:TelnetByRuby()
  elseif g:reload_fx_script_language_type ==? 'perl' && has('perl')
    :call s:TelnetByPerl()
  elseif g:reload_fx_script_language_type ==? 'python' && has('python')
    :call s:TelnetByPython()
  endif
endfunction

function! s:ToggleAutoCmdReloadFx()
  if exists('g:reload_fx_cmd')
    autocmd! reloadfx
    unlet g:reload_fx_cmd
    echo "STOP \"reloadfx\"."
  else
    augroup reloadfx
      autocmd BufWritePost *.html,*.htm,*.php,*.js,*.css call ReloadFirefox()
    augroup END
    let g:reload_fx_cmd=1
    echo "START \"reloadfx\"."
  endif
endfunction

" vim:fdl=0 fdm=marker:ts=2 sw=2 sts=0:
