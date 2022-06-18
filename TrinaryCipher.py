#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#*********************************************************
# 作者：伍耀晖               Author: YaoHui.Wu           *
# 开源日期：2022年5月27日    Open Source Date: 2022-5-27 *
# 国家：中国                 Country: China              *
#*********************************************************

import sys

def Usage():
    print("Usage\n\tEncryption: python TrinaryCipher -e/-E Plaintext.file Ciphertext.file Password\n\tDecrytion: python TrinaryCipher -d/-D Ciphertext.file Plaintext.file Password")

def Ternary(iNumeric, lTrinary):
    for i in range(5, -1, -1):
        iNumeric, iRemainder = divmod(iNumeric, 3)

        lTrinary[i] = iRemainder

if __name__ == "__main__":
    if len(sys.argv) != 5: Usage()

    elif sys.argv[1] == "-e" or sys.argv[1] == "-E":
        with open(sys.argv[2], "br") as fdPlaintext:
            bData = fdPlaintext.read()

            iFileSize = fdPlaintext.tell()

        if iFileSize == 0:
            print("There is no data in file [{}], 0 byte.".format(sys.argv[2]))

            exit(-1)

        strPassword, lData = sys.argv[4], []

        iPasswordLength, k = len(strPassword), 0

        lPlaintextOrCiphertext, lPassword = [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]

        for i in range(iFileSize):
            Ternary(bData[i], lPlaintextOrCiphertext)

            Ternary(ord(strPassword[k]), lPassword)

            for j in range(6):
                if lPlaintextOrCiphertext[j] == lPassword[j] == 0: lPlaintextOrCiphertext[j] = "0"

                elif lPlaintextOrCiphertext[j] == 0 and lPassword[j] == 1: lPlaintextOrCiphertext[j] = "0"

                elif lPlaintextOrCiphertext[j] == 0 and lPassword[j] == 2: lPlaintextOrCiphertext[j] = "2"

                elif lPlaintextOrCiphertext[j] == 1 and lPassword[j] == 0: lPlaintextOrCiphertext[j] = "1"

                elif lPlaintextOrCiphertext[j] == lPassword[j] == 1: lPlaintextOrCiphertext[j] = "1"

                elif lPlaintextOrCiphertext[j] == 1 and lPassword[j] == 2: lPlaintextOrCiphertext[j] = "1"

                elif lPlaintextOrCiphertext[j] == 2 and lPassword[j] == 0: lPlaintextOrCiphertext[j] = "2"

                elif lPlaintextOrCiphertext[j] == 2 and lPassword[j] == 1: lPlaintextOrCiphertext[j] = "2"

                elif lPlaintextOrCiphertext[j] == lPassword[j] == 2: lPlaintextOrCiphertext[j] = "0"

            lData.append(int("".join(lPlaintextOrCiphertext), 3))

            k = (k + 1) % iPasswordLength

        with open(sys.argv[3], "bw") as fdCiphertext:
            for iData in lData:
                fdCiphertext.write(iData.to_bytes(2, "little"))

    elif sys.argv[1] == "-d" or sys.argv[1] == "-D":
        with open(sys.argv[2], "br") as fdCiphertext:
            bData = fdCiphertext.read()

            iFileSize = fdCiphertext.tell() // 2

        if iFileSize == 0:
            print("There is no data in file [{}], 0 byte.".format(sys.argv[2]))

            exit(-1)

        strPassword, lData = sys.argv[4], []

        iPasswordLength, k = len(strPassword), 0

        lCiphertextOrPlaintext, lPassword = [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]

        for i in range(iFileSize):
            Ternary(bData[2 * i] + (bData[2 * i +1] << 8), lCiphertextOrPlaintext)

            Ternary(ord(strPassword[k]), lPassword)

            for j in range(6):
                if lCiphertextOrPlaintext[j] == lPassword[j] == 0: lCiphertextOrPlaintext[j] = "0"

                elif lCiphertextOrPlaintext[j] == 0 and lPassword[j] == 1: lCiphertextOrPlaintext[j] = "0"

                elif lCiphertextOrPlaintext[j] == 0 and lPassword[j] == 2: lCiphertextOrPlaintext[j] = "2"

                elif lCiphertextOrPlaintext[j] == 1 and lPassword[j] == 0: lCiphertextOrPlaintext[j] = "1"

                elif lCiphertextOrPlaintext[j] == lPassword[j] == 1: lCiphertextOrPlaintext[j] = "1"

                elif lCiphertextOrPlaintext[j] == 1 and lPassword[j] == 2: lCiphertextOrPlaintext[j] = "1"

                elif lCiphertextOrPlaintext[j] == 2 and lPassword[j] == 0: lCiphertextOrPlaintext[j] = "2"

                elif lCiphertextOrPlaintext[j] == 2 and lPassword[j] == 1: lCiphertextOrPlaintext[j] = "2"

                elif lCiphertextOrPlaintext[j] == lPassword[j] == 2: lCiphertextOrPlaintext[j] = "0"

            lData.append(int("".join(lCiphertextOrPlaintext), 3))

            k = (k + 1) % iPasswordLength

        with open(sys.argv[3], "bw") as fdPlaintext:
            for iData in lData:
                fdPlaintext.write(iData.to_bytes(1, "little"))

    else: Usage()