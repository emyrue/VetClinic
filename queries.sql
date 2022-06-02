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

/*Last animal seen by William Thatcher*/
SELECT vets.name, animalsAndVisits.animal_name, animalsAndVisits.date_of_visit FROM 
    (SELECT id, name as animal_name, vet_id, date_of_visit FROM animals 
    INNER JOIN visits
    ON animals.id = animal_id) as animalsAndVisits
    INNER JOIN vets
    ON vet_id = vets.id
    WHERE vet_id = 1
    ORDER BY date_of_visit desc
    LIMIT 1;
/*number of animals seen by Stephanie Mendez*/
SELECT name, COUNT(*) FROM
    (SELECT id, name as animal_name, vet_id, date_of_visit FROM animals 
    INNER JOIN visits
    ON animals.id = animal_id) as animalsAndVisits
    INNER JOIN vets
    ON vet_id = vets.id
    WHERE vet_id = 3
    GROUP BY name;
/*All vets and their specialties*/
SELECT vet_name, name as specialty FROM
    (SELECT name as vet_name, id, specialization_id, vet_id FROM vets
    LEFT JOIN specializations
    ON vets.id = vet_id) as vetsAndSpecialties
    LEFT JOIN species
    ON species.id = specialization_id;
/*All animals that visited Stephanie Mendez between April 1st and August 30th, 2020*/
SELECT animalsAndVisits.animal_name, animalsAndVisits.date_of_visit FROM 
    (SELECT id, name as animal_name, vet_id, date_of_visit FROM animals 
    INNER JOIN visits
    ON animals.id = animal_id) as animalsAndVisits
    INNER JOIN vets
    ON vet_id = vets.id
    WHERE vet_id = 3 AND date_of_visit BETWEEN '2020-04-01' and '2020-08-30';
/*What animal has the most vet visits*/
SELECT name, count as number_of_visits FROM
    (SELECT animal_id, COUNT(*) FROM visits GROUP BY animal_id) as countVisits
    INNER JOIN animals
    ON animals.id = animal_id
    ORDER BY count desc
    LIMIT 1;
/*Maisy Smith's first visit*/
SELECT vets.name, animalsAndVisits.animal_name, animalsAndVisits.date_of_visit FROM 
    (SELECT id, name as animal_name, vet_id, date_of_visit FROM animals 
    INNER JOIN visits
    ON animals.id = animal_id) as animalsAndVisits
    INNER JOIN vets
    ON vet_id = vets.id
    WHERE vet_id = 2
    ORDER BY date_of_visit
    LIMIT 1;
/*Details for most recent visit of each animal*/
SELECT animal_name, visit_date, date_of_birth, escape_attempts, neutered, weight_kg, name as vet_name, age, date_of_graduation FROM
    (SELECT id, animal_name, visit_date, date_of_birth, escape_attempts, neutered, weight_kg, vet_id FROM
    (SELECT id, max as visit_date, animals.name as animal_name, date_of_birth, escape_attempts, neutered, weight_kg FROM
    (SELECT animal_id, MAX(date_of_visit) FROM animals
    INNER JOIN visits
    ON animals.id = animal_id
    GROUP BY animal_id) as recentVisit
    INNER JOIN animals
    ON animals.id = animal_id) as animalInfo
    INNER JOIN visits
    ON visit_date = date_of_visit) as infoWithVetId
    INNER JOIN vets
    ON vet_id = vets.id;
/*Number of non-specialized visits*/
SELECT COUNT(*) as number_of_non_specialized_visits FROM
    (SELECT species_id, animal_id, vet_id as my_vet_id, date_of_visit FROM
    (SELECT species_id, animals.id as animals_id FROM animals
    INNER JOIN species
    ON species.id = species_id) as animal_species
    INNER JOIN visits
    ON visits.animal_id = animals_id) as all_visits
    LEFT JOIN specializations
    ON specializations.vet_id = all_visits.my_vet_id
    WHERE specialization_id != species_id OR specialization_id IS NULL;
/*What species Maisy Smith gets the most*/
SELECT name, count FROM
    (SELECT species_id, COUNT(*) FROM
    (SELECT species_id, animal_id, vet_id as my_vet_id, date_of_visit FROM
    (SELECT species_id, animals.id as animals_id FROM animals
    INNER JOIN species
    ON species.id = species_id) as animal_species
    INNER JOIN visits
    ON visits.animal_id = animals_id
    WHERE vet_id = 2) as maisys_visits
    GROUP BY species_id
    ORDER BY species_id desc
    LIMIT 1) as maximum
    INNER JOIN species
    ON species.id = species_id;
