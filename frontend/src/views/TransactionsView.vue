<template>
  <div class="home flex justify-content-center w-full">
    <ProgressSpinner v-if="isLoading"/>
    <DataTable ref="dt" v-else :value="transactions" responsiveLayout="scroll" class="w-full">
      <Column header="Created">
        <template #body="slotProps">
          {{ dateFormat(slotProps.data.created) }}
        </template>
      </Column>
      <Column header="Imported">
        <template #body="slotProps">
          {{ dateFormat(slotProps.data.imported) }}
        </template>
      </Column>
      <Column field="bookingText" header="Text"></Column>
      <Column field="purpose" header="Purpose"></Column>
      <Column field="beneficialPayee" header="Beneficiary"></Column>
      <Column field="amount" header="Amount" style="text-align: right">
        <template #body="slotProps">
          <span :class="{'text-red-500':amountNegative(slotProps.data.amount),
               'text-green-500':!amountNegative(slotProps.data.amount)}">
            {{ convertToCurrency(slotProps.data.amount) }}
          </span>
        </template>
      </Column>
      <template #empty>
        No transactions found.
      </template>
    </DataTable>
  </div>
</template>

<script>
import Button from "primevue/button";
import Column from "primevue/column";
import DataTable from "primevue/datatable";
import Toast from "primevue/toast";
import ProgressSpinner from "primevue/progressspinner";
import InputText from "primevue/inputtext";
import Dialog from "primevue/dialog";
import Textarea from "primevue/textarea";
import {onMounted, ref} from 'vue';
import axios from "axios";
import {baseUrl} from "../../config";
import {amountNegative, convertToCurrency, showErrorToast} from "@/helper";
import moment from "moment";

export default {
  name: 'TransactionsView',
  components: {
    Button, Column, DataTable, Toast, ProgressSpinner, InputText, Dialog, Textarea
  },
  setup() {
    const isLoading = ref(true)
    const transactions = ref()

    onMounted(() => {
      axios.get(baseUrl + "/transactions").then((res) => {
        transactions.value = res.data;
      }).catch((err) => {
        showErrorToast(toast, err)
      }).finally(() => {
        isLoading.value = false;
      })
    })

    const dateFormat = (dateString) => {
      return moment(dateString).utc().format("DD.MM.YYYY HH:mm")
    }

    return {isLoading, transactions, dateFormat, convertToCurrency, amountNegative}
  }
}
</script>
