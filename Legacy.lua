local textureCache = {}
local retryCount = {}
local applied = {}

local replacements = {
    {"BridgeFloor", "https://raw.githubusercontent.com/GBLuaKoilp/KoilpGoreBoxLuaGithub/main/Rock.png"},
    {"Floor (4)", "https://raw.githubusercontent.com/GBLuaKoilp/KoilpGoreBoxLuaGithub/main/Grass.png"},
    {"Floor (10)", "https://raw.githubusercontent.com/GBLuaKoilp/KoilpGoreBoxLuaGithub/main/Sand.png"},
    {"Floor (5)", "https://raw.githubusercontent.com/GBLuaKoilp/KoilpGoreBoxLuaGithub/main/Tiles.png"},
    {"Floor (6)", "https://raw.githubusercontent.com/GBLuaKoilp/KoilpGoreBoxLuaGithub/main/Cliffs.png"},
    {"Cube (1)", "https://raw.githubusercontent.com/GBLuaKoilp/KoilpGoreBoxLuaGithub/main/Dirt.png"},
    {"Cube", "https://raw.githubusercontent.com/GBLuaKoilp/KoilpGoreBoxLuaGithub/main/Water.png"}
}

function OnSceneLoaded(scene)
    if scene == "map_Legacy" then
        ApplyTextures()
    end
end

function ApplyTextures()
    for i = 1, #replacements do
        local name = replacements[i][1]
        local url = replacements[i][2]

        if not applied[name] then
            local obj = GameObject.FindByName(name)
            if obj and obj.IsValid() then
                applied[name] = true
                if textureCache[url] then
                    SetMaterial(obj, textureCache[url])
                else
                    LoadTexture(obj, name, url)
                end
            end
        end
    end
end

function LoadTexture(obj, name, url)
    if not retryCount[url] then retryCount[url] = 0 end

    loadtexture(url, function(ok, tex)
        if not obj or not obj.IsValid() then return end

        if ok and tex and tex.IsValid() then
            textureCache[url] = tex
            SetMaterial(obj, tex)
        else
            retryCount[url] = retryCount[url] + 1
            if retryCount[url] <= 3 then
                local co = coroutine.create(function()
                    coroutine.yield(2000)
                    LoadTexture(obj, name, url)
                end)
                if coroutineTable then
                    coroutineTable[co] = Time.GetRealTimeMs() + 2000
                else
                    coroutine.resume(co)
                end
            else
                Debug.LogError("Failed: " .. name)
            end
        end
    end)
end

function SetMaterial(obj, tex)
    local mat = obj.Material
    if not mat or not mat.IsValid() then
        mat = Material.Create("Standard")
    end
    mat.mainTexture = tex
    mat.color = Vector4.New(1,1,1,1)
    mat.metallic = 0
    mat.smoothness = 0
    obj.Material = mat
end

function OnUnload()
    for _, tex in tableIterators.pairs(textureCache) do
        if tex and tex.IsValid() then tex.Destroy() end
    end
    textureCache = {}
    applied = {}
    retryCount = {}
end
