document.addEventListener("DOMContentLoaded", function () {
    const inputField = document.getElementById("input");
    const responseField = document.getElementById("output");

    const submitButton = document.getElementById("encode");
    const clearButton = document.getElementById("clear");

    const autoEncode = document.getElementById("auto");

    const filterSearch = document.getElementById("filter-search");

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

    inputField.addEventListener("keydown",  function (event) {
        if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
            submitButton.click();
        }
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

    filterSearch.addEventListener("keyup", function () {
        console.log(this.value);
        let filter = this.value.toLowerCase();
        let elements = document.getElementsByClassName("filterable");
        console.log(elements)
        for (let element of elements) {
            if (element.innerText.toLowerCase().includes(filter)) {
                element.style.display = "block";
            } else {
                element.style.display = "none";
            }
        }
    });
});