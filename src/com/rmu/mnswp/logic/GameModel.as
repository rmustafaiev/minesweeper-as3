package com.rmu.mnswp.logic {
import com.rmu.mnswp.model.CellState;
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


    /**
     * Initiate Game Start
     */
    public function playGame():void {
        _state = GameState.START;
        dispatchEvent(new GameEvent(GameEvent.STATE, state));
    }

    public function resetGame():void {

    }

    /**
     * Create new board just PREPARATION
     * @param boardSize
     * @param minesCount
     */
    public function newGame(boardSize = 9, minesCount:int = 10):void {
        _boardSize = boardSize
        _minesCount = minesCount
        _userBoard = new Board(boardSize);

        _state = GameState.PREPARE;
        dispatchEvent(new GameEvent(GameEvent.STATE, state));
    }
    /**
     * Create new Boards with SAFE cells,
     * First Board Cell has been clicked
     * game progress initiated here
     * @param cell - clicked cell
     */
    public function performFirstBoardCellClick(cell:Cell):void {
        const tmpCol:int = cell.colIndex;
        const tmpRow:int = cell.rowIndex;

        _realBoard = new Board(_boardSize);
        _realBoard = Board.firstClickSafeWithMines(cell, _minesCount, _realBoard);

        trace(' ---- BOARD + MINES  ---- ')
        Board.printBoardMines(_realBoard);
        // fill board nearby cells count
        const boardAllCells = _realBoard.getCellsLinear();
        for (var i = 0; i < boardAllCells.length; i++) {
            Board.cellNearbyMines(boardAllCells[i], _realBoard);
        }

        // copy to user board
        _userBoard = _realBoard.clone();
        // time to game, now progress starts!
        _state = GameState.PROGRESS;
        dispatchEvent(new GameEvent(GameEvent.STATE, state));

        // Reveal 1st clicked Cell
        const cellShow:Cell = userBoard.getCell(tmpCol, tmpRow);
        cellShow.__setState(CellState.OPEN);
        dispatchEvent(new GameEvent(GameEvent.BOARD, [cellShow]));
    }

    /**
     * Game in progress, User keep discovering cells
     * @param cell - clicked cell
     */
    public function performBoardCellClick(cell:Cell):void {
        trace(' ---- cellClick '+cell+':'+cell.cellId+' --- ')
        const bc:Cell = userBoard.getCell(cell.colIndex, cell.rowIndex);
        // Ignore flagged cells
        if (bc.isFlagged()){
            return;
        }
        // Bada boom!!!
        if (bc.isMined()){
            bc.__setState(CellState.MINED);
            dispatchEvent(new GameEvent(GameEvent.BOARD, [bc]));
            _state = GameState.LOOSE;
            dispatchEvent(new GameEvent(GameEvent.STATE, [bc]));
        }
        else {
            // Game must go on.
            bc.__setState(CellState.OPEN);
            dispatchEvent(new GameEvent(GameEvent.BOARD, [bc]));
        }
    }

    public function performBoardCellRightClick(cell:Cell):void {
        const bc:Cell = userBoard.getCell(cell.colIndex, cell.rowIndex);
        const rbc:Cell = realBoard.getCell(cell.colIndex, cell.rowIndex);
        if (!bc.isFlagged()){
            bc.__setState(CellState.FLAGGED);
        }
        else{
            bc.__setState(rbc.state);
        }
        dispatchEvent(new GameEvent(GameEvent.BOARD, [bc]));
    }
}
}
