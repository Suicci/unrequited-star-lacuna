Proyectil = Class{__includes = ObjetoAnimado}

function Proyectil:init(sheet,x,y)
    ObjetoAnimado.init(self,sheet,33,32,3,0.06)

    self.x = x
    self.y = y
    self.vel = 550
    self.puntos = -5
    self.escala = 2

end

function Proyectil:Actualizar(dt)
    self.x = self.x + self.vel * dt
    self:ActualizarAnimacion(dt)

    if self.x - self.ancho / 2 > love.graphics.getWidth() then
        self.x = -self.ancho / 2
        self.y = love.math.random(
            50 + self.alto /2,
            love.graphics.getHeight() - self.alto / 2 - 20
        )
    end
end

function Proyectil:Dibujar()
    dibujarAnimacion(
        self.anim,
        self.x - (self.ancho * self.escala) / 2,
        self.y - (self.alto * self.escala) / 2,
        self.escala,
        self.escala
    )
end

function Proyectil:Reiniciar()
    self.x = -(self.ancho * self.escala) / 2
    self.y = love.math.random(
        50 + (self.alto * self.escala) / 2,
        love.graphics.getHeight() - (self.alto * self.escala) / 2 - 20
    )
end

function Proyectil:ContienePunto(mx,my)
    local mitadAncho = self.ancho * self.escala / 2
    local mitadAlto = self.alto * self.escala / 2

    return mx >= self.x - mitadAncho
        and mx <= self.x + mitadAncho
        and my >= self.y - mitadAlto
        and my <= self.y + mitadAlto
end