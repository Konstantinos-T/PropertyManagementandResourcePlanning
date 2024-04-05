<template>
  <PersonTable :persons="owners" :is-loading="isLoading"/>
</template>

<script>
import PersonTable from "@/components/PersonTable";
import {onMounted, ref} from "vue";
import axios from "axios";
import {baseUrl} from "../../config";
import {showErrorToast} from "@/helper";
import {useToast} from "primevue/usetoast";

export default {
  name: 'OwnersView',
  components: {PersonTable},
  setup() {
    const toast = useToast()
    const isLoading = ref(true)
    const owners = ref();


    onMounted(() => {
      axios.get(baseUrl + "/owners").then((res) => {
        owners.value = res.data;
      }).catch((err) => {
        showErrorToast(toast, err);
      }).finally(() => {
        isLoading.value = false;
      })
    })

    return {owners, isLoading}
  }
}
</script>
