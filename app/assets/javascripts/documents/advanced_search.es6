(() => {
  const searchTerms = $(".advanced-search-terms .search-term");
  const searchBox = $(".advanced-search-query");

  const TYPE_TITLES = { text: "Text", xpath: "XPath" };

  function addInput(term) {
    const typeTitle = TYPE_TITLES[term.data("type")];
    const container = $("<span>").addClass("input-group search-term");

    container.append($("<span>").addClass("input-group-addon").text(typeTitle));
    container.append($("<input>").attr({
      type: "text",
      class: "form-control",
      "data-type": term.data("type")
    }));

    searchBox.append(container);
    container.find("input").focus();
  }

  function addUnaryOperator(term) {
    const container = $("<span>").text(term.text()).attr({
      class: "search-term search-term-unary",
      "data-operator": term.data("operator")
    });

    searchBox.append(container);
  }

  function addBinaryOperator(term) {
    const container = $("<span>").text(term.text()).attr({
      class: `search-term search-term-binary ${term.data("operator")}`,
      "data-operator": term.data("operator")
    });

    searchBox.append(container);
  }

  function dropTerm(term) {
    if (term.is(".search-term-text")) {
      addInput(term);
    } else if (term.is(".search-term-unary")) {
      addUnaryOperator(term);
    } else {
      addBinaryOperator(term);
    }
  }

  function isOutsideSearchBox(x, y) {
    const clientRect = searchBox.get(0).getBoundingClientRect();

    return x < clientRect.left || y < clientRect.top || x > clientRect.right || y > clientRect.bottom;
  }

  function maybeRemoveTerm(term, e) {
    if (isOutsideSearchBox(e.clientX, e.clientY)) {
      e.preventDefault();
      term.closest(".search-term").remove();
    }
  }

  searchTerms
    .draggable({
      appendTo: "body",
      helper: "clone",
      cancel: false
    })
    .click(e => dropTerm($(e.target)));

  searchBox
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
    });

  searchBox.on("mouseup", ".search-term", e => maybeRemoveTerm($(e.target), e));
})();
