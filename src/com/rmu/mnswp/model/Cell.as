package com.rmu.mnswp.model {
import flash.display.DisplayObject;

public class Cell {
    private var _colIndex:int;
    private var _rowIndex:int;
    private var _state:int;
    private var _count:int;
    private var _cellId:String;
    private var _view:DisplayObject;

    public function get count():int {
        return _count;
    }

    public function setCount(cnt:int):void {
        _count = cnt;
    }

    public function get state():int {
        return _state;
    }

    /**
     * @private
     * @return
     */
    public function __setState(state:int):void {
        _state = state;
    }

    public function isReserved():Boolean {
        return _state === CellState.RESERVED;
    }
    public function isMined():Boolean {
        return _state === CellState.MINED;
    }

    public function isFree():Boolean {
        return _state === CellState.FREE;
    }
    /**
     * Only allowed state to set by user
     * @param value
     */
    public function setFlagged():void {
        _state = CellState.FLAGGED;
    }
    public function isFlagged():Boolean {
        return _state === CellState.FLAGGED;
    }


    public function get rowIndex():int {
        return _rowIndex;
    }

    public function get colIndex():int {
        return _colIndex;
    }

    public function get cellId():String {
        return _cellId;
    }

    public function setView(view:DisplayObject):void {
        _view = view;
    }
    public function get view():DisplayObject {
        return _view;
    }

    public function Cell(col:int, row:int, count:int, state:int, view:DisplayObject = null) {
        _view = view;
        _colIndex = col;
        _rowIndex = row;
        _count = count;
        _state = state;
        _cellId = "cell["+row+":"+col+"]";
    }

    public function clone(clear:Boolean = true):Cell {
        var withView:DisplayObject = clear ? null : this._view
        return new Cell(this._colIndex, this._rowIndex, this._count, this._state, withView);
    }

}
}
