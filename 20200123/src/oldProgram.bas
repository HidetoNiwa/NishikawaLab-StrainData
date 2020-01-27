Sub lowPass()

    Range("J:R").Clear
    
    dataNum = WorksheetFunction.Count(Range("C:C"))
    rangePercent = 0.01
    freq = 10 '周波数（Hz）
    timeDiff = 1 / freq '周期
    
    Range("F1").Value = "周波数（Hz）"
    Range("F2").Value = freq
    Range("F4").Value = dataNum
    
    'データのコピーを行う
    Range("H1").Value = "時刻(s)"
    Range("I1").Value = "時定数(us)"
    
    Application.ScreenUpdating = False
    
    For y = 1 To dataNum
        Cells(y + 1, 8).Value = (Cells(y + 1, 1).Value - Cells(2, 1).Value) / 1000
    Next
    
    Application.ScreenUpdating = True
    Application.ScreenUpdating = False
    
    For y = 1 To dataNum
        Cells(y + 1, 9).Value = Cells(y + 1, 3).Value
    Next
    
    Application.ScreenUpdating = True
    Application.ScreenUpdating = False
    
    Range("J1").Value = "有意確率"
    
    Range("L1").Value = "区間下限値"
    Range("M1").Value = "区間上限値"
    Range("N1").Value = "平均時刻(s)"
    Range("O1").Value = "標準誤差"
    Range("P1").Value = "平均時定数(us)"
    Range("Q1").Value = "標準誤差"
    Range("R1").Value = "分散"
    
    endTime = timeDiff
    secnum = 1
    startSecNum = 1
    
    For y = 1 To dataNum
        If Cells(y + 1, 8).Value > endTime Then
            Cells(secnum + 1, 12).Value = endTime - timeDiff
            Cells(secnum + 1, 13).Value = endTime
            Cells(secnum + 1, 14).Value = WorksheetFunction.Average(Range(Cells(startSecNum + 1, 8), Cells(y, 8)))
            Cells(secnum + 1, 16).Value = WorksheetFunction.Average(Range(Cells(startSecNum + 1, 9), Cells(y, 9)))
            Cells(secnum + 1, 15).Value = WorksheetFunction.StDev(Range(Cells(startSecNum + 1, 8), Cells(y, 8))) / Sqr(y - startSecNum)
            Cells(secnum + 1, 17).Value = WorksheetFunction.StDev(Range(Cells(startSecNum + 1, 9), Cells(y, 9))) / Sqr(y - startSecNum)
            Cells(secnum + 1, 18).Value = WorksheetFunction.Var(Range(Cells(startSecNum + 1, 9), Cells(y, 9)))
            For Section = startSecNum + 1 To y
                ' t値の計算
                Cells(Section, 10).Value = Abs(Cells(Section, 9).Value - Cells(secnum + 1, 16).Value) / Sqr(Cells(secnum + 1, 18).Value)
                ' これで両側分布の確率が出る
                Cells(Section, 10).Value = WorksheetFunction.T_Dist_2T(Cells(Section, 10).Value, y - startSecNum - 2)
            Next
            
            startTime = endTime
            endTime = endTime + timeDiff
            secnum = secnum + 1
            startSecNum = y
        End If
    Next
    
    Application.ScreenUpdating = True
    Application.ScreenUpdating = False
    
    y_1 = 2
    
    For y = 1 To dataNum - 1
        If rangePercent < Cells(y + 1, 10).Value Then
            Cells(y_1, 8).Value = Cells(y + 1, 8).Value
            Cells(y_1, 9).Value = Cells(y + 1, 9).Value
            y_1 = y_1 + 1
        End If
    Next
    
    Application.ScreenUpdating = True
    Application.ScreenUpdating = False
    
    For y = y_1 To dataNum + 1
        Cells(y, 8).Clear
        Cells(y, 9).Clear
        Cells(y, 10).Clear
    Next
    
    Application.ScreenUpdating = True
    Application.ScreenUpdating = False
    
    dataNum = y_1
    
    For y = 1 To dataNum
        If Cells(y + 1, 8).Value > endTime Then
            Cells(secnum + 1, 12).Value = endTime - timeDiff
            Cells(secnum + 1, 13).Value = endTime
            Cells(secnum + 1, 14).Value = WorksheetFunction.Average(Range(Cells(startSecNum + 1, 8), Cells(y, 8)))
            Cells(secnum + 1, 15).Value = WorksheetFunction.StDev(Range(Cells(startSecNum + 1, 8), Cells(y, 8))) / Sqr(y - startSecNum)
            Cells(secnum + 1, 16).Value = WorksheetFunction.Average(Range(Cells(startSecNum + 1, 9), Cells(y, 9)))
            Cells(secnum + 1, 17).Value = WorksheetFunction.StDev(Range(Cells(startSecNum + 1, 9), Cells(y, 9))) / Sqr(y - startSecNum)
            Cells(secnum + 1, 18).Value = WorksheetFunction.Var(Range(Cells(startSecNum + 1, 9), Cells(y, 9)))
            
            For Section = startSecNum + 1 To y
                ' t値の計算
                Cells(Section, 10).Value = Abs(Cells(Section, 9).Value - Cells(secnum + 1, 16).Value) / Sqr(Cells(secnum + 1, 18).Value)
                ' これで両側分布の確率が出る
                Cells(Section, 10).Value = WorksheetFunction.T_Dist_2T(Cells(Section, 10).Value, y - startSecNum - 2)
            Next
            
            startTime = endTime
            endTime = endTime + timeDiff
            secnum = secnum + 1
            startSecNum = y
        End If
    Next
    
    Application.ScreenUpdating = True

End Sub
