public with sharing class ObjectHandler {
  @AuraEnabled(cacheable=true)
  public static List<Map<String, String>> getAllObjects() {
    List<Map<String, String>> objectsList = new List<Map<String, String>>();
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

    Set<String> standardObjects = new Set<String>();
    Set<String> customObjects = new Set<String>();

    // Iterate through all SObject types in the schema
    for (Schema.SObjectType d : schemaMap.values()) {
      Schema.DescribeSObjectResult ds = d.getDescribe();
      if (!ds.isCreateable()) {
        continue; // Skip non-creatable objects
      }
      if (!ds.isCustom() && ds.getRecordTypeInfos().size() > 0) {
        standardObjects.add(ds.getName()); // Collect standard objects
      } else if (ds.isCustom()) {
        customObjects.add(ds.getName()); // Collect custom objects
      }
    }

    // Combine standard and custom objects into objectsList
    for (String name : standardObjects) {
      Schema.DescribeSObjectResult ds = schemaMap.get(name).getDescribe(); // Get describe for standard object
      Map<String, String> option = new Map<String, String>();
      option.put('label', ds.getLabel()); // Use the object's label as the label
      option.put('value', ds.getName()); // Use the API name as the value
      objectsList.add(option);
    }

    for (String name : customObjects) {
      Schema.DescribeSObjectResult ds = schemaMap.get(name).getDescribe(); // Get describe for custom object
      Map<String, String> option = new Map<String, String>();
      option.put('label', ds.getLabel()); // Use the object's label as the label
      option.put('value', ds.getName()); // Use the API name as the value
      objectsList.add(option);
    }

    return objectsList;
  }
}
