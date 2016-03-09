(() => {
  const form = $("form#simple_search");
  const queryInput = form.find("input#query");

  function isXPathQuery(text) {
    return text.indexOf("/") === 0;
  }

  function updateSearchTypeDisplay() {
    const currentText = queryInput.val();
    const container = queryInput.closest(".input-group");

    if (isXPathQuery(currentText)) {
      container.find(".search-type-xpath").removeClass("hidden");
    } else {
      container.find(".search-type-xpath").addClass("hidden");
    }
  }

  form.find("[data-toggle='tooltip']").tooltip();

  queryInput.on("input", updateSearchTypeDisplay);
  updateSearchTypeDisplay();
})();
