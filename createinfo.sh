#!/bin/bash
cinza="\e[90m"
normal="\e[0m"
vermelho="\e[31m"
verde="\e[32m"
bold="\e[1m"
##################################
texto=`echo $1 | tr A-Z a-z| cut -d ":" -f2 | sed 's/\///g'`
servidor=`echo $2 | tr A-Z a-z`
dominio=$texto
##################################
echo "###########################################################"
echo "##                                                       ##"
echo "##                                                       ##"
echo "##                    I N F O . P H P                    ##"
echo "##                                                       ##"
echo "##                                                       ##"
echo "###########################################################"
echo "                                 [Feito por vitor.silveira]"
if [[ $1 == "" ]]; then
    echo -e "[$vermelho$bold+$normal] Por favor, insira um domínio/subdomínio válido"
    exit
fi
if [[ $2 == "" ]]; then
    echo -e "[$vermelho$bold+$normal] Por favor, insira um servidor válido"
    exit
fi
DIRDom=$(whmapi1 domainuserdata domain=${dominio} | grep documentroot | awk '{print $2}')
arquivo=$DIRDom/info.php
cat /etc/userdomains | grep ^${dominio} | awk '{print $2}' > /dev/null 2>&1
if [[ "$?" != "0" ]]; then
    echo "Usuário não identificado"
    exit
fi
cat /etc/userdomains | grep ^${dominio} > /dev/null 2>&1
if [[ "$?" != "0" ]]; then
    echo "Dominio/Sub Dominio nao encontrado"
    exit
fi
cd /tmp
arquivocat=`mktemp cat.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`
catt=$arquivocat
identificado2=$(cat /var/named/${dominio}.db 2> ${catt})
if [[ "$?" != "0" ]]; then
    echo -e "Dominio$vermelho nao$normal encontrado no servidor ${variavel2}"
    exit
fi
rm -f /tmp/$arquivocat
if [[ -f $DIRDom/info.php ]]; then
    echo -e "[$vermelho$bold+$normal] Arquivo já existe"
    exit
fi
USUARIO=$(cat /etc/userdomains | grep ^${dominio} | awk '{print $2}')
echo -e "[$verde$bold+$normal] Arquivo info.php criado em$verde$bold $DIRDom/info.php $normal"
echo "<?php
phpinfo();
?>" >> $arquivo
chown $USUARIO $arquivo
chgrp $USUARIO $arquivo 
