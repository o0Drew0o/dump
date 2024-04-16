#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"


MAIN_MENU() {
  if [[ $1 ]]; then
    echo -e "\n$1"
  fi
  
  echo -e "\n1) Cut \n2) Pedicure\n3) Manicure\n4) Dyeing"
  read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED -lt 1 || $SERVICE_ID_SELECTED -gt 4 ]]; then
    MAIN_MENU "Please enter a valid number."
  else 
    GET_CUSTOMER_DATA
    SERVICE_NAME=$($PSQL"SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    SCHEDULE_APPOINTMENT
  fi
}

GET_CUSTOMER_DATA() {
  # ask for phone
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  # check if it exists
  CUSTOMER_NAME=$($PSQL"SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]; then
    # if not, ask name
    echo -e "\nI don't have that number registered... May I have your name?"
    read CUSTOMER_NAME
    # add customer
    ADD_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL"SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
}

SCHEDULE_APPOINTMENT() {
  echo -e "\nAt what time?"
  read SERVICE_TIME
  SCHEDULE_RESULT=$($PSQL"INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU