function checkHealth() {
  fetch("http://localhost:5000/health")
    .then(res => res.json())
    .then(data => {
      document.getElementById("health-result").innerText =
        "Backend Status: " + data.status;
    })
    .catch(() => {
      document.getElementById("health-result").innerText =
        "Backend is DOWN";
    });
}
