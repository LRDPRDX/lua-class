local Class = {}

function Class:subclass (name)
    assert(type(name) == 'string',
           ('bad argument #1 to subclass (string expected, got %s)'):format(type(name)))
    local mt = {
        __call = function (class, instance)
            instance = instance or {}
            assert(type(instance) == 'table',
                   ('bad constructor argument (table expected, got %s)'):format(type(instance)))
            instance = setmetatable(instance or {}, class)

            local constructors = {}
            local current      = class
            local index        = 0

            -- Collect all constructors in the hierarchy
            while current do
                if current.new and not constructors[current.new] then
                    index                     = index + 1
                    constructors[current.new] = index
                    constructors[index]       = current.new
                end
                current = current.super
            end

            -- Call constructors in the reverse order (downwards in the hierarchy)
            for i = #constructors, 1, -1 do
                constructors[i](instance)
            end

            return instance
        end,
        __index = self, -- parent class
        __name = name,
    }

    local class   = {}
    class.__index = class
    class.super   = self

    return setmetatable(class, mt)
end

function Class:isSubclassOf (class)
    if self == class then
        return true
    end

    if self.super then
        return self.super:isSubclassOf(class)
    end

    return false
end

function Class:isA (class)
    local mt = getmetatable(self)
    return mt:isSubclassOf(class)
end

return Class
