-- ** in relation to products **

-- 1. What categories of tech products does Magist have?

SELECT *
from product_category_name_translation;

SELECT product_category_name, count(distinct ot.product_id) as product_count
from order_items ot
LEFT JOIN products p 
using (product_id)
where product_category_name in ('eletronicos', 'informatica_acessorios','pcs','telefonia','tablets_impressao_imagem','audio','pc_gamer','consoles_games','telefonia_fixa')
group by  p.product_category_name;

-- to find avg price per category along with product_count
SELECT product_category_name, count(distinct ot.product_id) as product_count, round(avg(ot.price),2) as avg_price
from order_items ot
LEFT JOIN products p 
using (product_id)
where product_category_name in ('eletronicos', 'informatica_acessorios','pcs','telefonia','tablets_impressao_imagem','audio','pc_gamer','consoles_games','telefonia_fixa')
group by  p.product_category_name;

-- 2. How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?

 SELECT
  tech.tech_items_sold,
  total.total_items_sold,
  ROUND(100 * tech.tech_items_sold / total.total_items_sold, 2) AS tech_pct
FROM
  (SELECT COUNT(*) AS tech_items_sold
   FROM order_items oi
   JOIN orders o ON o.order_id = oi.order_id
   JOIN products p ON p.product_id = oi.product_id
   WHERE o.order_status IN ('delivered', 'shipped')
     AND p.product_category_name IN (
       'eletronicos', 'informatica_acessorios', 'pcs', 'telefonia',
       'tablets_impressao_imagem', 'audio', 'pc_gamer',
       'consoles_games', 'telefonia_fixa')
  ) AS tech,
  (SELECT COUNT(*) AS total_items_sold
   FROM order_items oi
   JOIN orders o ON o.order_id = oi.order_id
   WHERE o.order_status IN ('delivered', 'shipped')
  ) AS total;
  
  -- 3.  What’s the average price of the products being sold? (over all)
SELECT round(avg(ot.price),2) as all_items_avg_price
from orders o
join order_items ot
using (order_id) 
-- join products p 
-- using (product_id)
where o.order_status in ('delivered', 'shipped') ;

  -- 3.  What’s the average price of the products being sold? (only tech)
SELECT round(avg(ot.price),2) as tech_item_sold_avg
from orders o
join order_items ot
using (order_id) 
join products p 
using (product_id)
where product_category_name in ('eletronicos', 'informatica_acessorios','pcs','telefonia','tablets_impressao_imagem','audio','pc_gamer','consoles_games','telefonia_fixa') AND 
o.order_status in ('delivered', 'shipped') ;


-- Are expensive tech products popular? * -- nope

SELECT
  CASE
    WHEN oi.price < 100 THEN 'cheap'
    WHEN oi.price <= 500 THEN 'mid'
    ELSE 'expensive'
  END AS price_bracket,
  COUNT(*) AS items_sold
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status IN ('delivered', 'shipped')
  AND p.product_category_name IN ('eletronicos','informatica_acessorios','pcs',
      'telefonia','tablets_impressao_imagem','audio','pc_gamer',
      'consoles_games','telefonia_fixa')
GROUP BY price_bracket;

-- 5. Reviews per category for tech products 
SELECT category, COUNT(*) AS orders, ROUND(AVG(review_score), 2) AS avg_review
FROM (
  SELECT DISTINCT o.order_id, p.product_category_name AS category, r.review_score
  FROM order_reviews r
  JOIN orders o ON o.order_id = r.order_id
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN products p ON p.product_id = oi.product_id
  WHERE  p.product_category_name IN ('eletronicos','informatica_acessorios','pcs',
        'telefonia','tablets_impressao_imagem','audio','pc_gamer',
        'consoles_games','telefonia_fixa') 
    
) t
GROUP BY category; 

-- To find max value and min value in tech_sold 
SELECT MAX(ot.price) as tech_item_sold_max, product_category_name, Min(ot.price) as tech_item_sold_min
from orders o
join order_items ot
using (order_id) 
join products p 
using (product_id)
where product_category_name in ('eletronicos', 'informatica_acessorios','pcs','telefonia','tablets_impressao_imagem','audio','pc_gamer','consoles_games','telefonia_fixa') AND 
o.order_status in ('delivered', 'shipped') 
group by product_category_name
order by tech_item_sold_max  DESC; 

-- orders per month 
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
       COUNT(*) AS orders
FROM orders
GROUP BY order_month
ORDER BY order_month;


-- Query for Histogram 
SELECT FLOOR(LEAST(oi.price, 1000) / 50) * 50 AS price_from,
       COUNT(*) AS items_sold
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status IN ('delivered', 'shipped')
  AND p.product_category_name IN ('eletronicos','informatica_acessorios','pcs',
      'telefonia','tablets_impressao_imagem','audio','pc_gamer',
      'consoles_games','telefonia_fixa')
GROUP BY price_from
ORDER BY price_from;

-- Item sold category 
SELECT t.product_category_name_english AS category, COUNT(*) AS items_sold
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN product_category_name_translation t ON t.product_category_name = p.product_category_name
WHERE o.order_status IN ('delivered', 'shipped')
  AND p.product_category_name IN ('eletronicos','informatica_acessorios','pcs',
      'telefonia','tablets_impressao_imagem','audio','pc_gamer',
      'consoles_games','telefonia_fixa')
GROUP BY t.product_category_name_english
ORDER BY items_sold DESC;