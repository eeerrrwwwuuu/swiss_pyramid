//+------------------------------------------------------------------+
//|                                                   Tail_Stops.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input string   vCurrencyPair;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
 
   int total= OrdersTotal();
   
   string curr = vCurrencyPair;
   curr = StringToUpper( curr ) ; 
   
   for(int i=total-1;i>=0;i--)
     {
      int ticket;
      
      ticket = OrderSelect(i,SELECT_BY_POS);
      int type=OrderType();
      
 
      string symbol=OrderSymbol();
      symbol = StringToUpper(symbol);
      
     
      if( curr  == symbol) 
         continue;
         
      double Step = StrToDouble(OrderComment());
      
      Print( StrToDouble(OrderComment()));
      
      if( Step > 0 ) {
        switch(OrderType()){
          case OP_BUYSTOP: case OP_BUY: case OP_BUYLIMIT:
            OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss()+Step, OrderTakeProfit(),NULL, Yellow);
            break;
          case OP_SELLLIMIT: case OP_SELL: case OP_SELLSTOP:
            OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss()-Step, OrderTakeProfit(),NULL, Yellow);
          break; 
        }
     } 
      
   }
   WindowRedraw();
}