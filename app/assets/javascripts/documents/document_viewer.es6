(() => {
  const container = $("#document");
  if (!container) return;

  const documentViewer = container.find(".view-document");
  const formatSwitcher = container.find(".switch-format");

  function setFormat(format) {
    formatSwitcher.find("[class*='format']").removeClass("active");
    formatSwitcher.find(`.format-${format}`).addClass("active");

    documentViewer.find("[class*='format']").addClass("hidden");
    documentViewer.find(`.format-${format}`).removeClass("hidden");
  }

  formatSwitcher.find(".format-html").on("click", setFormat.bind(null, "html"));
  formatSwitcher.find(".format-tei").on("click", setFormat.bind(null, "tei"));

  formatSwitcher.find(".active").trigger("click");
})();
