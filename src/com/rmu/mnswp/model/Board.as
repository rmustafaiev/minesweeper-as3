package com.rmu.mnswp.model {
import flash.display.DisplayObject;

public class Board {
    private static const RESERVED_CELL_COUNT:int = 5;

    private var _board:Array;
    private var _side:int;
    private var _flatBoard:Array;

    /**
     * Avoids to put mine to first User clicked cell,
     * and places mines randomly, safe for first click.
     *
     * Returns same board.
     *
     * Safe cells now had a state as Reserved,
     * in total 5 Cells are safe all CORNERS + CLICKED Cell
     * @param clickedCell
     * @param minesCount
     * @param board
     * @return board Board - same board
     */
    public static function firstClickSafeWithMines(clickedCell:Cell, minesCount:int, board:Board):Board {
        var cellOnBoard:Cell = board.getCell(clickedCell.colIndex, clickedCell.rowIndex);

        if (cellOnBoard) {
            cellOnBoard.__setState(CellState.RESERVED);
            board.getCell(0, 0).__setState(CellState.RESERVED);
            board.getCell(0, board.side - 1).__setState(CellState.RESERVED);
            board.getCell(board.side - 1, board.side - 1).__setState(CellState.RESERVED);
            board.getCell(board.side - 1, 0).__setState(CellState.RESERVED);
        }
        return Board.randomMines(minesCount, board);
    }

    /**
     * Places mines randomly, not safe for first click,
     * Returns same board
     * @param minesCount
     * @param board
     * @return
     */
    public static function randomMines(minesCount:int, board:Board):Board {
        var minesCount = minesCount > 0 ? Math.min(minesCount, board.side * 2 - RESERVED_CELL_COUNT) : 0;
        var count:int = 0;
        var random:int, row:int, col:int;
        var guard:int = 10000;
        var cellAt:Cell;

        while (count < minesCount) {
            random = Math.floor(Math.random() * (board.side * board.side));
            col = Math.floor(random / board.side);
            row = random % board.side;

            try {
                cellAt = board.getCell(col, row);
                if (!cellAt.isMined() && !cellAt.isReserved()) {
                    cellAt.__setState(CellState.MINED);
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

    /**
     * Calculates nearby mines,
     * fulfills cell counts, returns same Board
     * @param cell:Cell
     * @param board:Board
     */
    public static function cellNearbyMines(cell:Cell, board:Board):Board {
        /*
        Cell has 8 neighbours
        [10:30]  \  [12:00]  / [1:30]
        [9:00]  -    [0]  -   [3]
        [7:30]  /    [6] \   [4:30]

        0 - this cell [0,0]
        24:00 [row-1, col]
        13:30 [row-1, col+1]
        15:00 [row, col+1]
        16:30 [row+1, col+1)
        18:00 [row+1, col]
        20:30 [row+1, col-1]
        21:00 [row, col-1]
        22:30 [row-1, col-1]
        24:00 [row-1, col+1]
        */

        var lookupCell:Cell = null;
        if (cell) {
            //  0 - this cell [0,0] 24:00 [row-1, col+1]
           //  24:00 [row-1, col]
            cell.setCount(0);
            lookupCell = board.getCell(cell.colIndex, cell.rowIndex - 1);
            if (lookupCell) {
                if (lookupCell.state === CellState.MINED) {
                    cell.setCount(cell.count + 1);
                }
            }
            // 13:30 [row-1, col+1]
            lookupCell = board.getCell(cell.colIndex + 1, cell.rowIndex - 1);
            if (lookupCell) {
                if (lookupCell.state === CellState.MINED) {
                    cell.setCount(cell.count + 1);
                }
            }
            // 15:00 [row, col+1]
            lookupCell = board.getCell(cell.colIndex + 1, cell.rowIndex);
            if (lookupCell) {
                if (lookupCell.state === CellState.MINED) {
                    cell.setCount(cell.count + 1);
                }
            }
            //  16:30 [row+1, col+1)
            lookupCell = board.getCell(cell.colIndex + 1, cell.rowIndex + 1);
            if (lookupCell) {
                if (lookupCell.state === CellState.MINED) {
                    cell.setCount(cell.count + 1);
                }
            }
            //  18:00 [row+1, col]
            lookupCell = board.getCell(cell.colIndex, cell.rowIndex + 1);
            if (lookupCell) {
                if (lookupCell.state === CellState.MINED) {
                    cell.setCount(cell.count + 1);
                }
            }
            //  20:30 [row+1, col-1]
            lookupCell = board.getCell(cell.colIndex - 1, cell.rowIndex + 1);
            if (lookupCell) {
                if (lookupCell.state === CellState.MINED) {
                    cell.setCount(cell.count + 1);
                }
            }
            //  21:00 [row, col-1]
            lookupCell = board.getCell(cell.colIndex - 1, cell.rowIndex);
            if (lookupCell) {
                if (lookupCell.state === CellState.MINED) {
                    cell.setCount(cell.count + 1);
                }
            }
            // 22:30 [row-1, col-1]
            lookupCell = board.getCell(cell.colIndex - 1, cell.rowIndex - 1);
            if (lookupCell) {
                if (lookupCell.state === CellState.MINED) {
                    cell.setCount(cell.count + 1);
                }
            }
        }
        return board;
    }

    public static function printBoardState(board:Board):void {
        for (var i = 0; i < board.side; i++) {
            var row:String = '';
            for (var j = 0; j < board.side; j++) {
                row += "\t|\t" + board.getCell(i, j).state;
            }
            trace(row + "\t|")
        }
    }

    public static function printBoardIndexes(board:Board):void {
        for (var i = 0; i < board.side; i++) {
            var row:String = '';
            for (var j = 0; j < board.side; j++) {
                row += "\t|\t" + i + ":" + j;
            }
            trace(row + "\t|")
        }
    }

    public static function printBoardCount(board:Board):void {
        for (var i = 0; i < board.side; i++) {
            var row:String = '';
            for (var j = 0; j < board.side; j++) {
                row += "\t|\t" + board.getCell(i, j).count;
            }
            trace(row + "\t|")
        }
    }

    public function Board(side:int = 6) {
        _side = side;
        _board = [];
        _flatBoard = [];
        for (var i = 0; i < side; i++) {
            _board[i] = [];
            for (var j = 0; j < side; j++) {
                _board[i][j] = new Cell(i, j, 0, CellState.UNDEFINED);
                _flatBoard.push(_board[i][j]);
            }
        }
    }

    public function get side():int {
        return _side;
    }

    public function getCell(col:int, row:int):Cell {
        if (col < 0 || col > side - 1 || row < 0 || row > side - 1) {
            return null;
        }
        return _board[col][row];
    }

    public function getCellsLinear():Array {
        return _flatBoard;
    }

    //@private
    public function __replaceCell(i:int, j:int, cell:Cell):void {
        _board[i][j] = cell;
    }

    //@private
    public function __rebuildFlatBoard(newBoard:Array = null):void {
        if (newBoard && newBoard.length) {
            _flatBoard = [].concat(newBoard);
        }
    }

    public function findCellByView(view:DisplayObject):Cell {
        var res = _flatBoard.filter(function (cellAt:*) {
            if (Cell(cellAt).view === view) {
                return true;
            }
        });

        if (res && res.length){
            return res[0];
        }
        return null;
    }

    public function clone():Board {
        var thisBoard:Array = [].concat(_board);
        var clone:Board = new Board(_side);
        var reindexArr:Array = [];
        var newCell:Cell;
        for (var i = 0; i < side; i++) {
            for (var j = 0; j < side; j++) {
                newCell = thisBoard[i][j].clone()
                clone.__replaceCell(i, j, newCell);
                reindexArr.push(newCell);
            }
        }
        clone.__rebuildFlatBoard(reindexArr);
        return clone;
    }
}
}
