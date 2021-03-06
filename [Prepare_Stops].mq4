//+------------------------------------------------------------------+
//|                                                    Prepare Stops |
//|                              Copyright © 2011, BeyondMarkets.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, BeyondMarkets.com"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

int start()
  { 
  double ATR = iATR(NULL, 0, 15, 0);
  ATR=(ATR*2);
  if ((ObjectFind("StopLine1") < 0) && (ObjectFind("StopLine2") < 0)) {
    ObjectCreate("StopLine1", OBJ_HLINE, 0, TimeCurrent(), Close[0]+ATR);
    ObjectSet("StopLine1", OBJPROP_COLOR, clrPink);
    ObjectCreate("StopLine2", OBJ_HLINE, 0, TimeCurrent(), Close[0]-ATR);
    ObjectSet("StopLine2", OBJPROP_COLOR, clrPink);
  } else {
    if (ObjectFind("EntryLine1") < 0) {
      ObjectCreate("EntryLine1", OBJ_HLINE, 0, TimeCurrent(), Close[0]);
      ObjectSet("EntryLine1", OBJPROP_COLOR, clrMagenta);     
      ObjectSet("EntryLine1",OBJPROP_STYLE,STYLE_DASH);
    } else {
      if (ObjectFind("StopLine1") >= 0) ObjectDelete("StopLine1");
      if (ObjectFind("StopLine2") >= 0) ObjectDelete("StopLine2");
      if (ObjectFind("EntryLine1") >= 0) ObjectDelete("EntryLine1");
    }
  }
  ObjectsRedraw();
  return(0);
  }
//+------------------------------------------------------------------+