-- select distinct a.* from articles a
-- where a.id IN (
--   select a.id from articles a
--   inner join articles_tags at on at.article_id = a.id
--   inner join tags t on t.id = at.tag_id
--   where a.id IN (
--     SELECT a.id
--     from articles a
--     inner join articles_tags at on at.article_id = a.id
--     inner join tags t on t.id = at.tag_id
--     where t.filter_id = 4
--     order by t.name asc)
--   and t.filter_id = 1
--   ORDER BY t.name desc
-- );
--   
-- select distinct a.* from articles a
-- where a.id in (
-- SELECT a.id
-- from articles a
-- inner join articles_tags at on at.article_id = a.id
-- inner join tags t on t.id = at.tag_id
-- where t.filter_id = 4
-- order by t.name asc
-- );
--   SELECT * 
--     FROM articles a
--     INNER JOIN articles_tags ON articles_tags.article_id = a.id 
--     INNER JOIN tags ON tags.id = articles_tags.tag_id 
--     WHERE tags.filter_id = 1
--     ORDER BY tags.name desc 
--   GROUP BY a.id
--   HAVING count(*) = 1
  
select * from articles a 
-- full outer join articles_criterions ac on a.id = ac.article_id 
-- full outer join criterions c on ac.criterion_id = c.id
-- full outer join criterions cc on ac.criterion_id = cc.id and cc.filter_id = 1
-- full outer join criterions ccc on ac.criterion_id = ccc.id and ccc.filter_id = 5
where a.id in (
select distinct a.id from articles a
inner join articles_criterions ac on a.id = ac.article_id 
inner join criterions c on ac.criterion_id = c.id
where a.id in (
select a.id from articles a 
inner join articles_criterions ac on a.id = ac.article_id 
inner join criterions c on ac.criterion_id = c.id
where c.filter_id = 1
INTERSECT
select a.id from articles a 
inner join articles_criterions ac on a.id = ac.article_id 
inner join criterions c on ac.criterion_id = c.id
where c.filter_id = 5
)
)
;
--inner join criterions cc on ac.criterion_id = cc.id and cc.filter_id = 1
--inner join criterions ccc on ac.criterion_id = ccc.id and ccc.filter_id = 5

--  order by ccc.name asc, cc.name asc 
--   
--   
-- select * from articles a 
-- inner join articles_criterions ac on a.id = ac.article_id 
-- inner join criterions c on ac.criterion_id = c.id
-- where a.name like '%r%';

select distinct a.*, cc.name as ccname from articles a
INNER JOIN articles_criterions ac ON ac.article_id = a.id 
INNER JOIN criterions c ON c.id = ac.criterion_id
inner join criterions cc on ac.criterion_id = cc.id and cc.filter_id = 5
where a.id in (
SELECT a.id FROM articles a
INNER JOIN articles_criterions ac ON ac.article_id = a.id 
INNER JOIN criterions c ON c.id = ac.criterion_id 
WHERE (c.id = 3)
)
order by cc.name desc
;
  
  
select a.* from articles a 
inner join articles_criterions ac on a.id = ac.article_id 
where ac.criterion_id = 1
INTERSECT
select a.id from articles a 
inner join articles_criterions ac on a.id = ac.article_id 
where ac.criterion_id = 3
  
  
  
  select distinct a.*, cc.name as ccname from articles a
   INNER JOIN articles_criterions ac ON ac.article_id = a.id 
   INNER JOIN criterions c ON c.id = ac.criterion_id
   inner join criterions cc on ac.criterion_id = cc.id and cc.filter_id = 5
   where a.id in (
   select a.id from articles a 
   inner join articles_criterions ac on a.id = ac.article_id 
   where ac.criterion_id = 1 
   INTERSECT 
   select a.id from articles a 
   inner join articles_criterions ac on a.id = ac.article_id 
   where ac.criterion_id = 3
   ) order by cc.name asc
  
Привет. Политклуба сегодня не будет, так что напишу здесь.
Предлагаю несколько исправлений:
1. Сортировку по ОДНОЙ из дат сделать отдельным полем, а не фильтром. Так будет правильнее, потому что если дату взять как фильтр, то критериев этого фильтра будет слишком много и они бессмысленные. Да и вообще сущность сильно отличается от остальных. А даты привязать намертво к каждой статье. Тем более, что 3 из них(создания, обновления и посл. коммента) записываются автоматически.
2. Убрать дату "дата описываемых событий".
3. Таким образом сортировку по фильтру оставить только одну. Тем более, что на уровне SQL осуществлять сортировку по двум фильтрам проблематично.
Итого, процесс действия пользователя следующий:
1. Выбираем фильтр Ф1. -> получаем все статьи, отсортированные по именам критериев фильтра Ф1 + все критерии Ф1 слева.
2. Выбираем критерий К1 слева. -> получаем просто все статьи критерия К1.
3. Выбираем фильтр Ф2. -> получаем все статьи критерия К1, отстортированные по именам критериев фильтра Ф2.
4. Выбираем критерий К2 слева. -> получаем просто все статьи пересечения критериев K1 & K2.
…
Менять направление сортировки можно у последнего фильтра, кликнув по нему. 
Сортировать по датам можно на любом пункте.  
  
  
select distinct on(a.id, cc.name) * from articles a
INNER JOIN articles_criterions ac ON ac.article_id = a.id 
INNER JOIN criterions c ON c.id = ac.criterion_id
full outer join criterions cc on cc.id = ac.criterion_id and cc.filter_id = 4
where a.id in (
  SELECT articles.id from articles
)
order by cc.name  
;
  
  
select * from articles a
INNER JOIN articles_criterions ac ON ac.article_id = a.id 
INNER JOIN criterions c ON c.id = ac.criterion_id
where c.filter_id = 5
order by a.id
;

select * from articles a
INNER JOIN articles_criterions ac ON ac.article_id = a.id 
INNER JOIN criterions c ON c.id = ac.criterion_id
where a.id in (
  select a.id from articles a
) and c.filter_id = 4 
order by c.name desc
;
  
  
  
select a.id from articles a 
inner join articles_criterions ac on a.id = ac.article_id 
where ac.criterion_id = 8
INTERSECT
select a.id from articles a 
inner join articles_criterions ac on a.id = ac.article_id 
where ac.criterion_id = 4;
  

select a.id from articles a
inner join articles_criterions ac on a.id = ac.article_id
inner join articles_criterions acc on a.id = acc.article_id
where ac.criterion_id = 4 and acc.criterion_id = 8;
  
  
  
  
  
  