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


-- Create a Table called vets.
CREATE TABLE vets (
    id serial PRIMARY KEY,
    name varchar(255),
    age integer,
    date_of_graduation date
);

-- Create a "join table" called specializations to handle the many-to-many relationship
CREATE TABLE specializations (
    vet_id INT,
    species_id INT,
    PRIMARY KEY (vet_id, species_id),
    FOREIGN KEY (vet_id) REFERENCES vets (id),
    FOREIGN KEY (species_id) REFERENCES species (id)
);


-- Create a "join table" called visits to handle the many-to-many relationship between the animals and vets tables
CREATE TABLE visits (
    visit_id SERIAL PRIMARY KEY,
    vet_id INT,
    animal_id INT,
    visit_date DATE,
    FOREIGN KEY (vet_id) REFERENCES vets (id),
    FOREIGN KEY (animal_id) REFERENCES animals (id)
);
