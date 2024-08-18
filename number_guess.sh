#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUMBER=$((RANDOM % 1000 + 1))

echo "Enter your username:"
read USERNAME

USERS=$($PSQL "SELECT name FROM users WHERE username='$USERNAME'")
