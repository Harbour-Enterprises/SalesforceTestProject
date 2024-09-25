import { LightningElement, track } from "lwc";

export default class TemplateSettings extends LightningElement {
  @track availableTemplates = [
    { label: "1", value: "1" },
    { label: "2", value: "2" },
    { label: "3", value: "3" }
  ];
  @track selectedTemplate;

  //   async getTemplates(){
  //     try()
  //   }

  handleSelectedTemplateChange(event) {
    this.selectedTemplate = event.detail.value;
  }
}
