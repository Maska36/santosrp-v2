INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_pcmaker','Vendeur Informatique', 1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_pcmaker','Vendeur Informatique', 1)
;
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_pcmaker', 'Vendeur Informatique', 1)
;

INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
	('pcmaker', 'Informaticien', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('pcmaker',0,'recrue','Intérimaire', 500, '{"tshirt_1":59,"tshirt_2":0,"torso_1":12,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('pcmaker',1,'novice','Vendeur', 750, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('pcmaker',2,'cdisenior','Vendeur confirmé', 1200, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	('pcmaker',3,'boss','Patron', 1600,'{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}','{"tshirt_1":15,"tshirt_2":0,"torso_1":14,"torso_2":15,"shoes_1":12,"shoes_2":0,"pants_1":9, "pants_2":5, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}')
;

INSERT INTO `items` (`name`, `label`) VALUES
	('circuit', 'Circuit Informatique'),
	('cm', 'Carte Mere'),
	('cpu', 'Processeur'),
	('gpu', 'Carte Graphique')
;

INSERT INTO `vehicle_categories`(`name`, `label`) VALUES ("importexport", "Import/Export");
INSERT INTO `vehicles`(`name`, `model`, `price`, `category`) VALUES ("Lamborghini", "lp770r", "4470000", "importexport");
INSERT INTO `vehicles`(`name`, `model`, `price`, `category`) VALUES ("Audi RS6", "rs6", "1610000", "importexport");

INSERT INTO `vehicles`(`name`, `model`, `price`, `category`) VALUES ("Bugatti Vision GT", "nero2", "15830000", "importexport");
INSERT INTO `vehicles`(`name`, `model`, `price`, `category`) VALUES ("Raptor F-150", "RAPTOR150", "1610000", "importexport");


INSERT INTO `vehicles`(`name`, `model`, `price`, `category`) VALUES ("Lamborghini 2", "sc18", "8610000", "importexport");