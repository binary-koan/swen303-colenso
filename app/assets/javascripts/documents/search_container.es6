(() => {
  const searchContainer = $(".search-container");
  if (!searchContainer.length) return;

  const simpleSearch = searchContainer.find(".simple-search");
  const advancedSearch = searchContainer.find(".advanced-search");

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
    if (startEditingContainer.hasClass("hidden")) {
      searchWithinContainer.addClass("hidden");
      searchWithinButton.removeClass("active");
      startEditingContainer.removeClass("hidden");
      startEditingButton.addClass("active");
    } else {
      startEditingContainer.addClass("hidden");
      startEditingButton.removeClass("active");
    }
  }

  function toggleFiltering() {
    if (searchWithinContainer.hasClass("hidden")) {
      startEditingContainer.addClass("hidden");
      startEditingButton.removeClass("active");
      searchWithinContainer.removeClass("hidden");
      searchWithinButton.addClass("active");
    } else {
      searchWithinContainer.addClass("hidden");
      searchWithinButton.removeClass("active");
    }
  }

  queryBuilderToggle.on("click", toggleQueryBuilder);

  startEditingButton.on("click", toggleEditing);
  searchWithinButton.on("click", toggleFiltering);
})();
