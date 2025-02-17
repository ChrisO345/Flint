document.addEventListener("DOMContentLoaded", function () {
    const inputField = document.getElementById("input");
    const responseField = document.getElementById("output");

    const submitButton = document.getElementById("encode");
    const clearButton = document.getElementById("clear");

    const autoEncode = document.getElementById("auto");

    inputField.addEventListener("input", async function () {
        if (!autoEncode.checked) {
            return;
        }
        let inputValue = this.value;
        let response = await fetch("/encode", {
            method: "POST",
            body: inputValue
        });
        responseField.innerText = await response.text();
    });

    submitButton.addEventListener("click", async function () {
        let inputValue = inputField.value;
        let response = await fetch("/encode", {
            method: "POST",
            body: inputValue
        });
        responseField.innerText = await response.text();
    });

    clearButton.addEventListener("click", function () {
        inputField.value = "";
        responseField.innerText = "";
    });
});