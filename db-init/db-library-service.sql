SELECT 'CREATE DATABASE "library-service-db"' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '"library-service-db"')\gexec
