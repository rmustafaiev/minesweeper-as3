package com.rmu.mnswp.model {
public class Cell {
    private var _colIndex:int;
    private var _rowIndex:int;
    private var _state:int;
    private var _value:int;
    private var _cellId:String;

    public function get value():int {
        return _value;
    }
    public function setValue(value:int):void {
        _value = value;
    }

    public function get state():int {
        return _state;
    }
    public function setState(value:int):void {
        _state = value;
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

    public function Cell(row:int, col:int, value:int, state:int) {
        _colIndex = col;
        _rowIndex = row;
        _value = value;
        _state = state;
        _cellId = "cell["+row+":"+col+"]";
    }

    public function clone():Cell {
        return new Cell(this._rowIndex, this._colIndex, this._value, this._state)
    }


}
}
