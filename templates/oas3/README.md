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
| `operation` | `Encode` or `Decode`. | `Encode` |
| `user.ref` | Variable ref for username. | |
| `user.value` | Static value for username. | |
| `password.ref` | Variable ref for password. | |
| `password.value` | Static value for password. | |
| `assignTo.createNew`| Create a new variable? | `false` |
| `assignTo.value` | Variable name to assign to. | |
| `assignTo.type` | Attachment flow (`request`/`response`). | `request` |
| `source` | Source variable for Decode. | |


### Other Extensions

-   `x-apigee-spike-arrest-rate` (Info level): Sets the rate for the Spike Arrest policy.
-   `x-apigee-logging` (Info level): Enables Cloud Logging.
-   `x-apigee-authz-idp` (Info level): Enables IDP Token Authorization.
