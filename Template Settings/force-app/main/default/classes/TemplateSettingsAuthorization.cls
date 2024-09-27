public with sharing class TemplateSettingsAuthorization {
  // Check if the user has a custom permission on the server side
  @AuraEnabled
  public static Boolean hasAccess() {
    return FeatureManagement.checkPermission('Template_Settings');
  }
}
