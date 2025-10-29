# 🔐 Multi IdP JWT Validation Policy - MuleSoft Custom Policy (VIVO / ACCENTURE)

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:0C2340,100:00BFFF&height=220&section=header&text=JWT%20Validation%20Policy&fontSize=40&fontColor=ffffff&animation=fadeIn" alt="JWT Policy" />
</p>

<p align="center">
  <a href="https://docs.mulesoft.com/mule-runtime/4.4/"><img src="https://img.shields.io/badge/Mule%20Runtime-4.4%2B-003B71?logo=mulesoft" alt="Mule Runtime"/></a>
  <a href="https://adoptium.net/"><img src="https://img.shields.io/badge/Java-8%20%7C%2011%20%7C%2017-FF6A00?logo=java" alt="Java 8 | 11 | 17"/></a>
  <a href="https://maven.apache.org/"><img src="https://img.shields.io/badge/Maven-3.x-C71A36?logo=apache-maven" alt="Maven"/></a>
  <a href="https://www.linkedin.com/in/leonel-dorneles-porto-b88600122"><img src="https://img.shields.io/badge/Autor-Leonel%20Porto-0C2340?logo=linkedin" alt="Leonel Porto"/></a>
</p>

---


## 📖 Visão Geral

A **Multi IdP JWT Validation Policy** é uma política customizada para MuleSoft desenvolvida pela Accenture para uso em APIs protegidas com **tokens JWT** emitidos por múltiplos provedores de identidade (IdPs), como **Azure AD**, **Oracle Access Manager (OAM)** e **Oracle IDCS**. Essa solução garante que a validação de assinatura e dos claims do token seja feita de forma flexível, percorrendo múltiplas URLs JWKS em busca do public key adequado e possibilitando o fallback caso um IdP esteja indisponível.

A política se integra à **extensão** `mule-connector-jwt-fallback-extension`, que executa a validação das assinaturas JWT com mecanismo de fallback entre várias URLs JWKS e oferece recursos adicionais, como suporte a headers dinâmicos e mapeamento de claims personalizados.

> ⚠️ **Atenção:** Para que esta política funcione corretamente, é necessário instalar e configurar a extensão `mule-connector-jwt-fallback-extension`. Essa extensão deve estar disponível no repositório Maven ou Anypoint Exchange da sua organização.

---

## 📂 Estrutura do Projeto

```
multi-idp-jwt-policy/
├── pom.xml
├── mule-artifact.json
├── multi-idp-jwt-policy.yaml
├── template.xml
├── README.md  <-- (este documento)
└── └── src/
    ├── main/
    │   └── yaml/
    │       └── multi-idp-jwt-policy.yaml  (definição de metadados da policy)
    └── mule/
        └── template.xml  (fluxo Mule que implementa a validação JWT)
```

* `pom.xml`: Arquivo de configuração Maven, contendo dependências, plugins e repositórios necessários.
* `mule-artifact.json`: Metadados do pacote Mule (nome, versão, requisitos mínimos e configurações de classloader).
* `multi-idp-jwt-policy.yaml`: Definição da policy em formato YAML, com todas as propriedades disponíveis (params, descrições, tipos e obrigatoriedade).
* `template.xml`: Fluxo Mule (XML) que implementa a lógica de validação JWT usando a extensão `jwt-fallback-extension`.
* `README.md`: Documento de referência completa, explicando instalação, configuração, parâmetros, exemplos de uso e troubleshooting.

### Dependências Principais (pom.xml)

No `pom.xml`, as dependências notáveis incluem:

* `com.mulesoft.anypoint:mule-jwt-extension`: Extensão padrão MuleSoft para manipulação de JWT.
* `com.mulesoft.anypoint:mule-client-id-enforcement-extension`: Extensão para enforcement de Client ID (opcional).
* `com.mulesoft.anypoint:mule-http-policy-transform-extension`: Extensão para transformar responses padrão de policy.
* `bda6429f-df0d-477d-80cb-e10089cffdee:mule-connector-jwt-fallback-extension:1.0.5`: Extensão customizada para validação em múltiplos IdPs com fallback.
* `com.mulesoft.modules:mule-secure-configuration-property-module`: Permite o uso de propriedades seguras nos parâmetros da policy.

Além das dependências acima, o projeto faz uso de plugins Maven:

* `mule-maven-plugin` (versão definida em `${mule.maven.plugin.version}`, atualmente 3.2.1): Para build, deploy e validação de policies.
* `exchange-mule-maven-plugin` (versão `0.0.23`): Para publicação automática no Anypoint Exchange.
* `build-helper-maven-plugin`: Auxilia na geração de resources adicionais (se necessário).

> **Observação:** A seção `<repositories>` inclui o repositório `releases-ee` para baixar artefatos Enterprise (EE) caso sua organização tenha licenciamento.

---

## 📄 mule-artifact.json

Este arquivo descreve metadados do pacote da policy, incluindo:

```json
{
  "configs": [
    "template.xml"
  ],
  "secureProperties": [],
  "supportedJavaVersions": [],
  "redeploymentEnabled": true,
  "name": "bda6429f-df0d-477d-80cb-e10089cffdee:mule-policy-multi-idp-jwt:1.0.6",
  "minMuleVersion": "4.4.0",
  "requiredProduct": "MULE_EE",
  "classLoaderModelLoaderDescriptor": {
    "id": "mule",
    "attributes": {
      "exportedPackages": [],
      "exportedResources": []
    }
  },
  "bundleDescriptorLoader": {
    "id": "mule",
    "attributes": {
      "groupId": "bda6429f-df0d-477d-80cb-e10089cffdee",
      "classifier": "mule-policy",
      "artifactId": "mule-policy-multi-idp-jwt",
      "type": "jar",
      "version": "1.0.6"
    }
  }
}
```

* `configs`: Lista de arquivos de configuração que serão empacotados (aqui, `template.xml`).
* `name`: Identificador único do pacote (deve corresponder a `<groupId>:<artifactId>:<version>` do `pom.xml`).
* `minMuleVersion`: Versão mínima do Mule Runtime suportada (ex.: 4.4.0).
* `requiredProduct`: Produto Mule necessário (`MULE_EE` restringe às edições Enterprise).
* `redeploymentEnabled`: Se `true`, permite redeploy da policy sem reiniciar a aplicação.

Certifique-se de que a versão (`1.0.6`) em `mule-artifact.json` esteja alinhada com a do `pom.xml`:

```xml
<version>1.0.6</version>
```

---

## 🥪 multi-idp-jwt-policy.yaml

Este arquivo define as propriedades que podem ser configuradas pelo usuário final ao aplicar a policy na API Manager. Abaixo está um exemplo completo comentado:

```yaml
name: "Multi IdP JWT Validation Policy"
version: "1.0.6"
author: "Leonel Dorneles Porto"
description: |
  Política customizada para validar JWTs de múltiplos provedores de identidade (IdPs) com fallback de JWKS.
  Suporta Azure AD, OAM, Oracle IDCS, entre outros.
tags:
  - jwt
  - security
  - idp
  - multi-idp
muleVersion: "4.4.0"         # Versão mínima do Mule Runtime suportada
product: "MULE_EE"           # Requer Mule EE Edition para execução da policy

definition:
  parameters:

    # ---------- Parâmetros Obrigatórios ----------
    - propertyName: token
      name: "Header • Authorization"
      description: |
        🎫 Token JWT recebido no cabeçalho HTTP "Authorization". Pode incluir prefixo "Bearer ".
        Ex: 'Bearer eyJhbGciOiJSUzI1Ni...'.
      type: string
      optional: false

    - propertyName: urlsCsv
      name: "URLs JWKS"
      description: |
        🌐 Lista de URLs para acessar os JWKS dos diferentes IdPs, separadas por vírgula.
        Ex: 'https://auth1.example.com/jwks,https://auth2.example.com/jwks'.
      type: string
      optional: false

    # ---------- Parâmetros de Algoritmo e Issuer ----------
    - propertyName: alg
      name: "Header • alg"
      description: |
        🔐 Lista de algoritmos JWT permitidos no header (CSV). Ex: 'RS256,RS512'. Se não informado, aceita qualquer.
      type: string
      optional: true

    - propertyName: iss
      name: "Payload • iss"
      description: |
        🌐 Lista de Issuers válidos no payload (CSV). Ex: 'https://issuer1.com,https://issuer2.com'.
        A validação considera positivo se algum valor coincidir.
      type: string
      optional: true

    - propertyName: aud
      name: "Payload • aud"
      description: |
        🔑 Lista de audiencias válidas no payload (CSV). Ex: 'api://default,api://vivo-service'.
        Pode ser usada em `customClaims` ou diretamente aqui.
      type: string
      optional: true

    # ---------- Parâmetros de Claims e Expiração ----------
    - propertyName: sub
      name: "Payload • sub"
      description: |
        🙍‍♂️ Lista de Subjects permitidos no payload (CSV). Filtra se o claim 'sub' não corresponder.
      type: string
      optional: true

    - propertyName: requireExpiration
      name: "Exigir Expiração (exp)"
      description: |
        ⏳ Se 'true', a policy rejeita tokens sem claim 'exp' ou expirados.
      type: boolean
      optional: true

    - propertyName: requireNotBefore
      name: "Exigir Not Before (nbf)"
      description: |
        🚧 Se 'true', a policy rejeita tokens cujo claim 'nbf' ainda não esteja válido.
      type: boolean
      optional: true

    - propertyName: requireJWTId
      name: "Exigir JWT ID (jti)"
      description: |
        🆔 Se 'true', a policy exige que o claim 'jti' esteja presente, mas não valida duplicidade.
      type: boolean
      optional: true

    # ---------- Claims Personalizados ----------
    - propertyName: customClaims
      name: "Claims Personalizados"
      description: |
        ✨ Objeto JSON contendo pares 'claim:valor' para validações adicionais. Ex:
        '{"role":"admin","tenant":"vivo"}'.
        A policy verifica igualdade exata de string.
      type: object
      optional: true

    # ---------- Headers Dinâmicos / QueryParams ----------
    - propertyName: dynamicParams
      name: "QueryParams Dinâmicos"
      description: |
        🔄 Permite mapear headers HTTP em parâmetros de query na URL JWKS.
        Ex: '{"x-oauth-identity-domain-name":"VivoCustomerDomain"}'.
        A URL gerada: 'https://oam.example.com/jwks?x-oauth-identity-domain-name=VivoCustomerDomain'.
      type: object
      optional: true

    # ---------- Configurações de Timeout e Cache ----------
    - propertyName: jwksTimeoutMillis
      name: "Timeout JWKS (ms)"
      description: |
        ⏱ Tempo máximo para baixar o JWKS de cada URL em milissegundos. Default: 2000.
      type: number
      optional: true

    - propertyName: jwksCacheExpirationMinutes
      name: "Cache JWKS (minutos)"
      description: |
        🗄 Tempo de cache dos JWKS em memória. Remove a necessidade de buscar a cada requisição.
        Default: 30.
      type: number
      optional: true

    # ---------- Flags adicionais ----------
    - propertyName: requireCustomClaimsValidation
      name: "Validar Claims Personalizados"
      description: |
        🔍 Se `true`, a policy valida os claims definidos em `customClaims`. Se `false`, ignora.
        Default: `true`.
      type: boolean
      optional: true
      defaultValue: true

    - propertyName: enableLogging
      name: "Ativar Logging Detalhado"
      description: |
        📝 Se `true`, exibe logs detalhados de todo o processo de validação JWT no runtime.
        Útil para debugging.
      type: boolean
      optional: true
      defaultValue: false

  # ---------- Exemplo de Valores (para testes ou documentação interna) ----------
  example:
    token: "Bearer eyJhbGciOiJSUzI1NiI..."
    urlsCsv: "https://auth1.vivo.com.br/jwks,https://oam.vivo.com.br/jwks"
    alg: "RS256,RS512"
    iss: "https://idcs.vivo.com.br,https://oam.vivo.com.br"
    aud: "api://default,api://vivo-service"
    sub: "User123"
    requireExpiration: true
    requireNotBefore: false
    requireJWTId: true
    customClaims:
      role: "admin"
      region: "BR"
    dynamicParams:
      x-oauth-identity-domain-name: "VivoCustomerDomain"
    jwksTimeoutMillis: 2500
    jwksCacheExpirationMinutes: 60
    requireCustomClaimsValidation: true
    enableLogging: true
```

> **Dica:** Se algum parâmetro não se aplicar, basta não preenchê-lo no momento de configurar a política no Anypoint Platform.

---

## 🔮 Fluxo Interno (template.xml)

O `template.xml` implementa a lógica de validação JWT. Abaixo, descrevemos o passo a passo detalhado de cada componente no fluxo:

```xml
<mule xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns="http://www.mulesoft.org/schema/mule/core"
      xmlns:http-policy="http://www.mulesoft.org/schema/mule/http-policy"
      xmlns:client-id-enforcement="http://www.mulesoft.org/schema/mule/client-id-enforcement"
      xmlns:jwt-fallback="http://www.mulesoft.org/schema/mule/jwt-fallback"
      xsi:schemaLocation="
          http://www.mulesoft.org/schema/mule/core              http://www.mulesoft.org/schema/mule/core/current/mule.xsd
          http://www.mulesoft.org/schema/mule/http-policy       http://www.mulesoft.org/schema/mule/http-policy/current/mule-http-policy.xsd
          http://www.mulesoft.org/schema/mule/client-id-enforcement http://www.mulesoft.org/schema/mule/client-id-enforcement/current/mule-client-id-enforcement.xsd
          http://www.mulesoft.org/schema/mule/jwt-fallback      http://www.mulesoft.org/schema/mule/jwt-fallback/current/mule-jwt-fallback.xsd">

    <http-policy:proxy name="{{{policyId}}}-jwt-fallback-validation">
        <http-policy:source>
            <try>
                <!-- ① JWT signature & claim validation -->
                <jwt-fallback:validate-with-fallback
                    doc:name="Validate with fallback"
                    token="#[(attributes.headers.authorization default '')]"
                    urlsCsv="{{urlsCsv}}"
                    {{#if requireJWTId}}         requireJWTId="{{requireJWTId}}"                 {{/if}}
                    {{#if requireExpiration}}    requireExpiration="{{requireExpiration}}"       {{/if}}
                    {{#if requireNotBefore}}     requireNotBefore="{{requireNotBefore}}"         {{/if}}
                    {{#if timeoutMillis}}        timeoutMillis="{{timeoutMillis}}"               {{/if}}
                    {{#if enableLogging}}        enableLogging="{{enableLogging}}"               {{/if}}
                    {{#if validateCustomClaims}} validateCustomClaims="{{validateCustomClaims}}" {{/if}}
                    target="isValid">

                    <jwt-fallback:custom-claims>
                        {{#if alg}}                               <jwt-fallback:custom-claim key="alg"                              value="{{alg}}"/>                                  {{/if}}
                        {{#if kid}}                               <jwt-fallback:custom-claim key="kid"                              value="{{kid}}"/>                                  {{/if}}
                        {{#if typ}}                               <jwt-fallback:custom-claim key="typ"                              value="{{typ}}"/>                                  {{/if}}
                        {{#if x5t}}                               <jwt-fallback:custom-claim key="x5t"                              value="{{x5t}}"/>                                  {{/if}}
                        {{#if sub}}                               <jwt-fallback:custom-claim key="sub"                              value="{{sub}}"/>                                  {{/if}}
                        {{#if iss}}                               <jwt-fallback:custom-claim key="iss"                              value="{{iss}}"/>                                  {{/if}}
                        {{#if jti}}                               <jwt-fallback:custom-claim key="jti"                              value="{{jti}}"/>                                  {{/if}}
                        {{#if vivo_env}}                          <jwt-fallback:custom-claim key="vivo.env"                         value="{{vivo_env}}"/>                             {{/if}}
                        {{#if vivo_endpoint}}                     <jwt-fallback:custom-claim key="vivo.endpoint"                    value="{{vivo_endpoint}}"/>                        {{/if}}
                        {{#if oauth_scope}}                       <jwt-fallback:custom-claim key="oracle.oauth.scope"               value="{{oauth_scope}}"/>                          {{/if}}
                        {{#if oauth_client_origin_id}}            <jwt-fallback:custom-claim key="oracle.oauth.client_origin_id"    value="{{oauth_client_origin_id}}"/>               {{/if}}
                        {{#if oauth_id_d_id}}                     <jwt-fallback:custom-claim key="oracle.oauth.id_d_id"             value="{{oauth_id_d_id}}"/>                        {{/if}}
                        {{#if user_tenant_name}}                  <jwt-fallback:custom-claim key="user.tenant.name"                 value="{{user_tenant_name}}"/>                     {{/if}}
                        {{#if oauth_svc_p_n}}                     <jwt-fallback:custom-claim key="oracle.oauth.svc_p_n"             value="{{oauth_svc_p_n}}"/>                        {{/if}}
                        {{#if iat}}                               <jwt-fallback:custom-claim key="iat"                              value="{{iat}}"/>                                  {{/if}}
                        {{#if oauth_prn_id_type}}                 <jwt-fallback:custom-claim key="oracle.oauth.prn.id_type"         value="{{oauth_prn_id_type}}"/>                    {{/if}}
                        {{#if oauth_tk_context}}                  <jwt-fallback:custom-claim key="oracle.oauth.tk_context"          value="{{oauth_tk_context}}"/>                     {{/if}}
                        {{#if prn}}                               <jwt-fallback:custom-claim key="prn"                              value="{{prn}}"/>                                 
                        {{/if}}
                        {{#if oracle\_oauth\_user\_origin\_id}}       \<jwt-fallback\:custom-claim key="oracle.oauth.user\_origin\_id"      value="{{oracle\_oauth\_user\_origin\_id}}" />         {{/if}}
                        {{#if oracle\_oauth\_user\_origin\_id\_type}}  \<jwt-fallback\:custom-claim key="oracle.oauth.user\_origin\_id\_type" value="{{oracle\_oauth\_user\_origin\_id\_type}}"/>     {{/if}}
                        {{#if vivoLKRS}}                          \<jwt-fallback\:custom-claim key="vivoLKRS"                         value="{{vivoLKRS}}" />                            {{/if}}
                        {{#if domain}}                            \<jwt-fallback\:custom-claim key="domain"                           value="{{domain}}" />                              {{/if}}
                        {{#if env}}                               \<jwt-fallback\:custom-claim key="env"                              value="{{env}}"/>                                  {{/if}}
                        {{#if customClaimsKey}}                   \<jwt-fallback\:custom-claim key="{{customClaimsKey}}"              value="{{customClaimsValue}}"/>                    {{/if}}
                        {{#if aud}}                               \<jwt-fallback\:custom-claim key="aud"                              value="{{aud}}" />                                 {{/if}}
                        {{#if client}}                            \<jwt-fallback\:custom-claim key="client"                           value="{{client}}"/>                               {{/if}}
                        {{#if entryUUID}}                         \<jwt-fallback\:custom-claim key="entryUUID"                        value="{{entryUUID}}"/>                            {{/if}}
                        {{#if firstname}}                         \<jwt-fallback\:custom-claim key="firstname"                        value="{{firstname}}"/>                            {{/if}}
                        {{#if lastname}}                          \<jwt-fallback\:custom-claim key="lastname"                         value="{{lastname}}"/>                             {{/if}}
                        {{#if mail}}                              \<jwt-fallback\:custom-claim key="mail"                             value="{{mail}}"/>                                 {{/if}}
                        {{#if nrdocumento}}                       \<jwt-fallback\:custom-claim key="nrdocumento"                      value="{{nrdocumento}}"/>                          {{/if}}
                        {{#if documentocliente}}                  \<jwt-fallback\:custom-claim key="documentocliente"                 value="{{documentocliente}}"/>                     {{/if}}
                        {{#if uid}}                               \<jwt-fallback\:custom-claim key="uid"                              value="{{uid}}"/>                                  {{/if}}
                        {{#if commonname}}                        \<jwt-fallback\:custom-claim key="commonname"                       value="{{commonname}}"/>                           {{/if}}
                        {{#if authorizedservices}}                \<jwt-fallback\:custom-claim key="authorizedservices"               value="{{authorizedservices}}"/>                   {{/if}}
                        {{#if tvdesignador}}                      \<jwt-fallback\:custom-claim key="tvdesignador"                     value="{{tvdesignador}}"/>                         {{/if}}
                        {{#if tvdesignadorpreferido}}             \<jwt-fallback\:custom-claim key="tvdesignadorpreferido"            value="{{tvdesignadorpreferido}}"/>                {{/if}}
                        {{#if description}}                       \<jwt-fallback\:custom-claim key="description"                      value="{{description}}"/>                          {{/if}}
                        {{#if oracle\_oauth\_rt\_ttc}}               \<jwt-fallback\:custom-claim key="oracle.oauth.rt.ttc"              value="{{oracle\_oauth\_rt\_ttc}}"/>                  {{/if}}
                        \</jwt-fallback\:custom-claims>
                        \</jwt-fallback\:validate-with-fallback>

            <!-- ② Route based on validation result -->
            <choice>
                <when expression="#[(vars.isValid)]">
                    {{#unless skipClientIdValidation}}
                      {{#if clientIdExpression}}
                        <client-id-enforcement:validate-client-id
                            config-ref="clientEnforcementConfig"
                            clientId="#[(vars.jwtResponse)]"/>
                        <remove-variable doc:name="Remove Variable jwtResponse" variableName="jwtResponse"/>
                      {{/if}}
                    {{/unless}}
                    <remove-variable doc:name="Remove Variable isValid" variableName="isValid"/>
                    <http-policy:execute-next/>
                </when>
                <otherwise>
                    <http-transform:set-response statusCode="401">
                        <http-transform:body><![CDATA[{ "error": "JWT validation failed." }]]></http-transform:body>
                        <http-transform:headers><![CDATA[#[{ 'WWW-Authenticate': 'Bearer', 'Content-Type': 'application/json' }]]]></http-transform:headers>
                    </http-transform:set-response>
                </otherwise>
            </choice>

            <!-- ③ Detailed error handling for JWT & Client‑ID enforcement -->
            <error-handler>
                <on-error-continue type="JWT:REJECTED" logException="false">
                    <http-transform:set-response statusCode="401">
                        <http-transform:body><![CDATA[{ "error": "Invalid or expired JWT." }]]></http-transform:body>
                        <http-transform:headers><![CDATA[#[{ 'WWW-Authenticate': 'Bearer', 'Content-Type': 'application/json' }]]]></http-transform:headers>
                    </http-transform:set-response>
                </on-error-continue>

                <on-error-continue type="JWT:JWKS_SERVICE_UNAVAILABLE" logException="false">
                    <http-transform:set-response statusCode="503">
                        <http-transform:body><![CDATA[{ "error": "Unable to reach JWKS endpoint." }]]></http-transform:body>
                    </http-transform:set-response>
                </on-error-continue>

                <on-error-continue type="JWT:TOKEN_NOT_PRESENT" logException="false">
                    <http-transform:set-response statusCode="400">
                        <http-transform:body><![CDATA[{ "error": "JWT not provided in request." }]]></http-transform:body>
                    </http-transform:set-response>
                </on-error-continue>

                <on-error-continue type="CLIENT-ID-ENFORCEMENT:INVALID_API, CLIENT-ID-ENFORCEMENT:INVALID_CLIENT, CLIENT-ID-ENFORCEMENT:INVALID_CREDENTIALS" logException="false">
                    <http-transform:set-response statusCode="403">
                        <http-transform:body><![CDATA[{ "error": "Client-ID validation failed." }]]></http-transform:body>
                    </http-transform:set-response>
                </on-error-continue>
            </error-handler>
        </try>
    </http-policy:source>
</http-policy:proxy>
```
---

### Explicação Detalhada do Fluxo:

1. A política extrai o token JWT do header `Authorization`.
2. Chama a extensão `jwt-fallback:validate-with-fallback`, passando o token e a lista de URLs JWKS.
3. A extensão tenta validar o token em sequência com cada URL JWKS, com fallback automático.
4. Recebe flags opcionais para validação de `exp`, `nbf`, `jti` e claims customizados.
5. Em caso de sucesso, o fluxo permite o request seguir e pode executar validação Client-ID se configurado.
6. Em caso de falha, retorna status `401 Unauthorized` com mensagem JSON.
7. O tratamento de erros é detalhado para situações comuns como token ausente, endpoint JWKS indisponível, token inválido ou Client-ID inválido.

---

## 🔧 Configurando no Anypoint API Manager

1. **Faça o upload da policy para o Exchange**:

   * Execute no diretório do projeto:

   ```bash
   mvn clean deploy -DskipTests -s .maven/settings.xml
   ```

   * Verifique no Anypoint Exchange se a policy apareceu com a versão `1.0.6`.

2. **Crie ou edite a API** no Anypoint Platform:

   * Acesse **Anypoint Platform > API Manager > APIs**.
   * Selecione a API que deseja proteger ou crie uma nova.
   * No menu **Policies**, clique em **Apply New Policy** e localize **Multi IdP JWT Validation Policy**.
   * Clique em **Next** e preencha os parâmetros conforme necessário:

     * **token**: `#{attributes.headers['Authorization']}` (padrão para extrair header).
     * **urlsCsv**: Ex: `https://auth1.vivo.com.br/jwks,https://oam.vivo.com.br/jwks`.
     * **alg**: `RS256,RS512` (se quiser restringir algoritmos).
     * **iss**: `https://idcs.vivo.com.br,https://oam.vivo.com.br`.
     * **aud**: `api://default,api://vivo-service`.
     * **requireExpiration**: `true`.
     * **requireJWTId**: `true`.
     * **customClaims**: `{"role":"admin","region":"BR"}` (caso haja claims extras).
     * **dynamicParams**: `{"x-oauth-identity-domain-name":"VivoCustomerDomain"}`.
     * **jwksTimeoutMillis** e **jwksCacheExpirationMinutes**: ajuste conforme necessidade.
     * **enableLogging**: `true` para ativar logs detalhados em runtime.
   * Clique em **Apply**.

3. **Teste a API**:

   * Use o Postman ou outra ferramenta para enviar uma requisição com header `Authorization: Bearer <token válido>`.
   * Observe se a policy bloqueia ou libera a requisição conforme os parâmetros configurados.
   * Se o token for inválido ou expirado, deve retornar `401 Unauthorized`.

> ℹ️ **Dica de Teste:** Utilize ferramentas como jwt.io para inspecionar tokens, editar claims e simular tokens vencidos ou com `nbf` no futuro.

---

## 🛠️ Debug e Troubleshooting

### 1. Erros Comuns durante o Maven Verify

```
[ERROR] Failed to execute goal org.mule.tools.maven:mule-maven-plugin:4.5.0:verify [...]
Verify exception: Error in file 'mule-artifact.json'. The version does not match the one defined in the pom.xml. Expected '1.0.6'. Actual '1.0.0'.
```

**Solução**: Ajuste o campo `version` no `mule-artifact.json` para ficar igual ao `<version>` do `pom.xml`:

```json
{
  "version": "1.0.6"
}
```

### 2. HTTP Request Timeout ao buscar JWKS

* **Sintoma**: Requisição para `https://auth.example.com/jwks` leva mais de 2 segundos e dispara erro de timeout.
* **Ação**:

  1. Aumente o parâmetro `jwksTimeoutMillis` para um valor maior (ex: 5000 ms).
  2. Verifique conectividade de rede entre o Mule Runtime e o serviço JWKS (firewall, DNS).
  3. Habilite logs detalhados (`DEBUG`) no logger para saber qual URL falhou.

### 3. Falha de Validação de Claims Personalizados

* **Sintoma**: Mesmo com token válido, a policy retorna `401` indicando que um claim não corresponde.
* **Ação**:

  1. Certifique-se de que o claim está exatamente igual (case-sensitive).
  2. Ao usar `customClaims`, valide o JSON de entrada (no Anypoint Platform) e garanta que o valor do claim esteja correto.
  3. Teste o token no jwt.io (verifique payload > campo `role` e `region`).

### 4. Exceção ao Decodificar JWT (formato inválido)

* **Sintoma**: Erro no `<jwt:decode>` indicando token malformado.
* **Ação**:

  1. Verifique se o header `Authorization` está sendo passado corretamente.
  2. Confirme se está usando `Bearer <token>` ou apenas `<token>`. Se for puro, ajuste a extração no template.
  3. Garanta que o token tenha 3 segmentos separados por ponto (`header.payload.signature`).

### 5. Performance no Loop de URLs JWKS

* **Sintoma**: Latência alta ao validar tokens, pois a policy faz várias chamadas HTTP em sequência.
* **Ação**:

  1. Reduza a frequência das chamadas ativando cache de JWKS (`jwksCacheExpirationMinutes`).
  2. Se possível, disponibilize um endpoint unificado de JWKS que agrupe chaves de múltiplos IdPs.
  3. Aumente o thread pool ou conectTimeout no HTTP Request Configuration.

---

## 📈 Monitoramento e Métricas

Para acompanhar métricas de uso e taxa de sucesso/falha de validação, recomenda-se:

1. **Habilitar logs estruturados (JSON)** em níveis `INFO` e `WARN`, coletando em um sistema de APM (Application Performance Monitoring).
2. **Adicionar métricas customizadas** (via DataWeave e Mulesoft Metrics) para contar:

   * Total de tentativas de validação.
   * Total de tokens aprovados.
   * Total de tokens rejeitados.

Exemplo de bloco DataWeave para incrementar uma contagem:

```xml
<dw:transform-message doc:name="Increment Metrics">
    <dw:set-variable variableName="validationMetricPayload"><![CDATA[
%dw 2.0
output application/java
---
{"event": "jwt_validation_attempt", "success": vars.validationSuccess}
]]></dw:set-variable>
</dw:transform-message>
<amm:report metricName="jwt.validation.attempts" value="1" doc:name="Report Validation Attempt" config-ref="APM_Config" />
```

> **Recomendação:** Centralize logs num sistema como Splunk, ELK ou New Relic para análise de padrões de falha.

---

## 📦 Versionamento e Publicação

1. **Incremento de Versão**: Siga o SemVer (semântico) para alterações:

   * **Patch**: Correções de bugs internos (ex.: tratamento de excepcões).
   * **Minor**: Adição de novos parâmetros opcionais (ex.: suporte a `scope`).
   * **Major**: Mudanças incompatíveis (ex.: alteração de `template.xml` que quebra compatibilidade de configuração).

2. **Publicação no Exchange**:

   * Atualize `<version>` no `pom.xml` e `mule-artifact.json`.
   * Rode `mvn clean deploy -DskipTests -s .maven/settings.xml`.
   * Confirme no Anypoint Exchange que a nova versão está disponível.
   * Atualize a documentação (README) com notas de versão no GitHub (CHANGELOG).

---

## 🔗 Integração com Outras Políticas e Flows

* **Client ID Enforcement**: Caso você queira garantir que todos os requests possuam um Client ID válido, combine esta política com **Client ID Enforcement Policy** do Anypoint.
* **Rate Limiting / Throttling**: Coloque a **Rate Limiting Policy** antes da validação JWT, filtrando abuso antes de executar lógica de validação.
* **Transform Message**: Após validação JWT, você pode usar um flow que extraia claims e adicione cabeçalhos customizados para downstream.

---

## 👥 Desenvolvedores e Contatos

* **Autor Principal:** Leonel Dorneles Porto
* **E-mail:** [leonel.d.porto@accenture.com](mailto:leonel.d.porto@accenture.com)
* **LinkedIn:** [https://br.linkedin.com/in/leonel-dorneles-porto-b88600122](https://br.linkedin.com/in/leonel-dorneles-porto-b88600122)
* **Organização:** Accenture / Telefônica VIVO

---

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=22&pause=1000&color=00BFFF&center=true&vCenter=true&width=1000&lines=Obrigado+por+usar+a+Multi+IdP+JWT+Validation+Policy+🚀"/>
</p>

---
