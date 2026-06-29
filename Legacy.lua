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
        Initialized()
    end
end

function Initialized()
    for i = 1, #replacements do
        local entry = replacements[i]
        local obj = GameObject.FindByName(entry[1])
        if obj then
            local url = entry[2]
            loadtexture(url, function(success, tex, err)
                if success and tex then
                    local mat = Material.Create("Standard")
                    mat.mainTexture = tex
                    mat.color = Vector4.New(1, 1, 1, 1)
                    mat.metallic = 0
                    mat.smoothness = 0
                    obj.Material = mat
                end
            end)
        end
    end
end
