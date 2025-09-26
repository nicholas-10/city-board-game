function GenerateQuads(width, height, texture)
    local quads = {}
    local imWidth, imHeight = texture:getDimensions()
    local numberQuadsX = imWidth / width
    local numberQuadsY = imHeight / height
    for y = 0, numberQuadsY - 1 do
        for x = 0, numberQuadsX - 1 do
            local quad = love.graphics.newQuad(x * width, y * height, width, height, texture:getDimensions())
           
            table.insert(quads, quad)
        end
     
    end
    return quads
end