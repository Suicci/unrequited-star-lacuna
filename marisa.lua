Marisa = Class{__includes = ObjetoAnimado}

function Marisa:init(sheet)
    ObjetoAnimado.init(self, sheet, 120, 66, 8, 0.08)

    self.anim.posicionesX = {10, 136, 262, 387, 512, 637, 762, 887}

    self.x = -self.ancho / 2
    self.y = 300
    self.vel = 650
    self.puntos = 3
end

function Marisa:Actualizar(dt)
    self.x = self.x + self.vel * dt
    self:ActualizarAnimacion(dt)

    if self.x - self.ancho / 2 > love.graphics.getWidth() then
        self.x = -self.ancho/2
        self.y = love.math.random(
            50 + self.alto / 2,
            love.graphics.getHeight() - self.alto / 2 - 20
        )
    end
end

function Marisa:Dibujar()
    self:DibujarEn(self.x,self.y)
end

function Marisa:ContienePunto(mx,my)
    return mx >= self.x - self.ancho / 2
        and mx <= self.x + self.ancho / 2
        and my >= self.y - self.alto / 2
        and my <= self.y + self.alto / 2
end