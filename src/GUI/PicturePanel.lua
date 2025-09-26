-- picture panel is just a panel with an additional arguments, which are image and texture
-- to draw the picture inside the panel. This is so Panel can be reused somewhere else if the game scales
PicturePanel = Class{}
function PicturePanel:init(def)
    self.boarder = def.boarder or 0
    self.panel = Panel(def.x, def.y, def.width, def.height, self.boarder)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.image = def.image
end
function PicturePanel:update(dt)

end
function PicturePanel:render()
    
    self.panel:render()
    if self.texture ~= nil then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.texture, self.image, self.x, self.y)
    end
    love.graphics.setColor(1, 1, 1, 1)
end