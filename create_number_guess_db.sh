#!/bin/bash

# Define the PSQL command for connecting to PostgreSQL
PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"

# Create the number_guess database
$PSQL "CREATE DATABASE number_guess;"

# Connect to the number_guess database and create the users table
psql --username=freecodecamp --dbname=number_guess <<EOF
CREATE TABLE users(
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(22) UNIQUE NOT NULL,
  games_played INT DEFAULT 0,
  best_game INT
);

CREATE TABLE games(
  game_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  guesses INT NOT NULL
);
EOF

echo "Database 'number_guess' and table 'users' created successfully."
