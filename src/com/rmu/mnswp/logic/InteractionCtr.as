package com.rmu.mnswp.logic {
import com.rmu.mnswp.logic.GameModel;

import flash.display.Stage;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;

public class InteractionCtr {

    private var _model:GameModel;

    public function get model():GameModel{
        return _model;
    }
    public function InteractionCtr(model:GameModel) {
        this._model = model;
    }


    public function onPlayBtnClickHandler(event:MouseEvent):void {
        model.playGame();
    }

    public function onResetBtnClickHandler(event:MouseEvent):void {
        model.resetGame();
    }
}
}
