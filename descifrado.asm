.data

###########################################
# Equivalencias
#
# Para definir constantes num�ricas como el tama�o m�ximo del criptograma o del nombre del fichero.
###########################################
	.eqv	TAMANONOMBREFICHEROMAX	80	# N�mero m�ximo de caracteres que podr� tener el nombre del fichero que contiene el criptograma o en el que guardaremos la soluci�n 
	.eqv	TAMANOTEXTOMAX 		1000	# N�mero m�ximo de caracteres que podr� tener el criptograma
	.eqv	TAMANOABECEDARIO	26	# N�mero de letras del abecedario, sin contar la �, se corresponde con el tama�o de varios vectores que aparecen a lo largo del programa
	
###########################################
# Variables globales, incluidas las cadenas de texto que se muestran por la consola
###########################################	
frecuenciaAbsoluta:	.space 	TAMANOABECEDARIO  # Vector para las frecuencias absolutas
frecuenciaRelativa:	.space  TAMANOABECEDARIO  # Vector frecuencias relativas del criptograma
frecuenciaMedia:	.word	13,1,5,6,14,1,1,1,6,0,0,5,3,7,9,3,1,7,8,5,4,1,0,0,1,1 # Porcentajes de frecuencias relativas medias de aparici�n de letras en espa�ol. Se ha redondeado al entero m�s cercano. Cada componente corresponde a una letra seg�n su orden en el abecedario
vectorDistancia:	.space	TAMANOABECEDARIO
nombreFichero:		.space	TAMANONOMBREFICHEROMAX	# Nombre de fichero que se abre/escribe
mensajeLeerCriptograma:	.asciiz	"\n\nEscribe el nombre del fichero que contiene el criptograma: "
mensajeFichero:		.asciiz "Fichero "
mensajeLeido:		.asciiz " le�do correctamente\n" 
mensajeGuardado:	.asciiz " guardado correctamente\n"
mensajeElCriptogramaEs:	.asciiz "\nEl criptograma es:\n\n"
mensajeErrorFichero:	.asciiz "�Error de E/S con el fichero "
mensajeExclamacion:	.asciiz "!\n"
mensajeGuardarSolucion:	.asciiz "\n\nEscribe el nombre del fichero en el que grabaremos la soluci�n: "
mensajeErrorCriptograma:.asciiz	"\n�Error: No hay ningun criptograma cargado!\n"
mensajeNL:		.asciiz "\n"
tamanoTextoCriptograma:	.word	0	# N�mero caracteres que contiene el criptorama, se actualiza en subrutina contarLetras
texto:			.space	TAMANOTEXTOMAX 	# Variable donde se almacena el criptograma
mensajeMenu:		.asciiz "\nMen� de opciones:\n"
opcion1Menu:		.asciiz "\n 1. Leer criptograma desde fichero\n"
opcion2Menu:		.asciiz "\n 2. Autodescodificar el criptograma\n"
opcion3Menu:		.asciiz "\n 3. Escribir resultado en fichero\n"
opcion4Menu:		.asciiz "\n 4. Salir\n"
elegirMenu:		.asciiz "\n Elige la opci�n deseada (1-4)\n"
laClaveEs:		.asciiz "La clave es: "
empty:			.asciiz " "


.text
###########################################
# Comienzo del programa principal
###########################################
MENU:
	# PRINT mensaje MENU:
		# Carga en $a0 la direcci�n de memoria donde comienza la variable mensajeMenu
       		# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	la	$a0, mensajeMenu
	li	$v0, 4
	syscall
	
	# PRINT mensaje opcion1Menu:
		# Carga en $a0 la direcci�n de memoria donde comienza la variable opcion1Menu
       		# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	la	$a0, opcion1Menu
	li	$v0, 4
	syscall
	
	# PRINT mensaje opcion1Menu:
		# Carga en $a0 la direcci�n de memoria donde comienza la variable opcion2Menu
       		# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	la	$a0, opcion2Menu
	li	$v0, 4
	syscall
	
	# PRINT mensaje opcion1Menu:
		# Carga en $a0 la direcci�n de memoria donde comienza la variable opcion3Menu
       		# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	la	$a0, opcion3Menu
	li	$v0, 4
	syscall
	
	# PRINT mensaje opcion1Menu:
		# Carga en $a0 la direcci�n de memoria donde comienza la variable opcion4Menu
       		# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	la	$a0, opcion4Menu
	li	$v0, 4
	syscall
	
	# PRINT mensaje opcion1Menu:
		# Carga en $a0 la direcci�n de memoria donde comienza la variable elegirMenu
       		# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	la	$a0, elegirMenu
	li	$v0, 4
	syscall
	
	# READ numero por teclado (opci�n del men�):
       		# Llamada al sistema con el servicio que carga en $v0 el entero que se lee por teclado
	li	$v0, 5
	syscall
	
	# Comprobaci�n valor introducido
	beq 	$v0, 1, OPCION1
	beq 	$v0, 2, OPCION2
	beq 	$v0, 3, OPCION3
	beq 	$v0, 4, OPCION4
	
	# Control introducci�n err�nea
	bgt 	$v0, 4, MENU
	blt	$v0, 1, MENU
	
# Llamadas a cada una de las opciones
	
OPCION1: 	# OPCI�N1: llamada a la subrutina leerCriptograma
	la	$a0, texto			# $a0 <-- puntero a la variable texto
	li	$a1, TAMANOTEXTOMAX		# $a1 <-- valor de la variable TAMANOTEXTOMAX	
	jal	leerCriptograma			# llamada a la subrutina leerCriptograma
	sw 	$v0, tamanoTextoCriptograma	# tamanoTextoCriptograma <-- $v0
	
	# Comprobaci�n que el criptograma est� en memoria
	move	$s0, $v0
	
	j	MENU				# salto a la etiqueta MENU
	
OPCION2:	# OPCI�N2: llamada a la subrutina autodescodificar
	la	$a0, texto			# $a0 <-- puntero a la variable texto
	la	$a1, frecuenciaMedia		# $a1 <-- puntero a la variable frecuenciaMedia
	li	$a2, TAMANOABECEDARIO		# $a2 <-- valor de la variable TAMANOABECEDARIO	
	lw	$a3, tamanoTextoCriptograma	# $a3 <-- valor de la variable tamanoTextoCriptograma
	
	# Comprobaci�n que el criptograma est� en memoria
	beq 	$s0, $zero, VolverMenu
	
	jal	autodescodificar		# llamada a la subrutina autodescodificar
	j	MENU				# salto a la etiqueta MENU
VolverMenu: 
	# Carga en $a0 la direcci�n de memoria donde comienza la variable mensajeErrorCriptograma
       	# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	li	$v0, 4		
	la	$a0, mensajeErrorCriptograma
	syscall	
	j	MENU				# salto a la etiqueta MENU	
		
OPCION3:	# OPCI�N3: llamada a la subrutina escribirResultado
	la	$a0, texto			# $a0 <-- puntero a la variable texto
	la	$s1, tamanoTextoCriptograma	# $s1 <-- valor de la direcci�n de memoria de la variable tamanoTextoCriptograma
	lw	$a1, 0($s1)			# $a1 <-- valor que hay en la direcci�n de memoria de $S1
	jal	escribirResultado		# llamada a la subrutina escrbirResultado
	j	MENU				# salto a la etiqueta MENU
	
OPCION4:	# OPCI�N4: salir del men�
	# Llamada al sistema con el servicio que termina la ejecuci�n
	li	$v0, 10
	syscall
###########################################
# Fin del programa principal
###########################################



###########################################
# Subrutina leerCriptograma
#
# Tipo de subrutina:
# - Funci�n
# - Tallo
#
# Objetivos: 
# - Solicitar el nombre del fichero que
#   contiene el criptograma
# - Abrir el fichero con permiso de 
#   lectura (*)
# - Leer su contenido y cargarlo en 
#   memoria
# - Cerrar el fichero
#
# (*) Si se produce un error de apertura
#     del fichero, se termina la subrutina
#     y se regresa al programa principal
#
# Par�metros: 
# - $a0 = Puntero a la cadena de texto que 
#         contendr� el criptograma
# - $a1 = Tama�o m�ximo del texto
#
# Valor devuelto:
# - $v0 = tama�o del fichero le�do
#
# Pila: 
# - Al ser subrutina tallo, reserva 
#   hueco de 16 bytes y necesita guardar
#   el registro $ra. Tambi�n hay un hueco
#   de 4 bytes para que el total sea
#   m�ltiplo de 8 bytes
# - Realiza una copia de los par�metros $a0 
#   y $a1 en el hueco del invocador
# - No necesitamos hacer la salvaguarda de 
#   de registros: no se usan los registros $s
#   y los $t se usan despu�s de la llamada a
#   otra subrutina
# - No tiene variables locales en la pila
# 
# Marco de pila:
# |                             |
# | Marco de pila del invocador |
# |                             |
# |        Copia de $a1         | <- 28($sp)
# +-----------------------------+
# |        Copia de $a0         | <- 24($sp)
# +=============================+���������������^
# |       Hueco (4 bytes)       |		|
# +-----------------------------+		|
# |        Copia de $ra         | <- 16($sp)	|
# +-----------------------------+		|
# |       Hueco (4 bytes)       |		|
# +-----------------------------+	 24 bytes
# |       Hueco (4 bytes)       |		|
# +-----------------------------+		|
# |       Hueco (4 bytes)       |		|
# +-----------------------------+		|
# |       Hueco (4 bytes)       | <- 0($sp)	|
# +=============================+���������������V
#
###########################################		
leerCriptograma:
	# Primera parte: pr�logo de la subrutina
	addi	$sp, $sp, -24	# Reserva el hueco en la pila
	sw	$ra, 16($sp)	# Salvaguarda de la direcci�n de retorno en la pila
	sw	$a0, 24($sp)	# Salvaguarda del par�metro recibido por $a0 (puntero a la variable texto)
	sw	$a1, 28($sp)	# Salvaguarda del par�metro recibido por $a1 (tama�o m�ximo del texto)
		
	# Segunda parte: se pide un nombre de fichero por teclado
	li	$v0, 4		# Mostramos el mensaje Escribe el nombre del fichero
	la	$a0, mensajeLeerCriptograma
	syscall

	li 	$v0, 8		# Solicitamos una cadena de texto por teclado
	la	$a0, nombreFichero	# Almacenaremos la cadena tecleada en la variable global nombreFichero (suponemos por simplicidad que tenemos acceso a esta variable desde esta subrutina)
	li	$a1, TAMANONOMBREFICHEROMAX	# Este es el tama�o m�ximo que puede tener el nombre del fichero = n�mero m�ximo de caracteres que se van a leer
	syscall
	
	# Quitamos el car�cter '\n' del nombre del fichero que hemos escrito	
	#
	# Par�metros:
	# - $a0: Puntero al nombre del fichero ($a0 ya contiene esta direcci�n)
	#
	# Valor devuelto:
	# - No tiene
	jal	quitarNL	# Llamada a la subrutina quitarNL
	# Si no quitamos este car�cter '\n' del nombre del fichero, dar� un error al intentar abrirlo
  
	# Tercera parte: se abre el fichero
	li   	$v0, 13       	# Abrir fichero
  	la   	$a0, nombreFichero	# Puntero al nombre del fichero (debe terminar en el byte nulo y no tener '\n')
  	li   	$a1, 0        	# Permiso del fichero: 0 = lectura
	li   	$a2, 0		# Modo del fichero (se ignora)
	syscall           	
	move 	$t0, $v0      	# $v0 devuelve el descriptor del fichero y se hace una copia en el registro $t0
	# No nos ha hecho falta salvaguardar el registro $t0 (al ser subrutina tallo) porque lo usamos despu�s de la 
	# �nica llamada a otra subrutina (quitarNL)
	
	bge	$t0, $zero, leerCriptograma2 	# Comprobamos que el descriptor del fichero es correcto
	# Si ha surgido alg�n error de apertura del fichero, el descriptor es negativo
	# Si es positivo o cero, entonces no ha habido problema y continuamos a partir de la etiqueta leerCriptograma2

errorLeerCriptograma:
	# ERROR al abrir el fichero (descriptor negativo)
	li	$v0, 4		# Mostramos un mensaje de error en la consola
	la	$a0, mensajeErrorFichero
	syscall
	la	$a0, nombreFichero
	syscall
	la	$a0, mensajeExclamacion
	syscall
	j	finLeerCriptograma	# Saltamos al ep�logo de la subrutina para reajustar la pila
  
  	# Cuarta parte: leemos el fichero y almacenamos su contenido en la variable texto
leerCriptograma2:	
  	li	$v0, 14		# Leer fichero 
  	move	$a0, $t0	# Colocamos el descriptor del fichero en $a0
  	lw	$a1, 24($sp)	# Restauramos el par�metro que salvaguardamos en la pila (puntero a la variable texto)
  	lw	$a2, 28($sp)	# N�mero m�ximo de bytes que se van a leer (tama�o m�ximo permitido del fichero)
  	syscall
  	move	$t1, $v0	# $v0 devuelve el valor del n�mero de bytes le�dos realmente en el fichero y lo copiamos en $t1
  	
  	# Si el n�mero de bytes le�dos es 0 o negativo, se ha producido un error
  	ble	$t1, $zero, errorLeerCriptograma
  
        # Quinta parte: cerramos el fichero
  	li   	$v0, 16         # Cerrar fichero
  	move 	$a0, $t0        # Colocamos el descriptor del fichero en $a0
  	syscall   
  	
  	# Debemos asegurarnos de que el �ltimo car�cter de la variable texto
  	# sea el byte nulo que marca el final de cadena
  	lw	$a0, 24($sp)	# Puntero a la variable texto, que lo recuperamos de la pila
  	add	$a0, $a0, $t1	# Apuntamos al byte que hay justo despu�s del �ltimo le�do. $t1 contiene el n�mero de bytes le�dos en el fichero
	blt	$t1, $a2, escribirByteNulo  	# $a2 contiene (ver unas pocas l�neas m�s arriba) el tama�o m�ximo que puede tener la variable texto. Si el tama�o del fichero le�do es menor que el m�ximo permitido, saltamos a escribirByteNulo
  	addi	$a0, $a0, -1	# Restamos 1 para que apunte al �ltimo byte permitido de la variable texto, ya que hemos le�do todos los bytes posibles
escribirByteNulo:
  	sb	$zero, 0($a0)	# Escribimos el byte nulo que marca el final del texto
  	
  	# Sexta parte: Imprimimos diversos mensajes que indican que todo ha ido bien
  	li	$v0, 4
  	la	$a0, mensajeFichero	# El fichero
  	syscall
  	la	$a0, nombreFichero	# **nombre de fichero**
  	syscall
  	la	$a0, mensajeLeido	# se ha le�do correctamnete
  	syscall
  	la	$a0, mensajeElCriptogramaEs	# El criptograma es
  	syscall
  	lw	$a0, 24($sp)     	# Imprimimos el criptograma que acabamos de leer de fichero
  	syscall
  	la	$a0, mensajeNL		# Imprimimos una nueva l�nea por claridad
  	syscall
 
 	# S�ptima parte: ep�logo de la subrutina
finLeerCriptograma: 
	move	$v0, $t1	# El valor devuelto de la funci�n es el n�mero de bytes le�dos realmente en el fichero
  	lw	$ra, 16($sp)    # Restauramos la direcci�n de retorno de la pila
  	sw	$zero, 16($sp)
	addi	$sp, $sp, 24	# Restaura la pila   
	jr 	$ra		# Retorno al invocador
###########################################
# Fin de leerCriptograma
###########################################
	
			

###########################################
# Subrutina autodescodificar
#
# Tipo de subrutina:
# - Procedimiento
# - Tallo
#
# Objetivos: 
# - (*) Obtener las frecuencias relativas del 
# criptograma para compararlas con las 
# frecuencias relativas medias del espa�ol
# y as� obtener un vector de distancias,
# donde la posici�n de la distancia m�nima
# ser� el valor de la clave, por tanto, el 
# n�mero de caracteres a desplazar en el 
# criptograma para obtener el texto en claro.
#
# (*) Si se produce un error al no estar el
#     fichero en memoria, salta un mensaje 
#     de error.
#
# Par�metros: 
# - $a0 = Puntero a la variable texto
# - $a1 = Puntero a al vector frecuenciaRelativa
# - $a2 = valor variable TAMANOABECEDARIO
# - $a3 = valor variable tamanoTextoCriptograma
#
# Valor devuelto:
# - Impresi�n del criptograma descifrado
#
# Pila: 
# - Al ser subrutina tallo, reserva 
#   hueco de 232 bytes y necesita guardar
#   el registro $ra. Tambi�n hay un hueco
#   de 4 bytes para que el total sea
#   m�ltiplo de 8 bytes.
# - Se realiza una copia de los par�metros $a0, 
#   $a1, $a2 y $a3 en el hueco del invocador.
# - No necesitamos hacer la salvaguarda de 
#   de registros: no se usan los registros $s
#   y los $t se usan despu�s de la llamada a
#   otra subrutina.
# - Si tiene variables locales en la pila:
#	$s0 vector frecuenciaRelativa.
#	$s1 vectorDistancia.
# 
# Marco de pila:
# |                             |
# | Marco de pila del invocador |
# |                             |
# |        Copia de $a3         | <- 244($sp)
# +-----------------------------+
# |        Copia de $a2         | <- 240($sp)
# +-----------------------------+
# |        Copia de $a1         | <- 236($sp)
# +-----------------------------+
# |        Copia de $a0         | <- 232($sp)
# +=============================+���������������^
# |           v1[25]            |              	|
# +-----------------------------+		|
# |            ...              | 	        |
# +-----------------------------+		|
# |            v1[0]            | <- 128($sp)	|
# +-----------------------------+		|
# |           v2[25]            |              	|
# +-----------------------------+		|
# |            ...              | 	        |
# +-----------------------------+		|
# |            v2[0]            | <- 24($sp)	|
# +-----------------------------+		|
# |       Hueco (4 bytes)       |		|
# +-----------------------------+		|
# |        Copia de $ra         | <- 16($sp)	|
# +-----------------------------+		|
# |        Copia de $a3         | <- 12($sp)	|
# +-----------------------------+		|
# |        Copia de $a2         | <- 8($sp)	|
# +-----------------------------+		|
# |        Copia de $a1         | <- 4($sp)	|
# +-----------------------------+		|
# |        Copia de $a0         | <- 0($sp)	|
# +=============================+���������������V
#		
###########################################
autodescodificar:
	

	addi	$sp, $sp, -232	# Reserva en la pila de 232 bytes
	sw	$ra, 16($sp)	# Salvaguarda de la direcci�n de retorno en la pila
	sw	$a0, 232($sp)	# Salvaguarda del par�metro recibido por $a0 (puntero a la variable texto)
	sw	$a1, 236($sp)	# Salvaguarda del par�metro recibido por $a1 (puntero a la variable frecuenciaMedia)
	sw	$a2, 240($sp)	# Salvaguarda del par�metro recibido por $a2 (n�mero de elementos del vector: variable TAMANOABECEDARIO)
	sw	$a3, 244($sp)	# Salvaguarda del par�metro recibido por $a3 (n�mero de car�cteres del texto: tamanoTextoCriptograma )

	# Declaraci�n de las variables locales
	la	$s0, 128($sp)		# Vector de frecuencias relativas del criptograma, variable frecuenciaRelativa
	la	$s1, 24($sp)		# Vector distancias, varible vectorDistancia	
	
	# Llamada a la subrutina contarLetras
	la 	$a0, ($a0)	# $a0 <-- puntero a la variable texto
	la	$a1, ($s0)	# $a1 <-- puntero a la variable frecuenciaRelativa
	jal	contarLetras
	
	lw  	$a0, 232($sp)	# recuperaci�n puntero a Variable texto
	lw  	$a1, 236($sp)	# recuperaci�n puntero a Variable frecuenciaMedia
	lw  	$a2, 240($sp)	# recuperaci�n variable TAMANOABECEDARIO
	lw  	$a3, 244($sp)	# recuperaci�n variable tamanoTextoCriptograma

#BUCLE: while (i<=TAMANOABECEDARIO) $s0<--i	$s1<--n
	li 	$s2, 0		# $s2<--Valor inicial de i (iterador), se inicializa a 0

WHILE:  beq  	$s2, $a2, END	# Control de salida del bucle. Si el valor de $S2 (variable) es igual al de $s3 (fijo), 26, se ir� a la instruci�n con la etiqueta END

	la	$s0, 128($sp)	# recuperaci�n puntero a la variable frecuenciaRelativa
	lw	$a1, 236($sp)	# recuperaci�n puntero a la Variable frecuenciaMedia
	move	$a0, $s0	# $a0<--v. frecuenciaRelativa($s0)
	
	jal 	distancia	# Llamada a la subrutina distancia
	sw	$zero, ($s1)	# Limpiamos posibles valores antiguos en vector distancia ($s1).
	sw 	$v0, ($s1)	# $v0 es el resultado de la operaci�n matem�tica de calcular la distancia (Lo almacenamos en vector distancias)
	
	la	$s7, 128($sp)	# $s7 Vector de frecuencias relativas del criptograma, variable frecuenciaRelativa
	beq	$s1, $s7, END	# comprobaci�n si hemos llegado al final del vector distancia
	
	lw  	$a0, 232($sp)	# recuperaci�n puntero a Variable texto
	lw  	$a1, 236($sp)	# recuperaci�n puntero a Variable frecuenciaMedia
	lw  	$a2, 240($sp)	# recuperaci�n variable TAMANOABECEDARIO
	
	addi 	$s1, $s1, 4 	# Sumamos 4 bytes para pasar a la siguiente posici�n del vector distancias.
	
	la	$s0, 128($sp)	# recuperaci�n puntero a la variable frecuenciaRelativa
	la	$a0, ($s0)	# $a0<--v. frecuenciaRelativa
	move	$a1, $a2	# $a1<-- TAMANOABECEDARIO
	jal 	rotarVector	# llamada a la subrutina rotarVector
	
	lw  	$a0, 232($sp)	# recuperaci�n puntero a Variable texto
	lw  	$a1, 236($sp)	# recuperaci�n puntero a Variable frecuenciaMedia
	lw  	$a2, 240($sp)	# recuperaci�n variable TAMANOABECEDARIO
	
	addi 	$s2, $s2, 1	# incremento en 1 del iterador i

	j 	WHILE		# llamada a la etiqueta WHILE	
END:				# Final del bucle
	la	$s1, 24($sp)	# recuperaci�n del puntero a la variable vectorDistancia
	la 	$a0, ($s1)	# $a0 <-- puntero vectorDistancia
	move	$a1, $a2	# $a1 <-- TAMANOABECEDARIO
	jal 	minimo		# llamada a la subrutina minimo
	move	$s3, $v0	# $s3 <-- $v0 Se corresponde con el valor m�nimo en el vector distancia, lo devuelve la subrutina minimo
	
	lw  	$a0, 232($sp)	# recuperaci�n puntero a Variable texto
	lw  	$a1, 236($sp)	# recuperaci�n puntero a Variable frecuenciaMedia
	lw  	$a2, 240($sp)	# recuperaci�n variable TAMANOABECEDARIO
	lw  	$a3, 244($sp)	# recuperaci�n variable tamanoTextoCriptograma
	
	move	$a1, $s3	# $a1 <-- valor n�mero clave, lo devuelto por minimo ($s3)
	move	$a2, $a3	# $a2 <-- valor de la variable tamanoTextoCriptograma ($a3)
	jal 	desplazar	# llamada a la subrutina desplazar
	
	lw  	$a0, 232($sp)	# recuperaci�n puntero a Variable texto
	lw  	$a1, 236($sp)	# recuperaci�n puntero a Variable frecuenciaMedia
	lw  	$a2, 240($sp)	# recuperaci�n variable TAMANOABECEDARIO

	# Restauraci�n de pila para volver a la rutina invocadora
	lw  	$ra, 16($sp)	# recuperaci�n $ra
	addi 	$sp, $sp, 232	# Arreglo pila
	jr	$ra		# Retorno de la subrutina al invocador 
		
###########################################
# Fin de autodescodificar
###########################################



###########################################
# Subrutina contarLetras	
#
# Tipo de subrutina:
# - Procedimiento
# - Hoja
#
# Objetivos: 
# - Rellenar el vector frecuenciaRelativa
# dependiendo del texto cifrado introducido.
#
# Par�metros: 
# - $a0 = puntero a la variable texto
# - $a1 = puntero a la variable frecuenciaRelativa
# - $a2 = n�mero de elementos del vector: variable TAMANOABECEDARIO
# - $a3 = n�mero de caracteres del criptograma: variable tamanoTextoCriptograma
#
# Pila: 
# - Al ser subrutina hoja, no reserva 
#   hueco y no guarda ning�n registro.
#
###########################################
contarLetras:	
	li	$s5, 0			# inicializamos $s5 a 0, ser� nuestro iterador para ambos bucles
	move 	$t5, $a1		# $t5 <-- $a1 puntero a la variable frecuenciaRelativa
	
	# Recorremos el vector frecuenciaRelativa para vaciarlo, introducci�n de 0s en todas sus posiciones y evitar as� fallos en c�lculos.
While_LimparRelativa:
	beq 	$s5, $a2, Fin_Limpiarrelativa
	sw 	$zero, ($t5)
	addi 	$t5, $t5, 4
	addi 	$s5, $s5, 1
	j	While_LimparRelativa

Fin_Limpiarrelativa:			
	li	$t8, 0x00000041 	# Cargamos en $t8 el valor decimal de "A"
	li 	$t9, 0x0000005a 	# Cargamos en $t9 el valor decimal de "Z"
	
	li	$s5, 0			# Iterador del bucle while inicializado a 0
	li	$t5, 5			# $t5 <-- para el redondeo	
	
		
	lb 	$t0, ($a0)		# $t0 <-- cada caracter del criptograma
	li	$s6, 0			# $s6 <-- iterador, inicializado a 0
	move	$s7, $a3		# $s7 <-- tamanoTextoCriptograma
WHILE_CONTARLETRAS:			# while (i<TAMANOTEXTOMAX)
	beq  	$s6, $s7 WHILE_2	# Control salida bucle, cuando se termine de leer el criptograma
	
	# control caracteres entre A y Z
	bgt 	$t0, $t9, ERROR_ContarLetras
	blt	$t0, $t8, ERROR_ContarLetras
	
	sub	$t1, $t0, $t8		# $t1 <-- posici�n del caracter le�do
	li 	$t2, 4			# $t2 <-- 4
	mul	$t3, $t1, $t2		# $t3 <-- $t1*$t2 c�lculo en qu� posici�n debemos sumar 1 
	add 	$t4, $t3, $a1		# $t4 <-- $t3+$t1 avance puntero al vector frecuenciaRelativa
	
	lw 	$t6, ($t4)		# $t6 <-- valor que hay en la posici�n del vector donde sumaremos 1
	addi 	$t6, $t6, 1		# sumar 1 
	sw 	$t6, ($t4)		# escribir el nuevo valor en la posici�n del vector
	
SIGUIENTE:	
	addi 	$a0, $a0, 1		# incremento en 1 la direcci�n de la cadena para obtener el siguiente caracter
	lb 	$t0, ($a0)		# $t0 <-- cada caracter del criptograma 
	addi 	$s6, $s6, 1		# aumentar iterador
	j 	WHILE_CONTARLETRAS	# llamada a la etiqueta WHILE_CONTARLETRAS
	
WHILE_2:				# while ($s5 < TAMANOTEXTOABECEDARIO)
	beq 	$s5, $a2, END_ContarLetras	# Condici�n salida bucle. 
	
	lw	$t1, ($a1)		# $t1 <-- valor de cada posici�n del vector frecuenciaRelativa
	mul 	$t1, $t1, 100		# Pasar a %
	div 	$t1, $t1, $a3		# Divisi�n entre el total de letras del criptograma (tamanoTextoCriptograma)
	mfhi 	$t3 			# $t3 <-- resto de la divisi�n
	
	# Redondeo, si el resto est� entre 5 y 9, se suma 1 a la parte entera, sino nos quedaremos con el entero.
	blt	$t3, $t5, ENTERO	
	addi 	$t1, $t1, 1		
ENTERO:
	sw 	$t1, ($a1)		# Almacenmiento valor de frecuencia relativa en vector.
	addi	$s5, $s5, 1		# Avanzar iterador
	addi	$a1, $a1, 4		# Avanzar puntero al vector frecuenciaRelativa
	j	WHILE_2
	
END_ContarLetras:	
	jr	$ra			# Retorno de la subrutina al invocador 
	
ERROR_ContarLetras:
	sub 	$a3, $a3, 1		# Resta 1 al total de caracteres del criptograma, ya que el caracter leido no es una letra (A-Z)
	j	SIGUIENTE	
###########################################
# Fin de contarLetras
###########################################



###########################################
# Subrutina distancia	
#
# Tipo de subrutina:
# - Funci�n
# - Hoja
#
# Objetivos: 
# - Calcular la distancia entre el vector de 
# frecuencias relativas y el de frecuencias 
# relativas medias del espa�ol.
#
# Par�metros: 
# - $a0 = vector frecuenciaRelativa
# - $a1 = vector frecuenciaMedia
# - $a2 = variable TAMANOABECEDARIO
#
# Valor devuelto:
# - $v0 = el valor de la distancia cuadr�tica 
# entre los dos vectores.
#
# Pila: 
# - Al ser subrutina hoja, no reserva 
#   hueco y no guarda ning�n registro.
#		
###########################################
distancia:	

	li 	$t0, 0		# Valor sumatorio acumulable inicializado a 0
	li 	$t1, 0		# $t1 <-- Valor inicial de i (iterador), se inicializa a 0

WHILE_Distancia: 		
	li 	$t2, 0		# $t2 <-- 0
	li 	$t3, 0 		# $t3 <-- 0
						# while (i<=TAMANOABECEDARIO)
	beq 	$t1, $a2, END_Distancia 	# Control de salida del bucle. Si el valor de $t1 (variable) es igual al de $a2(fijo), 26, se ir� a la instruci�n con la etiqueta END
	
	lw	$s0, ($a0)	# $s0 <-- valor de cada posici�n vector frecuenciaMedia
	lw	$s2, ($a1)	# $s1 <-- valor de cada posici�n vector frecuenciaRelativa
	
	# C�lculos distancia cuadr�tica
	sub	$t2, $s2, $s0
	mul	$t3, $t2, $t2
	add	$t0, $t0, $t3
	
	addi 	$a0, $a0, 4	# incremento puntero vector frecuenciaMedia
	addi	$a1, $a1, 4	# incremento puntero vector frecuenciaRelativa
	addi	$t1, $t1, 1	# incremento iterador

	j 	WHILE_Distancia		# llamada a la etiqueta WHILE	
END_Distancia:	
	addi	$v0, $t0, 0	# Final del bucle
	jr	$ra		# Retorno de la subrutina al invocador 
###########################################
# Fin de distancia
###########################################



###########################################
# Subrutina rotarVector	
#
# Tipo de subrutina:
# - Procedimiento
# - Hoja
#
# Objetivos: 
# - Desplazar una posici�n los valores del
# vector frecuenciaRelativa.
#
# Par�metros: 
# - $a0 = vector frecuenciRelativa
# - $a1 = valor TAMANOABECEDARIO
#
# Pila: 
# - Al ser subrutina hoja, no reserva 
#   hueco y no guarda ning�n registro.
#		
###########################################
rotarVector:
	move	$t7, $a0		# Direcci�n reservada para el primer valor del vector
	lw	$t1, ($a0)		# $t1 <-- valor de cada posici�n vector frecuenciaRelativa
	sub	$a1, $a1, 1		# TANOABECEDARIO - 1, queremos hacer 24 iteraciones
	
BUCLE: 					# while (1<$a1)
	beq	$t2, $a1, InsertarValorUltimo		# $t2 <-- iterador del bucle 
	
	addi	$a0, $a0, 4		# avanzar puntero vector frecuenciaRelativa
	lw	$t3, ($a0)		# $t3 <-- valor de posici�n puntero vector frecuenciaRelativa
	sw 	$t1, ($a0)		# escribir en la posici�n de memoria de $a0 el valor contenido en $t1
	move	$t1, $t3		# $t1 <-- $t3
	addi	$t2, $t2, 1		# avanzar iterador
	j BUCLE				# llamada a la etiqueta BUCLE
	
InsertarValorUltimo:
	sw	$t1, ($t7)		# escribir en la direcci�n de memoria de $t7 el valor de $t1
	
	jr	$ra			# Retorno de la subrutina al invocador 
###########################################
# Fin de rotarVector
###########################################



###########################################
# Subrutina minimo
#
# Tipo de subrutina:
# - Funci�n
# - Hoja
#
# Objetivos: 
# - Encontrarel valor m�nimo almacenado en
# el vector distancia. Su posici�n se corresponde 
# con la clave.
#
# Par�metros: 
# - $a0 = vectorDistancia
# - $a1 = valor TAMANOABECEDARIO
#
# Valor devuelto:
# - $v0 = clave
#
# Pila: 
# - Al ser subrutina hoja, no reserva 
#   hueco y no guarda ning�n registro.
#		
###########################################
minimo:
	li 	$t3, 0			# $t3 <-- 0, ir� almacenando la posici�n del valor m�nimo del vectorDistancia
	li 	$t0, 1			# Se inicializa $t0 a 1 ser� el iterador
	lw 	$t1, ($a0)		# $t1 almacena valor del vector distancias
	addi 	$a0, $a0, 4		# Movemos el puntero de vector distancias una posici�n a la derecha.
	
WHILE_MINIMO: 
	beq 	$t0, $a1, END_MINIMO	# Bucle de 24 iteraciones para sacar la distancia m�nima, si $t0==26 sale del bucle a etiqueta END.
	lw 	$t2, ($a0)		# $t2 almacena valor de la direcci�n de memoria donde se encuentra el apuntador de vectorDistancia

	bge 	$t2, $t1, NEXT		# Si el nuevo valor es menor al que ten�amos, saltamos a NEXT.
	move 	$t3, $t0		# $t3 <-- Valor de la posici�n del m�nimo
	move 	$t1, $t2		# Si el nuevo valor es menor, sobreescribir� el valor anterior ($t1).
NEXT:
	addi 	$a0, $a0, 4		# Movemos el apuntador de vector distancias una posici�n a la derecha.
	addi 	$t0, $t0, 1		# Aumentamos el iterador
	j 	WHILE_MINIMO		# Volvemos al while.
	
END_MINIMO: 	
	# PRINT mensaje laClaveEs:
		# Carga en $a0 la direcci�n de memoria donde comienza la variable laClaveEs
       		# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	la	$a0, laClaveEs
	li	$v0, 4
	syscall
	
	# PRINT entero:
		# Llamada al sistema con el servicio que imprime por pantalla el entero que se almacena en $a0
	move	$a0, $t3
	li	$v0, 1
	syscall
	
	move 	$v0, $t3		# Se almacena en $v0 la posici�n en el vector de la distancia m�nima.
	jr 	$ra			# Retorno de la subrutina al invocador 
	
###########################################
# Fin de minimo
###########################################



###########################################
# Subrutina desplazar
#
# Tipo de subrutina:
# - Funci�n
# - Hoja
#
# Objetivos: 
# - Mover cada caracter del texto cifrado
# tantas posiciones como indique la clave.
#
# Par�metros: 
# - $a0 = puntero a la variable texto
# - $a1 = valor n�mero clave, lo devuelto por minimo
# - $a2 = n�mero caracteres del criptograma
#
# Valor devuelto:
# - Imprime el texto descifrado.
#
# Pila: 
# - Al ser subrutina hoja, no reserva 
#   hueco y no guarda ning�n registro.
#		
###########################################
desplazar:
	
	beq 	$a1, $zero, FIN 	# Si la clave es 0, el texto no est� encriptado
	li	$t8, 65 		# Cargamos en $t8 el valor decimal de "A"
	li 	$t9, 90 		# Cargamos en $t9 el valor decimal de "Z"
	move 	$t6, $a0		# $t6 <-- $a0 Guardamos el valor del puntero a texto
	lb	$t0, ($a0)		# $t0 <-- valor del primer car�cter de la variable texto
	
	li	$t2, 0			# $t2 iterador del bucle, inicializado a 0
WHILE_DESPLAZAR: 
	beq 	$t2, $a2, FIN 		# si $t2 = n�mero de caracteres del criptograma
	
	# control caracteres entre A y Z
	bgt 	$t0, $t9, NEXT_DESPLAZAR
	blt	$t0, $t8, NEXT_DESPLAZAR
	
	li	$t1, 0			# $t1 iterador del bucle, inicializado a 0
	WHILE_DESPLAZAR2: 		# desplazar la letra
		beq 	$t1, $a1, NEXT_DESPLAZAR	# Control salida bucle. Si $1 es igual que la clave ($a1) ya se ha desplazado tantas posiciones como indicaba la clave
		addi	$t0, $t0, 1			# avanzamos 1 posici�n el car�cter en el criptograma
		
		# si car�cter una vez movido, su valor en ASCII es mayor o igual que $t9(Z) se cambia por una A
		ble	$t0, $t9, CORRECTO		
		move	$t0, $t8					
CORRECTO:
		addi 	$t1, $t1, 1			# avanzamos iterador en 1 
		j 	WHILE_DESPLAZAR2		# llamada a la etiqueta WHILE_DESPLAZAR2
NEXT_DESPLAZAR:	
	sb 	$t0, ($a0)		# almacenar el car�cter descifrado en la variable texto
	addi	$a0, $a0, 1		# avanza el puntero a la variable texto
	lb	$t0, ($a0)		# $t0 <-- valor del primer car�cter de la variable texto
	addi	$t2, $t2, 1		# aumentar el iterador
	
VOLVER: j 	WHILE_DESPLAZAR		# llamada a la etiqueta WHILE_DESPLAZAR


FIN:	
	# PRINT mensaje  mensajeElCriptogramaEs:
		# Carga en $a0 la direcci�n de memoria donde comienza la variable mensajeElCriptogramaEs
       		# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	la 	$a0, mensajeElCriptogramaEs
	li	$v0, 4
	syscall
	
	# PRINT criptograma descifrado:
		# Carga en $a0 la direcci�n de memoria donde comienza el criptograma descifrado, ($t6)
		# Llamada al sistema con el servicio que imprime por pantalla un string que comienza en la direcci�n que almacena $a0
	move 	$a0, $t6
	li	$v0, 4
	syscall
	
	jr	$ra		# Retorno de la subrutina al invocador 
###########################################
# Fin de desplazar
###########################################



###########################################
# Subrutina escribirResultado 
#
# Tipo de subrutina:
# - Procedimiento
# - Tallo
#
# Objetivo: 
# - Solicitar el nombre del fichero que
#   en el que grabar la soluci�n del 
#   criptograma
# - Abrir el fichero con permiso de 
#   escritura (*)
# - Escribir en �l la soluci�n
# - Cerrar el fichero
#
# (*) Si se produce un error de apertura
#     del fichero, se termina la subrutina
#     y se regresa al programa principal
#
# Par�metros: 
# - $a0 = Puntero a la cadena de texto que 
#         contiene el criptograma (resuelto)
# - $a1 = N�mero de caracteres del criptograma
#
# Valor devuelto:
# - No tiene
#
# Pila: 
# - Al ser subrutina tallo, reserva 
#   hueco de 16 bytes y necesita guardar
#   el registro $ra. Tambi�n hay un hueco
#   de 4 bytes para que el total sea
#   m�ltiplo de 8 bytes 
# - Realiza una copia de los par�metros $a0 
#   y $a1 en el hueco del invocador
# - No necesitamos hacer la salvaguarda de 
#   de registros: no se usan los registros $s
#   y, de los $t que se usan, no necesitamos
#   mantener su valor
# - No tiene variables locales en la pila
# 
# Marco de pila:
# |                             |
# | Marco de pila del invocador |
# |                             |
# |        Copia de $a1         | <- 28($sp)
# +-----------------------------+
# |        Copia de $a0         | <- 24($sp)
# +=============================+���������������^
# |       Hueco (4 bytes)       |		|
# +-----------------------------+		|
# |        Copia de $ra         | <- 16($sp)	|
# +-----------------------------+		|
# |       Hueco (4 bytes)       |		|
# +-----------------------------+	 24 bytes
# |       Hueco (4 bytes)       |		|
# +-----------------------------+		|
# |       Hueco (4 bytes)       |		|
# +-----------------------------+		|
# |       Hueco (4 bytes)       | <- 0($sp)	|
# +=============================+���������������V
#
###########################################
escribirResultado:
	# Primera parte: pr�logo de la subrutina
	addi	$sp, $sp, -24	# Reserva el hueco en la pila para los par�metros
	sw	$ra, 16($sp)	# Salvaguarda de la direcci�n de retorno en la pila
	sw	$a0, 24($sp)	# Salvaguarda del par�metro recibido por $a0 (puntero al criptograma resuelto)
	sw	$a1, 28($sp)	# Salvaguarda del par�metro recibido por $a1 (n�mero de caracteres del criptograma)
	
	# Segunda parte: comprobamos que hay un criptograma cargado en memoria
	lw	$t0, 24($sp)	# Puntero al criptograma (para acceder al primer car�cter)
	lb	$t0, 0($t0)	# Miramos el valor del primer car�cter del criptograma
	bne	$t0, $zero, escribirResultado2	# Si es un byte nulo, es que no hemos cargado todav�a el criptograma y mostramos un mensaje de error
						# Si es un byte no nulo, continuamos ejecutando en la instrucci�n con la etiqueta escribirResultado2
	# Aunque hemos usado $t0, y a pesar de ser subrutina tallo, no nos hace falta salvaguardar este registro antes de la llamada a la subrutina quitarNL
													
	# ERROR: �No hemos cargado ning�n criptograma!
	li	$v0, 4		# Mostramos un mensaje de error por la consola
	la	$a0, mensajeErrorCriptograma
	syscall
	j	finEscribirResultado	# Saltamos al ep�logo de la subrutina para reajustar la pila

	# Tercera parte: se pide un nombre de fichero por teclado
escribirResultado2:	
	li	$v0, 4		# Mostramos el mensaje Escribe el nombre del fichero
	la	$a0, mensajeGuardarSolucion
	syscall

	li 	$v0, 8		# Solicitamos una cadena de texto por teclado
	la	$a0, nombreFichero	# Almacenaremos la cadena tecleada en la variable global nombreFichero (es la misma en la que almacenamos el nombre del fichero que contiene el criptograma original)
	li	$a1, TAMANONOMBREFICHEROMAX	# Este es el tama�o m�ximo que puede tener el nombre del fichero = n�mero m�ximo de caracteres que se van a leer
	syscall
	
	# Quitamos el car�cter '\n' del nombre del fichero que hemos escrito	
	#
	# Par�metros:
	# - $a0: Puntero al nombre del fichero ($a0 ya contiene esta direcci�n)
	#
	# Valor devuelto:
	# - No tiene
	jal	quitarNL	# Llamada a la subrutina quitarNL

	# Cuarta parte: se abre el fichero
	li   	$v0, 13 	# Abrir fichero
  	la   	$a0, nombreFichero     # Puntero al nombre del fichero
  	li   	$a1, 1		# Permiso del fichero: escritura = 1
	li   	$a2, 0       	# Modo del fichero (se ignora)
	syscall            
	move 	$t0, $v0     	# $v0 devuelve el descriptor del fichero y se hace una copia en el registro $t0
	# No nos ha hecho falta salvaguardar el registro $t0 (por ser subrutina tallo) porque lo usamos despu�s de la 
	# �nica llamada a otra subrutina (quitarNL)
	
	bge	$t0, $zero, escribirResultado3	# Comprobamos que el descriptor del fichero es correcto
	# Si ha surgido alg�n error de apertura del fichero, el descriptor es negativo
	# Si es positivo o cero, entonces no ha habido problema y continuamos a partir de la etiqueta escribirResultado3

	# ERROR al abrir el fichero (descriptor negativo)
	li	$v0, 4		# Mostramos un mensaje de error
	la	$a0, mensajeErrorFichero
	syscall
	la	$a0, nombreFichero
	syscall
	la	$a0, mensajeExclamacion
	syscall	
	j	finEscribirResultado	# Saltamos al ep�logo de la subrutina para reajustar la pila

	# Quinta parte: escribimos el criptograma resuelto en el fichero
escribirResultado3:
  	li	$v0, 15		# Escribir en fichero
  	move	$a0, $t0	# Copiamos en $a0 el descriptor del fichero
  	lw	$a1, 24($sp)	# Restauramos en $a1 el valor del puntero al criptograma resuelto, que est� en la pila
  	lw	$a2, 28($sp)	# Restauramos en $a2 el valor del n�mero de caracteres del criptograma, que est� en la pila  	  	
  	syscall
  	move 	$t1, $v0	# El valor devuelto en $v0 es el n�mero de bytes escritos
  	# No nos ha hecho falta salvaguardar el registro $t1 (por ser subrutina tallo) porque lo usamos despu�s de la 
	# �nica llamada a otra subrutina (quitarNL)
  	
  	beq	$t1, $a2, escribirResultado4 	# Miramos que se han escrito todos los bytes
  	
  	# Error: no se han escrito todos los bytes que deber�an
  	li	$v0, 4		# Mostramos un mensaje de error
	la	$a0, mensajeErrorFichero
	syscall	
	la	$a0, nombreFichero
	syscall
	la	$a0, mensajeExclamacion
	syscall	
	j	finEscribirResultado

escribirResultado4:
    	# Sexta parte: cerramos el fichero
  	li   	$v0, 16       # Cerrar el fichero
  	move 	$a0, $t0      # Colocamos en $a0 el descriptor del fichero
  	syscall            
  	
  	# S�ptima parte: Imprimimos diversos mensajes que indican que todo ha ido bien
  	li	$v0, 4
  	la	$a0, mensajeFichero	# El fichero
  	syscall
  	la	$a0, nombreFichero	# **nombre de fichero**
  	syscall
  	la	$a0, mensajeGuardado	# se ha guardado correctamnete
  	syscall  	
  	
	# Octava parte: ep�logo de la subrutina
finEscribirResultado:	
	lw	$ra, 16($sp)    # Restauramos la direcci�n de retorno de la pila
 	addi	$sp, $sp, 24	# Restaura la pila 
	jr 	$ra		# Retorno al invocador
###########################################
# Fin de escribirResultado
###########################################	

	
	
###########################################
# Subrutina quitarNL 
#
# Tipo de subrutina:
# - Procedimiento
# - Hoja
#
# Objetivo: 
# - Eliminar el car�cter '\n' (nueva l�nea)
#   al final de una cadena de texto que 
#   corresponde al nombre de un fichero
#   introducido por teclado
# - La cadena debe terminar en el byte nulo
#
# Par�metros:
# - $a0 = Puntero a la cadena (se modifica
#         la cadena al tener su direcci�n)
#
# Valor devuelto:
# - No devuelve valor
#
# Pila: 
# - Al ser subrutina hoja, no reserva 
#   hueco de 16 bytes, ni necesita guardar
#   el registro $ra
# - Al usar solo registros $t, no necesita
#   salvaguardar ning�n registro
# - No tiene variables locales en la pila,
#   ya que usamos un registro para definir
#   el car�cter '\n'
#
# Marco de pila:
# - No tiene (tama�o 0 bytes)
###########################################	
quitarNL:	
	li	$t0, '\n'	# Car�cter nueva l�nea que deseamos eliminar
	# Recorremos la cadena con un bucle que va mirando car�cter a car�cter (byte a byte)	
bucleQuitarNL:	
	lb	$t1, 0($a0)	# Cargamos un byte
	beq	$t1, $t0, finBucleQuitarNL	# Si es el byte de nueva l�nea, salimos del bucle
	addi	$a0, $a0, 1	# Si no, apuntamos al siguiente car�cter
	j	bucleQuitarNL	# Regreso al comienzo del bucle
finBucleQuitarNL:	
	sb	$zero, 0($a0)	# Se borra el byte de nueva l�nea al sobreescribirlo con el byte nulo
	jr 	$ra		# Retorno al invocador
###########################################
# Fin de quitarNL
###########################################
