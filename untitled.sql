select distinct a.* from articles a
where a.id IN (
  select a.id from articles a
  inner join articles_tags at on at.article_id = a.id
  inner join tags t on t.id = at.tag_id
  where a.id IN (
    SELECT a.id
    from articles a
    inner join articles_tags at on at.article_id = a.id
    inner join tags t on t.id = at.tag_id
    where t.filter_id = 4
    order by t.name asc)
  and t.filter_id = 1
  ORDER BY t.name desc
);
  
select distinct a.* from articles a
where a.id in (
SELECT a.id
from articles a
inner join articles_tags at on at.article_id = a.id
inner join tags t on t.id = at.tag_id
where t.filter_id = 4
order by t.name asc
);
  SELECT * 
    FROM "articles" a
    INNER JOIN "articles_tags" ON "articles_tags"."article_id" = a."id" 
    INNER JOIN "tags" ON "tags"."id" = "articles_tags"."tag_id" 
    WHERE "tags"."filter_id" = 1
    ORDER BY "tags"."name" desc 
  GROUP BY a."id"
  HAVING count(*) = 1
  
select distinct a.*, ccc.name, cc.name from articles a
inner join articles_criterions ac on a.id = ac.article_id 
inner join criterions c on ac.criterion_id = c.id
full outer join criterions cc on ac.criterion_id = cc.id and cc.filter_id = 1
full outer join criterions ccc on ac.criterion_id = ccc.id and ccc.filter_id = 4
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
order by ccc.name asc, cc.name asc
;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  