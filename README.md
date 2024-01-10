# rbxcat - roblox client access tunnel

using attributes can be a pain.
with the rbxcat game framework, we use that same painful system to run our games off of ^_^

![image](https://github.com/fartg/rbxcat/assets/70608092/8716d690-3fa9-4869-b965-d3d85c7026b8)

want to grab the device type of a user? simply do
```lua
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);
...
EditPlayer.Return(player, nil, "device_type");
```
this also works with the included RemoteFunctions!


want to see the actual, non-exploited, server-replicated value of a player in a localscript? you can do the following!

```lua
local events = game.ReplicatedStorage.Events.Info;

print(events.ReturnPlayerQuery:InvokeServer(nil, "device_type"));
```

anyway, here's the rojo stuff if you want to use this yourself

# rojo

```bash
rojo build -o "framework.rbxlx"
```

Next, open `framework.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```
