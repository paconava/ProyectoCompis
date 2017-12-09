%{ 
    #define INT 0
    #define FLOAT 1
    #define DOUBLE 2
    #define CHAR 3
    #define VOID 4
    #define STRUCT 5
    #include <stdio.h> 
    #include <string.h>
	#include <unistd.h>
	#include <stdlib.h>
	#include "tablas.h"

    int yylex(void); 
    void yyerror(char *); 
    int yylineno;
    int tipo_global = INT; // Cambia cuando se reduce a "T"

	int TS_tam = 0; // Tamanio TS, usado provisionalmente en lo que se implementa la TS
	int TT_tam = STRUCT + 1; // Tambien provisional, se entiende que la TT inicia con los tipos basicos ya dentro
	int T_pos = 5;
	int dir = 0; // Para la TS, habra que ver como manejarlo cuando se tenga una TS para cada funcion
	int dirTmp = 0; // Para la TS, habra que ver como manejarlo cuando se tenga una TS para cada funcion
	int pos = 0; // Para la TS, habra que ver como manejarlo cuando se tenga una TS para cada funcion
	int posTmp = 0; // Para la TS, habra que ver como manejarlo cuando se tenga una TS para cada funcion
	char TS_nombre[25]; // Nombre de la TS que se este usando al momento de insertar, para simular el cambio de TS cuando se entra en una funcion
	struct tabla_tipos **t_tipos[10], e_tipos[10], *b_tipo[10];
	struct tabla_simbolos **t_sim[10], e_sim[10], *b_sim[10];
	int abst = 0; // Nivel de abstracción para tablas
%} 

%union{

	struct{
		int tipo;
	} tipo_D;

	struct{
		int dim; // Hasta ahora lo ignoro, aunque quizas se use en T -> struct{D}
		int tipo;
	}tipo_T;

	struct{
		int tipo;
		int base; // como es un atributo heredado, he preferido no usarla por mientras
	}tipo_L;

	struct{
		int tipo;
		int base; // no usado por ahora
		int dim;
	}tipo_C;

	struct{
		int tipo; // Creo que se puede prescindir de esto
	}tipo_F;

	struct{
		char lista[100]; // Cambiar por una lista (ligada?) de Tipos (enteros)
	}tipo_A;

	struct{
		int tipo;
		char dir[2];
		char codigo[2]; // Ver como manejar codigo
	}tipo_E;


	struct{
		int tipo;
		char dir[2];
		char codigo[2]; // Ver como manejar codigo
	}tipo_U;

	struct{
		char* nombre;
	}id_atribs;

	struct{
		int numero;
	}num_int;
}

%token TIPO_INT TIPO_FLOAT TIPO_DOUBLE TIPO_CHAR TIPO_VOID TIPO_STRUCT TIPO_FUNC
%token<id_atribs> ID
%token<num_int> INDICE_DEC

%type<tipo_D> D
%type<tipo_T> T
%type<tipo_L> L
%type<tipo_C> C
%type<tipo_F> F
%type<tipo_A> A
%type<tipo_A> G
%type<tipo_E> E
%type<tipo_U> U

%%
P:	{
	strcpy(TS_nombre, "Global"); printf("> Se esta usando la TS %s\n", TS_nombre);
	
	t_tipos[0] = crear_TT();
	t_sim[0] = crear_TS();
	
	e_tipos[0].posicion = INT;
	strcpy(e_tipos[0].tipo, "int");
	e_tipos[0].tipo_base = -1;
	e_tipos[0].dimension = 4;
	agregar_TT(t_tipos[0], e_tipos[0]);
	memset(&e_tipos[0], 0, sizeof (e_tipos[0]));

	e_tipos[0].posicion = FLOAT;
	strcpy(e_tipos[0].tipo, "float");
	e_tipos[0].tipo_base = -1;
	e_tipos[0].dimension = 4;
	agregar_TT(t_tipos[0], e_tipos[0]);
	memset(&e_tipos[0], 0, sizeof (e_tipos[0]));

	e_tipos[0].posicion = DOUBLE;
	strcpy(e_tipos[0].tipo, "double");
	e_tipos[0].tipo_base = -1;
	e_tipos[0].dimension = 8;
	agregar_TT(t_tipos[0], e_tipos[0]);
	memset(&e_tipos[0], 0, sizeof (e_tipos[0]));

	e_tipos[0].posicion = CHAR;
	strcpy(e_tipos[0].tipo, "char");
	e_tipos[0].tipo_base = -1;
	e_tipos[0].dimension = 1;
	agregar_TT(t_tipos[0], e_tipos[0]);
	memset(&e_tipos[0], 0, sizeof (e_tipos[0]));

	e_tipos[0].posicion = VOID;
	strcpy(e_tipos[0].tipo, "void");
	e_tipos[0].tipo_base = -1;
	e_tipos[0].dimension = 0;
	agregar_TT(t_tipos[0], e_tipos[0]);
	memset(&e_tipos[0], 0, sizeof (e_tipos[0]));

	}D F{printf("r1\n");} // Aqui se debe de iniciar utilizando la Global
	;
 
D:
	T L ';' D 	{printf("r2.1\n");
			 $$.tipo = $2.tipo;}
	| 	 	{printf("r2.2\n");}
	;

T:
	TIPO_INT	{printf("r3.1\n");
			$$.tipo = INT;
			tipo_global = INT;} // Aprovechar aqui para insertar en tabla de tipos??
	| TIPO_FLOAT 	{printf("r3.2\n");
			$$.tipo = FLOAT;
			tipo_global = FLOAT;}
	| TIPO_DOUBLE	{printf("r3.3\n");
			$$.tipo = DOUBLE;
			tipo_global = DOUBLE;}
	| TIPO_CHAR	{printf("r3.4\n");
			$$.tipo = CHAR;
			tipo_global = CHAR;}
	| TIPO_VOID	{printf("r3.5\n");
			$$.tipo = VOID;
			tipo_global = VOID;}
	| TIPO_STRUCT	{printf("r3.6\n");
			$$.tipo = STRUCT;
			tipo_global = STRUCT;}
	;

L:
	L ',' ID C 	{printf("r4.1\n");
				$$.tipo = $4.tipo;
				if((busqueda_por_lexema(t_sim[abst], $3.nombre)) == NULL){
					e_sim[abst].posicion = pos;
					strcpy(e_sim[abst].lexema, $3.nombre);
					e_sim[abst].tipo = $$.tipo;
					e_sim[abst].tipoVar = var;
					e_sim[abst].dir = dir;
					agregar_TS(t_sim[abst], e_sim[abst]);
					memset(&e_sim[abst], 0, sizeof (e_sim[abst]));
					printf("> Insertar en TS de '%s' #%d:\n", TS_nombre, ++TS_tam); // Se simula que se inserta un nuevo simbolo
					printf(" - Nombre:%s, Tipo:%d, var, Dir:%d, NArgs: -1, TArgs: -1\n", $3.nombre, $$.tipo, dir);
					dir+=calculo_dimension(t_tipos[abst], $$.tipo); // Debera ser += la dimension del tipo en cuestion}
					pos++;
				}else{
					yyerror("Error de sintaxis");
					printf(" en línea %d:\n", yylineno);
					printf("La variable '%s' ya existe\n", $3.nombre);
					exit(0);
				}
			}
	| ID C 			{printf("r4.2\n");
				$$.tipo = $2.tipo;
				if((busqueda_por_lexema(t_sim[abst], $1.nombre)) == NULL){
					e_sim[abst].posicion = pos;
					strcpy(e_sim[abst].lexema, $1.nombre);
					e_sim[abst].tipo = $$.tipo;
					e_sim[abst].tipoVar = var;
					e_sim[abst].dir = dir;
					agregar_TS(t_sim[abst], e_sim[abst]);
					memset(&e_sim[abst], 0, sizeof (e_sim[abst]));
					printf("> Insertar en TS de '%s' #%d:\n", TS_nombre, ++TS_tam); // Se simula que se inserta un nuevo simbolo
					//printf(" - Nombre:%s, Tipo:%d, var, Dir:%d, NArgs: -1, TArgs: -1\n", $1.nombre, $$.tipo, dir);

					dir+=calculo_dimension(t_tipos[abst], $$.tipo); // Debera ser += la dimension del tipo en cuestion
					pos++;
				}else{
					yyerror("Error de sintaxis");
					printf(" en línea %d:\n", yylineno);
					printf("La variable '%s' ya existe\n", $1.nombre);
					exit(0);
				}
			}
	;

C:
	'[' INDICE_DEC ']' C	{printf("r5.1\n");
				// Esta parte cambia mucho si el tipo ya existe, asumo que no
				printf("> Insertar TT #%d", ++TT_tam); // Se simula que se inserta un nuevo tipo
				$$.tipo = $4.tipo; // Si el tipo ya existia, en realidad se asigna el tipo ya existente
				e_tipos[abst].posicion = ++T_pos;
				strcpy(e_tipos[abst].tipo, "array");
				e_tipos[abst].tipo_base = $4.tipo;
				e_tipos[abst].dimension = $2.numero;

				agregar_TT(t_tipos[abst], e_tipos[abst]);
				memset(&e_tipos[abst], 0, sizeof (e_tipos[abst]));
				
				printf(" - array, TipoBase:%d, Dim:%d\n", $4.tipo, $2.numero);
				$$.dim = $2.numero;
				}
	|			{printf("r5.2\n");
				$$.tipo = tipo_global;}
	;


F:
	TIPO_FUNC T ID {// Parece que aqui se debe de insertar para permitir recursion y para que las funciones se inserten
			// en el orden en que son declaradas
			//$$.tipo = tipo_global; // Al parecer esto es invalido hasta que F se haya reducido (final de la regla)
			// Ademas de que no funciona si el tipo global cambia dentro de A
			printf("> Insertar en TS de 'Global' #%d:\n", ++TS_tam); // Insertar en TS Global de momento sin los atributos de A
			if((busqueda_por_lexema(t_sim[abst], $3.nombre)) == NULL){
					e_sim[abst].posicion = pos;
					strcpy(e_sim[abst].lexema, $3.nombre);
					e_sim[abst].tipo = tipo_global;
					e_sim[abst].tipoVar = func;
					e_sim[abst].dir = dir;

					dir+=calculo_dimension(t_tipos[abst], tipo_global); // Debera ser += la dimension del tipo en cuestion}
					pos++;
			}else{
					yyerror("Error de sintaxis");
					printf(" en línea %d:\n", yylineno);
					printf("La variable '%s' ya existe\n", $3.nombre);
					exit(0);
			}
		}
			//printf(" - Nombre:%s, Tipo:%d, func, Dir:-1, NArgs: A.tam, TArgs: A.lista\n", $3.nombre, tipo_global);}
	'('A')'		{
					printf("> Crear nueva TS para funcion '%s'\n", $3.nombre);
					dirTmp = dir;
					posTmp = pos;
					dir = 0;
					pos = 0;
					++abst;
					t_sim[abst] = crear_TS();
					t_tipos[abst] = crear_TT();
					strcpy(TS_nombre, $3.nombre);
					printf("> Se empezara usar la TS de %s\n", TS_nombre);
					TS_tam = 0;
					printf("> Actualizar TS global con la lista de tipos de A:\n - %s\n", $6.lista);
					e_sim[abst-1].nargs = strlen($6.lista);
					e_sim[abst-1].tipo_args = crear_lista_param();
					for(int i=0;i<strlen($6.lista);i++)
						agregar_lista_param(e_sim[abst-1].tipo_args, ((int)($6.lista[i])-48));
					agregar_TS(t_sim[abst-1], e_sim[abst-1]);
					memset(&e_sim[abst-1], 0, sizeof (e_sim[abst-1]));
				}
	'{'D S'}'';'	{
						printf("> Destruir TS de '%s' antes de crear nueva funcion\n", TS_nombre);
						destruir_TS(t_sim[abst]);
						destruir_TT(t_tipos[abst]);
						--abst;
						dir = dirTmp;
						pos = posTmp;
					}
	 F		{// HASTA AQUI SE ACABA LA DECLARACION DE FUNCIONES (r6.1)
			printf("r6.1\n");}
	|		{printf("r6.2\n");}
	;

A:	G		{printf("r7.1\n");
			strcpy($$.lista,$1.lista);}
	|		{printf("7.2\n");
			strcpy($$.lista, "no hay params");}
	;

G:
	G ',' T ID	{// FALTA CONSIDERAR EL NO TERMINAL "I"
			printf("r8.1\n");
			strcpy($$.lista, $1.lista);
			char aux[2]; // Solo se usa en lo que se implementa la lista de A
			sprintf(aux,"%d",$3.tipo);			
			strcat($$.lista, aux);}
	| T ID		{printf("r8.2\n");
			char aux[2]; // Solo se usa en lo que se implementa la lista de A
			sprintf(aux,"%d",$1.tipo);			
			strcpy($$.lista, aux);}
	;

S:
	U '=' E	';'	{printf("r10.7\n");}
	|		{printf("r10.X\n");} // En la gramatica no se define S -> epsilon, pero aqui lo pongo para debugear
	;

U:
	ID		{printf("r13.1\n");
			printf("> Verificar que el id '%s' este en la TS de '%s'\n", $1.nombre, TS_nombre);}
	;

E:	E '+' E		{printf("r15.1\n");}
	| U		{printf("r15.6\n");}
	;
%% 
void yyerror(char *s) { 
    fprintf(stderr, "%s", s); 
}
 
extern FILE *yyin;

int main(int argc, char** argv){
	if(argc > 1){
		yyin = fopen(argv[1], "r");
	}
	yyparse();

	// Debug de tablas
	printf("\n\n");
	imprimir_TT(t_tipos[0]);
	imprimir_TS(t_sim[0]);
	return 0;
}

struct tabla_simbolos **crear_TS (void){
	struct tabla_simbolos **novo;
	novo = (struct tabla_simbolos **) calloc (1, sizeof(struct tabla_simbolos *));
	*novo = NULL;
	return novo;
}

void agregar_TS (struct tabla_simbolos **TS, const struct tabla_simbolos nuevo){
	struct tabla_simbolos *reg = *TS;
	
	if(reg != NULL){
		for(; reg->next != NULL; reg = reg->next);
		reg->next = (struct tabla_simbolos *) calloc (1, sizeof(struct tabla_simbolos));
		reg = reg->next;
	}
	else{
		*TS = (struct tabla_simbolos *) calloc (1, sizeof(struct tabla_simbolos));
		reg = *TS;
	}
	
	memcpy(reg, &nuevo, sizeof(struct tabla_simbolos));
	reg->next = NULL; //nos aseguramos que el próximo elemento se inserte después de éste
}

	
struct tabla_tipos **crear_TT (void){
	struct tabla_tipos **novo;
	novo = (struct tabla_tipos **) calloc (1, sizeof(struct tabla_tipos *));
	*novo = NULL;
	return novo;
}

void agregar_TT (struct tabla_tipos **TT, const struct tabla_tipos nuevo){
	struct tabla_tipos *reg = *TT;
	
	if(reg != NULL){
		for(; reg->next != NULL; reg = reg->next);
		reg->next = (struct tabla_tipos *) malloc (sizeof(struct tabla_tipos));
		reg = reg->next;
	}
	else{
		*TT = (struct tabla_tipos *) malloc (sizeof(struct tabla_tipos));
		reg = *TT;
	}
	
	memcpy(reg, &nuevo, sizeof(struct tabla_tipos));
	reg->next = NULL;
}

struct lista_tipo_args **crear_lista_param (void){
	struct lista_tipo_args **novo;
	novo = (struct lista_tipo_args **) calloc (1, sizeof(struct tabla_tipos *));
	*novo = NULL;
	return novo;
}

void agregar_lista_param (struct lista_tipo_args ** lista_param, const int tipo){
	struct lista_tipo_args *reg = *lista_param;
	
	if(reg != NULL){
		for(; reg->next != NULL; reg = reg->next);
		reg->next = (struct lista_tipo_args *) malloc (sizeof(struct lista_tipo_args));
		reg = reg->next;
	}
	else{
		*lista_param = (struct lista_tipo_args *) malloc (sizeof(struct lista_tipo_args));
		reg = *lista_param;
	}
	
	reg->tipo = tipo;
	reg->next = NULL;
}

struct tabla_simbolos *busqueda_por_lexema (struct tabla_simbolos **TS, const char *lexema){
	struct tabla_simbolos *reg = *TS;
	

	for(; reg != NULL; reg = reg->next){
		if(strcmp(reg->lexema, lexema) == 0)
			return reg;
	}
	
	return NULL;
}

struct tabla_tipos *busqueda_por_posicion_TT (struct tabla_tipos **TT, const int pos){
	struct tabla_tipos *reg = *TT;
	
	for(; reg != NULL; reg = reg->next){
		if(reg->posicion == pos)
			return reg;
	}

	return NULL;
}

void destruir_TT (struct tabla_tipos **TT){
	struct tabla_tipos *reg = *TT, *borrar = *TT;
	
	if(reg != NULL){
		
		do{
			reg = reg->next;
			free(borrar);
			borrar = reg;
		}while(reg != NULL);
	}
}

void destruir_lista_param (struct lista_tipo_args **lista_param){
	struct lista_tipo_args *reg = *lista_param, *borrar = *lista_param;
	
	if(reg != NULL){
		
		do{
			reg = reg->next;
			free(borrar);
			borrar = reg;
		}while(reg != NULL);
	}
}

void destruir_TS (struct tabla_simbolos **TS){
	struct tabla_simbolos *reg = *TS, *borrar = *TS;
	
	if(reg != NULL){
		
		do{
			reg = reg->next;
			if(borrar->tipoVar == func)
				destruir_lista_param(borrar->tipo_args);
			free(borrar);
			borrar = reg;
		}while(reg != NULL);
	}
}




int calculo_dimension (struct tabla_tipos **TT, int pos){
	struct tabla_tipos *reg;
	int dimension = 1;
	
	do{
		if((reg = busqueda_por_posicion_TT(TT, pos)) == NULL)
			return -1;
		dimension *= reg->dimension;
		pos = reg->tipo_base;
	}while(pos != -1);
	
	return dimension;
}


void imprimir_lista_param (struct lista_tipo_args **lista_param){
	struct lista_tipo_args *reg = *lista_param;

	if(reg != NULL){
		printf("Tipos de argumentos: ");
		for(; reg != NULL; reg = reg->next)
			printf("%d ", reg->tipo);
		printf("\n");
	}
}

void imprimir_TS (struct tabla_simbolos **TS){
	struct tabla_simbolos *reg = *TS;

	printf("Tabla de simbolos\n");
	for(; reg != NULL; reg = reg->next){
		if(reg->tipoVar == func){
			printf("Posición: %d, Lexema: %s, Tipo: %d, Tipo variable: func, "
				"Número de argumentos: %d\n", reg->posicion, reg->lexema, reg->tipo,
				reg->nargs);
			imprimir_lista_param(reg->tipo_args);
		}
		else
			printf("Posición: %d, Lexema: %s, Tipo: %d, Tipo variable: %s, "
				"Dirección: %d\n", reg->posicion, reg->lexema, reg->tipo,
				(reg->tipoVar == var)? "var" : "param", reg->dir);
	}
}

void imprimir_TT (struct tabla_tipos **TT){
	struct tabla_tipos *reg = *TT;
	
	printf("Tabla de tipos\n");
	for(; reg != NULL; reg = reg->next)
			printf("Posición: %d, Tipo: %s, Tipo base: %d, Dimensión: %d\n",
				reg->posicion, reg->tipo, reg->tipo_base, reg->dimension);	
}

