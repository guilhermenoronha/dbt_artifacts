{{ config( materialized='incremental', unique_key='manifest_snapshot_id' ) }}

with dbt_nodes as (

    select * from {{ ref('stg_dbt__nodes') }}

),

dbt_snapshots_incremental as (

    select *
    from dbt_nodes
    where resource_type = 'snapshot'

        {% if is_incremental() %}
            -- this filter will only be applied on an incremental run
            and artifact_generated_at > (select max(artifact_generated_at) from {{ this }})
        {% endif %}

),

fields as (

    select
        manifest_node_id as manifest_snapshot_id,
        command_invocation_id,
        dbt_cloud_run_id,
        artifact_run_id,
        artifact_generated_at,
        node_id,
        node_database as snapshot_database,
        node_schema as snapshot_schema,
        name,
        to_array(node_json:depends_on:nodes) as depends_on_nodes,
        node_json:package_name::string as package_name,
        node_json:path::string as snapshot_path,
        node_json:checksum.checksum::string as checksum
    from dbt_snapshots_incremental

)

select * from fields