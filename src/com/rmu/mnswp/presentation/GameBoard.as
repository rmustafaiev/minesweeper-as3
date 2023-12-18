package com.rmu.mnswp.presentation {
import com.rmu.mnswp.common.Assets;
import com.rmu.mnswp.model.Cell;
import com.rmu.mnswp.presentation.CellFrameLabel;
import com.rmu.mnswp.model.GameState;
import com.rmu.mnswp.common.BasicComponent;
import com.rmu.mnswp.events.GameEvent;
import com.rmu.mnswp.logic.BoardCtr;
import com.rmu.mnswp.logic.GameModel;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.MouseEvent;

public class GameBoard extends BasicComponent {

    public function get model():GameModel {
        return _model;
    }

    public function get controller():BoardCtr {
        return _controller;
    }

    private var _model:GameModel;
    private var _controller:BoardCtr;

    private function indexesToName(i:int, j:int):String {
        return i.toString() + ":" + j.toString();
    }

    private function nameToIndexes(name:String):Array {
        var res:Array = name.split(":");
        if (res.length > 0) {
            return [parseInt(res[0]), parseInt(res[1])]
        }
        return null;
    }

    private function eventTargetToCell(event):Cell {
        const name:String = event.target && event.target.name;
        const indeces = name && nameToIndexes(name);
        if (name && indeces) {
            return model.userBoard.getCell(indeces[0], indeces[1]);
        }
        return null;
    }
    public function GameBoard(model:GameModel, controller:BoardCtr) {
        this._model = model;
        this._controller = controller;
    }


    override protected function addChildren():void {
        super.addChildren();

        if (model.userBoard) {
            const side:int = model.userBoard.side;
            var childAt:MovieClip;
            var cellAt:Cell;

            for (var i = 0; i < side; i++) {
                for (var j = 0; j < side; j++) {
                    cellAt = model.userBoard.getCell(i, j);
                    childAt = new Assets.refMineCell();
                    childAt.name = indexesToName(i, j);
                    childAt.gotoAndStop(CellFrameLabel.UNDISCOVERED);

                    cellAt.setView(childAt);
                    addChild(childAt);
                }
            }
        }
    }

    public function update(event:GameEvent = null):void {
        switch (event.type) {
            case GameEvent.STATE:
                handleState(event.data);
                break;
            case GameEvent.BOARD:
                handleBoardDataChange(event.data);
                break;
        }
    }

    private function handleBoardDataChange(data:*):void {

    }

    private function handleState(state:*):void {
        switch (state) {
            case GameState.PREPARE:
                boardDestroy();
                addStartListener();
                break;
            case GameState.START:
                addChildren();
                addStartListener();
                break;
            case GameState.PROGRESS:
                boardDestroy();
                addChildren();
                addAllListeners();
                break;
            default:
                break;
        }
    }

    override protected function doLayout():void {
        if (!model.userBoard || !this.numChildren) {
            return;
        }
        const cw:int = 48;
        const padding:int = 2;
        const side:int = model.userBoard.side;
        var childAt:DisplayObject;
        var childNameAt:String;

        for (var i = 0; i < side; i++) {
            for (var j = 0; j < side; j++) {
                childNameAt = indexesToName(i, j);
                childAt = getChildByName(childNameAt);
                childAt.width = childAt.height = cw;
                childAt.x = i * cw + padding;
                childAt.y = j * cw + padding;
            }
        }
    }

    private function boardDestroy():void {
        removeStartListener();
        removeAllListeners();
        if (numChildren) {
            removeChildren(0, numChildren - 1)
        }
    }

    private function addStartListener():void {
        addEventListener(MouseEvent.CLICK, firstClickHandler);
    }

    private function removeStartListener():void {
        removeEventListener(MouseEvent.CLICK, firstClickHandler);
    }

    private function firstClickHandler(event:MouseEvent):void {
        controller.firstTurn(event);
    }

    private function addAllListeners():void {
        addEventListener(MouseEvent.CLICK, cellClickHandler);
        addEventListener(MouseEvent.MOUSE_DOWN, cellMouseDownHandler);
        addEventListener(MouseEvent.MOUSE_UP, cellMouseUpHandler);
        addEventListener(MouseEvent.RIGHT_CLICK, cellRightClickHandler);
        addEventListener(MouseEvent.MOUSE_OVER, cellMouseOverHandler);
        addEventListener(MouseEvent.MOUSE_OUT, cellMouseOutHandler);
    }

    private function removeAllListeners():void {
        removeEventListener(MouseEvent.CLICK, cellClickHandler);
        removeEventListener(MouseEvent.MOUSE_DOWN, cellMouseDownHandler);
        removeEventListener(MouseEvent.MOUSE_UP, cellMouseUpHandler);
        removeEventListener(MouseEvent.RIGHT_CLICK, cellRightClickHandler);
        removeEventListener(MouseEvent.MOUSE_OVER, cellMouseOverHandler);
        removeEventListener(MouseEvent.MOUSE_OUT, cellMouseOutHandler);
    }

    private function cellMouseOutHandler(event:MouseEvent):void {
        //trace(event.type +' - '+ event.target.name)
    }

    private function cellMouseOverHandler(event:MouseEvent):void {
        //trace(event.type +' - '+ event.target.name)
    }

    private function cellRightClickHandler(event:MouseEvent):void {
        //controller.cellRightClickHandler(event);
        //trace(event.type +' - '+ event.target.name)
    }

    private function cellMouseUpHandler(event:MouseEvent):void {
        //TODO Only when cell is dicovered
        return;
        //controller.cellMouseUpHandler(event);
        trace(event.type +' - '+ event.target.name)
    }

    private function cellMouseDownHandler(event:MouseEvent):void {
        //TODO Only when cell is discovered
        // we need to check
        //whether cell discovered and the highlight around cells

        return;
        //controller.cellMouseDownHandler(event);
        trace(event.type +' - '+ event.target.name)
    }

    private function cellClickHandler(event:MouseEvent):void {
        //
        trace(event.type +' - '+ event.target.name)
        const cell:Cell = eventTargetToCell(event);
        if (cell){
            controller.cellClickHandler(cell);
        }
    }
}
}
