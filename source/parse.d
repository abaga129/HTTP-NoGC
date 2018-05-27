module parse;

import core.stdc.string;
import core.stdc.stdlib;
import core.stdc.stdio;

string parseResponse(string header) nothrow @nogc
{
    char * cheader = cast(char*)header;
    const(char *) delim = "\r\n";
    char*[10] array;
    int i = 0;
    array[i] = strtok(cheader, "\r\n".ptr);
    
    while(array[i] != null)
    {
        array[++i] = strtok(null, "\r\n".ptr);
    }

    for( i = 0; i < 10; ++i)
    {
        printf("Test\n");
        printf("%s\n", array[i]);
    }

    return "";

}

// char* strtokm( char* str, const char* delim) nothrow @nogc
// {
//     static char *tok;
//     static char *next;
//     char* m;

//     if(delim == null) return null;

//     tok = (str) ? str : next;
//     if(tok == null) return null;

//     m = strstr(tok, delim);

//     if (m) {
//         next = m + strlen(delim);
        
//     } else {
//         next = null;
//     }

//     return tok;
// }

// char** strToWordArray(char *str, const char* delim)
// {
//     char** words;
//     int nwords = countWords(str, delim);
//     words = cast(char**)malloc((*words).sizeof * (nwords + 1));

//     int w = 0;
//     ulong len = strlen(delim);
//     while(*str != null)
//     {
//         if(strncmp(str, delim, len) == 0)
//         {
//             for(int i = 0; i < len; ++i)
//             {
//                 *(str++) = 0;
//             }
//             if(*str != 0)
//                 words[w++] = str;
//             else
//                 str--;
//         }
//         str++;
//     }
//     words[w] = null;
//     return words;
// }

unittest
{
    string response = "HTTP/1.1 200 OK\r\nDate: Sun, 27 May 2018 12:50:06 GMT\r\nConnection: keep-alive\r\nTransfer-Encoding: chunked\r\n\r\nHello World Post!\r\n";
    parseResponse(response);

}