# 📊 Badges do Projeto

Este documento explica como manter os badges do README.md atualizados.

## 🎯 Badges Atuais

### Status do Projeto
```markdown
<img src="https://img.shields.io/badge/Status-Produção-brightgreen" alt="Status"/>
```
- **Status**: Indica se o projeto está em desenvolvimento, produção, etc.
- **Cores**: `brightgreen` (produção), `orange` (beta), `red` (desenvolvimento)

### Versões
```markdown
<img src="https://img.shields.io/badge/Flutter-3.6.1+-blue?logo=flutter" alt="Flutter"/>
<img src="https://img.shields.io/badge/Dart-3.6.1+-blue?logo=dart" alt="Dart"/>
<img src="https://img.shields.io/badge/Version-1.0.0-green" alt="Version"/>
```
- **Flutter**: Versão mínima do Flutter SDK (verificar em `pubspec.yaml`)
- **Dart**: Versão mínima do Dart SDK (verificar em `pubspec.yaml`)
- **Version**: Versão atual do projeto (verificar em `pubspec.yaml`)

### Tecnologias
```markdown
<img src="https://img.shields.io/badge/Material-3-orange?logo=material-design" alt="Material 3"/>
<img src="https://img.shields.io/badge/Platform-Android-blue?logo=android" alt="Android"/>
```
- **Material 3**: Indica uso do Material Design 3
- **Platform**: Plataformas suportadas

### Dependências e Licença
```markdown
<img src="https://img.shields.io/badge/Dependencies-6-blue" alt="Dependencies"/>
<img src="https://img.shields.io/badge/License-MIT-yellow" alt="License"/>
```
- **Dependencies**: Número de dependências principais (contar em `pubspec.yaml`)
- **License**: Tipo de licença do projeto

## 🔄 Como Atualizar

### 1. Verificar Versões
```bash
# Verificar versão do Flutter
flutter --version

# Verificar versão do Dart
dart --version

# Verificar dependências
flutter pub deps
```

### 2. Atualizar pubspec.yaml
```yaml
version: 1.0.1+2  # Incrementar versão
environment:
  sdk: ^3.6.1     # Atualizar se necessário
```

### 3. Atualizar Badges no README.md
```markdown
# Exemplo de atualização
<img src="https://img.shields.io/badge/Flutter-3.6.1+-blue?logo=flutter" alt="Flutter"/>
<img src="https://img.shields.io/badge/Version-1.0.1-green" alt="Version"/>
```

## 🎨 Cores Disponíveis

### Cores Padrão
- `brightgreen` - Sucesso/Produção
- `green` - Estável
- `yellow` - Aviso
- `orange` - Beta/Teste
- `red` - Erro/Desenvolvimento
- `blue` - Informação
- `lightgrey` - Neutro

### Cores Personalizadas
```markdown
<img src="https://img.shields.io/badge/Custom-Color-ff0000" alt="Custom"/>
```

## 🔗 Badges Dinâmicos (Futuro)

Para badges dinâmicos, considere implementar:

### GitHub Actions
```yaml
# .github/workflows/badges.yml
name: Update Badges
on:
  push:
    branches: [main]
jobs:
  update-badges:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Update Version Badge
        uses: schneegans/dynamic-badges-action@v1.5.0
        with:
          auth: ${{ secrets.GIST_SECRET }}
          namedLogo: flutter
          label: version
          message: ${{ github.ref_name }}
          namedColor: blue
          gistID: your-gist-id
          filename: version.json
```

### Shields.io
```markdown
<img src="https://img.shields.io/github/v/release/username/repo" alt="Release"/>
<img src="https://img.shields.io/github/last-commit/username/repo" alt="Last Commit"/>
```

## 📝 Checklist de Atualização

- [ ] Verificar versão do Flutter
- [ ] Verificar versão do Dart
- [ ] Atualizar versão do projeto
- [ ] Contar dependências
- [ ] Verificar plataformas suportadas
- [ ] Atualizar badges no README.md
- [ ] Testar links dos badges
- [ ] Commit das mudanças

## 🚀 Automatização

Para automatizar o processo, considere:

1. **GitHub Actions** para atualização automática
2. **Scripts de build** para incrementar versão
3. **Hooks de pre-commit** para verificar badges
4. **CI/CD** para validação de versões

---

**Última atualização**: Janeiro 2025 