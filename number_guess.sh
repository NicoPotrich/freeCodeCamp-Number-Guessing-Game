#!/bin/bash

# Variable to run PostgreSQL commands
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate a random number between 1 and 1000
RANDOM_NUMBER=$((RANDOM % 1000 + 1))
echo $RANDOM_NUMBER

# Prompt the user to enter their username
echo -e "\nEnter your username:"
read USERNAME

# Query the database to check if the username exists and retrieve user data
USER_INFO=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$USERNAME'")

# If the user is new (not found in the database)
if [[ -z $USER_INFO ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  # Insert the new user into the database with default values
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES ('$USERNAME', 1, 1000)")
else
  # If the user exists, parse the user data
  echo "$USER_INFO" | while IFS="|" read USERNAME GAMES_PLAYED BEST_GAME
  do 
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

    # Update the number of games played by the user
    UPDATE_GAMES=$(
                    $PSQL "UPDATE users 
                           SET games_played = $((GAMES_PLAYED + 1)) 
                           WHERE username = '$USERNAME'"
                  )
  done
fi

# Prompt the user to guess the number
echo -e "\nGuess the secret number between 1 and 1000:"
read USER_RANDOM_NUMBER
USER_ATTEMPTS=1 # Initialize the number of attempts

# Validate the input to ensure it's an integer
while [[ ! $USER_RANDOM_NUMBER =~ ^[0-9]+$ ]]
do
  echo -e "\nThat is not an integer, guess again:"
  read USER_RANDOM_NUMBER
done

# Loop until the user guesses the correct number
while [[ $USER_RANDOM_NUMBER -ne $RANDOM_NUMBER ]]
do
  ((USER_ATTEMPTS++)) # Increment the number of attempts
  if [[ $USER_RANDOM_NUMBER -gt $RANDOM_NUMBER ]]
  then
    echo -e "\nIt's lower than that, guess again:"
  else
    echo -e "\nIt's higher than that, guess again:"
  fi
  # Read the next guess
  read USER_RANDOM_NUMBER
done
  
# Congratulate the user when they guess the correct number
echo -e "\nYou guessed it in $USER_ATTEMPTS tries. The secret number was $RANDOM_NUMBER. Nice job!"

# Update the user's best game if the current attempts are fewer
if [[ $USER_ATTEMPTS -lt $BEST_GAME ]]
then
  UPDATE_GAMES=$(
                  $PSQL "UPDATE users 
                        SET best_game = $USER_ATTEMPTS 
                        WHERE username = '$USERNAME'"
                )
fi

