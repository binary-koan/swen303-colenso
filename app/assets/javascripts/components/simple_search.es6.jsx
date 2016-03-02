//TODO implement

(() => {
  const { OverlayTrigger, Tooltip } = ReactBootstrap;

  class SimpleSearch extends React.Component {
    constructor(props) {
      super(props);

      this.state = { query: "" };
    }

    updateQuery(e) {
      this.setState({ query: e.target.value });
    }

    hasXPathQuery() {
      return this.state.query[0] === "/";
    }

    hasWholePhraseQuery() {
      return /^"[^"]+"$/.test(this.state.query);
    }

    hasComposedQuery() {
      return /".+"/.test(this.state.query);
    }

    searchTypeName() {
      if (this.hasXPathQuery()) {
        return "XPath";
      } else if (this.hasWholePhraseQuery()) {
        return "Whole phrase";
      } else if (this.hasComposedQuery()) {
        return "Composition";
      } else {
        return "Normal";
      }
    }

    searchTypeTooltip() {
      if (this.hasXPathQuery()) {
        return <Tooltip>Your search term will be interpreted as an XPath expression.</Tooltip>;
      } else if (this.hasWholePhraseQuery()) {
        return <Tooltip>Only documents containing that exact phrase will be shown.</Tooltip>;
      } else if (this.hasComposedQuery()) {
        return <Tooltip>Your search terms will be interpreted as a complex search pattern.</Tooltip>;
      } else {
        return <Tooltip>Documents matching any of the words you enter will be shown.</Tooltip>;
      }
    }

    render() {
      return <form className={this.props.hidden ? "hidden" : ""}>
        <div className="form-group has-feedback">
          <label htmlFor="query" className="sr-only">Search</label>
          <div className="input-group">
            <input id="query" type="text" className="form-control input-lg" aria-describedby="query_status" value={this.state.query} onChange={this.updateQuery.bind(this)} />
            <OverlayTrigger placement="bottom" trigger="hover" overlay={this.searchTypeTooltip()}>
              <span className="input-group-addon">{this.searchTypeName()}</span>
            </OverlayTrigger>
          </div>
        </div>

        <div className="text-center">
          <button type="submit" className="btn btn-primary btn-lg">
            <span className="glyphicon glyphicon-search" aria-hidden="true"></span> Search
          </button>
        </div>
      </form>;
    }
  }

  window.SimpleSearch = SimpleSearch;
})();
