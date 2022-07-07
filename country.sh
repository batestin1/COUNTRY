#!/bin/bash
#####################################################################
#
# script name: country
# created in: 06/29/22
# modified in: 14:13:28
#
# summary: Retorna a capital de um pais
#                                               developed by: bates
#####################################################################

clear
#variables

PAM=$1

if [ $(uname) = "Linux" ]; then

    sudo apt-get update -y > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    sudo apt-get install curl  > /dev/null 2> /dev/null

    sudo apt-get install jq > /dev/null 2> /dev/null

    #game
elif [ $(uname) = "Darwin" ]; then
    sudo apt-get update -y > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    /usr/bin/ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install) > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    brew install jq > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    brew install coreutil > /dev/null 2> /dev/null && sudo apt-get upgrade -y > /dev/null 2> /dev/null
    #game
fi
if [ $PAM ]; then
    if [ $PAM = "--ajuda" ] 2>/dev/null; then
        echo "#======================================================================================#"
        echo "# O Programa consulta a api do site wikipedia.org, em versão PT-BR                     #"
        echo "# O primeiro input que ele necessita é o nome do país.                                 #"
        echo "#======================================================================================#"
        echo ""
        echo "#======================================================================================#"
        echo "# Para saber a versão do programa digite o comando abaixo                              #"
        echo "# sh country.sh --versao                                                               #"
        echo "#======================================================================================#"
    fi

    if [ $PAM = "--versao" ] 2>/dev/null; then
        NOW=$(git log -p -1 | grep -i Date:)
        VAL=$(git log --oneline | grep -i -c "v")
        AFTER=$(git log -p -2 | grep -i Date:)
        if [ "$AFTER" = "$NOW" ]; then
            VAL=$(git log --oneline | grep -i -c "v")
        else
            VAL=$(expr $VAL + 1 )
        fi
        echo ""
        echo "#======================================================================================#"
        echo "# Versão do Programa $VAL.0.0                                                             #"
        echo "#======================================================================================#"
        echo ""
        echo "#======================================================================================#"
        echo "# Para saber mais sobre o programa digite o comando                                    #"
        echo "# sh country.sh --ajuda                                                                #"
        echo "#======================================================================================#"
    fi
else
    if [ country.sh ] 2>/dev/null; then

        read -p "Insira o nome do pais: " NAME
        NAME_1=$(echo $NAME | sed -e "s/\b\(.\)/\u\1/g")
        NAME_COUNTRY=$(echo $NAME_1 | sed 's/ /_/g')

        RES=$(curl -s -L https://pt.wikipedia.org/wiki/$NAME_COUNTRY | grep -i "vertical-align:top" | sed "1, 5 d"  | sed "s/<[^>]*>/\n/g" | sed "1,2 d" | head -n1 | sed "s/\n//g")
        RES_P=$(echo $RES | sed -e "s/\b\(.\)/\u\1/g")


        if [ "$RES_P" = "Cidade Mais Populosa" -o "$RESP" = "Cidade mais populosa" ]; then
            RES=$(curl -s -L https://pt.wikipedia.org/wiki/$NAME_COUNTRY  | grep -i "vertical-align:top" | sed "1, 5 d"  | sed "s/<[^>]*>/\n/g" | sed "1,5 d" | head -n1)
            RES_P=$(echo $RES | sed -e "s/\b\(.\)/\u\1/g")
        fi

        if [ "$RES_P" = "" ]; then
            RES_P="Não conseguimos encontrar essa resposta!"
        fi


        echo "PAIS: $NAME_1"
        echo "CAPITAL: $RES_P"

        read -p "Deseja pesquisar novamente? (Y/n) " OPT

        if [ "$OPT" = "Y" -o "$OPT" = "y" -o "$OPT" = "" ]; then
            sh country.sh
        else
            echo "Obrigado!"
        fi
    fi
fi