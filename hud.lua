HUD = Class{}

function HUD:init()
    self.depurar = false
end

function HUD:Dibujar(puntaje, objetivo, tiempo, estado)
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Puntaje: " .. puntaje .. " / " .. objetivo, 10, 10)
    love.graphics.print("Tiempo: " .. math.ceil(tiempo), 10, 30)
    love.graphics.print("F1: Alternar depuracion", 10, 50)

    if estado == "ganar" then
        love.graphics.printf("Victoria royal",0, 250,love.graphics.getWidth(),"center")
    elseif estado == "perder" then
        love.graphics.printf("Derrota",0, 250,love.graphics.getWidth(),"center")
    end

    if self.depurar then
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 70)
    end
end

function HUD:AlternarDepuracion()
    self.depurar = not self.depurar
end
