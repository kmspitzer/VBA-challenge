Attribute VB_Name = "Module1"

'
' Kate Spitzer
' UCSD Data Science and Visualization Bootcamp
' Homework #2, VBA
' 2 Dec 2020
'

'
' This subroutine loops through all worksheets in a workbook of stock data to calculate the yearly change,
' percent change and total volume traded for each ticker symbol found.  One row of output is generated per
' ticker symbol.  Yearly change cell is highlighted in red if there is a loss for the year, or green if
' even or there is a gain.  Percent change is formatted as a percent.
'
' Greatest volume traded, greatest percent increase, and greates percent decrease are tracked and output
' for each worksheet
'
' stockAnalyzer() assumes that the worksheet data is sorted by ticker symbol, and date
'




Sub stockAnalyzer()

    'declare variables
    Dim row As Long
    Dim ticker_cnt As Long
    Dim ticker_symbol As String
    Dim save_ticker As String
    Dim volume_ticker As String
    Dim increase_ticker As String
    Dim decrease_ticker As String
    Dim open_price As Double
    Dim close_price As Double
    Dim yearly_change As Double
    Dim percent_change As Double
    Dim total_volume As LongLong
    Dim greatest_volume As LongLong
    Dim greatest_increase As Double
    Dim greatest_decrease As Double

    Dim first_pass As Boolean
    Dim new_symbol As Boolean
    
    Dim ws As Worksheet
    
    
    
    
    
    ' loop through all worksheets in the workbook
    For Each ws In Worksheets
    
        ' make the current worksheet active
        ws.Activate

    
        'initialize counters and flags
        row = 2
        ticker_cnt = 2
        first_pass = True
        new_symbol = True
        total_volume = 0
        
        ' initialize superlatives
        greatest_volume = 0
        greatest_increase = 0
        greatest_decrease = 0
    
    
        'insert titles for output columns
        Range("I1").Value = "Ticker"
        Range("J1").Value = "Yearly Change"
        Range("K1").Value = "Percent Change"
        Range("L1").Value = "Total Stock Volume"
        Range("P1").Value = "Ticker"
        Range("Q1").Value = "Value"
        Range("O2").Value = "Greatest % Increase"
        Range("O3").Value = "Greatest % Decrease"
        Range("O4").Value = "Greatest Total Volume"


        'read first entry
        ticker_symbol = Cells(row, 1).Value
    
    
        'loop until we read an empty row
        Do While ticker_symbol <> ""


            If new_symbol = True Then
        
                ' we have encountered a new symbol
                If first_pass = False Then
                    ' this is not our first time through
                    If open_price <> 0 Then
                        ' we have valid data, so begin calculations and
                        ' write row to output area.
                        yearly_change = close_price - open_price
                        percent_change = yearly_change / open_price
            
                        Cells(ticker_cnt, 9).Value = save_ticker
                        Cells(ticker_cnt, 10).Value = yearly_change
                        Cells(ticker_cnt, 11).Value = FormatPercent(percent_change)
                        Cells(ticker_cnt, 12).Value = total_volume
                
                        ' check to see if this is the greatest volume,
                        ' greatest percent increase or decrease
                        If total_volume > greatest_volume Then
                            greatest_volume = total_volume
                            volume_ticker = save_ticker
                        End If
                
                        If percent_change < 0 Then
                            If percent_change < greatest_decrease Then
                                greatest_decrease = percent_change
                                decrease_ticker = save_ticker
                            End If
                        ElseIf percent_change > greatest_increase Then
                            greatest_increase = percent_change
                            increase_ticker = save_ticker
                        End If
                        
                        
                        ' format the yearly change cell red for a negative change
                        ' and green for 0 or positive change
                        If yearly_change < 0 Then
                            Cells(ticker_cnt, 10).Interior.ColorIndex = 3
                        Else
                            Cells(ticker_cnt, 10).Interior.ColorIndex = 4
                        End If
            
                        ' increment the output line count
                        ticker_cnt = ticker_cnt + 1
                    End If
                Else
                    ' this was our first time through.
                    ' we have no data accumulated - just set flag to false
                    first_pass = False
                End If


                ' first time through with this new symbol, grab the
                ' opening price for the year, and save the ticker symbol
                ' initialize total volume to zero
                ' set new_symbol flag to false
                open_price = Cells(row, 3).Value
                save_ticker = ticker_symbol
                total_volume = 0
                new_symbol = False
        
            End If
    
            ' accumulate volume, grab closing price and increment row counter
            total_volume = total_volume + Cells(row, 7).Value
            close_price = Cells(row, 6).Value
            row = row + 1
    
            ' read next ticker symbol, if it's a new one turn on the
            ' new_symbol flag
            ticker_symbol = Cells(row, 1).Value
            If ticker_symbol <> save_ticker Then
                new_symbol = True
            End If
        
        Loop
        
        ' display superlatives for the current worksheet
        Range("P2").Value = increase_ticker
        Range("Q2").Value = FormatPercent(greatest_increase)
        Range("P3").Value = decrease_ticker
        Range("Q3").Value = FormatPercent(greatest_decrease)
        Range("P4").Value = volume_ticker
        Range("Q4").Value = greatest_volume

        
    Next ws

End Sub



