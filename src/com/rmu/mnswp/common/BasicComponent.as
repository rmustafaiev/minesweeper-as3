package com.rmu.mnswp.common {
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Rectangle;

/**
 * Simple base component, handles basic construction phase,
 * Those sub-classes can override, and handle their
 * construction phases respectively.
 *
 * Precedence as follows
 *  addChildren() -  Added to stage so Stage becomes available.
 *                   An invalidateLayout scheduled here,
 *                  those calls doLayout on next frame,
 *                  Also You can call invalidate layout from other methods as well.
 *  preinitialize() - Just before enter frame so
 *                    basic calculations or pre initialization can be completed here
 *  initialize() - On enter frame, do initialization and related stuff.
 *  postinitialize() - End phase for clean up.
 */
public class BasicComponent extends Sprite {
    private static const NullRectangle:Rectangle = new Rectangle();
    private var _invalidateScheduled:Boolean = false;
    private var _viewportMax:Rectangle;
    private var _viewportMin:Rectangle;
    private var _viewport:Rectangle;

    public function get viewportMax():Rectangle {
        return _viewportMax;
    }

    public function get viewportMin():Rectangle {
        return _viewportMin;
    }

    public function get viewport():Rectangle {
        return _viewport;
    }

    public function BasicComponent(viewportMin:Rectangle = null) {
        trace('Ctor::Phased UI Component (' + this + ')');
        _viewport = NullRectangle.clone();
        _viewportMax = NullRectangle.clone();
        _viewportMin = viewportMin || NullRectangle.clone();
        addEventListener(Event.ADDED_TO_STAGE, simplyAdded);
    }

    // comes first
    protected function addChildren():void {
        invalidateLayout();
    }

    protected function preinitialize():void {
    }

    protected function initialize():void {
        if (!this.stage) {
            return;
        }
        this._viewportMax = new Rectangle(0, 0, this.stage.fullScreenWidth, this.stage.fullScreenHeight);
        this._viewport = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
        this.stage.addEventListener(Event.RESIZE, onStageResize);
    }

    protected function postinitialize():void {
    }

    protected function doLayout():void {
    }

    protected function resize(width:Number, height:Number):void {
    }

    protected function invalidateLayout():void {
        if (_invalidateScheduled) {
            return;
        }
        _invalidateScheduled = true;
        addEventListener(Event.ENTER_FRAME, onInvalidateFrame);
    }

    protected function fitBetween(size:int, max:int, min:int):int {
        return size >= max ? max : Math.max(size, min);
    }

    private function onInvalidateFrame(event:Event):void {
        removeEventListener(Event.ENTER_FRAME, onInvalidateFrame);
        _invalidateScheduled = false;
        doLayout();
    }

    private function simplyAdded(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, simplyAdded);
        addEventListener(Event.FRAME_CONSTRUCTED, simplyConstructed);
        addEventListener(Event.ENTER_FRAME, simplyAtFrame);
        addEventListener(Event.EXIT_FRAME, simplyOutFrame);
        addChildren();
    }

    private function simplyConstructed(event:Event):void {
        removeEventListener(Event.FRAME_CONSTRUCTED, simplyConstructed);
        preinitialize();
    }

    private function simplyAtFrame(event:Event):void {
        removeEventListener(Event.ENTER_FRAME, simplyAtFrame);
        initialize();
    }

    private function simplyOutFrame(event:Event):void {
        removeEventListener(Event.EXIT_FRAME, simplyOutFrame);
        postinitialize();
    }


    private function onStageResize(event:Event):void {
        _viewport = new Rectangle(0, 0, Stage(event.target).stageWidth, Stage(event.target).stageHeight);
        resize(viewport.width, viewport.height);
    }


}
}
