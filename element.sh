#!/bin/bash 
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  if [[ $1 =~ ^[1-9][0-9]?$ ]];
  then
    ATOMIC_NUMBER=$1
    SYMBOL=$($PSQL "select symbol from elements where atomic_number=$ATOMIC_NUMBER;")
    TYPE=$($PSQL "select type from properties inner join types using(type_id) where atomic_number=$ATOMIC_NUMBER;")
    NAME=$($PSQL "select name from elements where atomic_number=$ATOMIC_NUMBER;")
    MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
  elif [[ $1 =~ [A-Z][a-z]?$ ]];
  then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1';")
    SYMBOL=$1
    TYPE=$($PSQL "select type from properties inner join types using(type_id) where atomic_number=$ATOMIC_NUMBER;")
    NAME=$($PSQL "select name from elements where atomic_number=$ATOMIC_NUMBER;")
    MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
  else
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name='$1';")
    SYMBOL=$($PSQL "select symbol from elements where atomic_number=$ATOMIC_NUMBER;")
    TYPE=$($PSQL "select type from properties inner join types using(type_id) where atomic_number=$ATOMIC_NUMBER;")
    NAME=$1
    MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
  fi
  if [[ -z $MASS ]]
  then
    echo "I could not find that element in the database."
  else
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
