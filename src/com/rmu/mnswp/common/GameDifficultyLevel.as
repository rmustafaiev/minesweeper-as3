package com.rmu.mnswp.common {
public class GameDifficultyLevel {

    private static const boardMax:int = 300;
    private static const boardPercentMax:int = 35;
    private static const boardDifficultyMax:int = 3;

    public static const EASY:GameDifficultyLevel = new GameDifficultyLevel(1, 100, 10);
    public static const NORMAL:GameDifficultyLevel = new GameDifficultyLevel(2, 200, 25);
    public static const HARD:GameDifficultyLevel = new GameDifficultyLevel(3, 300, 35);

    private var _board:int;
    private var _percent:int;
    private var _difficulty:int;

    public function GameDifficultyLevel(level:int, boardSize:int, minesPercent:int) {
        _difficulty = Math.max(level, boardDifficultyMax);
        _percent = Math.max(minesPercent, boardPercentMax);
        _board = Math.max(boardSize, boardMax);
    }


}
}
