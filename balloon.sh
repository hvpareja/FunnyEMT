#########################################################################
#									#
# 	Autor: Héctor Valverde Pareja					#
# 	Email: hvalverde@uma.es						#
# 	Dirección: Departamento de Biología Molecular y Bioquímica	#
# 			Facultad de Ciencias				#
#			Universidad de Málaga				#
#	 Twitter: @hvpareja						#
#	          (https://twitter.com/hvpareja)			#
#									#
# 	Fecha: 12 de Julio de 2012					#
#									#
#########################################################################

# Reporte de errores e instrucciones de uso
if [ $# -lt 2 ]; then
	echo -e "\nERROR: Falta algún argumento."
	echo -e "Uso:"
	echo -e "./balloon.sh <Latitud> <Longitud>"
	exit
fi

# Captura de variables (desde los argumentos)
lat=$1
long=$2

#long_min=3550; lat_min=6300; long_max=6500; lat_max=7630
#base_long="-4."; base_lat="36."
#while [ $long_min -lt $long_max ]; do 
#	while [ $lat_min -lt $lat_max ]; do 
#		echo $base_lat$lat_min $base_long$long_min
#		let lat_min+=1
#	done
#	let long_min+=1
#done


# Si no existe el archivo "paradas.txt", lo creamos (OUTPUT)
if [ ! -f paradas.txt ]; then
	# Cabecera de la tabla
	echo -e "\n\tLista de paradas:\n" > paradas.txt
fi


# Llamada http y filtrado extracción de los enlaces (filtrado)
ItemList=$(curl -s "http://dev.layar.com/api/layer/pois/emtmalaga/?countryCode=ES&lat=${lat}&localCountryCode=ES&lon=${long}&oauth_consumer_key=&oauth_nonce=&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1342082734&oauth_version=1.0&phoneId=&radius=400&version=5.0&oauth_signature=" | grep "\"uri\":" | grep "&name=" | sed 's/^.*"uri": "/	/g' | sed 's/",//g')

# Incluye los nuevos datos sin redundancia
counter=0
for Item in $ItemList; do
	match=$(grep $Item paradas.txt | wc -l) 
	if [ $match -eq 0 ]; then
		echo $Item >> paradas.txt
		let counter=counter+1
	fi
done

# Contar el número de paradas que llevamos recopiladas
num=$(grep "http" paradas.txt | wc -l)

# Muestra las paradas si ha encontrado alguna nueva
if [ $counter -gt 0 ]; then

	# Limpia la consola
	clear

	# Muestra la tabla
	cat paradas.txt

	# Pie de tabla
	echo -e "\n\tTotal:\n\t\t$num paradas almacenadas ($counter nuevas)\n"

fi

