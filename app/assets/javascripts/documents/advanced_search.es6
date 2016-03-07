(() => {
  const searchTerms = $(".advanced-search-terms .search-term");
  const searchBox = $(".advanced-search-query");

  function addInput(term) {
    searchBox.append($("<input>").attr({
      type: "text",
      "data-type": term.data("type")
    }));
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

  searchTerms.draggable({
    appendTo: "body",
    helper: "clone",
    cancel: false
  });

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
})();
