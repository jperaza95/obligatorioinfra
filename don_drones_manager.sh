#!/bin/bash

#Variables
ARCHIVO_FLOTA="flota.csv"

declare -A usuarios
# -A es array asociativo.

usuarios["a"]="a"
usuarioLogueado=""

categorias=("Scout" "Cargo" "Heavy" "Cooler" "Racer")

#Funciones

esNumerico(){
    local valor=$1
    if[[ "$valor" =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
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

login(){
    echo "-- Login --"
    read -r -p $'Usuario: \n' user
    read -r -p $'Password: \n' pass

    while ! [[ -v usuarios["$user"] && "${usuarios["$user"]}" == "$pass" ]]; do
        echo -e "Error al intentar loguear. Pruebe nuevamente: \n"
        read -r -p $'Usuario: \n' user
        read -r -p $'Password: \n' pass
    done

    usuarioLogueado=$user;

    echo "Usuario $usuarioLogueado logueado correctamente."
    menuPrincipal
    
}

logout(){
    usuarioLogueado=""
    menuSesion
}

mostrarCategorias(){
    for c in "${!categorias[@]}"; do  # "!" recorre los indices de la lista.
        echo "$c - ${categorias[$c]}" # ${categorias[c]} - categoria en la posicion i 
        #"${#categorias[@]}" / tamaño del array
    done
}

obtenerCategoriaPorIndice(){
    local indice=$1

    for ((i=0; i<${#categorias[@]}; i++)); do
        if [ "$i" -eq "$indice" ]; then
            echo "${categorias[i]}" #retorna el nombre de la categoria hacia afuera
            return 0 #corta toda la funcion.
        fi
    done

}

aumentarEnUno(){
    local actualId=$1 # recibo HEA-004
    local prefijo="${actualId:0:4}" #extrae HEA-
    local actualNumeros="${actualId: -3}" #extrae ultimos 3: 004
    local siguienteNumeros=$((10#$actualNumeros+1)) # 10# : bash puede interpretar numeros que empiezan con cero como octales
    printf "%s%03d\n" "$prefijo" "$siguienteNumeros" #HEA-005; ancho del numero es 3, rellenando con ceros a la izq
   
}

asignarid(){
    local categoria=$1 ## recibe categoria Heavy por ej.
    local prefijo="${categoria:0:3}"  ##extrae Hea
    prefijo="${prefijo^^}" ## Pasa a mayusc HEA


    while IFS=, read -r ID CAT MODELO BATERIA DISP; do
        if [ "${ID:0:3}" == "$prefijo" ]; then
            echo $(aumentarEnUno "$ID")
            return 0
        fi
    done < <(tail -n +2 "$ARCHIVO_FLOTA" | tac)  



}
ingresarModelo(){
    read -r -p $'Ingrese el modelo: \n' modelo

    while [[ -z "$modelo" ]]; do
            read -r -p $'El modelo no puede estar vacio. Intente nuevamente: \n' modelo
    done
    echo $modelo
}

ingresarBateria(){
    read -r -p $'Ingrese nivel de bateria: \n' bat

    while [[ bat -lt 0 || bat -gt 100 ]]; do
            read -r -p $'Ingrese un nivel de bateria entre 0 y 100\n' bat
    done

    echo $bat
}


ingresarDron(){
    echo "**-- ALTA DE DRON --**"

    local categoria=""
    local id

    #categoria
    echo -e "Seleccione una categoría: \n"
    mostrarCategorias
    read -r  categ
    categoria=$(obtenerCategoriaPorIndice "$categ") 
    echo "Categoría seleccionada : $categoria"
    id=$(asignarid "$categoria")

    local modelo=$(ingresarModelo)
    echo $modelo

    #bateria
    local bateria=$(ingresarBateria)

}

menuSesion(){
    while true; do
        echo
        echo "**-- BIENVENIDO --**"
        echo " 1 - Registrarse"
        echo " 2 - Log In"
        echo " 3 - Salir"
        read -r -p "Opción: " opcion

        case "$opcion" in
            1) signup ;;
            2) login ;;
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
        echo "4 - Log Out" 

        read -r -p "Opción: " opcion

        case "$opcion" in 
            1) ingresarDron
                ;;
            2) echo "Asignar dron a reparto"
                ;;
            3) echo "Actualizar dron"
                ;;    
            4) logout
                ;;             
            *) echo "No se ingresó una opción válida."
                ;;
        esac  
    done
}


# inicio(){
#     while true; do

#         read -r -p $'Sistema de Drones. Bienvenido \n 1 - Menú de sesión \n 2 - Menú Principal\n 3 - Salir\n' menuvalor
        
#         case "$menuvalor" in 
#             1) menuSesion
#                 ;;
#             2) menuPrincipal
#                 ;;
#             3) exit 0
#             ;;    

#             *) echo "No se ingresó una opción válida."
#                 ;;
#         esac   

#     done 
# }

# Ejecutamos el inicio.
menuSesion


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