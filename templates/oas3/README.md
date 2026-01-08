# OAS3 Templates

This directory contains templates for generating Apigee API Proxies from OpenAPI 3.0 specifications using `apigee-go-gen`.

## Supported Extensions

### `x-apigee-assign-message`

Allows for the generation and attachment of `AssignMessage` policies directly from the OpenAPI specification operation.

**Usage:**

Add the `x-apigee-assign-message` extension to your operation in the OpenAPI spec.

```yaml
paths:
  /hello:
    get:
      x-apigee-assign-message:
        - name: "AM-SetHeader"
          AssignTo:
            type: "request" # or "response"
          Set:
            Headers:
              - name: "X-Hello"
                value: "World"
```

**Configuration Fields:**

| Field | Description | Default |
| :--- | :--- | :--- |
| `name` | Name of the policy. | `AM-<OperationId>-<Index>` |
| `condition` | Flow Condition string. | |
| `AssignTo` | Target for the assignment. | |
| `AssignTo.type` | Flow to attach the policy to (`request` or `response`). | `request` |
| `Set` | standard AssignMessage `Set` configuration. | |
| `AssignVariable` | standard AssignMessage `AssignVariable` list. | |
| `IgnoreUnresolvedVariables`| Boolean flag. | |

### `x-apigee-basic-authentication`

Allows for the generation and attachment of `BasicAuthentication` policies.

**Usage:**

```yaml
paths:
  /auth:
    post:
      x-apigee-basic-authentication:
        - name: "BA-Encode"
          condition: "request.queryparam.auth = 'true'"
          operation: "Encode"
          user:
            ref: "request.queryparam.user"
          password:
            ref: "request.queryparam.pass"
          assignTo:
            createNew: true
            type: "request"
          source: "request.header.Authorization"
```

**Configuration Fields:**

| Field | Description | Default |
| :--- | :--- | :--- |
| `name` | Name of the policy. | `BA-<OperationId>-<Index>` |
| `condition` | Flow Condition string. | |
| `operation` | `Encode` or `Decode`. | `Encode` |
| `user.ref` | Variable ref for username. | |
| `user.value` | Static value for username. | |
| `password.ref` | Variable ref for password. | |
| `password.value` | Static value for password. | |
| `assignTo.createNew`| Create a new variable? | `false` |
| `assignTo.value` | Variable name to assign to. | |
| `assignTo.type` | Attachment flow (`request`/`response`). | `request` |
| `source` | Source variable for Decode. | |


### `x-apigee-oas-validation`

Controls the `OAS-Validate` policy in the PreFlow.

**Usage:**

```yaml
info:
  title: My API
  x-apigee-oas-validation:
    enabled: true
    condition: "request.header.validate = 'true'"
```

**Configuration Fields:**

| Field | Description | Default |
| :--- | :--- | :--- |
| `enabled` | Enable/Disable the policy. | `true` |
| `condition` | Flow Condition string. | |

### `x-apigee-verify-api-key`

Controls the `VerifyAPIKey` policy configuration for API Key security schemes.

**Usage:**

```yaml
components:
  securitySchemes:
    MyApiKey:
      type: apiKey
      in: header
      name: X-API-KEY
      x-apigee-verify-api-key:
        name: "VA-CustomName"
        continueOnError: true
```

**Configuration Fields:**

| Field | Description | Default |
| :--- | :--- | :--- |
| `name` | Name of the policy. | `VA-<SchemeName>` |
| `enabled` | Enable/Disable the policy. | `true` |
| `continueOnError` | Boolean flag. | `false` |
| `displayName` | Policy display name. | `VA-<SchemeName>` |

### `x-apigee-assign-message` (Global)

Policies defined in the `info` object are attached to the `PreFlow`.

```yaml
info:
  title: My API
  x-apigee-assign-message:
    - name: "AM-Global-SetHeader"
      flow: preflow # default, or 'postflow'
      assignTo:
        type: request # or response
      AssignVariable:
        Name: "global_var"
        Value: "true"
```

### `x-apigee-basic-authentication` (Global)

Can also be attached globally to `PreFlow` or `PostFlow`.

```yaml
info:
  x-apigee-basic-authentication:
    - name: "BA-Global-Auth"
      flow: preflow
      assignTo:
        type: request
      ...
```

### Other Extensions



