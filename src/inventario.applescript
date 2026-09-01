on run
	try
		set targetFolder to choose folder with prompt "Seleccione la carpeta de la SALA donde desea guardar el inventario de este equipo:"
		set targetPath to POSIX path of targetFolder
	on error
		return
	end try
	
	set shScript to "
TARGET_DIR=\"" & targetPath & "\"
TARGET_DIR=\"${TARGET_DIR%/}\"

COMPUTER_NAME=$(scutil --get ComputerName 2>/dev/null)
[ -z \"$COMPUTER_NAME\" ] && COMPUTER_NAME=$(hostname -s)

SERIAL_NUM=$(ioreg -c IOPlatformExpertDevice 2>/dev/null | grep \"IOPlatformSerialNumber\" | awk -F\"\\\"\" '{print $4}')
if [ -z \"$SERIAL_NUM\" ]; then
    SERIAL_NUM=$(system_profiler SPHardwareDataType 2>/dev/null | grep \"Serial Number\" | awk -F\": \" '{print $2}')
fi
[ -z \"$SERIAL_NUM\" ] && SERIAL_NUM=\"No disponible\"

MARCA=\"Apple\"

MODEL_NAME=$(system_profiler SPHardwareDataType 2>/dev/null | grep \"Model Name\" | awk -F\": \" '{print $2}')
MODEL_ID=$(sysctl -n hw.model 2>/dev/null)
if [ -n \"$MODEL_NAME\" ] && [ -n \"$MODEL_ID\" ]; then
    MODELO=\"$MODEL_NAME ($MODEL_ID)\"
elif [ -n \"$MODEL_NAME\" ]; then
    MODELO=\"$MODEL_NAME\"
else
    MODELO=\"${MODEL_ID:-Mac}\"
fi

RAM=$(system_profiler SPHardwareDataType 2>/dev/null | grep \"Memory:\" | awk -F\": \" '{print $2}')
if [ -z \"$RAM\" ]; then
    BYTES=$(sysctl -n hw.memsize 2>/dev/null)
    if [ -n \"$BYTES\" ]; then
        GB=$((BYTES / 1073741824))
        RAM=\"${GB} GB\"
    else
        RAM=\"No disponible\"
    fi
fi

CHIP=$(system_profiler SPHardwareDataType 2>/dev/null | grep \"Chip:\" | awk -F\": \" '{print $2}')
PROC_NAME=$(system_profiler SPHardwareDataType 2>/dev/null | grep \"Processor Name:\" | awk -F\": \" '{print $2}')
CPU_BRAND=$(sysctl -n machdep.cpu.brand_string 2>/dev/null)
if [ -n \"$CHIP\" ]; then
    PROCESADOR=\"$CHIP\"
elif [ -n \"$PROC_NAME\" ]; then
    PROCESADOR=\"$PROC_NAME\"
elif [ -n \"$CPU_BRAND\" ]; then
    PROCESADOR=\"$CPU_BRAND\"
else
    PROCESADOR=\"Procesador Mac\"
fi

OS_NAME=$(sw_vers -productName 2>/dev/null)
OS_VER=$(sw_vers -productVersion 2>/dev/null)
SO=\"${OS_NAME} ${OS_VER}\"

DISCO_NOMBRE=$(diskutil info disk0 2>/dev/null | grep \"Device / Media Name\" | sed 's/.*: *//')
[ -z \"$DISCO_NOMBRE\" ] && DISCO_NOMBRE=$(diskutil info / 2>/dev/null | grep \"Device / Media Name\" | sed 's/.*: *//')
[ -z \"$DISCO_NOMBRE\" ] && DISCO_NOMBRE=\"SSD / Disco Principal\"

DISCO_TAMANO=$(diskutil info disk0 2>/dev/null | grep \"Disk Size\" | sed 's/.*: *//' | sed 's/ (.*//')
[ -z \"$DISCO_TAMANO\" ] && DISCO_TAMANO=$(diskutil info / 2>/dev/null | grep \"Disk Size\" | sed 's/.*: *//' | sed 's/ (.*//')
[ -z \"$DISCO_TAMANO\" ] && DISCO_TAMANO=$(df -h / | awk 'NR==2 {print $2}')

SAFE_NAME=$(echo \"$COMPUTER_NAME\" | tr '/' '-' | tr ':' '-')
FILE_PATH=\"${TARGET_DIR}/${SAFE_NAME}.txt\"

cat << OUT > \"$FILE_PATH\"
================================================================================
                   INVENTARIO DE EQUIPO MAC
================================================================================
NOMBRE DEL EQUIPO  : $COMPUTER_NAME
NÚMERO DE SERIE    : $SERIAL_NUM
MARCA              : $MARCA
MODELO             : $MODELO
MEMORIA RAM        : $RAM
PROCESADOR         : $PROCESADOR
SISTEMA OPERATIVO  : $SO
DISCOS             : $DISCO_NOMBRE
TAMAÑO DEL DISCO   : $DISCO_TAMANO
================================================================================
FORMATO DE TABLA / EXCEL (TAB SEPARATED):
NOMBRE DEL EQUIPO	NÚMERO DE SERIE	MARCA	MODELO	MEMORIA RAM	PROCESADOR	SISTEMA OPERATIVO	DISCOS	TAMAÑO DEL DISCO
$COMPUTER_NAME	$SERIAL_NUM	$MARCA	$MODELO	$RAM	$PROCESADOR	$SO	$DISCO_NOMBRE	$DISCO_TAMANO
================================================================================
OUT

echo \"${SAFE_NAME}.txt|${TARGET_DIR}\"
"
	set outputInfo to do shell script shScript
	
	set AppleScript's text item delimiters to "|"
	set fileName to text item 1 of outputInfo
	set folderLoc to text item 2 of outputInfo
	set AppleScript's text item delimiters to ""
	
	display dialog "✅ Inventario guardado exitosamente." & return & return & "📄 Archivo: " & fileName & return & "📁 Ubicación: " & folderLoc buttons {"Aceptar"} default button "Aceptar" with icon note
end run
