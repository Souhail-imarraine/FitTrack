-- *********** create database ********** -- 
-- **************************************

CREATE DATABASE FitnessManagement;
USE FitnessManagement;

-- ********** create Table members **********--
-- ******************************************

create TABLE members(
	member_id int(11) auto_increment primary KEY,
    first_name varchar(50) NOT NULL,
	last_name varchar(50)NOT NULL,
    gender enum('male','female') NOT NULL,
    data_of_birth date,
    phone_number varchar(15) NOT NULL,
    email varchar(100),
    UNIQUE(email)
);

-- ************ create Table memberships ************** -- 
-- ****************************************************


CREATE TABLE memberships (
memberships_id int(11) auto_increment primary KEY,
member_id int(11) NOT NULL,
room_id int(11),
FOREIGN KEY (member_id) REFERENCES members(member_id),
FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- ************ create Table rooms *************-- 
-- *********************************************


create TABLE rooms(
	room_id int(11) primary key auto_increment, 
    room_number varchar(10),
    room_type enum('Cardio','Weights','Studio'),
    capacity int(11)
);

-- ************ create Table departments ************** --
-- ****************************************************


CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- ************ create Table trainers *************-- 
-- ************************************************


CREATE TABLE trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ************ create Table appointments ************** --
-- *****************************************************


CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    trainer_id INT NOT NULL,
    member_id INT NOT NULL,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- ************ create Table workout_plans ************** --
-- ******************************************************

CREATE TABLE workout_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    trainer_id INT NOT NULL,
    instructions VARCHAR(255),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);

-- *******************************************************************
INSERT INTO members (first_name, last_name, gender, data_of_birth, phone_number, email) VALUES
('John', 'Doe', 'male', '1990-01-15', '1234567890', 'john.doe@example.com'),
('Jane', 'Smith', 'female', '1985-05-20', '0987654321', 'jane.smith@example.com');
--*********************************************************************
INSERT INTO rooms (room_number, room_type, capacity) VALUES
('101', 'Cardio', 20),
('102', 'Weights', 15),
('103', 'Studio', 25);
--*********************************************************************
INSERT INTO departments (department_name, location) VALUES
('Fitness', 'Main Building'),
('Yoga', 'Annex Building'),
('Strength Training', 'Main Building');
--*********************************************************************
INSERT INTO trainers (first_name, last_name, specialization, department_id) VALUES
('Alice', 'Johnson', 'Cardio Training', 1),
('Bob', 'Williams', 'Strength Training', 3),
('Cathy', 'Brown', 'Yoga', 2);
--*********************************************************************
INSERT INTO memberships (memberships_id, member_id, room_id) VALUES
(1, 1, 1),
(2, 2, 2);  



-- Opérations CRUD : Insérer un nouveau membre --

INSERT INTO members (`first_name`, `last_name`, `gender`, `data_of_birth`,`phone_number`) VALUES ('Alex', 'Johnson','male','1990-07-15','1234567890');

-- Instruction SELECT : Récupérer tous les départements Récupérez tous les départements avec leurs emplacements --

SELECT * FROM departments;

-- Clause ORDER BY : Trier les membres par date de naissance
-- Listez tous les membres, triés par date de naissance dans l'ordre croissant.

select * FROM members order by data_of_birth;

-- Filtrer les membres uniques par sexe (DISTINCT)
-- Récupérez tous les sexes des membres enregistrés, sans doublons.


select DISTINCT gender from members;

-- Clause LIMIT : Obtenir les 3 premiers entraîneurs
-- Récupérez les trois premiers entraîneurs dans la table des entraîneurs.

SELECT * FROM trainers limit 3;

-- Clause WHERE : Membres nés après 2000
-- Récupérez les informations des membres nés après l'année 2000.


SELECT * FROM members where data_of_birth > '2000-01-01';


-- Opérateurs Logiques : Entraîneurs dans des départements spécifiques
-- Récupérez les entraîneurs des départements "Musculation" et "Cardio".


SELECT * FROM trainers t JOIN departments d ON t.department_id = d.department_id 
WHERE d.department_name = 'Musculation' OR d.department_name = 'Cardio';


-- Opérateurs Spéciaux : Vérifier des plages de dates
-- Listez les abonnements entre le 1er décembre et le 7 décembre 2024.

SELECT * FROM memberships WHERE start_date BETWEEN '2024-12-1' AND '2024-12-7';

-- Fonctions d'Agrégation : Nombre total de rendez-vous
-- Comptez le nombre total de rendez-vous d'entraînement enregistrés.

SELECT count(appointment_id) FROM appointments;

-- Expressions Conditionnelles : Nommer les catégories d'âge des membres
-- Ajoutez une colonne catégorisant les membres en "Junior", "Adulte", ou "Senior" selon leur âge.

SELECT *, case  
	when year(current_date()) - year(data_of_birth)  < 18 
    then 'Junior'
    when year(current_date()) - year(data_of_birth)  between 18 and 30 
    then 'Adulte'
    ELSE 'Senior'
END AS age
FROM members;

-- COUNT avec GROUP BY : Nombre d'entraîneurs par département
-- Comptez le nombre d'entraîneurs dans chaque département.

SELECT COUNT(trainer_id) FROM trainers group by department_id;

-- AVG : Âge moyen des membres
-- Calculez l'âge moyen des membres.

SELECT AVG(year(current_date()) - year(data_of_birth)) FROM members;


-- MAX : Dernier rendez-vous
-- Trouvez la date et l'heure du dernier rendez-vous enregistré.

SELECT  MAX(appointment_date) `appointment_date`, max(appointment_time) `appointment_time` FROM appointments ;

-- SUM : Total des abonnements par salle
-- Calculez le total des abonnements pour chaque salle d'entraînement.

SELECT COUNT(memberships_id) AS abonnement , room_id FROM memberships group by room_id;

-- Contraintes : Vérifier les membres sans e-mail
-- Récupérez tous les membres dont le champ email est vide.

SELECT * FROM members where email is null;

-- Jointure : Liste des rendez-vous avec noms des entraîneurs et membres
-- Récupérez les rendez-vous avec les noms des entraîneurs et des membres.

SELECT 
    a.appointment_id, 
    a.appointment_date, 
    a.appointment_time, 
    t.first_name AS trainer_first_name, 
    t.last_name AS trainer_last_name, 
    m.first_name AS member_first_name, 
    m.last_name AS member_last_name
FROM 
    appointments a
JOIN 
    trainers t ON a.trainer_id = t.trainer_id
JOIN 
    members m ON a.member_id = m.member_id;

-- DELETE : Supprimer les rendez-vous avant 2024
-- Supprimez tous les rendez-vous programmés avant 2024.

SET SQL_SAFE_UPDATES = 0;
DELETE FROM 
    appointments
WHERE 
    appointment_date < '2024-01-01';

-- UPDATE : Modifier un département
-- Changez le nom du département "Musculation" en "Force et Conditionnement".

SET SQL_SAFE_UPDATES = 0;
UPDATE 
    departments
SET 
    department_name = 'Force et Conditionnement'
WHERE 
    department_name = 'Musculation';



-- Clause HAVING : Membres par sexe avec au moins 2 entrées
-- Listez les genres ayant au moins deux membres.

SELECT 
    gender, 
    COUNT(*) AS member_count
FROM 
    members
GROUP BY 
    gender
HAVING 
    COUNT(*) >= 2;


-- Créer une vue : Abonnements actifs
-- Créez une vue listant tous les abonnements en cours.

CREATE VIEW active_memberships AS
SELECT 
    m.memberships_id, 
    m.member_id, 
    m.room_id, 
    m.start_date
FROM 
    memberships m
WHERE 
    start_date >= CURDATE();
