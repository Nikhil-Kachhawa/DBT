# DBT Learning Notes (Databricks + dbt)

## Project Setup

### Environment Setup

* Install Python
* Verify Git installation
* Install uv package manager

```bash
git --version
pip install uv
```

### Create and Activate Virtual Environment

```bash
uv init
uv sync
.\.venv\Scripts\activate
```

### Install dbt

```bash
uv add dbt-core dbt-databricks
pip freeze > requirements.txt
dbt --version
```

---

## Databricks Connection Setup

Configure:

* Host Name
* HTTP Path
* Personal Access Token
* Catalog
* Schema
* Threads

Verify connection:

```bash
dbt debug
```

---

## Medallion Architecture

Created project structure following the Medallion Architecture:

```text
models/
├── sources/
├── bronze/
├── silver/
└── gold/
```

---

## Sources

Created source definitions using `sources.yml`.

Example:

```yaml
sources:
  - name: source
    database: dbt_poc
    schema: source

    tables:
      - name: fact_sales
      - name: fact_returns
      - name: dim_date
      - name: dim_product
      - name: dim_customer
```

Usage:

```sql
SELECT *
FROM {{ source('source', 'fact_sales') }}
```

---

## Materializations

Configured models using:

### Project-Level Config

```yaml
models:
  dbt_poc:
    bronze:
      +materialized: table
```

### Properties-Level Config

```yaml
models:
  - name: bronze_sales
    config:
      materialized: table
```

### Model-Level Config

```sql
{{ config(materialized='view') }}
```

### Configuration Priority

```text
Model Config
    ↓
Properties Config
    ↓
dbt_project.yml
```

---

## Custom Schemas

Implemented schema separation:

```yaml
models:
  dbt_poc:
    bronze:
      schema: bronze

    silver:
      schema: silver

    gold:
      schema: gold
```

---

## Custom Macro

Created custom schema generation macro.

```sql
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}

{%- endmacro %}
```

---

## Node Selection

Run individual models:

```bash
dbt run --select bronze_date
```

Run multiple models:

```bash
dbt run --select "bronze_date bronze_store"
```

Run folder:

```bash
dbt run --select models/bronze/
```

---

## Data Testing

### Generic Tests

Implemented:

* unique
* not_null
* accepted_values

Example:

```yaml
columns:
  - name: sales_id
    data_tests:
      - unique
      - not_null
```

### Severity Configuration

```yaml
config:
  severity: warn
```

---

## Singular Tests

Created custom SQL-based tests.

Example:

```sql
SELECT *
FROM {{ ref('bronze_sales') }}
WHERE gross_amount < 0
```

---

## ref() Function

Used `ref()` to create dependencies between models.

```sql
SELECT *
FROM {{ ref('bronze_sales') }}
```

---

## Custom Generic Tests

Created reusable generic tests.

```sql
{% test generic_non_negative(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} < 0

{% endtest %}
```

Usage:

```yaml
columns:
  - name: gross_amount
    data_tests:
      - generic_non_negative
```

---

## Seeds

Used dbt Seeds to manage static lookup data.

Example:

```csv
country_code,country_name
DE,Germany
IN,India
US,United States
CA,Canada
```

Load seed:

```bash
dbt seed
```

Configure schema:

```yaml
seeds:
  dbt_poc:
    +schema: bronze
```

---

## Analyses

Used the `analyses/` folder to store reusable SQL investigations and exploratory queries that are not materialized as models.

---

## Jinja

Used Jinja templating to add programming capabilities on top of SQL.

Examples:

```sql
{{ source('source', 'fact_sales') }}

{{ ref('bronze_sales') }}

{{ config(materialized='table') }}
```

---

## Commands Practiced

```bash
dbt debug
dbt run
dbt test
dbt seed
dbt clean
```

---

## Skills Practiced

* dbt Core
* Databricks
* SQL
* Jinja
* Data Testing
* Macros
* Data Modeling
* Medallion Architecture
* Data Lineage
* Data Quality Validation
* Schema Management
* Seed Management

```
```
