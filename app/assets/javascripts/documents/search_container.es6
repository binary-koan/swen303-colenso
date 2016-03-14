(() => {
  const searchContainer = $(".search-container");
  if (!searchContainer.length) return;

  const simpleSearch = searchContainer.filter(".simple-search-container");
  const advancedSearch = searchContainer.filter(".advanced-search-container");

  const queryBuilderToggle = $(".query-builder-toggle");
  const startEditingButton = searchContainer.find(".viewing-section .start-editing");

  function toggleQueryBuilder() {
    simpleSearch.toggleClass("hidden");
    advancedSearch.toggleClass("hidden");
    queryBuilderToggle.find(".query-builder-hidden").toggleClass("hidden");
    queryBuilderToggle.find(".query-builder-shown").toggleClass("hidden");
  }

  queryBuilderToggle.click(toggleQueryBuilder);

  startEditingButton.on("click", () => searchContainer.addClass("editing"));
})();
