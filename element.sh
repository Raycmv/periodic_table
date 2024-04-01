#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

FINDATA() {
    CONSULT1=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE atomic_number = $1")
    CONSULT2=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius,type_id FROM properties WHERE atomic_number = $1")
        echo "$CONSULT1" | while IFS='|' read ATOMIC NAME SYMBOL
          do
            echo "$CONSULT2" | while IFS='|' read ATOMIC_MASS MELTING_POINTS BOILING_POINTS TYPE_ID
              do
                TYPE=$($PSQL "SELECT type FROM types WHERE  type_id=$TYPE_ID")
                echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINTS celsius and a boiling point of $BOILING_POINTS celsius."
              done
          done
}


if [[ $1 ]]
then
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        ATO_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
        if [[ -z $ATO_NUM ]]
        then
          echo "I could not find that element in the database."
        else
          FINDATA $ATO_NUM
        fi
        
    elif [[ ${#1} -le 2 ]]
    then
        ATO_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
        if [[ -z $ATO_NUM ]]
        then
          echo "I could not find that element in the database."
        else
          FINDATA $ATO_NUM
        fi
    else
        ATO_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
        if [[ -z $ATO_NUM ]]
        then
          echo "I could not find that element in the database."
        else
          FINDATA $ATO_NUM
        fi
    fi
else
    echo "Please provide an element as an argument."
fi


  
    


