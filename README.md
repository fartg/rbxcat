
![rhdbardhbard](https://github.com/fartg/rbxcat/assets/70608092/fa5aeffd-5673-46ca-b6a9-f9d67f19add7)
<p align="center">
<h1 align="center">rbxcat - roblox client access tunnel</h1>

<h2 align="center"> Now compatible with rbxcat-server! </h2>

See our Analytics and OpenCloudMessaging modules and want to take advantage? Now you can!

Head to [rbxcat-server](https://github.com/lostmedia/rbxcat-server) and follow the installation instructions.

(Make sure to change your Secrets.lua to include your webserver and rbx_ocm_apikey!)

Enjoy connecting to and from ROBLOX game servers with the power of rbxcat and rbxcat-server!

<h1 align="center">introduction</h1>
Using attributes can be a pain.
With the rbxcat game framework, we use that same painful system to run our games off of! ^_^

![image](https://github.com/fartg/rbxcat/assets/70608092/8716d690-3fa9-4869-b965-d3d85c7026b8)
![RobloxStudioBeta_76arq8IcoV](https://github.com/fartg/rbxcat/assets/70608092/7baba323-7810-4381-9247-0e54768001bf)

Want to grab the device type of a user? Simply do:
```lua
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);
...
EditPlayer.Return(player, nil, "device_type");
```


This also works with the included remote functions.
Want to see the actual, non-exploited, server-replicated value of a player in a local script? You can do the following:

```lua
local events = game.ReplicatedStorage.Events.Info;

print(events.ReturnPlayerQuery:InvokeServer(nil, "device_type"));
```
What if you wanted to change a players money from 1000 to 0?
```lua
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);
...
EditPlayer.Inventory(player, "money", 0);
```

<h1 align="center"> included modules </h1>
The current included modules inside of rbxcat as as follows:

```bash
|   Config.lua [note: change things in here]
|
\---Modules
    |   Variables.lua
    |
    +---Functions
    |       Datastore.lua [note: set up yourself if you'd like to have more subfolders]
    |       EditPlayer.lua
    |       EditServer.lua
    |       OpenCloudMessaging.lua [note: Set up at your own risk!]
    |       PlayerFunctions.lua
    |       Variables.lua
    |
    +---Info
    |       Admin.lua [note: make sure to change to your teams' UserIds]
    |       Badges.lua [note: make sure to add your own badgeIds]
    |       BaseVariables.lua
    |       Purchases.lua [note: make sure to change to your purchaseIds]
    |       Rewards.lua [note: make sure to add your own rewards]
    |
    \---Misc
            Analytics.lua [note: this will be made way more useful when rbxcat-server gets published]
            AnalyticsSettings.lua
            Promise.lua [note: thank you to the lovely @evaera!]
            Secrets.lua [note: make your own]
```


<h1 align="center"> examples </h1>

![image](https://github.com/fartg/rbxcat/assets/70608092/52a13679-e2fb-4ece-84d2-2c55a5173416)
rbxcat-obby: A simple obby game made off of the rbxcat framework.

Playable at: https://www.roblox.com/games/15950136702/rbxcat-obby

Source visible at: https://github.com/fartg/rbxcat-obby


<h1 align="center"> installation </h1>

You can download the .rbxm from our release page, or from roblox directly.

https://create.roblox.com/marketplace/asset/15938514509/rbxcat%3Fkeyword=&pageNumber=&pagePosition=

You can also scroll down to the bottom of the page to start your own project with the power of Rojo.

<h1 align="center"> tutorial </h1>
Let's do something simple, like adding $1 to every player's money every second.

First off, we're going to want every player to have money, right? Let's go ahead and edit our base variables to have a "money" variable.

Inside of `game.ServerStorage.rbxcat.Modules.Info.BaseVariables`, let's edit the following lines. 

![image](https://github.com/fartg/rbxcat/assets/70608092/04429a61-db98-4e36-bdac-7e393365c77e)

```lua
...
bv.Inventory = {

}
...
```

Let's change this into:
```lua
bv.Inventory = {
	money = 0,
}
```

Perfect. Now all players will have an attribute named money with the starting value of 0.


Now let's get our money functions set up somewhere safe so our server scripts can access them.
Inside of `game.ServerStorage.rbxcat.Modules.Handlers` you'd create a new module script entitled "Money".
(Inside of this is where we'll handle spending and receiving money.)

![image](https://github.com/fartg/rbxcat/assets/70608092/0dbd034c-1bef-4a4f-aa6c-a3bfb7c024a4)  


You're going to want EditPlayer, so let's go ahead and require that first and build ourselves a skeleton for what we want.

```lua
--money.lua
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);
local money = {};

money.Give = function (player, amount)

end;

money.Spend = function (player, amount)

end;

return money;
```

Perfect. Now that we have two functions set up for giving and spending money, let's flesh them out.

```lua
money.Give = function (player, amount)
	local player_money = EditPlayer.Return(player, "Inventory", "money");
	EditPlayer.Inventory(player, "money", player_money + amount);
end;

money.Spend = function (player, amount)
	local player_money = EditPlayer.Return(player, "Inventory", "money");
	
	if player_money < amount then
		print("too little :(");
		return
	end
	
	EditPlayer.Inventory(player, "money", player_money - amount);
end;
```

Inside of `game.ReplicatedStorage.Events`, let's make a new folder called Money and a RemoteEvent called "Spend".

![image](https://github.com/fartg/rbxcat/assets/70608092/ebc4de3e-90a4-4687-a5a4-7c05539ac0a3)

This will allow a client to contact our server and say let's spend some money.

Let's add a new controller to handle this remote event.
In `game.ServerScriptService.rbxcat.Controllers`, make a new server script called "Money".

![image](https://github.com/fartg/rbxcat/assets/70608092/09c9b769-ddd9-4ee2-87fb-16fd9856d2ff)

Now we can populate it with how we want our Spend event to work.

First, you want to define what Events the controller will deal with and then require your newly-made money handler so we can access the functions.
```lua
local Events = game.ReplicatedStorage.Events.Money;
local MoneyHandler = require(game.ServerStorage.rbxcat.Modules.Handlers.Money);

Events.Spend.OnServerEvent:Connect(function(player, amount)

end)
```
Let's put them together.
```lua
Events.Spend.OnServerEvent:Connect(function(player, amount)
		MoneyHandler.Spend(player, amount);
end)
```
We've covered how to communicate from client to server, how to give players money and how to make them spend it, but how do we get money into the player's pockets?

Let's do that now.

Starting from `game.ServerScriptService`, let's make a new script called MoneyPerSecond.

![image](https://github.com/fartg/rbxcat/assets/70608092/82422996-58df-4f57-97cc-82fdcd5f8450)

With this script, we'll be giving players $1 every second until they leave.

Let's start off with requiring our money handler and EditPlayer so that we can check if the player exists yet.
```lua
local MoneyHandler = require(game.ServerStorage.rbxcat.Modules.Handlers.Money);
local EditPlayer = require(game.ServerStorage.rbxcat.Modules.Functions.EditPlayer);

game.Players.PlayerAdded:Connect(function(player)

end)
```

Now that we have an event listener on player joining, we want to give them money. We can do that in a simple while (...) loop wrapped in a coroutine.

```lua
game.Players.PlayerAdded:Connect(function(player)
		-- We're going to want to wait until the attribute exists since roblox doesn't suport promises
		repeat task.wait() until EditPlayer.Return(player, "Inventory", "money") ~= nil
		
		--Creating our coroutine!
		local coro = coroutine.create(function()
				-- While our player is still in the server...
				while game.ServerStorage.Players:FindFirstChild(player.UserId) ~= nil do
					MoneyHandler.Give(player, 1);
					task.wait(1);
				end
		end)

		local success, result = coroutine.resume(coro);
end)
```
Now if you click play and followed every step correctly, this should be the outcome!
![RobloxStudioBeta_AUuwDB2xwT](https://github.com/fartg/rbxcat/assets/70608092/fdfd3d15-e840-4b5e-9553-4f9dfe7fc81f)

<h1 align="center"> rojo </h1>

```bash
rojo build -o "framework.rbxlx"
```

Next, open `framework.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```

<h1 align="center"> Special Thanks </h1>
A special thank you to:

1. [@oh](https://github.com/oh) (moral support, code-auditing and being an all around swell guy)

2. [Leah](https://www.roblox.com/users/129180189/profile) (moral support, co-developing and hosting everything!)

4. [@evaera](https://github.com/evaera) (for making the wonderful roblox Promise implementation!)

6. You! for making all of this possible :)

