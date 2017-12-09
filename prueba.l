%{ 
    #include <stdlib.h> 
    void yyerror(char *); 
    #include "y.tab.h" 
%} 
%x comentario
%%

"/*" {BEGIN(comentario) ; }
<comentario>"*/" {BEGIN(INITIAL) ; }
<comentario>.|[ \n\t] {}

"int" {return TIPO_INT;}

"float" {return TIPO_FLOAT;}

"func" {return TIPO_FUNC;}
 
[a-z][a-z0-9]*	{ 
			yylval.id_atribs.nombre = strdup(yytext);                
			return ID; 
            	}

[1-9]+[0-9]*	{
			yylval.num_int.numero = atoi(yytext);
			return INDICE_DEC; // Para indice al declarar arreglos
	     	}

[;,\[\](){}=+]	return *yytext;
[ \n]	;
    
.         yyerror("Error Lexico - Caracter no valido"); 

%% 
int yywrap(void) { 
    return 1; 
} 
