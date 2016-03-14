(() => {
  const searchContainer = $(".advanced-search-container");
  if (!searchContainer.length) return;

  const searchTerms = searchContainer.find(".advanced-search-terms .search-term");

  const searchViewer = searchContainer.find(".advanced-search-query:not(.editable)");
  const searchEditor = searchContainer.find(".advanced-search-query.editable");

  const form = $("form#advanced_search");

  const TYPE_TITLES = { text: "Text", xpath: "XPath" };

  function addInput({ type, value, editable }, box) {
    const container = $("<span>").addClass("search-term");

    if (editable) {
      container.addClass("input-group").data("type", type);
      container.append($("<span>").addClass("input-group-addon").text(TYPE_TITLES[type]));
      container.append($("<input>").attr("type", "text").addClass("form-control").val(value));
    } else {
      container.addClass("search-term-text").text(value);
    }

    box.append(container);
    container.find("input").focus();
  }

  function addOperator({ operator }, box) {
    const container = $("<span>").text(operator).attr({
      class: `search-term search-term-operator ${operator}`,
      "data-operator": operator
    });

    box.append(container);
  }

  function dropTerm(term) {
    if (term.is(".search-term-text")) {
      addInput({ type: term.data("type"), editable: true }, searchEditor);
    } else {
      addOperator({ operator: term.data("operator") }, searchEditor);
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
        terms.push({ "operator": child.data("operator") });
      } else {
        terms.push({ type: child.data("type"), value: child.find("input").val() });
      }
    });

    form.find("#query").val(JSON.stringify({ terms }));
  }

  function restoreQueryData(data, box) {
    data.forEach(term => {
      if (term.operator) {
        addOperator(term, box);
      } else {
        addInput(term, box);
      }
    });
  }

  searchTerms
    .draggable({
      appendTo: "body",
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

  if (searchViewer.data("query")) {
    restoreQueryData(searchViewer.data("query").terms, searchViewer);
  }
})();
