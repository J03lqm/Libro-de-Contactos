#!/bin/bash

# Joel Quenard Martínez
# Libro de contactos
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
    echo "	--help  : Mostrará esta ayuda"
    echo "  -a      : Añade entradas al registro"
    echo "          Sintaxis: $0 -a --nombre --teléfono --email"
    echo "          Ej: $0 -a Joel_Quenard 123456789 joelqm02@gmail.com"
    echo
    echo "  -l      : Muestra el contenido del registro"
    echo "          Sintaxis: $0 -l"
    echo
    echo "  -s      : Filtra el registro por el nombre"
    echo "          Sintaxis: $0 -s --filtro"
    echo "          Ej: $0 -s Joel"
    echo
    echo "  -st     : Filtra el registro por el teléfono"
    echo "          Sintaxis: $0 -st --filtro"
    echo "          Ej: $0 -st 1234"
    echo
    echo "  -se     : Filtra el registro por el nombre"
    echo "          Sintaxis: $0 -se --filtro"
    echo "          Ej: $0 -se gmail"
    echo
    echo "  -r      : Elimina una entrada del registro filtrando por el nombre"
    echo "          Sintaxis: $0 -r filtro"
    echo "          Ej: $0 -r Joel"
    echo
    echo "  -e      : Edita una entrada del fichero eligiendo la linea"
    echo "          Sintaxis: $0 -e --linea"
    echo "          Ej: $0 -e 2"
    echo
    echo "  -ln     : Muestra el registro con el numero de linea"
    echo "          Sintaxis: $0 -ln"
    echo
    echo "(c) Joel Quenard Martínez"
    exit 0
}

function error(){
    [ $1 -eq 1 ] && echo "Error 1: Debe introducir exactamente 4 parametros, para usar el parametro -a" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 2 ] && echo "Error 2: El teléfono debe de ser un número" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 3 ] && echo "Error 3: El número tiene que tener una longitud de 9 caracteres" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 4 ] && echo "Error 4: Debe introducir exactamente 2 parametros, para usar el parametro -s" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 5 ] && echo "Error 5: Debe introducir exactamebte un parametro, para usar el parametro -l" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 6 ] && echo "Error 6: Número de parametros incorrecto" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 7 ] && echo "Error 7: Debe introducir exactamente 2 parametros, para usar el parametro -r" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 8 ] && echo "Error 8: Debe introducir exactamente 2 parametros, para usar el parametro -st" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 9 ] && echo "Error 9: Debe introducir exactamente 2 parametros, para usar el parametro -se" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 10 ] && echo "Error 10: Debe introducir exactamente 2 parametros, para usar el parametro -e" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    [ $1 -eq 11 ] && echo "Error 11: Debe introducir exactamebte un parametro, para usar el parametro -ln" 1>&2 && echo "Puede usar $0 --help para mostrar la ayuda"
    exit $1
}
###################
# Main
###################

# Comprobaciones iniciales
[ "$1" == "--help" ] && ayuda
[ "$1" == "-a" ] && [ "$#" -ne 4 ] && error 1
[ "$1" == "-l" ] && [ "$#" -ne 1 ] && error 5
[ "$1" == "-ln" ] && [ "$#" -ne 1 ] && error 11
[ "$1" == "-s" ] && [ "$#" -ne 2 ] && error 4
[ "$1" == "-st" ] && [ "$#" -ne 2 ] && error 8
[ "$1" == "-se" ] && [ "$#" -ne 2 ] && error 9
[ "$1" == "-r" ] && [ "$#" -ne 2 ] && error 7
[ "$1" == "-e" ] && [ "$#" -ne 2 ] && error 10
[ "$#" -eq 0 ] && error 6

# Comprueba que el segundo parametro es un numero
[ "$1" == "-a" ] && [ $3 -lt 0 ] &&  error 2
[ "$1" == "-a" ] && [ $3 -gt 999999999 ] && error 2
[ "$1" == "-st" ] && [ $2 -lt 0 ] &&  error 2
[ "$1" == "-st" ] && [ $2 -gt 999999999 ] && error 2

#Comprueba la longitud del número
[ "$1" == "-a" ] && longitudNum=$( echo -n $3 | wc -m )
[ "$1" == "-a" ] && [ $longitudNum -gt 9 ] && error 3
[ "$1" == "-a" ] && [ $longitudNum -lt 9 ] && error 3

# Creamos el fichero si no existe
[ -e "ab.txt" ] ||  touch ab.txt


# $1 == -a Añade una entrada a la agenda
[ "$1" == "-a" ] && echo "$2 $3 $4" >> ab.txt && exit 0

# $1 == -l Muestra el contenido de la agenda
[ "$1" == "-l" ] && echo -e "Nombre       - Numero  - email\n-----------------------------------------" && cat ab.txt && exit 0

# $1 == -s Muestra las entradas de la agenda con los nombres que coincidan con el segundo parametro
if [ "$1" == "-s" ];then
resultadoBusqueda=$(cat ab.txt|tr " " ";"|cut -d ";" -f1|grep -i "$2")
    if [ "$resultadoBusqueda" != "" ];then
        echo -e "Nombre       - Numero  - email\n-----------------------------------------"
        lineas=$( nl ab.txt | tr "\t" " " | tr -s " " | tr " " ";" | cut -d ";" -f 2,3 | grep $2 | cut -d ";" -f 1 | tr "\n" "," )
        tamFich=$( echo -n $lineas|tr "," " " | wc -w )#Numero de lineas a mostrar
        x=1
        echo -e "Nombre       - Numero  - email\n-----------------------------------------"
        while [ $x -le $tamFich ]; do
            comVar=$( echo $lineas | cut -d ',' -f$x )
            sed -n $comVar"p" ab.txt | tr " " "\t"
            let x=x+1
            let comBorrar=comBorrar+1
        done
        exit 0
    else
        echo "No hay ningun contacto que contenga $2 como nombre"
        exit 0
    fi
fi

# Bonus 2.1 $1 == -st Muestra las entradas de la agenda con los telefonos que coincidan con el segundo parametro
if [ "$1" == "-st" ];then
resultadoBusqueda=$(cat ab.txt|tr " " ";"|cut -d ";" -f2|grep -i "$2")
    if [ "$resultadoBusqueda" != "" ];then
    lineas=$( nl ab.txt | tr "\t" " " | tr -s " " | tr " " ";" | cut -d ";" -f 2,4 | grep $2 | cut -d ";" -f 1 | tr "\n" "," )
    tamFich=$( echo -n $lineas|tr "," " " | wc -w )#Numero de lineas a mostrar
    x=1
    echo -e "Nombre       - Numero  - email\n-----------------------------------------"
    while [ $x -le $tamFich ]; do
        comVar=$( echo $lineas | cut -d ',' -f$x )
             sed -n $comVar"p" ab.txt | tr " " "\t"
        let x=x+1
        let comBorrar=comBorrar+1
    done
        exit 0
    else
        echo "No hay ningun contacto que contenga $2 como teléfono"
        exit 0
    fi
fi
####

# Bonus 2.2 $1 == -se Muestra las entradas de la agenda con los emails que coincidan con el segundo parametro
if [ "$1" == "-se" ];then
resultadoBusqueda=$(cat ab.txt|tr " " ";"|cut -d ";" -f3|grep -i "$2")
    if [ "$resultadoBusqueda" != "" ];then
        lineas=$( nl ab.txt | tr "\t" " " | tr -s " " | tr " " ";" | cut -d ";" -f 2,5 | grep $2 | cut -d ";" -f 1 | tr "\n" "," )
        tamFich=$( echo -n $lineas|tr "," " " | wc -w )#Numero de lineas a mostrar
        x=1
        echo -e "Nombre       - Numero  - email\n-----------------------------------------"
        while [ $x -le $tamFich ]; do
            comVar=$( echo $lineas | cut -d ',' -f$x )
            sed -n $comVar"p" ab.txt | tr " " "\t"
            let x=x+1
        done
        exit 0
    else
        echo "No hay ningun contacto que contenga $2 como correo"
        exit 0
    fi
fi
####

# $1 == -r Elimina las entradas de la agenda con los nombres que coincidan con el segundo parametro
if [ "$1" == "-r" ];then
    lineaBorrar=$( nl ab.txt | tr "\t" " " | tr -s " " | tr " " ";" | cut -d ";" -f 2,3 | grep $2 | cut -d ";" -f 1 | tr "\n" "," )
    tamBorrar=$( echo -n $lineaBorrar|tr "," " " | wc -w )#Numero de lineas a borrar

    # Bonus 1 pedir confirmación
    echo "Se van a borrar las siguientes entradas:"
    x=1
    tamFich=$( cat ab.txt |wc -l ) 
    while [ $x -le $tamBorrar ]; do
        comVar=$( echo $lineaBorrar | cut -d ',' -f$x )
        sed -n $comVar"p" ab.txt
        let x=x+1
        let comBorrar=comBorrar+1
    done
    echo "¿Seguro?(S/n):"
    read conf
    ####
    if [ $conf == "S" ];then
        i=1
        borrar=0
        while [ $i -le $tamBorrar ]; do
            var=$( echo $lineaBorrar | cut -d ',' -f$i )
            sed -i $(( $var - $borrar ))"d" ab.txt
            let i=i+1
            let borrar=borrar+1
        done
    else
        echo "Se ha cancelado la operación"
    fi
exit 0
fi

# Bonus 3. Editar entradas de ficheros
if [ $1 == "-e" ];then
resultadoBusqueda=$(nl ab.txt| tr "\t" " " | tr -s " "|cut -d " " -f2|grep -i "$2") 
    if [ "$resultadoBusqueda" != "" ];then
        tamFich=$( cat ab.txt |wc -l )
        tmpSup=$(mktemp /tmp/archivoTmp1.XXXXX)
        head -n $(($2-1)) ab.txt > $tmpSup
        tmpInf=$(mktemp /tmp/archivoTmp2.XXXXX)
        tail -n $(($tamFich-$2+1)) ab.txt > $tmpInf
        echo "Se va a editar la siguiente entrada:"
        sed -n $2"p" ab.txt
        echo "¿Seguro?(S/n):"
        read conf
        if [ $conf == "S" ];then
            echo "Introduzca la nueva entrada"
            read entrada
            cat $tmpSup > ab.txt
            echo $entrada >> ab.txt
            cat $tmpInf >> ab.txt
            rm -f $tmpSup
            rm -f $tmpInf
        else
            echo "Se ha cancelado la operación"
        fi
        exit 0
    else
        echo "La entrada seleccionada no existe"
        exit 0
    fi
fi

#Nueva funcion para hacer más facil el uso de la anterior, muestra el fichero con el numero de las lineas
[ "$1" == "-ln" ] && echo -e "Nombre       - Numero  - email\n-----------------------------------------" && nl ab.txt && exit 0
####