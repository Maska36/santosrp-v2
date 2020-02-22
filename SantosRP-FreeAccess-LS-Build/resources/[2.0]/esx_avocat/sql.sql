INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_avocat','Avocat', 1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_avocat','Avocat', 1)
;
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_avocat', 'Avocat', 1)
;

INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
	('avocat', 'Avocat', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('avocat',0,'recrue','Substitut', 500, '{}', '{}'),
	('avocat',1,'novice','Avocat', 750, '{}', '{}'),
	('avocat',2,'cdisenior','Procureur', 1200, '{}', '{}'),
	('avocat',3,'boss','Patron', 1600, '{}', '{}')
;