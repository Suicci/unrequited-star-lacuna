require "dependencias"

local marisaSheet
local proyectilSheet

marisa = nil
gatos = {}
barreras = {}
world = nil
hud = nil

cantidadGatos = 5
puntaje = 0
gana = 100
limite = 60
restante = limite
estado = "activo"
sonidoGato = nil
sonidoMarisa = nil
musica = nil

tiempoEv = 0
duracionEv = 3
lapsoEv = 5
evActivo = false
proyectilesLluvia = {}

function crearAnimacion(spriteSheet, frameWidth, frameHeight, frameCount, frameTime)
    return {
        sheet = spriteSheet,
        frameWidth = frameWidth,
        frameHeight = frameHeight,
        frameCount = frameCount,
        frameTime = frameTime,
        currentTime = 0,
        currentFrame = 1
    }
end

function actualizarAnimacion(anim, dt)
    anim.currentTime = anim.currentTime + dt

    while anim.currentTime >= anim.frameTime do
        anim.currentTime = anim.currentTime - anim.frameTime
        anim.currentFrame = anim.currentFrame + 1

        if anim.currentFrame > anim.frameCount then
            anim.currentFrame = 1
        end
    end
end

function dibujarAnimacion(anim, x, y, scaleX, scaleY, flipX)
    local frame = anim.currentFrame
    local quad

    if anim.posicionesX then
        quad = love.graphics.newQuad(
            anim.posicionesX[frame],
            0,
            anim.frameWidth,
            anim.frameHeight,
            anim.sheet:getDimensions()
        )
    else
        local quadsX = math.floor(
            anim.sheet:getWidth() / anim.frameWidth
        )

        local col = (frame - 1) % quadsX
        local row = math.floor((frame - 1) / quadsX)

        quad = love.graphics.newQuad(
            col * anim.frameWidth,
            row * anim.frameHeight,
            anim.frameWidth,
            anim.frameHeight,
            anim.sheet:getDimensions()
        )
    end

    love.graphics.draw(anim.sheet,quad,x,y,0,
        (scaleX or 1) * (flipX and -1 or 1),
        scaleY or 1
    )
end

local function crearBarrera(x, y, w, h)
    local cuerpo = love.physics.newBody(
        world,
        x + w / 2,
        y + h / 2,
        "static"
    )

    local forma = love.physics.newRectangleShape(w, h)

    local fixture = love.physics.newFixture(
        cuerpo,
        forma
    )

    fixture:setRestitution(1)
    fixture:setFriction(0)

    table.insert(barreras, {
        cuerpo = cuerpo,
        forma = forma,
        fixture = fixture
    })
end

local function crearBarreras()
    local ancho = love.graphics.getWidth()
    local alto = love.graphics.getHeight()
    local grosor = 20

    crearBarrera(0, 0, ancho, grosor)
    crearBarrera(0, alto - grosor, ancho, grosor)
    crearBarrera(0, 0, grosor, alto)
    crearBarrera(ancho - grosor, 0, grosor, alto)
end

local function reiniciarMarisa()
    marisa.x = -marisa.ancho / 2

    marisa.y = love.math.random(
        50 + marisa.alto / 2,
        love.graphics.getHeight() - marisa.alto / 2 - 20
    )
end

function iniciarLluvia()
    evActivo = true
    tiempoEv = 0

    for i = 1, 8 do
        local x = love.math.random(30, love.graphics.getWidth() - 30)
        local y = love.math.random(-300, -30)

        local gato = Proyectil(proyectilSheet, x, y)

        gato.velY = love.math.random(250, 450)

        table.insert(proyectilesLluvia, gato)
    end
end

--Load--
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    marisaSheet = love.graphics.newImage("marisasprite.png")
    proyectilSheet = love.graphics.newImage("supermuertesprite.png")

    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 0, true)

    crearBarreras()

    marisa = Marisa(marisaSheet)

    hud = HUD()

    for i = 1, cantidadGatos do
        local x = love.math.random(80, 720)
        local y = love.math.random(80, 520)

        local gato

        if i <= 2 then
            gato = ProyectilFisico(proyectilSheet,x,y)
        else
            gato = Proyectil(proyectilSheet,x,y)
        end

        table.insert(gatos, gato)
    end

    sonidoMarisa = love.audio.newSource("marisoni.wav", "static")
    sonidoGato = love.audio.newSource("gatoauch.wav", "static")
    musica = love.audio.newSource("musicath.ogg", "stream")

    sonidoMarisa:setVolume(0.8)
    sonidoGato:setVolume(0.8)
    musica:setVolume(0.5)
    musica:setLooping(true)
    musica:play()
end

--Update--
function love.update(dt)
    if estado ~= "activo" then
        return
    end

    restante = restante - dt

    if restante <= 0 then
        restante = 0
        estado = "perder"
        return
    end

    if puntaje >= gana then
        estado = "ganar"
        return
    end

    world:update(dt)

    marisa:Actualizar(dt)

    for _, gato in ipairs(gatos) do
        gato:Actualizar(dt)
    end

    if not evActivo then
        tiempoEv = tiempoEv + dt

        if tiempoEv >= lapsoEv then
            iniciarLluvia()
        end
    else
        tiempoEv = tiempoEv + dt

        for _, gato in ipairs(proyectilesLluvia) do
            gato.y = gato.y + gato.velY * dt
            gato:ActualizarAnimacion(dt)
    end

    if tiempoEv >= duracionEv then
        evActivo = false
        tiempoEv = 0
        proyectilesLluvia = {}
    end
end

local function dibujarFisicaDebug()
    love.graphics.setColor(0, 1, 0)

    for _, barrera in ipairs(barreras) do
        love.graphics.polygon(
            "line",
            barrera.cuerpo:getWorldPoints(
                barrera.forma:getPoints()
            )
        )
    end

    for _, gato in ipairs(gatos) do
        if gato.Debug then
            gato:Debug()
        end
    end

    love.graphics.setColor(1, 1, 1)
end

--draw--
function love.draw()
    if estado == "activo" then
        marisa:Dibujar()

        for _, gato in ipairs(gatos) do
            gato:Dibujar()
        end

        if evActivo then
            for _, gato in ipairs(proyectilesLluvia) do
                gato:Dibujar()
            end
        end
    end

    hud:Dibujar(puntaje, gana, restante, estado)

    if hud.depurar then
        dibujarFisicaDebug()
    end
end

--teclado y mouse y esas csoas--
function love.mousepressed(mx, my, button)
    if estado ~= "activo" or button ~= 1 then
        return
    end

    if marisa:ContienePunto(mx, my) then
        puntaje = puntaje + marisa.puntos
        sonidoMarisa:stop()
        sonidoMarisa:play()
        reiniciarMarisa()
        return
    end

    for _, gato in ipairs(gatos) do
        if gato:ContienePunto(mx, my) then
            puntaje = math.max(
                0,
                puntaje + gato.puntos
            )
            sonidoGato:stop()
            sonidoGato:play()
            gato:Reiniciar()
            return
        end
    end
end

function love.keypressed(key)
    if key == "f1" then
        hud:AlternarDepuracion()
    end
end
end