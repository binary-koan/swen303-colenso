(() => {
  const searchResults = $("#search_results");
  if (!searchResults.length) return;

  const searchUri = URI(location.href).suffix("json");

  const loadMoreSpinner = $(".load-more-results .spinner");
  const loadMoreButton = $(".load-more-results button");

  let searchTask;
  let infiniteScrollEnabled = false;
  let page = 1;

  function loadNextPage() {
    if (searchTask) return;

    page += 1;
    loadMoreSpinner.removeClass("hidden");

    searchTask = $.get(searchUri.setQuery({ page }).toString()).then(data => {
      loadMoreSpinner.addClass("hidden");
      searchResults.append(data.content);
      searchTask = null;
    });
  }

  function loadFirstExtras() {
    loadNextPage();

    infiniteScrollEnabled = true;
    loadMoreButton.addClass("hidden");
  }

  function scrollDown() {
    if (!infiniteScrollEnabled) return;

    const [windowWrapper, documentWrapper] = [$(window), $(document)];

    if (windowWrapper.scrollTop() + windowWrapper.height() > documentWrapper.height() - 100) {
      loadNextPage();
    }
  }

  loadMoreButton.on("click", loadFirstExtras);
  $(window).on("scroll", scrollDown);
})();
