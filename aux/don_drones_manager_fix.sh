#!/bin/bash

ACCION=$1
PARAMETRO=$2
ARCHIVO_FLOTA="flota.csv"

if [ -z "$ACCION" ]; then
    echo -e "Error: Acción no especificada\n\tUso: ./don_drones_manager.sh <ACCIÓN> [PARÁMETRO]\n\tEj: ./don_drones_manager.sh bateria_critica"
    exit 1
fi

case $ACCION in
    bateria_critica)
        CONTADOR=0
        while IFS=, read -r ID CAT MODELO BATERIA DISP; do
            if [ "$BATERIA" -lt "20" ]; then
                CONTADOR=$((CONTADOR + 1))
            fi
        done < <(tail -n +2 "$ARCHIVO_FLOTA")  
        echo "Drones con batería crítica: $CONTADOR"
        ;;

        #En lugar de usar pipe (|), redirigimos la salida del tail al bucle while usando < <(...)
        #Esto evita la creación de un subshell y hace que el bucle se ejecute en el mismo proceso principal.

    asignar)
        DRON=$(grep "^$PARAMETRO," "$ARCHIVO_FLOTA")
        
        DISPONIBLE=$(echo "$DRON" | cut -d',' -f5)
        if [ "$DISPONIBLE" != "Si" ]; then
            echo "Error: el dron $PARAMETRO no está disponible."
            exit 1
        fi

        BATERIA_ACTUAL=$(grep "^$PARAMETRO," "$ARCHIVO_FLOTA" | cut -d',' -f4)
        #cambiamos el operador > por -gt para comparar números en lugar de cadenas. 
        #Además, en este contexto > se interpreta como redirección de salida, 
        #creando un arhivo llamado "20" y redirigiendo la salida hacia él en lugar de realizar la comparación numérica deseada.

        if [ "$BATERIA_ACTUAL" -gt "20" ]; then 
            sed -i "s/^$PARAMETRO,\(.*\),Si$/$PARAMETRO,\1,No/" "$ARCHIVO_FLOTA"
            echo "Dron $PARAMETRO asignado exitosamente."
        else
            echo "Error: Batería insuficiente."
            exit 1
        fi
        ;;

    *)
        echo "Acción no reconocida."
        exit 1
        ;;
    
esac