<template>
  <Toast position="bottom-right" group="br"/>
  <Dialog header="CSV-Import" v-model:visible="showModal" :style="{width: '50vw'}" :modal="true"
          :dismissableMask="true">
    <FileUpload name="csv" :customUpload="true" @uploader="myUploader" :multiple="false" :fileLimit="1" accept=".csv"
                :maxFileSize="1000000">
      <template #empty>
        <p>Drag and drop files to here to upload.</p>
      </template>
    </FileUpload>
  </Dialog>
  <Button @click="openModal" label="CSV-Import" icon="pi pi-database" class="p-button-primary"/>
</template>

<script>
import Button from "primevue/button";
import {ref} from "vue";
import Dialog from "primevue/dialog";
import FileUpload from "primevue/fileupload";
import axios from "axios";
import {baseUrl} from "../../config";
import {useToast} from "primevue/usetoast";
import Toast from "primevue/toast";
import {showErrorToast, showSuccessToast} from "@/helper";
import {useRouter} from "vue-router";

export default {
  name: 'CsvImport',
  components: {Button, Dialog, FileUpload, Toast},
  setup() {
    const toast = useToast()
    const router = useRouter()
    const showModal = ref(false);

    function openModal() {
      showModal.value = true;
    }

    function myUploader(event) {
      axios.post(baseUrl + "/importCSV", event.files[0]).then((res) => {
        showSuccessToast(toast, res.data)
      }).catch((err) => {
        showErrorToast(toast, err)
      }).finally(() => {
        showModal.value = false;
        router.push("/transactions")
      })
    }

    return {openModal, showModal, myUploader}
  }
}
</script>
