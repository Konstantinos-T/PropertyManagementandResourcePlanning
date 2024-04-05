import {jsPDF} from "jspdf";
import autoTable from 'jspdf-autotable';
import {amountNegative, convertToCurrency, dateFormat} from "@/helper";

let doc;
let client;
let data;
let selectedDate;
let totalAmount;
let tableBody = [];
const postWindowPosition = {y: 45};
const topRightPosition = {y: 20};
const tablePosition = {y: 150};
const textPosition = {y: 100};
const spaceBetweenText = 6;
const spaceToLine = 1;
const basicFontSize = 11;
const smallFontSize = 6;

function initPdf() {
    doc = new jsPDF();
    doc.setFontSize(basicFontSize);
}

function setColorBasedOnAmount(amount) {
    amountNegative(amount) && doc.setTextColor(200, 0, 0);
}

function resetColor() {
    doc.setTextColor(0, 0, 0)
}

function drawLine(from, to, y) {
    doc.line(from, y + spaceToLine, to, y + spaceToLine);
}

function buildPostWindow(topLeftX) {
    doc.setFontSize(smallFontSize);
    doc.text("DreamHouse Property Management, Flandernstr. 101, 73728 Esslingen", topLeftX, postWindowPosition.y);
    drawLine(topLeftX, topLeftX + 70, postWindowPosition.y)
    doc.setFontSize(basicFontSize);
    doc.text(client.firstName + " " + client.lastName, topLeftX, postWindowPosition.y + spaceBetweenText);
    doc.text(client.street + " " + client.streetNo, topLeftX, postWindowPosition.y + 2 * spaceBetweenText);
    doc.text(client.zipCode + " " + client.city, topLeftX, postWindowPosition.y + 3 * spaceBetweenText);
}

function buildTopRight(topRightX) {
    const leftAligned = topRightX - 60;
    doc.text("DreamHouse Property Management", leftAligned, topRightPosition.y);
    doc.text("Flandernstr. 101", leftAligned, topRightPosition.y + spaceBetweenText);
    doc.text("73728 Esslingen", leftAligned, topRightPosition.y + 2 * spaceBetweenText);
    doc.text("Invoice date:", leftAligned, topRightPosition.y + 4 * +spaceBetweenText);
    doc.text(dateFormat(new Date()), topRightX, topRightPosition.y + 4 * spaceBetweenText, null, null, "right");
    doc.text("Billing month:", leftAligned, topRightPosition.y + 5 * spaceBetweenText);
    doc.text(String(selectedDate.month).padStart(2, "0") + "." + selectedDate.year, topRightX, topRightPosition.y + 5 * spaceBetweenText, null, null, "right");
}

function buildText(topLeftX) {
    const resultText = amountNegative(totalAmount)
        ? "Please pay the outstanding amount of " + convertToCurrency(Math.abs(totalAmount)) + "  within 6 days."
        : "We will credit the amount of " + convertToCurrency(totalAmount) + "  next month.";
    doc.text("Dear Sir or Madam,\n\n" +
        "Please find below the operating cost statement for the rented living space.\n\n" +
        resultText + "\n\n" +
        "Yours sincerely\n" +
        "DreamHouse Property Management", topLeftX, textPosition.y
    )
}

function buildTableRow(rowInformation) {
    tableBody.push([dateFormat(rowInformation.transactionDate), rowInformation.transactionReason, rowInformation.amount])
}

function buildTotalRow() {
    tableBody.push(["", "incl. VAT (19%)", Math.abs(totalAmount) * 0.19])
    tableBody.push(["", "Total", totalAmount])
}

function buildTable() {
    for (let i = 0; i < data.length; i++) {
        buildTableRow(data[i]);
    }
    buildTotalRow();
}

export function buildPdfAndSave(_data, _selectedDate, _totalAmount) {
    initPdf();
    data = _data;
    client = _data[0];
    selectedDate = _selectedDate;
    totalAmount = _totalAmount;
    buildTable();
    autoTable(doc, {
        theme: "plain",
        headStyles: {
            textColor: [10, 10, 10],
            fillColor: [240, 240, 240],
            fontSize: 13,
        },
        startY: tablePosition.y,
        head: [['Date', 'Reason', 'Amount']],
        columnStyles: {2: {halign: 'right'}},
        body: tableBody,
        didParseCell: function (data) {
            if (data.row.index === tableBody.length - 1) {
                data.cell.styles.fontSize = 13;
            }
            if (data.row.section === "head" && data.column.dataKey === 2) {
                data.cell.styles.halign = 'right';
            }
        },
        willDrawCell: function (data) {
            if (data.row.section === 'body' && data.column.dataKey === 2) {
                setColorBasedOnAmount(data.cell.raw);
                data.cell.text = convertToCurrency(data.cell.raw);
            }
            if (data.row.section === 'body') {
                if (data.row.index >= tableBody.length - 2) {
                    data.cell.y = data.cell.y + 10;
                }
            }
        },
        didDrawCell: function () {
            resetColor();
        },
        didDrawPage: function (data) {
            // Header
            buildPostWindow(data.settings.margin.left + 1)
            buildTopRight(194);
            buildText(data.settings.margin.left + 1)

            // Footer
            const str = 'Page ' + doc.internal.getNumberOfPages();
            doc.setFontSize(10)
            const pageSize = doc.internal.pageSize;
            const pageHeight = pageSize.height ? pageSize.height : pageSize.getHeight();
            doc.text("Bank: Landesoberkasse Baden-Württemberg\nIBAN: DE55 6005 0101 7495 5307 00\nBIC: SOLADEST600", data.settings.margin.left, pageHeight - 30)
            doc.text(str, data.settings.margin.left, pageHeight - 10)
        },
    })
    doc.save("export.pdf");
    tableBody = [];
}
