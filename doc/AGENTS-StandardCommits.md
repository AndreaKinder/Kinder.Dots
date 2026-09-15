# Agents

## Commits

Los mensajes de commit deben seguir el formato **Conventional Commits**:

```
<type>(<scope>): <description>
```

### Tipos permitidos

- `feat` — nueva funcionalidad
- `fix` — corrección de bug
- `refactor` — refactorización sin cambio de comportamiento
- `chore` — tareas de mantenimiento, dependencias, configuración
- `docs` — cambios en documentación
- `test` — añadir o corregir tests
- `perf` — mejoras de rendimiento
- `style` — formato, espacios, puntos y coma (sin cambio de lógica)

### Ejemplos

```
feat(match-settings): add database persistence for match weights
fix(job-application): remove hardcoded weights from domain entity
refactor(users): split MatchSettingsRoute into get and save routes
```
