# A (yet another, I know ) simple class library for Lua

[![Busted](https://github.com/LRDPRDX/lua-class/actions/workflows/busted.yml/badge.svg)](https://github.com/LRDPRDX/lua-class/actions/workflows/busted.yml)
[![Luacheck](https://github.com/LRDPRDX/lua-class/actions/workflows/luacheck.yml/badge.svg)](https://github.com/LRDPRDX/lua-class/actions/workflows/luacheck.yml)
[![Docs](https://github.com/LRDPRDX/lua-class/actions/workflows/doc.yml/badge.svg)](https://github.com/LRDPRDX/lua-class/actions/workflows/doc.yml)

# Features

 - Inheritance (subclass)
 - Constructor call downwards the hierarchy (from parent to child)
 - Table-oriented constructor (the only parameter of a constructor is a table)
 - RTTI (`isA`, `isSubclassOf`)

# Example

```lua
describe('Tutorial', function()
    local Class = require('class')
    -- Create a new class
    local Drawable = Class:subclass('Drawable')

    -- Constructor. Called every time a new instance is created.
    -- self is the instance itself. No need to return anything from the constructor.
    function Drawable:new()
        self.color  = self.color or { 0, 0, 0 }
        self.weight = self.weight or 1
    end

    -- Static fields. Can be overridden by a child class
    Drawable.nDim = 2
    Drawable.name = 'drawable'

    -- Method. Can be overridden by a child class.
    -- (note: the dot syntax to explicitly express that the self parameter isn't used)
    function Drawable.size(_)
        return nil
    end

    -- Polyline is a Drawable
    local Polyline = Drawable:subclass('Polyline')

    function Polyline:new()
        self.points = self.points or {}
    end

    -- Override static field
    Polyline.name = 'polyline'

    -- Override method
    function Polyline:size()
        if #self.points == 0 then
            return nil
        end

        local minX, minY, maxX, maxY = nil, nil, nil, nil
        for _, p in ipairs(self.points) do
            minX = minX and math.min(p.x, minX) or p.x
            minY = minY and math.min(p.y, minY) or p.y
            maxX = maxX and math.max(p.x, maxX) or p.x
            maxY = maxY and math.max(p.y, maxY) or p.y
        end

        return { x = maxX - minX,
                 y = maxY - minY }
    end

    function Polyline:nPoints()
        return #self.points
    end

    local d = Drawable {
        color = { 1, 1, 1 }
    }

    local p = Polyline {
        weight = 2,
        points = {
            { x = 0, y = 0 },
            { x = 0, y = 1 },
            { x = 1, y = 1 },
            { x = 1, y = 0 },
        }
    }

    it('subclass of', function()
        assert.is.equal(Drawable:isSubclassOf(Class)    , true)
        assert.is.equal(Polyline:isSubclassOf(Class)    , true)
        assert.is.equal(Polyline:isSubclassOf(Drawable) , true)
    end)

    it('instance of', function()
        assert.is.equal(d:isA(Class)    , true)
        assert.is.equal(d:isA(Drawable) , true)
        assert.is.equal(p:isA(Class)    , true)
        assert.is.equal(p:isA(Drawable) , true)
        assert.is.equal(p:isA(Polyline) , true)
    end)

    it('fields', function()
        assert.is.equal(d.name       , Drawable.name )
        assert.is.equal(d.nDim       , Drawable.nDim )
        assert.is.equal(p.super.name , Drawable.name ) -- access the superclass
        assert.is.same(d.color       , { 1, 1, 1 } )
        assert.is.equal(d.weight     , 1 )

        assert.is.equal(p.name   , Polyline.name )
        assert.is.equal(p.nDim   , Drawable.nDim )
        assert.is.same(p.color   , { 0, 0, 0 } )
        assert.is.equal(p.weight , 2 )
    end)

    it('methods', function()
        assert.is.equal(d:size()    , nil)
        assert.is.same(p:size()     , { x = 1, y = 1 })
        assert.is.equal(p:nPoints() , 4)
    end)
end)
```

# Documentation
See [here](https://lrdprdx.github.io/lua-class/) for documentation.
