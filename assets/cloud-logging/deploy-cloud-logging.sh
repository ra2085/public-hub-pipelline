#!/bin/bash

# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ -z "$APIGEE_PROJECT" ]; then
  echo "No APIGEE_PROJECT variable set"
  exit
fi

if [ -z "$APIGEE_ENV" ]; then
  echo "No APIGEE_ENV variable set"
  exit
fi

if [ -z "$TOKEN" ]; then
  TOKEN=$(gcloud auth print-access-token)
fi

echo "Installing apigeecli"
curl -s https://raw.githubusercontent.com/apigee/apigeecli/main/downloadLatest.sh | bash
export PATH=$PATH:$HOME/.apigeecli/bin

gcloud config set project "$APIGEE_PROJECT"

gcloud iam service-accounts create apigee-logger --description="Logging client" --display-name="apigee-logger"

sleep 5

gcloud projects add-iam-policy-binding "$APIGEE_PROJECT" --member="serviceAccount:apigee-logger@$APIGEE_PROJECT.iam.gserviceaccount.com" --role="roles/logging.logWriter"

echo "Deploying Apigee artifacts..."

echo "Importing and Deploying Apigee apigee-logger-v1 sharedflow..."
REV_SF=$(apigeecli sharedflows create bundle -f ./sharedflowbundle -n cloud-logging-v1 --org "$APIGEE_PROJECT" --token "$TOKEN" --disable-check | jq ."revision" -r)
apigeecli sharedflows deploy --name cloud-logging-v1 --ovr --rev "$REV_SF" --org "$APIGEE_PROJECT" --env "$APIGEE_ENV" --token "$TOKEN" --sa "apigee-logger@$APIGEE_PROJECT.iam.gserviceaccount.com"

