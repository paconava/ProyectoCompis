#ifndef TABLAS_H
#define TABLAS_H

#define TAM_NOMBRE_MAX 200 //tamaño máximo del nombre de una variable
#define TIPO_MAX 50 //tamaño máximo del nombre de tipo de dato


struct lista_tipo_args {
	int tipo;
	struct lista_tipo_args *next;
};


struct tabla_simbolos {
	int posicion;
	char lexema[TAM_NOMBRE_MAX];
	int tipo;
	enum tipo {var, func, param} tipoVar;
	int dir;
	int nargs;
	struct lista_tipo_args **tipo_args;
	struct tabla_simbolos *next;
};

struct tabla_tipos {
	int posicion;
	char tipo[TIPO_MAX];
	int tipo_base;
	int dimension;
	struct tabla_tipos *next;
};

struct tabla_simbolos **crear_TS (void);
void agregar_TS (struct tabla_simbolos **TS, const struct tabla_simbolos nuevo);
struct tabla_tipos **crear_TT (void);
void agregar_TT (struct tabla_tipos **TT, const struct tabla_tipos nuevo);
struct lista_tipo_args **crear_lista_param (void);
void agregar_lista_param (struct lista_tipo_args ** lista_param, const int tipo);
struct tabla_simbolos *busqueda_por_lexema (struct tabla_simbolos **TS, const char *lexema);
struct tabla_tipos *busqueda_por_posicion_TT (struct tabla_tipos **TT, const int pos);
void destruir_TT (struct tabla_tipos **TT);
void destruir_lista_param (struct lista_tipo_args **lista_param);
void destruir_TS (struct tabla_simbolos **TS);
int calculo_dimension (struct tabla_tipos **TT, int pos);
int get_dimension (struct tabla_tipos **TT, int pos);
void imprimir_lista_param (struct lista_tipo_args **lista_param);
void imprimir_TS (struct tabla_simbolos **TS);
void imprimir_TT (struct tabla_tipos **TT);

#endif
