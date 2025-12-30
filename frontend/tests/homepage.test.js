const fs = require("fs");
const path = require("path");

test("Homepage loads and contains expected text", () => {
  const html = fs.readFileSync(
    path.resolve(__dirname, "../index.html"),
    "utf8"
  );

  expect(html).toContain("Welcome");
});
