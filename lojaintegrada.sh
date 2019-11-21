#!/bin/bash
cinza="\e[90m"
normal="\e[0m"
vermelho="\e[31m"
verde="\e[32m"
bold="\e[1m"
 
 
#if [ "$variavel2" == "" ]; then
#        echo 'Utilize: lojaintegrada <dominio> <servidor>'
#        exit
#fi
 
echo -e $cinza"Reporte bugs para vitor.silveira@endurance.com\n "$normal
echo -e $verde"Apontamento loja integrada automatico"$normal
 
echo "###############################################"
echo "#                                             #"
echo "#          APONTAMENTO LOJA INTEGRADA         #"
echo "#               HOSTGATOR EIGSH               #"
echo "#                                             #"
echo "###############################################"
 
echo "                             [HostGator Brasil]"
echo "       [Feito por vitor.silveira@endurance.com]"
echo
echo
# TRATAMENTO DE TEXTO
texto=`echo $1 | tr A-Z a-z| cut -d ":" -f2 | sed 's/\///g'`
variavel2=`echo $2 | tr A-Z a-z`
texto2=$texto
tipoA="54.232.92.235"
tipoCNAME="www.${texto2}.cdn.vtex.com."
 
backupZona=/home/hgtransfer/.backupZona
if [ ! -d /home/hgtransfer ]
then
	mkdir /home/hgtransfer/
else
	echo " "
fi



if [ ! -d $backupZona ]
then
	mkdir $backupZona
else
        echo " "
fi
        #RETONRO SE USADO O COMANDO ERRADO
        if [ "$1" == "" ]; then
                echo -e "Utilize: lojaintegrada <dominio> <servidor>$vermelho <-b>$normal (use$vermelho -b$normal apenas em caso de$vermelho restauracao$normal de backup)"
                exit
        fi
        #RETONRO SE USADO O COMANDO ERRADO
        if [ "$2" == "" ]; then
                echo -e "Utilize: lojaintegrada <dominio> <servidor>$vermelho <-b>$normal (use$vermelho -b$normal apenas em caso de$vermelho restauracao$normal de backup)"
                exit
        fi
 
        echo -e "Procurando dominio$vermelho ${texto2}$normal"
                        echo " "
        procurando=`cat /etc/userdomains | grep ^${texto2} | wc -l`
 
        if [[ "$procurando" -lt "1" ]]; then
                echo -e "Dominio$vermelho nao$normal encontrado no servidor ${variavel2}"
                echo " "
                exit
        else
                echo -e "Dominio$verde encontrado$normal, prosseguindo.$normal"
                        echo " "
                        echo " "
       fi
    cd /tmp
        arquivocat=`mktemp cat.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`
        catt=$arquivocat
        identificado2=$(cat /var/named/${texto2}.db 2> ${catt})
        if [[ "$?" == "0" ]]; then
                echo -e "Dominio$verde encontrado$normal no servidor ${variavel2}"
           else
                echo -e "Dominio$vermelho nao$normal encontrado no servidor ${variavel2}"
                   exit
        fi
        rm -rf /tmp/$arquivocat
 
 
 
 
logBACKUP=`mktemp log.XXXXXXXXXXXXXXXX`
logAlteradoR=`mktemp alteradoR.XXXXXXXXXXXXXXXXXX`
logAlteradoO=`mktemp alteradoO.XXXXXXXXXXXXXXXXXX`
 
# FUNCAO QUE RESTAURA O BACKUP
function restaurarBACKUP() {
#CASO O BACKUP EXISTA, ELE FAZ A RESTAURACAO, SE NAO EXISTIR, NAO FAZ
if [ -f /home/hgtransfer/.backupZona/${texto2}.db.BKPLOJA ]; then
    #DELETANDO A ZONA ANTIGA
    rm -rf /var/named/${texto2}.db
    #RENOMENADO O BACKUP PARA O NOME DA ZONA ANTIGA
    mv /home/hgtransfer/.backupZona/${texto2}.db.BKPLOJA /var/named/${texto2}.db
 serial1BKP=`cat /var/named/${texto2}.db | grep -i serial | awk -F ";" '{print $1}' | sed 's/^[[:space:]]*//g'`
  serial2BKP=`expr $serial1BKP + 1`
  sed -i "s/$serial1BKP/$serial2BKP/g"  /var/named/${texto2}.db
                  echo " "
          echo "Executando checkzone no backup"
          named-checkzone ${texto2} /var/named/${texto2}.db > /tmp/$logBACKUP
          cat /tmp/$logBACKUP
rm -rf /tmp/$logBACKUP
rm -rf /tmp/$logAlteradoR
rm -rf /tmp/$logAlteradoO
        echo -e "Zona$verde restaurada$normal com sucesso"
else
     echo
     echo -e "Arquivo de backup$vermelho nao$normal existe para restaurar"
     exit
rm -rf /tmp/$logBACKUP
rm -rf /tmp/$logAlteradoR
rm -rf /tmp/$logAlteradoO
fi
 
}
 
#FUNCAO ALTERAR RESERVADO, FORMATO "DIFERENTE"
function ALTERARreservado(){
      echo -e "Procurando dominio$vermelho ${texto2}$normal"
                        echo " "
        procurando=`cat /etc/userdomains | grep ^${texto2} | wc -l`
        if [[ "$procurando" -lt "1" ]]; then
                echo -e "Dominio$vermelho nao$normal encontrado no servidor ${variavel2}"
                echo " "
                exit
        else
                echo -e "Dominio$verde encontrado$normal, prosseguindo.$normal"
                        echo " "
                        echo " "
       fi
 
          echo -e "Servidor $variavel2 detectado"
          echo -e "Realizando apontamento no ${variavel2}"
 
          acharIPR=$(cat -n /var/named/${texto2}.db | grep ${texto2}. | grep [0-9]$ | awk '{print $5}')
          achartipoAR=$(cat -n /var/named/${texto2}.db | grep ${texto2}. | grep [0-9]$ | sed -n 1p)
          catarLinhaR=$(cat -n /var/named/${texto2}.db | grep ${texto2}. | grep [0-9]$ | cut -f 1)
          LineeR=$catarLinhaR
 
          acharCNAMER=$(cat -n /var/named/${texto2}.db | awk -F ' ' '{print $2" "$5 " "$3" "$4" "$1}' | grep ^"www\ ")
          valorCNAMER=$(cat -n /var/named/${texto2}.db | awk -F ' ' '{print $2" "$5 " "$3" "$4" "$1}' | grep ^"www\ " | awk '{print $2}')
          catarLinhaCNAMER=$(cat -n /var/named/${texto2}.db | awk -F ' ' '{print $2" "$5 " "$3" "$4" "$1}' | grep ^"www\ " | awk '{print $5}')
          LineeCNAMER=$catarLinhaCNAMER
          if [[ $acharIPR == $tipoA ]]; then
                  echo
                  echo "Nao foi possivel realizar o apontamento, pelo motivo de ja estar para o Loja Integrada"
                  echo
                  echo "Qualquer duvida, entre em contato com vitor.silveira, ou um L."
                  exit
          fi
            achartipoA2=$(cat /var/named/${texto2}.db | grep ^${texto2}. | grep [0-9]$ | wc -l )
    if [[ "$achartipoA2" -ge "2" ]]; then
            echo -e $vermelho"Dominio com mais de um tipo A"$normal
            echo "Precisa realizar manualmente"
            exit
        else
            echo "Dominio nao possui tipo A a mais, prosseguindo"
        fi
 
            achartipoCNAME2=$(cat -n /var/named/${texto2}.db | awk -F ' ' '{print $2" "$5 " "$3" "$4" "$1}' | grep ^"www\ " | wc -l)
    if [[ "$achartipoCNAME2" -ge "2" ]]; then
            echo -e $vermelho"Dominio com mais de um apontamento tipo www"$normal
            echo "Precisa realizar manualmente"
            exit
        else
            echo "Dominio nao possui tipo WWW a mais, prosseguindo"
        fi
 
 
          cp -fp /var/named/${texto}.db /home/hgtransfer/.backupZona/${texto}.db.BKPLOJA
          echo
          echo -e "Backup da Zona de DNS$verde criado.$normal\nUtilize o parametro no final$verde -b$normal para restaurar o backup$vermelho\nlojaintegrada <dominio> <servidor> $verde<-b>$normal\nOu consulte um$vermelho L1/L2/L3/Especialista Tecnico$normal caso precise restaura-lo."
          echo
          sed -i "${LineeCNAMER}s/$valorCNAMER/$tipoCNAME/" "/var/named/${texto2}.db"
          sed -i "${LineeR}s/$acharIPR/$tipoA/" "/var/named/${texto2}.db"
 
          # SUBSTITUICAO SERIAL
          serial1=`cat /var/named/${texto2}.db | grep -i serial | awk -F ";" '{print $1}' | sed 's/^[[:space:]]*//g'`
          serial2=`expr $serial1 + 1`
          sed -i "s/$serial1/$serial2/g"  /var/named/${texto2}.db
 
         serial1BKP=`cat /home/hgtransfer/.backupZona/${texto2}.db.BKPLOJA | grep -i serial | awk -F ";" '{print $1}' | sed 's/^[[:space:]]*//g'`
  serial2BKP=`expr $serial1BKP + 1`
  sed -i "s/$serial1BKP/$serial2BKP/g"  /home/hgtransfer/.backupZona/${texto2}.db.BKPLOJA
 
 
          echo "Executando um checkzone"
 
          named-checkzone ${texto2} /var/named/${texto2}.db > /tmp/$logAlteradoR
          if [[ $? != 0 ]]
            then
                  echo -e $vermelho"Erro na zona,$normal verificar.\n $(cat /tmp/$logAlteradoR)\n"
                rm -f /tmp/$logAlteradoR
                else
                 echo -e $verde"Alterado com sucesso!"$normal
                cat /tmp/$logAlteradoR
                rm -f /tmp/$logAlteradoR
             fi
          exit
rm -rf /tmp/$logBACKUP
rm -rf /tmp/$logAlteradoR
rm -rf /tmp/$logAlteradoO
        }
 
function alterarOUTRO() {
  echo -e "Procurando dominio$vermelho ${texto2}$normal"
                    echo " "
    procurando=`cat /etc/userdomains | grep ^${texto2} | wc -l`
    if [[ "$procurando" -lt "1" ]]; then
            echo -e "Dominio$vermelho nao$normal encontrado no servidor ${variavel2}"
            echo " "
            exit
    else
            echo -e "Dominio$verde encontrado$normal, prosseguindo.$normal"
                    echo " "
                    echo " "
   fi
 
      echo -e "Servidor $variavel2 detectado"
      echo -e "Realizando apontamento no ${variavel2}"
 
      acharIPR=$(cat -n /var/named/${texto2}.db | grep ${texto2}. | grep [0-9]$ | awk '{print $6}')
      achartipoAR=$(cat -n /var/named/${texto2}.db | grep ${texto2}. | grep [0-9]$ | sed -n 1p)
      catarLinhaR=$(cat -n /var/named/${texto2}.db | grep ${texto2}. | grep [0-9]$ | cut -f 1)
      LineeR=$catarLinhaR
 
      acharCNAMER=$(cat -n /var/named/${texto2}.db | awk -F ' ' '{print $2" "$6" "$5" "$3" "$4" "$1}' | grep ^"www\ ")
      valorCNAMER=$(cat -n /var/named/${texto2}.db | awk -F ' ' '{print $2" "$6" "$5" "$3" "$4" "$1}' | grep ^"www\ " | awk '{print $2}')
      catarLinhaCNAMER=$(cat -n /var/named/${texto2}.db | awk -F ' ' '{print $2" "$6" "$5" "$3" "$4" "$1}' | grep ^"www\ " | awk '{print $6}')
      LineeCNAMER=$catarLinhaCNAMER
      if [[ $acharIPR == $tipoA ]]; then
              echo
              echo "Nao foi possivel realizar o apontamento, pelo motivo de ja estar para o Loja Integrada"
              echo
              echo "Qualquer duvida, entre em contato com vitor.silveira, ou um L."
              exit
      fi
        achartipoA2=$(cat /var/named/${texto2}.db | grep ^${texto2}. | grep [0-9]$ | wc -l )
if [[ "$achartipoA2" -ge "2" ]]; then
        echo -e $vermelho"Dominio com mais de um tipo A"$normal
        echo "Precisa realizar manualmente"
        exit
    else
        echo "Dominio nao possui tipo A a mais, prosseguindo"
    fi
 
        achartipoCNAME2=$(cat -n /var/named/${texto2}.db | awk -F ' ' '{print $2" "$6" "$5" "$3" "$4" "$1}' | grep ^"www\ " | wc -l)
if [[ "$achartipoCNAME2" -ge "2" ]]; then
        echo -e $vermelho"Dominio com mais de um apontamento tipo www"$normal
        echo "Precisa realizar manualmente"
        exit
    else
        echo "Dominio nao possui tipo WWW a mais, prosseguindo"
    fi
 
 
      cp -fp /var/named/${texto}.db /home/hgtransfer/.backupZona/${texto}.db.BKPLOJA
      echo
      echo -e "Backup da Zona de DNS$verde criado.$normal\nUtilize o parametro no final$verde -b$normal para restaurar o backup$vermelho\nlojaintegrada <dominio> <servidor> $verde<-b>$normal\nOu consulte um$vermelho L1/L2/L3/Especialista Tecnico$normal caso precise restaura-lo."
      echo
      sed -i "${LineeCNAMER}s/$valorCNAMER/$tipoCNAME/" "/var/named/${texto2}.db"
      sed -i "${LineeR}s/$acharIPR/$tipoA/" "/var/named/${texto2}.db"
 
      # SUBSTITUICAO SERIAL
      serial1=`cat /var/named/${texto2}.db | grep -i serial | awk -F ";" '{print $1}' | sed 's/^[[:space:]]*//g'`
      serial2=`expr $serial1 + 1`
      sed -i "s/$serial1/$serial2/g"  /var/named/${texto2}.db
 
     serial1BKP=`cat /home/hgtransfer/.backupZona/${texto2}.db.BKPLOJA | grep -i serial | awk -F ";" '{print $1}' | sed 's/^[[:space:]]*//g'`
serial2BKP=`expr $serial1BKP + 1`
sed -i "s/$serial1BKP/$serial2BKP/g"  /home/hgtransfer/.backupZona/${texto2}.db.BKPLOJA
 
 
      echo "Executando um checkzone"
 
      named-checkzone ${texto2} /var/named/${texto2}.db > /tmp/$logAlteradoR
      if [[ $? != 0 ]]
        then
              echo -e $vermelho"Erro na zona,$normal verificar.\n $(cat /tmp/$logAlteradoR)\n"
            rm -f /tmp/$logAlteradoR
            else
             echo -e $verde"Alterado com sucesso!"$normal
            cat /tmp/$logAlteradoR
            rm -f /tmp/$logAlteradoR
         fi
      exit
rm -rf /tmp/$logBACKUP
rm -rf /tmp/$logAlteradoR
rm -rf /tmp/$logAlteradoO
    }
 
         re='^[0-9]+$'
 
        identificador=$(cat /var/named/${texto2}.db | grep ^${texto2}. |  grep [0-9]$ | awk '{print $2}' )
 
 if [[ $3 == "-b" ]];  then
        echo " "
      while true; do
         read -p "Voce tem certeza que quer restaurar o backup da zona do ${texto2} ?(s/n)  " sn
            case $sn in
                [Ss]* ) restaurarBACKUP; exit;;
                [Nn]* ) echo "Sabia escolha"; exit;;
        * ) echo "Por favor responda sim ou nao (s/n).";;
        esac
      done
          exit
        fi
        if [[ $3 == "-B" ]];  then
                echo " "
      while true; do
         read -p "Voce tem certeza que quer restaurar o backup da zona do ${texto2} ?(s/n)  " sn
            case $sn in
                [Ss]* ) restaurarBACKUP; exit;;
                [Nn]* ) echo "Sabia escolha"; exit;;
        * ) echo "Por favor responda sim ou nao (s/n).";;
        esac
      done
          exit
        fi
 
 
        #if [[ $HOSTNAME == "reservado01.hostgator.com.br" ]]; then
 
function identificadoR() {
  if [[ $variavel2 != " " ]]; then
      while true; do
         read -p "Voce quer alterar a zona do ${texto2} para o loja integrada?(s/n)  " sn
            case $sn in
                [Ss]* ) ALTERARreservado; exit;;
                [Nn]* ) echo "Sabia escolha"; exit;;
        * ) echo "Por favor responda sim ou nao (s/n).";;
        esac
      done
    fi
}
 
function identificadorO(){
   if [[ $variavel2 != " " ]]; then
     while true; do
         read -p "Voce quer alterar a zona do ${texto2} para o loja integrada?(s/n)  " sn
            case $sn in
                [Ss]* ) alterarOUTRO; exit;;
                [Nn]* ) echo "Sabia escolha"; exit;;
        * ) echo "Por favor responda sim ou nao (s/n).";;
        esac
      done
    fi
}
 
        if ! [[ "$identificador" =~ $re ]]; then
         echo " "
         identificadoR
        else
         echo " "
         identificadorO
        fi
