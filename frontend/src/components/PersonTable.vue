<template>
  <div class="home flex justify-content-center w-full">
    <ProgressSpinner v-if="isLoading"/>
    <DataTable v-else :value="persons" responsiveLayout="scroll" class="w-full">
      <Column field="firstname" header="First Name"></Column>
      <Column field="lastname" header="Last Name"></Column>
      <Column header="Date Of Birth">
        <template #body="slotProps">
          {{ dateFormat(slotProps.data.dateOfBirth) }}
        </template>
      </Column>
      <Column v-if="balanceIncluded" header="Balance">
        <template #body="slotProps">
          <span :class="{'text-red-500':amountNegative(slotProps.data.balance ?? 0),
               'text-green-500':!amountNegative(slotProps.data.balance ?? 0)}">
            {{ convertToCurrency(slotProps.data.balance ?? 0) }}
          </span>
        </template>
      </Column>
      <Column v-if="clickable" style="text-align: right">
        <template #body="slotProps">
          <Button icon="pi pi-clock" @click="$emit('showHistory',slotProps.data.tenantId, slotProps.data.balance ?? 0)"
                  label="History" class="mr-2"/>
          <Button icon="pi pi-file-pdf" @click="$emit('createPdf', slotProps.data.tenantId)"
                  label="PDF"/>
        </template>
      </Column>
      <template #empty>
        No persons found.
      </template>
    </DataTable>
  </div>
</template>

<script>
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import ProgressSpinner from "primevue/progressspinner";
import {computed, ref} from "vue";
import {amountNegative, convertToCurrency, dateFormat} from "@/helper";
import Button from "primevue/button";

export default {
  name: 'PersonTable',
  components: {
    DataTable, Column, ProgressSpinner, Button
  },
  emits: ["showHistory", "createPdf"],
  props: {
    persons: {type: Array, default: []},
    isLoading: {type: Boolean, default: true},
    clickable: {type: Boolean, default: false},
  },
  setup(props) {
    const managers = ref();

    const balanceIncluded = computed(() => props.persons.length > 0 ? props.persons[0].hasOwnProperty("balance")
        :
        false
    )

    return {managers, dateFormat, balanceIncluded, convertToCurrency, amountNegative}
  }
}
</script>
