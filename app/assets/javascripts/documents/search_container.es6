(() => {
  const searchContainer = $(".search-container");
  if (!searchContainer.length) return;

  const simpleSearch = searchContainer.find("#simple_search");
  const advancedSearch = searchContainer.find("#advanced_search");

  const queryBuilderToggle = searchContainer.find(".query-builder-toggle");
  const startEditingButton = searchContainer.find(".viewing-section .start-editing");

  function toggleQueryBuilder() {
    simpleSearch.toggleClass("hidden");
    advancedSearch.toggleClass("hidden");
    queryBuilderToggle.find(".query-builder-hidden").toggleClass("hidden");
    queryBuilderToggle.find(".query-builder-shown").toggleClass("hidden");
  }

  queryBuilderToggle.on("click", toggleQueryBuilder);

  startEditingButton.on("click", () => searchContainer.addClass("editing"));
})();
