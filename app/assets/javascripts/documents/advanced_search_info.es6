(() => {
  const advancedSearchInfo = $("#advanced_search_info");
  const closeButton = advancedSearchInfo.find(".close");

  closeButton.click(() => {
    advancedSearchInfo.alert("close");
    monster.set("hide_advanced_search_info", true);
  });
})();
