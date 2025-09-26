-- Panel class just draws 2 rectangles with different colors.
Panel = Class{}
function Panel:init(x, y, width, height, boarder)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.boarder = boarder
end
function Panel:update(dt)
    
end
function Panel:render()
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle('fill', self.x - self.boarder, self.y - self.boarder, self.width + self.boarder * 2, self.height + self.boarder * 2, 3)
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 3)
    
end