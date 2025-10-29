# 🛡️ mule-policy-test

Repositório modelo para desenvolvimento de **Custom Policies** no MuleSoft, com estrutura pronta para build e deploy facilitado usando Maven e script `.cmd`.

---

## 🚀 Visão Geral

Este projeto fornece um **template completo** para criar e testar **Custom Policies** no Anypoint Platform, com as seguintes vantagens:

- Projeto gerado via archetype oficial `api-gateway-custom-policy-archetype`
- Estrutura de diretórios organizada
- Arquivo `pom.xml` pronto para build
- Arquivo `mule-policy-test.yaml` com metadados da política
- Script `Build Deploy.cmd` para automatizar o processo de deploy
- Uso de Connected App com `CLIENT_ID~?~CLIENT_SECRET` como autenticação

---

## 🧱 Estrutura do Projeto

```

mule-policy-test/
├── Build Deploy.cmd             # Script de build + deploy (Windows)
├── pom.xml                      # Build Maven configurado
├── mule-artifact.json           # Manifesto da policy
├── mule-policy-test.yaml        # Metadata da Custom Policy
├── template.xml                 # Template da policy (logica Mule)
└── .maven/settings.xml          # Repositórios + Exchange

````

---

## 🛠️ Pré-Requisitos

- **Java 8+**
- **Maven 3.6+**
- **Anypoint Platform Connected App** com:
  - `client_id`
  - `client_secret`
  - Permissão: **Exchange Contributor**
- Acesso ao **repositório Nexus EE**, caso use dependências privadas

---

## 🧪 Como Testar / Fazer Deploy

### 1. Configure as variáveis no script `Build Deploy.cmd`

Edite o bloco abaixo no script:

```bat
REM Nexus EE
set MULE_REPO_EE_NEXUS_USERNAME=SEU_USUARIO_NEXUS
set MULE_REPO_EE_NEXUS_PASSWORD=SUA_SENHA_NEXUS

REM Anypoint Exchange - Connected App
set ANYPOINT_USERNAME=~~~Client~~~
set ANYPOINT_CONNECTED_APP_CLIENT_ID=SEU_CLIENT_ID
set ANYPOINT_CONNECTED_APP_CLIENT_SECRET=SEU_CLIENT_SECRET
````

---

### 2. Execute o script:

```bash
Build Deploy.cmd
```

💡 O script realiza:

* `mvn clean install`
* `mvn deploy` com `settings.xml` customizado
* Mostra o resultado no terminal e pausa ao final

---

## 📦 Deploy para o Anypoint Exchange

O deploy é feito via plugin Maven para Custom Policies:

```xml
<plugin>
  <groupId>org.mule.tools.maven</groupId>
  <artifactId>mule-custom-policy-plugin</artifactId>
  ...
</plugin>
```

Você pode ver os detalhes no `pom.xml` incluso.

---

## 💬 Exemplo da Policy

A lógica da policy (`template.xml`) simplesmente adiciona um header e body customizados:

```xml
<http-transform:set-response statusCode="201">
  <http-transform:body>#[ 'Hello World!' ]</http-transform:body>
  <http-transform:headers>#[ {'New-Header': 'Hello World!'} ]</http-transform:headers>
</http-transform:set-response>
```

---

## 👥 Colaboradores

Este projeto foi estruturado para uso interno de desenvolvedores MuleSoft, mas pode ser facilmente adaptado para qualquer contexto.

---

## 🧾 Licença

Uso interno e educativo. Sinta-se livre para adaptar às suas necessidades.

---
