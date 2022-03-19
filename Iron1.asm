;PROYECTO 1 ARQUITECTURA DEL COMPUTADOR JUEGO IRON MAN
 ;PROYECTO DE ARQUITECTURA DEL COMPUTADOR 1 GRUPO 4
.MODEL SMALL
.STACK 100
.DATA

;---------------------------------------------------------------------------

FINISH db "TERMINO EL JUEGO" ;STRING que muestra donde termina el juego
FINJUEGO db ' '	;Una cadena de ayuda utilizada para calcular el juego sobre la longitud del mensaje FINJUEGO - offset FINISH = longitud del masaje
gano1   db      "Jugador 1 gano" , '$' ;Muestra que el jugador número 1 gano
gano2   db      "Jugador 2 gano" , '$' ;Muestra que el jugador número 2 gano
ganador Db 0d	;se usa para saber quien es el ganador, 1 o 2, si 0, nadie gano, la variable se verifica despues de cada choque de las balas
					;se usar return para regresar
					
JuegoNivel DB ?	;escoger que nivel quiere jugar 
vida1 DB ?	;vida del jugador 1
vida2 DB ? 	;vida del jugador 2
arma1 DB ? 	;arma del jugador 1
arma2 DB ?	;arma del jugador 2
NIVELES DB "ESCOGER NIVEL QUE QUIERES JUGAR (PRESIONAR 1, 2, o 3)",'$' 	;seleccion para elegir un nivel
NVL1 DB "Nivel 1",'$' 	;escogio el nivel 1
NVL2 DB "Nivel 2",'$'	;escogio el nivel 2
NVL3 DB "Nivel 3",'$'	;escogio el nivel 3
NombreJugador DB 15 DUP(?),'$'	;Nombre del jugador en un espacio de 15 bytes    
;Jugador 2
IngresaNombre DB "INGRESA TU NOMBRE ",0Dh,0Ah,09h, '$' 	;Ingresar el nombre
PresionarEnter DB "PRESIONE ENTER PARA CONTINUAR";INGRESAR ENTER PARA AVANZAR EN EL PROGRAMA
FinPresionarEnter DB '$' 	;Continuar 
msg1    db      "PROYECTO ARQUITECTURA DEL COMPUTADOR 1, LANDIVAR " , '$' 	;Mensaje que aparece para ingresar al juego
msg2	    db      "Elija una opcion", '$'	;Segundo mensaje del juego
msg3	    db      "PRESIONAR F2 PARA JUGAR ", '$'	;ENTRA A LOS NIVELES DE JUEGO
msg4	    db      "PRESIONAR ESC PARA SALIR", '$'	;SALIR
msg0 db      "GRACIAS POR EL JUEGO, PRESIONAR SUPR PARA SALIR",0Dh,0Ah,09h, '$'	;MENSAJE PARA SALIR DEL JUEGO


Ancho_Ventana DW 140h				;ancho de la ventana 
Alto_Ventana DW 150d				;alto de la ventana
Limite DW 6d					;verificar las colisiones de las balas para tener un limite al ser tiradas y el 6 esta bien si no se cambia la velocidad de las balas
										

;------------------------------------TIEMPOS

TiempoAux DB 0 						;Verifica si el tiempo no ha cambiado
TiempoAuxSeg DB 0					;Da 5 segundos para salir del juego cuando termino o cuando alguien se queda sin vidas
MuestraSegundos DB 0					;verifica si ya pasaron los 5 segundos cuando termino el juego y muestra el ganador

;------------------------------------TIROS
Tiro1 DB 1						;Tiros del jugador 1, solo puede tirar uno hasta que llegue alfinal o pegue
Tiro2 DB 1						;Tiros del jugador 1, solo puede tirar uno hasta que llegue alfinal o pegue
VariosTiros DB 0				;hay una opcion donde tira mas de tiro el jugador

;OPCIONES QUE APARECEN EN EL JUEGO
CheckearPotenciador DB 6d  			; 6=Nada, 5 = Meteteoritos, 4 = Vida, 3 = Armas, 2 = Velocidad , 1= Congelacion , 0 = DisparosMultiples
ActivarPoder DB 6d					; 6=Nada, 5 = Meteteoritos, 4 = Vida, 3 = Armas, 2 = Velocidad , 1= Congelacion , 0 = DisparosMultiples
TempPoder DB 0						;resetear el disparo
PotenciaColisicion DB 0				;colision de las balas

;DISPAROOS O BALAS DEL JUEGO

Disparo1_X DW 0Ah 			        	;posicion en x de la bala del jugador 1
Disparo1_Y DW 30d 			        	;posicion en y de la bala del jugador 1

Disparo2_X DW 278d 					;posicion en x de la bala del jugador 2
Disparo2_Y DW 119D 					;posicion en y de la bala del jugado 2

;TIROS MULTIPLES

DisparoM1_X DW 0A0h				        ;posicion de las multibalas del jugador 1 en x
DisparoM1_Y DW 64h 			        	;posicion de las multibalas del jugador 1 en y
DisparoM2_X DW 0Ah 						;posicion de las multibalas del jugador 2 en x
DisparoM2_Y DW 0Ah 						;posicion de las multibalas del jugador 2 en y
MultiDisparo DB 0						;esto es una variable cuando el jugador agarra un item de multidisparo
DisparoM_VelocidadX1 DW 4d				; Velocidad en x de las multibalas jugador 1
DisparoM_VelocidadX2 DW 4d				; Velocidad en y de las multibalas jugador 1
DisparoM_VelocidadY1 DW 4d				; Velocidad en x de las multibalas jugador 2
DisparoM_VelocidadY2 DW 4d				; Velocidad en y de las multibalas jugador 2



TamanoBalas DW 08h						;size of the bullet (how many pixels does the bullet have) w x h
VelocidadBala_X DW 6d 				;X velocidad de la bala
VelocidadBala_X2 DW 6d 				;Y velovidad de la bala


;JUGADOR 1 izquierdo 
POSX DW 0d					;posicion en el lado izquierdo del iron man
POSY DW 0Ah 				;posiion en medio del lado izquierdo del iron man
VIEJAPOSX DW ?					;posicion antigua x
VIEJAPOSY DW ?					;posicion antigua Y

;JUGADOR 2 derecho
POS_DERECHOX DW 280d 				;posicion en el lado derecho del iron man
POS_DERECHOY DW 100D 				;posicion en medio en el lado derecho del iron man
OLDPOS_DERECHOX DW ?				;posicion antigua x
OLDPOS_DERECHOY DW ?				;posicion antigua y

;PINTAR LOS IRON MANS Y LAS COLISIONES QUE SE TIENEN
TempAncho DW 40d					;ancho del iron en x horizontal
TempAlto DW 40d				;ancho del iron en y vertical

;velocidad de los jugadores
RapidezY1 DW 8h 				
RapidezY2 DW 8h			

;Armadura 
MaxArmadura DB 0   ;nivel de la armadura maxima que se puede tener
Presionar_F4 DB "F4 SALIR"	;SALIR CON F4 EN EL JUEGO


;empezamos a pintar el iron man con excel para facilitar la pintada
IronMan DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	00,	00,	00,	00,	00,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	04,	04,	04,	04,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	04,	04,	04,	04,	04,	04,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	04,	04,	14,	14,	14,	04,	04,	14,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	04,	14,	14,	14,	14,	14,	14,	14,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	14,	14,	14,	14,	14,	14,	14,	14,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	14,	14,	03,	03,	14,	14,	14,	03,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	22,	14,	14,	03,	03,	14,	03,	03,	00,	15,	15,	15,	15,	15,	15,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	14,	14,	14,	14,	14,	14,	14,	00,	15,	15,	15,	15,	15,	00,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	00,	00,	00,	00,	04,	22,	14,	00,	00,	00,	14,	00,	00,	00,	00,	00,	00,	00,	04,	00,	04,	03,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	00,	00,	14,	22,	22,	22,	00,	04,	04,	14,	14,	14,	00,	22,	14,	14,	14,	22,	22,	04,	00,	04,	03,	03,	03,	03,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	00,	22,	14,	14,	22,	22,	22,	04,	00,	00,	00,	00,	00,	22,	22,	22,	14,	14,	22,	04,	03,	00,	04,	15,	15,	03,	03,	03,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	00,	22,	22,	22,	14,	14,	22,	04,	04,	04,	04,	04,	04,	04,	04,	22,	14,	14,	22,	22,	04,	04,	00,	04,	03,	03,	03,	03,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	00,	04,	04,	22,	22,	22,	00,	00,	22,	04,	04,	03,	04,	04,	22,	00,	00,	00,	00,	00,	00,	00,	00,	04,	00,	04,	03,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	00,	04,	04,	04,	04,	22,	00,	15,	00,	04,	22,	04,	04,	04,	22,	04,	00,	15,	15,	15,	15,	15,	15,	15,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	00,	04,	04,	04,	04,	04,	00,	15,	15,	00,	14,	22,	04,	04,	04,	22,	14,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	00,	03,	04,	04,	00,	15,	15,	15,	00,	04,	14,	22,	04,	22,	14,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	00,	04,	00,	15,	15,	15,	15,	00,	04,	14,	22,	04,	22,	14,	04,	00,	00,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	00,	15,	15,	15,	15,	15,	00,	04,	04,	04,	04,	04,	04,	04,	14,	04,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	14,	04,	04,	04,	14,	14,	14,	04,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	14,	14,	14,	00,	00,	00,	00,	14,	04,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	14,	14,	00,	15,	15,	15,	00,	04,	22,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	04,	00,	15,	15,	15,	00,	04,	04,	22,	22,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	04,	04,	00,	15,	15,	00,	04,	04,	04,	04,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	22,	04,	04,	00,	15,	15,	15,	00,	04,	04,	04,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	22,	22,	00,	15,	15,	15,	15,	00,	00,	00,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	04,	04,	04,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	00,	00,	00,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
DB	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,	15,
;FIN DEL PINTADO DEL IRON MAN EN EXCEL


 ImagenReversa DB ? ;variable para la imagen del iron man
 
 ;corazoncito

 Corazoncito DB 16, 16, 112, 40, 112, 16, 16, 16, 112, 40, 40, 40, 112, 16, 112, 40, 40, 40, 40, 40, 112, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 112, 40, 40, 112, 40 
 DB 40, 112, 16, 112, 112, 16, 112, 112, 16

InverseCorazoncito DB ? 	;variable del corazon

;armadura del juego
ArmaduraImagen DB 16, 16, 1, 32, 1, 16, 16, 16, 1, 32, 32, 32, 1, 16, 16, 1, 32, 31, 32, 1, 16, 1, 32, 32, 31, 32, 32, 1, 1, 32, 32, 31, 32, 32, 1, 1, 32, 32, 32, 32 
 DB 32, 1, 16, 1, 32, 32, 32, 1, 16

InverseArmaduraImagen DB ? 	;Variable de la armadura
;Hielos
Hielos DB 31, 53, 16, 53, 16, 53, 31, 53, 31, 16, 31, 16, 31, 53, 16, 16, 53, 31, 53, 16, 16, 53, 31, 31, 53, 31, 31, 53, 16, 16, 53, 31, 53, 16, 16, 53, 31, 16, 31, 16 
 DB 31, 53, 31, 53, 16, 53, 16, 53, 31

 InverseHielos DB ? 	;Variable del hielo

;Meteoritos
Meteoritos DB 37, 37, 37, 37, 37, 108, 16, 37, 108, 108, 37, 108, 16, 16, 37, 108, 37, 37, 16, 37, 16, 37, 37, 37, 108, 16, 16, 37, 37, 108, 16, 16, 37, 16, 16, 108, 16, 37, 16, 16 
 DB 37, 16, 16, 16, 16, 37, 16, 16, 37

InverseMeteoritos DB ?	;Variable del meteorito

;velocidades aumento imagen
VelocidadImagen DB 16, 16, 116, 43, 116, 16, 16, 16, 16, 116, 43, 116, 16, 16, 116, 16, 116, 43, 116, 16, 116, 116, 43, 43, 43, 43, 43, 116, 16, 116, 43, 43, 43, 116, 16, 16, 16, 116, 43, 116 
 DB 16, 16, 16, 16, 16, 116, 16, 16, 16

InverseVelocidadImagen DB ?	;Variable de la velocidad

;Multidisparos
MultiDisparosX DB 16, 111, 111, 111, 111, 111, 16, 16, 16, 111, 16, 111, 16, 16, 16, 16, 16, 40, 16, 16, 16, 16, 16, 40, 16, 40, 16, 16, 16, 40, 16, 40, 16, 40, 16, 40, 16, 16, 16, 16 
 DB 16, 40, 16, 16, 16, 40, 16, 16, 16

InverseMultiDisparosX DB ?	;Variable de los multples disparos

;======================================COMIENZA A PROGRAMAR===================================================================================
.CODE 
;primero obtiene el nombre del jugador y luego entra en un bucle para llamar al menu principal

	MAIN PROC FAR                       ;main proc
	MOV AX,@DATA 						;guardar en el registro AX el contenido del segmento DATA
	MOV DS,AX                           ;guardar en el segmento DS el contenido del AX
    CALL ObtenerNombreJugador					;Obtener nombres de jugadores
	infLoop:							;siga repitiendo hasta que se presione la tecla esc en el menú principal
    CALL MiMenu						;Sigue llamando al menú principal si la jugador/a lo elige
	mov cx,2d							;utilizado para configurar inf loop
	cmp cx,3d							;utilizado para configurar inf loop
	JNE infLoop							;utilizado para configurar inf loop
    MOV AH,4CH        					;el control ha vuelto al sistema
    INT 21H								;el control ha vuelto al sistema
MAIN ENDP								;fin main proc

;llama desde el menú principal si el usuario elige el modo de juego

    ModosJuego proc NEAR 			;Modo de juego Procedimiento que controla y actualiza el juego
    CALL EscogerNivel			;Selecion de niveles en el juego
    CALL LIMPIAR			;Limpiar el modo de juego
     ControlTiempo: 					;un bucle para comprobar la llegada del siguiente cuadro
		MOV AH,2Ch					;obtener la hora del sistema
		INT 21h						

		CMP DL,TiempoAux				;¿La hora actual es igual a la anterior (TiempoAux)
		JE ControlTiempo				;Si es lo mismo, espera un nuevo marco.

		
		MOV TiempoAux,DL 			;Hora de actualización con nuevo marco


		CALL PoderGenerador 				
        CALL StadoBar				
		
		cmp Tiro1 , 0				;La primera jugadora disparó una bala
		je CheckearDisparo2		;Si no, entonces busca el segundo jugador
		CALL MoverBala 			;Mueve la bala
										
		CheckearDisparo2:       ;Disaparos de la segunda persona
		cmp Tiro2 , 0				; el segundo jugador dispara
		je DibujarBala			;si es asi entinces busca al segundo
		CALL MoverBala2 			
		DibujarBala:			
		CALL DibujarBalas 			


		;IGUAL QUE ANTERIOR, PERO LAS COMPROBACIONES SE REALIZAN PARA DISPAROS MÚLTIPLES EN LUGAR DE BALAS NORMALES
		cmp VariosTiros , 0		;tirar varios tiros
		je ResetMultidisparo			;si no, prepara a los luchadores a disparar
		Call MovMultiDisparo			;si disparan, muévalos hacia adelante, si golpean un objetivo o están fuera de los límites, establezca IsShot en 0
		cmp VariosTiros , 0		;¿Están dentro de los límites y no golpearon a un jugador?
		je ResetMultidisparo			; si no resetea la posicion de los tiros
		Call PintarMultiDisparo			;si es asi los dibuja
		ResetMultidisparo:				;resetear a la posicion del disparo
		CALL Restea_Balas_Posicion	;Resetear la posicion de los multiples tiros
																						
		cmp ganador,0					;checkea si ya gano
		jne ReturnToMiMenu			;si ganas puede regresar al menu

		CALL MoverIronMans 			;Mover a los ironmans
		CALL PintarseIronmans 			;dibujar los remos o luchadores con las posiciones actualizadas

		JMP	ControlTiempo 				;repetir cada vez que cambie la hora del sistema

	ReturnToMiMenu:
    RET
    ModosJuego ENDP



PoderGenerador proc NEAR

MOV AH,2Ch					;obtener la hora del sistema
INT 21h						
cmp PotenciaColisicion , 1
JE FINCREACION				
mov TempPoder ,dh			

cmp DH , 10d				;verifique la marca de 10 segundos,
je GenerarRand			;Si es asi generar poder
cmp DH , 20d				;verifique la marca de 20 segundos,
je GenerarRand			;Si es asi generar poder
cmp DH , 30d				;verifique la marca de 30 segundos,
je GenerarRand			;Si es asi generar poder
cmp DH , 40d				;verifique la marca de 40 segundos, 
je GenerarRand			;Si es asi generar poder
cmp DH , 50d				;verifique la marca de 50 segundos,				
je GenerarRand			;Si es asi generar poder
cmp DH,0d					;verifique la marca de 60 segundos,
JNE FIN_PODER				;Si es asi NO generar poder

GenerarRand:			;Antes de crear nuevos potenciadores, deshabilite los efectos de los antiguos para que sean más desafiantes.			
Call DeshabilitarE	;Deshabilitar el procedimiento de encendido
   MOV AH, 00h  ;interrupciones para obtener la hora del sistema      
   INT 1AH      ;CX:DX ahora tiene el número de tics de reloj desde la medianoche     

   mov  ax, dx	;obtenga ese número en hacha para prepararse para la división
   xor  dx, dx	;Dx ahora = 0 preparándose para la división
   mov  cx, 6   ;dividor
   div  cx       
   
   cmp JuegoNivel , 2 ;nivel 2 solo aumenta la velocidad de las balas
   JE DONADA		
   cmp JuegoNivel , 3 ;isi es el 3 aumenta la velocidad de las balas y menos vidas
   JE Nivel3_J		
	
	;Nivel Uno
	cmp dl, 5		;si el encendido generado es un meteorito?
	jne DONADA	;si no, no pasa nada
	mov dl,3		;si es así, genera un escudo en su lugar
	jmp DONADA	;jmp para evitar aplicar mods de nivel 3
	Nivel3_J:		;modos del nivel 3
	cmp dl ,4		;si el poder generado es vida extra?
	jne DONADA	;si no no pasa nada
	mov dl,5		;si es asi genera  un meteorito
	DONADA:		
	
   	mov CheckearPotenciador, dl		; poner ese número en potenciadores (se convierte en el potenciador activo)
	mov ActivarPoder, dl		; poner ese número en potenciadores (se convierte en el potenciador activo)	
	;se activa despues de que pase 10,20 hasta 60 segundos 
	CALL CreadorPoder			;creador del nuevo poder

FIN_PODER:
RET
FINCREACION:					;si la colisión está activada, no crees más
cmp TempPoder,dh				;comprobar si ha pasado un segundo
je RegresarCreacionFinal		;si no, entonces no haga nada (la generación permanecerá detenida)
mov PotenciaColisicion, 0			;si no, establezca la colisión en 0, para permitir nuevas generaciones después de 10 segundos
RegresarCreacionFinal:
RET
PoderGenerador ENDP

DeshabilitarE PROC
cmp JuegoNivel , 1
je Nivel1Valor			;si es, resetear velocidad del nivel 1
cmp JuegoNivel , 2
je Nivel2Valor			;si es, resetear velocidad del nivel 2
cmp JuegoNivel , 3
je Nivel3Valor			;si es, resetear velocidad del nivel 3
;Valores del nivel 1
Nivel1Valor:
mov VelocidadBala_X, 4d
mov VelocidadBala_X2, 4d
mov RapidezY1, 8d
mov RapidezY2, 8d
mov MultiDisparo , 0
RET
;Nivel 2 valores
Nivel2Valor:
mov VelocidadBala_X, 6d
mov VelocidadBala_X2, 6d
mov RapidezY1, 8d
mov RapidezY2, 8d
mov MultiDisparo , 0
RET
;Nivel 3 valores
Nivel3Valor:
mov VelocidadBala_X, 8d
mov VelocidadBala_X2, 8d
mov RapidezY1, 8d
mov RapidezY2, 8d
mov MultiDisparo , 0
RET
DeshabilitarE ENDP
;APLICAR EL EFECTO DEL PROCEDIMIENTO DE POWERUPS PARA LA PRIMERA JUGADORA
USOPODERES1 PROC
cmp ActivarPoder,4		;si es 4 es para la vida
je IncrementoVida
cmp ActivarPoder,3		; si es 3 es aplica extra armadura
je Incrementoarmadura
cmp ActivarPoder,2		;si es 2 aplica a la mayor velocidad
je IncrementoVelocidad
cmp ActivarPoder,1		;si es 1 congela
je Hielito1
cmp ActivarPoder,0		;si es cero es un multidisparo
je Multidisparos1			
cmp ActivarPoder,5		;si es 5 un ataque de meteoritos
je Meteoritos1
RET
IncrementoVida:			;;aumenta la vida del jugador
inc vida1		
RET		
Incrementoarmadura:		;extra de escudo es como una vida extra
inc arma1		;incementa
mov al,arma1	
cmp al , MaxArmadura		;verifica si puede usar el maximo de armadura posible
ja DontIncArmour		;si no regresa
RET
DontIncArmour:			;decrementa la armadura
Dec arma1		;regresa
RET	
IncrementoVelocidad:			;añade 4 balas y mas rapido
add VelocidadBala_X , 4d	
RET
Hielito1:				;cuando cae el hielo se congela y la velocidad es igual a cero
Mov RapidezY2, 0d
RET
Multidisparos1:				;Multidisparos del jugador
mov MultiDisparo, 1d
RET
Meteoritos1:				;Meteoritos del juego al atacar
mov arma2,48d
RET
USOPODERES1 ENDP
;
;	Hacer lo mismo para el jugador 2
;
UsoPoderes2 PROC
cmp ActivarPoder,4
je IncrementoVida2
cmp ActivarPoder,3
je Incrementoarmadura2
cmp ActivarPoder,2
je IncrementoVelocidad2
cmp ActivarPoder,1
je Hielitos2
cmp ActivarPoder,0
je Multidisparos2
cmp ActivarPoder,5
je Meteoritos12
RET
IncrementoVida2:
inc vida2
RET	
Incrementoarmadura2:
mov al,arma2
cmp al , MaxArmadura
je DontIncArmour2
inc arma2
DontIncArmour2:
RET
IncrementoVelocidad2:
add VelocidadBala_X2 , 4d
RET
Hielitos2:
Mov RapidezY1, 0d
RET
Multidisparos2:
mov MultiDisparo, 2d
RET
Meteoritos12:
mov arma1,48d
RET	
UsoPoderes2 ENDP

FIN_PODERUPLIFESPAN PROC

	mov cx, 157d	 	;mostrrar la posicion en x de la figura
    MOV DX, 72d  		;mostrrar la posicion en y de la figura 
	MOV BH,00h   		;numero de pagina
	PowerUPS:	
    MOV AH,0Ch   	;escribir por pixeles
    mov al, 00h   	; color negro ya que es 00
	INT 10h      	;dibujar el pixel
	inc Cx       	; usar el loop para pintar el pixel
    mov ax , 164d	;164 pixeles
    cmp cx, ax		;si no, repita hasta que cx llegue a 164
    Jb PowerUPS     	; en otras palabras, verifique si podemos dibujar más en la dirección x, de lo contrario, continúe en la dirección y
	mov Cx, 157d				;restablecer cx al eje x original
	inc DX   					;y dirección aumentada (baja una fila) y prepárate para dibujar
	mov ax,78d   				; loop en la y direccion
	cmp dx,ax 					; si no, repita para la siguiente fila
	ja  SALIRPowerUPS  	; osolo sale cuando la imagen se borra por completo
	Jmp PowerUPS		;repetir si no se borra
SALIRPowerUPS:
RET
FIN_PODERUPLIFESPAN ENDP
;Procedimiento que activa el encendido, igual que el procedimiento anterior pero se basa en variables de color de píxeles de imagen en lugar de negro

CreadorPoder PROC NEAR
cmp CheckearPotenciador,5d		;si es 5 es meteoritos
je CreateMeteoritos1
cmp CheckearPotenciador,4d		;isi es 4 es vida
je CrearCorazon					
cmp CheckearPotenciador,3d		;si es 3 es vida
je CrearArmadura					
cmp CheckearPotenciador,2d		;si es 2 es velocidad
je CrearVelocidad
cmp CheckearPotenciador,1d		;si es 1 es hielo
je CrearHielos
cmp CheckearPotenciador,0d		;si es 0 es multidisparos
je CrearMultidisparo

CrearCorazon:
CALL DibujarVidaPoder	;ddibujos aleatorios
RET
CrearArmadura:
CALL DibujarArmaduraPoder	;dddibujos aleatorios
RET
CrearVelocidad:
CALL DibujarVelocidadPoder	;ddibujos aleatorios
RET
CrearHielos:
CALL DibujarHielosPoder	;ddibujos aleatorios
RET
CrearMultidisparo:
Call DibujarMultidisparoPoder ;ddibujos aleatorios
RET
CreateMeteoritos1:
Call DibujarMeteoritoPoder ;ddibujos aleatorios
RET
CreadorPoder ENDP

;Dibujar los dibujos de aprox 7x7
DibujarVidaPoder PROC
	mov cx, 157d	 	;establecer el eje X de la imagen
    MOV DX, 72d  		;Y 
	mov DI, offset InverseCorazoncito 	
	dec DI					; Puntero al último píxel de la variable de imagen
	MOV BH,00h   			;mostrar pagina
	DibujarCorazonLoop:	
    MOV AH,0Ch   	;establecer la configuración para escribir un píxel
    mov al, [DI]   
	INT 10h      	
    Dec DI			
	inc Cx       	
    mov ax , 164d		
    cmp cx, ax			
    Jb DibujarCorazonLoop     
	mov Cx, 157d		
	inc DX   			
	mov ax,78d   		; loop en la direcion y
	cmp dx,ax 			; si no repetir
	ja  SalirCorazoncito   	 
	Jmp DibujarCorazonLoop	;if not then, repetir
SalirCorazoncito:
RET
DibujarVidaPoder ENDP
; Lo mismo para la armadura
DibujarArmaduraPoder PROC
	mov cx, 157d	 	
    MOV DX, 72d  
	mov DI, offset InverseArmaduraImagen	 ; Puntero de armadura para iterar sobre los píxeles.
	dec DI
	MOV BH,00h   			;mostrar siguiente paguna
	PintarArmaduraLoop:	
    MOV AH,0Ch   	
    mov al, [DI]     
	INT 10h      	;dibujar
    Dec DI			;dec di para obtener el siguiente píxel para la siguiente iteración
	inc Cx       	;usado para hacer un bucle en la dirección x
    mov ax , 164d		
    cmp cx, ax					
    Jb PintarArmaduraLoop      
	mov Cx, 157d
	inc DX   					;y direction increased (goes down one row) and get ready to draw
	mov ax,78d   				;  loop en y
	cmp dx,ax 					; repetir en la siguiente 
	ja  SalirArmaduraLoop   	
	Jmp PintarArmaduraLoop		;repetir
SalirArmaduraLoop:
RET
DibujarArmaduraPoder ENDP
;Lo mismo para la velocidad
DibujarVelocidadPoder PROC
	mov cx, 157d	 	
    MOV DX, 72d  
	mov DI, offset InverseVelocidadImagen		 ; interactuar con los pixeles
	dec DI
	MOV BH,00h   			;mostrar pagina siguiente
	DibujarVelocidadLoop:	
    MOV AH,0Ch   	;pintas los pixeles
    mov al, [DI]     ; 
	INT 10h      	;Dibujar el pixel
    Dec DI			
	inc Cx       	; usar la direcion en x del loop
    mov ax , 164d		
    cmp cx, ax					
    Jb DibujarVelocidadLoop      	
	mov Cx, 157d
	inc DX   					
	mov ax,78d   				;  loop en y direccion
	cmp dx,ax 					; si no repetir
	ja  SalirVelocidadLoop   		
	Jmp DibujarVelocidadLoop			;repetir
SalirVelocidadLoop:
RET
DibujarVelocidadPoder ENDP
;Lo mismo para el hielo
DibujarHielosPoder PROC
	mov cx, 157d	 	
    MOV DX, 72d  
	mov DI, offset InverseHielos			 ;interactuar con los pixeles
	dec DI
	MOV BH,00h   			;mostrar pagina
	PintarHieloLoop:	
    MOV AH,0Ch   	
    mov al, [DI]     
	INT 10h      	;dibujamos los pixeles
    Dec DI			
	inc Cx       	; usar el x en el loop
    mov ax , 164d		
    cmp cx, ax					
    Jb PintarHieloLoop      	
	mov Cx, 157d
	inc DX   					
	mov ax,78d   	;  loop en la y direccion
	cmp dx,ax 					;si no repetir
	ja  SalirHieloLoop   				
	Jmp PintarHieloLoop			;repetir
SalirHieloLoop:
RET
DibujarHielosPoder ENDP
DibujarMultidisparoPoder PROC
	mov cx, 157d	 	
    MOV DX, 72d  
	mov DI, offset InverseMultiDisparosX			 ; 
	dec DI
	MOV BH,00h   			;mostrar pagina siguiente
	PintarMultiDisparoLoopPU:	
    MOV AH,0Ch   	
    mov al, [DI]     
	INT 10h      	
    Dec DI			
	inc Cx       	
    mov ax , 164d		
    cmp cx, ax					
    Jb PintarMultiDisparoLoopPU      	
	mov Cx, 157d
	inc DX   					
	mov ax,78d   	
	cmp dx,ax 					
	ja  SalirMultiDisparoLoop   				
	Jmp PintarMultiDisparoLoopPU			
SalirMultiDisparoLoop:
RET
DibujarMultidisparoPoder ENDP
;lo mismo para los multidisparos
DibujarMeteoritoPoder PROC
mov cx, 157d	 	
    MOV DX, 72d  
	mov DI, offset InverseMeteoritos			 
	dec DI
	MOV BH,00h   		
	DibujarMeteoritosLoop:	
    MOV AH,0Ch   	
    mov al, [DI]      
	INT 10h      	
    Dec DI			
	inc Cx       	
    mov ax , 164d		
    cmp cx, ax					
    Jb DibujarMeteoritosLoop      	
	mov Cx, 157d
	inc DX   					
	mov ax,78d   
	cmp dx,ax 					
	ja  SalirMeteoritosLoop   			
	Jmp DibujarMeteoritosLoop			
SalirMeteoritosLoop:
RET	
DibujarMeteoritoPoder ENDP
StadoBar proc NEAR 	  

mov cx,120d				
 mov dx,Alto_Ventana	
 mov al,5d				
 mov ah,0ch				
 Status:					
 int 10h					
 inc cx					
 cmp cx,200d		
 jnz Status				


	;Dibuja el corazón izquierdo debajo de la jugadora 1
	MOV CX, 5d 	 ;mostrar en x
    MOV DX, Alto_Ventana 
	add DX, 10d		;mostrar en y
	mov DI, offset InverseCorazoncito 			 ; interacturar con las x
	dec DI
	   
    MOV BH,00h   			;mostrar la paguna
	DibujaCorazonA:	
    MOV AH,0Ch   	;Escribir el pixel
    mov al, [DI]     ; 
	      
	INT 10h      	;dibujar pixel
    Dec DI			;aumente di para obtener el siguiente píxel para la próxima iteración
	inc Cx       	; usado para hacer un bucle en la dirección x
    mov ax , 12			
    cmp cx, ax					
    Jb DibujaCorazonA      	; en otras palabras, verifique si podemos dibujar más en la dirección x, de lo contrario, continúe en la dirección y
	mov Cx, 5d		;restablecer cx para dibujar una nueva línea de píxeles en la nueva fila debajo de la fila anterior
	inc DX   					;y dirección aumentada (baja una fila) y prepárate para dibujar
	mov ax,Alto_Ventana   	;bucle en la dirección y
	add ax,17d					;hasta que la ubicación y la altura sean más pequeñas que dx, solo entonces salga del ciclo
	cmp dx,ax 					; si no, repita para la siguiente fila
	ja  SalirCorazon1   			
	Jmp DibujaCorazonA			;repetir

	SalirCorazon1:
;;dibujar salud para el jugador izquierdo usando 13h/10h int

 mov al, 1				;
 mov bh, 0				;numero de pagina
 mov bl,  00000010b		;Atributos : Color verde sobre fondo negro
 mov cx, 1 ; calcular el tamaño del mensaje para el bucle
 mov dx, Alto_Ventana	;para obtener la altura de la ventana (o el número de fila) en dh (DEBE HACER PARA QUE LA INTERRUPCIÓN FUNCIONE), primero debemos moverlo a dx (16 bits a 16 bits)
 mov dh, dl				
 sub dh, 2d			; restar 2, se ve mejor
 mov dl, 2d				;número de columna
 push DS 				;Necesario para interrumpir no romper el código
 pop es					; es = ds
 mov bp, offset vida1	; bp = mensaje de salud del jugador 1 ofsset, es y bp usados para imprimir cadenas
 mov ah, 13h				
 int 10h					
;Lo mismo para el segundo jugador

	MOV CX, Ancho_Ventana
	sub cx, 12d	 	;
    MOV DX, Alto_Ventana 
	add DX, 10d		;establecer la altura (Y)
	mov DI, offset InverseCorazoncito 			 ; para iterar sobre los píxeles
	dec DI
	MOV BH,00h   			;numero de pagina
	DibujaCorazonA2:	
    MOV AH,0Ch   	
    mov al, [DI]     ; color de las coordenadas actuales RECUPERADAS DE LOS PÍXELES DE LA IMAGEN, DI tiene la ubicación del primer píxel
	      
	INT 10h      	;dibujar pixel
    Dec DI			;aumente di para obtener el siguiente píxel para la próxima iteración
	inc Cx       	; usar el loop en la direcciion x
    mov ax , Ancho_Ventana
	sub ax , 5d			
    cmp cx, ax					;  , si la respuesta es sí, si cx es igual a ellos, proceda a la siguiente fila
    Jb DibujaCorazonA2      	 
	mov Cx, Ancho_Ventana
	sub cx, 12d		;reset cx para dibujar una nueva línea de píxeles en la nueva fila debajo de la fila anterior
	inc DX   					;y dirección aumentada (baja una fila) y prepárate para dibujar
	mov ax,Alto_Ventana   	;  loop en y
	add ax,17d					
	cmp dx,ax 					; si no, repita para la siguiente fila
	ja  SalirCorazon2   		
	Jmp DibujaCorazonA2			;repetir

	SalirCorazon2:
; Lo mismo spara dibujar la salud del segundo jugador
mov al, 1
mov bh, 0
mov bl,  00000010b
mov cx, 1  
mov dx, Alto_Ventana
mov dh, dl
sub dh, 2d
mov dl,37d
push DS
pop es
mov bp, offset vida2
mov ah, 13h
int 10h
;Dibujar armadura de abajo del jugador 1

	MOV CX, 5d 	
    MOV DX, Alto_Ventana 
	add DX, 35d	;	establecer la altura (Y)
	mov DI, offset InverseArmaduraImagen 			 ; para iterar sobre los píxeles
	dec DI
	   
    MOV BH,00h   			;Mostrar numero de pagina
	PintarLaArmaduraLoop:	
    MOV AH,0Ch   	;establecer la configuración para escribir un píxel
    mov al, [DI]     ;
	      
	INT 10h      	;Dibujar el pixel
    Dec DI			;aumente di para obtener el siguiente píxel para la próxima iteración
	inc Cx       	;usado para hacer un bucle en la dirección x
    mov ax , 12			
    cmp cx, ax					
    Jb PintarLaArmaduraLoop      
	mov Cx, 5d		;reset cx to draw a new line of pixels in the new row below the row before
	inc DX   					;y dirección aumentada (baja una fila) y prepárate para dibujar
	mov ax,Alto_Ventana   	;  loop en y
	add ax,41d					;hasta que la ubicación y la altura sean más pequeñas que dx, solo entonces salga del ciclo
	cmp dx,ax 					; si no repetir para la siguiente fila
	ja  SalirArmadura_1  		
	Jmp PintarLaArmaduraLoop			;repetir

	SalirArmadura_1:
;Armadura 1 como en el anterior del corazon
mov al, 1
mov bh, 0
mov bl,  00000001b
mov cx, 1 
mov dx, Alto_Ventana
mov dh, dl
add dh, 1d
mov dl,2d
push DS
pop es
mov bp, offset arma1
mov ah, 13h
int 10h
;Lo mismo para el jugador 2
	mov cx , Ancho_Ventana
	sub cx, 12d	 	
    MOV DX, Alto_Ventana 
	add DX, 35d		;set the hieght (Y) 
	mov DI, offset InverseArmaduraImagen 			 ; interactura con los pixeles
	dec DI
	   
    MOV BH,00h   			;Mostrar numero de pagina
	PintarLaArmaduraLoop2:	
    MOV AH,0Ch   	;establecer la configuración para escribir un píxel
    mov al, [DI]    
	      
	INT 10h      	;Dibujar el pixel
    Dec DI			;aumenta di para obtener el siguiente píxel para la siguiente iteración
	inc Cx       	;usado para hacer un bucle en la dirección x
    mov ax , Ancho_Ventana
	sub ax , 5d			
    cmp cx, ax		
    Jb PintarLaArmaduraLoop2      	;en otras palabras, verifique si podemos dibujar más en la dirección x, de lo contrario, continúe en la dirección y
	mov cx , Ancho_Ventana
	sub cx, 12d	 				
	inc DX   					
	mov ax,Alto_Ventana   	;  loop en y
	add ax,41d					;hasta que la ubicación y la altura sean más pequeñas que dx, solo entonces salga del ciclo
	cmp dx,ax 					; repetir en la siguiente 
	ja  SalirEscudo_2  			
	Jmp PintarLaArmaduraLoop2			;repetir

	SalirEscudo_2:
;lo mismo para el segundo jugador en la armadura
mov al, 1
mov bh, 0
mov bl,  00000001b
mov cx, 1 
mov dx, Alto_Ventana
mov dh, dl
add dh, 1d
mov dl,37d
push DS
pop es
mov bp, offset arma2
mov ah, 13h
int 10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;lo mismo 'atras - F4'
mov al, 1
mov bh, 0
mov bl,  00000110b
mov cx, 9 ; calculate message size. 
mov dx, Alto_Ventana
mov dh, dl
sub dh, 5d
mov dl,15d
push DS
pop es
mov bp, offset Presionar_F4
mov ah, 13h
int 10h
;Imprimir el nombre del jugador 1
mov al, 1
mov bh, 0
mov bl,  00000110b
mov cx, 15 
mov dx, Alto_Ventana
mov dh, dl
sub dh,4d
mov dl,0d
push DS
pop es
mov bp, offset NombreJugador
mov ah, 13h
int 10h
;Lo mismo para el jugador 2
mov al, 1
mov bh, 0
mov bl,  00000110b
mov cx, 15 
mov dx, Alto_Ventana
mov dh, dl
sub dh,4d
mov dl,25d
push DS
pop es
mov bp, offset NombreJugador
mov ah, 13h
int 10h


RET
StadoBar ENDP
;ELEGIR NIVEL
;Solicita al usuario a que elija el nivel lo imprime
;lo imprime ya sea nivel 1 2 o 3

    EscogerNivel proc NEAR  ; un procedimiento que pregunta al jugador por el nivel que quiere jugar

	MOV AX,Alto_Ventana
	SUB AX,Limite
	SUB AX,TempAlto
	mov POS_DERECHOY, ax		
	Call RESETEAR_POSICIONDEBALAS
	Call RESETEAR_POSICIONDEBALAS2
	mov POSX, 0
	mov POSY, 0AH  	 
	mov VIEJAPOSX, 0
	mov VIEJAPOSY, 0AH

	mov POS_DERECHOX, 280d
	mov POS_DERECHOY, 90D
	mov OLDPOS_DERECHOX, 280d
	mov OLDPOS_DERECHOY, 100D

    ;LETRAS EN COLOR MORADOOOOOOOOOOOO :D
    MOV AX,0600H         	
    MOV BH,00001101b				
    MOV CX,0000H			
    MOV DX,184FH			
    INT 10H					
    ;establecer la ubicación del cursor en el centro de la pantalla
    MOV AH,02H				
    MOV BH,00				;mostrar pagina numero
    MOV DX,0810H   			; X = 10, Y = 8
    INT 10H    				

    ;Imprime_Mensaje
    mov dx, Offset NIVELES 	;obtener mensajes
	mov     ah, 09h					;imprime el signo de dolar
	int     21h						
  
	mov al ,1
	mov bh, 0
	mov bl,  00000010b
	mov cx, 7
	mov dl, 22H
	mov dh, 0Ah
	push Ds
	pop es
	mov bp, offset NVL1
	mov ah, 13h
	int 10h
    
	mov al ,1
	mov bh, 0
	mov bl,  00001110b
	mov cx, 7
	mov dl, 22H
	mov dh, 0Ch
	push Ds
	pop es
	mov bp, offset NVL2
	mov ah, 13h
	int 10h
   
	mov al ,1
	mov bh, 0
	mov bl,  00001100b
	mov cx, 7
	mov dl, 22H
	mov dh, 0Eh
	push Ds
	pop es
	mov bp, offset NVL3
	mov ah, 13h
	int 10h
	
	
    MOV AH,02H
    MOV BH,00
    MOV DX,3A17H ; X = 17, Y = 3A 
    INT 10H   ; cursor oculto 
	;Bucle para verificar la entrada del usuario
    ObtenerNiveles:
    mov ah,0		;Esperar entrada
    int 16h			
    CMP al , '1'	;comparar entrada con 1 para lvl uno
    JE  IniciarNVL1	
    CMP al , '2'	;comparar entrada con 2 para lvl uno
    JE  IniciarNVL2	
    CMP al , '3'	;comparar entrada con 3 para lvl uno
    JE  IniciarNVL3	
    JMP ObtenerNiveles	;solo acepta los numeros 1 2 y 3
    IniciarNVL1: CALL NivelUNO	;procedimiento de llamada de nivel uno
    JMP RegresarNivelSeleccionado			;retorna al nivel
    IniciarNVL2: CALL Nivel_2	;procedimiento de llamada de nivel 2
    JMP RegresarNivelSeleccionado			;retorna al nivel
    IniciarNVL3: CALL Nivel_3	;procedimiento de llamada de nivel 3
    RegresarNivelSeleccionado:			;retorna al label
    RET							;regreso
    EscogerNivel ENDP

;Niveles disponibles 
;Nivel uno :
;				vida maxima = 4, armadura maxima = 4, velocidad de las balas = lento, 	 , habilitar armadura , deshabilitar Meteoritos1
;Nivel 2:
;				vida maxima= 3,armadura maxima = 2, velocidad de las balas = medio	 , habilitar Meteoritos1, te pude tocar un poco mas la armadyura
;Nivel 3:
;				vida maxima = 2, armadura maxima= 1,	velocidad de las balas = rapido  	 ,deshabilitar vida
NivelUNO proc NEAR
mov JuegoNivel,1d
mov vida1,52d	;establece la salud p1 en 4 codigo asscci para el cero
mov vida2,52d	;igual para p2
mov arma1, 48d	;establecer armadura a 0 para p1
mov arma2, 48d	;igual para p2
mov VelocidadBala_X , 6d;ESTABLECER LA VELOCIDAD DE LA BALA EN BAJA	
mov VelocidadBala_X2 , 6d;ESTABLECER LA VELOCIDAD DE LA BALA EN BAJA

CALL Restea_Balas_Posicion
Mov VariosTiros , 0
mov MultiDisparo , 0
mov ActivarPoder , 0
mov CheckearPotenciador , 0
;LÍMITES DE VENTANA NORMALES
mov Limite , 6d 	
mov MaxArmadura , 4d		;maximo deamraduta es 4
ADD MaxArmadura , 48d		;codigo ascii


RET
NivelUNO ENDP
Nivel_2 proc NEAR
mov JuegoNivel,2d
mov vida1,51d	;establece la salud p1 en 4 codigo asscci para el cero
mov vida2,51d	;igual para p2
mov arma1, 48d	;establecer armadura a 0 para p1
mov arma2, 48d	;igual para p2
mov VelocidadBala_X , 8d;ESTABLECER LA VELOCIDAD DE LA BALA EN MEDIA	
mov VelocidadBala_X2 , 8d;ESTABLECER LA VELOCIDAD DE LA BALA EN MEDIA	

CALL Restea_Balas_Posicion
Mov VariosTiros , 0
mov MultiDisparo , 0
mov ActivarPoder , 0
mov CheckearPotenciador , 0

mov Limite , 6d	;LÍMITES DE VENTANA NORMALES
mov MaxArmadura , 2d		;maximo deamraduta es 4
ADD MaxArmadura , 48d		;ASCII codigo
RET
Nivel_2 ENDP
Nivel_3 proc NEAR
mov JuegoNivel,3d
mov vida1,50d	;establece la salud p1 en 4 codigo asscci para el cero
mov vida2,50d	;igual para p2
mov arma1, 48d	;establecer armadura a 0 para p1
mov arma2, 48d	;igual para p2
mov VelocidadBala_X , 10d;ESTABLECER LA VELOCIDAD DE LA BALA EN ALTA
mov VelocidadBala_X2 , 10d;ESTABLECER LA VELOCIDAD DE LA BALA EN ALTA

CALL Restea_Balas_Posicion
Mov VariosTiros , 0
mov MultiDisparo , 0
mov ActivarPoder , 0
mov CheckearPotenciador , 0

mov Limite , 16d	
mov MaxArmadura , 1d		;maximo deamraduta es 1
ADD MaxArmadura , 48d		;ASCII codigo
RET
Nivel_3 ENDP

;MProcedimiento Move Fighters que calcula la nueva posición y borra la imagen antigua de la ubicación anterior

    MoverIronMans proc NEAR		;Mover jugadores
  
		mov ax, POSX	;obtener la posición anterior para el eje x
		mov VIEJAPOSX, ax	
		mov ax, POSY	;como arriba para el eje y
		mov VIEJAPOSY, ax	
        mov ax, POS_DERECHOX	;lo mismo para el jugador 2
		mov OLDPOS_DERECHOX, ax
		mov ax, POS_DERECHOY
		mov OLDPOS_DERECHOY, ax

		MOV AH,01h	;presione la tecla PERO NO ESPERE UNA CLAVE
		INT 16h		
		JZ ChekearMovs_JMPER
        MOV AH,00h  ;obtener la clave del búfer
		INT 16h 	
		CMP     Ah, 3Eh							;verifique la barra F4, SI ES SÍ, SALGA DEL MODO DE JUEGO
		JE      F4
		CMP     AL, 32d 						;;verifique la barra espaciadora, SI DISPARE PEW PEW
		JNE      checkP2	
		cmp Tiro1 , 0			;SI SE PRESIONA LA BARRA ESPACIADORA, COMPROBAR SI YA SE HA DISPARADO UNA BALA ANTES
		JNE Reload1 			;SI NO, ACTUALIZAR LA POSICIÓN DE LA VIÑETA A LA POSICIÓN DE LA NAVE ESPACIAL
		CALL RESETEAR_POSICIONDEBALAS	
		Reload1:							
		mov Tiro1 , 1d		;SI ES SÍ, MANTENER TIRO ESTÁ HABILITADO
		cmp MultiDisparo,1d		;COMPROBAR SI MULTISHOT ESTÁ ACTIVO PARA EL JUGADOR 1
		jne checkP2				;SI NO, IR A COMPROBAR AL SEGUNDO JUGADOR
		mov VariosTiros, 1d	;SI ES SÍ, ENTONCES DISPARA MULTIDISPARO PARA EL JUGADOR 1
		jmp checkP2				;Y MOVER A JUGADOR 2 CHEQUES
		F4:
		mov ganador, 1			;SI apacha F4, REGRESA AL MENÚ PRINCIPAL 
		RET
		checkP2:				
		CMP     AL, 47d 							
		JNE      MovPaleta 	
		
		;lo mismo para el jugador 2
		cmp Tiro2 , 0				
		JNE Reload2 
		CALL RESETEAR_POSICIONDEBALAS2
		Reload2:
		mov Tiro2 , 1
		cmp MultiDisparo,2d
		jne MovPaleta
		mov VariosTiros, 1d
		jmp MovPaleta 

		ChekearMovs_JMPER:	;UTILIZADO PARA EVITAR EL ERROR DE SALTO FUERA DE LÍMITES
		jmp ChekearMovsDerecho_JMPER


		MovPaleta:
	;compruebe si se está presionando alguna tecla y verifique si es la tecla de movimiento (si no, verifique al otro jugador)
; ;comprobar qué tecla se está presionando (AL = Carácter ASCII)
; ;obtener la tecla que fue presionada y actuar en consecuencia
;si es flecha arriba -> mover hacia arriba para el jugador izquierdo
		CMP ah,48h 									;verifique la flecha hacia arriba
		JE MovesArriba1						;si es cierto sube

		
		CMP ah,50h 									;verifique la FLECHA ABAJO
		JE MovesAbajo1					;si es asi baja
		
		JMP ChekearMovsDerecho_JMPER				;lo mismo para el jugador 2
														

		;SECUENCIA DE MOVIMIENTO DEL LUCHADOR IZQUIERDO ===AQUI VOY TODO BIEN											
		MovesArriba1: 						;Secuencia para mover la paleta izquierda hacia arriba
			MOV AX,RapidezY1 					;Control de velocidad para cambiar la velocidad del luchador.
			SUB POSY,AX 					;restando el RapidezY1 en la posición actual de la paleta

			MOV AX,Limite
			CMP POSY,AX 					;comprobar si la paleta está en el límite superior
			JL repararPosicion 		;si está en el límite superior, fije la posición
			JMP ChekearMovsDerecho_JMPER			;repetir

			repararPosicion:					
				MOV POSY,AX 				
				JMP ChekearMovsDerecho_JMPER	

		MovesAbajo1: 						;Secuencia para mover la paleta izquierda hacia abajo
			MOV AX,RapidezY1 					
			ADD POSY,AX 					;agregando el RapidezY1 en la posición actual de la paleta
			MOV AX,Alto_Ventana					
			SUB AX,Limite					;El valor de los límites se puede cambiar para límites más estrechos o más anchos
			SUB AX,TempAlto					;Igual que mover la paleta hacia arriba, pero ahora se verifica con la altura de la ventana, la altura de la paleta y los límites.
			CMP POSY,AX 					;comprobar si la paleta está en el límite inferior
			JG repararPosicionizq 		;si está en el límite inferior, fije la posición
			JMP ChekearMovsDerecho_JMPER

			repararPosicionizq:
				MOV POSY,AX 				;posición superior de la paleta de fijación
				JMP ChekearMovsDerecho_JMPER

		exit:
			JMP SALIRPADMOVE 								

		;Movimiento de combate derecho en el teclado
		ChekearMovsDerecho_JMPER:
			
			CMP AL,6Fh 								;busca 'o'
			JE MovDerechoPad
			CMP AL,4Fh 								;busca 'o'
			JE MovDerechoPad

			;si es 'l' o 'L' -> abajo
			CMP AL,6Ch 								;compara para 'l'
			JE MovDerechoPadABajo
			CMP AL,4Ch 								;compara para 'L'
			JE MovDerechoPadABajo
			JMP SALIRPADMOVE

		MovDerechoPad: 						
			MOV AX,RapidezY2					
			SUB POS_DERECHOY,AX 					

			MOV AX,Limite
			CMP POS_DERECHOY,AX 			
			JL RepararDerechoTopPo  		
			JMP SALIRPADMOVE

			RepararDerechoTopPo:
				MOV POS_DERECHOY,AX 				
				JMP SALIRPADMOVE

		MovDerechoPadABajo:
			MOV AX,RapidezY2
			ADD POS_DERECHOY,AX 					;agregando el RapidezY1 en la posición actual de la paleta
			MOV AX,Alto_Ventana
			SUB AX,Limite
			SUB AX,TempAlto
			CMP POS_DERECHOY,AX 					;comprobar si la paleta está en el límite inferior
			JG RepararDerechoTopPoBoton 	;si está en el límite inferior, fije la posición
			JMP SALIRPADMOVE

			RepararDerechoTopPoBoton:
				MOV POS_DERECHOY,AX 				;fijar la posición de la paleta
				JMP SALIRPADMOVE

		SALIRPADMOVE:

			;Jugador de la izquierda
			mov cx, POSX	;comparar operando 1
			mov dx, VIEJAPOSX	;comparar operando 2
			cmp cx, dx				;
			jne AntiMovi			;si no prepárate para borrar viejo
			mov cx, POSY	;igual que arriba pero para el eje Y
			mov dx, VIEJAPOSY
			cmp cx, dx				;compruebe si las coordenadas X antiguas == las nuevas coordenadas X
			je NoAntiMovi		
			;antiguos movimientos
			AntiMovi:	
			mov cx, VIEJAPOSX	;obtener coordenadas X antiguas 
			mov dx, VIEJAPOSY	;obtener coordenadas Y antiguas


			DibujarIzqHorizontal:
			MOV AH,0Ch					;establecer la configuración para escribir el píxel
			MOV AL,00h					
			MOV BH,00h					;Mostrar numero de pagina
			INT 10h 					;ejecutar la configuración

			INC CX 						
			MOV AX,VIEJAPOSX		
			add AX,TempAncho	
			CMP cx,ax					;CX > TempAncho + POSX (si es así, nueva línea; si no, nueva columna)
			JNG DibujarIzqHorizontal	
			mov cx, VIEJAPOSX
			inc dx
			MOV AX,VIEJAPOSY					
			add AX,TempAlto	
			cmp dx,ax					;DX < POST + Altura (si es así, nueva línea. Si no, SALGA DEL DIBUJO)
			JNG DibujarIzqHorizontal

			NoAntiMovi:		
			mov cx, POS_DERECHOX
			mov dx, OLDPOS_DERECHOX
			cmp cx, dx
			jne AntiMovi2
			mov cx, POS_DERECHOY
			mov dx, OLDPOS_DERECHOY
			cmp cx, dx
			je NoAntiMovi2
			
			AntiMovi2:
			mov cx, OLDPOS_DERECHOX		;obtener coordenadas x antiguas
			mov dx, OLDPOS_DERECHOY		;obtener coordenadas y antiguas

			;lo  mismo para el jugador del lado derecho
			DibujarDereHorizontal:
			MOV AH,0Ch					;establecer la configuración para escribir el píxel
			MOV AL,00h					
			MOV BH,00h					;Mostrar numero de pagina
			INT 10h 					;ejecutar la configuración

			INC CX 						
			MOV AX,OLDPOS_DERECHOX		;CX > TempAncho + POSX (si es así, nueva línea; si no, nueva columna)
			add AX,TempAncho	
			CMP cx,ax
			JNG DibujarDereHorizontal
			mov cx, OLDPOS_DERECHOX
			inc dx
			MOV AX,OLDPOS_DERECHOY		;DX < POST + Altura (si es así, nueva línea. Si no, SALGA DEL DIBUJO)
			add AX,TempAlto	
			cmp dx,ax
			JNG DibujarDereHorizontal

		NoAntiMovi2:      			
    RET
    MoverIronMans ENDP
 
    PintarseIronmans proc NEAR		;procedimiento de dibujar luchador
    
		;ironman derecha
		MOV CX, POSX   	;establecer la UBICACIÓN DE INICIO DEL EJE X
	    MOV DX, POSY  		;establecer la UBICACIÓN DE INICIO DEL EJE Y
		mov DI, offset IronMan 			 ; para iterar sobre los píxeles
		   
		    MOV BH,00h   			;Mostrar numero de pagina
	PintarseIronmansLoop:	
	       MOV AH,0Ch   	;establecer la configuración para escribir un píxel
           mov al, [DI]     
	      
	       INT 10h      	;Dibujar el pixel
		   inc DI		;aumenta di para obtener el siguiente píxel para la siguiente iteración
	       inc Cx       	;usado para hacer un bucle en la dirección x
		   mov ax , POSX	
		   Add ax,TempAncho		
		   cmp cx, ax					
	       Jb PintarseIronmansLoop      
	       mov Cx, POSX		;reset cx para dibujar una nueva línea de píxeles en la nueva fila debajo de la fila anterior
	       inc DX   					
		   mov ax,	 POSY   	;  loop en y
		   add ax,39					;hasta que la ubicación y la altura sean más pequeñas que dx, solo entonces salga del ciclo
		   cmp dx,ax 					; repetir en la siguiente 
	       ja  ENDING   				;  tanto x como y TERMINATED LOOP, así que salga para dibujar al otro luchador
		   Jmp PintarseIronmansLoop			;repetir
	ENDING:
	;Lo mismo para el jugador de la izquierda
		MOV CX, POS_DERECHOX   	
	    MOV DX, POS_DERECHOY  	
		mov DI, offset ImagenReversa - 1  ;para obtener la ubicación del último píxel en el IronMan
		   
		 MOV BH,00h   	;Mostrar numero de pagina
	PintarseIronmansLoop2:	
	       MOV AH,0Ch   	;establecer la configuración para escribir un píxel
           mov al, [DI]     ; color de las coordenadas actuales
	      
	       INT 10h      	;ejecutar la configuración
		   dec DI			;hacer decremento porque vamos en sentido contrario
	       inc Cx       	; bucle en la dirección x
		   mov ax , POS_DERECHOX
		   Add ax,40
		   cmp cx, ax			
	       Jb PintarseIronmansLoop2      		;comparaciones similares a las anteriores
	       mov Cx, POS_DERECHOX	
	       inc DX   
		   mov ax,	 POS_DERECHOY   	
		   add ax,39
		   cmp dx,ax 						;comparaciones similares a las anteriores
	       ja  ENDING2   	;  tanto x como y BUCLE TERMINADO así que finalice el programa
		   Jmp PintarseIronmansLoop2
		   ENDING2:

    RET
    PintarseIronmans ENDP
;Procedimiento de dibujo de viñetas, utiliza ram de video para dibujar directamente en la pantalla en lugar de usar interrupciones, elimina todos los parpadeos divertidos y artefactos en la pantalla

    DibujarBalas proc NEAR
			mov ax,TempAncho
			cmp Disparo1_X , ax
			je SegundaBala
            mov ax, 0A000h     
            mov es, ax  		;configurar es para que apunte a la primera parte de ram de video

			;Ddibujo de disparo
            MOV AX,Disparo1_Y 					;establecer la línea inicial (Y) en el hacha
           	MOV DX,Disparo1_X					;establecer la línea inicial (X) en el hacha
        	mov cx, Ancho_Ventana				;establezca cx en 320, ancho de ventana
        	mul cx								;mul hacha por cx (ubicación Y o fila * ancho de ventana o 320)
        	add ax,Disparo1_X					;añadir columna
        	mov di, ax      ; (row*320+col)  	;establecer di con la ubicación exacta para dibujar
            mov Al,0CH							;color de píxel rojo claro
            mov cx,TamanoBalas       			;bucle para escribir tamaño de viñeta número de píxeles
            rep STOSB							;repetir almacenar un solo byte y dec cx hasta cx = 0
        	MOV AX,Disparo1_Y					
        	mov cx, Ancho_Ventana				;poner 320 en cx
        	mul cx								
        	add ax,Disparo1_X					;añadir columna
        	add  ax,Ancho_Ventana				;agregue el ancho de la ventana para obtener la siguiente fila
        	mov di, ax							;establecer di con nueva ubicaciónn		
        	mov Al,0CH						;	color de píxel rojo claro
        	mov cx,TamanoBalas 					;bucle para escribir tamaño de viñeta número de píxeles
        	rep STOSB							;repetir almacenar un solo byte y dec cx hasta cx = 0
										
			;Dibujar al segundo jugador
			SegundaBala:
			mov ax, Ancho_Ventana
			sub ax, TempAncho
			sub ax, TamanoBalas
			cmp Disparo2_X, ax
			je Dontdraw
			MOV AX,Disparo2_Y 					;establecer la línea inicial (Y) en el hacha
           	MOV DX,Disparo2_X					;establecer la línea inicial (X) en el hacha
        	mov cx, Ancho_Ventana
        	mul cx					 
        	add ax,Disparo2_X
        	mov di, ax      
            mov Al,0DH		;DIBUJA VIÑETAS DE COLOR MORADO EN SU LUGAR
            mov cx,TamanoBalas       
            rep STOSB
        	MOV AX,Disparo2_Y
        	mov cx, Ancho_Ventana
        	mul cx					
        	add ax,Disparo2_X
        	add  ax,Ancho_Ventana
        	mov di, ax
        	mov Al,0DH		;DIBUJA VIÑETAS DE COLOR MORADO EN SU LUGAR
        	mov cx,TamanoBalas 
        	rep STOSB
			Dontdraw:
            RET
    DibujarBalas ENDP
    ;Dibujar todo lo relacionado con la ubicacion de las balas
    MoverBala PROC NEAR					;procesar el movimiento de la bala

		;primero Borrar viñeta antigua
			mov ax, 0A000h      ;a la pantalla de gráficos
            mov es, ax  				
            MOV AX,Disparo1_Y 	;establecer la línea inicial(Y)
           	MOV DX,Disparo1_X	;establecer la columna inicial (X)

			
        	mov cx, Ancho_Ventana 
        	mul cx					
        	add ax,Disparo1_X
        	mov di, ax      	
            mov Al,00H			;color negro
            mov cx,TamanoBalas       
            rep STOSB			;dibujar tiempos de tamaño de viñeta
        	MOV AX,Disparo1_Y	;repetir para la fila siguiente
        	mov cx, Ancho_Ventana
        	mul cx				
        	add ax,Disparo1_X
        	add  ax,Ancho_Ventana
        	mov di, ax
        	mov Al,00H			;color negro
        	mov cx,TamanoBalas 
        	rep STOSB			;Dibujar tiempos de viñetas


		;SIGUIENTE movemos ambas viñetas en sus respectivas direcciones
		MOV AX,VelocidadBala_X	;agregue la velocidad de la bala en la dirección X a su coordenada X actual
		ADD Disparo1_X,AX 			;mover la viñeta horizontalmente (de izquierda a derecha)
		MOV AX,Ancho_Ventana			;Obtener ancho de ventana en hacha
		SUB AX,TamanoBalas			;Reste el tamaño de la viñeta de él
		SUB AX,Limite		
		CMP Disparo1_X,AX			
		JG  Reset_Pos 	
		
		jmp contafterjmp 
		Reset_Pos: 
		Call RESETEAR_POSICIONDEBALAS 
		JMP Colision_Ballon		;Volver a Verificación de las segundas viñetas


		contafterjmp:
		;ahora haga comprobaciones de colisión de Luchador = balas
		MOV AX,POS_DERECHOX	;Obtener la coordenada X del luchador derecho
		add ax,10				;AGREGAR 10, porque sin él en la pantalla estrecha hace que el juego se desarrolle (le da al jugador más margen de maniobra)
		CMP Disparo1_X,AX		
		JL Colision_Ballon		;si no hay colisión, verificamos el caza izquierdo
		
		MOV AX,Disparo1_Y		;obtener las coordenadas Y de la viñeta
		CMP AX,POS_DERECHOY	
		JNG Colision_Ballon

		MOV AX,POS_DERECHOY	;Consigue la coordenada del luchador
		ADD AX,TempAlto	
		CMP Disparo1_Y,AX		
		JG Colision_Ballon		

		
		cmp arma2 , 48d
		je SaludJugador2
		Dec arma2
		Jmp hit1
		SaludJugador2:
        Dec vida2	;disminuir la salud del jugador
		cmp vida2 , 48d 
		je ENDGAME1				
		hit1:
		CALL RESETEAR_POSICIONDEBALAS	;Si hay colisión, devuelva la bala al caza para prepararlo para un nuevo disparo.
        RET
        
		ENDGAME1:	;Si el ganador es el jugador 1
		
		mov ganador,1	;establecer la variable ganadora en 1
		Call GAME_OVER	

		RET
		Colision_Ballon: ;Compruebe si hay colisiones de encendido
		cmp ActivarPoder , 6
		je NoEncendido

		MOV AX,Disparo1_X	;obtener la coordenada X de PowerUp
		add ax,TamanoBalas
		CMP AX	,157d	;la comparación entre los dos, de la ubicación de la bala es mayor, de lo que podría haber una colisión
	JL NoEncendido		;si no hay colisión, buscamos al luchador derecho

	
		MOV AX,Disparo1_Y		;obtener las coordenadas Y de la viñeta
		CMP AX,71d			
		JL NoEncendido	;si no hay colisión Verifique Right Fighter

		
		CMP Disparo1_Y,79d		
		JG NoEncendido		

		mov PotenciaColisicion , 1d	;dejar de generar más potenciadores, si el proceso de generación no terminó
		CALL FIN_PODERUPLIFESPAN		;borrar encendido
		CALL RESETEAR_POSICIONDEBALAS	;restablecer la posición de la viñeta para prepararse para el siguiente disparo
		CALL USOPODERES1			;Usa el efecto de encendido para el jugador 1
		mov ActivarPoder,6d			;resetear
		NoEncendido:
	    RET
	MoverBala ENDP


	
	MoverBala2 PROC NEAR					

		
			mov ax, 0A000h      ;a la pantalla de gráficos
            mov es, ax  		;			
			;repetir para el jugador 2

			MOV AX,Disparo2_Y 					
           	MOV DX,Disparo2_X					
        	mov cx, Ancho_Ventana
        	mul cx					
        	add ax,Disparo2_X
        	mov di, ax      
            mov Al,00H
            mov cx,TamanoBalas       
            rep STOSB
        	MOV AX,Disparo2_Y
        	mov cx, Ancho_Ventana
        	mul cx					
        	add ax,Disparo2_X
        	add  ax,Ancho_Ventana
        	mov di, ax
        	mov Al,00H
        	mov cx,TamanoBalas 
        	rep STOSB
			


		MOV AX,VelocidadBala_X2	;Lo mismo para la bala del jugador 2
		sub Disparo2_X,AX 			;mover la bala horizontalmente en dirección negativa (de derecha a izquierda)
		
		MOV AX,Limite
		CMP Disparo2_X,AX 			;Disparo2_X se compara con los límites izquierdos de la pantalla
		JL Reset_Pos2 			;si es menor, restablecer la posición
	 
		jmp contafterjmp2 
		Reset_Pos2:			;AME COMO PARA disparo1, Pero después de este, sale de procedimiento, porque si BULLET está fuera de límites
										;entonces no puede golpear barcos o potenciadores, por lo que no es necesario hacer más cálculos
		Call RESETEAR_POSICIONDEBALAS2
		RET							


		contafterjmp2:
		
		CheckColision_Izquierda:
		MOV AX,POSX		
		add ax,TempAncho 
		sub ax,10d
		CMP AX,Disparo2_X 	
		JNG Colision_Ballon2	;Salir del proceso si no hay colisión

		MOV AX,Disparo2_Y
		ADD AX,TamanoBalas
		CMP AX,POSY	;igual que el luchador derecho
		JNG Colision_Ballon2	;Salir del proceso si no hay colisión

		MOV AX,POSY
		ADD AX,TempAlto
		CMP Disparo2_Y,AX 		;igual que el luchador derecho
		JNL Colision_Ballon2	;Salir del proceso si no hay colisión

		
		cmp arma1,48d
		je Calcu_VidaJugador2
		dec arma1
		jmp hit2
		Calcu_VidaJugador2:
		Dec vida1	;disminuir la salud del jugador
		cmp vida1 , 48d	;Compruebe si la salud es cero, CERO EN ASCII es 48
								
		je ENDGAME2				
		hit2:
		CALL RESETEAR_POSICIONDEBALAS2 ;
        RET
        
		ENDGAME2:	
		mov ganador ,2	;mostrar ganador 2
		Call GAME_OVER ;Llame al PROTOCOLO DE JUEGO TERMINADO
		RET
		Colision_Ballon2: 
		cmp ActivarPoder , 6
		je NoEncendido2

		MOV AX,Disparo2_X	;obtener la coordenada X del poder
		CMP AX	,164d	
		JG NoEncendido2		
		MOV AX,Disparo2_Y		;obtener las coordenadas Y de la viñeta
		CMP AX,71d				
		JL NoEncendido2	;si no hay colisión Verifique Left Fighter


		CMP Disparo2_Y,79d		;Verifique y vea si la viñeta Y es menor que PU Y + PU Altura
		JG NoEncendido2		;si no hay colisión Verifique Left Fighter

		mov PotenciaColisicion , 1d
		CALL FIN_PODERUPLIFESPAN
		CALL RESETEAR_POSICIONDEBALAS2
		CALL UsoPoderes2
		mov ActivarPoder,6d
		NoEncendido2:
	    RET
	MoverBala2 ENDP
;COMPRUEBA EL MULDISPARO QUE SE VA EN X Y Y Y TAMBIEN SI PEGA EN EL JUGADOR O QUE HACE
MovMultiDisparo PROC ;;;

			mov ax, 0A000h      
            mov es, ax  				
			MOV AX,DisparoM2_Y 					
           	MOV DX,Disparo2_X					
        	mov cx, Ancho_Ventana
        	mul cx					
        	add ax,DisparoM2_X
        	mov di, ax      
            mov Al,00H
            mov cx,TamanoBalas       
            rep STOSB
        	MOV AX,DisparoM2_Y
        	mov cx, Ancho_Ventana
        	mul cx					
        	add ax,DisparoM2_X
        	add  ax,Ancho_Ventana
        	mov di, ax
        	mov Al,00H
        	mov cx,TamanoBalas 
        	rep STOSB
			
			mov ax, 0A000h      
            mov es, ax  					
			MOV AX,DisparoM1_Y 					
           	MOV DX,DisparoM1_X					
        	mov cx, Ancho_Ventana
        	mul cx					
        	add ax,DisparoM1_X
        	mov di, ax      
            mov Al,00H
            mov cx,TamanoBalas       
            rep STOSB
        	MOV AX,DisparoM1_Y
        	mov cx, Ancho_Ventana
        	mul cx					
        	add ax,DisparoM1_X
        	add  ax,Ancho_Ventana
        	mov di, ax
        	mov Al,00H
        	mov cx,TamanoBalas 
        	rep STOSB
			; SIGUIENTE movemos ambas viñetas en sus respectivas direcciones
		MOV AX,DisparoM_VelocidadX1	;agregue la velocidad de la bala en la dirección X a su coordenada X actual
		ADD DisparoM1_X,AX 			;mover la viñeta horizontalmente (de izquierda a derecha)
		MOV AX,DisparoM_VelocidadX2	;agregue la velocidad de la bala en la dirección X a su coordenada X actual
		ADD DisparoM2_X,AX 			;mover la viñeta horizontalmente (de izquierda a derecha)
		MOV AX,DisparoM_VelocidadY1	;agregue la velocidad de la bala en la dirección X a su coordenada X actual
		ADD DisparoM1_Y,AX 			;mover la viñeta horizontalmente (de izquierda a derecha)
		MOV AX,DisparoM_VelocidadY2	;agregue la velocidad de la bala en la dirección X a su coordenada X actual
		ADD DisparoM2_Y,AX 			;mover la viñeta horizontalmente (de izquierda a derecha)
		MOV AX,Limite
		CMP DisparoM1_Y,AX					;;DisparoM1_Y se compara con los límites SUPERIORES de la pantalla
		JL NegVelocidadY1				;si es menor invertir la velocidad en Y
		jmp CheckLimiteArriba
		NegVelocidadY1:
		NEG DisparoM_VelocidadY1
		CheckLimiteArriba:
		MOV AX,Limite
		CMP DisparoM2_Y,AX					;DisparoM2_Y se compara con los límites SUPERIORES de la pantalla
		JL NegVelocidadY2				;si es menor invertir la velocidad en Y
		jmp CheckLimiteAbajo
		NegVelocidadY2:
		NEG DisparoM_VelocidadY2
		CheckLimiteAbajo:
		
		
		MOV AX,Alto_Ventana
		SUB AX,TamanoBalas
		SUB AX,Limite					
		CMP DisparoM1_Y,AX					
		JG NegVelocidadY12				
		jmp CheckLimiteAbajo2
		NegVelocidadY12:
		NEG DisparoM_VelocidadY1
		CheckLimiteAbajo2:
		MOV AX,Alto_Ventana
		SUB AX,TamanoBalas
		SUB AX,Limite					
		CMP DisparoM2_Y,AX					
		JG NegVelocidadY122				
		jmp CheckLimiteAbajo22
		NegVelocidadY122:
		NEG DisparoM_VelocidadY2
		CheckLimiteAbajo22:

		
		MOV AX,Ancho_Ventana			;Obtener ancho de ventana en hacha
		SUB AX,TamanoBalas			;Reste el tamaño de la viñeta de él
		SUB AX,Limite		;Restar límites de ventana
		CMP DisparoM1_X,AX			;DisparoM1_X se compara con los límites derechos de la pantalla
		JG  Reset_Pos_M 	;si es mayor, resetear posición
		MOV AX,Limite
		CMP DisparoM2_X,AX 			;Disparo2_X se compara con los límites izquierdos de la pantalla
		JL Reset_Pos_M 			;si es menor, restablecer la posición
	
		jmp contafterjmpM 
		Reset_Pos_M: 
		Call Restea_Balas_Posicion_AFTERSHOT 
		RET			


		
		contafterjmpM:
		MOV AX,POS_DERECHOX	;Obtener la coordenada X del luchador derecho
		add ax,10				
		CMP DisparoM1_X,AX		
									;para asegurarnos de que comprobamos la ubicación y
									
		JL CheckColision_IzquierdaM		;si no hay colisión, verificamos el caza izquierdo

	
		MOV AX,DisparoM1_Y		;obtener las coordenadas Y de la viñeta
		CMP AX,POS_DERECHOY	
		JNG CheckColision_IzquierdaM	;si no hay colisión Verifique Left Fighter

	
		MOV AX,POS_DERECHOY	;Consigue la coordenada del luchador
		ADD AX,TempAlto	;
		CMP DisparoM1_Y,AX		
		JG CheckColision_IzquierdaM		

		cmp arma2 , 48d
		je SaludJugador2M
		Dec arma2
		Jmp hit1M
		SaludJugador2M:
        Dec vida2	;disminuir la salud del jugador
		cmp vida2 , 48d ;Compruebe si la salud es cero, CERO EN ASCII es 48
								
		je ENDGAME1M				
		hit1M:
		CALL Restea_Balas_Posicion_AFTERSHOT	
        RET

		CheckColision_IzquierdaM:
		MOV AX,POSX		
		add ax,TempAncho 
		sub ax,10d
		CMP AX,DisparoM1_X 	;
		JNG Colision_BallonM	;Salir del proceso si no hay colisión

		MOV AX,DisparoM1_Y
		ADD AX,TamanoBalas
		CMP AX,POSY	;igual que el luchador derecho
		JNG Colision_BallonM	;Salir del proceso si no hay colisión

		MOV AX,POSY
		ADD AX,TempAlto
		CMP DisparoM1_Y,AX 		;igual que el luchador derecho
		JNL Colision_BallonM	;Salir del proceso si no hay colisión

		cmp arma1,48d
		je Calcu_VidaJugador2M
		dec arma1
		jmp hit2M
		Calcu_VidaJugador2M:
		Dec vida1	;disminuir la salud del jugador
		cmp vida1 , 48d	
		je ENDGAME2M				
		hit2M:
		CALL Restea_Balas_Posicion_AFTERSHOT ;
        RET
        ;
        ENDGAME1M:	;si ganara el jugador 1
		mov ganador,1	;set ganador variable to 1
		Call GAME_OVER	
		RET
		
		
		ENDGAME2M:	;	si ganara el jugador 2
		mov ganador ,2	;establecer ganador var a 2
		Call GAME_OVER 
		RET
		Colision_BallonM: 

		MOV AX,POS_DERECHOX	;Obtener la coordenada X del luchador derecho
		add ax,10			
		CMP DisparoM2_X,AX		
		JL CheckColision_IzquierdaM2		
		
		MOV AX,DisparoM2_Y		;obtener las coordenadas Y de la viñeta
		CMP AX,POS_DERECHOY	
		JNG CheckColision_IzquierdaM2	
		
		;se verifica si existe una colision en la derecha
		MOV AX,POS_DERECHOY	;Consigue la coordenada del luchador
		ADD AX,TempAlto	;agregue la altura del luchador, ahora tenemos el último píxel Y del luchador
		CMP DisparoM2_Y,AX		;Verifique y vea si la viñeta Y es menor que el luchador Y + la altura del luchador
		JG CheckColision_IzquierdaM2		;si no hay colisión Verifique Left Fighter

		cmp arma2 , 48d
		je SaludJugador2M2
		Dec arma2
		Jmp hit1M2
		SaludJugador2M2:
        Dec vida2	;disminuir la salud del jugador
		cmp vida2 , 48d 
								
		je ENDGAME1M				
		hit1M2:
		CALL Restea_Balas_Posicion_AFTERSHOT	;si hay colisión, devuelva la bala al luchador para prepararse para un nuevo disparo
        RET

		CheckColision_IzquierdaM2:
		MOV AX,POSX		
		add ax,TempAncho 
		sub ax,10d
		CMP AX,DisparoM2_X 	
		JNG Colision_BallonM2	

		MOV AX,DisparoM2_Y
		ADD AX,TamanoBalas
		CMP AX,POSY	;lo mismo para el iron man del lado derecho
		JNG Colision_BallonM2	

		MOV AX,POSY
		ADD AX,TempAlto
		CMP DisparoM2_Y,AX 		;lo mismo para el iron man del lado derecho
		JNL Colision_BallonM2	

		cmp arma1,48d
		je Calcu_VidaJugador2M2
		dec arma1
		jmp hit2M
		Calcu_VidaJugador2M2:
		Dec vida1	;disminuir la salud del jugador
		cmp vida1 , 48d	
		je ENDGAME2M2				;
        RET	
		ENDGAME2M2:	;si gana el jugador 2
		
		mov ganador ,2	;establecer ganador var a 2
		Call GAME_OVER ;llamamos a juego terminado
		RET
		Colision_BallonM2:

		RET
MovMultiDisparo ENDP
;Dibujando el multidisparo cada foototograma
PintarMultiDisparo PROC
            mov ax, 0A000h      
            mov es, ax  		

			;DIBUJANDO PRIMERA BALA MULTIDISPARO
            MOV AX,DisparoM1_Y 					;establecer la línea inicial (Y) en el hacha
           	MOV DX,DisparoM1_X					;establecer la línea inicial (X) en el hacha
        	mov cx, Ancho_Ventana				;establezca cx en 320, ancho de ventana
        	mul cx								
        	add ax,DisparoM1_X					;añadir a la columna
        	mov di, ax      ; (row*320+col)  	;establecer di con la ubicación exacta para dibujar
            mov Al,0CH							;color de píxel rojo claro
            mov cx,TamanoBalas       			;bucle para escribir tamaño de viñeta número de píxeles
            rep STOSB							;repetir almacenar un solo byte y dec cx hasta cx = 0
        	MOV AX,DisparoM1_Y					
        	mov cx, Ancho_Ventana				
        	mul cx								
        	add ax,DisparoM1_X					;añadir a la columna
        	add  ax,Ancho_Ventana				;agregue el ancho de la ventana para obtener la siguiente fila
        	mov di, ax							;agregue el ancho de la ventana para obtener la siguiente fila		
        	mov Al,0CH							;color de píxel rojo claro
        	mov cx,TamanoBalas 					;loop para escribir tamaño de viñeta número de píxeles
        	rep STOSB
			;lo mismo para el jugador 2
            MOV AX,DisparoM2_Y 					
           	MOV DX,DisparoM2_X					
        	mov cx, Ancho_Ventana				 
        	mul cx								
        	add ax,DisparoM2_X					
        	mov di, ax      ; (row*320+col)  	
            mov Al,0CH							
            mov cx,TamanoBalas       			
            rep STOSB							
        	MOV AX,DisparoM2_Y					
        	mul cx								 
        	add ax,DisparoM2_X					
        	add  ax,Ancho_Ventana				
        	mov di, ax								
        	mov Al,0DH							
        	mov cx,TamanoBalas 					
        	rep STOSB							
            RET
PintarMultiDisparo ENDP

GAME_OVER PROC NEAR  
	CALL StadoBar  

	
	mov al, 1				
	mov bh, 0				;numero de pagina
	mov bl,  00001101b		;Atributos :Color morado sobre fondo negro
	mov cx, offset FINJUEGO - offset FINISH  ;calcular el tamaño del mensaje para el bucle 			
	mov dh, 2d				
	mov dl,15D				;numero de columna
	push DS 				;Necesario para interrumpir no romper el código
	pop es					; es = ds
	mov bp, offset FINISH	
	mov ah, 13h				
	int 10h				


	;Ahora mostramos game over durante 5 segundos y luego seguimos
	MOV AH,2Ch					;obtener la hora del sistema
	INT 21h						
	mov TiempoAuxSeg,dh			;Nosotros obtenemos segundos
	add TiempoAuxSeg, 5			;Sumamos 5 (como en 5 segundos)
	cmp TiempoAuxSeg , 60
	JB CincoSegundos

	sub TiempoAuxSeg, 60 ; 
	
	CincoSegundos: 					;un bucle para comprobar la llegada de la siguiente trama
		MOV AH,2Ch					;obtener la hora del sistema
		INT 21h						
		mov al, TiempoAuxSeg		; Obtener el tiempo + 5 segundos
		sub al, DH					;restar la hora actual
		JNS NOTNEGATIVE 			
		NEG al						
		mov dh,60					
		sub dh,al					;resta ese nuevo número de 60
		mov al,dh					;ahora en todo tenemos el valor correcto
		NOTNEGATIVE:				;proceder a la impresión y cuenta regresiva
		mov MuestraSegundos, al		
		add MuestraSegundos,48d		;compruebe si el resultado es 0, si es así, salga del bucle
		cmp MuestraSegundos,0			
		JE DONT

		
		mov al, 1				
		mov bh, 0				;numero de pagina
		mov bl,  00001101b		;Atributos : color morado sobre fondo negro
		mov cx, 1  ; calcular el tamaño del mensaje para el bucle		
		mov dh, 5d				
		mov dl,19D				;numero de columna
		push DS 				;Necesario para interrumpir no romper el código
		pop es					; es = ds
		mov bp, offset MuestraSegundos	
		mov ah, 13h				
		int 10h						
		
		DONT:					;si han pasado 5 segundos, entonces continuamos haciendo reinicios de nivel
		MOV AH,2Ch					;obtener la hora del sistema
		INT 21h						
		CMP DH,TiempoAuxSeg				;;¿el tiempo actual es igual al anterior (TiempoAux)?
		JNE CincoSegundos				;si es lo mismo, espere un nuevo marco



	QUICK:	
	mov POSX, 0
	mov POSY, 0AH
	mov VIEJAPOSX, 0
	mov VIEJAPOSY, 0AH

	mov POS_DERECHOX, 280d
	mov POS_DERECHOY, 90D
	mov OLDPOS_DERECHOX, 280d
	mov OLDPOS_DERECHOY, 100D

	mov Disparo1_X , 0Ah 			        ;posición X actual (columna) de la viñeta del primer jugador
	mov Disparo1_Y , 30d 			        ;posición Y actual (línea) de la viñeta del primer jugador
	mov Disparo2_X , 278d 					;posición X actual (columna) de la viñeta del segundo jugador
	mov Disparo2_Y , 119D 					;posición Y actual (línea) de la viñeta del segundo jugador


	mov al, 03h 
	mov ah, 0		
	int 10h		 

	;pantalla clara, lápiz MORADO fondo NEGRO
    MOV AX,0600H         	              
    MOV BH,00001101b				
    MOV CX,0000H			
    MOV DX,184FH			
    INT 10H					

	
    MOV AH,02H
    MOV BH,00
    MOV DX,081BH   ; X = 1b, Y = 8
    INT 10H    

	cmp ganador,2 ;verifique qué jugador ganó para mostrar la cadena apropiada
	je SegundoGANA 		;si 2 entonces salta ahi
	mov dx, Offset gano1 	;obtener una cadena ganada por el jugador
	mov     ah, 09h
	int     21h	;cadena de visualización

    MOV AH,02H
    MOV BH,00
    MOV DX,0D1BH ; X = 1b, Y = D
    INT 10H   
    ;imprimir mensaje
    mov dx, Offset PresionarEnter ;obtener presione ingresar cadena
	mov     ah, 09h
	int     21h		;imprime int


	EntradaDeGanador:
    mov     ah, 7  ;tomar entrada
	int     21h        
    cmp al,	0Dh ;check el enter
    jne EntradaDeGanador	;no entrar, esperar otra entrada
	jmp Returnganador	
	SegundoGANA:
	mov dx, Offset gano2 
	mov     ah, 09h
	int     21h
  
    MOV AH,02H
    MOV BH,00
    MOV DX,0D1BH ; X = 1b, Y = D
    INT 10H   
    ;imprime mensaje
    mov dx, Offset PresionarEnter 
	mov     ah, 09h
	int     21h
	EntradaDeGanador2:
    mov     ah, 7  ;tomar entrada
	int     21h        
    cmp al,	0Dh
    jne EntradaDeGanador2

Returnganador:
RET
GAME_OVER ENDP
;Resetear posicion de las balas
;uno para el multi disparo
;una bala para el primer y segundo jugador

Restea_Balas_Posicion PROC
	cmp VariosTiros , 0		;SI EL MULTIDISPARO AÚN NO SE HA DISPARADO, CONFIGURAR LA UBICACIÓN EN BLASTER DE MULISHOOTER, P1 O P2
	je ComienzaMulti		;DE LO CONTRARIO, SI DISPARA, REGRESA SIN RESETEAR
	RET
	ComienzaMulti:		
	cmp MultiDisparo,2
	je SecondPlayer				;SI MultiDisparo ES EL JUGADOR 2, SALTAR AL JUGADOR 2
	MOV AX,POSX		;OBTENER LUCHADOR X POSICIÓN
	add AX,TempAncho 		;AGREGAR ANCHO A ESA POSICIÓN
	mov DisparoM1_X, ax			;MUEVA ESE VALOR A LA POSICIÓN X DE AMBAS VIÑETAS
	mov DisparoM2_X, ax
	mov DisparoM_VelocidadX1 , 4d	;ESTABLECER LA VELOCIDAD DE LA BALA MULTIDISPARO
	mov DisparoM_VelocidadX2 , 4d
	MOV AX,POSY			
	add ax,19d						;AGREGAR MEDIA ALTURA DE CAZA
	mov DisparoM1_Y, ax				;MUEVA ESA UBICACIÓN A LA POSICIÓN Y DE AMBAS VIÑETAS
	mov DisparoM2_Y, ax
	mov DisparoM_VelocidadY1 , 4d	
	mov DisparoM_VelocidadY2 , 4d
	NEG DisparoM_VelocidadY2		;LA BALA 2 TIENE VELOCIDAD NEGATIVA, VA HACIA ABAJO
	RET
	;lo mismo para el segundo jugador
	SecondPlayer:
	MOV AX,POS_DERECHOX 				
	sub ax, TamanoBalas														 
	mov DisparoM1_X, ax
	mov DisparoM2_X, ax
	mov DisparoM_VelocidadX1 , 4d
	mov DisparoM_VelocidadX2 , 4d
	NEG DisparoM_VelocidadX1	;NEGATIVO, VA DE DERECHA A IZQUIERDA PARA EL JUGADOR 2
	NEG DisparoM_VelocidadX2	;NEGATIVO, VA DE DERECHA A IZQUIERDA PARA EL JUGADOR 2
	MOV AX,POS_DERECHOY
	add ax,19							
	mov DisparoM1_Y, ax
	mov DisparoM2_Y, ax
	mov DisparoM_VelocidadY1 , 4d
	mov DisparoM_VelocidadY2 , 4d
	NEG DisparoM_VelocidadY2		
RET	
Restea_Balas_Posicion ENDP

Restea_Balas_Posicion_AFTERSHOT PROC 	
Mov VariosTiros, 0 
mov MultiDisparo, 0
RET	
Restea_Balas_Posicion_AFTERSHOT ENDP

RESETEAR_POSICIONDEBALAS proc NEAR				;Procedimiento que podría cambiar más tarde, por ahora restablece bala a blaster

   		MOV AX,POSX
		add AX,TempAncho 					
		MOV Disparo1_X,AX 					;establecer la coordenada X actual de la bala en los blasters de fighter1
		MOV AX,POSY
		add ax,19							;haz que dispare desde el centro del caza (altura/2 - 1)
		MOV Disparo1_Y,AX 					;establecer la coordenada Y actual de la bala en los blasters de fighter1
		mov Tiro1 ,0										
RET											
RESETEAR_POSICIONDEBALAS ENDP

RESETEAR_POSICIONDEBALAS2 proc NEAR

   		MOV AX,POS_DERECHOX 				
		sub ax, TamanoBalas					
											
		MOV Disparo2_X,AX 					
	
		MOV AX,POS_DERECHOY
		add ax,19							
		MOV Disparo2_Y,AX 					 
		mov Tiro2 ,0
											
RET
RESETEAR_POSICIONDEBALAS2 ENDP
;Limpiar pagina
	LIMPIAR PROC NEAR 				;procedimiento para borrar la pantalla reiniciando el modo video

		MOV AH,00h 						;establecer la configuración en modo video
		MOV AL,13h 						;elegir el modo de vídeo
		INT 10h							;ejecutar la configuración

		MOV AH,0Bh						;establecer la configuración
		MOV BH,00h						;al color de fondo
		MOV BL,00h 						;Elegir negro como fondo
		INT 10h 						
		
		RET
	LIMPIAR ENDP
;obtener nombre del jugador
    ObtenerNombreJugador proc NEAR		
    MOV AX,0600H                  
    MOV BH,00001101b
    MOV CX,0000H
    MOV DX,184FH
    INT 10H			;fondo gris modo texto 80x25 8 páginas

    MOV AH,02H
    MOV BH,00
    MOV DX,081BH   ; X = 17, Y = 8
    INT 10H    
    ;Imprime_Mensaje
    mov dx, Offset IngresaNombre 
	mov     ah, 09h
	int     21h
    ;establecer la ubicación del cursor en el centro de la pantalla
    MOV AH,02H
    MOV BH,00
    MOV DX,0C1BH ; X  = 17, Y = D
    INT 10H   
    ;Imprime_Mensaje
    mov dx, Offset PresionarEnter 
	mov     ah, 09h
	int     21h
    ;establecer la ubicación del cursor en el centro de la pantalla
    MOV AH,02H
    MOV BH,00
    MOV DX,0A1FH ; X = 17, Y = A
    INT 10H   

	

    ObtenerInput:	
	mov cx,0
    mov     ah, 7 
	int     21h     

	   
    cmp al,'A'	
    jb ObtenerInput
    cmp al,'Z'  ;;si entre la A y la Z, efectivamente es una letra continúe, si no, salte a la isletra para marcar en MINÚSCULAS
    Ja IsLetter	;;ir a isleter para marcar minúsculas si no mayúsculas
    Letter:		;si llega hasta aqui entonces es una carta
  
    mov     ah, 2  
	mov     dl, al
    int     21h 	
    mov NombreJugador,al
    mov cx,1	
    JMP GetRestOfName 

    IsLetter:
    cmp al, 'a'		
    jb ObtenerInput
    cmp al, 'z'		
    ja ObtenerInput		
    JMP Letter		

	

    BackSpace: 
    dec cx	;El contador se decrementa (porque la letra borrada lo habría incrementado)
	cmp cx,0
	jb ObtenerInput
    mov di,cx	;mueva cx a di para establecer di en la ubicación de la letra que se eliminará
    mov NombreJugador[di] , ' '	;Escriba el signo de espacio en lugar del valor anterior
    mov     ah, 2  	
	mov     dl, 8d	
    int     21h 		;hacer un Backspace
    mov     ah, 2  
	mov     dl, 32d
    int     21h 		;Haz un espacio Normal (para sobrescribir visualmente la letra)
    mov     ah, 2  
	mov     dl, 8d		;
    int     21h 
    cmp cx,0			
    JE ObtenerInput


    GetRestOfName:
    mov     ah, 7  ;entrada
	int     21h 
    cmp al, 13d ; Compruebe si el usuario presiona enter
    JE EndofObtenerNombreJugador	;si el usuario presiona enter, no tome más valores, salte al final
    cmp al,8d				
    jE BackSpace			
    cmp cx,15;compruebe si se alcanzó el límite de tamaño del nombre (15 caracteres)
    JE GetRestOfName	;si lo hizo, no lo guarde y espere a que ingrese la tecla
    mov     ah, 2  		;si no fue así, guárdelo en la variable
	mov     dl, al
    int     21h 		;mostrar en la pantalla
    mov di,cx
    mov NombreJugador[di] , al	;guardar la variable
    inc cx  
    JMP GetRestOfName	;repetir
    

    EndofObtenerNombreJugador: ;Si el usuario presiona entrar, entonces:
   
    REtObtenerNombreJugador:	;si eran 15 entonces sal sin hacer nada
    RET
    ObtenerNombreJugador ENDP
	MiMenu proc NEAR

	mov ganador,0 ;Restablecer ganador de nuevo a cero
	
	mov al, 03h	 ;modo texto
	mov ah, 0
	int 10h
   MOV AX,0600H                       
    MOV BH,00001101b
    MOV CX,0000H
    MOV DX,184FH
    INT 10H
    MOV AH,02H
    MOV BH,00
    MOV DX,081BH   ; X  = 17, Y = 8
    INT 10H    
    ;Imprime_Mensaje
    mov dx, Offset msg1 
	mov     ah, 09h
	int     21h
    
    MOV AH,02H
    MOV BH,00
    MOV DX,0A1BH ; X  = 17, Y = A
    INT 10H    
    ;Imprime
    mov dx, Offset msg2 
	mov     ah, 09h
	int     21h
    
    MOV AH,02H
    MOV BH,00
    MOV DX,0B1BH ; X  = 17, Y = B
    INT 10H    
    ;Imprime
    mov dx, Offset msg3 
	mov     ah, 09h
	int     21h
   
    MOV AH,02H
    MOV BH,00
    MOV DX,0C1BH ; X= 17, Y = C
    INT 10H    
    ;Imprime
    mov dx, Offset msg4 
	mov     ah, 09h
	int     21h
   MOV AH,02H
    MOV BH,00
    MOV DX,9D1BH ; X  = 17, Y = D
    INT 10H    

    ;Comprobar el suo de F1 y F2
    ObtenerNumero:
    mov     ax, 0  
	int     16h       
    ; verifique si la entrada es f1 o f2 o ESC, de lo contrario, vuelva a tomar otra entrada
	cmp     ah, 3Bh
	jE     Arqui  
	cmp     ah, 3Ch
	jE     StartModosJuego 
    cmp     ah, 01h
	jE     Escape   
    JMP ObtenerNumero ;repetir 

    StartModosJuego: CALL ModosJuego
    jmp RetMiMenu
    Arqui: 
    jmp RetMiMenu
    Escape:
   
    MOV AX,0600H                       
    MOV BH,00001101b
    MOV CX,0000H
    MOV DX,184FH
    INT 10H
    MOV AH,02H
    MOV BH,00
    MOV DX,0C0DH   ; X  = 17, Y = 8
    INT 10H    
    ;Imprime_Mensaje
    mov dx, Offset msg0  
	mov     ah, 09h
	int     21h

   MOV AH,02H
    MOV BH,00
    MOV DX,881BH   ; X  = 17, Y = 8
    INT 10H    
    MOV AH,4CH          
    INT 21H


	
    RetMiMenu:
    RET
    MiMenu ENDP
    ;PROYECTO DE ARQUITECTURA DEL COMPUTADOR 1 GRUPO 4
    END MAIN
