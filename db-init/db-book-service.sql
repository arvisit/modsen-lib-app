SELECT 'CREATE DATABASE "book-service-db"' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '"book-service-db"')\gexec
