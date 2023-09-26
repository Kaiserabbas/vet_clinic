/* Database schema to keep the structure of entire database. */
-- Creating table for animals
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


-- Starting multiple tables 

-- Creating table for owners
CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    age INTEGER
);

-- Creating table for species
CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);


-- Modify animals table

-- 1. Set 'id' as autoincremented PRIMARY KEY
ALTER TABLE animals
ADD COLUMN id SERIAL PRIMARY KEY;

-- 2. Remove the 'species' column
ALTER TABLE animals
DROP COLUMN species;

-- 3. Add 'species_id' as a foreign key referencing 'species' table
ALTER TABLE animals
ADD COLUMN species_id INTEGER REFERENCES species(id);

-- 4. Add 'owner_id' as a foreign key referencing 'owners' table
ALTER TABLE animals
ADD COLUMN owner_id INTEGER REFERENCES owners(id);


