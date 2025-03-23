-- Insert a test user with bcrypt encrypted password ('password')
INSERT INTO users (name, email, password, role) 
VALUES ('Test User', 'test@example.com', '$2a$10$ywj0bnIiZjYuiTGThY7RD.S0rIoRWd7/zKXbA2UUHNI.ZBD1Id5uy', 'ADMIN'); 