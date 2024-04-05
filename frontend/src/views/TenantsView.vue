<template>
  <Dialog v-model:visible="historyDialog" :modal="true" :dismissableMask="true" :closable="true"
          @hide="onHide" style="min-width: 50vw">
    <DataTable ref="dataTable" :value="history" responsiveLayout="scroll" class="w-full mb-3">
      <template v-if="history.length>0 && createPdfDialog" #header>
        <div class="flex justify-content-between mb-5">
          <div class="flex flex-column">
            <div>{{ history[0].firstName }} {{ history[0].lastName }}</div>
            <div>{{ history[0].street }} {{ history[0].streetNo }}</div>
            <div>{{ history[0].zipCode }} {{ history[0].city }}</div>
            <div>{{ history[0].country }}</div>
          </div>
          <div class="flex flex-column align-items-end">
            <div>Date: {{ dateFormat(new Date()) }}</div>
            <div>Month: {{ selected.month + "." + selected.year }}</div>
          </div>
        </div>
      </template>
      <Column header="Date">
        <template #body="slotProps">
          {{ dateFormat(slotProps.data.transactionDate) }}
        </template>
      </Column>
      <Column field="transactionReason" header="Reason"></Column>
      <Column field="amount" header="Amount" style="text-align: right">
        <template #body="slotProps">
          {{ convertToCurrency(slotProps.data.amount) }}
        </template>
      </Column>
      <template #footer>
        <div class="flex justify-content-end">
          {{ convertToCurrency(totalAmount) }}
        </div>
      </template>
      <template #empty>
        No transactions found.
      </template>
    </DataTable>
    <div v-if="createPdfDialog">
      <Dropdown v-model="selected.month" :options="months" optionLabel="label" optionValue="value"
                placeholder="Month" @change="fetchPdfData" class="mr-2"/>
      <Dropdown v-model="selected.year" :options="years" optionLabel="label" optionValue="value"
                placeholder="Year" @change="fetchPdfData" class="mr-2"/>
      <Button icon="pi pi-file-pdf" @click="createPdf"
              label="PDF"/>
    </div>
  </Dialog>
  <PersonTable :clickable="true" :persons="tenants" :is-loading="isLoading"
               @showHistory="(id, amount)=>showHistory(id, amount)"
               @createPdf="(id)=>openPdfDialog(id)"/>
</template>

<script>
import {onMounted, reactive, ref} from 'vue';
import axios from "axios";
import {baseUrl} from "../../config";
import PersonTable from "@/components/PersonTable";
import {convertToCurrency, dateFormat, showErrorToast} from "@/helper";
import {useToast} from "primevue/usetoast";
import Dialog from "primevue/dialog";
import Column from "primevue/column";
import DataTable from "primevue/datatable";
import Button from "primevue/button";
import Dropdown from "primevue/dropdown";
import moment from "moment";
import {buildPdfAndSave,} from "@/pdf";


export default {
  name: 'TenantsView',
  components: {PersonTable, Dialog, DataTable, Column, Button, Dropdown},
  setup() {
    const dataTable = ref()
    const toast = useToast()
    const isLoading = ref(true)
    const tenants = ref();
    const historyDialog = ref(false);
    const history = ref([]);
    const totalAmount = ref(0);
    const createPdfDialog = ref(false);
    const currentUserId = ref();
    const years = [...Array(26)].map((_, index) => {
      return {label: index + 2000, value: index + 2000};
    })
    const months = [...Array(12)].map((_, index) => {
      return {label: index + 1, value: index + 1};
    })
    const selected = reactive({
      month: moment().month() + 1,
      year: moment().year(),
    })

    onMounted(() => {
      axios.get(baseUrl + "/tenants").then((res) => {
        tenants.value = res.data;
      }).catch((err) => {
        showErrorToast(toast, err);
      }).finally(() => {
        isLoading.value = false;
      })
    })

    function showHistory(id, amount) {
      totalAmount.value = amount
      axios.get(baseUrl + "/transactions/" + id).then((res) => {
        history.value = res.data;
      }).catch((err) => {
        showErrorToast(toast, err);
      })
      historyDialog.value = true;
    }

    function openPdfDialog(id) {
      currentUserId.value = id
      fetchPdfData().then(() => {
        createPdfDialog.value = true;
        historyDialog.value = true;
      })
    }

    function createPdf() {
      fetchPdfData().then(() => {
        buildPdfAndSave(history.value, selected, totalAmount.value)
      })
    }

    function fetchPdfData() {
      return axios.get(baseUrl + "/transactions/" + currentUserId.value + "/" + selected.month + "/" + selected.year).then((res) => {
        history.value = res.data;
        let total = 0;
        for (let i = 0; i < history.value.length; i++) {
          total += history.value[i].amount;
        }
        (total !== totalAmount.value) && (totalAmount.value = total);
      }).catch((err) => {
        showErrorToast(toast, err);
      })
    }

    function onHide() {
      totalAmount.value = 0;
      history.value = [];
      createPdfDialog.value = false;
    }

    return {
      tenants,
      isLoading,
      showHistory,
      historyDialog,
      history,
      createPdf,
      dataTable,
      dateFormat,
      totalAmount,
      onHide,
      convertToCurrency,
      createPdfDialog,
      years,
      months,
      selected,
      openPdfDialog,
      fetchPdfData,
    }
  }
}
</script>
