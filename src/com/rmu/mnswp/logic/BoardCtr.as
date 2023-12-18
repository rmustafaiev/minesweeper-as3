package com.rmu.mnswp.logic {

import com.rmu.mnswp.model.Cell;

import flash.display.DisplayObject;

import flash.events.Event;

public class BoardCtr {
    private var _model:GameModel;
    public function BoardCtr(model:GameModel) {
        this._model = model;
    }

    public function get model():GameModel {
        return _model;
    }

    public function firstTimeCellClickHandler(event:Event):void {
        const cell:Cell = eventTargetToCell(event);
        if (cell) {
            model.performFirstBoardCellClick(cell);
        }
    }

    public function cellClickHandler(event:Event):void {
        const cell:Cell = eventTargetToCell(event);
        if (cell) {
            model.performBoardCellClick(cell);
        }
    }

    public function cellRightClickHandler(event:Event):void {
        const cell:Cell = eventTargetToCell(event);
        if (cell) {
            model.performBoardCellRightClick(cell);
        }
    }

    private function eventTargetToCell(event):Cell {
        const name:String = event.target && event.target.name;
        const indeces = name && nameToIndexes(name);
        if (name && indeces) {
            return model.userBoard.getCell(indeces[0], indeces[1]);
        }
        return null;
    }

    private function nameToIndexes(name:String):Array {
        var res:Array = name.split(":");
        if (res.length > 0) {
            return [parseInt(res[0]), parseInt(res[1])]
        }
        return null;
    }


}
}
