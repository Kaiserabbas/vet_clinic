/*Queries that provide answers to the questions from all projects.*/

--Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon';
--List the name of all animals born between 2016 and 2019.
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
--List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
--List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
--List name and escape attempts of animals that weigh more than 10.5kg.
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
--Find all animals that are neutered.
SELECT * FROM animals WHERE neutered = true;
--Find all animals not named Gabumon.
SELECT * FROM animals WHERE name != 'Gabumon';
--Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg).
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

--Inside a transaction update the animals table by setting the species column to unspecified. 
-- Start a transaction
BEGIN;
-- Update the 'species' column to 'unspecified'
UPDATE animals SET species = 'unspecified';
-- Verify the change (you can run SELECT statements within the same transaction)
SELECT * FROM animals WHERE species = 'unspecified';
-- Roll back the transaction to revert the changes
ROLLBACK;

--Update the animals table
-- Start a transaction
BEGIN;
-- Update the 'species' column to 'digimon' for animals with names ending in 'mon'
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';
-- Update the 'species' column to 'pokemon' for animals with no species set
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
-- Verify the changes (you can run SELECT statements within the same transaction)
SELECT * FROM animals;
-- Commit the transaction to save the changes
COMMIT;

--Inside a transaction delete all records and rollback
-- Start a transaction
BEGIN;
-- Delete all records in the 'animals' table
DELETE FROM animals;
-- Roll back the transaction to undo the deletion
ROLLBACK;
--  verify if all records in the animals table still exists
SELECT * FROM animals;


-- Create a savepoint for the transaction after deletion.
-- Start a transaction
BEGIN;
-- Delete all animals born after Jan 1st, 2022
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
-- Create a savepoint
SAVEPOINT my_savepoint;
-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1;
-- Rollback to the savepoint
ROLLBACK TO SAVEPOINT my_savepoint;
-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
-- Commit the transaction
COMMIT;

--Write the queries
SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) AS max_escape_attempts
FROM animals
GROUP BY neutered;

SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- Queries  Write queries (using JOIN) to answer the following questions

-- What animals belong to Melody Pond?
SELECT a.name FROM animals a JOIN owners o ON a.owner_id = o.id WHERE o.full_name = 'Melody Pond';

-- List of all animals that are Pokemon (their type is Pokemon).
SELECT a.name FROM animals a JOIN species s ON a.species_id = s.id WHERE s.name = 'Pokemon';

-- List all owners and their animals, including those who don't own any animals.
SELECT o.full_name, COALESCE(array_agg(a.name), '{}'::text[]) FROM owners o LEFT JOIN animals a ON o.id = a.owner_id GROUP BY o.full_name;

-- How many animals are there per species?
SELECT s.name AS species, COUNT(*) AS count FROM animals a JOIN species s ON a.species_id = s.id GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT a.name FROM animals a JOIN owners o ON a.owner_id = o.id JOIN species s ON a.species_id = s.id WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name FROM animals a JOIN owners o ON a.owner_id = o.id WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- Who owns the most animals?
SELECT o.full_name, COUNT(a.id) AS num_animals FROM owners o LEFT JOIN animals a ON o.id = a.owner_id GROUP BY o.full_name ORDER BY num_animals DESC LIMIT 1;


-- Queries for Joint Tables

-- Who was the last animal seen by William Tatcher?
SELECT a.name AS last_animal_seen
FROM animals a
JOIN visits v ON a.id = v.animal_id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id) AS animals_seen
FROM visits v
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, s.name AS specialty
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animal_name
FROM animals a
JOIN visits v ON a.id = v.animal_id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
AND v.visit_date >= '2020-04-01' AND v.visit_date <= '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.name AS animal_name, COUNT(*) AS visit_count
FROM animals a
JOIN visits v ON a.id = v.animal_id
GROUP BY a.name
ORDER BY visit_count DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT a.name AS first_visit_animal
FROM animals a
JOIN visits v ON a.id = v.animal_id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
ORDER BY v.visit_date
LIMIT 1;

-- Details for the most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, v.name AS vet_name, v.age AS vet_age, v.date_of_graduation AS vet_graduation_date, vst.visit_date AS visit_date
FROM visits vst
JOIN animals a ON vst.animal_id = a.id
JOIN vets v ON vst.vet_id = v.id
ORDER BY vst.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS mismatched_visits
FROM visits v
JOIN specializations s ON v.vet_id = s.vet_id
JOIN animals a ON v.animal_id = a.id
WHERE s.species_id <> a.species_id;


-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS suggested_specialty, COUNT(*) AS visit_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
JOIN specializations s ON vt.id = s.vet_id
WHERE vt.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY visit_count DESC
LIMIT 1;

-- The following queries are to check whether it is taking too much time (1 sec = 1000ms can be considered as too much time for database query).
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';
 





