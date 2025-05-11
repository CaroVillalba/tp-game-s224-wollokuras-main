import wollok.game.*
import niveles.*
import items.* 
import enemigos.*

object mario{

  var property vidas = 3
  var property monedas = 0 
  var property position = game.center()
  var property invulnerabilidad = false
  var property monedaTope = 20
  var property stuneado = false 

  var sufijo = "right"

  method image() = "mario1-"+ sufijo +".png"
  
  method mover(nuevaPosicion) {
    //if(not stuneado){
      if (self.inBoundsCheck(nuevaPosicion) and vidas != 0 and not stuneado) {
        if (nuevaPosicion.x() > position.x()) {
          sufijo = "right"
        } else if (nuevaPosicion.x() < position.x()) {
          sufijo = "left"
        }
      position = nuevaPosicion
      }
    //}
  }

  method play() = game.sound("jump.wav").play()
  method playMuerte() = game.sound("mario-game-over.mp3").play()
  method playDanio() = game.sound("mario-danio.mp3").play()
  method playMoneda() = game.sound("coin.wav").play()
  method playGanarVida() = game.sound("get_heart.mp3").play()


  method perderCorazon() {
    marioVidas.perderCorazon()
    self.invulnerable()
  }
  method ganarVidas() {
    if(vidas < 5){
        vidas +=1
        self.playGanarVida()
        marioVidas.ganarCorazon()
      }else{
        self.playGanarVida()
      }
  }
  method perderVidas() {
    if(!invulnerabilidad){
      vidas -= 1
      if(vidas != 0){
        self.playDanio()
        self.perderCorazon()

      }else{
        sufijo = "muerte"
        position = position.up(1)
        self.playMuerte()
        self.perderCorazon()


        game.schedule(200, { position = position.down(1)})
        juego.terminar()
      }}
  }
  method inBoundsCheck(newPos) = newPos.y() <=game.height()-1 && newPos.y() >= 1 && newPos.x() >=0 && newPos.x() <= game.width()-1

  method invulnerable(){
    invulnerabilidad = true
    game.schedule(1000, { invulnerabilidad = false })
  }

  method marioLiberado(){
    stuneado = false
    sufijo = "right"
  }

  method enElAire(){
    stuneado = true
    sufijo = "congelados"
    game.schedule(2000, { self.marioLiberado() })
  }

  method ganarMoneda() {
    monedas = monedas + 1
    self.playMoneda()
    self.evaluarCantMonedas()
    if(monedas == monedaTope){ //aca depende la dificultad pueden ser más monedas, entonces monedas se deberá igualar a una variable tipo "victoria_monedas" o "monedas_tope"
      self.evaluarCantMonedas()

      if(monedas == monedaTope){ //aca depende la dificultad pueden ser más monedas, entonces monedas se deberá igualar a una variable tipo "victoria_monedas" o "monedas_tope"
      self.ganar()
      }
    }
  }
  

method evaluarCantMonedas() {
    if (monedas > 15) {
        juego.sacarEventos()
        juego.dificultad(150, 150, 150, 3000)
    } else if (monedas > 10) {
        juego.sacarEventos()
        juego.dificultad(200, 200, 150, 2500)
    } else if (monedas > 5) {
        juego.sacarEventos()
        juego.dificultad(400, 400, 200, 2000)
    }
}


    method ganar() {
      game.sound("levelcomplete.wav").play()
      juego.terminar()
    }
}


object marioVidas {
  const vidas = [vidaInicial]

  var property vidaInicial = new Vida(position = game.at(0, 0))
  method ganarCorazon() {
    var vidaExtra
    vidaExtra = new Vida(position = game.at(vidas.last().position().x()+1, 0))
    vidas.add(vidaExtra)
    game.addVisual(vidaExtra)
  }
  method perderCorazon(){
    game.removeVisual(vidas.last())
    vidas.remove(vidas.last())
  }
  method inicializarVidas(){
    game.addVisual(vidaInicial)
    self.ganarCorazon()
    self.ganarCorazon()
  }
}



class Vida{

  var property position

  method image() = "corazon1.png"

}