(*******************************************************
* 作者：伍耀晖	           Author: YaoHui.Wu           *
* 开源日期：2022年5月27日  Open Source Date: 2022-5-27 *
* 国家：中国               Country: China              *
*******************************************************)
(* Compiled by free pascal. free pascal website: www.freepascal.org *)

Program TrinaryCipher;

Type
   TrinaryArray = Array[0..5] Of Byte;

Procedure Usage();
Begin
    writeln('Usage'#10#9'Encryption: TrinaryCipher -e/-E Plaintext.file Ciphertext.file Password'#10#9'Decryption: TrinaryCipher -d/-D Ciphertext.file Plaintext.file Password');
End;

Procedure Ternary(wNumeric : Word;
                  Var baTrinary : TrinaryArray);
Var
    i : Byte;

Begin
    If wNumeric < 1 Then
    Begin
        baTrinary[0] := 0;

        baTrinary[1] := 0;

        baTrinary[2] := 0;

        baTrinary[3] := 0;

        baTrinary[4] := 0;

        baTrinary[5] :=  0;
    End
    Else
    Begin
        For i := 5 DownTo 0 Do
        Begin
            baTrinary[i] := wNumeric Mod 3;

            wNumeric := wNumeric Div 3;
        End;
    End;
End;

(*
 0 ? 2    0 1 2
 1 1 1 or ? 1 ?
 2 ? 0    2 1 0
*)

Procedure TernaryXor(Var baCiphertextOrPlaintext : TrinaryArray;
                     Var baPassword : TrinaryArray);
Var
    j : Byte;

Begin
    For j := 0 To 5 Do
    Begin
        If (baCiphertextOrPlaintext[j] = 0) And (baPassword[j] = 0) Then
        Begin
            baCiphertextOrPlaintext[j] := 0;
        End
        Else If (baCiphertextOrPlaintext[j] = 0) And (baPassword[j] = 1) Then
        Begin
            baCiphertextOrPlaintext[j] := 2;
        End
        Else If (baCiphertextOrPlaintext[j] = 0) And (baPassword[j] = 2) Then
        Begin
            baCiphertextOrPlaintext[j] := 2;
        End
        Else If (baCiphertextOrPlaintext[j] = 1) And (baPassword[j] = 0) Then
        Begin
            baCiphertextOrPlaintext[j] := 1;
        End
        Else If (baCiphertextOrPlaintext[j] = 1) And (baPassword[j] = 1) Then
        Begin
            baCiphertextOrPlaintext[j] := 1;
        End
        Else If (baCiphertextOrPlaintext[j] = 1) And (baPassword[j] = 2) Then
        Begin
            baCiphertextOrPlaintext[j] := 1;
        End
        Else If (baCiphertextOrPlaintext[j] = 2) And (baPassword[j] = 0) Then
        Begin
            baCiphertextOrPlaintext[j] := 2;
        End
        Else If (baCiphertextOrPlaintext[j] = 2) And (baPassword[j] = 1) Then
        Begin
            baCiphertextOrPlaintext[j] := 0;
        End
        Else If (baCiphertextOrPlaintext[j] = 2) And (baPassword[j] = 2) Then
        Begin
            baCiphertextOrPlaintext[j] := 0;
        End
    End;
End;

Var
    bPasswordLength : Byte;

    i, j, k, iFileSize : LongWord;

    baPassword : Array Of TrinaryArray;

    baCiphertext : TrinaryArray;

    fdPlaintextOrCiphertext : File;

    bpPlaintext : PByte;

    wpCiphertext : PWord;

Begin
    If(ParamCount < 4) Then
    Begin
        Usage();
    End
    Else If (ParamStr(1) = '-e') Or (ParamStr(1) = '-E') Then
    Begin
        bPasswordLength := Length(ParamStr(4));

        SetLength(baPassword, bPasswordLength);

        For i := 1 To bPasswordLength Do
        Begin
            Ternary(Ord(ParamStr(4)[i]), baPassword[i - 1]);
        End;

        Assign(fdPlaintextOrCiphertext, ParamStr(2));

        Reset(fdPlaintextOrCiphertext, 1);

        iFileSize := FileSize(fdPlaintextOrCiphertext);

        bpPlaintext := GetMem(iFileSize);

        BlockRead(fdPlaintextOrCiphertext, bpPlaintext^, iFileSize);

        Close(fdPlaintextOrCiphertext);

        wpCiphertext := GetMem(2 * iFileSize);

        k := 0;

        For j := 0 To iFileSize - 1 Do
        Begin
            Ternary(bpPlaintext[j], baCiphertext);

            TernaryXor(baCiphertext, baPassword[k]);

            wpCiphertext[j] := 243 * baCiphertext[0] + 81 * baCiphertext[1] + 27 * baCiphertext[2] + 9 * baCiphertext[3] + 3 * baCiphertext[4] + baCiphertext[5];

            k := (k + 1) Mod bPasswordLength;
        End;

        Assign(fdPlaintextOrCiphertext, Paramstr(3));

        Rewrite(fdPlaintextOrCiphertext, 1);

        BlockWrite(fdPlaintextOrCiphertext, wpCiphertext^, 2 * iFileSize);

        Close(fdPlaintextOrCiphertext);

        FreeMem(wpCiphertext);

        FreeMem(bpPlaintext);
    End
    Else If (paramstr(1) = '-d') Or (paramstr(1) = '-D') Then
    Begin
        bPasswordLength := Length(ParamStr(4));

        SetLength(baPassword, bPasswordLength);

        For i := 1 To bPasswordLength Do
        Begin
            Ternary(Ord(ParamStr(4)[i]), baPassword[i - 1]);
        End;

        Assign(fdPlaintextOrCiphertext, ParamStr(2));

        Reset(fdPlaintextOrCiphertext, 1);

        iFileSize := FileSize(fdPlaintextOrCiphertext);

        wpCiphertext := GetMem(iFileSize);

        BlockRead(fdPlaintextOrCiphertext, wpCiphertext^, iFileSize);

        Close(fdPlaintextOrCiphertext);

        iFileSize := iFileSize Div 2;

        bpPlaintext := GetMem(iFileSize);

        k := 0;

        For j := 0 To iFileSize - 1 Do
        Begin
            Ternary(wpCiphertext[j], baCiphertext);

            TernaryXor(baCiphertext, baPassword[k]);

            bpPlaintext[j] := 243 * baCiphertext[0] + 81 * baCiphertext[1] + 27 * baCiphertext[2] + 9 * baCiphertext[3] + 3 * baCiphertext[4] + baCiphertext[5];

            k := (k + 1) Mod bPasswordLength;
        End;

        Assign(fdPlaintextOrCiphertext, Paramstr(3));

        Rewrite(fdPlaintextOrCiphertext, 1);

        BlockWrite(fdPlaintextOrCiphertext, bpPlaintext^, iFileSize);

        Close(fdPlaintextOrCiphertext);

        FreeMem(bpPlaintext);

        FreeMem(wpCiphertext);
    End
    Else
    Begin
        Usage();
    End
End.