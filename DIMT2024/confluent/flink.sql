SELECT * FROM orders;

CREATE TABLE sales_per_minute (
 window_start TIMESTAMP(3),
 window_end   TIMESTAMP(3),
 nr_of_orders BIGINT
);

INSERT INTO sales_per_minute
SELECT window_start, window_end, COUNT(DISTINCT order_id) as nr_of_orders
  FROM TABLE(
    TUMBLE(TABLE orders, DESCRIPTOR($rowtime), INTERVAL '1' MINUTE))
  GROUP BY window_start, window_end;

SELECT id, name, brand
FROM (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY $rowtime DESC) AS row_num
  FROM `shoes`)
WHERE row_num = 1

CREATE TABLE deduplicated_shoes(
    id STRING,
    brand STRING,
    name STRING,
    sale_price INT,
    rating DOUBLE,
    PRIMARY KEY (id) NOT ENFORCED
);

INSERT INTO deduplicated_shoes(
    SELECT id, brand, name, sale_price, rating
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY id ORDER BY $rowtime DESC) AS row_num
        FROM `shoes`)
    WHERE row_num = 1
);

SELECT
    c.`$rowtime`,
    c.product_id,
    s.name,
    s.brand
FROM
    clickstream c
    INNER JOIN deduplicated_shoes s ON c.product_id = s.id;

CREATE TABLE inactive_users(
    user_id STRING,
    start_tstamp TIMESTAMP(3),
    end_tstamp TIMESTAMP(3),
    avgViewTime INT
);

INSERT INTO inactive_users
SELECT *
FROM clickstream
    MATCH_RECOGNIZE (
        PARTITION BY user_id
        ORDER BY `$rowtime`
        MEASURES
            FIRST(A.`$rowtime`) AS start_tstamp,
            LAST(A.`$rowtime`) AS end_tstamp,
            AVG(A.view_time) AS avgViewTime
        ONE ROW PER MATCH
        AFTER MATCH SKIP PAST LAST ROW
        PATTERN (A+ B)
        DEFINE
            A AS AVG(A.view_time) < 30
    ) MR;

CREATE TABLE inactive_customers_enriched(
    user_id STRING,
    avgViewTime INT,
    first_name STRING,
    last_name STRING,
    email STRING
);
INSERT INTO inactive_customers_enriched
  SELECT
    u.user_id,
    u.avgViewTime,
    c.first_name,
    c.last_name,
    c.email
  FROM
    inactive_users u
    INNER JOIN customers c ON u.user_id = c.id;