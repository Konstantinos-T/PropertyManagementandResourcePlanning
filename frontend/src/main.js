import {createApp} from 'vue'
import App from './App.vue'
import store from './store'
import PrimeVue from "primevue/config";
import Router from "@/router";
import mdiVue from 'mdi-vue/v3';
import * as mdijs from '@mdi/js';
import ToastService from 'primevue/toastservice';

import "primevue/resources/themes/lara-light-indigo/theme.css";
import "primevue/resources/primevue.min.css";
import "primeicons/primeicons.css";
import "primeflex/primeflex.css";

const app = createApp(App);

app.use(Router)
app.use(PrimeVue);
app.use(store);
app.use(mdiVue, {
    icons: mdijs
});
app.use(ToastService);

app.mount("#app");
