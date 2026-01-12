INSERT INTO orders (customer_name, product, amount, created_at)
SELECT
    'Cliente ' || i,
    'Produto ' || (i % 10),
    round((random() * 100)::numeric, 2),
    NOW() - (i || ' days')::interval
FROM generate_series(1, 100000) i;
