import wollok.game.*
import mario.*
import niveles.*
import items.*

object kongiDonk {
    var property position = game.at(0,1)
    
    const proyectilesActivos=[]
    var donkeyVertical= false

    method image() = "kongi.png"

    method aparecerAleatorio() {
         if(donkeyVertical){ //donkey en x=0
             position = game.at(0, 1.randomUpTo(game.height()-1))
             donkeyVertical = false
         }else{ //donkey en y=game.height()-1
             position = game.at(0.randomUpTo(game.width()-1) , game.height()-1)
             donkeyVertical = true
         }
     }

    method aparicionProyectil(proyectil){
            game.addVisual(proyectil)
            proyectilesActivos.add(proyectil)
    }

    method lanzarProyectil() {
        const posibilidadCorazon= 0.randomUpTo(12).round()
        if(!donkeyVertical && posibilidadCorazon != 1 && posibilidadCorazon <= 10){
            var proyectil
            proyectil = new Fuegos(position = self.position().right(1))
            self.aparicionProyectil(proyectil)
        } else if(posibilidadCorazon!=1 && posibilidadCorazon <= 10){
            var proyectil
            proyectil = new FuegosVerticales(position = self.position().down(1))
            self.aparicionProyectil(proyectil)
        } else if (donkeyVertical && posibilidadCorazon > 10){
            var obstaculo
            obstaculo = new RemolinoVertical(position = self.position().down(1))
            self.aparicionProyectil(obstaculo)
        } else if (posibilidadCorazon>10){
            var obstaculo
            obstaculo = new Remolino(position = self.position().right(1))
            self.aparicionProyectil(obstaculo)
        }
        else if(donkeyVertical && posibilidadCorazon <= 10){
            var proyectil
            proyectil = new CorazonVerdeVertical(position = self.position().down(1))
            self.aparicionProyectil(proyectil)
        } else{
            var proyectil
            proyectil = new CorazonVerde(position = self.position().right(1))
            self.aparicionProyectil(proyectil)
        }
    }


    method moverProyectiles(){
        proyectilesActivos.forEach({proyectil => if(!proyectil.estaDetenido()){proyectil.desplazarse()} else proyectilesActivos.remove(proyectil)})
    }

     method playGolpe() = game.sound("kong-golpe.mp3").play()

     method condManosiadoPorMario() {
            mario.perderVidas()
            self.playGolpe()
     }

     method manosiadoPorMario(){ // Codigo usado para interacción de dk con mario!!
         if(self.position().x() == 0){
             mario.mover(mario.position().right(1))
             self.condManosiadoPorMario()
         } else {
             mario.mover(mario.position().down(1))
             self.condManosiadoPorMario()
         }
     }

}

class Proyectiles { //se podrian agregar mas
    var property position 
    var property detenido = false
   
    method inBounds() = position.y() <=game.height() && position.y() >= 2 && position.x() >=0 && position.x() <= game.width()
    
    method desplazarse() { 
        if (self.inBounds()) {
            self.desplazamientoHijos()
        } else {
            self.detenerse()
        }
    }

    method estaDetenido() = detenido
    
    method detenerse() {
        game.removeVisual(self)
        detenido = true
    }

    method desplazamientoHijos()
}

class Fuegos inherits Proyectiles {
    
    method image() = "fireballright.png"

    override method desplazamientoHijos() {
        position = position.right(1)
    }

    method manosiadoPorMario(){
        mario.perderVidas()
        self.detenerse()
    }
}

class FuegosVerticales inherits Fuegos{
    
    override method image() = "fireballdown.png"


    override method desplazamientoHijos() {
        position = position.down(1)
    }
    override method desplazarse() { 
        if(self.inBounds()){
            position = position.down(1)
        } else {
            self.detenerse()
        }
    } 
}


class Remolino inherits Proyectiles{

    method image() = "remolino.png"

    override method desplazamientoHijos() {
        position = position.right(1)
    }

    method manosiadoPorMario(){ 
        mario.enElAire()
        self.detenerse()
    }
}

class RemolinoVertical inherits Remolino{

    override method desplazamientoHijos() {
        position = position.down(1)
    }
}

class CorazonVerde inherits Proyectiles{
    
    method image() = "corazonVerde.png"

    override method desplazamientoHijos() {
        position = position.right(1)
    }

    method manosiadoPorMario(){
        mario.ganarVidas()
        self.detenerse()
    }
}

class CorazonVerdeVertical inherits CorazonVerde{    
    override method desplazamientoHijos() {
        position = position.down(1)
    }
}

