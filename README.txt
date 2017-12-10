# ProyectoCompis
Compilador de subconjunto de C a MIPS

## Compilar y correr

Se compila y corre asi:

yacc -d prueba.y

lex prueba.l

cc lex.yy.c y.tab.c -o prueba

./prueba p.txt


## Explicacion de Salida
- Con la entrada p.txt, deberia obtenerse la siguiente salida.
- Se resalta la creacion de funciones, y que ellas se insertan a la TS global en el orden en el que son declaradas en el .txt de entrada
- Tambien se imprime el lugar donde se realiza el cambio de TS
- Se imprime que las variables se añaden en la TS correspondiente
- La lista de argumentos de A, por el momento, es una simple cadena. En este ejemplo se obtiene que la lista A de funcion1 es '001' pues los parametros de dicha funcion son de tipo int int y float.
- En las reglas que producen "c = a + perro" se verifica que c, a y perro se encuentran en la TS correspondiente
- Se imprime la regla r# cuando se reduce dicha regla; en general se pueden ignorar esas lineas de salida, pero son utiles para comprender el orden en que yacc ejecuta las cosas

--------------------------------------------------- Salida:
> Se esta usando la TS Global
r3.1
r5.2
r5.1
> Insertar TT #7 - array, TipoBase:0, Dim:5
r5.1
> Insertar TT #8 - array, TipoBase:6, Dim:3
r5.1
> Insertar TT #9 - array, TipoBase:7, Dim:2
r4.2
> Insertar en TS de 'Global' #1:
r5.2
r5.1
> Insertar TT #10 - array, TipoBase:0, Dim:1
r4.1
> Insertar en TS de 'Global' #2:
 - Nombre:hola2, Tipo:9, var, Dir:120, NArgs: -1, TArgs: -1
r5.2
r5.1
> Insertar TT #11 - array, TipoBase:0, Dim:9
r4.1
> Insertar en TS de 'Global' #3:
 - Nombre:enfin, Tipo:10, var, Dir:124, NArgs: -1, TArgs: -1
r3.1
r5.2
r4.2
> Insertar en TS de 'Global' #4:
r3.3
r5.2
r4.2
> Insertar en TS de 'Global' #5:
r3.4
r5.2
r4.2
> Insertar en TS de 'Global' #6:
r3.2
r5.2
r4.2
> Insertar en TS de 'Global' #7:
r2.2
r2.1
r2.1
r2.1
r2.1
r2.1
r3.1
> Insertar en TS de 'Global' #8:
r3.1
r8.2
r3.1
r8.1
r3.2
r8.1
r7.1
> Crear nueva TS para funcion 'funcion1'
> Se empezara usar la TS de funcion1
> Actualizar TS global con la lista de tipos de A:
 - 001
r3.1
r5.2
r4.2
> Insertar en TS de 'funcion1' #1:
r3.1
r5.2
r4.2
> Insertar en TS de 'funcion1' #2:
r2.2
r2.1
r2.1
r10.X
> Destruir TS de 'funcion1' antes de crear nueva funcion
r3.2
> Insertar en TS de 'Global' #3:
r3.2
r8.2
r3.2
r8.1
r3.1
r8.1
r7.1
> Crear nueva TS para funcion 'funcion2'
> Se empezara usar la TS de funcion2
> Actualizar TS global con la lista de tipos de A:
 - 110
r3.1
r5.2
r4.2
> Insertar en TS de 'funcion2' #1:
r3.2
r5.2
r4.2
> Insertar en TS de 'funcion2' #2:
r2.2
r2.1
r2.1
r13.1
> Verificar que el id 'c' este en la TS de 'funcion2'
r13.1
> Verificar que el id 'a' este en la TS de 'funcion2'
r15.6
r13.1
> Verificar que el id 'perro' este en la TS de 'funcion2'
r15.6
r15.1
r10.7
> Destruir TS de 'funcion2' antes de crear nueva funcion
r6.2
r6.1
r6.1
r1


Tabla de tipos
Posición: 0, Tipo: int, Tipo base: -1, Dimensión: 4
Posición: 1, Tipo: float, Tipo base: -1, Dimensión: 4
Posición: 2, Tipo: double, Tipo base: -1, Dimensión: 8
Posición: 3, Tipo: char, Tipo base: -1, Dimensión: 1
Posición: 4, Tipo: void, Tipo base: -1, Dimensión: 0
Posición: 6, Tipo: array, Tipo base: 0, Dimensión: 20
Posición: 7, Tipo: array, Tipo base: 6, Dimensión: 60
Posición: 8, Tipo: array, Tipo base: 7, Dimensión: 120
Posición: 9, Tipo: array, Tipo base: 0, Dimensión: 4
Posición: 10, Tipo: array, Tipo base: 0, Dimensión: 36
Tabla de simbolos
Posición: 0, Lexema: arreglo29, Tipo: 8, Tipo variable: var, Dirección: 0
Posición: 1, Lexema: hola2, Tipo: 9, Tipo variable: var, Dirección: 120
Posición: 2, Lexema: enfin, Tipo: 10, Tipo variable: var, Dirección: 124
Posición: 3, Lexema: var1, Tipo: 0, Tipo variable: var, Dirección: 160
Posición: 4, Lexema: var2, Tipo: 2, Tipo variable: var, Dirección: 164
Posición: 5, Lexema: var3, Tipo: 3, Tipo variable: var, Dirección: 172
Posición: 6, Lexema: var4, Tipo: 1, Tipo variable: var, Dirección: 173
Posición: 7, Lexema: funcion1, Tipo: 0, Tipo variable: func, Número de argumentos: 3
Tipos de argumentos: 0 0 1 
Posición: 8, Lexema: funcion2, Tipo: 1, Tipo variable: func, Número de argumentos: 3
Tipos de argumentos: 1 1 0 
