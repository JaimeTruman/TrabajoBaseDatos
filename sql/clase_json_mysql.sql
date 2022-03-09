-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 09-03-2022 a las 16:05:18
-- Versión del servidor: 8.0.27
-- Versión de PHP: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `clase_json_mysql`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `dictionaryfinal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `dictionaryfinal` ()  BEGIN
SET @dictionary= JSON_OBJECT('dictionary',
	(SELECT JSON_ARRAYAGG(JSON_OBJECT(
	'tables',json)) FROM tables));
SELECT @dictionary;
TRUNCATE `dictionary`;
INSERT INTO `dictionary`(`dictionary`)
VALUES(@dictionary);
END$$

DROP PROCEDURE IF EXISTS `tables_cursor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `tables_cursor` (IN `schema_in` VARCHAR(50))  NO SQL
BEGIN
  DECLARE name_schema varchar(64) ;
  DECLARE name_table varchar(64) ;
  DECLARE fin INTEGER DEFAULT 0;
  DECLARE tables_cursor  CURSOR FOR SELECT TABLE_SCHEMA, TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA =schema_in ;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;
  OPEN tables_cursor;
  get_cursor: LOOP
  FETCH tables_cursor INTO name_schema, name_table;
 IF fin = TRUE
	THEN
   	 LEAVE get_cursor;
	END IF;
 SELECT name_schema;
 SELECT name_table;
 SET @fields:= build_tables(name_schema,name_table);
/* SELECT @fields;*/
 SET @table=JSON_OBJECT('schema',name_schema,'name_table',name_table);
 SET @tables=JSON_MERGE(@table,@fields);
 SELECT @tables;
  INSERT INTO `tables`(`json`) VALUES (@tables);
  END LOOP get_cursor;
  CLOSE tables_cursor;  
END$$

--
-- Funciones
--
DROP FUNCTION IF EXISTS `build_tables`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `build_tables` (`name_schema` VARCHAR(64), `name_table` VARCHAR(64)) RETURNS JSON NO SQL
BEGIN                  	 
SET @fields = JSON_OBJECT( 'fields',(SELECT JSON_ARRAYAGG(JSON_OBJECT('column_name', `COLUMN_NAME`, 'is_null', `IS_NULLABLE`, 'data_type',`DATA_TYPE`, 'character_max_lenght',`CHARACTER_MAXIMUM_LENGTH`,'character_octet_lenght', `CHARACTER_OCTET_LENGTH`, 'column_key',`COLUMN_KEY`, 'privileges',`PRIVILEGES`)) FROM information_schema.`COLUMNS` WHERE TABLE_SCHEMA = name_schema AND TABLE_NAME = name_table));
/*SELECT @fields;*/
RETURN @fields;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dictionary`
--

DROP TABLE IF EXISTS `dictionary`;
CREATE TABLE IF NOT EXISTS `dictionary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dictionary` json NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `dictionary`
--

INSERT INTO `dictionary` (`id`, `dictionary`) VALUES
(1, '{\"dictionary\": [{\"tables\": {\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"i_ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"s_ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}], \"schema\": \"unilarge\", \"name_table\": \"advisor\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"building\", \"character_max_lenght\": 15, \"character_octet_lenght\": 15}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"capacity\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"room_number\", \"character_max_lenght\": 7, \"character_octet_lenght\": 7}], \"schema\": \"unilarge\", \"name_table\": \"classroom\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"credits\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"dept_name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"title\", \"character_max_lenght\": 50, \"character_octet_lenght\": 50}], \"schema\": \"unilarge\", \"name_table\": \"course\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"budget\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"building\", \"character_max_lenght\": 15, \"character_octet_lenght\": 15}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"dept_name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}], \"schema\": \"unilarge\", \"name_table\": \"department\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"dept_name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"salary\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"instructor\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"prereq_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}], \"schema\": \"unilarge\", \"name_table\": \"prereq\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"building\", \"character_max_lenght\": 15, \"character_octet_lenght\": 15}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"room_number\", \"character_max_lenght\": 7, \"character_octet_lenght\": 7}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"sec_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"semester\", \"character_max_lenght\": 6, \"character_octet_lenght\": 6}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"time_slot_id\", \"character_max_lenght\": 4, \"character_octet_lenght\": 4}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"year\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"section\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"dept_name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"tot_cred\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"student\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"grade\", \"character_max_lenght\": 2, \"character_octet_lenght\": 2}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"sec_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"semester\", \"character_max_lenght\": 6, \"character_octet_lenght\": 6}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"year\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"takes\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"sec_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"semester\", \"character_max_lenght\": 6, \"character_octet_lenght\": 6}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"year\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"teaches\"}}, {\"tables\": {\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"day\", \"character_max_lenght\": 1, \"character_octet_lenght\": 1}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"end_hr\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"end_min\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"start_hr\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"start_min\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"time_slot_id\", \"character_max_lenght\": 4, \"character_octet_lenght\": 4}], \"schema\": \"unilarge\", \"name_table\": \"time_slot\"}}]}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tables`
--

DROP TABLE IF EXISTS `tables`;
CREATE TABLE IF NOT EXISTS `tables` (
  `id` int NOT NULL AUTO_INCREMENT,
  `json` json NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `tables`
--

INSERT INTO `tables` (`id`, `json`) VALUES
(1, '{\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"i_ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"s_ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}], \"schema\": \"unilarge\", \"name_table\": \"advisor\"}'),
(2, '{\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"building\", \"character_max_lenght\": 15, \"character_octet_lenght\": 15}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"capacity\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"room_number\", \"character_max_lenght\": 7, \"character_octet_lenght\": 7}], \"schema\": \"unilarge\", \"name_table\": \"classroom\"}'),
(3, '{\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"credits\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"dept_name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"title\", \"character_max_lenght\": 50, \"character_octet_lenght\": 50}], \"schema\": \"unilarge\", \"name_table\": \"course\"}'),
(4, '{\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"budget\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"building\", \"character_max_lenght\": 15, \"character_octet_lenght\": 15}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"dept_name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}], \"schema\": \"unilarge\", \"name_table\": \"department\"}'),
(5, '{\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"dept_name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"salary\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"instructor\"}'),
(6, '{\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"prereq_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}], \"schema\": \"unilarge\", \"name_table\": \"prereq\"}'),
(7, '{\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"building\", \"character_max_lenght\": 15, \"character_octet_lenght\": 15}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"room_number\", \"character_max_lenght\": 7, \"character_octet_lenght\": 7}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"sec_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"semester\", \"character_max_lenght\": 6, \"character_octet_lenght\": 6}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"time_slot_id\", \"character_max_lenght\": 4, \"character_octet_lenght\": 4}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"year\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"section\"}'),
(8, '{\"fields\": [{\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"MUL\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"dept_name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"name\", \"character_max_lenght\": 20, \"character_octet_lenght\": 20}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"tot_cred\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"student\"}'),
(9, '{\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"YES\", \"data_type\": \"varchar\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"grade\", \"character_max_lenght\": 2, \"character_octet_lenght\": 2}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"sec_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"semester\", \"character_max_lenght\": 6, \"character_octet_lenght\": 6}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"year\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"takes\"}'),
(10, '{\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"course_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"ID\", \"character_max_lenght\": 5, \"character_octet_lenght\": 5}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"sec_id\", \"character_max_lenght\": 8, \"character_octet_lenght\": 8}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"semester\", \"character_max_lenght\": 6, \"character_octet_lenght\": 6}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"year\", \"character_max_lenght\": null, \"character_octet_lenght\": null}], \"schema\": \"unilarge\", \"name_table\": \"teaches\"}'),
(11, '{\"fields\": [{\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"day\", \"character_max_lenght\": 1, \"character_octet_lenght\": 1}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"end_hr\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"YES\", \"data_type\": \"decimal\", \"column_key\": \"\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"end_min\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"start_hr\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"NO\", \"data_type\": \"decimal\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"start_min\", \"character_max_lenght\": null, \"character_octet_lenght\": null}, {\"is_null\": \"NO\", \"data_type\": \"varchar\", \"column_key\": \"PRI\", \"privileges\": \"select,insert,update,references\", \"column_name\": \"time_slot_id\", \"character_max_lenght\": 4, \"character_octet_lenght\": 4}], \"schema\": \"unilarge\", \"name_table\": \"time_slot\"}');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
