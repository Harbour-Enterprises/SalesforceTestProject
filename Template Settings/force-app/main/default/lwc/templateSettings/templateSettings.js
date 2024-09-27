import { LightningElement, track } from "lwc";
import getTemplates from "@salesforce/apex/TemplateSettings.getTemplates";

export default class TemplateSettings extends LightningElement {
  @track availableTemplates = [];
  @track selectedTemplate = "";
  @track templateInputs = [];
  @track objects = []; // Array to hold object names
  @track fields = {}; // Object to hold fields by object name

  fullTemplateData = [];

  connectedCallback() {
    this.loadTemplates();
    this.getObjectsAndFields();
  }

  getObjectsAndFields() {
    this.objects = ["Account", "Contact", "Opportunity"];
    this.fields = {
      Account: ["Name", "Type", "Industry"],
      Contact: ["FirstName", "LastName", "Email"],
      Opportunity: ["StageName", "Amount", "CloseDate"]
    };
  }

  async loadTemplates() {
    try {
      const templates = await getTemplates();
      this.fullTemplateData = templates;
      this.availableTemplates = templates.map((template) => {
        // The template value is used in both places because the type may not be unique but the title likely would be
        return { label: template.value, value: template.value };
      });
    } catch (error) {
      console.error("Error fetching templates:", error);
    }
  }

  handleSelectedTemplateChange(event) {
    this.selectedTemplate = event.detail.value;

    // Find the selected template and set its inputs
    const selectedTemplateData = this.fullTemplateData.find(
      (template) => template.value === this.selectedTemplate
    );
    if (selectedTemplateData && selectedTemplateData.document_inputs) {
      this.templateInputs = selectedTemplateData.document_inputs.map(
        (input) => ({
          id: input.id,
          label: input.internal_label,
          required: input.is_required,
          placeholder: input.place_holder,
          preferredIcon: input.preferred_icon,
          isTextInput: input.field_type === "TEXTINPUT",
          isImageInput: input.field_type === "IMAGEINPUT"
        })
      );
    }
  }

  handleObjectChange(event, inputId) {
    // Handle the object selection change
    const selectedObject = event.detail.value;
    // You can do something with the selected object here, if needed
  }
}
