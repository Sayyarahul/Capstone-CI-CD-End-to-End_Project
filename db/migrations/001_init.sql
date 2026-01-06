CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO users (name)
SELECT 'Initial User'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE name='Initial User');
