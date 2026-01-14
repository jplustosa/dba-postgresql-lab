## Teste de Backup e Restore

### Cenário
Simulação de falha com perda de tabela crítica.

### Ação
- Backup lógico com pg_dump
- Restore em banco separado

### Resultado
- Banco restaurado com sucesso
- Dados íntegros
- Tempo de recuperação validado

### Ferramentas
- pg_dump
- pg_restore
