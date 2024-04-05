<template>
  <Menubar :model="items">
    <template #start>
      <mdicon class="mr-5" name="home-city-outline" size="40"/>
    </template>
    <template #end>
      <CsvImport/>
    </template>
  </Menubar>
</template>

<script>
import {ref} from 'vue';
import Menubar from "primevue/menubar";
import Button from "primevue/button";
import CsvImport from "@/components/CsvImport";

export default {
  name: 'TheNavigation',
  components: {
    CsvImport,
    Menubar,
    Button
  },
  setup() {
    const items = ref([
      {
        label: 'Properties',
        icon: 'pi pi-fw pi-map-marker',
        to: "/properties"
      },
      {
        label: 'Tenants',
        icon: 'pi pi-fw pi-users',
        to: "/tenants"
      },
      {
        label: 'Managers',
        icon: 'pi pi-fw pi-users',
        to: "/managers"
      },
      {
        label: 'Owners',
        icon: 'pi pi-fw pi-users',
        to: "/owners"
      },
      {
        label: 'Transactions',
        icon: 'pi pi-fw pi-wallet',
        to: "/transactions"
      },
    ]);

    return {items}
  }
}
</script>
