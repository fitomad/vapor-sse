// Server-Sent Events code

const eventSource = new EventSource("http://127.0.0.1:8080/events");

eventSource.onmessage = function (event) {
	let eventContent = `<code>General event: ${event.data}</code><br/>`;
}

eventSource.addEventListener("ping", (event) => {
	let eventContent = `<code>${event.data}</code><br/>`;
	console.log(eventContent);
	id("events").innerHTML += eventContent
});

eventSource.onerror = (err) => {
	console.error("EventSource failed:", err);
};


// detected Stop button click

id("stop").addEventListener("click", function(e) {
	console.log("stop!")
	eventSource.close();
});

// Helper functions

function id(element_id) {
	return document.getElementById(element_id);
}
