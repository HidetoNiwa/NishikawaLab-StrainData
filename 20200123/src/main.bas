'���\�z�\�z���@
'�Q�l:http://skill-note.net/post-944/

dim x as integer
dim y as integer
dim dataNum as integer

Sub choicePipot()
    dataNum=WorksheetFunction.Count(Range("A:A"))

    For i=1 To dataNum/2
        Cells(i+1,3).Value=(i-1)/100
        Cells(i+1,4).Value=Cells(i*2,1).Value
    Next
    
End Sub

Sub main()
    Range("F:BE").Clear
    Call setXY(3,1)

    Cells(y,x).Value="����"
    x=add(x,1)
    Cells(y,x).Value="���萔"

    dataNum=WorksheetFunction.Count(Range("D:D"))

    Call setXY(6,1)
    Cells(y,x).Value="�f�[�^��"
    y=add(y,1)
    Cells(y,x).Value=dataNum

    y=add(y,1)
    Cells(y,x).Value="�L�ӊm��"
    y=add(y,1)
    rangePercent=Cells(y,x).Value

    x=add(x,2)
    y=1
    Cells(y,x).Value="��������"

    For i=0 To 99
        y=add(y,1)
        Cells(y,x).Value=i/100        
    Next

    count=1
    dim loopNum as integer
    loopNum=1
    x=add(x,1)
    y=1

    ' �f�[�^�����ԒP�ʂɈڐA
    For i=2 To dataNum

        if count=1 Then
            Cells(y,x).Value=loopNum 'loop���̕\��
            count=count+1
        End If

        Cells(count,x).Value=Cells(i,4).Value
        count=count+1
        
        If count=102 Then
            count=1
            loopNum=add(loopNum,1)
            y=1
            x=add(x,1)
        End If
    Next

    '���v�l�v�Z
    x=loopNum+7+4
    y=1
    Cells(y,x).Value="���萔���ϒl"
    x=add(x,1)
    Cells(y,x).Value="���萔�W���덷"
    x=add(x,1)
    Cells(y,x).Value="���萔���U"

    dim clearCells as boolean

    For i=1 To 100
        restart :
        clearCells=False
        x=loopNum+7+4
        Cells(i+1,x).Value=WorksheetFunction.Average(Range(Cells(i+1, 7), Cells(i+1, loopNum+6)))
        x=add(x,1)
        Cells(i+1,x).Value=WorksheetFunction.StDev(Range(Cells(i+1, 7), Cells(i+1, loopNum+6))) / Sqr(WorksheetFunction.Count(Range(Cells(i+1, 7), Cells(i+1, loopNum+6))))
        x=add(x,1)
        Cells(i+1,x).Value=WorksheetFunction.Var(Range(Cells(i+1, 7), Cells(i+1, loopNum+6)))

        dataSectionNum=WorksheetFunction.Count(Range(Cells(i+1, 7), Cells(i+1, loopNum+6)))

        For j=0 To dataSectionNum-1

            if Cells(i+1, j+7).Value="" Then
            Else 
                t = Abs(Cells(i+1, j+7).Value - Cells(i + 1, loopNum+7).Value) / Sqr(Cells(i + 1, loopNum+9).Value)
                    ' ����ŗ������z�̊m�����o��
                p = WorksheetFunction.T_Dist_2T(t,dataSectionNum - 2)
                    if p<rangePercent Then
                        Cells(i+1,j+7).Clear
                        clearCells=True
                    End if
            End if
        Next

        if clearCells=True Then
            GoTO restart
        End if

    Next

    Application.ScreenUpdating = True
    Application.ScreenUpdating = False
    

End Sub

Sub setXY(x_tmp as integer,y_tmp as integer)
    x=x_tmp
    y=y_tmp
End Sub

Function add(tmp as integer,num as integer) As integer
    add = tmp +num
End Function