# A (yet another, I know ) simple class library for Lua

# Features

 - Inheritance (subclass)
 - Constructor call downwards the hierarchy (from parent to child)
 - Table-oriented constructor (the only parameter of a constructor is a table)
 - RTTI (super)

# Example

```lua
describe('Class', function()
    local Class = require('class')

    local Enemy = Class:subclass('Enemy')
    local defaults = {
        damage = 100,
        motto = 'Me kill hoomans !',
    }

    -- Constructor
    function Enemy:new()
        self.damage = self.damage or defaults.damage
        self.motto  = self.motto or defaults.motto
        self.enemy  = true
    end

    -- Static function
    function Enemy.static()
        return 'Enemy'
    end

    -- Method
    function Enemy:say()
        return self.motto
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
                assert.is.equal(enemy:say(), defaults.motto)
            end)
            it('enemy is an instance of Class', function()
                assert.is.equal(enemy:isA(Class), true)
            end)
            it('Enemy.static', function()
                assert.is.equal(enemy.static(), 'Enemy')
            end)
            it('Enemy is a subclass of Class', function()
                assert.is.equal(Enemy:isSubclassOf(Class), true)
            end)
        end)

        describe('Default ctor', function()
            local enemy = Enemy {}
            it('default damage', function()
                assert.is.equal(enemy.damage, defaults.damage)
            end)
            it('enemy field', function()
                assert.is.equal(enemy.enemy, true)
            end)
        end)
    end)

    describe('Koopa -> Enemy -> Class', function()
        local Koopa = Enemy:subclass('Koopa')
        local boo = 'Boo!'

        -- Override method
        -- (dot syntax because the self argument is not used)
        function Koopa.say(_)
            return boo
        end

        -- Override static
        function Koopa.static()
            return 'Koopa'
        end

        local koopa = Koopa { damage = 300 }
        it('damage passed to the ctor', function()
            assert.is.equal(koopa.damage, 300)
        end)
        it('enemy field', function()
            assert.is.equal(koopa.enemy, true)
        end)
        it('Koopa:say()', function()
            assert.is.equal(koopa:say(), boo)
        end)
        it('Koopa.static', function()
            assert.is.equal(koopa.static(), 'Koopa')
        end)
        it('super.static (access via class)', function()
            assert.is.equal(Koopa.super.static(), Enemy.static())
        end)
        it('super.static (access via instance)', function()
            assert.is.equal(koopa.super.static(), Enemy.static())
        end)
    end)
end)
```
