const queueList = document.getElementById("queue-list");

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

async function updateServerQueue(name) {
    let req = {
        method: "POST",
        body: JSON.stringify({
            method: "ADD", // Only functionality exists for adding to the queue.
            name: name
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
    queueList.innerHTML = await response.text();
}
