-- ========Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”========

-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

UPDATE users
	SET created_at = NOW() AND updated_at = NOW()
;

-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы
--    типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
--    Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

ALTER TABLE users MODIFY COLUMN created_at varchar(150); # преобразуем колонку в VARCHAR
ALTER TABLE users MODIFY COLUMN updated_at varchar(150); # преобразуем колонку в VARCHAR

-- Преобразую значения из строки
UPDATE users
	SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
	updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i')
;

-- Обновляю тип данных колонок с VARCHAR на DATETIME
ALTER TABLE users
	MODIFY COLUMN created_at DATETIME,
	MODIFY COLUMN updated_at DATETIME
;

-- Обртно вернуть исходный вид даты не получается, бился весь вечер над тем что бы вернуть к формату 20.10.2017 8:10
UPDATE users
	SET created_at = DATE_FORMAT(created_at, '%d.%m.%Y %H:%i'),
	updated_at = DATE_FORMAT(updated_at, '%d.%m.%Y %H:%i')
;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться
-- самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
-- Однако, нулевые запасы должны выводиться в конце, после всех записей.

SELECT * FROM storehouses_products;

INSERT INTO storehouses_products
	(storehouse_id, product_id, value, created_at, updated_at) VALUES
	(1, 1, 2, now(), now()),
	(2, 2, 1, now(), now()),
	(3, 3, 5, now(), now()),
	(4, 4, 0, now(), now()),
	(5, 5, 4, now(), now()),
	(6, 6, 3, now(), now())
;

SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 9999999999999999999999 ELSE value END;

-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
-- Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT * FROM users WHERE birthday_at RLIKE '^[0-9]{4}-(05|08)-[0-9]{2}';

-- ========Практическое задание теме “Агрегация данных”========

-- 5. (по желанию) Подсчитайте произведение чисел в столбце таблицы

SELECT round(exp(sum(log(id))), 10) from users;

-- ********** ex_01 ***********
-- *** 1. Подсчитайте средний возраст пользователей в таблице users. ***
SELECT ROUND(AVG((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25), 0) AS AVG_Age FROM users;

-- Вариант решения GB
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 0) AS AVG_Age FROM users;




-- ********** ex_02 ***********
-- *** 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.***
-- *** Следует учесть, что необходимы дни недели текущего года, а не года рождения. ***********

-- ******** Подбор решения **********
-- SELECT YEAR(NOW());

-- SELECT CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10)) AS birthday FROM users;

-- SELECT
--     DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10))) AS week_day_of_birthday
-- FROM users;
-- *********************************

-- ***** само РЕШЕНИЕ для ex02 *****
SELECT
    DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10))) AS week_day_of_birthday_in_this_Year,
    COUNT(*) AS amount_of_birthday
FROM
    users
GROUP BY 
    week_day_of_birthday_in_this_Year
ORDER BY
	amount_of_birthday DESC;

-- скрипт для проверки ex_2
-- SELECT
-- 	name,
-- 	birthday_at,
-- 	CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10)) AS date_of_birthday_in_this_Year,
--     DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10))) AS week_day_of_birthday_in_this_Year
-- FROM
--     users
-- ORDER BY
-- 	week_day_of_birthday_in_this_Year;

-- ********** ex_03 ***********
-- *** 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы. ***
CREATE TABLE integers(
    value SERIAL PRIMARY KEY
);

INSERT INTO integers VALUES
    (NULL),
    (NULL),
    (NULL),
    (NULL),
    (NULL),
    (NULL);

-- решение ex_03
SELECT ROUND(exp(SUM(log(value))), 0) AS factorial FROM integers;