public with sharing class ObjectFieldsHandler {
  @AuraEnabled(cacheable=true)
  public static List<Map<String, String>> getObjectFields(String objectName) {
    // List to hold the field options
    List<Map<String, String>> fields = new List<Map<String, String>>();

    // Get the object describe information
    Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
    if (sObjectType != null) {
      Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();

      // Loop through each field and get its label and API name
      Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
      for (Schema.SObjectField field : fieldMap.values()) {
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

        // Create a map for each field's label and API name
        Map<String, String> fieldInfo = new Map<String, String>();
        fieldInfo.put('label', fieldDescribe.getLabel());
        fieldInfo.put('value', fieldDescribe.getName());
        fieldInfo.put('type', fieldDescribe.getType().name());

        // Add the field to the list
        fields.add(fieldInfo);
      }
    }

    return fields;
  }
}
