# How to benchmark?

## Dip version https://github.com/bibendi/dip
```bash
cd [dir] #activerecord, sequel, etc
dip provision
```

## Docker compose
```bash
cd [dir] #activerecord, sequel, etc

docker compose down --volumes
docker compose up -d postgres
docker compose run ruby bundle install
docker compose run ruby ruby ./benchmark.rb
docker compose down --volumes
```
