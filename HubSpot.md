# HubSpot configuration

To make the MEDDIC roles classification work, please, make the following configurations in your HubSpot Data Model.


## Contacts configuration

Create the `MEDDIC Properties` group and add the following properties to it.

| Property Label | Internal Name | Property Type | Purpose |
| --- | --- | --- | --- |
| Work Experience | work_experience | Multi-line Text | Input to the classification workflow in n8n |
| Possible Role | middic_possible_role | Single-line text | Output of the classification workflow | 
| Possible Role Rationale | middic_possible_role_rationale | Single-line text | Output of the classification workflow |
| Clarified Role | meddic_role | Dropdown select (see the options below) | To be set manually with the role clarified by human |

### Options for meddic_role

| Option Label | Internal Name |
| --- | --- |
| Irrelevant | IRRELEVANT |
| Economic Buyer | ECONOMIC_BUYER |
| Champion | CHAMPION |
| Coach | COACH |


## Contact View

To display these properties on the Contact page, edit its Default view using the Customize button. 
Then, add a card with a list of properties and include the properties listed above.


## Properties used as input

Script enriches the Possible Role and Rationale only for contact records with the following properties set.

### Contact

* First Name
* Last Name
* Employment Seniority
* Employment Role
* Employment Sub Role
* Work Experience

### Contact's Company

* Name
* Industry
* Number of Employees
* Annual Revenue
* Year Founded
* Country


## HubSpot API Token

Create a legacy private App in your HubSpot account:
1. Go to Development → Legacy Apps
2. Create a new app with scopes listed below
3. Copy the access token 
4. Set the access token as `HUBSPOT_APP_TOKEN` environment variable within `.env` file

### App Scopes

* crm.objects.companies.highly_sensitive.read
* crm.objects.companies.read
* crm.objects.companies.sensitive.read
* crm.objects.contacts.highly_sensitive.read
* crm.objects.contacts.read
* crm.objects.contacts.sensitive.read
* crm.objects.contacts.write


