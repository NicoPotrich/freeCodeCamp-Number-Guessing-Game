#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUMBER=$((RANDOM % 1000 + 1))
echo $RANDOM_NUMBER

echo "Enter your username:"
read USERNAME

USER_INFO=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$USERNAME'")

if [[ -z $USER_INFO ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES ('$USERNAME', 0, 10000)")
else
  echo "$USER_INFO" | while IFS="|" read USERNAME GAMES_PLAYED BEST_GAME
  do 
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

echo -e "\nGuess the secret number between 1 and 1000:"
read USER_RANDOM_NUMBER
USER_ATTEMPTS=1

if [[ ! $USER_RANDOM_NUMBER =~ ^[0-9]+$ ]]
then
  echo -e "\nThat is not an integer, guess again:"
else
  while [[ $USER_RANDOM_NUMBER != $RANDOM_NUMBER ]]
  do
    ((USER_ATTEMPTS++))
    if [[ $USER_RANDOM_NUMBER > $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      read USER_RANDOM_NUMBER
    else
      echo "It's higher than that, guess again:"
      read USER_RANDOM_NUMBER
    fi
  done
  echo "You guessed it in $USER_ATTEMPTS tries. The secret number was $RANDOM_NUMBER. Nice job!"
fi

