local function a()return type(package)=="table"and type(package.config)=="string"and package.config:sub(1,1)=="\\"end;local b=not a()if a()then b=os.getenv("ANSICON")end;local c={reset=0,bright=1,dim=2,underline=4,blink=5,reverse=7,hidden=8,black=30,red=31,green=32,yellow=33,blue=34,magenta=35,cyan=36,white=37,blackbg=40,redbg=41,greenbg=42,yellowbg=43,bluebg=44,magentabg=45,cyanbg=46,whitebg=47}local d=string.char(27).."[%dm"local function e(f)return d:format(f)end;local function g(h)if not b then return""end;local i={}local f;for j in h:gmatch("%w+")do f=c[j]assert(f,"Unknown key: "..j)table.insert(i,e(f))end;return table.concat(i)end;local function k(h)h=string.gsub(h,"(%%{(.-)})",function(l,h)return g(h)end)return h end;local function m(h)h=tostring(h or"")return k("%{reset}"..h.."%{reset}")end;return setmetatable({noReset=k},{__call=function(l,h)return m(h)end})
