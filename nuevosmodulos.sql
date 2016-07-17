CREATE TABLE `gespro`.`usuarios_monitor` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NULL,
  `apellido_paterno` VARCHAR(50) NULL,
  `apellido_materno` VARCHAR(50) NULL,
  `email` VARCHAR(50) NOT NULL,
  `password` VARCHAR(250) NOT NULL,
  `activo` BIT NULL,
  PRIMARY KEY (`id`));