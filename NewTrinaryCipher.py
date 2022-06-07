#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#*******************************************************
# 作者：伍耀晖             Author: YaoHui.Wu           *
# 开源日期：2022年6月7日   Open Source Date: 2022-6-7  *
# 国家：中国               Country: China              *
#*******************************************************

import sys

def Usage():
    print("Usage\n\tEncryption: python TrinaryCipher.py -e/-E Plaintext.file Ciphertext.file Password\n\tDecryption: python TrinaryCipher.py -d/-D Ciphertext.file Plaintext.file Password")

def Ternary(iNumeric):
    i, lTrinary = 0, [0, 0, 0, 0, 0, 0]

    if iNumeric and i < 6:
        while iNumeric:
            iNumeric, iRemainder = divmod(iNumeric, 3)

            lTrinary[i] = iRemainder

            i += 1

    return lTrinary

# 2 ? 0    2 1 0
# 1 1 1 or ? 1 ?
# 0 ? 2    0 1 2

def TernaryXand(lTrinary, lPassword):
    for l in range(6):
       if lTrinary[l] == lPassword[l] == 0: lTrinary[l] = "2"

       elif lTrinary[l] == 0 and lPassword[l] == 1: lTrinary[l] = "0"

       elif lTrinary[l] == 0 and lPassword[l] == 2: lTrinary[l] = "0"

       elif lTrinary[l] == 1 and lPassword[l] == 0: lTrinary[l] = "1"

       elif lTrinary[l] == lPassword[l] == 1: lTrinary[l] = "1"

       elif lTrinary[l] == 1 and lPassword[l] == 2: lTrinary[l] = "1"

       elif lTrinary[l] == 2 and lPassword[l] == 0: lTrinary[l] = "0"

       elif lTrinary[l] == 2 and lPassword[l] == 1: lTrinary[l] = "2"

       elif lTrinary[l] == lPassword[l] == 2: lTrinary[l] = "2"

    return int("".join(lTrinary[::-1]), 3)

if __name__ == "__main__":
    if len(sys.argv) < 5: Usage()

    elif sys.argv[1] == "-e" or sys.argv[1] == "-E":
        strPassword, lPassword, lCiphertext = sys.argv[4], [], []

        iPasswordLength, i = len(strPassword), 0

        for j in range(iPasswordLength):
            lPassword.append(Ternary(ord(strPassword[j])))

        with open(sys.argv[2], "br") as fdPlaintext:
            bPlaintext = fdPlaintext.read()

            iFileSize = fdPlaintext.tell()

        for k in range(iFileSize):
            lCiphertext.append(TernaryXand(Ternary(bPlaintext[k]), lPassword[i]))

            i = (i + 1) % iPasswordLength

        with open(sys.argv[3], "bw") as fdCiphertext:
            for iCiphertext in lCiphertext:
                fdCiphertext.write(iCiphertext.to_bytes(2, "little"))

    elif sys.argv[1] == "-d" or sys.argv[1] == "-D":
        strPassword, lPassword, lPlaintext = sys.argv[4], [], []

        iPasswordLength, i = len(strPassword), 0

        for j in range(iPasswordLength):
            lPassword.append(Ternary(ord(strPassword[j])))

        with open(sys.argv[2], "br") as fdCiphertext:
            bCiphertext = fdCiphertext.read(2)

            while bCiphertext:
                lPlaintext.append(TernaryXand(Ternary(int.from_bytes(bCiphertext, "little")), lPassword[i]))

                i = (i + 1) % iPasswordLength

                bCiphertext = fdCiphertext.read(2)

        with open(sys.argv[3], "bw") as fdPlaintext:
            for iPlaintext in lPlaintext:
                fdPlaintext.write(iPlaintext.to_bytes(1, "little"))

    else: Usage()
