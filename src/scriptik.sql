-- 1

SELECT
    "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД",
    "Н_ВЕДОМОСТИ"."ЧЛВК_ИД"
FROM
    "Н_ТИПЫ_ВЕДОМОСТЕЙ"
        INNER JOIN "Н_ВЕДОМОСТИ" ON "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД" = "Н_ВЕДОМОСТИ"."ТВ_ИД"
WHERE
        "Н_ТИПЫ_ВЕДОМОСТЕЙ"."НАИМЕНОВАНИЕ" > 'Экзаменационный лист'
  AND "Н_ВЕДОМОСТИ"."ИД" <= 1250972;

-- 2

SELECT
    "Н_ЛЮДИ"."ФАМИЛИЯ",
    "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД",
    "Н_УЧЕНИКИ"."ГРУППА"
FROM
    "Н_ЛЮДИ"
        JOIN "Н_ОБУЧЕНИЯ" ON "Н_ОБУЧЕНИЯ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД"
        JOIN "Н_УЧЕНИКИ" ON "Н_УЧЕНИКИ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД"
WHERE
        "Н_ЛЮДИ"."ОТЧЕСТВО" = 'Владимирович'
  AND "Н_ОБУЧЕНИЯ"."НЗК" < '999080';

-- 3

SELECT
        COUNT(*) > 0 AS "Есть студенты без ИНН"
FROM
    "Н_УЧЕНИКИ"
        INNER JOIN "Н_ЛЮДИ" ON "Н_УЧЕНИКИ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД"
WHERE
        "Н_УЧЕНИКИ"."ГРУППА" = '3102'
  AND ("Н_ЛЮДИ"."ИНН" IS NULL OR "Н_ЛЮДИ"."ИНН" = '');

--4     ФИЛЬТРАЦИЯ МЕЖДУ ДЖОИНОМ И ВХЕРЕ

SELECT "43КТиУ"."ГРУППА", "43КТиУ"."КОЛИЧЕСТВО"
FROM (
         SELECT "Н_УЧЕНИКИ"."ГРУППА", count("Н_УЧЕНИКИ"."ИД") AS "КОЛИЧЕСТВО"
         FROM "Н_УЧЕНИКИ"
                  JOIN "Н_ПЛАНЫ" ON "Н_УЧЕНИКИ"."ПЛАН_ИД" = "Н_ПЛАНЫ"."ИД"
                  JOIN "Н_ОТДЕЛЫ" ON "Н_ОТДЕЛЫ"."ИД" = "Н_ПЛАНЫ"."ОТД_ИД"
         WHERE "Н_ПЛАНЫ"."УЧЕБНЫЙ_ГОД" = '2010/2011'
           AND "Н_ОТДЕЛЫ"."КОРОТКОЕ_ИМЯ" = 'КТиУ'
         GROUP BY "Н_УЧЕНИКИ"."ГРУППА"
     ) AS "43КТиУ"
WHERE "43КТиУ"."КОЛИЧЕСТВО" < 5;


-- 5 поменять дату

SELECT "Н_УЧЕНИКИ"."ГРУППА",
   AVG(date_part('year', age(COALESCE("Н_ЛЮДИ"."ДАТА_СМЕРТИ", CURRENT_DATE), "Н_ЛЮДИ"."ДАТА_РОЖДЕНИЯ"))) AS avg_age
FROM "Н_ЛЮДИ"
JOIN "Н_УЧЕНИКИ" ON "Н_УЧЕНИКИ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД"
GROUP BY "Н_УЧЕНИКИ"."ГРУППА"
HAVING AVG(date_part('year', age(COALESCE("Н_ЛЮДИ"."ДАТА_СМЕРТИ", CURRENT_DATE), "Н_ЛЮДИ"."ДАТА_РОЖДЕНИЯ"))) < (
SELECT AVG(date_part('year', age(COALESCE("Н_ЛЮДИ"."ДАТА_СМЕРТИ", CURRENT_DATE), "Н_ЛЮДИ"."ДАТА_РОЖДЕНИЯ")))
FROM "Н_ЛЮДИ"
JOIN "Н_УЧЕНИКИ" ON "Н_УЧЕНИКИ"."ЧЛВК_ИД" = "Н_ЛЮДИ"."ИД"
WHERE "Н_УЧЕНИКИ"."ГРУППА" = '1101'
);

-- 6

SELECT "ВНЕШ_УЧЕНИКИ"."ГРУППА",
       "ВНЕШ_УЧЕНИКИ"."ИД",
       "Н_ЛЮДИ"."ФАМИЛИЯ",
       "Н_ЛЮДИ"."ИМЯ",
       "Н_ЛЮДИ"."ОТЧЕСТВО",
       "ВНЕШ_УЧЕНИКИ"."П_ПРКОК_ИД"
FROM "Н_УЧЕНИКИ" "ВНЕШ_УЧЕНИКИ"
         JOIN "Н_ЛЮДИ" ON "Н_ЛЮДИ"."ИД" = "ВНЕШ_УЧЕНИКИ"."ЧЛВК_ИД"
WHERE EXISTS (
    SELECT *
    FROM "Н_УЧЕНИКИ" "ВНУТР_УЧЕНИКИ"
    WHERE "ВНУТР_УЧЕНИКИ"."ПРИЗНАК" = 'отчисл'
      AND "ВНУТР_УЧЕНИКИ"."СОСТОЯНИЕ" = 'утвержден'
      AND "ВНУТР_УЧЕНИКИ"."ИД" = "ВНЕШ_УЧЕНИКИ"."ИД"
      AND DATE("ВНУТР_УЧЕНИКИ"."КОНЕЦ") < '2012-09-01'
)
  AND EXISTS (
    SELECT *
    FROM "Н_ПЛАНЫ"
             JOIN "Н_ФОРМЫ_ОБУЧЕНИЯ" ON "Н_ПЛАНЫ"."ФО_ИД" = "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИД"
    WHERE "ВНЕШ_УЧЕНИКИ"."ПЛАН_ИД" = "Н_ПЛАНЫ"."ИД"
      AND ("Н_ФОРМЫ_ОБУЧЕНИЯ"."НАИМЕНОВАНИЕ" = 'Заочная' OR "Н_ФОРМЫ_ОБУЧЕНИЯ"."НАИМЕНОВАНИЕ" = 'Очная')
)
  AND EXISTS (
    SELECT *
    FROM "Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ"
             JOIN "Н_НАПР_СПЕЦ" ON "Н_НАПР_СПЕЦ"."ИД" = "Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ"."НС_ИД"
    WHERE "ВНЕШ_УЧЕНИКИ"."ВИД_ОБУЧ_ИД" = "Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ"."ИД"
      AND "Н_НАПР_СПЕЦ"."НАИМЕНОВАНИЕ" = 'Программная инженерия'
);


-- 7

SELECT ЛюдиШки."ИД",
       ЛюдиШки."ФАМИЛИЯ",
       ЛюдиШки."ИМЯ",
       ЛюдиШки."ОТЧЕСТВО"
FROM "Н_ЛЮДИ" AS ЛюдиШки
WHERE NOT EXISTS (
    SELECT *
    FROM "Н_УЧЕНИКИ"
             JOIN "Н_ПЛАНЫ" ON "Н_УЧЕНИКИ"."ПЛАН_ИД" = "Н_ПЛАНЫ"."ИД"
             JOIN "Н_ОТДЕЛЫ" ON "Н_ПЛАНЫ"."ОТД_ИД" = "Н_ОТДЕЛЫ"."ИД"
        AND "Н_ОТДЕЛЫ"."КОРОТКОЕ_ИМЯ" = 'КТиУ'
    WHERE "Н_УЧЕНИКИ"."ЧЛВК_ИД" = ЛюдиШки."ИД"
);



-- ВЫВЕСТИ ТИПЫ ВЕДОМОСТЕЙ ВСЕ И ДЛЯ КАЖДОЙ ЧТОБ ВЫВОДИЛИСЬ ВСЕ ОЦЕНКИ КОТОРЫЕ ЕСТЬ

SELECT "Н_ТИПЫ_ВЕДОМОСТЕЙ"."НАИМЕНОВАНИЕ", "Н_ВЕДОМОСТИ"."ОЦЕНКА"
    FROM "Н_ТИПЫ_ВЕДОМОСТЕЙ"
INNER JOIN "Н_ВЕДОМОСТИ" on "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД" = "Н_ВЕДОМОСТИ"."ТВ_ИД"

