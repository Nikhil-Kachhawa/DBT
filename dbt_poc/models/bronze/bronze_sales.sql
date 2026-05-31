{# SELECT * FROM dbt_poc.source.fact_sales #}

SELECT 
    * 
FROM
    {{ source('source', 'fact_sales') }}