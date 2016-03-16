(() => {
  const container = $("#document");
  if (!container) return;

  const documentViewer = container.find(".view-document");
  const formatSwitcher = container.find(".switch-format");

  function setupEditor() {
    const editor = ace.edit("document_tei");
    editor.setTheme("ace/theme/chrome");
    editor.getSession().setMode("ace/mode/xml");

    editor.renderer.setShowGutter(false);
    editor.setOptions({ maxLines: 5000 });

    if (!$("#document_tei").hasClass("editable")) {
      editor.setReadOnly(true);
      editor.setHighlightActiveLine(false);
      editor.renderer.$cursorLayer.element.style.display = "none";
    }
  }

  function setFormat(format) {
    formatSwitcher.find("[class*='format']").removeClass("active");
    formatSwitcher.find(`.format-${format}`).addClass("active");

    documentViewer.find("[class*='format']").addClass("hidden");
    documentViewer.find(`.format-${format}`).removeClass("hidden");
  }

  formatSwitcher.find(".format-html").on("click", setFormat.bind(null, "html"));
  formatSwitcher.find(".format-tei").on("click", setFormat.bind(null, "tei"));

  formatSwitcher.find(".active").trigger("click");

  setupEditor();
})();
