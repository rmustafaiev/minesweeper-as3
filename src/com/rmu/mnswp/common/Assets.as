package com.rmu.mnswp.common {
import com.rmu.mnswp.model.Cell;

import flash.display.MovieClip;

public class Assets {

    [Embed(source='../../../../../assets/MinesweeperLibrary.swf', symbol='SymbGameLogo')]
    public static const refGameLogo:Class;

    [Embed(source='../../../../../assets/GameBackground.png')]
    public static const refGameBackground:Class;

    [Embed(source='../../../../../assets/MinesweeperLibrary.swf', symbol='SymbGameTimer')]
    public static const refGameTimer:Class; // -> timerField

    [Embed(source='../../../../../assets/MinesweeperLibrary.swf', symbol='SymbMinesControl')]
    public static const refMinesDisplay:Class;// -> minesField

    [Embed(source='../../../../../assets/MinesweeperLibrary.swf', symbol='SymbPlayBtn')]
    public static const refPlayBtn:Class;

    [Embed(source='../../../../../assets/MinesweeperLibrary.swf', symbol='SymbResetBtn')]
    public static const refResetBtn:Class;

    [Embed(source='../../../../../assets/MinesweeperLibrary.swf', symbol='SymbMineCell')]
    public static const refMineCell:Class;
}
}