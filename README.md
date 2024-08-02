<p align="center">
<p align="center">
	<img src="images/logo.svg" alt="Logo" width=20% height=20%>
</p>
<h1 align="center"> <b>Watchdog</b> </h1>
<p align = "center">Simple Observer pattern for Roblox.</p>
</p>

**Watchdog** is a simple, barebones Observer pattern that centers around the [Signal](https://sleitnick.github.io/RbxUtil/api/Signal/) pattern.

---

## 📦 Installation

You can install Watchdog on [Wally](https://wally.run/package/tracyspells/watchdog).

Alternatively, you can check out the latest [GitHub Release](https://github.com/tracyspells/watchdog/releases) to download the `.rbxm` file.

---

## 📚 Reference

### `Watchdog.new()`

Creates a new `Watchdog` object.

```lua
local watchdog = Watchdog.new()
```

#### Returns

A new `Watchdog` object.

---
### `Watchdog:Bark(...)`

Alerts all entities that the Watchdog is observing with the arguments passed.


```lua
watchdog:Bark("Hello! I'm Bob!")
watchdog:Bark("How many pancakes do you want?")
watchdog:Bark(5)
```

#### Parameters

- `...args`: Arguments to pass to the `:Observe()` and `:ObserveOnce()` `entity` function.

#### Returns

`:Bark()` does not return anything.

---

### `Watchdog:Observe(entity)`

Observes an entity.

```lua
local stopObserving = watchdog:Observe(function(message: string)
    print(message)
end)
```

#### Parameters

- `entity`: A function that will be called with the arguments you passed in `Bark()`.

#### Returns

`:Observe()` returns a cleanup function.

---

### `Watchdog:ObserveOnce(entity)`

Observes an entity that is only alerted once.

```lua
local stopObserving = watchdog:ObserveOnce(function(message: string)
    print(message)
end)
```

#### Parameters

- `entity`: A function that will be called with the arguments you passed in `Bark()`.

#### Returns

`:ObserveOnce()` returns a cleanup function.

---

### `Watchdog:Destroy()`

Destroys the `Watchdog` object.

```lua
watchdog:Destroy()
```

#### Returns

`:Destroy()`  does not return anything.

---

## ⚙️ Example

`observeProperty.luau`
```lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Watchdog = require(ReplicatedStorage.Packages.Watchdog)

type Callback = () -> ()
type Watchdog = Watchdog.Watchdog

local function observeProperty(instance: Instance, propertyName: string, callback: (value: any) -> ()): Callback
	local watchdog: Watchdog = Watchdog.new()
	
	local connection: RBXScriptConnection
	
	local function onPropertyChanged()
		watchdog:Bark((instance :: any)[propertyName])
	end
	
	connection = instance:GetPropertyChangedSignal(propertyName):Connect(onPropertyChanged)
	
	watchdog:Observe(callback)
	onPropertyChanged()
	
	return function()
		connection:Disconnect()
		watchdog:Destroy()
	end
end

return observeProperty
```

---

<p align="center">
Watchdog is released under the <a href="LICENSE.md">MIT License</a>.
</p>

<p align="center" xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/">
The dog icon for Watchdog's logo was from the 
<a property="dct:title" rel="cc:attributionURL" href="https://www.iconshock.com/material-design-icons/animals-icons/">Free Animals Material Icons</a> pack by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://www.iconshock.com/">IconShock & ByPeople</a>, licensed under <a href="https://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""></a>
</p>