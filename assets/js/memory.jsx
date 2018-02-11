import React from 'react';
import ReactDOM from 'react-dom';
import {Button} from 'reactstrap';

export default function run_memory(root, channel) {
  ReactDOM.render(<GameController channel={channel}/>, root);
}

class GameController extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel
    let itemProps = {}
    for(var i = 0; i < 16; i++) {
          itemProps[i] =
          {id: i,
          isEnabled: true,
          isHidden: true,
          isMatched: false,
          value: "",
          onClickHandler: this.onClickHandler.bind(this)
        }
    }
    this.state = {
      clickCount: 0,
      isSecondClick: false,
      prevItemProps: null,
      isEnabled: true,
      itemPropsMap: itemProps
    }
    this.channel.join().receive("ok", this.updateView.bind(this)).receive("error", resp => {
      console.log("Unable to join", resp)
    })
    this.channel.on("update", this.updateView.bind(this))
  }

  updateView(state) {
    console.log("updateView")
    console.log(state)
    for(var key in state.itemPropsMap) {
      state.itemPropsMap[key]["onClickHandler"] = this.onClickHandler.bind(this)
    }
    this.setState(state)
  }

  enable() {
    console.log("enable")
    this.channel.push("enable", this.state)
      .receive("ok", this.updateView.bind(this))
  }

  onClickHandler(props) {
    console.log("onClickHandler")
    // console.log(this.state)
    this.channel.push("item_clicked", {itemProps: props, gameState: this.state})
      .receive("ok", this.updateView.bind(this))
  }

  reset() {
    this.channel.push("game_reset")
      .receive("ok", this.updateView.bind(this))
  }

  render() {
    // console.log(this.state)
    let reset = this.reset.bind(this);
    let itemPropsMap = this.state.itemPropsMap;
    return (<span>
      <h1>{this.state.clickCount}</h1>
      <div className="row">
        <div className="col-3">{Item(itemPropsMap[0])}</div>
        <div className="col-3">{Item(itemPropsMap[1])}</div>
        <div className="col-3">{Item(itemPropsMap[2])}</div>
        <div className="col-3">{Item(itemPropsMap[3])}</div>
      </div>
      <div className="row">
        <div className="col-3">{Item(itemPropsMap[4])}</div>
        <div className="col-3">{Item(itemPropsMap[5])}</div>
        <div className="col-3">{Item(itemPropsMap[6])}</div>
        <div className="col-3">{Item(itemPropsMap[7])}</div>
      </div>
      <div className="row">
        <div className="col-3">{Item(itemPropsMap[8])}</div>
        <div className="col-3">{Item(itemPropsMap[9])}</div>
        <div className="col-3">{Item(itemPropsMap[10])}</div>
        <div className="col-3">{Item(itemPropsMap[11])}</div>
      </div>
      <div className="row">
        <div className="col-3">{Item(itemPropsMap[12])}</div>
        <div className="col-3">{Item(itemPropsMap[13])}</div>
        <div className="col-3">{Item(itemPropsMap[14])}</div>
        <div className="col-3">{Item(itemPropsMap[15])}</div>
      </div>
      <button onClick={reset}>Reset</button>
    </span>);
  }
}

// return a new Item
function Item(props) {
  const id = props.id;
  const isMatched = props.isMatched;
  const isHidden = props.isHidden;
  const isEnabled = props.isEnabled;

  let className = null;
  if (isMatched) {
    className = isHidden
      ? "matched hidden"
      : "matched";
  } else {
    className = isHidden
      ? "hidden"
      : "";
  }

  let onClickHandler = (() => {});
  if (isHidden && isEnabled) {
    onClickHandler = (() => props.onClickHandler(props));
  }

  let value = isHidden
    ? ""
    : props.value;

  return <p className={className} onClick={onClickHandler}>{value}</p>;
}
