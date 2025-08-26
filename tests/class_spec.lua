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

    describe('Boss -> Enemy -> Class', function()
        local Boss = Enemy:subclass('Boss')
        local motto = 'Me kill all !'

        local enemy = Enemy {}

        function Boss:new()
            self.level = self.level or 'high'
            self.boss  = true
            self.motto = motto
        end

        describe('Basic', function()
            local boss = Boss { damage = 300, level = 'low' }

            it('damage passed to the ctor', function()
                assert.is.equal(boss.damage, 300)
            end)
            it('level passed to the ctor', function()
                assert.is.equal(boss.level, 'low')
            end)
            it('enemy field', function()
                assert.is.equal(boss.enemy, true)
            end)
            it('boss field', function()
                assert.is.equal(boss.boss, true)
            end)
            it('Boss.say() is different from Enemy.say()', function()
                assert.is_not.equal(boss:say(), enemy:say())
            end)
        end)

        describe('Default ctor', function()
            local boss = Boss {}

            it('Default ctor', function()
                assert.is.equal(boss.damage, 100)
            end)
            it('Default level', function()
                assert.is.equal(boss.level, 'high')
            end)
            it('enemy field', function()
                assert.is.equal(boss.enemy, true)
            end)
            it('boss field', function()
                assert.is.equal(boss.boss, true)
            end)
            it('Enemy:say()', function()
                assert.is.equal(boss:say(), motto)
            end)
        end)

        describe('Bowser -> Boss -> Enemy -> Class', function()
            local Bowser = Boss:subclass('Bowser')

            describe('Basic', function()
                local bowser = Bowser { damage = 400, level = 'critical' }

                it('damage passed to the ctor', function()
                    assert.is.equal(bowser.damage, 400)
                end)
                it('level passed to the ctor', function()
                    assert.is.equal(bowser.level, 'critical')
                end)
                it('enemy field', function()
                    assert.is.equal(bowser.enemy, true)
                end)
                it('boss field', function()
                    assert.is.equal(bowser.boss, true)
                end)
                it('Bowser:say() is Boss:say()', function()
                    assert.is.equal(bowser:say(), motto)
                end)
            end)
        end)
    end)

    describe('Errors', function()
        describe('Bad subclass', function()
            it('no name', function()
                assert.has.error(function () local _ = Class:subclass() end)
            end)

            it('number as name', function()
                assert.has.error(function () local _ = Class:subclass(42) end)
            end)
        end)

        describe('Bad new call', function()
            local A = Class:subclass('A')

            it('number as argument', function()
                assert.has.error(function () local _ = A(42) end)
            end)
        end)
    end)
end)
