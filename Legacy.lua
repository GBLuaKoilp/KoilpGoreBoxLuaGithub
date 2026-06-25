local replacements = {
    {"BridgeFloor", "Textures/Rock.png"},
    {"Floor (4)", "Textures/Grass.png"},
    {"Floor (10)", "Textures/Sand.png"},
    {"Floor (5)", "Textures/Tiles.png"},
    {"Floor (6)", "Textures/Cliffs.png"},
    {"Cube (1)", "Textures/Dirt.png"},
    {"Cube", "Textures/Water.png"}
}

function OnSceneLoaded(scene)
    Initialized()
end

function Initialized()
    for i = 1, #replacements do
        local entry = replacements[i]
        local obj = GameObject.FindByName(entry[1])
        if obj then
            local tex = Importer.ImportTexture(entry[2])
            if tex then
                local mat = Material.Create("Standard")
                mat.mainTexture = tex
                mat.color = Vector4.New(1, 1, 1, 1)
                mat.metallic = 0
                mat.smoothness = 0
                obj.Material = mat
            end
        end
    end
end