package com.rmu.mnswp.logic {
import com.rmu.mnswp.common.GameState;
import com.rmu.mnswp.events.GameEvent;
import com.rmu.mnswp.model.Board;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;

public class GameModel extends EventDispatcher {


    public function get state():int {
        return _state;
    }

    public function get userBoard():Board {
        return _userBoard;
    }

    public function get realBoard():Board {
        return _realBoard;
    }

    public function get timer():int {
        return _timer;
    }

    public function get minesDiscovered():int {
        return _minesDiscovered;
    }

    private var _state:int;
    private var _userBoard:Board = null;
    private var _realBoard:Board = null;
    private var _timer:int = 0;
    private var _minesDiscovered:int = 0;


    public function GameModel() {

    }


    public function newGame(boardSize = 9):void {
        _state = GameState.NEW;
        _userBoard = new Board(boardSize);
        _realBoard = new Board(boardSize);
        dispatchEvent(new GameEvent(GameEvent.STATE, state));
    }

    public function playGame():void {
        _state = GameState.STARTED;
        dispatchEvent(new GameEvent(GameEvent.STATE, state));
    }

    public function resetGame():void {

    }


}
}
