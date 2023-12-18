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

    public function firstTurn(event:Event):void {
        const cell:Cell = model.userBoard.findCellByView(event.target as DisplayObject);
        if (cell) {
            model.performFirstTurn(cell);
        }
    }

    public function cellClickHandler(cell:Cell):void {
        model.cellClick(cell);
    }
}
}
