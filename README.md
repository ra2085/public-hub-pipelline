# Public Hub Pipeline

This repository contains the pipeline and templates for generating Apigee API Proxies from OpenAPI specifications using `apigee-go-gen`.

## Directory Structure

-   `pipeline/`: Contains Cloud Build configurations and scripts.
-   `templates/`: Contains `apigee-go-gen` templates.
    -   `templates/oas3/`: Templates for OpenAPI 3.0 generation. [See Documentation](templates/oas3/README.md).
-   `tests/`: Contains test specifications and runner scripts.
-   `overlays/`: Contains OpenAPI overlays.

## Usage

### Local Testing

You can verify the template generation locally using the provided test runner.

**Prerequisites:**
-   `apigee-go-gen` installed and in your PATH.
-   `jq` (optional, for some scripts).

**Run Tests:**

```bash
./tests/run_tests.sh
```

This script will:
1.  Iterate through YAML specs in the `tests/` directory.
2.  Generate API Proxy bundles in `tests/out/`.
3.  Report success or failure.

### Template Extensions

This project supports custom OpenAPI extensions to drive Apigee policy generation, such as:
-   `x-apigee-assign-message`
-   `x-apigee-basic-authentication`

For full documentation on supported extensions and usage examples, please refer to the [OAS3 Templates README](templates/oas3/README.md).

## Cloud Build

The `pipeline/cloudbuild.yaml` defines the CI/CD process for:
1.  Fetching OpenAPI specs from API Hub.
2.  Applying overlays.
3.  Generating Apigee API Proxy bundles.
4.  Deploying to Apigee.
