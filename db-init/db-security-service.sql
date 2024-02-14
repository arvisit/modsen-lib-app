SELECT 'CREATE DATABASE "security-service-db"' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '"security-service-db"')\gexec
