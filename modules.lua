local Modules = Modules or {}

Modules.Vec = Modules.Vec or require "modules.vec"

if Modules.Collider == nil or Modules.Colliders == nil then
    local aux = require "modules.collider"
    Modules.Collider = aux.Collider
    Modules.Colliders = aux.Colliders
end

return Modules
