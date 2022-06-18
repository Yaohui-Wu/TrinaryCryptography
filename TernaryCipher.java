/*********************************************************
* 作者：伍耀晖               Author: YaoHui.Wu           *
* 开源日期：2022年5月27日    Open Source Date: 2022-5-27 *
* 国家：中国                 Country: China              *
*********************************************************/

import java.io.*;

public class NewTrinaryCipher
{
    private static void Usage()
    {
        System.out.println("Usage\n\tEncryption: java TrinaryCipher -e/-E Plaintext.file Ciphertext.file Password\n\tDecryption: java TrinaryCipher -d/-D Ciphertext.file Plaintext.file Password\n");
    }

    private static void Ternary(int iNumeric,
                                byte[] baTrinary)
    {
        for(int i = 5; i >= 0; --i)
        {
            baTrinary[i] = (byte)(iNumeric % 3);

            iNumeric /= 3;
        }
    }

// 2 2 0
// 1 1 1
// 0 0 2

    private static void TernaryXand(byte[] baCiphertextOrPlaintext,
                                    byte[] baPassword)
    {
        for(int j = 0; j < 6; ++j)
        {
            if(baCiphertextOrPlaintext[j] == 0 && baPassword[j] == 0)
            {
                baCiphertextOrPlaintext[j] = 2;
            }
            else if(baCiphertextOrPlaintext[j] == 0 && baPassword[j] == 1)
            {
                baCiphertextOrPlaintext[j] = 2;
            }
            else if(baCiphertextOrPlaintext[j] == 0 && baPassword[j] == 2)
            {
                baCiphertextOrPlaintext[j] = 0;
            }
            else if(baCiphertextOrPlaintext[j] == 1 && baPassword[j] == 0)
            {
                baCiphertextOrPlaintext[j] = 1;
            }
            else if(baCiphertextOrPlaintext[j] == 1 && baPassword[j] == 1)
            {
                baCiphertextOrPlaintext[j] = 1;
            }
            else if(baCiphertextOrPlaintext[j] == 1 && baPassword[j] == 2)
            {
                baCiphertextOrPlaintext[j] = 1;
            }
            else if(baCiphertextOrPlaintext[j] == 2 && baPassword[j] == 0)
            {
                baCiphertextOrPlaintext[j] = 0;
            }
            else if(baCiphertextOrPlaintext[j] == 2 && baPassword[j] == 1)
            {
                baCiphertextOrPlaintext[j] = 0;
            }
            else if(baCiphertextOrPlaintext[j] == 2 && baPassword[j] == 2)
            {
                baCiphertextOrPlaintext[j] = 2;
            }
        }
    }

    public static void main(String[] args)
    {
        if(args.length != 4)
        {
            Usage();
        }
        else if(args[0].equals("-e") || args[0].equals("-E"))
        {
            int iPasswordLength = args[3].length();

            byte[][] baPassword = new byte[iPasswordLength][6];

            for(int i = 0; i < iPasswordLength; ++i)
            {
                Ternary(args[3].getBytes()[i], baPassword[i]);
            }

            RandomAccessFile rafPlaintext = null, rafCiphertext = null;

            try
            {
                rafPlaintext = new RandomAccessFile(args[1], "r");

                rafCiphertext = new RandomAccessFile(args[2], "rw");

                long lFileSize = rafPlaintext.length();

                rafCiphertext.setLength(2 * lFileSize);

                byte[] baPlaintextOrCiphertext = new byte[6];

                int k = 0;

                for(long j = 0; j < lFileSize; ++j)
                {
                    Ternary(rafPlaintext.readUnsignedByte(), baPlaintextOrCiphertext);

                    TernaryXand(baPlaintextOrCiphertext, baPassword[k]);

                    rafCiphertext.writeShort(243 * baPlaintextOrCiphertext[0] + 81 * baPlaintextOrCiphertext[1] + 27 * baPlaintextOrCiphertext[2] + 9 * baPlaintextOrCiphertext[3] + 3 * baPlaintextOrCiphertext[4] + baPlaintextOrCiphertext[5]);

                    k = ++k % iPasswordLength;
                }              
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
            finally
            {
                try
                {
                    if(rafCiphertext != null)
                    {
                        rafCiphertext.close();
                    }

                    if(rafPlaintext != null)
                    {
                        rafPlaintext.close();
                    }
                }
                catch(Exception e)
                {
                    e.printStackTrace();
                }
            }
        }
        else if(args[0].equals("-d") || args[0].equals("-D"))
        {
            int iPasswordLength = args[3].length();

            byte[][] baPassword = new byte[iPasswordLength][6];

            for(int i = 0; i < iPasswordLength; ++i)
            {
                Ternary(args[3].getBytes()[i], baPassword[i]);
            }

            RandomAccessFile rafCiphertext = null, rafPlaintext = null;

            try
            {
                rafCiphertext = new RandomAccessFile(args[1], "r");

                rafPlaintext = new RandomAccessFile(args[2], "rw");

                long lFileSize = rafCiphertext.length() / 2;

                rafPlaintext.setLength(lFileSize);

                byte[] baCiphertextOrPlaintext = new byte[6];

                int k = 0;

                for(long j = 0; j < lFileSize; ++j)
                {
                    Ternary(rafCiphertext.readUnsignedShort(), baCiphertextOrPlaintext);

                    TernaryXand(baCiphertextOrPlaintext, baPassword[k]);

                    rafPlaintext.writeByte(243 * baCiphertextOrPlaintext[0] + 81 * baCiphertextOrPlaintext[1] + 27 * baCiphertextOrPlaintext[2] + 9 * baCiphertextOrPlaintext[3] + 3 * baCiphertextOrPlaintext[4] + baCiphertextOrPlaintext[5]);

                    k = ++k % iPasswordLength;
                }
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
            finally
            {
                try
                {
                    if(rafPlaintext != null)
                    {
                        rafPlaintext.close();
                    }

                    if(rafCiphertext != null)
                    {
                        rafCiphertext.close();
                    }
                }
                catch(Exception e)
                {
                    e.printStackTrace();
                }
            }
        }
        else
        {
            Usage();
        }
    }
}