/'********************************************************
* 作者：伍耀晖               Author: YaoHui.Wu           *
* 开源日期：2022年5月27日    Open Source Date: 2022-5-27 *
* 国家：中国                 Country: China              *
********************************************************'/
' Compiled by free basic. free basic website: www.freebasic.net

#include "file.bi"

Sub Usage()
    Print "Usage" & Chr(10) & Chr(9) & "Encryption: TrinaryCipher -e/-E Plaintext.file Ciphertext.file Password" & Chr(10) & Chr(9) & "Decryption: TrinaryCipher -d/-D Ciphertext.file Plaintext.file Password"
End Sub

Sub Ternary(ByVal usNumeric As UShort, ubpTrinary As UByte Pointer)
    ubpTrinary[0] = 0

    ubpTrinary[1] = 0

    ubpTrinary[2] = 0

    ubpTrinary[3] = 0

    ubpTrinary[4] = 0

    ubpTrinary[5] =  0

    If usNumeric <> 0 Then
        For i As Byte = 5 To 0 Step -1
            ubpTrinary[i] = usNumeric Mod 3

            usNumeric \= 3
        Next i
    End If
End Sub

/'
 2 2 0
 1 1 1
 0 0 2
'/

Sub TernaryXand(ubaCiphertextOrPlaintext() As UByte, ubpPassword As UByte Pointer)
    For j As UByte = 0 To 5
        If ubaCiphertextOrPlaintext(j) = 0 AndAlso ubpPassword[j] = 0 Then
            ubaCiphertextOrPlaintext(j) = 2
        Elseif ubaCiphertextOrPlaintext(j) = 0 AndAlso ubpPassword[j] = 1 Then
            ubaCiphertextOrPlaintext(j) = 2
        Elseif ubaCiphertextOrPlaintext(j) = 0 AndAlso ubpPassword[j] = 2 Then
            ubaCiphertextOrPlaintext(j) = 0
        Elseif ubaCiphertextOrPlaintext(j) = 1 AndAlso ubpPassword[j] = 0 Then
            ubaCiphertextOrPlaintext(j) = 1
        Elseif ubaCiphertextOrPlaintext(j) = 1 AndAlso ubpPassword[j] = 1 Then
            ubaCiphertextOrPlaintext(j) = 1
        Elseif ubaCiphertextOrPlaintext(j) = 1 AndAlso ubpPassword[j] = 2 Then
            ubaCiphertextOrPlaintext(j) = 1
        Elseif ubaCiphertextOrPlaintext(j) = 2 AndAlso ubpPassword[j] = 0 Then
            ubaCiphertextOrPlaintext(j) = 0
        Elseif ubaCiphertextOrPlaintext(j) = 2 AndAlso ubpPassword[j] = 1 Then
            ubaCiphertextOrPlaintext(j) = 0
        Elseif ubaCiphertextOrPlaintext(j) = 2 AndAlso ubpPassword[j] = 2 Then
            ubaCiphertextOrPlaintext(j) = 2
        End If
    Next j
End Sub

Sub Main()
    Dim As UByte ubCLAA = 1, k = 0, ubPasswordLength, ubaPassword(), ubaPlaintextOrCiphertext(5)

    Dim As ULongInt ulFileSize

    Dim As String strPassword

    Dim As UByte Pointer ubpPlaintext

    Dim As UShort Pointer uspCiphertext

    Do
        Dim As String strCLA = Command(ubCLAA)

        If Len(strCLA) = 0 Then
            Exit Do
        End If

        ubCLAA += 1
    Loop

    If ubCLAA <> 5 Then : Usage()

    Elseif Command(1) = "-e" OrElse Command(1) = "-E" Then
        ulFileSize = FileLen(Command(2))

        If ulFileSize = 0 Then
            Print "There is no data in file [" & Command(2) & "], 0 byte."

            End -1
        End If

        uspCiphertext = New UShort[ulFileSize]

        ubpPlaintext = New UByte[ulFileSize]

        Open Command(2) For Binary Access Read As #3

        Get #3, , *ubpPlaintext, ulFileSize

        Close #3

        strPassword = Command(4)

        ubPasswordLength = Len(Command(4))

        ReDim ubaPassword(ubPasswordLength - 1, 5)

        For i As UByte = 0 To ubPasswordLength - 1
            Ternary(strPassword[i], @ubaPassword(i, 0))
        Next i

        For j As ULongInt = 0 To ulFileSize - 1
            Ternary(ubpPlaintext[j], @ubaPlaintextOrCiphertext(0))

            TernaryXand(ubaPlaintextOrCiphertext(), @ubaPassword(k, 0))

            uspCiphertext[j] = 243 * ubaPlaintextOrCiphertext(0) + 81 * ubaPlaintextOrCiphertext(1) + 27 * ubaPlaintextOrCiphertext(2) + 9 * ubaPlaintextOrCiphertext(3) + 3 * ubaPlaintextOrCiphertext(4) + ubaPlaintextOrCiphertext(5)

            k = (k + 1) Mod ubPasswordLength
        Next j

        Delete ubpPlaintext

        Open Command(3) For Binary Access Write As #4

        Put #4, , *uspCiphertext, ulFileSize

        Close #4

        Delete uspCiphertext

    Elseif Command(1) = "-d" OrElse Command(1) = "-D" Then
        ulFileSize = FileLen(Command(2)) \ 2

        If ulFileSize = 0 Then
            Print "There is no data in file [" & Command(2) & "], 0 byte."

            End -1
        End If

        ubpPlaintext = New UByte[ulFileSize]

        uspCiphertext = New UShort[ulFileSize]

        Open Command(2) For Binary Access Read As #3

        Get #3, , *uspCiphertext, ulFileSize

        Close #3

        strPassword = Command(4)

        ubPasswordLength = Len(Command(4))

        ReDim ubaPassword(ubPasswordLength - 1, 5)

        For i As UByte = 0 To ubPasswordLength - 1
            Ternary(strPassword[i], @ubaPassword(i, 0))
        Next i

        For j As ULongInt = 0 To ulFileSize - 1
            Ternary(uspCiphertext[j], @ubaPlaintextOrCiphertext(0))

            TernaryXand(ubaPlaintextOrCiphertext(), @ubaPassword(k, 0))

            ubpPlaintext[j] = 243 * ubaPlaintextOrCiphertext(0) + 81 * ubaPlaintextOrCiphertext(1) + 27 * ubaPlaintextOrCiphertext(2) + 9 * ubaPlaintextOrCiphertext(3) + 3 * ubaPlaintextOrCiphertext(4) + ubaPlaintextOrCiphertext(5)

            k = (k + 1) Mod ubPasswordLength

        Next j

        Delete uspCiphertext

        Open Command(3) For Binary Access Write As #4

        Put #4, , *ubpPlaintext, ulFileSize

        Close #4

        Delete ubpPlaintext

    Else
        Usage()
    End If
End Sub

Main()