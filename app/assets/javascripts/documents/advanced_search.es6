function setupAdvancedSearch(form) {
  const searchTerms = form.find(".advanced-search-terms .search-term");
  const searchEditor = form.find(".advanced-search-query.editable");
  const builtQueryInput = form.find("input[name='query[]']").last();

  const TYPE_TITLES = { t: "Text", x: "XPath" };

  function addInput(type, value, box) {
    const container = $("<span>").addClass("search-term input-group").data("type", type);
    container.append($("<span>").addClass("input-group-addon").text(TYPE_TITLES[type]));
    container.append($("<input>").attr("type", "text").addClass("form-control").val(value));

    box.append(container);
    container.find("input").focus();
  }

  function addOperator(operator, box) {
    const container = $("<span>").text(operator).attr({
      class: `search-term search-term-operator ${operator}`,
      "data-operator": operator
    });

    box.append(container);
  }

  function dropTerm(term) {
    if (term.is(".search-term-text")) {
      addInput(term.data("type"), "", searchEditor);
    } else {
      addOperator(term.data("operator"), searchEditor);
    }
  }

  function isOutsideSearchEditor(x, y) {
    const clientRect = searchEditor.get(0).getBoundingClientRect();

    return x < clientRect.left || y < clientRect.top || x > clientRect.right || y > clientRect.bottom;
  }

  function maybeRemoveTerm(term, e) {
    if (isOutsideSearchEditor(e.clientX, e.clientY)) {
      e.preventDefault();
      term.closest(".search-term").remove();
    }
  }

  function calculateQueryData(e) {
    const terms = [];

    searchEditor.children().each((i, el) => {
      const child = $(el);

      if (child.hasClass("search-term-operator")) {
        terms.push("o" + child.data("operator"));
      } else {
        terms.push(child.data("type") + child.find("input").val());
      }
    });

    builtQueryInput.val(JSON.stringify(terms));
  }

  function restoreQueryData(data, box) {
    if (!data) return;

    data.forEach(term => {
      if (term.indexOf("o") === 0) {
        addOperator(term.slice(1), box);
      } else {
        addInput(term[0], term.slice(1), box);
      }
    });
  }

  searchTerms
    .draggable({
      appendTo: searchEditor,
      helper: "clone",
      cancel: false
    })
    .click(e => dropTerm($(e.target)));

  searchEditor
    .droppable({
      hoverClass: "highlight",
      accept: ".search-term.ui-draggable",

      drop(_, { draggable }) {
        dropTerm(draggable);
      }
    })
    .sortable({
      sort(_, { item }) {
        // gets added unintentionally by droppable interacting with sortable
        // using connectWithSortable fixes this, but doesn't allow you to customize active/hoverClass options
        item.removeClass("ui-state-default");
      }
    })
    .on("mouseup", ".search-term", e => maybeRemoveTerm($(e.target), e));

  form.on("submit", calculateQueryData);

  if (searchEditor.data("query")) {
    restoreQueryData(searchEditor.data("query"), searchEditor);
  }
};

$("form.advanced-search").each((_, form) => setupAdvancedSearch($(form)));
