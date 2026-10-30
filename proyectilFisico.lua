ProyectilFisico = Class{__includes = Proyectil}

function ProyectilFisico:init(sheet,x,y)
    Proyectil.init(self,sheet,x,y)

    self.radio = 8 * self.escala

    self.cuerpo = love.physics.newBody(world,x,y,"dynamic")

    self.forma = love.physics.newCircleShape(self.radio)
    self.fixture = love.physics.newFixture(self.cuerpo,self.forma,1)

    self.fixture:setRestitution(1)
    self.fixture:setFriction(0)
    self.fixture:setUserData(self)

    self.cuerpo:setBullet(true)
    self.cuerpo:setLinearVelocity(
        love.math.random(189,300),
        love.math.random(-180,180)
    )
end

function ProyectilFisico:Actualizar(dt)
    self:ActualizarAnimacion(dt)
end

function ProyectilFisico:Dibujar()
    dibujarAnimacion(
        self.anim,
        self.cuerpo:getX() - (self.ancho * self.escala) / 2,
        self.cuerpo:getY() - (self.alto * self.escala) / 2,
        self.escala,
        self.escala
    )
end

function ProyectilFisico:Reiniciar()
    local ancho = love.graphics.getWidth()
    local alto = love.graphics.getHeight()

    self.cuerpo:setPosition(
        ancho / 2,
        love.math.random(50, alto - 50)
    )

    self.cuerpo:setLinearVelocity(love.math.random(189, 300),love.math.random(-180, 180))

    self.cuerpo:setAngularVelocity(0)
    self.cuerpo:setAwake(true)
end

function ProyectilFisico:ContienePunto(mx,my)
    local dx = mx - self.cuerpo:getX()
    local dy = my - self.cuerpo:getY()

    return dx * dx + dy * dy <= self.radio * self.radio
end