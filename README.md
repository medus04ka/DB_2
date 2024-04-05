# Лабораторная работа #2
## Задание.

По варианту, выданному преподавателем, составить и выполнить запросы к базе данных "Учебный процесс".

Команда для подключения к базе данных ucheb:
```
psql -h pg -d ucheb
```
Отчёт по лабораторной работе должен содержать:
```
Текст задания.
Реализацию запросов на SQL.
Выводы по работе.
```
Темы для подготовки к защите лабораторной работы:
```
SQL
Соединение таблиц
Подзапросы
Представления
Последовательности
```
## Вариант: 1276

### Составить запросы на языке SQL (пункты 1-7).

1. Сделать запрос для получения атрибутов из указанных таблиц, применив фильтры по указанным условиям:
```
Н_ТИПЫ_ВЕДОМОСТЕЙ, Н_ВЕДОМОСТИ.
Вывести атрибуты: Н_ТИПЫ_ВЕДОМОСТЕЙ.ИД, Н_ВЕДОМОСТИ.ЧЛВК_ИД.
Фильтры (AND):
a) Н_ТИПЫ_ВЕДОМОСТЕЙ.НАИМЕНОВАНИЕ > Экзаменационный лист.
b) Н_ВЕДОМОСТИ.ИД < 1250972.
c) Н_ВЕДОМОСТИ.ИД = 1250972.
Вид соединения: INNER JOIN.
```
2. Сделать запрос для получения атрибутов из указанных таблиц, применив фильтры по указанным условиям:
```
Таблицы: Н_ЛЮДИ, Н_ОБУЧЕНИЯ, Н_УЧЕНИКИ.
Вывести атрибуты: Н_ЛЮДИ.ФАМИЛИЯ, Н_ОБУЧЕНИЯ.ЧЛВК_ИД, Н_УЧЕНИКИ.ГРУППА.
Фильтры: (AND)
a) Н_ЛЮДИ.ОТЧЕСТВО = Владимирович.
b) Н_ОБУЧЕНИЯ.НЗК < 999080.
Вид соединения: INNER JOIN.
```
3. Составить запрос, который ответит на вопрос, есть ли среди студентов группы 3102 люди без ИНН. 
4. Найти группы, в которых в 2011 году было менее 5 обучающихся студентов на ФКТИУ. \
Для реализации использовать подзапрос. 
5. Выведите таблицу со средним возрастом студентов во всех группах (Группа, Средний возраст), где средний возраст меньше среднего возраста в группе 1101. 
6. Получить список студентов, отчисленных после первого сентября 2012 года с очной или заочной формы обучения (специальность: Программная инженерия). 
В результат включить:
```
номер группы;
номер, фамилию, имя и отчество студента;
номер пункта приказа;
```
Для реализации использовать соединение таблиц. \
7. Вывести список людей, не являющихся или не являвшихся студентами ФКТИУ (данные, о которых отсутствуют в таблице Н_УЧЕНИКИ). В запросе нельзя использовать DISTINCT.
