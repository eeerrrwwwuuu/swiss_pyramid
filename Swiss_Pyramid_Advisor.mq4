//+------------------------------------------------------------------+
//|                                                Swiss_Pyramid.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input int      LIMIT=50;


#define SYMBOLS_MAX 1024
#define DEALS          0
#define BUY_LOTS       1
#define BUY_PRICE      2
#define SELL_LOTS      3
#define SELL_PRICE     4
#define NET_LOTS       5
#define PROFIT         6
 

string ExtName="SwissPyramid Advisor";
string ExtSymbols[SYMBOLS_MAX];
int    ExtSymbolsTotal=0;
double ExtSymbolsSummaries[SYMBOLS_MAX][7];
int    ExtLines=-1;
string ExtCols[8]={"Symbol",
                   "Deals",
                   "Buy lots",
                   "Buy price",
                   "Sell lots",
                   "Sell price",
                   "Net lots",
                   "Profit"};
int    ExtShifts[8]={ 10, 80, 130, 180, 260, 310, 390, 460 };
int    ExtVertShift=14;
double ExtMapBuffer[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
      
//---
   return(INIT_SUCCEEDED);
  }
  
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
  

void removePyramid(string vSymbol)
{
   int total= OrdersTotal();
   int ticket;
   string curr = vSymbol;
   bool result;
   StringToUpper( curr ) ; 
   
   for(int i=total-1;i>=0;i--){
      
   
         
         ticket = OrderSelect(i,SELECT_BY_POS);
         int type=OrderType();
         
         string symbol=OrderSymbol();
         StringToUpper(symbol);
         
         if( StringLen(curr) > 0  && curr  != symbol) 
            continue;
         
         
         RefreshRates();
         
         switch(OrderType()){
            //Close opened long positions
             case OP_BUY       : 
                  result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
                  Print("Closing: ",OrderTicket());
             break;

            //Close opened short positions
            case OP_SELL      :  
                  result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
                  Print("Closing: ", OrderTicket());
            break;
         
            default : 
                  result = OrderDelete(OrderTicket());
                  Print("Deleting: ",  OrderTicket());
            break;
         }

         if( result == false) 
             Print("Last error code: ");
         else
            Sleep(120);
            
  }
}
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

int SymbolsIndex(string SymbolName)
  {
   bool found=false;
   int  i;
//----
   for(i=0; i<ExtSymbolsTotal; i++)
     {
      if(SymbolName==ExtSymbols[i])
        {
         found=true;
         break;
        }
     }
//----
   if(found)
      return(i);
   if(ExtSymbolsTotal>=SYMBOLS_MAX)
      return(-1);
//----
   i=ExtSymbolsTotal;
   ExtSymbolsTotal++;
   ExtSymbols[i]=SymbolName;
   ExtSymbolsSummaries[i][DEALS]=0;
   ExtSymbolsSummaries[i][BUY_LOTS]=0;
   ExtSymbolsSummaries[i][BUY_PRICE]=0;
   ExtSymbolsSummaries[i][SELL_LOTS]=0;
   ExtSymbolsSummaries[i][SELL_PRICE]=0;
   ExtSymbolsSummaries[i][NET_LOTS]=0;
   ExtSymbolsSummaries[i][PROFIT]=0;
//----
   return(i);
  }
  
  
void OnTick()
  {
//---

   double profit;
   int    i,index,type,total=OrdersTotal();
//----

   for(i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      type=OrderType();
      if(type!=OP_BUY && type!=OP_SELL) continue;
      index=SymbolsIndex(OrderSymbol());
      if(index<0 || index>=SYMBOLS_MAX) continue;
      //----
      ExtSymbolsSummaries[index][DEALS]=0;
      profit=0;
      ExtSymbolsSummaries[index][PROFIT]=profit;
      if(type==OP_BUY)
        {
         ExtSymbolsSummaries[index][BUY_LOTS]=0;
         ExtSymbolsSummaries[index][BUY_PRICE]=0;
        }
      else
        {
         ExtSymbolsSummaries[index][SELL_LOTS]=0;
         ExtSymbolsSummaries[index][SELL_PRICE]=0;
        }
     } 
     
     
   for(i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      type=OrderType();
      if(type!=OP_BUY && type!=OP_SELL) continue;
      index=SymbolsIndex(OrderSymbol());
      if(index<0 || index>=SYMBOLS_MAX) continue;
      //----
      ExtSymbolsSummaries[index][DEALS]++;
      profit=OrderProfit()+OrderCommission()+OrderSwap();
      ExtSymbolsSummaries[index][PROFIT]+=profit;
      if(type==OP_BUY)
        {
         ExtSymbolsSummaries[index][BUY_LOTS]+=OrderLots();
         ExtSymbolsSummaries[index][BUY_PRICE]+=OrderOpenPrice()*OrderLots();
        }
      else
        {
         ExtSymbolsSummaries[index][SELL_LOTS]+=OrderLots();
         ExtSymbolsSummaries[index][SELL_PRICE]+=OrderOpenPrice()*OrderLots();
        }
     }
  
   total=OrdersTotal();
   
   for(i=0; i<total; i++)
    {  
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      type=OrderType();
      if(type!=OP_BUY && type!=OP_SELL) continue;
      index=SymbolsIndex(OrderSymbol());
      if(index<0 || index>=SYMBOLS_MAX) continue;
      //----
      if( ExtSymbolsSummaries[index][PROFIT] <  (LIMIT * -1) ){
          removePyramid(ExtSymbols[index]);
     //     MessageBox("zamykamy" , "Ssss"+string(ExtSymbolsSummaries[index][PROFIT])+ExtSymbols[index], 0 );
      }else{
     //   MessageBox("moze byc" , "Ssss"+string(ExtSymbolsSummaries[index][PROFIT]), 0 );
       }
    }
//----
   
   Sleep(2000);
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+

 