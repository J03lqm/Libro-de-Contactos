#!/bin/bash

# Joel Quenard Martínez
# Muestra el último número del cupón de la once premiado
# 28-01-2020
# Últma revisión:

###################
# Functions
###################
function ayuda(){
    echo "Uso $0 [--help]"
    echo "Que hace "
    echo
    echo "Parámetro:"
    echo "	--help : Mostrará esta ayuda"
    echo
    echo "(c) Joel Quenard Martínez"
    exit 0
}

function error(){
    [ $1 -eq 1 ] && echo "Error 1: Debe introducir exactamente 4 parametros, para usar el parametro -a" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 2 ] && echo "Error 2: El segundo parametro debe de ser un número" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 3 ] && echo "Error 3: El numero tiene que tener una longitud de 9 caracteres" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 4 ] && echo "Error 4: Debe introducir exactamente 2 parametros, para usar el parametro -s" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 5 ] && echo "Error 5: Debe introducir exactamebte un parametro, para usar el parametro -l" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    exit $1
}
###################
# Main
###################

# Comprobaciones iniciales
[ "$1" == "--help" ] && ayuda
[ "$1" == "-a" ] && [ "$#" -ne 4 ] && error 1
[ "$1" == "-l" ] && [ "$#" -ne 1 ] && error 5
[ "$1" == "-s" ] && [ "$#" -ne 2 ] && error 4
[ "$1" == "-r" ] && [ "$#" -ne 2 ] && error 4

# Comprueba que el segundo parametro es un numero
[ "$1" == "-a" ] && [ $3 -lt 0 ] &&  error 2
[ "$1" == "-a" ] && [ $3 -gt 999999999 ] && error 2

#Comprueba la longitud del número
[ "$1" == "-a" ] && longitudNum=$( echo -n $3 | wc -m )
[ "$1" == "-a" ] && [ $longitudNum -gt 9 ] && error 3
[ "$1" == "-a" ] && [ $longitudNum -lt 9 ] && error 3

# Creamos el fichero si no existe
[ -e "ab.txt" ] ||  touch ab.txt


# $1 == -a Añade una entrada a la agenda
[ "$1" == "-a" ] && echo "$2 $3 $4" >> ab.txt exit 0

# $1 == -l Muestra el contenido de la agenda
[ "$1" == "-l" ] && echo -e "Nombre       - Numero  - email\n-----------------------------------------" && cat ab.txt && exit 0

# $1 == -s Muestra las lineas de la agenda con los nombres que coincidan con el segundo parametro
[ "$1" == "-s" ] && resultadoBusqueda=$(cat ab.txt | grep -i "$2") && [ "$resultadoBusqueda" != "" ] && echo -e "Nombre       - Numero  - email\n-----------------------------------------" && cat ab.txt | grep -i "$2" && exit 0 || echo "No hay ningun contacto que contenga $2" && exit 0

# $1 == -r Elimina las lineas de la agenda con los nombres que coincidan con el segundo parametro
