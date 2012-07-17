rm paradas.txt
long_min=35500; lat_min=63000; long_max=65000; lat_max=76300
base_long="-4."; base_lat="36."
while [ $long_min -lt $long_max ]; do 
	while [ $lat_min -lt $lat_max ]; do 
		~/Desktop/FunnyEMT/./balloon.sh $base_lat$lat_min $base_long$long_min
		let lat_min+=1
	done
	let long_min+=1
done
echo "Finish EMT Job:" | mutt -s "EMT Job" hvalverde@uma.es
