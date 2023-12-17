package com.rmu.mnswp.model {
import com.rmu.mnswp.model.Board;

public class Board {
    private static const RESERVED_CELL_COUNT:int = 5;
    private var _side:int;
    private var _board:Array;

    public function get side():int {
        return _side;
    }
    public function getAt(col:int, row:int):Cell {
        return _board[col][row];
    }

    public function createCellAt(col:int, row:int, cell:Cell):void {
        this._board[col][row] = cell;
    }

    public function getAll():Array {
        var res:Array = [];
        for (var i = 0; i < side; i++) {
            for (var j = 0; j < side; j++) {
                res.push(_board[i][j]);
            }
        }
        return res;
    }

    public function Board(side:int = 6) {
        _side = side;
        _board = new Array();
        fillBoard();
    }

    private function fillBoard():void {
        for (var i = 0; i < side; i++) {
            _board[i] = new Array();
            for (var j = 0; j < side; j++) {
                _board[i][j] = new Cell(i, j, 0, CellState.UNDEFINED);
            }
        }
    }

    /**
     * Returns Board with first click safe
     * @param clickedCell
     * @param minesCount
     * @param board
     * @return
     */
    public static function firstClickSafeWithMines(clickedCell:Cell, minesCount:int, board:Board):Board {
        var boardCell = board.getAt(clickedCell.rowIndex, clickedCell.colIndex);

        if (boardCell){
            boardCell.setState(CellState.RESERVED);
            board.getAt(0,0).setState(CellState.RESERVED);
            board.getAt(0,board.side-1).setState(CellState.RESERVED);
            board.getAt(board.side-1,board.side-1).setState(CellState.RESERVED);
            board.getAt(board.side-1,0).setState(CellState.RESERVED);
        }
        return Board.randomMines(minesCount, board);
    };

    public static function randomMines(minesCount:int, board:Board):Board {
        var minesCount = minesCount > 0 ? Math.min(minesCount, board.side*2-RESERVED_CELL_COUNT) : 0;
        var count:int = 0;
        var random:int, row:int, col:int;
        var guard:int = 10000;
        var cellAt:Cell;

        while (count < minesCount) {
            random = Math.floor(Math.random() * (board.side * board.side));
            col = Math.floor(random / board.side);
            row = random % board.side;

            try {
                cellAt = board.getAt(col, row);
                if (cellAt.state !== CellState.MINED && (cellAt.state !== CellState.RESERVED)) {
                    cellAt.setState(CellState.MINED);
                    cellAt.setValue(1);
                    // trace("Placed: "+random+" col: "+col+" row: "+row);
                    count++;
                } else {
                    //trace("     >> New attempt to generate: random: " + random + " col: " + col + " ,row: " + row + " guard: " + guard);
                }
            } catch (err) {
                throw new Error('Unable to generate board mines, attempts exceeded.');
            }

            if (guard < 0) {
                throw new Error('Unable to generate board mines, attempts exceeded.');
            }
            guard--;
        }
        return board;
    }

    public static function printBoard(board:Board):void {
        for (var i = 0; i < board.side; i++) {
            var row:String = '';
            for (var j = 0; j < board.side; j++) {
                row += "\t|\t" + board.getAt(i, j).state;
            }
            trace(row + "\t|")
        }
    }

    public function clone():Board {
        var newBoard:Board = new Board(side);
        for (var i = 0; i < side; i++) {
            for (var j = 0; j < side; j++) {
                newBoard.createCellAt(i,j, getAt(i,j).clone())
            }
        }
        return newBoard;
    }


}
}
