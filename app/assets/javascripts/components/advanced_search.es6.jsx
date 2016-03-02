//TODO implement or delete

class AdvancedSearch extends React.Component {
  render () {
    return <form className={this.props.hidden ? "hidden" : ""}>
      <input type="hidden" id="computed_query" name="computed_query" />

      <div className="well">
        <div className="form-group">
          <label htmlFor="query_1" className="sr-only">First search term</label>

          <div className="input-group">
            <span className="input-group-btn">
              <button className="btn btn-default" data-toggle="button">NOT</button>
            </span>
            <input type="text" id="query_1" className="form-control" />
            <span className="input-group-btn">
              <button className="btn btn-default" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Phrase <span className="caret"></span>
              </button>
              <button className="btn btn-danger">
                <span className="glyphicon glyphicon-trash"></span>
                <span className="sr-only">Remove</span>
              </button>
            </span>
          </div>
        </div>

        <div className="form-group">
          <p className="text-center">AND</p>
          <label htmlFor="query_2" className="sr-only">Second search term</label>

          <div className="input-group">
            <span className="input-group-btn">
              <button className="btn btn-default" data-toggle="button">NOT</button>
            </span>
            <input type="text" id="query_2" className="form-control" />
            <span className="input-group-btn">
              <button className="btn btn-default" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                XPath <span className="caret"></span>
              </button>
              <button className="btn btn-danger">
                <span className="glyphicon glyphicon-trash"></span>
                <span className="sr-only">Remove</span>
              </button>
            </span>
          </div>
        </div>

        <div className="text-center">
          <button className="btn btn-default">AND ...</button>&nbsp;
          <button className="btn btn-default">OR ...</button>
        </div>
      </div>

      <div className="text-center">
        <button type="submit" className="btn btn-primary btn-lg">
          <span className="glyphicon glyphicon-search" role="presentation" aria-hidden="true"></span> Search
        </button>
      </div>
    </form>;
  }
}

