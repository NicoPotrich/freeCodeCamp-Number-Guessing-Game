#!/bin/bash

# Define the PSQL command for connecting to PostgreSQL
PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"

# Create the number_guess database
$PSQL "CREATE DATABASE number_guess;"

# Connect to the number_guess database and create the users table
psql --username=freecodecamp --dbname=number_guess <<EOF
CREATE TABLE users (
    username VARCHAR(22) PRIMARY KEY,
    games_played INT NOT NULL,
    best_game INT NOT NULL
);
EOF

echo "Database 'number_guess' and table 'users' created successfully."
