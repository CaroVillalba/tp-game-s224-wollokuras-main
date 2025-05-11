import wollok.game.*
import mario.*
import niveles.*
import enemigos.*

object generadorDeObjetos {

method spawnMoneda(ms){
  game.onTick(ms, "generarMoneda", { self.generarMoneda() }) 
}

method generarMoneda() {
    const nuevaMoneda = new Moneda(position = game.at(1.randomUpTo(14), 1.randomUpTo(14)))
    game.addVisual(nuevaMoneda)
    nuevaMoneda.iniciarAnimacion()
 }

}

class Moneda {
  var property position
  var property recogida = false
  var property sufijo = 1

  method image() = "coin" + sufijo + ".png"
 
  method iniciarAnimacion() {
    if (not recogida) {
      self.animarMoneda() 
      self.manosiadoPorMario() 
    }
  }

  method animarMoneda() {
    if (not recogida) { 
      game.schedule(200, {
        if (sufijo < 5) {
          sufijo += 1
        } else {
          sufijo = 1
        }
        self.animarMoneda() 
      })
    }
  }

  method recoger() {
    recogida = true
    game.removeVisual(self)
    mario.ganarMoneda()
  }

  method manosiadoPorMario() {
    game.schedule(50, {
      if (!recogida and self.estaCercaDe(mario)) { // && self.estaCercaDe(mario)
        self.recoger()
      } else if (!recogida) {
        self.manosiadoPorMario() 
      }
    })
  }

  method estaCercaDe(objeto) {
    var distanciaX = (self.position().x() - objeto.position().x()).abs()
    var distanciaY = (self.position().y() - objeto.position().y()).abs()
    return distanciaX <= 0.5 && distanciaY <= 0.5
  }


}


object moneda_inherte{
  method image() = "money1.png"
  method position() = game.at(game.width() - 2,0)
}

object contador_moneda{

  method text() = mario.monedas().toString()
  method textColor() = "FFFFFF"
  method position() = game.at(game.width() - 1,0)

}

object menu {
    method image() = "kongstill0.png"

    method position() = game.center()

    method text() = "

    KONGI DONK






    Pulsa Espacio para iniciar!"
  
    method textColor() = "c31212cc"

    method iniciarMenu(){
    game.stop()
    game.addVisual(self)
    self.iniciarJuego()
    
  }


    method iniciarJuego(){
        keyboard.space().onPressDo({juego.iniciar()})
        keyboard.space().onPressDo({game.removeVisual(self)})
    }

}