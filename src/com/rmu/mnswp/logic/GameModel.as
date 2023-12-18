package com.rmu.mnswp.logic {
import com.rmu.mnswp.model.GameState;
import com.rmu.mnswp.events.GameEvent;
import com.rmu.mnswp.model.Board;
import com.rmu.mnswp.model.Cell;
import com.rmu.mnswp.presentation.CellFrameLabel;

import flash.display.DisplayObject;
import flash.display.MovieClip;

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
    private var _boardSize:int;
    private var _minesCount:int;


    public function GameModel() {

    }


    public function newGame(boardSize = 9, minesCount:int = 10):void {
        _state = GameState.PREPARE;
        _boardSize = boardSize
        _minesCount = minesCount
        _userBoard = new Board(boardSize);

        //Board.printBoardIndeces(_userBoard);
        dispatchEvent(new GameEvent(GameEvent.STATE, state));
    }

    public function playGame():void {
        _state = GameState.START;
        dispatchEvent(new GameEvent(GameEvent.STATE, state));
    }

    public function resetGame():void {

    }


    public function performFirstTurn(cell:Cell):void {
        _realBoard = new Board(_boardSize);
        _realBoard = Board.firstClickSafeWithMines(cell, _minesCount, _realBoard);
        trace(' ---- SAFE REAL BOARD --- ')
        trace(' ---- generated on click '+cell+':'+cell.cellId +' --- ')
        Board.printBoardState(_realBoard);
        trace(' ---- FULFILL REAL BOARD + Neighbours count  --- ')
        var allCells = _realBoard.getCellsLinear();
        for (var i = 0; i < allCells.length; i++) {
            Board.cellNearbyMines(allCells[i], _realBoard);
        }

        trace(' ----- NEW FULFILL REAL BOARD--- ')
        Board.printBoardCount(_realBoard);
        trace('')
        //
        _userBoard = _realBoard.clone();
        //

        trace(' ----- USER BOARD --- ')
        //Board.printBoard(_userBoard);
        _state = GameState.PROGRESS;
        dispatchEvent(new GameEvent(GameEvent.STATE, state));
    }

    public function cellClick(cell:Cell):void {
        trace(' ---- cellClick '+cell+':'+cell.cellId+' --- ')
        const bc:Cell = userBoard.getCell(cell.colIndex, cell.rowIndex);

        if (bc && bc.view){
            MovieClip(bc.view).gotoAndStop(CellFrameLabel.DISCOVERED_1);
        }
    }
}
}
