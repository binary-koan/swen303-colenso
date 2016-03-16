(() => {
  const searchContainer = $(".search-container");
  if (!searchContainer.length) return;

  const simpleSearch = searchContainer.find("#simple_search");
  const advancedSearch = searchContainer.find("#advanced_search");

  const queryBuilderToggle = searchContainer.find(".query-builder-toggle");
  const startEditingButton = searchContainer.find(".query-viewer .start-editing");

  const searchWithinButton = searchContainer.find(".query-viewer .search-within");
  const searchWithinContainer = searchContainer.filter(".search-within");

  function toggleQueryBuilder() {
    simpleSearch.toggleClass("hidden");
    advancedSearch.toggleClass("hidden");
    queryBuilderToggle.find(".query-builder-hidden").toggleClass("hidden");
    queryBuilderToggle.find(".query-builder-shown").toggleClass("hidden");
  }

  function toggleSearchingWithin() {
    searchWithinContainer.toggleClass("hidden");
    startEditingButton.toggleClass("hidden");
    searchWithinButton.toggleClass("active");
  }

  queryBuilderToggle.on("click", toggleQueryBuilder);

  startEditingButton.on("click", () => searchContainer.addClass("editing"));
  searchWithinButton.on("click", toggleSearchingWithin);
})();
