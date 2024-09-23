# Salesforce LWC Test Project: Template Settings Page

## Project Overview

This test project aims to evaluate technical skills in developing Lightning Web Components (LWC) and working with Salesforce's ecosystem. The project involves creating a 'Settings' page that allows authorized users to manage template mappings between an external API and Salesforce Object Fields.

## Objectives

1. Create a Lightning Web Component for the Settings page
2. Implement user authorization to restrict access to the Settings page
3. Integrate with Harbour's API to fetch available templates
4. Display template inputs and allow mapping to Salesforce Object Fields
5. Store and persist mappings in a custom Salesforce object

## Detailed Requirements

### 1. Lightning Web Component

- Create a new LWC called `templateSettings`
- The component should have a clean, user-friendly interface
- Implement proper error handling and loading states

### 2. User Authorization

- Restrict access to the Settings page to users with a specific custom permission
- Implement server-side and client-side checks for authorization

### 3. API Integration

- Integrate with Harbour's API to fetch all available templates
- Use Named Credentials to securely store API credentials
- Implement proper error handling for API calls

### 4. Template Display and Mapping

- Display a list of all templates retrieved from the API
- When a template is selected, show all its inputs
- Clearly indicate which inputs are required
- Provide a way to map each input to a Salesforce Object Field
- Implement type checking to ensure compatible field types are mapped

### 5. Data Storage

- Create a custom object called `Template_Mapping__c` to store the mappings
- The object should have fields for:
  - Template ID
  - Input ID
  - Salesforce Object API Name
  - Salesforce Field API Name
- Implement CRUD operations for this object in Apex

### 6. Persistence

- Ensure that mappings are saved and can be retrieved across different sessions
- Implement a way to edit existing mappings

## Example Mapping

```
Template ID: template_123
Input ID: abc123
Salesforce Object API Name: Opportunity
Salesforce Field API Name: Account.Name
```

## Evaluation Criteria

1. Code quality and organization
2. Proper use of Lightning Web Components
3. Salesforce best practices and security considerations
4. Error handling and user experience
5. Apex code quality (if used for backend operations)
6. Proper use of custom objects and fields
7. API integration implementation
8. Overall solution design and scalability

## Submission Guidelines

1. Create a new Salesforce Developer Edition org for this project
2. Develop the solution in your org
3. Use GitHub to version control your code
4. Provide clear documentation on how to deploy and test your solution
5. Include any assumptions made during development

## Time Frame

Please complete this project within 5 business days.

Good luck!