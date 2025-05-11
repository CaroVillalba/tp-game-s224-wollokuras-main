import wollok.game.*
import mario.*
import items.*
import enemigos.*

object juego {
 

  method iniciar() {

    config.configurarTeclas()
    config.configurarColisiones()
    game.addVisual(kongiDonk)
    game.addVisual(mario)
    game.addVisual(moneda_inherte)
    game.addVisual(contador_moneda)

    marioVidas.inicializarVidas()

    self.dificultad(1000, 1000, 200, 2000)
  }
/*
  var property lanzarObstaculoSiguiente = false // Inicia con proyectiles
  var property count = 0 

  method lanzarSiguiente() {
      if (lanzarObstaculoSiguiente && count < 5) {
          kongiDonk.lanzarObstaculo()
          count += 1
      } else {
          kongiDonk.lanzarProyectil()
          count = 0
      }
      lanzarObstaculoSiguiente = !lanzarObstaculoSiguiente // Alterna el próximo lanzamiento
  }
*/

  method terminar(){
    game.schedule(1000, {game.stop()})
  }

  method dificultad(spawnProyectil,velocidadMono,velocidadProyectil,spawnMoneda){
    game.onTick(spawnProyectil, "genera mas proyectiles", { kongiDonk.lanzarProyectil() })
    game.onTick(velocidadMono, "se mueve la mona", { kongiDonk.aparecerAleatorio() })
    game.onTick(velocidadProyectil, "movimiento proyectil", {kongiDonk.moverProyectiles()})
    game.onTick(spawnMoneda, "generarMoneda", { generadorDeObjetos.generarMoneda() }) // Genera una moneda cada 2 segundos
    //game.onTick(spawnRemolino, "generar remolino", { kongiDonk.lanzarObstaculo() })
  }
  
  method sacarEventos(){
    game.removeTickEvent("genera mas proyectiles")
    game.removeTickEvent("se mueve la mona")
    game.removeTickEvent("movimiento proyectil")
    game.removeTickEvent("generarMoneda")
    game.removeTickEvent("generar remolino")
  }

}

object config {

  method configurarTeclas() {
    
    keyboard.a().onPressDo({mario.mover(mario.position().left(1))})
		keyboard.d().onPressDo({mario.mover(mario.position().right(1))})
    keyboard.w().onPressDo({mario.mover(mario.position().up(1))})
		keyboard.s().onPressDo({mario.mover(mario.position().down(1))})

    keyboard.left().onPressDo({mario.mover(mario.position().left(1))})
		keyboard.right().onPressDo({mario.mover(mario.position().right(1))})
    keyboard.up().onPressDo({mario.mover(mario.position().up(1))})
		keyboard.down().onPressDo({mario.mover(mario.position().down(1))})

  }

  method configurarColisiones() {
    game.onCollideDo(mario, {algo => algo.manosiadoPorMario()})
  }

}