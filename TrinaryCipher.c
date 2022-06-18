/*********************************************************
* 作者：伍耀晖               Author: YaoHui.Wu           *
* 开源日期：2022年5月27日    Open Source Date: 2022-5-27 *
* 国家：中国                 Country: China              *
*********************************************************/

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>

void Usage()
{
    printf("Usage\n\tEncryption: TrinaryCipher -e/-E Plaintext.file Ciphertext.file Password\n\tDecryption: TrinaryCipher -d/-D Ciphertext.file Plaintext.file Password\n");
}

void Ternary(long long lNumeric,
             unsigned char *ucpTrinary)
{
    for(long long i = 5; i >= 0; --i)
    {
        ucpTrinary[i] = lNumeric % 3;

        lNumeric /= 3;
    }
}

long long main(long long argc,
               char *argv[])
{
    if(argc != 5)
    {
        Usage();
    }
    else if(*(short*)argv[1] == 0x452D || *(short*)argv[1] == 0x652D)
    {
        struct stat tStatFileSize;

        stat(argv[2], &tStatFileSize);

        long long lFileSize = tStatFileSize.st_size;

        if(lFileSize == 0)
        {
            printf("There is no data in file [%s], 0 byte.\n", argv[2]);

            return -1;
        }

        int fdPlaintextOrCiphertext = open(argv[2], O_BINARY | O_RDONLY, S_IREAD | S_IWRITE);

        unsigned char *ucpPlaintext = malloc(lFileSize), ucaPlaintextOrCiphertext[6], ucaPassword[6];

        read(fdPlaintextOrCiphertext, ucpPlaintext, lFileSize);

        close(fdPlaintextOrCiphertext);

        unsigned short *uspCiphertext = malloc(2 * lFileSize);

        unsigned char ucPasswordLength = -1;

        while(argv[4][++ucPasswordLength]);

        for(long long i = 0, k = 0; i < lFileSize; ++i)
        {
            Ternary(ucpPlaintext[i], ucaPlaintextOrCiphertext);

            Ternary(argv[4][k], ucaPassword);

            for(long long j = 0; j < 6; ++j)
            {
                if(ucaPlaintextOrCiphertext[j] == 0 && ucaPassword[j] == 0)
                {
                    ucaPlaintextOrCiphertext[j] = 0;
                }
                else if(ucaPlaintextOrCiphertext[j] == 0 && ucaPassword[j] == 1)
                {
                    ucaPlaintextOrCiphertext[j] = 0;
                }
                else if(ucaPlaintextOrCiphertext[j] == 0 && ucaPassword[j] == 2)
                {
                    ucaPlaintextOrCiphertext[j] = 2;
                }
                else if(ucaPlaintextOrCiphertext[j] == 1 && ucaPassword[j] == 0)
                {
                    ucaPlaintextOrCiphertext[j] = 1;
                }
                else if(ucaPlaintextOrCiphertext[j] == 1 && ucaPassword[j] == 1)
                {
                    ucaPlaintextOrCiphertext[j] = 1;
                }
                else if(ucaPlaintextOrCiphertext[j] == 1 && ucaPassword[j] == 2)
                {
                    ucaPlaintextOrCiphertext[j] = 1;
                }
                else if(ucaPlaintextOrCiphertext[j] == 2 && ucaPassword[j] == 0)
                {
                    ucaPlaintextOrCiphertext[j] = 2;
                }
                else if(ucaPlaintextOrCiphertext[j] == 2 && ucaPassword[j] == 1)
                {
                    ucaPlaintextOrCiphertext[j] = 2;
                }
                else if(ucaPlaintextOrCiphertext[j] == 2 && ucaPassword[j] == 2)
                {
                    ucaPlaintextOrCiphertext[j] = 0;
                }
            }

            uspCiphertext[i] = 243 * ucaPlaintextOrCiphertext[0] + 81 * ucaPlaintextOrCiphertext[1] + 27 * ucaPlaintextOrCiphertext[2] + 9 * ucaPlaintextOrCiphertext[3] + 3 * ucaPlaintextOrCiphertext[4] + ucaPlaintextOrCiphertext[5];

            k = ++k % ucPasswordLength;
        }

        fdPlaintextOrCiphertext = open(argv[3], O_BINARY | O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR);

        write(fdPlaintextOrCiphertext, uspCiphertext, 2 * lFileSize);

        close(fdPlaintextOrCiphertext);

        free(uspCiphertext);

        free(ucpPlaintext);
    }
    else if(*(short*)argv[1] == 0x442D || *(short*)argv[1] == 0x642D)
    {
        struct stat tStatFileSize;

        stat(argv[2], &tStatFileSize);

        long long lFileSize = tStatFileSize.st_size;

        if(lFileSize == 0)
        {
            printf("There is no data in file [%s], 0 byte.\n", argv[2]);

            return -1;
        }

        int fdCiphertextOrPlaintext = open(argv[2], O_BINARY | O_RDONLY, S_IREAD | S_IWRITE);

        unsigned short *uspCiphertext = malloc(lFileSize);

        read(fdCiphertextOrPlaintext, uspCiphertext, lFileSize);

        close(fdCiphertextOrPlaintext);

        lFileSize /= 2;

        unsigned char *ucpPlaintext = malloc(lFileSize), ucaCiphertextOrPlaintext[6], ucaPassword[6];

        unsigned char ucPasswordLength = -1;

        while(argv[4][++ucPasswordLength]);

        for(long long i = 0, k = 0; i < lFileSize; ++i)
        {
            Ternary(uspCiphertext[i], ucaCiphertextOrPlaintext);

            Ternary(argv[4][k], ucaPassword);

            for(long long j = 0; j < 6; ++j)
            {
                if(ucaCiphertextOrPlaintext[j] == 0 && ucaPassword[j] == 0)
                {
                    ucaCiphertextOrPlaintext[j] = 0;
                }
                else if(ucaCiphertextOrPlaintext[j] == 0 && ucaPassword[j] == 1)
                {
                    ucaCiphertextOrPlaintext[j] = 0;
                }
                else if(ucaCiphertextOrPlaintext[j] == 0 && ucaPassword[j] == 2)
                {
                    ucaCiphertextOrPlaintext[j] = 2;
                }
                else if(ucaCiphertextOrPlaintext[j] == 1 && ucaPassword[j] == 0)
                {
                    ucaCiphertextOrPlaintext[j] = 1;
                }
                else if(ucaCiphertextOrPlaintext[j] == 1 && ucaPassword[j] == 1)
                {
                    ucaCiphertextOrPlaintext[j] = 1;
                }
                else if(ucaCiphertextOrPlaintext[j] == 1 && ucaPassword[j] == 2)
                {
                    ucaCiphertextOrPlaintext[j] = 1;
                }
                else if(ucaCiphertextOrPlaintext[j] == 2 && ucaPassword[j] == 0)
                {
                    ucaCiphertextOrPlaintext[j] = 2;
                }
                else if(ucaCiphertextOrPlaintext[j] == 2 && ucaPassword[j] == 1)
                {
                    ucaCiphertextOrPlaintext[j] = 2;
                }
                else if(ucaCiphertextOrPlaintext[j] == 2 && ucaPassword[j] == 2)
                {
                    ucaCiphertextOrPlaintext[j] = 0;
                }
            }

            ucpPlaintext[i] = 243 * ucaCiphertextOrPlaintext[0] + 81 * ucaCiphertextOrPlaintext[1] + 27 * ucaCiphertextOrPlaintext[2] + 9 * ucaCiphertextOrPlaintext[3] + 3 * ucaCiphertextOrPlaintext[4] + ucaCiphertextOrPlaintext[5];

            k = ++k % ucPasswordLength;
        }

        fdCiphertextOrPlaintext = open(argv[3],  O_BINARY | O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR);

        write(fdCiphertextOrPlaintext, ucpPlaintext, lFileSize);

        close(fdCiphertextOrPlaintext);

        free(ucpPlaintext);

        free(uspCiphertext);
    }
    else
    {
        Usage();
    }

    return 0;
}