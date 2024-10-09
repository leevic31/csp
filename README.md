# README

To setup the project using Docker
```
git clone https://github.com/leevic31/csp.git

cd csp

docker-compose up --build && docker-compose run web rails db:migrate && docker-compose run web rails db:seed
```

To setup the project using Codespaces with Docker
```
Create a new codespace on Github

docker-compose up --build && docker-compose run web rails db:migrate && docker-compose run web rails db:seed

```

To setup the project using Codespaces without Docker
```
Create a new codespace on Github

bundle install

rails server

rails db:migrate

rails db:seed
```