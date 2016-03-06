(() => {
  const form = $("form#simple_search");

  function isXPathQuery(text) {
    return text.indexOf("/") === 0;
  }

  function updateSearchTypeDisplay(input) {
    const currentText = input.val();
    const container = input.closest(".input-group");

    if (isXPathQuery(currentText)) {
      container.find(".search-type-normal").addClass("hidden");
      container.find(".search-type-xpath").removeClass("hidden");
    } else {
      container.find(".search-type-xpath").addClass("hidden");
      container.find(".search-type-normal").removeClass("hidden");
    }
  }

  form.find("[data-toggle='tooltip']").tooltip();

  form.find("input#query").on("input", e => updateSearchTypeDisplay($(e.target)));
})();
