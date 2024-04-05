<template>
  <div class="home flex justify-content-center w-full">
    <ProgressSpinner v-if="isLoading"/>
    <DataTable dataKey="propertyId" v-else :filters="filters" :value="properties" responsiveLayout="scroll"
               class="w-full">
      <template #header>
        <div class="table-header flex align-items-center justify-content-between">
          <Button label="New" icon="pi pi-plus" class="p-button-success mr-2" @click="openNew"/>
          <span class="p-input-icon-left">
            <i class="pi pi-search"/>
            <InputText v-model="filters['global'].value"
                       placeholder="Search..."/>
          </span>
        </div>
      </template>

      <Column field="street" header="Address">
        <template #body="slotProps">
          <div class="flex flex-column">
            <div>{{ slotProps.data.street }} {{ slotProps.data.streetNo }}</div>
            <div>{{ slotProps.data.zipCode }} {{ slotProps.data.city }}</div>
            <div>{{ slotProps.data.country }}</div>
          </div>
        </template>
      </Column>
      <Column hidden field="streetNo"></Column>
      <Column hidden field="zipCode"></Column>
      <Column hidden field="city"></Column>
      <Column hidden field="country"></Column>
      <Column field="description" header="Description"></Column>
      <Column field="owner.fullName" header="Owner"></Column>
      <Column field="squareMeter" header="Size">
        <template #body="slotProps">
          {{ slotProps.data.squareMeter }} ㎡
        </template>
      </Column>
      <Column :exportable="false" style="text-align: right">
        <template #body="slotProps">
          <Button icon="pi pi-pencil" class="p-button-rounded p-button-success mr-2"
                  @click="editProperty(slotProps.data)"/>
          <Button icon="pi pi-trash" class="p-button-rounded p-button-warning"
                  @click="confirmDeleteProperty(slotProps.data)"/>
        </template>
      </Column>
      <template #empty>
        No properties found.
      </template>
    </DataTable>
  </div>

  <Dialog v-model:visible="propertyDialog" :style="{minWidth: '50vw'}" header="Property Details" :modal="true"
          :dismissableMask="true" class="p-fluid">
    <div class="field">
      <label for="owner">Owner</label>
      <Dropdown id="owner" v-model="v$.ownerId.$model" :options="owners" optionLabel="fullName" optionValue="ownerId"
                placeholder="Select owner" :class="{'p-invalid':v$.ownerId.$invalid && submitted}"/>
    </div>
    <div class="grid">
      <div class="field col-12 md:col-8">
        <label for="street">Street</label>
        <InputText id="street" v-model.trim="v$.street.$model" autofocus
                   :class="{'p-invalid':v$.street.$invalid && submitted}"/>
      </div>
      <div class="field col-12 md:col-4">
        <label for="nr">Number</label>
        <InputText id="nr" v-model.trim="v$.streetNo.$model" :class="{'p-invalid':v$.streetNo.$invalid && submitted}"/>
      </div>
    </div>
    <div class="grid">
      <div class="field col">
        <label for="zip">Zip</label>
        <InputText id="zip" v-model.trim="v$.zipCode.$model" :class="{'p-invalid':v$.zipCode.$invalid && submitted}"/>
      </div>
      <div class="field col">
        <label for="zip">City</label>
        <InputText id="zip" v-model.trim="v$.city.$model" :class="{'p-invalid':v$.city.$invalid && submitted}"/>
      </div>
    </div>
    <div class="field">
      <label for="country">Country</label>
      <InputText id="country" v-model.trim="v$.country.$model" :class="{'p-invalid':v$.country.$invalid && submitted}"/>
    </div>
    <div class="field">
      <label for="description">Description</label>
      <Textarea id="description" v-model="v$.description.$model" required="true" rows="3" cols="20"
                :class="{'p-invalid':v$.description.$invalid && submitted}"/>
    </div>
    <div class="field">
      <label for="squareMeter">Size (㎡)</label>
      <InputText id="squareMeter" v-model.trim="v$.squareMeter.$model"
                 :class="{'p-invalid':v$.squareMeter.$invalid && submitted}"/>
    </div>
    <template #footer>
      <Button label="Cancel" icon="pi pi-times" class="p-button-text" @click="hideDialog"/>
      <Button label="Save" icon="pi pi-check" class="p-button-text" @click="saveProperty(!v$.$invalid)"/>
    </template>
  </Dialog>

  <Dialog v-model:visible="deletePropertyDialog" :style="{width: '450px'}" header="Confirm" :modal="true"
          :dismissableMask="true">
    <div class="confirmation-content">
      <i class="pi pi-exclamation-triangle mr-3" style="font-size: 2rem"/>
      <span v-if="property">Are you sure you want to delete <b>{{ property.description }}</b>?</span>
    </div>
    <template #footer>
      <Button label="No" icon="pi pi-times" class="p-button-text" @click="deletePropertyDialog = false"/>
      <Button label="Yes" icon="pi pi-check" class="p-button-text" @click="deleteProperty"/>
    </template>
  </Dialog>
</template>

<script>
import Button from "primevue/button";
import axios from "axios";
import {onMounted, ref} from 'vue';
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import ProgressSpinner from "primevue/progressspinner";
import {baseUrl} from "../../config";
import InputText from "primevue/inputtext";
import {FilterMatchMode} from "primevue/api";
import Dialog from "primevue/dialog";
import Textarea from "primevue/textarea";
import Toast from "primevue/toast";
import {useToast} from "primevue/usetoast";
import {dateFormat, showErrorToast, showSuccessToast} from "@/helper";
import {required, integer, decimal, maxLength} from "@vuelidate/validators";
import useVuelidate from "@vuelidate/core";
import Dropdown from "primevue/dropdown";

export default {
  name: 'PropertiesView',
  components: {
    Button, Column, DataTable, Toast, ProgressSpinner, InputText, Dialog, Textarea, Dropdown
  },
  setup() {
    const toast = useToast();
    const property = ref({})
    const rules = {
      squareMeter: {required, decimal},
      street: {required, maxLengthValue: maxLength(45)},
      streetNo: {required, maxLengthValue: maxLength(10)},
      zipCode: {required, integer},
      city: {required, maxLengthValue: maxLength(45)},
      country: {required, maxLengthValue: maxLength(45)},
      description: {required, maxLengthValue: maxLength(300)},
      ownerId: {required}
    };
    const submitted = ref(false);
    const v$ = useVuelidate(rules, property);

    const properties = ref([]);
    const owners = ref([]);
    const selectedOwner = ref({});
    const isLoading = ref(true);
    const propertyDialog = ref(false);
    const deletePropertyDialog = ref(false);
    const filters = ref({
      'global': {value: null, matchMode: FilterMatchMode.CONTAINS},
    });

    onMounted(() => {
      axios.get(baseUrl + "/property").then((res) => {
        properties.value = res.data;
        axios.get(baseUrl + "/owners").then((res) => {
          owners.value = res.data;
          owners.value.map((owner) => {
            owner.fullName = owner.firstname + " " + owner.lastname
          })
          properties.value.map((prop) => {
            prop.owner = owners.value.find((owner) => owner.ownerId === prop.ownerId)
          })
        })
      }).catch((err) => {
        showErrorToast(toast, err)
      }).finally(() => {
        isLoading.value = false;
      })
    })
    const hideDialog = () => {
      submitted.value = false;
      propertyDialog.value = false;
    };
    const editProperty = (prop) => {
      property.value = {...prop};
      propertyDialog.value = true;
    };
    const confirmDeleteProperty = (prop) => {
      property.value = prop;
      deletePropertyDialog.value = true;
    };
    const deleteProperty = () => {
      axios.delete(baseUrl + "/property/" + property.value.propertyId).then(() => {
        properties.value = properties.value.filter(val => val.propertyId !== property.value.propertyId);
        showSuccessToast(toast, "Property deleted")
        property.value = {};
      }).catch(() => {
        showErrorToast(toast, "Cannot delete Property")
      })
      deletePropertyDialog.value = false;
    };
    const saveProperty = (isFormValid) => {
      submitted.value = true;

      if (!isFormValid) {
        return;
      }
      if (!property.value.propertyId) {
        axios.post(baseUrl + "/property", property.value).then(() => {
          axios.get(baseUrl + "/property").then((res) => {
            properties.value = res.data;
          })
        }).catch(() => {
          showErrorToast(toast, "Cannot create Property")
        })
      } else {
        axios.put(baseUrl + "/property/" + property.value.propertyId, property.value).then(() => {
          const index = properties.value.findIndex((val) => val.propertyId === property.value.propertyId)
          properties.value[index] = property.value
          properties.value.map((prop) => {
            prop.owner = owners.value.find((owner) => owner.ownerId === prop.ownerId)
          })
          property.value = {};
          showSuccessToast(toast, "Property saved")
        }).catch(() => {
          showErrorToast(toast, "Cannot save Property")
        })
      }
      propertyDialog.value = false;
    };
    const openNew = () => {
      property.value = {};
      submitted.value = false;
      propertyDialog.value = true;
    };

    return {
      properties,
      property,
      isLoading,
      filters,
      editProperty,
      confirmDeleteProperty,
      deleteProperty,
      deletePropertyDialog,
      propertyDialog,
      hideDialog,
      saveProperty,
      openNew,
      v$,
      submitted,
      dateFormat,
      selectedOwner,
      owners,
    }
  }
}
</script>
