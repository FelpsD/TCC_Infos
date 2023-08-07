#
#  			Bash0711.sh
# 
# Este programa inicia junto com o embarcado, para definir se a rede cabeada tera um IPV4 manual (caso do laboratorio aerotech) 
# ou um IPV4 com DHCP, nao precisando dessa maneira de um adaptador serial para ter acesso a plaquinha
# 
# Funcao manual: so ligar a plaquinha ja conectada no cabo
#  
# Funcao DHCP: ligar a plaquinha e depois sim conectar o cabo
# 
# 
# 
# Funcao:     Definir IPV4 manual ou DHCP automaticamente
# Plataforma: Linux (ARM)
# 
# Autor:      Felippe Destri Ferreira 10747012 
#


#!/bin/sh
sleep 5 #Importante para deixar o sistema como um todo ininiar, poderia ser resolvido se o After no .service fosse o correto
cable=`cat /sys/class/net/eth0/carrier` #1 retorna se tiver algum cabo de rede conectado e 0 caso o contrario
true=1
((end_time=${SECONDS}+100)) #timeout de 100 segundos

if [ $cable = $true ]; then 
	var=$(connmanctl services | grep -Eo "(ethernet)\w+") #armazena o nome do servico da rede cabeada
	connmanctl config $var --ipv4 manual 172.31.1.171 255.255.255.0 172.31.1.255 
	exit 0
else
	sleep 2
	while [ $SECONDS -lt $end_time ]; do
	cable=`cat /sys/class/net/eth0/carrier`
	if [ $cable = $true ]; then
	  sleep 1
	  var=$(connmanctl services | grep -Eo "(ethernet)\w+")
          connmanctl config $var --ipv4 dhcp
	  echo "DHCP setted"
	  exit 0
	fi
	done
	echo "DHCP failed"
	exit 0
fi
