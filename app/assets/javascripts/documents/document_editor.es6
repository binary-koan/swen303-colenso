(() => {
  const editorWrapper = $("#document_tei");
  if (!editorWrapper) return;

  const editor = ace.edit(editorWrapper.get(0));

  const form = editorWrapper.closest("form");
  const xmlInput = form.find("input#xml");

  function setupEditor() {
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

  function saveEditorContent() {
    xmlInput.val(editor.getValue());
  }

  setupEditor();
  form.on("submit", saveEditorContent);
})();
