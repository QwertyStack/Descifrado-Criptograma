# Descifrado-Criptograma
_Descifrado automático de  un criptograma mediante análisis de frecuencias en ensamblador MIPS_



## COMENZANDO 🚀
Se trata de un código funcional basado en el descifrado de un criptograma cifrado por el méodo de sustitución o desplazamiento, conocido como el **cifrado César**. Para ello suponemos que el texto está escrito en castellano y conocemos cuales son las letras que aparecen con más frecuencia (https://es.wikipedia.org/wiki/Frecuencia_de_aparici%C3%B3n_de_letras). Esto nos permitiría ir descifrando algunas palabras e ir deduciendo otras. Como simplificación, supondremos que el texto está escrito en mayúsculas y que se han eliminado todas las tildes y diéresis y que las 'Ñ' se han sustituido por 'N', con lo que solamente estaremos contando 26 letras. Los signos de puntuación y espacios en blanco seguirán en su sitio en el texto encriptado.

### Pre-requisitos 📋
Contar con simulador MARS, puedes descargarlo en https://courses.missouristate.edu/KenVollmar/mars/download.htm.


### Funcionamiento ⚙️
Se imprime por pantalla un menú de opciones el usuario elegirá una (1-4), en caso de error se vuelve a pedir la entrada:
- Si se selecciona la opción 1, se produce la  lectura del criptograma en memoria.
- Si se selecciona la opción 2, se llama a autodescodificar, donde el criptograma se descifrará pasando por varias subrutinas.
- Si se selecciona la opción 3, se llama a la escritura del texto descifrado en un fichero indicando su nombre.
- Si se seleciona la opción 4, se finaliza la  ejecución del programa.
