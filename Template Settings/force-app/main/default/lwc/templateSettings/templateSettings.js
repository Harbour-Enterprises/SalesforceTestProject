import { LightningElement, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getTemplates from "@salesforce/apex/TemplateSettings.getTemplates";
import getAllObjects from "@salesforce/apex/ObjectHandler.getAllObjects";
import getObjectFields from "@salesforce/apex/ObjectFieldsHandler.getObjectFields";
import createTemplateMapping from "@salesforce/apex/TemplateMappingHandler.createTemplateMapping";

export default class TemplateSettings extends LightningElement {
  @track availableTemplates = [];
  @track selectedTemplate = "";
  @track templateInputs = [];
  @track allObjects = []; // Array to hold object names
  @track selectedObject = "";
  @track error;

  fullTemplateData = [];

  connectedCallback() {
    this.loadTemplates();
  }

  @wire(getAllObjects)
  wiredObjects({ error, data }) {
    if (data) {
      this.allObjects = data.map((obj) => ({
        label: obj.label,
        value: obj.value
      }));
    } else if (error) {
      console.error("Error retrieving objects:", error);
    }

    this.allObjects.sort((a, b) => a.label.localeCompare(b.label));
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
      this.showToast("Failed", "Error fetching templates:" + error, "error");
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

  handleObjectChange(event) {
    const selectedObject = event.detail.value; // Get selected object directly from event
    const inputId = event.target.dataset.id; // Get input id from the dataset

    // Update the selected object in the map, keyed by input.id
    this.templateInputs = this.templateInputs.map((input) => {
      if (input.id === inputId) {
        return { ...input, selectedObject }; // Update the selectedObject for this input
      }
      return input;
    });

    // Fetch the object fields for the selected object using Apex
    getObjectFields({ objectName: selectedObject })
      .then((fields) => {
        // Map through the templateInputs and update the specific input with its fields
        this.templateInputs = this.templateInputs.map((input) => {
          if (input.id === inputId) {
            // Filter fields based on input.fieldType
            const filteredFields = fields.filter((field) => {
              if (input.isTextInput) {
                // Filter for String fields only
                return field.type === "STRING";
              } else if (input.isImageInput) {
                return field.type === "TEXTAREA"; // Adjust this based on actual field types for images
              }
              return false; // Default case if no matching type
            });

            return {
              ...input,
              fields: filteredFields // Attach the fields to the selected input
            };
          }
          return input;
        });
      })
      .catch((error) => {
        console.error("Error fetching object fields: ", error);
      });
  }

  handleObjectFieldChange(event) {
    const selectedObjectField = event.detail.value;
    const inputId = event.target.dataset.id; // Get input id from the dataset

    this.templateInputs = this.templateInputs.map((input) => {
      if (input.id === inputId) {
        return { ...input, selectedObjectField }; // Update the selectedObjectField for this input
      }
      return input;
    });
  }

  handleSaveClick() {
    const selectedTemplateData = this.fullTemplateData.find(
      (template) => template.value === this.selectedTemplate
    );
    this.templateInputs.forEach((input) => {
      input.template_id = selectedTemplateData.id;
    });

    // Loop through each templateInput and create corresponding Template_Mapping__c records
    const savePromises = this.templateInputs.map((input) => {
      return createTemplateMapping({
        templateId: input.template_id, // Replace with actual template ID
        inputId: input.id,
        objectApiName: input.selectedObject,
        fieldApiName: input.selectedObjectField // Assuming this holds the selected field's API name
      })
        .then((result) => {
          console.log("Mapping created successfully: ", result);
        })
        .catch((error) => {
          this.showToast("Error", "Error creating mapping" + error, "error");
        });
    });

    // Wait for all promises to resolve
    Promise.all(savePromises)
      .then(() => {
        this.showToast(
          "Success",
          "All mappings created successfully",
          "success"
        );
      })
      .catch((error) => {
        this.showToast("Error", "Error creating mapping" + error, "error");
      });
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }
}

// console.log(
//   "Current templateInputs:",
//   JSON.stringify(this.templateInputs, null, 2)
// );
