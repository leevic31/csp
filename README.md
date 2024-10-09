# README

To setup the project using Docker

```
git clone https://github.com/leevic31/csp.git

cd csp

docker-compose up --build && docker-compose run web rails db:migrate && docker-compose run web rails db:seed
```