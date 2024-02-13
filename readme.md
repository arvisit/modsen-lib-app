## Requests to book-service: **TODO** replace port 8081 with 8080 after api-gateway will be added

### Endpoints available for everyone including anonymous users

Get all books

```
curl -i -X GET 'http://localhost:8081/api/v1/books'
```

Get info about book by id, e.g. *db7bb26a-b292-44e1-a814-4dc41f0c899a*

```
curl -i -X GET 'http://localhost:8081/api/v1/books/db7bb26a-b292-44e1-a814-4dc41f0c899a'
```

Get info about book by ISBN, e.g. *978-0-307-36463-1* (10 and 13 digit with hyphens ISBNs are supported only)

```
curl -i -X GET 'http://localhost:8081/api/v1/books/by-isbn/978-0-307-36463-1'
```

## Endpoints available for administrators (users with role 'ADMIN')

**Note!** Below tokens are used as placeholders. To successfully perform requests actual tokens should be provided.
To perform below actions user should authenticate himself via username and password and get a JWT token. This token should be transfered 
within header 'Authorization' as 'Bearer <this-token>':

```
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJuZXdfdXNlckBtYWlsLmNvbSIsImlhdCI6MTcwNzUyMTQ4MiwiZXhwIjoxNzA3NTI1MDgyLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXX0.FE2f8fXkz4MtFz7iq_dvYolcQ3JazrK04NnJIA3OIw7xjgOX7GC5kjnieCi9DZvzuHz0KhCt3NMWTDS0-Fghvg
```

Add info about new book

```
curl -i -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwNzUyMzE4MiwiZXhwIjoxNzA3NTI2NzgyLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIl19.WUf3rIQgHFdVTfM3krhyO3vfhAgSYsL_zpPAXSfmJ8Iv1EZEyWr5hb9ghZSwXBM1pkZyBXh5eIlFmFsVvjvbbA" \
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
     'http://localhost:8081/api/v1/books'
```

Update info about existing book

```
curl -i -X PUT -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwNzUyMzE4MiwiZXhwIjoxNzA3NTI2NzgyLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIl19.WUf3rIQgHFdVTfM3krhyO3vfhAgSYsL_zpPAXSfmJ8Iv1EZEyWr5hb9ghZSwXBM1pkZyBXh5eIlFmFsVvjvbbA" \
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
     'http://localhost:8081/api/v1/books/db7bb26a-b292-44e1-a814-4dc41f0c899a'
```

Delete book

```
curl -i -X DELETE -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwNzUyMzE4MiwiZXhwIjoxNzA3NTI2NzgyLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIl19.WUf3rIQgHFdVTfM3krhyO3vfhAgSYsL_zpPAXSfmJ8Iv1EZEyWr5hb9ghZSwXBM1pkZyBXh5eIlFmFsVvjvbbA" \
     'http://localhost:8081/api/v1/books/db7bb26a-b292-44e1-a814-4dc41f0c899a'
```

## Requests to security-service: **TODO** replace port 8082 with 8080 after api-gateway will be added

### Endpoints available for everyone including anonymous users

Register. To register as a user username, password and repeat password values should be provided in a request body

```
curl -i -X POST -H "Content-Type: application/json" \
    -d '{ 
        "username": "new_user@mail.com", 
        "password": "password", 
        "rePassword": "password" 
     }' \
     'http://localhost:8082/api/v1/users/register/user'
```

Login. To authenticate and get a JWT token username and password should be provided in a request body. JWT token will be 
in response header 'Authorization'

```
curl -i -X POST -H "Content-Type: application/json" \
    -d '{ 
        "username": "new_user@mail.com", 
        "password": "password" 
     }' \
     'http://localhost:8082/api/v1/users/login'
```

**Note!** Pre-saved user credentials:

User with role 'USER'

```
curl -i -X POST -H "Content-Type: application/json" \
    -d '{ 
        "username": "user@mail.com", 
        "password": "user" 
     }' \
     'http://localhost:8082/api/v1/users/login'
```

User with role 'ADMIN'

```
curl -i -X POST -H "Content-Type: application/json" \
    -d '{ 
        "username": "admin@mail.com", 
        "password": "admin" 
     }' \
     'http://localhost:8082/api/v1/users/login'
```

User with role 'SERVICE'

```
curl -i -X POST -H "Content-Type: application/json" \
    -d '{ 
        "username": "service@mail.com", 
        "password": "service" 
     }' \
     'http://localhost:8082/api/v1/users/login'
```

Validate. Utility endpoint to validate provided JWT token. If token is valid then username and list of authorities

```
curl -i -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJuZXdfdXNlckBtYWlsLmNvbSIsImlhdCI6MTcwNzUyMTQ4MiwiZXhwIjoxNzA3NTI1MDgyLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXX0.FE2f8fXkz4MtFz7iq_dvYolcQ3JazrK04NnJIA3OIw7xjgOX7GC5kjnieCi9DZvzuHz0KhCt3NMWTDS0-Fghvg" \
     'http://localhost:8082/api/v1/users/validate'
```

## Requests to library-service: **TODO** replace port 8083 with 8080 after api-gateway will be added

### Endpoints available for authorized users (users with role 'USER')

Get list of available books (also available for administrators)

```
curl -i -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwNzgzNDUyMiwiZXhwIjoxNzA3ODM4MTIyLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIl19.DRuCQuOiVTk2oPGWtiVuwsbwBpHuRGkk-jO_st6_fpfv1z3XX93dyzCAZ8APIQxGD4aUNWzsk03n3uSlMcWBng" \
    'http://localhost:8083/api/v1/books/available'
```

Get list of borrowed books (also available for administrators)

```
curl -i -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwNzgzNDUyMiwiZXhwIjoxNzA3ODM4MTIyLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIl19.DRuCQuOiVTk2oPGWtiVuwsbwBpHuRGkk-jO_st6_fpfv1z3XX93dyzCAZ8APIQxGD4aUNWzsk03n3uSlMcWBng" \
    'http://localhost:8083/api/v1/books/borrowed'
```

Borrow book

```
curl -i -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyQG1haWwuY29tIiwiaWF0IjoxNzA3ODM1NjAxLCJleHAiOjE3MDc4MzkyMDEsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdfQ.qgqgQcBGYD6-7z7hL-HZssj61fNAtp7XDWafBD5Jirg7agRLCvhZeShOlzbFhP5MzRJtowxRuq2_Ugk_RHJoMA" \
    'http://localhost:8083/api/v1/books/available/db7bb26a-b292-44e1-a814-4dc41f0c899a/borrow'
```

### Endpoints available for administrators (users with role 'ADMIN')

Add new book **Note!** Utility endpoint is made for the book-service requests and should not be used for direct requests

```
curl -i -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwNzgzNDUyMiwiZXhwIjoxNzA3ODM4MTIyLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIl19.DRuCQuOiVTk2oPGWtiVuwsbwBpHuRGkk-jO_st6_fpfv1z3XX93dyzCAZ8APIQxGD4aUNWzsk03n3uSlMcWBng" \
    -d '{ 
        "id": "b0cd8da5-3bcf-44b5-85fb-19639f484b89", 
     }' \
     'http://localhost:8081/api/v1/books'
```

Return book

```
curl -i -X PATCH -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwNzgzNDUyMiwiZXhwIjoxNzA3ODM4MTIyLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIl19.DRuCQuOiVTk2oPGWtiVuwsbwBpHuRGkk-jO_st6_fpfv1z3XX93dyzCAZ8APIQxGD4aUNWzsk03n3uSlMcWBng" \
    'http://localhost:8083/api/v1/books/borrowed/db7bb26a-b292-44e1-a814-4dc41f0c899a/return'
```

Get info about borrowed book

```
curl -i -X GET -H "Content-Type: application/json" \
    -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbkBtYWlsLmNvbSIsImlhdCI6MTcwNzgzNDUyMiwiZXhwIjoxNzA3ODM4MTIyLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIl19.DRuCQuOiVTk2oPGWtiVuwsbwBpHuRGkk-jO_st6_fpfv1z3XX93dyzCAZ8APIQxGD4aUNWzsk03n3uSlMcWBng" \
    'http://localhost:8083/api/v1/books/borrowed/db7bb26a-b292-44e1-a814-4dc41f0c899a'
```
