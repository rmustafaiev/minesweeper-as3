package com.rmu.mnswp.presentation {
import com.rmu.mnswp.common.Assets;
import com.rmu.mnswp.model.GameState;
import com.rmu.mnswp.common.BasicComponent;
import com.rmu.mnswp.events.GameEvent;
import com.rmu.mnswp.logic.BoardCtr;
import com.rmu.mnswp.logic.GameModel;
import com.rmu.mnswp.logic.InteractionCtr;

import flash.display.Bitmap;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;

public class GameView extends BasicComponent {
    /**
     * Game view
     * @param model
     * @param controller
     * @param viewportMin
     */
    public function GameView(model:GameModel, controller:InteractionCtr, viewportMin:Rectangle) {
        super(viewportMin);
        this._model = model;
        this._controller = controller;
    }
    private var background:Bitmap;
    private var logo:Sprite;
    private var playBtn:SimpleButton;
    private var resetBtn:SimpleButton;
    private var gameTimer:Sprite;
    private var minesDisplay:Sprite;
    private var bottomEmptyPlaceholder:Sprite;
    private var topmostEmptyPlaceholder:Sprite;
    private var gameBoard:GameBoard;
    private var _model:GameModel;
    private var _controller:InteractionCtr;

    public function get model():GameModel {
        return _model;
    }

    public function get controller():InteractionCtr {
        return _controller;
    }

    override protected function initialize():void {
        super.initialize(); //schedule invalidateLayout
        playBtn.addEventListener(MouseEvent.CLICK, onPlayBtnClick);
        resetBtn.addEventListener(MouseEvent.CLICK, onResetBtnClick);
    }

    override protected function addChildren():void {
        background = new Assets.refGameBackground();
        logo = new Assets.refGameLogo();
        playBtn = new Assets.refPlayBtn();
        resetBtn = new Assets.refResetBtn();
        gameTimer = new Assets.refGameTimer();
        minesDisplay = new Assets.refMinesDisplay();
        bottomEmptyPlaceholder = new Sprite();
        topmostEmptyPlaceholder = new Sprite();
        gameBoard = new GameBoard(this.model, new BoardCtr(this.model));

        addChild(background);
        addChild(logo);
        addChild(bottomEmptyPlaceholder);
        addChild(gameTimer);
        addChild(minesDisplay);
        addChild(playBtn);
        addChild(resetBtn);
        addChild(topmostEmptyPlaceholder);
        bottomEmptyPlaceholder.addChild(gameBoard);
        super.addChildren();
    }

    override protected function resize(width:Number, height:Number):void{
        invalidateLayout();
    }

    /*
        ** NOTE this is just an example and not exact or pixel perfect match.
        Goal was to fit controls/graphic within the view container
        dynamically,
        approx scales and ratios have been calculated.
        e.g. logo should be 1/10 of total height etc ...
     */
    override protected function doLayout():void {
        const logoScale:Number = 0.10;
        const gameTimerScale:Number = 0.1;
        const minesDisplayScale:Number = 0.1;
        const resetBtnScale:Number = 0.07;
        const playBtnScale:Number = 0.11;

        // stitch to actual width height ratio
        const bgRatio:Number = background.width / background.height;
        const logoRatio:Number = logo.width / logo.height;
        const gameTimerRatio:Number = gameTimer.width / gameTimer.height;
        const minesDisplayRatio:Number = minesDisplay.width / minesDisplay.height;
        const playBtnRatio:Number = playBtn.width / playBtn.height;
        const resetBtnRatio:Number = resetBtn.width / resetBtn.height;

        const viewArea:Rectangle = new Rectangle(0, 0,
                fitBetween(viewport.width, viewportMax.width, viewportMin.width),
                fitBetween(viewport.height, viewportMax.height, viewportMin.height)
        )

        background.x = background.y = 0;
        background.height = viewArea.height;
        background.width = background.height * bgRatio;

        logo.height = viewArea.height * logoScale;
        logo.width = logo.height * logoRatio;
        logo.x = (viewArea.width - logo.width) / 2;
        logo.y = 10;

        gameTimer.height = viewArea.height * gameTimerScale;
        gameTimer.width = gameTimer.height * gameTimerRatio;
        gameTimer.y = logo.y + logo.height;
        gameTimer.x = logo.x - (gameTimer.width - 10);

        minesDisplay.height = viewArea.height * minesDisplayScale;
        minesDisplay.width = gameTimer.height * minesDisplayRatio;
        minesDisplay.y = logo.y + logo.height;
        minesDisplay.x = logo.x + (logo.width - 10);

        resetBtn.height = viewArea.height * resetBtnScale;
        resetBtn.width = resetBtn.height * resetBtnRatio;
        resetBtn.y = gameTimer.y + gameTimer.height / 2 - resetBtn.height / 2;
        resetBtn.x = logo.x + logo.width / 2 - resetBtn.width / 2;

        playBtn.height = viewArea.height * playBtnScale;
        playBtn.width = playBtn.height * playBtnRatio;
        playBtn.y = viewArea.height / 2 - playBtn.height / 2;
        playBtn.x = viewArea.width / 2 - playBtn.width / 2;

        gameBoard.x = viewArea.width/2 - gameBoard.width/2;
        gameBoard.y = (gameTimer.y + gameTimer.height)+ 20;
    }

    private function handleState(state:*):void {
        switch (state){
            case GameState.PREPARE:
                showPrepareGame();
                break;
            case GameState.START:
                showFirstTurn();
                break;
            case GameState.PROGRESS:
                showProgress();
                break;
            case GameState.WIN:
                showYouWin();
                break;
            case GameState.LOOSE:
                showYouLoose();
                break;
            default:
                break;
        }
    }

    private function showYouWin():void {
        playBtn.visible = false;
        resetBtn.visible = false;
    }
    private function showYouLoose():void {
        playBtn.visible = false;
        resetBtn.visible = false;
    }

    private function showPrepareGame():void {
        playBtn.visible = true;
        resetBtn.visible = false;
        gameTimer.visible = false;
        minesDisplay.visible = false;
        gameBoard.visible = false;
    }

    private function showFirstTurn():void{
        playBtn.visible = false;
        resetBtn.visible = false;
        gameTimer.visible = true;
        minesDisplay.visible = true;
        gameBoard.visible = true;
        updateStats();
        invalidateLayout();
    }

    private function showProgress():void{
        playBtn.visible = false;
        resetBtn.visible = true;
        gameTimer.visible = true;
        minesDisplay.visible = true;
        gameBoard.visible = true;
        updateStats();
    }

    private function handleStatisticsChange(data:*):void {
        updateStats();
    }

    private function updateStats():void {
        var timerTf:TextField = gameTimer.getChildByName('timerField') as TextField;
        var minesTf:TextField = minesDisplay.getChildByName('minesField') as TextField;

        if (timerTf){
            timerTf.text = model.timer === 0 ? "" : model.timer.toString();
        }
        if (minesTf){
            minesTf.text = model.minesDiscovered === 0 ? "" : model.minesDiscovered.toString();
        }
    }

    public function update(event:GameEvent):void {
        gameBoard.update(event);
        /*
        impl strategy
        eg
        getStartegy by event type
         */
        switch (event.type){
            case GameEvent.STATE:
                    handleState(event.data);
                break;
            case GameEvent.STATISTICS:
                    handleStatisticsChange(event.data)
                break;
        }

    }

    private function onResetBtnClick(event:MouseEvent):void {
        controller.onResetBtnClickHandler(event);
    }

    private function onPlayBtnClick(event:MouseEvent):void {
        controller.onPlayBtnClickHandler(event);
    }

}
}
