#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

MAIN_MENU() {

  echo -e "\n## Welcome to the salon ##"
  echo -e "\nWhat can we do for you today ?"

  SERVICES=$($PSQL "SELECT service_id, name FROM services")

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  SERVICE_EXIST=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

if [[ -z $SERVICE_EXIST ]]
then 
  MAIN_MENU "Please select a service from the list :"
  else 

echo "Please enter your phone number :"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat's your name ?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
echo -e "\nAt what time should we schedule the appointment ?"
read SERVICE_TIME

INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
CONFIRMATION_FORMATTED=$(echo $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME | sed 's/^ //')
echo -e "\nI have put you down for a $CONFIRMATION_FORMATTED."
fi  
}

MAIN_MENU
