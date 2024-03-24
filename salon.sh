#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

SERVICES=$($PSQL "select service_id, name from services order by 1")

declare -a SERVICE_DICT

echo $SERVICES
for SERVICE in $SERVICES 
do
  SERVICE_ID=$(echo $SERVICE | cut -d"|" -f1)
  SERVICE_NAME=$(echo $SERVICE | cut -d"|" -f2)
  SERVICE_DICT[$SERVICE_ID]="$SERVICE_NAME"
  echo "Service #$SERVICE_ID: ${SERVICE_DICT[$SERVICE_ID]}"
done

function showServices()
{
  for SERVICE_ID in "${!SERVICE_DICT[@]}"
  do
    echo "${SERVICE_ID}) ${SERVICE_DICT[$SERVICE_ID]}"
  done
}

function getCustomerData()
{
  $PSQL "select customer_id, name from customers where phone = '$CUSTOMER_PHONE'"
}

function createCustomer()
{
  $PSQL "insert into customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')" >/dev/null
  $PSQL "select customer_id, name from customers where phone = '$CUSTOMER_PHONE'"
}

function createAppointment()
{
  $PSQL "insert into appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')" >/dev/null
}

SELECTED_SERVICE=""

while [ "$SELECTED_SERVICE" == "" ]
do
  showServices
  echo 'Enter service_id: '
  read SERVICE_ID_SELECTED
  SELECTED_SERVICE=${SERVICE_DICT[$SERVICE_ID_SELECTED]}
done

#echo "Selected service #$SERVICE_ID_SELECTED: ${SERVICE_DICT[$SERVICE_ID_SELECTED]}"

echo 'Enter phone number: '
read CUSTOMER_PHONE

CUSTOMER_DATA=$(getCustomerData)

#echo "Customer data: $CUSTOMER_DATA"
if [ "$CUSTOMER_DATA" == "" ]
then
  echo 'Enter name: '
  read CUSTOMER_NAME
  CUSTOMER_DATA=$(createCustomer)
fi

#echo "Customer data#2: $CUSTOMER_DATA"
CUSTOMER_ID=$(echo $CUSTOMER_DATA | cut -d"|" -f1)
CUSTOMER_NAME=$(echo $CUSTOMER_DATA | cut -d"|" -f2)

echo 'Enter time: '
read SERVICE_TIME

createAppointment

echo "I have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
