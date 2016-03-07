(() => {
  const simpleSearch = $("#simple_search");
  const advancedSearch = $("#advanced_search");
  const toggle = $(".query-builder-toggle");

  function toggleQueryBuilder() {
    simpleSearch.toggleClass("hidden");
    advancedSearch.toggleClass("hidden");
    toggle.find(".query-builder-hidden").toggleClass("hidden");
    toggle.find(".query-builder-shown").toggleClass("hidden");
  }

  toggle.click(toggleQueryBuilder);
})();