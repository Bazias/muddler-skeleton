# muddler-skeleton

## What is this?
This is a simple skeleton to get you started with [muddler](https://github.com/demonnic/muddler) and [squish](https://github.com/vvvvv/squish) to build your separate lua packages into a single artifact that is then imported into mudlet.

## How does this work?
Run `./build.sh`.

There are two steps in the build process:
1) Squish is ran, reading the `./squishy` file to know what files and dependencies should be included in the bundle. All files in the `./sys` directory should be included in the squishy file if they should be included in the bundle. It writes its output to `./src/resources/`.
1) Muddler runs over the `./src` directory and builds an `mpackage`

## Why a single bundle?
I'm lazy and only have to deal with one file.

## How to work with CI?
Squish makes use of `package.preload`, so when doing a reload, both it and `package.loaded` need to be cleared.

I'm currently using something like this:

```lua
local function killSys()
	deleteAllNamedEventHandlers("sys")
  for i,target in ipairs({ 'sys', 'notify', 'pl' }) do
    	for pkgName, _ in pairs(package.loaded) do
        if pkgName:find(target) then
      			debugc("Uncaching lua package " .. pkgName)
      			package.loaded[pkgName] = nil
      		end
    	end
      
      for pkgName, _ in pairs(package.preload) do
        if pkgName:find(target) then
      			debugc("Uncaching lua package " .. pkgName)
      			package.preload[pkgName] = nil
      		end
    	end
  end
	sys = nil
end

local function create_helper()
	if SysMuddler then
		SysMuddler:stop()
	end
	SysMuddler = Muddler:new({
		path = "/home/bazias/Dev/sys/",
		postremove = killSys,
	})
end

if not SysMuddler then
	registerAnonymousEventHandler("sysLoadEvent", create_helper)
end
```
