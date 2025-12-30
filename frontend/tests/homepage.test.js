const fs = require("fs");
const path = require("path");

test("Homepage loads and contains project title", () => {
  const html = fs.readFileSync(
    path.resolve(__dirname, "../index.html"),
    "utf8"
  );

  expect(html).toContain("Capstone CI/CD End-to-End Project");
  expect(html).toContain("Frontend Status");
  expect(html).toContain("Backend Health");
});
