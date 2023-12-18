package com.rmu.mnswp {

import com.rmu.mnswp.common.BasicComponent;
import com.rmu.mnswp.events.GameEvent;
import com.rmu.mnswp.logic.GameModel;
import com.rmu.mnswp.logic.InteractionCtr;
import com.rmu.mnswp.presentation.GameView;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.geom.Rectangle;

[SWF(width="800", height="800", frameRate="60", backgroundColor="#1F0E72")]
public class Main extends BasicComponent {

    // Game minimum Viewport area,
    // Assumption IT MUST NOT BE less than provided,
    // Just use the same as SWF initial size
    private const VIEWPORT_MIN:Rectangle = new Rectangle(0, 0, 600, 800);

    // game main entities
    private var gameModel:GameModel;
    private var interactionCtr:InteractionCtr;
    private var gameView:GameView;

    public function Main() {
        super();
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
