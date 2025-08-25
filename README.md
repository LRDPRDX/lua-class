# A (yet another, I know ) simple class library for Lua

# Features

 - Inheritance (subclass)
 - Constructor call downwards the hierarchy (from parent to child)
 - Table-oriented constructor (the only parameter of a constructor is a table)
 - RTTI (super)

# Example

```lua
local Class = require('class')

local Enemy = Class:subclass('Enemy')
Enemy.defaults = {
    damage = 100,
    motto = 'Me kill hoomans !',
}

function Enemy:new()
    self.damage = self.damage or Enemy.defaults.damage
    self.enemy = true
end

function Enemy:say()
    return Enemy.defaults.motto
end

describe('Enemy -> Class', function()
    describe('Basic', function()
        local enemy = Enemy { damage = 200 }
        it('damage passed to the ctor', function()
            assert.is.equal(enemy.damage, 200)
        end)
        it('enemy field', function()
            assert.is.equal(enemy.enemy, true)
        end)
        it('Enemy:say()', function()
            assert.is.equal(enemy:say(), Enemy.defaults.motto)
        end)
        it('enemy is Class', function()
            assert.is.equal(enemy:isA(Class), true)
        end)
        it('Enemy is a subclass of Class', function()
            assert.is.equal(Enemy:isSubclassOf(Class), true)
        end)
    end)

    describe('Default ctor', function()
        local enemy = Enemy {}
        it('default damage', function()
            assert.is.equal(enemy.damage, Enemy.defaults.damage)
        end)
        it('enemy field', function()
            assert.is.equal(enemy.enemy, true)
        end)
    end)
end)

describe('Koopa -> Enemy -> Class', function()
    local Koopa = Enemy:subclass('Koopa')
    local motto = 'Boo!'

    -- Override method
    function Koopa:say()
        return motto
    end

    local koopa = Koopa { damage = 300 }
    it('damage passed to the ctor', function()
        assert.is.equal(koopa.damage, 300)
    end)
    it('enemy field', function()
        assert.is.equal(koopa.enemy, true)
    end)
    it('Koopa:say()', function()
        assert.is.equal(koopa:say(), motto)
    end)
    it('super:say (access via class)', function()
        assert.is.equal(Koopa.super:say(), Enemy.defaults.motto)
    end)
    it('super:say (access via instance)', function()
        assert.is.equal(koopa.super:say(), Enemy.defaults.motto)
    end)
end)
```
