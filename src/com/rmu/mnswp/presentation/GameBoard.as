package com.rmu.mnswp.presentation {
import com.rmu.mnswp.common.Assets;
import com.rmu.mnswp.common.CellFrameLabel;
import com.rmu.mnswp.common.GameState;
import com.rmu.mnswp.components.BasicComponent;
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
    private var _allCells:Array = [];

    public function GameBoard(model:GameModel, controller:BoardCtr) {
        this._model = model;
        this._controller = controller;
        this._allCells = [];
    }


    override protected function addChildren():void {
        super.addChildren();

        if (model.userBoard) {
            var childAt:MovieClip;
            for (var i = 0; i < model.userBoard.side; i++) {
                for (var j = 0; j < model.userBoard.side; j++) {
                    childAt = new Assets.refMineCell();
                    childAt.name = model.userBoard.getAt(i, j).cellId;
                    childAt.gotoAndStop(CellFrameLabel.UNDISCOVERED);
                    _allCells.push(childAt);
                    addChild(childAt)
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
            case GameState.NEW:
                boardDestroy();
                break;
            case GameState.STARTED:
                addChildren();
                addStartListener();
                break;
            case GameState.PROGRESS:
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
        var offsetX = 0;
        var offsetY = 0;
        var cellAt:DisplayObject;
        var childNameAt:String;
        for (var i = 0; i < model.userBoard.side; i++) {
            for (var j = 0; j < model.userBoard.side; j++) {
                childNameAt = model.userBoard.getAt(i,j).cellId;
                cellAt = getChildByName(childNameAt);
                cellAt.width = cellAt.height = cw;
                cellAt.x = offsetX;
                cellAt.y = offsetY;
                offsetY = j * cw + padding;
            }
            offsetX = i * cw + padding;
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
        var z = event.target;
        trace(event.target)
    }

    private function addAllListeners():void {
        if (_allCells.length) {
            var cellAt:DisplayObject;
            for (var i = 0; i < _allCells.length; i++) {
                cellAt = _allCells[i];
                cellAt.addEventListener(MouseEvent.CLICK, cellClickHandler);
                cellAt.addEventListener(MouseEvent.MOUSE_DOWN, cellMouseDownHandler);
                cellAt.addEventListener(MouseEvent.MOUSE_UP, cellMouseUpHandler);
                cellAt.addEventListener(MouseEvent.RIGHT_CLICK, cellRightClickHandler);
                cellAt.addEventListener(MouseEvent.MOUSE_OVER, cellMouseOverHandler);
                cellAt.addEventListener(MouseEvent.MOUSE_OUT, cellMouseOutHandler);
            }
        }
    }

    private function removeAllListeners():void {
        if (_allCells.length) {
            var cellAt:DisplayObject;
            for (var i = 0; i < _allCells.length; i++) {
                cellAt = _allCells[i];
                cellAt.removeEventListener(MouseEvent.CLICK, cellClickHandler);
                cellAt.removeEventListener(MouseEvent.MOUSE_DOWN, cellMouseDownHandler);
                cellAt.removeEventListener(MouseEvent.MOUSE_UP, cellMouseUpHandler);
                cellAt.removeEventListener(MouseEvent.RIGHT_CLICK, cellRightClickHandler);
                cellAt.removeEventListener(MouseEvent.MOUSE_OVER, cellMouseOverHandler);
                cellAt.removeEventListener(MouseEvent.MOUSE_OUT, cellMouseOutHandler);
            }
        }
    }

    private function cellMouseOutHandler(event:MouseEvent):void {

    }

    private function cellMouseOverHandler(event:MouseEvent):void {

    }

    private function cellRightClickHandler(event:MouseEvent):void {
        //controller.cellRightClickHandler(event);
    }

    private function cellMouseUpHandler(event:MouseEvent):void {
        //controller.cellMouseUpHandler(event);
    }

    private function cellMouseDownHandler(event:MouseEvent):void {
        //controller.cellMouseDownHandler(event);
    }

    private function cellClickHandler(event:MouseEvent):void {
        //controller.cellClickHandler(event);
    }


    private function addBtnsCtrl():void {


        function cellName(i:int, j:int):String {
            return 'cell[' + i + '][' + j + ']';
        }

        const states:Array = [
            CellFrameLabel.UNDISCOVERED,
            CellFrameLabel.DISCOVERED_EMPTY,
            CellFrameLabel.UNDISCOVERED_HIGHLIGHT,
            CellFrameLabel.DISCOVERED_MINE,
            CellFrameLabel.FLAG_SET,
            CellFrameLabel.DISCOVERED_1,
            CellFrameLabel.DISCOVERED_2,
            CellFrameLabel.DISCOVERED_3,
            CellFrameLabel.DISCOVERED_4,
            CellFrameLabel.DISCOVERED_5,
            CellFrameLabel.DISCOVERED_6,
            CellFrameLabel.DISCOVERED_7]

//addChild(cell);
        const cells:Array = [];
        const cw:int = 48;
        const padding:int = 2;
        var offsetX = 0;
        var offsetY = 0;
        var cellAt:MovieClip;
        for (var i:int = 0; i < 10; i++) {
            for (var j:int = 0; j < 10; j++) {
                var label:String = states[Math.floor(Math.random() * states.length)]
                cellAt = new Assets.refMineCell();
                cellAt.name = cellName(i, j);
                cellAt.gotoAndStop(label);
                cellAt.width = cellAt.height = cw;
                cellAt.x = offsetX;
                cellAt.y = offsetY;


                offsetY = j * cw;
                addChild(cellAt)
            }
            offsetX = i * cw;
        }
    }


}
}
