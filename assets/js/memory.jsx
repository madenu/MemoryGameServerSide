import React from 'react';
import ReactDOM from 'react-dom';
import {Button} from 'reactstrap';

export default function run_memory(root) {
  ReactDOM.render(<GameController />, root);
}

class GameController extends React.Component {
  constructor(props) {
    super(props);
    let tempArray = this.newPropsArray(this.makeLetterArray());
    this.state = {
      clickCount: 0,
      isSecondClick: false,
      prevItemProps: null,
      isEnabled: true,
      itemPropsArray: tempArray
    }
  }

  render() {
    let reset = this.reset.bind(this);
    const itemPropsArray = this.state.itemPropsArray;
    return (<span>
      <h1>{this.state.clickCount}</h1>
      <div className="row">
        <div className="col-3">{Item(itemPropsArray[0])}</div>
        <div className="col-3">{Item(itemPropsArray[1])}</div>
        <div className="col-3">{Item(itemPropsArray[2])}</div>
        <div className="col-3">{Item(itemPropsArray[3])}</div>
      </div>
      <div className="row">
        <div className="col-3">{Item(itemPropsArray[4])}</div>
        <div className="col-3">{Item(itemPropsArray[5])}</div>
        <div className="col-3">{Item(itemPropsArray[6])}</div>
        <div className="col-3">{Item(itemPropsArray[7])}</div>
      </div>
      <div className="row">
        <div className="col-3">{Item(itemPropsArray[8])}</div>
        <div className="col-3">{Item(itemPropsArray[9])}</div>
        <div className="col-3">{Item(itemPropsArray[10])}</div>
        <div className="col-3">{Item(itemPropsArray[11])}</div>
      </div>
      <div className="row">
        <div className="col-3">{Item(itemPropsArray[12])}</div>
        <div className="col-3">{Item(itemPropsArray[13])}</div>
        <div className="col-3">{Item(itemPropsArray[14])}</div>
        <div className="col-3">{Item(itemPropsArray[15])}</div>
      </div>
      <button onClick={reset}>Reset</button>
    </span>);
  }

  onClickHandler(props) {
    // fucking sick and tired of JavaScript's bullshit
    // and mutation right now
    let itemProps = deepCopy(props);
    let gameState = deepCopy(this.state);
    let prevProps = deepCopy(gameState.prevItemProps);

    itemProps.isHidden = false;
    gameState.clickCount = gameState.clickCount + 1;
    gameState = this.updateItem(itemProps, gameState);

    if(gameState.isSecondClick) {
      if(itemProps.value == prevProps.value) {
        itemProps.isMatched = true;
        prevProps.isMatched = true;
        gameState = this.updateItem(itemProps, gameState);
        gameState = this.updateItem(prevProps, gameState);
        this.setState(_.extend(this.state, gameState));
      } else {
        gameState.isEnabled = false;
        console.log('sleeping..');
        setTimeout(() => {
          itemProps.isHidden = true;
          prevProps.isHidden = true;
          gameState.isEnabled = true;
          gameState = this.updateEnabled(gameState);
          gameState = this.updateItem(itemProps, gameState);
          gameState = this.updateItem(prevProps, gameState);
          this.setState(_.extend(this.state, gameState));
        }, 1000);
      }
    }

    gameState.prevItemProps = itemProps;
    gameState.isSecondClick = !gameState.isSecondClick;
    gameState = this.updateEnabled(gameState);
    this.setState(_.extend(this.state, gameState));
  }

  // update the properties for a single item and return a new state
  updateItem(props, state) {
    // fuck it
    let itemProps = deepCopy(props);
    let gameState = deepCopy(state);
    let propsArr = deepCopy(gameState.itemPropsArray);
    propsArr[itemProps.id] = itemProps;
    gameState.itemPropsArray = propsArr;
    return gameState;
  }

  // update the isEnabled flags for each item
  updateEnabled(state) {
    let gameState = deepCopy(state);
    let itemProps = deepCopy(gameState.itemPropsArray);
    itemProps = _.map(itemProps, x => _.extend(x, {isEnabled: gameState.isEnabled}));
    gameState.itemPropsArray = itemProps;
    return gameState;
  }

  // generate shuffled array of random paris of letters
  makeLetterArray() {
    let letterArray = this.shuffle("ABCDEFGHABCDEFGH".split(""));
    return letterArray;
  }

  // https://github.com/coolaj86/knuth-shuffle
  shuffle(array) {
    let currentIndex = array.length,
      temporaryValue,
      randomIndex;
    // While there remain elements to shuffle...
    while (0 !== currentIndex) {
      // Pick a remaining element...
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex -= 1;
      // And swap it with the current element.
      temporaryValue = array[currentIndex];
      array[currentIndex] = array[randomIndex];
      array[randomIndex] = temporaryValue;
    }
    return array;
  }

  // create a new array of properties for the items in the grid
  newPropsArray(valueArray) {
    let resultArray = [];
    let onClickHandler = this.onClickHandler.bind(this);
    for (var i = 0; i < valueArray.length; i++) {
      resultArray.push({id: i, isEnabled: true, isHidden: true, isMatched: false, value: valueArray[i], onClickHandler: onClickHandler});
    }
    return resultArray;
  }

  // make a new game
  reset() {
    let gameState = this.state;
    let itemProps = deepCopy(gameState.itemPropsArray);
    itemProps = this.newPropsArray(this.makeLetterArray());
    console.log(itemProps);
    gameState.itemPropsArray = itemProps;
    gameState.clickCount = 0;
    gameState.isSecondClick = false;
    gameState.prevItemProps = null;
    gameState.isEnabled = true;
    this.setState(_.extend(this.state, gameState));
  }
}

// return a deep copy of the object
function deepCopy(obj) {
  return $.extend(true, {}, obj);
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
