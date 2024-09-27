public with sharing class TemplateSettings {
  @AuraEnabled(cacheable=true)
  public static List<Map<String, Object>> getTemplates() {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:Harbourshare_v1/agreements');
    req.setMethod('GET');

    Http http = new Http();
    HttpResponse res;

    try {
      // Make the request
      res = http.send(req);
    } catch (Exception e) {
      throw new AuraHandledException(
        'Error getting the templates: ' + e.getMessage()
      );
    }

    if (res.getStatusCode() == 200) {
      try {
        // Parse the entire response body as JSON
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
          res.getBody()
        );

        // Extract the 'agreements' array from the response
        List<Object> agreements = (List<Object>) responseMap.get('agreements');
        List<Map<String, Object>> templateList = new List<Map<String, Object>>();

        // Loop through each agreement and extract required data
        for (Object agreementObj : agreements) {
          Map<String, Object> agreementMap = (Map<String, Object>) agreementObj;

          // Extract the fields
          String templateType = (String) agreementMap.get('template_type');
          String title = (String) agreementMap.get('title');
          String templateId = (String) agreementMap.get('id');

          // Extract the document_inputs array
          List<Object> documentInputs = (List<Object>) agreementMap.get(
            'document_inputs'
          );

          // Check if the item already exists in the templateList
          Boolean alreadyExists = false;
          for (Map<String, Object> existingAgreement : templateList) {
            if (
              existingAgreement.get('type') == templateType &&
              existingAgreement.get('value') == title
            ) {
              alreadyExists = true;
              break; // Exit the loop if a duplicate is found
            }
          }

          // Add to the list if it's not a duplicate
          if (!alreadyExists) {
            Map<String, Object> templateData = new Map<String, Object>();
            templateData.put('type', templateType);
            templateData.put('value', title);
            templateData.put('id', templateId);

            // Add document_inputs to the template data
            templateData.put('document_inputs', documentInputs);

            // Add the constructed template to the list
            templateList.add(templateData);
          }
        }

        // Return the list of templates with document_inputs
        return templateList;
      } catch (Exception e) {
        throw new AuraHandledException(
          'Error processing the response: ' + e.getMessage()
        );
      }
    } else {
      // Show the status code and response for non-200 responses
      throw new AuraHandledException(
        'Failed to fetch templates. Status Code: ' + res.getStatusCode()
      );
    }
  }

  // Default constructor
  public TemplateSettings() {
  }
}
