import yfinance as yf
import pandas as pd


apple= yf.Ticker("aapl")

# show actions (dividends, splits)
apple.actions

# show dividends
apple.dividends

# show splits
apple.splits

# S_0 = 149.80 on 29th of October at close

# get option chain calls data for specific expiration date
aapl = yf.Ticker("aapl")
opt = aapl.option_chain(date='2022-02-18')

df = opt.puts
df.to_csv('data5.csv',index=False)

#print(opt.calls)
#opt.puts