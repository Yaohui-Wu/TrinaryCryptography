(*********************************************************
* 作者：伍耀晖               Author: YaoHui.Wu           *
* 开源日期：2022年5月27日    Open Source Date: 2022-5-27 *
* 国家：中国                 Country: China              *
*********************************************************)
(* Compiled by free pascal. free pascal website: www.freepascal.org *)

Program TrinaryCipher;

Type
   TrinaryArray = Array[0..5] Of Byte;

Procedure Usage();
Begin
    WriteLn('Usage'#10#9'Encryption: TrinaryCipher -e/-E Plaintext.file Ciphertext.file Password'#10#9'Decryption: TrinaryCipher -d/-D Ciphertext.file Plaintext.file Password');
End;

Procedure Ternary(wNumeric : Word;
                  Var baTrinary : TrinaryArray);
Var
    i : Byte;

Begin
    baTrinary[0] := 0;

    baTrinary[1] := 0;

    baTrinary[2] := 0;

    baTrinary[3] := 0;

    baTrinary[4] := 0;

    baTrinary[5] := 0;

    If wNumeric <> 0 Then
    Begin
        For i := 5 DownTo 0 Do
        Begin
            baTrinary[i] := wNumeric Mod 3;

            wNumeric := wNumeric Div 3;
        End;
    End;
End;

Var
    fdPlaintextOrCiphertext : File;

    i, ulFileSize : QWord;

    bpPlaintext : PByte;

    wpCiphertext : PWord;

    j, k, bPasswordLength : Byte;

    baPassword, baPlaintextOrCiphertext : TrinaryArray;

Begin
    If(ParamCount < 4) Then
    Begin
        Usage();
    End
    Else If (ParamStr(1) = '-e') Or (ParamStr(1) = '-E') Then
    Begin
        Assign(fdPlaintextOrCiphertext, ParamStr(2));

        Reset(fdPlaintextOrCiphertext, 1);

        ulFileSize := FileSize(fdPlaintextOrCiphertext);

        If ulFileSize = 0 Then
        Begin
            WriteLn('There is no data in file [', ParamStr(2), '], 0 byte.');

            Halt(-1);
        End;

        bpPlaintext := GetMem(ulFileSize);

        BlockRead(fdPlaintextOrCiphertext, bpPlaintext^, ulFileSize);

        Close(fdPlaintextOrCiphertext);

        wpCiphertext := GetMem(2 * ulFileSize);

        bPasswordLength := Length(ParamStr(4));

        k := 0;

        For i := 0 To ulFileSize - 1 Do
        Begin
            Ternary(bpPlaintext[i], baPlaintextOrCiphertext);

            Ternary(Ord(ParamStr(4)[k]), baPassword);

            For j := 0 To 5 Do
                If (baPlaintextOrCiphertext[j] = 0) And (baPassword[j] = 0) Then baPlaintextOrCiphertext[j] := 0

                Else If (baPlaintextOrCiphertext[j] = 0) And (baPassword[j] = 1) Then baPlaintextOrCiphertext[j] := 0

                Else If (baPlaintextOrCiphertext[j] = 0) And (baPassword[j] = 2) Then baPlaintextOrCiphertext[j] := 2

                Else If (baPlaintextOrCiphertext[j] = 1) And (baPassword[j] = 0) Then baPlaintextOrCiphertext[j] := 1

                Else If (baPlaintextOrCiphertext[j] = 1) And (baPassword[j] = 1) Then baPlaintextOrCiphertext[j] := 1

                Else If (baPlaintextOrCiphertext[j] = 1) And (baPassword[j] = 2) Then baPlaintextOrCiphertext[j] := 1

                Else If (baPlaintextOrCiphertext[j] = 2) And (baPassword[j] = 0) Then baPlaintextOrCiphertext[j] := 2

                Else If (baPlaintextOrCiphertext[j] = 2) And (baPassword[j] = 1) Then baPlaintextOrCiphertext[j] := 2

                Else If (baPlaintextOrCiphertext[j] = 2) And (baPassword[j] = 2) Then baPlaintextOrCiphertext[j] := 0;

            wpCiphertext[i] := 243 * baPlaintextOrCiphertext[0] + 81 * baPlaintextOrCiphertext[1] + 27 * baPlaintextOrCiphertext[2] + 9 * baPlaintextOrCiphertext[3] + 3 * baPlaintextOrCiphertext[4] + baPlaintextOrCiphertext[5];

            k := (k + 1) Mod bPasswordLength;
        End;

        Assign(fdPlaintextOrCiphertext, Paramstr(3));

        Rewrite(fdPlaintextOrCiphertext, 1);

        BlockWrite(fdPlaintextOrCiphertext, wpCiphertext^, 2 * ulFileSize);

        Close(fdPlaintextOrCiphertext);

        FreeMem(wpCiphertext);

        FreeMem(bpPlaintext);
    End
    Else If (paramstr(1) = '-d') Or (paramstr(1) = '-D') Then
    Begin
        Assign(fdPlaintextOrCiphertext, ParamStr(2));

        Reset(fdPlaintextOrCiphertext, 1);

        ulFileSize := FileSize(fdPlaintextOrCiphertext);

        If ulFileSize = 0 Then
        Begin
            WriteLn('There is no data in file [', ParamStr(2), '], 0 byte.');

            Halt(-1);
        End;

        wpCiphertext := GetMem(ulFileSize);

        BlockRead(fdPlaintextOrCiphertext, wpCiphertext^, ulFileSize);

        Close(fdPlaintextOrCiphertext);

        ulFileSize := ulFileSize Div 2;

        bpPlaintext := GetMem(ulFileSize);

        bPasswordLength := Length(ParamStr(4));

        k := 0;

        For i := 0 To ulFileSize - 1 Do
        Begin
            Ternary(wpCiphertext[i], baPlaintextOrCiphertext);

            Ternary(Ord(ParamStr(4)[k]), baPassword);

            For j := 0 To 5 Do
                If (baPlaintextOrCiphertext[j] = 0) And (baPassword[j] = 0) Then baPlaintextOrCiphertext[j] := 0

                Else If (baPlaintextOrCiphertext[j] = 0) And (baPassword[j] = 1) Then baPlaintextOrCiphertext[j] := 0

                Else If (baPlaintextOrCiphertext[j] = 0) And (baPassword[j] = 2) Then baPlaintextOrCiphertext[j] := 2

                Else If (baPlaintextOrCiphertext[j] = 1) And (baPassword[j] = 0) Then baPlaintextOrCiphertext[j] := 1

                Else If (baPlaintextOrCiphertext[j] = 1) And (baPassword[j] = 1) Then baPlaintextOrCiphertext[j] := 1

                Else If (baPlaintextOrCiphertext[j] = 1) And (baPassword[j] = 2) Then baPlaintextOrCiphertext[j] := 1

                Else If (baPlaintextOrCiphertext[j] = 2) And (baPassword[j] = 0) Then baPlaintextOrCiphertext[j] := 2

                Else If (baPlaintextOrCiphertext[j] = 2) And (baPassword[j] = 1) Then baPlaintextOrCiphertext[j] := 2

                Else If (baPlaintextOrCiphertext[j] = 2) And (baPassword[j] = 2) Then baPlaintextOrCiphertext[j] := 0;

            bpPlaintext[i] := 243 * baPlaintextOrCiphertext[0] + 81 * baPlaintextOrCiphertext[1] + 27 * baPlaintextOrCiphertext[2] + 9 * baPlaintextOrCiphertext[3] + 3 * baPlaintextOrCiphertext[4] + baPlaintextOrCiphertext[5];

            k := (k + 1) Mod bPasswordLength;
        End;

        Assign(fdPlaintextOrCiphertext, Paramstr(3));

        Rewrite(fdPlaintextOrCiphertext, 1);

        BlockWrite(fdPlaintextOrCiphertext, bpPlaintext^, ulFileSize);

        Close(fdPlaintextOrCiphertext);

        FreeMem(bpPlaintext);

        FreeMem(wpCiphertext);
    End
    Else
    Begin
        Usage();
    End
End.