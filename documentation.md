# 🚀 Steps to Set Up Your Database with Docker + Postgres

## 📂Project Structure

### Your repo should look like this:

ONLINEBANKINGSYSTEM/
│
├── docker-compose.yml
├── .env
└── Db/
    └── init/
        ├── schema.sql
        ├── triggers.sql
        ├── functions.sql
        └── views.sql

### 📝 .env file

Inside .env:

POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=bankdb

### 📝docker-compose.yml
version: '3.8'

services:
  db:
    image: postgres:15
    container_name: bankdb_postgres
    env_file: .env
    ports:
      - "5432:5432"
    volumes:
      - ./Db/init:/docker-entrypoint-initdb.d   # auto-run SQL files at startup
      - db_data:/var/lib/postgresql/data        # persistent DB data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db_data:

## ▶️Start the Database

### Run from inside your project root:

#### docker compose up -d


#### What happens:

If you don’t already have postgres:15, Docker downloads it.

A container named bankdb_postgres is started.

Postgres looks inside /docker-entrypoint-initdb.d (your Db/init) and executes all .sql files in order.

Your schema, triggers, functions, etc. are created in the new database.

Data is saved in the db_data volume so it persists.

### 🔍 Check That It Works

#### List containers:

##### docker compose ps


#### Check database tables:

##### docker compose exec db psql -U postgres -d bankdb -c "\dt"

## 🛠️ If You Update SQL Files

⚠️ Important: Postgres only runs *.sql in /docker-entrypoint-initdb.d on first creation of the database.

### So if you change schema.sql, you must reset the DB:

#### docker compose down -v   # remove container + volume


#### docker compose up -d     # starts fresh, runs updated SQL files

## 📝 Day-to-Day Commands

### Start database

docker compose up -d


### Stop database

docker compose down


### Reset everything (wipe DB + re-run SQL)

docker compose down -v
docker compose up -d


### Connect to DB shell

docker compose exec db psql -U postgres -d bankdb

## 🔄 Workflow Summary

Put all SQL files inside Db/init/.

Run docker compose up -d.

DB is ready → schema, triggers, procedures, functions auto-loaded.

If you make changes to SQL files → docker compose down -v && docker compose up -d.

Connect with psql or any GUI (like DBeaver/pgAdmin) on localhost:5432.