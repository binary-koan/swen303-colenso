class SearchContainer extends React.Component {
  constructor(props) {
    super(props);

    this.state = { advanced: false };
  }

  toggleAdvanced() {
    this.setState({ advanced: !this.state.advanced });
  }

  render () {
    return <div>
      <div className="row">
        <div className="col-md-6">
          <button className="btn btn-link" onClick={this.toggleAdvanced.bind(this)}>
            <span className="glyphicon glyphicon-cog"></span>&nbsp;
            {this.state.advanced ? "Simple search" : "Advanced search"}
          </button>
        </div>

        <div className="col-md-6 text-right">
          <button className="btn btn-link">
            <span className="glyphicon glyphicon-question-sign"></span> Get help
          </button>
        </div>
      </div>

      <SimpleSearch hidden={this.state.advanced} />
      <AdvancedSearch hidden={!this.state.advanced} />
    </div>;
  }
}
