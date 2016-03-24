(() => {
  const editorWrapper = $("#document_tei");
  if (!editorWrapper) return;

  const editor = ace.edit(editorWrapper.get(0));

  const formatSwitcher = $("#document .switch-format");

  const form = editorWrapper.closest("form");
  const xmlInput = form.find("input#xml");

  function updateEditor() {
    editor.resize();
    editor.renderer.updateFull();
  }

  function setupEditor() {
    editor.setTheme("ace/theme/chrome");
    editor.getSession().setMode("ace/mode/xml");
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

  formatSwitcher.on("click", updateEditor);
  form.on("submit", saveEditorContent);
})();
