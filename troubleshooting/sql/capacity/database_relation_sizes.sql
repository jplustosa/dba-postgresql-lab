-- Objetivo: mostrar tamanho do banco conectado e maiores relações de usuário.
-- Compatibilidade: PostgreSQL 15–18; usa funções de tamanho e catálogos do sistema.
-- Contexto: primário ou standby; ambos os resultados são apenas para current_database().
-- Permissões: CONNECT no banco atual (necessário para a conexão) ou pg_read_all_stats
-- para pg_database_size; consulte permissões de catálogo do ambiente para as relações.
-- Extensões: nenhuma.
-- Segurança: somente leitura; tamanho do banco/objetos não é espaço livre no filesystem.

SELECT
    current_database() AS database_name,
    size.database_size_bytes,
    pg_size_pretty(size.database_size_bytes) AS database_size_pretty
FROM (SELECT pg_database_size(current_database()) AS database_size_bytes) AS size;

WITH relations AS (
    SELECT
        namespace.nspname AS schema_name,
        relation.relname AS relation_name,
        relation.relkind AS relation_kind,
        pg_relation_size(relation.oid) AS relation_size_bytes,
        pg_total_relation_size(relation.oid) AS total_size_bytes
    FROM pg_class AS relation
    JOIN pg_namespace AS namespace
        ON namespace.oid = relation.relnamespace
    WHERE relation.relkind IN ('r', 'm')
      AND namespace.nspname <> 'information_schema'
      AND left(namespace.nspname, 3) <> 'pg_'
)
SELECT
    schema_name,
    relation_name,
    relation_kind,
    relation_size_bytes,
    pg_size_pretty(relation_size_bytes) AS relation_size_pretty,
    total_size_bytes,
    pg_size_pretty(total_size_bytes) AS total_size_pretty
FROM relations
ORDER BY total_size_bytes DESC, schema_name, relation_name
LIMIT 25;
