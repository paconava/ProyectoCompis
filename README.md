# ProyectoCompis
Compilador de subconjunto de C a MIPS

## Compilar y correr

Se compila y corre asi:

yacc -d prueba2.y
lex prueba2.l
cc lex.yy.c y.tab.c -oprueba2
./prueba2 p.txt


## Explicacion de Salida
- Con la entrada p.txt, deberia obtenerse la siguiente salida.
- Se resalta la creacion de funciones, y que ellas se insertan a la TS global en el orden en el que son declaradas en el .txt de entrada
- Tambien se imprime el lugar donde deberiamos realizar el cambio de TS
- Se imprime que las variables se añaden en la TS correspondiente
- La lista de argumentos de A, por el momento, es una simple cadena. En este ejemplo se obtiene que la lista A de funcion1 es '001' pues los parametros de dicha funcion son de tipo int int y float.
- De momento en la reglas que producen "c = a + b" solamente imprimo que se debe verificar que c, a y b se encuentran en la TS correspondiente
- Se imprime la regla r# cuando se reduce dicha regla; en general se pueden ignorar esas lineas de salida, pero son utiles para comprender el orden en que yacc ejecuta las cosas

--------------------------------------------------- Salida:
> Se esta usando la TS Global
r3.1
r5.2
r5.1
> Insertar TT #3 - array, TipoBase:0, Dim:4
r5.1
> Insertar TT #4 - array, TipoBase:3, Dim:3
r4.2
> Insertar en TS de 'Global' #1:
 - Nombre:arreglo29, Tipo:4, var, Dir:1, NArgs: -1, TArgs: -1
r5.2
r5.1
> Insertar TT #5 - array, TipoBase:0, Dim:1
r4.1
> Insertar en TS de 'Global' #2:
 - Nombre:hola2, Tipo:5, var, Dir:2, NArgs: -1, TArgs: -1
r5.2
r5.1
> Insertar TT #6 - array, TipoBase:0, Dim:9
r4.1
> Insertar en TS de 'Global' #3:
 - Nombre:enfin, Tipo:6, var, Dir:3, NArgs: -1, TArgs: -1
r2.2
r2.1
r3.1
> Insertar en TS de 'Global' #4:
 - Nombre:funcion1, Tipo:0, func, Dir:-1, NArgs: A.tam, TArgs: A.lista
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
 - Nombre:a, Tipo:0, var, Dir:4, NArgs: -1, TArgs: -1
r3.1
r5.2
r4.2
> Insertar en TS de 'funcion1' #2:
 - Nombre:b, Tipo:0, var, Dir:5, NArgs: -1, TArgs: -1
r2.2
r2.1
r2.1
r10.X
> Destruir TS de 'funcion1' antes de crear nueva funcion
r3.2
> Insertar en TS de 'Global' #3:
 - Nombre:funcion2, Tipo:1, func, Dir:-1, NArgs: A.tam, TArgs: A.lista
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
 - Nombre:a, Tipo:0, var, Dir:6, NArgs: -1, TArgs: -1
r3.2
r5.2
r4.2
> Insertar en TS de 'funcion2' #2:
 - Nombre:c, Tipo:1, var, Dir:7, NArgs: -1, TArgs: -1
r2.2
r2.1
r2.1
r13.1
> Verificar que el id 'c' este en la TS de 'funcion2'
r13.1
> Verificar que el id 'a' este en la TS de 'funcion2'
r15.6
r13.1
> Verificar que el id 'b' este en la TS de 'funcion2'
r15.6
r15.1
r10.7
> Destruir TS de 'funcion2' antes de crear nueva funcion
r6.2
r6.1
r6.1
r1


