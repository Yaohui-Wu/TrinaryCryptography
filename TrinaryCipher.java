/*********************************************************
* 作者：伍耀晖               Author: YaoHui.Wu           *
* 开源日期：2022年5月27日    Open Source Date: 2022-5-27 *
* 国家：中国                 Country: China              *
*********************************************************/

import java.io.*;

public class TrinaryCipher
{
    private static void Usage()
    {
        System.out.println("Usage\n\tEncryption: java TrinaryCipher -e/-E Plaintext.file Ciphertext.file Password\n\tDecryption: java TrinaryCipher -d/-D Ciphertext.file Plaintext.file Password");
    }

    private static void Ternary(int iNumeric,
                                byte[] baTrinary)
    {
        baTrinary[0] = baTrinary[1] = baTrinary[2] = baTrinary[3] = baTrinary[4] = baTrinary[5] =  0;

        if(iNumeric != 0)
        {
            for(int i = 5; i > -1; --i)
            {
                baTrinary[i] = (byte)(iNumeric % 3);

                iNumeric /= 3;
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
            File fdData = new File(args[1]);

            long lFileSize = fdData.length();

            if(lFileSize == 0)
            {
                System.out.printf("There is no data in file [%s], 0 byte.\n", args[1]);

                System.exit(-1);
            }

            byte[] baPlaintext = new byte[(int)lFileSize], baCiphertext = new byte[(int)(2 * lFileSize)];

            try
            {
                FileInputStream fisData = new FileInputStream(fdData);

                fisData.read(baPlaintext, 0, (int)lFileSize);

                fisData.close();
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }

            int iPasswordLength = args[3].length();

            byte[] baPlaintextOrCiphertext = new byte[6], baPassword = new byte[6];

            for(int i = 0, k = 0; i < lFileSize; ++i, k = ++k % iPasswordLength)
            {
                Ternary(baPlaintext[i] & 255, baPlaintextOrCiphertext);

                Ternary(args[3].getBytes()[k], baPassword);

                for(int j = 0; j < 6; ++j)
                {
                    if(baPlaintextOrCiphertext[j] == 0 && baPassword[j] == 0)
                    {
                        baPlaintextOrCiphertext[j] = 0;
                    }
                    else if(baPlaintextOrCiphertext[j] == 0 && baPassword[j] == 1)
                    {
                        baPlaintextOrCiphertext[j] = 0;
                    }
                    else if(baPlaintextOrCiphertext[j] == 0 && baPassword[j] == 2)
                    {
                        baPlaintextOrCiphertext[j] = 2;
                    }
                    else if(baPlaintextOrCiphertext[j] == 1 && baPassword[j] == 0)
                    {
                        baPlaintextOrCiphertext[j] = 1;
                    }
                    else if(baPlaintextOrCiphertext[j] == 1 && baPassword[j] == 1)
                    {
                        baPlaintextOrCiphertext[j] = 1;
                    }
                    else if(baPlaintextOrCiphertext[j] == 1 && baPassword[j] == 2)
                    {
                        baPlaintextOrCiphertext[j] = 1;
                    }
                    else if(baPlaintextOrCiphertext[j] == 2 && baPassword[j] == 0)
                    {
                        baPlaintextOrCiphertext[j] = 2;
                    }
                    else if(baPlaintextOrCiphertext[j] == 2 && baPassword[j] == 1)
                    {
                        baPlaintextOrCiphertext[j] = 2;
                    }
                    else if(baPlaintextOrCiphertext[j] == 2 && baPassword[j] == 2)
                    {
                        baPlaintextOrCiphertext[j] = 0;
                    }
                }

                char cCiphertext = (char)(243 * baPlaintextOrCiphertext[0] + 81 * baPlaintextOrCiphertext[1] + 27 * baPlaintextOrCiphertext[2] + 9 * baPlaintextOrCiphertext[3] + 3 * baPlaintextOrCiphertext[4] + baPlaintextOrCiphertext[5]);

                baCiphertext[2 * i] = (byte)cCiphertext;

                baCiphertext[2 * i + 1] = (byte)(cCiphertext >> 8);
            }
            
            try
            {
                FileOutputStream fosData = new FileOutputStream(args[2]);

                fosData.write(baCiphertext, 0, (int)(2 * lFileSize));

                fosData.close();
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
        }
        else if(args[0].equals("-d") || args[0].equals("-D"))
        {
            File fdData = new File(args[1]);

            long lFileSize = fdData.length();

            if(lFileSize == 0)
            {
                System.out.printf("There is no data in file [%s], 0 byte.\n", args[1]);

                System.exit(-1);
            }

            byte[] baCiphertext = new byte[(int)lFileSize];

            try
            {
                FileInputStream fisData = new FileInputStream(fdData);

                fisData.read(baCiphertext, 0, (int)lFileSize);

                fisData.close();
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }

            lFileSize /= 2;

            byte[] baPlaintext = new byte[(int)lFileSize];

            int iPasswordLength = args[3].length();

            byte[] baCiphertextOrPlaintext = new byte[6], baPassword = new byte[6];

            for(int i = 0, k = 0; i < lFileSize; ++i, k = ++k % iPasswordLength)
            {
                Ternary((baCiphertext[2 * i] & 255) + ((baCiphertext[2 * i + 1] & 255) << 8), baCiphertextOrPlaintext);

                Ternary(args[3].getBytes()[k], baPassword);

                for(int j = 0; j < 6; ++j)
                {
                    if(baCiphertextOrPlaintext[j] == 0 && baPassword[j] == 0)
                    {
                        baCiphertextOrPlaintext[j] = 0;
                    }
                    else if(baCiphertextOrPlaintext[j] == 0 && baPassword[j] == 1)
                    {
                        baCiphertextOrPlaintext[j] = 0;
                    }
                    else if(baCiphertextOrPlaintext[j] == 0 && baPassword[j] == 2)
                    {
                        baCiphertextOrPlaintext[j] = 2;
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
                        baCiphertextOrPlaintext[j] = 2;
                    }
                    else if(baCiphertextOrPlaintext[j] == 2 && baPassword[j] == 1)
                    {
                        baCiphertextOrPlaintext[j] = 2;
                    }
                    else if(baCiphertextOrPlaintext[j] == 2 && baPassword[j] == 2)
                    {
                        baCiphertextOrPlaintext[j] = 0;
                    }
                }

                baPlaintext[i] = (byte)(243 * baCiphertextOrPlaintext[0] + 81 * baCiphertextOrPlaintext[1] + 27 * baCiphertextOrPlaintext[2] + 9 * baCiphertextOrPlaintext[3] + 3 * baCiphertextOrPlaintext[4] + baCiphertextOrPlaintext[5]);
            }

            try
            {
                FileOutputStream fosData = new FileOutputStream(args[2]);

                fosData.write(baPlaintext, 0, (int)lFileSize);

                fosData.close();
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
        }
        else
        {
            Usage();
        }
    }
}