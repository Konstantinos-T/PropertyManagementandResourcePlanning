import moment from "moment";

export function showSuccessToast(toast, message) {
    toast.removeAllGroups();
    toast.add({
        severity: 'success',
        summary: 'Success',
        detail: message,
        group: 'br',
        life: 4000
    });
}

export function showErrorToast(toast, message) {
    toast.removeAllGroups();
    toast.add({
        severity: 'error',
        summary: 'Error',
        detail: message,
        group: 'br',
        life: 4000
    });
}

export function convertToCurrency(value) {
    return value.toLocaleString('de-DE', {style: "currency", currency: "EUR"});
}

export function amountNegative(amount) {
    return amount < 0;
}

export function dateFormat(dateString) {
    return moment(dateString).utc().format("DD.MM.YYYY")
}