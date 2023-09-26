/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id SERIAL PRIMARY KEY,
  name varchar(100),
  date_of_birth date,
  escape_attempts integer,
  neutered boolean,
  weight_kg decimal
);

-- Run this SQL statement to add the 'species' column to the 'animals' table
ALTER TABLE animals
ADD COLUMN species varchar(100);


