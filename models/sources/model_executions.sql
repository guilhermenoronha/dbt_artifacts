/* Bigquery won't let us `where` without `from` so we use this workaround */
with dummy_cte as (
    select 1 as foo
)

select
    cast(null as {{ type_string() }}) as command_invocation_id,
    cast(null as {{ type_string() }}) as node_id,
    {% if config.get("table_type") == "iceberg" -%}
        cast(null as timestamp(6))
    {%- else -%}
        cast(null as {{ type_timestamp() }})
    {%- endif -%}
    as run_started_at,
    cast(null as {{ type_boolean() }}) as was_full_refresh,
    cast(null as {{ type_string() }}) as thread_id,
    cast(null as {{ type_string() }}) as status,
    {% if config.get("table_type") == "iceberg" -%}
        cast(null as timestamp(6))
    {%- else -%}
        cast(null as {{ type_timestamp() }})
    {%- endif -%}
    as compile_started_at,
    {% if config.get("table_type") == "iceberg" -%}
        cast(null as timestamp(6))
    {%- else -%}
        cast(null as {{ type_timestamp() }})
    {%- endif -%}
    as query_completed_at,
    cast(null as {{ type_float() }}) as total_node_runtime,
    cast(null as {{ type_int() }}) as rows_affected,
    {% if target.type == 'bigquery' %}
        cast(null as {{ type_int() }}) as bytes_processed,
    {% endif %}
    cast(null as {{ type_string() }}) as materialization,
    cast(null as {{ type_string() }}) as schema,
    cast(null as {{ type_string() }}) as name,
    cast(null as {{ type_string() }}) as alias,
    cast(null as {{ type_string() }}) as message,
    cast(null as {{ type_json() }}) as adapter_response
from dummy_cte
where 1 = 0
