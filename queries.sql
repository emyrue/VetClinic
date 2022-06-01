/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon';
SELECT * from animals WHERE date_of_birth BETWEEN '2016-01-01' and '2019-12-31';
SELECT * from animals WHERE neutered = 't' AND escape_attempts < 3;
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;
SELECT * from animals WHERE neutered = 't';
SELECT * from animals WHERE name != 'Gabumon';
SELECT * from animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT species from animals;
ROLLBACK;
SELECT species from animals;
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT species from animals;
COMMIT;
SELECT species from animals;
BEGIN;
DELETE FROM animals;
SELECT * from animals;
ROLLBACK;
SELECT * from animals;
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SELECT * from animals;
SAVEPOINT FIRST;
UPDATE animals SET weight_kg = -1 * weight_kg;
SELECT weight_kg from animals;
ROLLBACK TO FIRST;
SELECT weight_kg from animals;
UPDATE animals SET weight_kg = -1 * weight_kg WHERE weight_kg < 0;
SELECT weight_kg from animals;
COMMIT;
SELECT weight_kg from animals;
SELECT COUNT(*) from animals;
SELECT COUNT(*) from animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) from animals;
SELECT neutered, AVG(escape_attempts) from animals GROUP BY neutered ORDER BY AVG(escape_attempts);
SELECT species, MIN(weight_kg), MAX(weight_kg) from animals GROUP BY species;
SELECT species, AVG(escape_attempts) from animals WHERE date_of_birth BETWEEN '1990-01-01' and '2000-12-31' GROUP BY species;

SELECT * FROM animals INNER JOIN owners ON owner_id = owners.id WHERE owner_id = 4;
SELECT * FROM animals INNER JOIN species ON species_id = species.id WHERE species_id = 1;
SELECT * FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;
SELECT COUNT(*) FROM (SELECT * FROM animals INNER JOIN species ON species_id = species.id) as animalsAndSpecies GROUP BY species_id;
SELECT * FROM
    (SELECT * FROM animals INNER JOIN species ON species_id = species.id) as animalsAndSpecies
    INNER JOIN owners ON owner_id = owners.id
    WHERE owner_id = 2 AND species_id = 2;
SELECT * FROM animals INNER JOIN owners ON owner_id = owners.id WHERE owner_id = 5 AND escape_attempts = 0;
SELECT owner_id, COUNT(*) FROM (SELECT * FROM animals INNER JOIN owners ON owner_id = owners.id) as animalsAndOwners
    GROUP BY owner_id ORDER BY count desc;
