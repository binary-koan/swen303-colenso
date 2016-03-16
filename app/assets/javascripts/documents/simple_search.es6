function setupSimpleSearch(form) {
  const queryInput = form.find("input#original_query");
  const builtQueryInput = form.find("input[name='query[]']").last();

  function isXPathQuery(text) {
    return text && text.indexOf("/") === 0;
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
    const type = isXPathQuery(currentText) ? "x" : "t";

    builtQueryInput.val(JSON.stringify([type + currentText]));
  }

  function updateQuery() {
    const currentText = queryInput.val();

    updateSearchTypeDisplay(currentText);
    updateQueryInput(currentText);
  }

  queryInput.on("input", updateQuery);
  updateQuery();

  return this;
};

$("form.simple-search").each((_, form) => setupSimpleSearch($(form)));
