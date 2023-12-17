package com.rmu.mnswp.events {
import flash.events.Event;

public class GameEvent extends Event {

    public static const STATE:String = 'state_change';
    public static const STATISTICS:String = 'statistics_change';
    public static const BOARD:String = 'board_data_change';

    public function get data():* {
        return _data;
    }

    private var _data:*;

    public function GameEvent(type, data:* = null):void {
        super(type, false, false);
        this._data = data;
    }

    override public function clone():Event {
        return new GameEvent(this.type, this._data);
    }

}
}
