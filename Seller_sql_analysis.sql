-- in relations to selleer 
-- How many months of data are included in the magist database?

SELECT MAX(order_purchase_timestamp) AS LAST_MONTH,
	   MIN(order_purchase_timestamp) AS FIRST_MONTH, 
TIMESTAMPDIFF(MONTH,MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) 
AS TOTAL_NUMBER_OF_MONTHS
FROM orders;

-- How many sellers are there? 
SELECT count(*) as seller_count
from sellers; -- 3095

-- How many Tech sellers are there? 
SELECT count(distinct seller_id) as seller_count
from orders o  
join order_items oi 
using (order_id)
join products p 
using (product_id)
where product_category_name in ('eletronicos', 'informatica_acessorios','pcs','telefonia','tablets_impressao_imagem','audio','pc_gamer','consoles_games','telefonia_fixa')  
;

-- how many items in a category. 

SELECT product_category_name, count(distinct ot.seller_id) as seller_count
from order_items ot
JOIN products p 
using (product_id)
where product_category_name in ('eletronicos', 'informatica_acessorios','pcs','telefonia','tablets_impressao_imagem','audio','pc_gamer','consoles_games','telefonia_fixa')
group by  p.product_category_name; -- by category 

/* informatica_acessorios		287
eletronicos						149
telefonia						149
consoles_games					82
telefonia_fixa					49
audio							36
pcs								9
tablets_impressao_imagem		6
pc_gamer						2*/

-- What percentage of overall sellers are Tech sellers?
 SELECT
  tech.tech_items_seller,
  total.total_items_seller,
  ROUND(100 * tech.tech_items_seller / total.total_items_seller, 2 ) as tech_pct
FROM
  (SELECT COUNT( distinct oi.seller_id) AS tech_items_seller
   FROM order_items oi
   JOIN orders o ON o.order_id = oi.order_id
   JOIN products p ON p.product_id = oi.product_id
   WHERE p.product_category_name IN (
       'eletronicos', 'informatica_acessorios', 'pcs', 'telefonia',
       'tablets_impressao_imagem', 'audio', 'pc_gamer',
       'consoles_games', 'telefonia_fixa')
  ) AS tech,
  (SELECT COUNT(distinct oi.seller_id) AS total_items_seller
   FROM order_items oi
   JOIN orders o ON o.order_id = oi.order_id
  ) AS total;

  -- What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
SELECT round(SUM( oi.price),2) AS total_amt_seller,
        round(sum(CASE WHEN p.product_category_name IN ('eletronicos','informatica_acessorios','pcs','telefonia','tablets_impressao_imagem','audio','pc_gamer','consoles_games','telefonia_fixa') then oi.price 
          ELSE 0
          END), 2) as total_amt_tech_seller
FROM order_items oi
JOIN orders o using(order_id)
JOIN products p using(product_id)
WHERE o.order_status IN ('delivered', 'shipped');

-- Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
-- Sellers counted regardless of order status; money counted only for delivered and shipped orders
SELECT
  ROUND(SUM(CASE WHEN o.order_status IN ('delivered','shipped') THEN oi.price ELSE 0 END)
        / COUNT(DISTINCT oi.seller_id) / 25, 2) AS avg_monthly_all,
  ROUND(SUM(CASE WHEN o.order_status IN ('delivered','shipped')
                  AND p.product_category_name IN ('eletronicos','informatica_acessorios','pcs',
                      'telefonia','tablets_impressao_imagem','audio','pc_gamer',
                      'consoles_games','telefonia_fixa') THEN oi.price ELSE 0 END)
        / COUNT(DISTINCT CASE WHEN p.product_category_name IN ('eletronicos','informatica_acessorios','pcs',
                      'telefonia','tablets_impressao_imagem','audio','pc_gamer',
                      'consoles_games','telefonia_fixa') THEN oi.seller_id END)
        / 25, 2) AS avg_monthly_tech
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id;


-- what percentage of tech seller are there who have sold an tech item and have been active between Apr 2017 - Mar 2018

SELECT
  tech.tech_sellers,
  total.total_sellers,
  ROUND(100 * tech.tech_sellers / total.total_sellers, 2) AS tech_pct
FROM
  (SELECT COUNT(DISTINCT oi.seller_id) AS tech_sellers
   FROM order_items oi
   JOIN orders o ON o.order_id = oi.order_id
   JOIN products p ON p.product_id = oi.product_id
   WHERE o.order_status IN ('delivered', 'shipped')
     AND o.order_purchase_timestamp >= '2017-04-01'
	AND o.order_purchase_timestamp <  '2018-04-01'
     AND p.product_category_name IN ('eletronicos','informatica_acessorios','pcs',
         'telefonia','tablets_impressao_imagem','audio','pc_gamer',
         'consoles_games','telefonia_fixa')
  ) AS tech,
  (SELECT COUNT(DISTINCT oi.seller_id) AS total_sellers
   FROM order_items oi
   JOIN orders o ON o.order_id = oi.order_id
   WHERE o.order_status IN ('delivered', 'shipped')
    AND o.order_purchase_timestamp >= '2017-04-01'
	AND o.order_purchase_timestamp <  '2018-04-01'
  ) AS total;
  
  -- only tech sellers 
SELECT COUNT(*) AS only_tech_sellers
FROM (
  SELECT oi.seller_id
  FROM order_items oi
  JOIN products p ON p.product_id = oi.product_id
  GROUP BY oi.seller_id
  HAVING SUM(p.product_category_name IN ('eletronicos','informatica_acessorios','pcs',
        'telefonia','tablets_impressao_imagem','audio','pc_gamer',
        'consoles_games','telefonia_fixa')) = COUNT(*)
) t;
  


