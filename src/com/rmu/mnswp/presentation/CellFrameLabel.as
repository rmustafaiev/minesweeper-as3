package com.rmu.mnswp.presentation {
import com.rmu.mnswp.model.Cell;
import com.rmu.mnswp.model.CellState;

public class CellFrameLabel {

    public static const UNDISCOVERED:String = 'UNDISCOVERED';
    public static const FLAG_SET:String = 'FLAG_SET';
    public static const UNDISCOVERED_HIGHLIGHT:String = 'UNDISCOVERED_HIGHLIGHT';
    public static const DISCOVERED_EMPTY:String = 'DISCOVERED_EMPTY';
    public static const DISCOVERED_1:String = 'DISCOVERED_1';
    public static const DISCOVERED_2:String = 'DISCOVERED_2';
    public static const DISCOVERED_3:String = 'DISCOVERED_3';
    public static const DISCOVERED_4:String = 'DISCOVERED_4';
    public static const DISCOVERED_5:String = 'DISCOVERED_5';
    public static const DISCOVERED_6:String = 'DISCOVERED_6';
    public static const DISCOVERED_7:String = 'DISCOVERED_7';
    public static const DISCOVERED_MINE:String = 'BOOM';

    public static function cellStateToFrameLabel(cell:Cell):String{
        switch (cell.state){
            case CellState.MINED:
                return DISCOVERED_MINE;
            case CellState.FLAGGED:
                return FLAG_SET;
            case CellState.HIDDEN:
                return UNDISCOVERED;
            case CellState.OPEN:
                var ptr:String = 'DISCOVERED_';
                    return (cell.count === 0)
                            ? DISCOVERED_EMPTY
                            : ptr+cell.count.toString()
                break;
        }
        return UNDISCOVERED;
    }
}
}
