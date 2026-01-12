CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_name TEXT NOT NULL,
    product TEXT NOT NULL,
    amount NUMERIC(10,2),
    created_at TIMESTAMP DEFAULT NOW()
);
