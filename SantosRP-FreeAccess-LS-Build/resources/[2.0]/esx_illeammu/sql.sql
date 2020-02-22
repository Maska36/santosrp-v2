INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_illammu','Armurier Illégal',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_illammu','Armurier Illégal',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_illammu', 'Armurier Illégal', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('illammu', 'Armurier Illégal', 1);

--
-- Déchargement des données de la table `jobs_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('illammu', 0, 'soldato', 'Soldat', 1000, '{}', '{}'),
('illammu', 1, 'capo', 'Assassin', 1200, '{}', '{}'),
('illammu', 2, 'consigliere', 'Sergent', 1500, '{}', '{}'),
('illammu', 3, 'righthand', 'Bras-droit', 2100, '{}', '{}'),
('illammu', 4, 'boss', 'Patron', 1, '{}', '{}');