#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 作者：伍耀晖	Author: YaoHui.Wu
# 开源日期：2022年5月27日	Open Source Date: 2022-5-27
# 国家：中国	Country: China

import sys

def Ternary(iNumeric, iRadix):
    i, lTrinary = 0, [0, 0, 0, 0, 0, 0]

    if iNumeric and i < 6:
        while iNumeric:
            iNumeric, iRemainder = divmod(iNumeric, iRadix)

            lTrinary[i] = iRemainder

            i += 1

    return lTrinary

if __name__ == "__main__":
    if len(sys.argv) < 4: print("Usage\n\tEncryption: TrinaryCipher -e/-E Plaintext.file Ciphertext.file Password\n\tDecrytion: TrinaryCipher -d/-D Ciphertext.file Plaintext.file Password")

    elif sys.argv[1] == "-e" or sys.argv[1] == "-E":
        strPassword, lData = sys.argv[4], []

        iLength, k = len(strPassword), 0

        with open(sys.argv[2], "br") as fdPlaintext:
            bData = fdPlaintext.read()

            iFileSize = fdPlaintext.tell()

        for i in range(iFileSize):
            lTrinary, lPassword, strData = Ternary(bData[i], 3), Ternary(ord(strPassword[k]), 3), ""

            for j in range(6):
                if lTrinary[j] == lPassword[j] == 0: strData += "0"

                elif lTrinary[j] == 0 and lPassword[j] == 1: strData += "2"

                elif lTrinary[j] == 0 and lPassword[j] == 2: strData += "2"

                elif lTrinary[j] == 1 and lPassword[j] == 0: strData += "1"

                elif lTrinary[j] == lPassword[j] == 1: strData += "1"

                elif lTrinary[j] == 1 and lPassword[j] == 2: strData += "1"

                elif lTrinary[j] == 2 and lPassword[j] == 0: strData += "2"

                elif lTrinary[j] == 2 and lPassword[j] == 1: strData += "0"

                elif lTrinary[j] == lPassword[j] == 2: strData += "0"

            lData.append(int(strData[::-1], 3))

            k = (k + 1) % iLength

        with open(sys.argv[3], "bw") as fdCiphertext:
            for iData in lData:
                fdCiphertext.write(iData.to_bytes(2, "little"))

    elif sys.argv[1] == "-d" or sys.argv[1] == "-D":
        strPassword, lData = sys.argv[4], []

        iLength, k = len(strPassword), 0

        with open(sys.argv[2], "br") as fdCiphertext:
            bData = fdCiphertext.read(2)

            while bData:
                lTrinary, lPassword, strData = Ternary(int.from_bytes(bData, "little"), 3), Ternary(ord(strPassword[k]), 3), ""

                for j in range(6):
                    if lTrinary[j] == lPassword[j] == 0: strData += "0"

                    elif lTrinary[j] == 0 and lPassword[j] == 1: strData += "2"

                    elif lTrinary[j] == 0 and lPassword[j] == 2: strData += "2"

                    elif lTrinary[j] == 1 and lPassword[j] == 0: strData += "1"

                    elif lTrinary[j] == lPassword[j] == 1: strData += "1"

                    elif lTrinary[j] == 1 and lPassword[j] == 2: strData += "1"

                    elif lTrinary[j] == 2 and lPassword[j] == 0: strData += "2"

                    elif lTrinary[j] == 2 and lPassword[j] == 1: strData += "0"

                    elif lTrinary[j] == lPassword[j] == 2: strData += "0"

                lData.append(int(strData[::-1], 3))

                k = (k + 1) % iLength

                bData = fdCiphertext.read(2)

        with open(sys.argv[3], "bw") as fdPlaintext:
            for iData in lData:
                fdPlaintext.write(iData.to_bytes(1, "little"))

    else: print("Usage\n\tEncryption: TrinaryCipher -e/-E Plaintext.file Ciphertext.file Password\n\tDecrytion: TrinaryCipher -d/-D Ciphertext.file Plaintext.file Password")