#!/bin/bash

#Variables

declare -A usuarios
# -A es array asociativo.

usuarios["admin"]="adm123"

#Funciones

ingresarDron(){
    echo "-- Ingresar dron --"
}

signup(){
    echo "-- Registro de usuario --"
    read -r -p $'Defina su usuario: \n' user

    while [[ -z "$user" ]]; do
        read -r -p $'El usuario no puede estar vacio. Defina su usuario: \n' user     
    done

    while [[ -v usuarios["$user"] ]]; do
        read -r -p $'El usuario ya se encuentra registrado. Vuelva a intentar: \n' user 
    done

    read -r -p $'Defina su contraseña: \n' pass

    while [[ -z "$pass" ]]; do
            read -r -p $'El password no puede estar vacio. Defina su password: \n' pass
    done

    usuarios["$user"]="$pass"
}

menuSesion(){
    while true; do
        echo
        echo "-- Menú de sesión --"
        echo " 1 - Registrarse"
        echo " 2 - Log In"
        echo " 3 - Volver al inicio"
        read -r -p "Opción: " opcion

        case "$opcion" in
            1) signup ;;
            2) echo "login" ;;
            3) return ;;
            *) echo "No se ingresó una opción válida." ;;
        esac
    done
}

menuPrincipal (){

    while true; do
        echo "-- Menú Principal --" 
        echo "1 - Ingresar dron"  
        echo "2 - Asignar dron a reparto" 
        echo "3 - Actualizar dron"
        echo "4 - Volver al inicio" 

        read -r -p "Opción: " opcion

        case "$opcion" in 
            1) echo "Ingresar Dron"
                ;;
            2) echo "Asignar dron a reparto"
                ;;
            3) echo "Actualizar dron"
                ;;    
            4) return
                ;;             
            *) echo "No se ingresó una opción válida."
                ;;
        esac  
    done
}


inicio(){
    while true; do

        read -r -p $'Sistema de Drones. Bienvenido \n 1 - Menú de sesión \n 2 - Menú Principal\n 3 - Salir\n' menuvalor
        
        case "$menuvalor" in 
            1) menuSesion
                ;;
            2) menuPrincipal
                ;;
            3) exit 0
            ;;    

            *) echo "No se ingresó una opción válida."
                ;;
        esac   

    done 
}

# Ejecutamos el inicio.
inicio


# ACCION=$1
# PARAMETRO=$2
# ARCHIVO_FLOTA="flota.csv"

# if [ -z "$ACCION" ]; then
#     echo -e "Error: Acción no especificada\n\tUso: ./don_drones_manager.sh <ACCIÓN> [PARÁMETRO]\n\tEj: ./don_drones_manager.sh bateria_critica"
#     exit 1
# fi

# case $ACCION in
#     bateria_critica)
#         CONTADOR=0
#         while IFS=, read -r ID CAT MODELO BATERIA DISP; do
#             if [ "$BATERIA" -lt "20" ]; then
#                 CONTADOR=$((CONTADOR + 1))
#             fi
#         done < <(tail -n +2 "$ARCHIVO_FLOTA")  
#         echo "Drones con batería crítica: $CONTADOR"
#         ;;

#         #En lugar de usar pipe (|), redirigimos la salida del tail al bucle while usando < <(...)
#         #Esto evita la creación de un subshell y hace que el bucle se ejecute en el mismo proceso principal.

#     asignar)
#         DRON=$(grep "^$PARAMETRO," "$ARCHIVO_FLOTA")
        
#         DISPONIBLE=$(echo "$DRON" | cut -d',' -f5)
#         if [ "$DISPONIBLE" != "Si" ]; then
#             echo "Error: el dron $PARAMETRO no está disponible."
#             exit 1
#         fi

#         BATERIA_ACTUAL=$(grep "^$PARAMETRO," "$ARCHIVO_FLOTA" | cut -d',' -f4)
#         #cambiamos el operador > por -gt para comparar números en lugar de cadenas. 
#         #Además, en este contexto > se interpreta como redirección de salida, 
#         #creando un arhivo llamado "20" y redirigiendo la salida hacia él en lugar de realizar la comparación numérica deseada.

#         if [ "$BATERIA_ACTUAL" -gt "20" ]; then 
#             sed -i "s/^$PARAMETRO,\(.*\),Si$/$PARAMETRO,\1,No/" "$ARCHIVO_FLOTA"
#             echo "Dron $PARAMETRO asignado exitosamente."
#         else
#             echo "Error: Batería insuficiente."
#             exit 1
#         fi
#         ;;

#     *)
#         echo "Acción no reconocida."
#         exit 1
#         ;;
    
# esac