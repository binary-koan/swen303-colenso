(() => {
  const searchContainer = $(".search-container");
  if (!searchContainer.length) return;

  const simpleSearch = searchContainer.find("#simple_search");
  const advancedSearch = searchContainer.find("#advanced_search");

  const queryBuilderToggle = searchContainer.find(".query-builder-toggle");

  const startEditingButton = searchContainer.find("button.edit-query");
  const startEditingContainer = searchContainer.filter(".edit-query");

  const searchWithinButton = searchContainer.find("button.search-within");
  const searchWithinContainer = searchContainer.filter(".search-within");

  function toggleQueryBuilder() {
    simpleSearch.toggleClass("hidden");
    advancedSearch.toggleClass("hidden");
    queryBuilderToggle.find(".query-builder-hidden").toggleClass("hidden");
    queryBuilderToggle.find(".query-builder-shown").toggleClass("hidden");
  }

  function toggleEditing() {
    startEditingContainer.toggleClass("hidden");
    searchWithinButton.toggleClass("hidden");
    startEditingButton.toggleClass("active");
  }

  function toggleFiltering() {
    searchWithinContainer.toggleClass("hidden");
    startEditingButton.toggleClass("hidden");
    searchWithinButton.toggleClass("active");
  }

  queryBuilderToggle.on("click", toggleQueryBuilder);

  startEditingButton.on("click", toggleEditing);
  searchWithinButton.on("click", toggleFiltering);
})();
