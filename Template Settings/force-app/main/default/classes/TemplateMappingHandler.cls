public with sharing class TemplateMappingHandler {
  // Create operation
  @AuraEnabled
  public static Template_Mapping__c createTemplateMapping(
    String templateId,
    String inputId,
    String objectApiName,
    String fieldApiName
  ) {
    Template_Mapping__c mapping = new Template_Mapping__c(
      Template_ID__c = templateId,
      Input_ID__c = inputId,
      Salesforce_Object_API_Name__c = objectApiName,
      Salesforce_Field_API_Name__c = fieldApiName
    );
    insert mapping;
    return mapping;
  }

  // Read operations
  @AuraEnabled(cacheable=true)
  public static List<Template_Mapping__c> getAllTemplateMappings() {
    return [
      SELECT
        Id,
        Template_ID__c,
        Input_ID__c,
        Salesforce_Object_API_Name__c,
        Salesforce_Field_API_Name__c
      FROM Template_Mapping__c
    ];
  }

  @AuraEnabled(cacheable=true)
  public static List<Template_Mapping__c> getTemplateMappings(
    String templateId
  ) {
    return [
      SELECT
        Id,
        Template_ID__c,
        Input_ID__c,
        Salesforce_Object_API_Name__c,
        Salesforce_Field_API_Name__c
      FROM Template_Mapping__c
      WHERE Template_ID__c = :templateId
    ];
  }

  @AuraEnabled(cacheable=true)
  public static Template_Mapping__c getTemplateMappingByIds(
    String templateId,
    String inputId
  ) {
    List<Template_Mapping__c> mappings = [
      SELECT
        Id,
        Template_ID__c,
        Input_ID__c,
        Salesforce_Object_API_Name__c,
        Salesforce_Field_API_Name__c
      FROM Template_Mapping__c
      WHERE Template_ID__c = :templateId AND Input_ID__c = :inputId
      LIMIT 1
    ];
    return mappings.isEmpty() ? null : mappings[0];
  }

  // Update operation
  @AuraEnabled
  public static Template_Mapping__c updateTemplateMapping(
    Id mappingId,
    String templateId,
    String inputId,
    String objectApiName,
    String fieldApiName
  ) {
    Template_Mapping__c mapping = [
      SELECT
        Id,
        Template_ID__c,
        Input_ID__c,
        Salesforce_Object_API_Name__c,
        Salesforce_Field_API_Name__c
      FROM Template_Mapping__c
      WHERE Id = :mappingId
      LIMIT 1
    ];

    mapping.Template_ID__c = templateId;
    mapping.Input_ID__c = inputId;
    mapping.Salesforce_Object_API_Name__c = objectApiName;
    mapping.Salesforce_Field_API_Name__c = fieldApiName;

    update mapping;
    return mapping;
  }

  // Delete operation
  @AuraEnabled
  public static void deleteTemplateMapping(Id mappingId) {
    Template_Mapping__c mapping = [
      SELECT Id
      FROM Template_Mapping__c
      WHERE Id = :mappingId
      LIMIT 1
    ];
    delete mapping;
  }
}
