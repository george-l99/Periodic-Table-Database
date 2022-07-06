#!/bin/bash
PSQL="psql -U freecodecamp -d periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    PROPERTIES=$($PSQL "SELECT atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name FROM properties LEFT JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $1") 
  else
    PROPERTIES=$($PSQL "SELECT atomic_number,type,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name FROM properties LEFT JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  fi
  if [[ -z $PROPERTIES ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$PROPERTIES" | while IFS="|" read ATOMIC_NUMBER TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi
