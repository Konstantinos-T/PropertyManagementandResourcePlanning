<template>
  <PersonTable :persons="managers" :is-loading="isLoading"/>
</template>

<script>
import {onMounted, ref} from "vue";
import axios from "axios";
import {baseUrl} from "../../config";
import PersonTable from "@/components/PersonTable";
import {showErrorToast} from "@/helper";
import {useToast} from "primevue/usetoast";

export default {
  name: 'ManagersView',
  components: {PersonTable},
  setup() {
    const toast = useToast()
    const isLoading = ref(true)
    const managers = ref();

    onMounted(() => {
      axios.get(baseUrl + "/manager").then((res) => {
        managers.value = res.data;
      }).catch((err) => {
        showErrorToast(toast, err);
      }).finally(() => {
        isLoading.value = false;
      })
    })

    return {managers, isLoading}
  }
}
</script>
