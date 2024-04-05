import {createRouter, createWebHistory} from 'vue-router'
import PropertiesView from "@/views/PropertiesView";
import TenantsView from "@/views/TenantsView";
import ManagersView from "@/views/ManagersView";
import OwnersView from "@/views/OwnersView";
import TransactionsView from "@/views/TransactionsView";

const routes = [
    {
        path: '/properties',
        name: 'Properties',
        component: PropertiesView
    },
    {
        path: '/tenants',
        name: 'Tenants',
        component: TenantsView
    },
    {
        path: '/managers',
        name: 'Managers',
        component: ManagersView
    },
    {
        path: '/owners',
        name: 'Owners',
        component: OwnersView
    },
    {
        path: '/transactions',
        name: 'Transactions',
        component: TransactionsView
    },
    {
        path: "/:catchAll(.*)",
        redirect: '/properties'
    }
]

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes
})

export default router
