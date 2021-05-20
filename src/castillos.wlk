class Castillo {

	var tamanioMuralla = 6
	var estabilidad = 500
	var planificacionEstrategica = 0
	var ambientes = []
	var espias = [] // BONUS
	var moradores = []
	var burocratasJoI = moradores.filter({ b => b.jovenOInexperto() })

	method fiesta() {
		if (estabilidad > 125 && moradores.count({ b => b.miedo() }) > 2) {
			moradores.forEach{ m => m.irAFiesta()}
			if (estabilidad < 500) espias.add("espia")
		}
	}

	method resistencia() {
		return (tamanioMuralla + (ambientes.sum({ a => a.dimension() })) + self.capacidadDefensa() + planificacionEstrategica - espias.size() * 25).min(500)
	}

	method recibirAtaque() {
		estabilidad = (estabilidad - 500 + self.resistencia())
		moradores.forEach({ g => g.recibirAtaque()})
	}

	method prepararDefensas() {
		if (!self.derrotado()) {
			estabilidad = ((estabilidad + ( moradores.sum({ g => g.capacidad() }))).div(moradores.size())).min(1000)
			if (moradores.count({ b => b.miedo() }) < 2) planificacionEstrategica += 50
		}
	}

	method capacidadDefensa() {
		return (moradores.sum({ g => g.capacidad() }) - (moradores.sum({ g => g.agotamiento() }))).max(100)
	}

	method derrotado() {
		return estabilidad < 100
	}

	method agregarGuardias(cantidad, cap) {
		cantidad.times({ x => moradores.add(new Guardia(capacidad = cap))})
	}

	method agregarBurocrata(nom, anio, exp) {
		moradores.add(new Burocrata(nombre = nom, anioNac = anio, aniosExp = exp))
	}

	method estabilidad() {
		return estabilidad
	}

	method agregarAmbiente(tamanio) {
		ambientes.add(new Ambiente(dimension = tamanio))
	}

//BONUS
	method discursoReina() { // Funcionalidad de reina
		moradores.forEach{ b => b.recibirDiscurso()}
	}

	method agrandarAmbiente(ambiente, tamanio) { // Funcionalidad de ambientes
		ambiente.agrandar(tamanio)
	}

}

class Guardia {

	var capacidad = 5 // 0-10
	var agotamiento = 0 // 0-5 

	method irAFiesta() {
		agotamiento = 0
	}

	method capacidad() {
		return capacidad
	}

	method recibirAtaque() {
		agotamiento = (agotamiento + 1).min(5)
	}

	method agotamiento() {
		return agotamiento
	}

	method jovenOInexperto() {
		return false
	}

	method miedo() {
		return false
	}

	method recibirDiscurso() {
		capacidad += 1
	}

}

class Burocrata {

	var nombre
	const anioNac
	var aniosExp
	var miedo = false

	method jovenOInexperto() {
		return (aniosExp < 5 || anioNac > 2000)
	}

	method irAFiesta() {
		miedo = false
	}

	method miedo() {
		return miedo
	}

	method recibirAtaque() {
		miedo = true
	}

	method capacidad() {
		return 0
	}

	method agotamiento() {
		return 0
	}

	method recibirDiscurso() {
		miedo = false
	}

}

class Rey {

	const castillo

	method ordenarFiesta() {
		castillo.fiesta()
	}

	method ordenarPrepararDefensas() {
		castillo.prepararDefensas()
	}

	method atacarCastillo(enemigo) {
		enemigo.recibirAtaque()
	}

}

// BONUS - 
class Reina {

	const castillo

	method ordenarPrepararDefensas() {
		castillo.prepararDefensas()
	}

	method atacarCastillo(enemigo) {
		enemigo.recibirAtaque()
	}

	method darDiscurso() {
		castillo.discursoReina()
	}

}

class Ambiente {

	var dimension = 5

	method agrandar(tamanio) {
		dimension += 1.min(10)
	}

	method dimension() {
		return dimension
	}

}

