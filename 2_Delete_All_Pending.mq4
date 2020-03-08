//+------------------------------------------------------------------+
//|                                           Delete_All_Pending.mq4 |
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
   int ticket;
   string curr = vCurrencyPair;
   
 
   StringToUpper( curr ) ; 
   
   for(int i=total-1;i>=0;i--){
      
         ticket = OrderSelect(i,SELECT_BY_POS);
         int type=OrderType();
         
         string symbol=OrderSymbol();
         StringToUpper(symbol);
         
         if( StringLen(curr) > 0  && curr  != symbol) 
            continue;
         
         switch(OrderType()){
            case OP_BUY: 
            case OP_SELL:
                  continue;
            break;
            default : 
               OrderDelete(OrderTicket());
            break;
         }
  }
}  
//+------------------------------------------------------------------+
