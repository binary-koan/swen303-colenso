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

    searchTypeName() {
      if (this.hasXPathQuery()) {
        return "XPath";
      } else {
        return "Normal";
      }
    }

    searchTypeTooltip() {
      if (this.hasXPathQuery()) {
        return <Tooltip>Your search term will be interpreted as an XPath expression.</Tooltip>;
      } else {
        return <Tooltip>Documents containing this phrase will be shown.</Tooltip>;
      }
    }

    render() {
      return <form action="/documents/search" method="get" className={this.props.hidden ? "hidden" : ""}>
        <input type="hidden" name="query_type" value="simple" />

        <div className="form-group has-feedback">
          <label htmlFor="query" className="sr-only">Search</label>
          <div className="input-group">
            <input id="query" name="query" type="text" className="form-control input-lg"
                aria-describedby="query_status" value={this.state.query}
                onChange={this.updateQuery.bind(this)} />
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
