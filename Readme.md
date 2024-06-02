# How to?

## Dip version
```bash
cd [dir]
dip provision
```

## Docker compose
```bash
cd [dir]

docker compose down --volumes
docker compose up -d postgres
docker compose run ruby bundle install
docker compose run ruby ruby ./benchmark.rb
docker compose down --volumes
```