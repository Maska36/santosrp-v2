CREATE TABLE `orgs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `orgs` (`name`, `label`) VALUES
('vagos', 'Vagos'),
('ballas', 'Ballas'),
('famillies', 'Famillies'),
('santos', 'SantosRP');

CREATE TABLE `org_grades` (
  `id` int(11) NOT NULL,
  `org_name` varchar(255) DEFAULT NULL,
  `gradeorg` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `org_grades` (`id`, `org_name`, `gradeorg`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'santos', 0, 'santos', 'Citoyen', 200, '{}', '{}'),
(2, 'famillies', 0, 'soldato', 'Ptite-Frappe', 1500, '{}', '{}'),
(3, 'famillies', 1, 'capo', 'Capo', 1800, '{}', '{}'),
(4, 'famillies', 2, 'consigliere', 'Capo-Chef', 2100, '{}', '{}'),
(5, 'famillies', 3, 'boss', 'Parrain', 2700, '{}', '{}'),
(6, 'ballas', 0, 'soldato', 'Ptite-Frappe', 1500, '{}', '{}'),
(7, 'ballas', 1, 'capo', 'Capo', 1800, '{}', '{}'),
(8, 'ballas', 2, 'consigliere', 'Capo-Chef', 2100, '{}', '{}'),
(9, 'ballas', 3, 'boss', 'Patron', 2700, '{}', '{}'),
(10, 'vagos', 0, 'soldato', 'Ptite-Frappe', 1500, '{}', '{}'),
(11, 'vagos', 1, 'capo', 'Capo', 1800, '{}', '{}'),
(12, 'vagos', 2, 'consigliere', 'Chef', 2100, '{}', '{}'),
(13, 'vagos', 3, 'boss', 'Patron', 2700, '{}', '{}');


ALTER TABLE `orgs`
  ADD PRIMARY KEY (`name`);

ALTER TABLE `org_grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

  `org` varchar(255) COLLATE utf8mb4_bin DEFAULT 'santos',
  `org_gradeorg` int(11) DEFAULT '0',





INSERT INTO `addon_account` (name, label, shared) VALUES 
  ('society_bloods','bloods',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
  ('society_bloods','Bloods',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
  ('society_bloods', 'Bloods', 1)
;

INSERT INTO `addon_account` (name, label, shared) VALUES 
  ('society_sexion','sexion',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
  ('society_sexion','Sexion d\'assaut',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
  ('society_sexion', 'Sexion d\'assaut', 1)
;

INSERT INTO `orgs` (`name`, `label`) VALUES
('bloods', 'Bloods', 1);

INSERT INTO `org_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('bloods', 0, 'soldato', 'Ptite-Frappe', 1500, '{}', '{}'),
('bloods', 1, 'capo', 'Capo', 1800, '{}', '{}'),
('bloods', 2, 'consigliere', 'Chef', 2100, '{}', '{}'),
('bloods', 3, 'boss', 'Patron', 2700, '{}', '{}');

-----------------------------------------------------------------------------------------------------------------------------

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES 
  ('society_yakuza','yakuza', 1)
;

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES 
  ('society_yakuza','Yakuza', 1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES 
  ('society_yakuza', 'Yakuza', 1)
;

INSERT INTO `orgs` (`name`, `label`) VALUES
('yakuza', 'Yakuza');

INSERT INTO `org_grades` (`id`, `org_name`, `org_grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(23, 'yakuza', 0, 'soldato', 'Ptite-Frappe', 1500, '{}', '{}'),
(24, 'yakuza', 1, 'capo', 'Capo', 1800, '{}', '{}'),
(25, 'yakuza', 2, 'consigliere', 'Chef', 2100, '{}', '{}'),
(26, 'yakuza', 3, 'boss', 'Patron', 2700, '{}', '{}');