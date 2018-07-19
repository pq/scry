# scry

a lightweight lua language server for [norns](https://github.com/monome/norns).

### advises

scry flags syntax errors, identifies common control and data flow issues,  highlights implicitly defined globals, overwritten or mutated protected norns global state, unused or shadowed variables and more.  behind the scenes scry uses [lua_check](https://github.com/mpeterv/luacheck) for linting and analysis and provides all of it’s supported [warnings](https://luacheck.readthedocs.io/en/stable/index.html).

### mends

scry builds on the [lua_code_formatter](https://github.com/martin-eden/lua_code_formatter) to provide simple on-demand code formatting for selections or entire documents.

### sees

*(planned)* scry provides access to lua and sc docs.

---

	
## motivation and background

maiden uses a customized [ace editor](https://ace.c9.io/) mode to provide an editing experience tailored to lua for norns.  out of the box, ace provides basic client-side syntax highlighting and a web-worker-based syntax checker. 

the design of ace only allows for limited customization.  notably, the syntax checker is not easily enhanced or replaced. work on the client-side has fundamental limitations as well.  doing semantic analysis in the browser (to provide, for example, awareness of norns functions or offer lua linting), is not practical.  nor is rich code transformation (such as formatting or refactoring).  scry works around these shortcomings by migrating analysis to a lightweight server process.

## features

beyond the basic ace editor lua support, scry adds:

* lua 5.3 syntax awareness
* lua and norns-specific semantic analysis
* a host of analyses and lints
* inline source markers
* on-demand formatting

planned improvements include:

* improved norns-aware code analyses
* improved error / lint messages

more ambitiously, another mode ("see") for

* serving documentation


## running scry

running scry involves setting up two parts. 

**scry server.** a process that manages a web socket that serves requests to “advise” and “mend” to maiden.

**scry maiden.** a version of maiden, tailored to listen to advice from a scry server.

trying out scry involves running a local scry server and local maiden dev server instance.  maiden will point to matron and sc repls on your norns device so you can edit and run your scripts in dust.

### scry server

**get the source.** clone or download the [scry repo](https://github.com/pq/scry).

**setup.** first you’ll need to get some lua libraries installed to do the heavy-lifting:`luacheck` (for static analysis) and `lcf` (for formatting).

**run.**

0. make sure you have lua installed locally (e.g., on mac os,  `brew update; brew install lua`) 
1. the default installation also provides `luarocks`, a lua package manager.  use it to install our library dependencies: `luarocks install luacheck; luarocks install lcf`

scry needs a server process to manage the web-socket connection w/ maiden.  included is a simple server using `node`.  (to be replaced.)

0. make sure node is installed (on mac os, `brew install node`)
1. use the node package manager to add a simple web socket library: `npm install --save ws`

finally, start scry:

`node server.js`

(you’ll want to keep this open in a dedicated terminal window or tab — aside, if you’re on mac os, consider the excellent free terminal replacement  [iTerm2](https://www.iterm2.com/index.html).)


### scry maiden

**get the source.** check out the >>> <<< branch for a  a version of maiden that integrates w scry. follow the general maiden setup instructions to install deps, etc. >>><<<.

**run.**

0. be sure wifi is enabled on `norns` (system > wifi menu)
1. note the ip address (visible in the wifi menu once connected); alternatively if `norns.local` resolves for you (`ping norns.local`), prefer that.
2. update `app/public/repl-endpoints.json`  replacing `maiden_app_location`to point at your norns ip address (here on we’ll use `norns.local`)
3. mount your `norns` locally (on mac os, `sshfs we@norns.local: ~/norns-mnt`)
4. (in a terminal window) start the backend: `go build && ./maiden -app app/build/ -data ~/norns-mnt/dust -doc ~/norns-mnt/norns/doc -debug`
5. (in another terminal) start the dev server:  `cd app; yarn start`
6. point your web browser at the dev server: `http://localhost:3000/`


## implementation

scry runs as a small lightweight server process.  maiden connects to scry via a web socket.  

* on source changes, editor contents are sent to scry for analysis; advice comes back as a list of “issues” that are translated into editor gutter annotations and inline source markers.
	
<TODO: PICTURE>

 > syntax errors appear in red and warnings in yellow. blue markers flag norns callback implementations for easy identification.

* on demand, editor selections (or full contents) are sent to scry for mending with a keystroke (⌘-SHIFT-F); a tidy, well formatted result replaces unruly editor contents.
	 
the smarts of scry are written in lua and leverage proven modules.  scry is  tiny, scalable and simple to extend.

## next steps

- [ ] migrate to a more native server wrapper (using `ws-wrapper` or lua web sockets).
- [ ] evaluate norns lua dependency installation options.
