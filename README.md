# scry

a lightweight lua language server for norns.

### advises

scry flags syntax errors, identifies common control and data flow issues,  highlights implicitly defined globals, overwritten or mutated protected norns global state, unused or shadowed variables and more.  behind the scenes scry uses [lua_check](https://github.com/mpeterv/luacheck) for linting and analysis and provides all of it’s supported [warnings](https://luacheck.readthedocs.io/en/stable/index.html).

### mends

scry builds on the [lua_code_formatter](https://github.com/martin-eden/lua_code_formatter) to provide simple on-demand code formatting for selections or entire documents.

---

## implementation

scry runs as a small lightweight server process.  maiden connects to scry via a web socket.  

* on source changes, editor contents are sent to scry for analysis; advice comes back as a list of “issues” that are translated into editor gutter annotations and inline source markers.
	
<TODO: PICTURE>

 > syntax errors appear in red and warnings in yellow. blue markers flag norns callback implementations for easy identification.

* on demand, editor selections (or full contents) are sent to scry for mending with a keystroke (⌘-SHIFT-F); a tidy, well formatted result replaces unruly editor contents.
	 
the smarts of scry are written in lua and leverage proven modules.  scry is  tiny, scalable and simple to extend.

	
## motivation and background
maiden uses a customized [ace editor](https://ace.c9.io/) mode to provide an editing experience tailored to lua for norns.  out of the box, ace provides basic client-side syntax highlighting and a web-worker-based syntax checker. 

the design of ace only allows for limited customization.  notably, the syntax checker is not easily enhanced or replaced. work on the client-side has fundamental limitations as well.  doing semantic analysis in the browser (to provide, for example, awareness of norns functions or offer lua linting), is not practical.  nor is rich code transformation (such as formatting or refactoring).  scry works around these shortcomings by migrating analysis to a lightweight server process.

beyond the basic ace editor lua support, scry adds:

* lua 5.3 syntax awareness
* lua and norns-specific semantic analysis
* a host of analyses and lints
* inline source markers
* on-demand formatting

## installation

TODO

## next steps

- [ ] migrate to a more native server wrapper (using `ws-wrapper` or lua web sockets).
- [ ] evaluate norns lua dependency installation options.
