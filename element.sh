PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

PRINT_ELEMENT() {
  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
  else
    EL_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $1")
    IFS=' | ' read A_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$EL_INFO"
    echo "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
}

#check if there is an argument
if [[ $1 ]]
then
    #check if input is numeric
    if [[ ! $1 =~ ^[0-9]+$ ]]
    then
      #check if input is less than 3 characters
      if [ ${#1} -le 3 ]
      then
        #get the element by symbol
        ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
        PRINT_ELEMENT $ELEMENT
      else 
        #get the element by name
        ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
        PRINT_ELEMENT $ELEMENT
      fi
    else

      #get the element by atomic_number
      ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
      PRINT_ELEMENT $ELEMENT
    fi
 

else
    #ask for input
    echo "Please provide an element as an argument."
fi