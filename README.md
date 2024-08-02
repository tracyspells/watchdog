<p align="center">
<h1 align="center"> <b>Watchdog</b> </h1>
<p align = "center">Simple Observer pattern for Roblox.</p>
</p>

**Watchdog** is a simple, barebones Observer pattern that centers around [Signals](https://sleitnick.github.io/RbxUtil/api/Signal/).

Check out the examples to see what you can do with **Watchdog**!

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


```lua
watchdog:Bark("Hello! I'm Bob!")
```

#### Parameters

- `...args`: Arguments to pass to the `:Observe()` and `:ObserveOnce()` `callback` function.

#### Returns

`:Bark()` does not return anything.

---

### `Watchdog:Observe(callback)`

```lua
local stopObserving = watchdog:Observe(function(message: string)
    print(message)
end)

watchdog:Bark("Hello world!")
```

#### Parameters

- `callback`: A function that will be called with the arguments you passed in `Bark()`.

#### Returns

`:Observe()` returns a cleanup function.

---

### `Watchdog:ObserveOnce(callback)`

```lua
local stopObserving = watchdog:ObserveOnce(function(message: string)
    --This function will only be called once!

    print(message)
end)

watchdog:Bark("Hello world!")
watchdog:Bark("Goodbye world!") -- Will not run
```

#### Parameters

- `callback`: A function that will be called with the arguments you passed in `Bark()`.

#### Returns

`:ObserveOnce()` returns a cleanup function.

---

### `Watchdog:Destroy()`

Destroys the `Watchdog` object, cleaning up any connections.

```lua
watchdog:Destroy()
```

#### Returns

`:Destroy()`  does not return anything.

---

<p align="center">
    Watchdog is released under the <a href="LICENSE.md">MIT License</a>.
</p>