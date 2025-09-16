% Empleados por departamento
seccion(ventas, kyle).
seccion(ventas, trisha).
seccion(logistica, ian).
seccion(logistica, sherri).
seccion(logistica, joshua).

empleado(Empleado):-
    distinct(Empleado, seccion(_, Empleado)).

departamento(Departamento):-
    distinct(Departamento, seccion(Departamento, _)).

%  Honorarios de empleados
honorarios(kyle, asalariado(7, 30)).
honorarios(sherri, asalariado(6, 90)).
honorarios(gus, asalariado(8, 60)).
honorarios(ian, jefe([kyle, rob], 85)).
honorarios(trisha, jefe([ian, gus, ginger], 50)).
honorarios(joshua, independiente(ingeniero, 35)).

% Felicidad
criterioFelicidadJefe(Personas, _):-
    length(Personas, Cantidad),
    Cantidad < 3.

criterioFelicidadJefe(_, Sueldo):-
    Sueldo > 50.

criterioFelicidadIndependiente(Carrera):-
    Carrera == ingeniero.

criterioFelicidadIndependiente(Carrera):-
    Carrera == arquitecto.

criterioFelicidad(asalariado(Horas, _)):-
    Horas < 7.

criterioFelicidad(jefe(Personas, Sueldo)):-
    criterioFelicidadJefe(Personas, Sueldo).

criterioFelicidad(independiente(Carrera, _)):-
    criterioFelicidadIndependiente(Carrera).

esFeliz(Persona):-
    empleado(Persona),
    honorarios(Persona, Honorario),
    criterioFelicidad(Honorario).

hayFelicidad(Departamento):-
    departamento(Departamento),
    forall(seccion(Departamento, Empleado), esFeliz(Empleado)).

hayFelicidad(Departamento):-
    departamento(Departamento),
    Departamento == logistica.

% Houston
quiereGanar(kyle, 70).
quiereGanar(trisha, 250).
quiereGanar(joshua, 70).
quiereGanar(sherri, 200).
quiereGanar(ian, 60).
quiereGanar(gus, 70).

sueldo(asalariado(_, Sueldo), Sueldo).
sueldo(jefe(_, Sueldo), Sueldo).
sueldo(independiente(_, Sueldo), Sueldo).

reglaConformidad(Objetivo, Honorario):-
    sueldo(Honorario, Sueldo),
    Objetivo =< Sueldo * 2.

estaSatisfecho(Persona):-
    quiereGanar(Persona, Objetivo),
    honorarios(Persona, Honorario),
    reglaConformidad(Objetivo, Honorario).

estaEnProblemas(Departamento):-
    departamento(Departamento),
    forall(
        seccion(Departamento, Empleado), 
        (empleado(Empleado),not(estaSatisfecho(Empleado)))
        ).

% El juego de las sillas

% Predicado inicial para comenzar la búsqueda.
% Usa findall para obtener todas las personas disponibles.
reorganizar(Presupuesto, Empleados, Costo) :-
    findall(Persona, empleado(Persona), PersonasDisponibles),
    reorganizar(Presupuesto, PersonasDisponibles, Empleados, Costo).

% Caso base: El presupuesto no alcanza para ninguna persona de la lista.
reorganizar(_, [], [], 0).

% Caso recursivo: Selecciona una persona de la lista de disponibles.
reorganizar(Presupuesto, [Persona|RestoDisponibles], [Persona|GrupoEmpleados], CostoTotal) :-
    honorarios(Persona, Honorario),
    sueldo(Honorario, Sueldo),
    Presupuesto >= Sueldo, % La persona puede ser agregada.
    NuevoPresupuesto is Presupuesto - Sueldo,
    reorganizar(NuevoPresupuesto, RestoDisponibles, GrupoEmpleados, CostoRestante),
    CostoTotal is Sueldo + CostoRestante.

% Segunda cláusula recursiva: No selecciona a la persona actual y continúa con el resto.
reorganizar(Presupuesto, [_|RestoDisponibles], GrupoEmpleados, Costo) :-
    reorganizar(Presupuesto, RestoDisponibles, GrupoEmpleados, Costo).




