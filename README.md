# Speer Twitter Clone Assignment

## Setup Instructions

Required tools:
-   Docker
-   Docker Compose

### Init
```
$ git clone https://github.com/swawrzyn/speer-twitter.git
$ cd speer-twitter
$ docker-compose build
```

### Prep DB
```
$ docker-compose run --rm app sh -c "rails db:create && rails db:migrate"
```

If you would like to seed the db:
```
$ docker-compose run --rm app sh -c "rails db:seed" 
```

### Run Tests
```
$ docker-compose run --rm app rspec
```

### Run Server
```
$ docker-compose up
```

After docker-compose up, you can access the server from http://localhost:3000 and API documentation at http://localhost:3000/api/docs


## Issues?

If you have any problems running the code or getting something to work. Please send me an email at swawrzyn (at) gmail.com.