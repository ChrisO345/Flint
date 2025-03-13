Object.defineProperty(String.prototype, 'capitalize', {
    value: function () {
        return this.charAt(0).toUpperCase() + this.slice(1);
    },
    enumerable: false
});

const queueResults = document.getElementById("queue-results");

document.addEventListener("DOMContentLoaded", function () {
    updateClientQueue().then(r => console.log("Queue loaded."));

    const inputField = document.getElementById("input");
    const responseField = document.getElementById("output");

    const submitButton = document.getElementById("encode");
    const clearButton = document.getElementById("clear");

    const autoEncode = document.getElementById("auto");

    const filterSearch = document.getElementById("filter-search");

    const filterableElements = document.querySelectorAll(".filterable");

    const queueClearButton = document.getElementById("queue-clear");

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

    inputField.addEventListener("keydown", function (event) {
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

    filterableElements.forEach(element => {
        element.addEventListener("click", async function () {
            await updateServerQueue(element.innerText);
        });
    });

    queueClearButton.addEventListener("click", async function () {
        let req = {
            method: "POST",
            body: JSON.stringify({
                method: "CLS"
            })
        }

        let response = await fetch("/queue", req);
        let queue = await response.text();
        console.log(queue);
        await updateClientQueue();
    });
});

async function addConfigurations() {
    const parentArray = document.querySelectorAll(".queue-item");


    parentArray.forEach((parent, index) => {
        let elements = parent.querySelectorAll(".configuration-element");
        elements.forEach(element => {

            element.addEventListener("click", async function () {
                let elementType = element.tagName.toLowerCase();
                if (elementType === "textarea") {
                } else if (elementType === "input" && element.type === "checkbox") {
                    console.log(index, element.parentElement.innerText, (element.checked).toString().capitalize());
                    await modifyServerConfigurations(index, element.parentElement.innerText, (element.checked).toString().capitalize());
                }
            });
        });
    });
}

async function modifyServerConfigurations(index, property, value) {
    let req = {
        method: "POST",
        body: JSON.stringify({
            method: "MOD",
            name: property,
            index: index,
            value: value
        })
    }

    let response = await fetch("/queue", req);
    let configurations = await response.text();
    console.log(configurations);
}

async function updateServerQueue(name) {
    let req = {
        method: "POST",
        body: JSON.stringify({
            method: "ADD",
            name: name
        })
    }

    let response = await fetch("/queue", req);
    let queue = await response.text();
    console.log(queue);
    await updateClientQueue();
}

async function modifyServerQueue(name, index, method) {
    let req = {
        method: "POST",
        body: JSON.stringify({
            method: method,
            name: name,
            index: index
        })
    }

    let response = await fetch("/queue", req);
    let queue = await response.text();
    console.log(queue);
    await updateClientQueue();
}

async function updateClientQueue() {
    let req = {
        method: "POST",
        body: JSON.stringify({
            method: "GET"
        })
    }

    let response = await fetch("/queue", req);
    let text = await response.text();

    if (text === "") {
        queueResults.innerHTML = "";
        return;
    }
    queueResults.innerHTML = text;

    await addConfigurations();
}
