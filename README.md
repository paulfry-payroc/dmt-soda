# Soda Core MVP

MVP of Soda Core.

## Contents

1. Installation
2. How-to Run
3. How-to Use
4. Use Cases

---

## 1. Installation

* Run `make install` to install Soda core.
* Populate the generated `.env` file, env vars are listed below:

    <details>

    <summary>Expand to see env vars</summary>

  * `SNOWFLAKE_USER` - Snowflake username
  * `SNOWFLAKE_PASSWORD` - Snowflake password
  * `SNOWFLAKE_ACCOUNT` - Snowflake account name
  * `SNOWFLAKE_REGION` - Snowflake region
  * `SNOWFLAKE_ROLE` - Snowflake role
  * `SNOWFLAKE_WAREHOUSE` - Snowflake warehouse
  * `SNOWFLAKE_DATABASE` - Snowflake database
  * `SNOWFLAKE_SCHEMA` - Snowflake schema

    </details>

---

## 2. How-to Run

* Enter `make run` to launch your local Airflow/astro project.

---

## 3. How-to Use

---

## Use Cases

1. Airflow: test data quality after ingestion and transformation in your pipeline.
2. CI/CD: test data quality during CI/CD development.
3. Track DQ over time: import your dbt tests into Soda to facilitate issue investigation and track dataset health over time.
