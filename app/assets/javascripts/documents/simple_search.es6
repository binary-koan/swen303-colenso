(() => {
  const form = $("form#simple_search");
  if (!form.length) return;

  const queryInput = form.find("input#original_query");
  const builtQueryInput = form.find("input[name='query[]']");

  function isXPathQuery(text) {
    return text.indexOf("/") === 0;
  }

  function updateSearchTypeDisplay(currentText) {
    const container = queryInput.closest(".input-group");

    if (isXPathQuery(currentText)) {
      container.find(".search-type-xpath").removeClass("hidden");
    } else {
      container.find(".search-type-xpath").addClass("hidden");
    }
  }

  function updateQueryInput(currentText) {
    const type = isXPathQuery(currentText) ? "xpath" : "text";

    builtQueryInput.val(JSON.stringify({ terms: [{ type, value: currentText }] }));
  }

  function updateQuery() {
    const currentText = queryInput.val();

    updateSearchTypeDisplay(currentText);
    updateQueryInput(currentText);
  }

  queryInput.on("input", updateQuery);
  updateQuery();
})();
