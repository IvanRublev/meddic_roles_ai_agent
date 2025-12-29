# MEDDIC Roles AI Agent

[![n8n Workflows](https://github.com/IvanRublev/meddic_roles_ai_agent/actions/workflows/validate-n8n-workflows.yml/badge.svg)](https://github.com/IvanRublev/meddic_roles_ai_agent/actions/workflows/validate-n8n-workflows.yml)

An AI agent that enriches HubSpot CRM contacts with [MEDDIC roles](https://www.atlassian.com/blog/project-management/meddic-sales-methodology), such as Economic Buyer, Champion, Coach or Irrelevant.

### What it does
- Scans HubSpot CRM for added contacts every five minutes
- Classifies the MEDDIC role of a contact based their company, employment role, and work experience
- Updates HubSpot with the Possible MEDDIC role name and rationale for classification

For classification to work, all input properties in HubSpot for the contact and associated company must have set values.
See the "Properties used as input" section in [HubSpot.MD](HubSpot.MD).
These properties can be enriched using methods not covered in this repository.

### Technical stack
- [n8n](https://n8n.io/) workflow for execution
- OpenAI [gpt-5-nano](https://platform.openai.com/docs/models/gpt-5-nano) model for classification
- [PostgreSQL](https://www.postgresql.org/) to persist workflow data

Implemented as a Docker Compose setup that can run on the local machine. See the "Setup" section below.

Can be deployed on any cloud provider due to the compatible technical stack.
Please, contact the author for assistance (https://ivanrublev.com).


## Limitations

A contact's MEDDIC role will be classified if the following conditions are met:
* All of the input HubSpot properties have a value (see the "Properties used as input" section in [HubSpot.MD](HubSpot.MD))
* Only one company is associated with the contact in HubSpot

To re-run the classification for the contact, any of the input HubSpot properties for the contact or associated company must have a new value, and the `Possible Role` property must be empty. 


## Scalability

Classifying one contact role takes about ~28K tokens. 

With a rate limit of ~5M tokens per minute on the OpenAI side, 
it's possible to classify about 170 contacts per minute.

The current version of the workflow processes contacts one by one in batches of ten.

It can be parallelized by extracting the "Get HubSpot Contacts for Enrichment" call
from the "MEDDIC Roles AI Agent" workflow. Then, the latter can be called 
with seventeen batches of contacts for enrichment as input.


## Setup

1. Copy the `.env-example` file to `.env` and specify the service tokens, keys, and database password 
    * See "HubSpot API Token" in [HubSpot.MD](HubSpot.MD)
    * OpenAI API Key can be created on the [developer platform](https://platform.openai.com/api-keys)
2. Run the containers with the `docker-compose up` command
3. Open the n8n web interface which is on port 5678 by default by opening the `http://localhost:5678` URL in a browser
4. Register the admin user in the web UI
5. Run the `setup.sh` script to import credentials to n8n and set up the database
6. In the n8n web interface import all files from the `workflows/` directory with the following
    * Create a workflow, then choose the three dots → Import from file, press the Save button followed by the Publish button, repeat for each file
    * To publish **3. MEDDIC Roles AI Agent** workflow choose the appropriate subworkflow from the dropdown list in `Get HubSpot Contacts for Enrichment` and each `Add LLM Stats` nodes
8. Configure the HubSpot data model as specified in [HubSpot.MD](HubSpot.MD)
9. Start to add the contacts with required properties to the HubSpot


## License

Copyright © 2026 Ivan Rublev

This project is licensed under the **MIT License**.