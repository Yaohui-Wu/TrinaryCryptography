/*******************************************************
* ���ߣ���ҫ��	           Author: YaoHui.Wu           *
* ��Դ���ڣ�2022��5��27��  Open Source Date: 2022-5-27 *
* ���ң��й�               Country: China              *
*******************************************************/

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
    if(lNumeric < 1)
    {
        ucpTrinary[0] = ucpTrinary[1] = ucpTrinary[2] = ucpTrinary[3] = ucpTrinary[4] = ucpTrinary[5] =  0;
    }
    else
    {
        for(long long i = 5; i >= 0; --i)
        {
            ucpTrinary[i] = lNumeric % 3;

            lNumeric /= 3;
        }
    }
}

// 0 ? 2    0 1 2
// 1 1 1 or ? 1 ?
// 2 ? 0    2 1 0

void TernaryXor(unsigned char *ucpCiphertextOrPlaintext,
                unsigned char *ucpPassword)
{
    for(long long j = 0; j < 6; ++j)
    {
        if(ucpCiphertextOrPlaintext[j] == 0 && ucpPassword[j] == 0)
        {
            ucpCiphertextOrPlaintext[j] = 0;
        }
        else if(ucpCiphertextOrPlaintext[j] == 0 && ucpPassword[j] == 1)
        {
            ucpCiphertextOrPlaintext[j] = 2;
        }
        else if(ucpCiphertextOrPlaintext[j] == 0 && ucpPassword[j] == 2)
        {
            ucpCiphertextOrPlaintext[j] = 2;
        }
        else if(ucpCiphertextOrPlaintext[j] == 1 && ucpPassword[j] == 0)
        {
            ucpCiphertextOrPlaintext[j] = 1;
        }
        else if(ucpCiphertextOrPlaintext[j] == 1 && ucpPassword[j] == 1)
        {
            ucpCiphertextOrPlaintext[j] = 1;
        }
        else if(ucpCiphertextOrPlaintext[j] == 1 && ucpPassword[j] == 2)
        {
            ucpCiphertextOrPlaintext[j] = 1;
        }
        else if(ucpCiphertextOrPlaintext[j] == 2 && ucpPassword[j] == 0)
        {
            ucpCiphertextOrPlaintext[j] = 2;
        }
        else if(ucpCiphertextOrPlaintext[j] == 2 && ucpPassword[j] == 1)
        {
            ucpCiphertextOrPlaintext[j] = 0;
        }
        else if(ucpCiphertextOrPlaintext[j] == 2 && ucpPassword[j] == 2)
        {
            ucpCiphertextOrPlaintext[j] = 0;
        }
    }
}

long long main(long long argc,
               char *argv[])
{
    if(argc < 5)
    {
        Usage();
    }
    else if(*(short*)argv[1] == 0x452D || *(short*)argv[1] == 0x652D)
    {
        long long lPasswordLength = -1;

        while(argv[4][++lPasswordLength]);

        unsigned char *ucpPassword = malloc(6 * lPasswordLength);

        for(long long i = 0; i < lPasswordLength; ++i)
        {
            Ternary(argv[4][i], ucpPassword + 6 * i);
        }

        struct stat tStatFileSize;

        stat(argv[2], &tStatFileSize);

        long long lFileSize = tStatFileSize.st_size;

        int fdPlaintextOrCiphertext = open(argv[2], O_BINARY | O_RDONLY, S_IREAD | S_IWRITE);

        unsigned char *ucpPlaintext = malloc(lFileSize), ucaCiphertext[6];

        read(fdPlaintextOrCiphertext, ucpPlaintext, lFileSize);

        close(fdPlaintextOrCiphertext);

        unsigned short *uspCiphertext = malloc(2 * lFileSize);

        for(long long j = 0, k = 0; j < lFileSize; ++j)
        {
            Ternary(ucpPlaintext[j], ucaCiphertext);

            TernaryXor(ucaCiphertext, ucpPassword + 6 * k);

            uspCiphertext[j] = 243 * ucaCiphertext[0] + 81 * ucaCiphertext[1] + 27 * ucaCiphertext[2] + 9 * ucaCiphertext[3] + 3 * ucaCiphertext[4] + ucaCiphertext[5];

            k = ++k % lPasswordLength;
        }

        fdPlaintextOrCiphertext = open(argv[3], O_BINARY | O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR);

        write(fdPlaintextOrCiphertext, uspCiphertext, 2 * lFileSize);

        close(fdPlaintextOrCiphertext);

        free(uspCiphertext);

        free(ucpPlaintext);
    }
    else if(*(short*)argv[1] == 0x442D || *(short*)argv[1] == 0x642D)
    {
        long long lPasswordLength = -1;

        while(argv[4][++lPasswordLength]);

        unsigned char *ucpPassword = malloc(6 * lPasswordLength);

        for(long long i = 0; i < lPasswordLength; ++i)
        {
            Ternary(argv[4][i], ucpPassword + 6 * i);
        }

        struct stat tStatFileSize;

        stat(argv[2], &tStatFileSize);

        long long lFileSize = tStatFileSize.st_size;

        int fdCiphertextOrPlaintext = open(argv[2], O_BINARY | O_RDONLY, S_IREAD | S_IWRITE);

        unsigned short *uspCiphertext = malloc(lFileSize);

        read(fdCiphertextOrPlaintext, uspCiphertext, lFileSize);

        close(fdCiphertextOrPlaintext);

        lFileSize /= 2;

        unsigned char *ucpPlaintext = malloc(lFileSize), ucaPlaintext[6];

        for(long long j = 0, k = 0; j < lFileSize; ++j)
        {
            Ternary(uspCiphertext[j], ucaPlaintext);

            TernaryXor(ucaPlaintext, ucpPassword + 6 * k);

            ucpPlaintext[j] = 243 * ucaPlaintext[0] + 81 * ucaPlaintext[1] + 27 * ucaPlaintext[2] + 9 * ucaPlaintext[3] + 3 * ucaPlaintext[4] + ucaPlaintext[5];

            k = ++k % lPasswordLength;
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