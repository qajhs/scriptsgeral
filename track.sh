#API TO SEARCH IP
#!/bin/bash
cinza="\e[90m"
normal="\e[0m"
vermelho="\e[31m"
verde="\e[32m"
bold="\e[1m"
echo -e $cinza"Submit all bugs to (vitor.silveira@endurance.com)"$normal
echo -e $bold"#############################################"
echo -e $bold"#                                           #"
echo -e $bold"#             LOCALIZADOR DE IP             #"
echo -e $bold"#                 BY VITOR S.               #"
echo -e $bold"#                                           #"
echo -e $bold"#############################################\n"
#########################################################################################################################
###
# Validações
###
#########################################################################################################################
if [[ $1 == "" ]]; then
    echo -e "$normal[$vermelho$bold+$normal] Favor informar um IP\n"
    exit
fi
if ! [[ $1 == *"."* ]]; then
    echo -e "$normal[$vermelho$bold+$normal] Favor informar um IP válido, exemplo 127.0.0.1 $bold(COM PONTOS)$normal\n"
    exit
fi
#########################################################################################################################
###
# Pegar IP e tratar
###
#########################################################################################################################
curl -s ip-api.com/json/$1 > $HOME/tratar
echo -e "[$verde$bold+$normal] Verificando IP > $verde$1$normal"
#########################################################################################################################
###
# Tratando
###
#########################################################################################################################
Pais=$(cat $HOME/tratar | jq .country | cut -d\" -f2)
Cidade=$(cat $HOME/tratar | jq .city | cut -d\" -f2)
Regiao=$(cat $HOME/tratar | jq .regionName | cut -d\" -f2)
isp=$(cat $HOME/tratar | jq .isp | cut -d\" -f2)
org=$(cat $HOME/tratar | jq .org | cut -d\" -f2)
#########################################################################################################################
###
# Echo's
###
#########################################################################################################################
echo -e "[$verde$bold+$normal] País > $verde$Pais$normal"
echo -e "[$verde$bold+$normal] Cidade > $verde$Cidade$normal"
echo -e "[$verde$bold+$normal] Região > $verde$Regiao$normal"
echo -e "[$verde$bold+$normal] Provedor de internet > $verde$isp$normal"
echo -e "[$verde$bold+$normal] Empresa do IP > $verde$org$normal\n"
#########################################################################################################################
###
# Apagando
###
#########################################################################################################################
rm -f $HOME/tratar
