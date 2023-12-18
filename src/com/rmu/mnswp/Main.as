package com.rmu.mnswp {

import com.rmu.mnswp.common.BasicComponent;
import com.rmu.mnswp.events.GameEvent;
import com.rmu.mnswp.logic.BoardCtr;
import com.rmu.mnswp.logic.GameModel;
import com.rmu.mnswp.logic.InteractionCtr;
import com.rmu.mnswp.presentation.CellFrameLabel;
import com.rmu.mnswp.model.Board;
import com.rmu.mnswp.model.Cell;
import com.rmu.mnswp.presentation.GameBoard;
import com.rmu.mnswp.presentation.GameView;
import com.rmu.mnswp.common.Assets;

import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.geom.Rectangle;
import flash.text.TextField;

[SWF(width="600", height="800", frameRate="60", backgroundColor="#1F0E72")]
public class Main extends BasicComponent {

    // Game minimum Viewport area,
    // Assumption IT MUST NOT BE less than provided,
    // Just use the same as SWF initial size
    private const VIEWPORT_MIN:Rectangle = new Rectangle(0, 0, 600, 800);

    // game main entities
    private var gameModel:GameModel;
    private var interactionCtr:InteractionCtr;
    private var boardCtr:BoardCtr;
    private var gameView:GameView;

    public function Main2() {
    }
    public function Main() {
        super();
//        var testBoard:Board = new Board(7);
//        Board.printBoard(testBoard);
//        //Board.randomMines(35, testBoard);
//        trace('---------------------------')
//        Board.firstClickSafeWithMines(testBoard.getCell(3,3), 5, testBoard);
//        Board.printBoard(testBoard);
//        trace('--------- clone ------------------')
//        Board.printBoard(testBoard.clone());
        this.stage.align = StageAlign.TOP_LEFT;
        this.stage.scaleMode = StageScaleMode.NO_SCALE;


    }

    /**
     * Add children, main already on the stage.
     * since all game instantiation based
     * on constructors,
     * apply build logic here.
     */
    override protected function addChildren():void {
        gameModel = new GameModel();
        interactionCtr = new InteractionCtr(gameModel);
        gameView = new GameView(gameModel, interactionCtr, VIEWPORT_MIN.clone());

        addChild(gameView);
    }

    /**
     * Initialization phase.
     * View and components has been added to stage already.
     */
    override protected function initialize():void {
        gameModel.addEventListener(GameEvent.STATE, gameView.update);
        gameModel.addEventListener(GameEvent.STATISTICS, gameView.update);
        gameModel.addEventListener(GameEvent.BOARD, gameView.update);
        gameModel.newGame();
    }



}
}
