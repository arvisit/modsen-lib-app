# Library App

Test task microservices REST application that imitates a library and provides an API for anonymous users to view info about books in the catalog, for authorized users to view lists of books which are available, borrowed and to borrow available ones, for authorized administrators to manage books catalog, i.e. perform CRUD operations, change borrowed books status to available, view info about particular borrowed book. When a new book is added to the catalog it automatically becomes available to borrow.

## Contents

+ [Project structure](#project-structure)
    + [Submodules](#submodules)
+ [Technology stack](#technology-stack)
    + [Backend](#backend)
    + [Database](#database)
    + [Testing](#testing)
    + [Documentation](#documentation)
    + [Containerization](#containerization)
    + [Version control system](#version-control-system)
    + [Build tool](#build-tool)
+ [Installation](#installation)
    + [Prerequisites](#prerequisites)
    + [Actual installation](#actual-installation)
+ [Web documentation](#web-documentation)
+ [Usage](#usage)
    + [Introduction](#introduction)
    + [Book service](#book-service)
    + [Security service](#security-service)
    + [Library service](#library-service)

## Project structure

Project consists of modules located in separate GitHub repositories attached to the current repository as submodules which also are parts of the Maven parent project to make it easier to import the whole project into an IDE.

### Submodules

+ [Api gateway](https://github.com/arvisit/modsen-api-gateway) - service to provide a single entrypoint to API
+ [Book service](https://github.com/arvisit/modsen-book-service) - service to provide access to book info catalog
+ [Config server](https://github.com/arvisit/modsen-config-server) - service to provide configuration for the rest services depending on an active profile
+ [Configs](https://github.com/arvisit/modsen-configs) - GitHub repository as a projects configs storage used by Config server
+ [Discovery server](https://github.com/arvisit/modsen-discovery-server) - service to automate another services discovery
+ [Exception handling starter](https://github.com/arvisit/modsen-exception-handling-starter) - Spring Boot Starter to provide autoconfiguration of Beans which are supposed to handle basic and security exception in a Spring Boot Application, uses its GitHub repository as a Maven repository to download artifact
+ [Inner filter starter](https://github.com/arvisit/modsen-inner-filter-starter) - Spring Boot Starter to provide autoconfiguration of Beans which are supposed to secure an application by interacting with Security service, uses its GitHub repository as a Maven repository to download artifact
+ [Library service](https://github.com/arvisit/modsen-library-service) - service to provide access to available/borrowed books info and ability to borrow available books for authorized users
+ [Security service](https://github.com/arvisit/modsen-security-service) - service to provide security for the entire Library App via JWT tokens

## Technology stack

### Backend

+ Java 17
+ Spring Boot 3
+ Spring Data JPA
+ Liquibase
+ Spring Security
+ Spring Cloud OpenFeign
+ Spring Cloud Netflix Eureka
+ Spring Cloud Config Server
+ Spring Cloud Gateway

### Database

+ PostgreSQL

### Testing

+ JUnit 5
+ Spring Boot Test
+ TestContainers
+ WireMock

### Documentation

+ Swagger (OpenAPI 3.0)

### Containerization

+ Docker
+ docker compose

### Version control system

+ git

### Build tool

+ Apache Maven

## Installation

### Prerequisites

+ ssh
+ git
+ Docker
+ docker compose

### Actual installation

Run the following commands to clone the repository together with submodules, build docker images and run containers:

```
git clone --recurse-submodules git@github.com:arvisit/modsen-lib-app.git
cd modsen-lib-app
docker compose up --build
```

It will take some time to download all dependencies and build images. Be patient.

## Web documentation

**Note!** Below links will be available after running application via `docker-compose.yml`

+ [Aggregated documentation](http://localhost:8080/webjars/swagger-ui/index.html)

Separate pages:
+ [Security service](http://localhost:8082/modsen-security-service/swagger-ui/index.html)
+ [Library service](http://localhost:8083/modsen-library-service/swagger-ui/index.html)
+ [Book service](http://localhost:8081/modsen-book-service/swagger-ui/index.html)

## Usage

### Introduction

Usage of the Library App endpoints can be performed via following `curl` requests or via [Swagger UI](http://localhost:8080/webjars/swagger-ui/index.html)

**Note!** Some of the bellow requests contain placeholder `<TOKEN>` for the JWT token. To successfully perform these requests actual token should be provided. To obtain a token, user should [authenticate](#security-service) himself via username and password. This token should be transfered within header 'Authorization' as 'Bearer <TOKEN>' like this:

```
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJuZXdfdXNlckBtYWlsLmNvbSIsImlhdCI6MTcwNzUyMTQ4MiwiZXhwIjoxNzA3NTI1MDgyLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXX0.FE2f8fXkz4MtFz7iq_dvYolcQ3JazrK04NnJIA3OIw7xjgOX7GC5kjnieCi9DZvzuHz0KhCt3NMWTDS0-Fghvg
```

### Book service

#### Endpoints available for everyone including anonymous users

Get list of all books

```
curl -i -X GET 'http://localhost:8080/api/v1/books'
```

Get info about book by id, e.g. *db7bb26a-b292-44e1-a814-4dc41f0c899a*

```
curl -i -X GET 'http://localhost:8080/api/v1/books/db7bb26a-b292-44e1-a814-4dc41f0c899a'
```

Get info about book by ISBN, e.g. *978-0-307-36463-1* (10 and 13 digit with hyphens ISBNs are supported only)

```
curl -i -X GET 'http://localhost:8080/api/v1/books/by-isbn/978-0-307-36463-1'
```

#### Endpoints available for administrators (users with role 'ADMIN')

Add info about new book

```
curl -i -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
    -d '{ 
        "isbn": "978-5-4461-0997-5", 
        "title": "Modern Java in Action", 
        "genre": 
            {
                "id": "1",
                "name": "Computer Science"
            }, 
        "description": "Book about Java lambdas, streams, Module System.",
        "author": "Raoul-Gabriel Urma" 
     }' \
     'http://localhost:8080/api/v1/books'
```

Update info about existing book

```
curl -i -X PUT -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
    -d '{ 
        "isbn": "978-0-306-40615-7", 
        "title": "The Shadow of the Wind", 
        "genre": 
            {
                "id": "2",
                "name": "Adventure"
            }, 
        "description": "New description.",
        "author": "Carlos Ruiz Zafón" 
     }' \
     'http://localhost:8080/api/v1/books/db7bb26a-b292-44e1-a814-4dc41f0c899a'
```

Delete book

```
curl -i -X DELETE -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
     'http://localhost:8080/api/v1/books/db7bb26a-b292-44e1-a814-4dc41f0c899a'
```

### Security service

#### Endpoints available for everyone including anonymous users

Register. To register as a user, username, password and repeat password values should be provided in a request body

```
curl -i -X POST -H "Content-Type: application/json" \
    -d '{ 
        "username": "new_user@mail.com", 
        "password": "password", 
        "rePassword": "password" 
     }' \
     'http://localhost:8080/api/v1/users/register/user'
```

Login. To authenticate and get a JWT token, username and password should be provided in a request body. JWT token will be in response header 'Authorization'

```
curl -i -X POST -H "Content-Type: application/json" \
    -d '{ 
        "username": "new_user@mail.com", 
        "password": "password" 
     }' \
     'http://localhost:8080/api/v1/users/login'
```

**Note!** Pre-saved credentials:

User with role 'USER'

```
curl -i -X POST -H "Content-Type: application/json" \
    -d '{ 
        "username": "user@mail.com", 
        "password": "user" 
     }' \
     'http://localhost:8080/api/v1/users/login'
```

User with role 'ADMIN'

```
curl -i -X POST -H "Content-Type: application/json" \
    -d '{ 
        "username": "admin@mail.com", 
        "password": "admin" 
     }' \
     'http://localhost:8080/api/v1/users/login'
```

Validate. Utility endpoint to validate provided JWT token. If token is valid then response with username and list of authorities

```
curl -i -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
     'http://localhost:8080/api/v1/users/validate'
```

### Library service

#### Endpoints available for authorized users (users with role 'USER')

Get list of available books (also available for administrators)

```
curl -i -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
    'http://localhost:8080/api/v1/library/books/available'
```

Get list of borrowed books (also available for administrators)

```
curl -i -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
    'http://localhost:8080/api/v1/library/books/borrowed'
```

Borrow book

```
curl -i -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
    'http://localhost:8080/api/v1/library/books/available/db7bb26a-b292-44e1-a814-4dc41f0c899a/borrow'
```

#### Endpoints available for administrators (users with role 'ADMIN')

Add new book

**Note!** Utility endpoint is made for the Book service requests and should not be used for the direct requests

```
curl -i -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
    -d '{ 
        "id": "b0cd8da5-3bcf-44b5-85fb-19639f484b89"
     }' \
     'http://localhost:8080/api/v1/library/books'
```

Return book

```
curl -i -X PATCH -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
    'http://localhost:8080/api/v1/library/books/borrowed/db7bb26a-b292-44e1-a814-4dc41f0c899a/return'
```

Get info about borrowed book

```
curl -i -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN>" \
    'http://localhost:8080/api/v1/library/books/borrowed/db7bb26a-b292-44e1-a814-4dc41f0c899a'
```
