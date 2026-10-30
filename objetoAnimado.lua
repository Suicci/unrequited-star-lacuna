ObjetoAnimado = Class {}

function ObjetoAnimado:init(sheet,ancho,alto,frames,tiempo)
    self.anim = crearAnimacion(
        sheet,ancho,alto,frames,tiempo
    )

    self.ancho = ancho
    self.alto = alto
end

function ObjetoAnimado:ActualizarAnimacion(dt)
    actualizarAnimacion(self.anim,dt)
end

function ObjetoAnimado:DibujarEn(x,y)
    dibujarAnimacion(
        self.anim,
        x - self.ancho / 2,
        y - self.alto / 2
    )
end