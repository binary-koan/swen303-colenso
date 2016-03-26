(() => {
  const editorWrapper = $("#document_tei");
  if (!editorWrapper) return;

  const editor = ace.edit(editorWrapper.get(0));

  const viewTabs = $("#document .switch-format a[data-toggle='tab']");

  const form = editorWrapper.closest("form");
  const xmlInput = form.find("input#xml");

  function updateEditor() {
    if (editorWrapper.closest(".tab-pane.active").length > 0) {
      editor.resize();
      editor.renderer.updateFull();
    }
  }

  function setupEditor() {
    editor.setTheme("ace/theme/chrome");
    editor.getSession().setMode("ace/mode/xml");
    editor.getSession().setUseWrapMode(true);
    editor.setOptions({ maxLines: 5000 });

    if (!$("#document_tei").hasClass("editable")) {
      editor.renderer.setShowGutter(false);
      editor.setReadOnly(true);
      editor.setHighlightActiveLine(false);
      editor.renderer.$cursorLayer.element.style.display = "none";
    }
  }

  function saveEditorContent() {
    xmlInput.val(editor.getValue());
  }

  setupEditor();

  viewTabs.on("shown.bs.tab", updateEditor);
  form.on("submit", saveEditorContent);
})();
