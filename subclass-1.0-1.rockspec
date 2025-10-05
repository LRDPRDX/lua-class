local package_name      = 'subclass'
local package_version   = '1.0'
local rockspec_revision = '1'

rockspec_format = '3.0'

package = package_name
version = package_version .. '-' .. rockspec_revision

source = {
   url = "git+https://github.com/LRDPRDX/lua-class.git",
   tag = 'v' .. package_version,
}

description = {
   summary  = "A (yet another) simple class for Lua",
   detailed = [[
    A simple class functionality for Lua:
        * Constructors (default: with no args)
        * Declarative construction
        * Inheritance (single)
        * isA & isInstanceOf
   ]],
   homepage = 'https://lrdprdx.github.io/lua-class',
   license  = 'MIT <http://opensource.org/licenses/MIT>',
}

dependencies = {
   "lua >= 5.1",
}

build = {
   type = 'builtin',
   modules = {
      subclass = 'subclass.lua',
   }
}

test = {
    type = 'busted',
    platforms = {
        unix = {
            flags = { 'tests/' },
        }
    }
}
