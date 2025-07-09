if not lib then error("ox_lib is not loaded. Please ensure ox_lib is started before this resource.") end

Shared = {
    PlayerDigs = {},
}

require "modules.utils.shared"
require "modules.bridge.server"
require "server.callbacks"
require "server.items"

math.randomseed(os.time())
RegisterItems()
