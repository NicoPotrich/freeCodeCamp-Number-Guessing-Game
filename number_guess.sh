#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUMBER=$((RANDOM % 1000 + 1))
echo $RANDOM_NUMBER

echo -e "\nEnter your username:"
read USERNAME

USER_INFO=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$USERNAME'")

if [[ -z $USER_INFO ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES ('$USERNAME', 1, 1000)")
else
  echo "$USER_INFO" | while IFS="|" read USERNAME GAMES_PLAYED BEST_GAME
  do 
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    echo "GAMES_PLAYED: $GAMES_PLAYED, BEST_GAME: $BEST_GAME, USERNAME: $USERNAME"

    UPDATE_GAMES=$(
                    $PSQL "UPDATE users 
                           SET games_played = $((GAMES_PLAYED + 1)) 
                           WHERE username = '$USERNAME'"
                  )
  done
fi

echo -e "\nGuess the secret number between 1 and 1000:"
read USER_RANDOM_NUMBER
USER_ATTEMPTS=1

while [[ ! $USER_RANDOM_NUMBER =~ ^[0-9]+$ ]]
do
  echo -e "\nThat is not an integer, guess again:"
  read USER_RANDOM_NUMBER
done

while [[ $USER_RANDOM_NUMBER -ne $RANDOM_NUMBER ]]
do
  ((USER_ATTEMPTS++))
  if [[ $USER_RANDOM_NUMBER -gt $RANDOM_NUMBER ]]
  then
    echo -e "\nIt's lower than that, guess again:"
  else
    echo -e "\nIt's higher than that, guess again:"
  fi
  read USER_RANDOM_NUMBER
done
  
echo -e "\nYou guessed it in $USER_ATTEMPTS tries. The secret number was $RANDOM_NUMBER. Nice job!"

if [[ $USER_ATTEMPTS -lt $BEST_GAME ]]
then
  UPDATE_GAMES=$(
                  $PSQL "UPDATE users 
                        SET best_game = $USER_ATTEMPTS 
                        WHERE username = '$USERNAME'"
                )
fi

