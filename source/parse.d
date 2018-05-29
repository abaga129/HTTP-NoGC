module parse;

import core.stdc.string;
import core.stdc.stdlib;
import core.stdc.stdio;
import dplug.core.alignedbuffer;
import dplug.core.nogc;

char** parseResponse(string response) nothrow @nogc
{
    char* cresponse = cast(char*) response;
    const(char*) delim = cast(const(char*))"\r\n";

    int buffer_length = wordCount(cresponse, delim);
    char** parsedResponse = cast(char**)malloc((char**).sizeof * buffer_length);
    for(int i = 0; i < buffer_length; ++i)
    {
        parsedResponse[i] = cast(char*) malloc((char*).sizeof * 256);
    }

    int count = 0;
    char c = ' ';
    int last = 0;
    int total_len = cast(int)strlen(cresponse);
    int word_len = cast(int)strlen(delim);

    int current = 0;
    int buffer_count = 0;
    AlignedBuffer!char delim_buf = makeAlignedBuffer!char();
    for(int i = 0; i < total_len; ++i)
    {
        c = cresponse[i];
        if(c == delim[0])
        {
            while(word_len >= delim_buf.length && c == delim[delim_buf.length])
            {
                delim_buf.pushBack(c);
                c = cresponse[++i];
            }

            if(cast(string)delim[0..word_len] == cast(string)delim_buf[0..delim_buf.length] && i - word_len != last)
            {
                parsedResponse[current][++buffer_count] = '\0';
                current++;
                buffer_count = 0;
                if(current >= buffer_length)
                    break;
            }
            last = i;
        }
        parsedResponse[current][++buffer_count] = c;
    }

    for(int i = 0; i < buffer_length; ++i)
    {
        printf("%s\n", parsedResponse[i]);
    }

    return parsedResponse;
}

int wordCount(char* input, const(char*) word) nothrow @nogc
{
    int total_len = cast(int)strlen(input);
    int word_len = cast(int)strlen(word);

    int count = 0;
    char c = ' ';
    int last = 0;
    AlignedBuffer!char delim_buf = makeAlignedBuffer!char();
    for(int i = 0; i < total_len; ++i)
    {
        c = input[i];
        if(c == word[0])
        {
            while(word_len >= delim_buf.length && c == word[delim_buf.length])
            {
                delim_buf.pushBack(c);
                c = input[++i];
            }

            if(cast(string)word[0..word_len] == cast(string)delim_buf[0..delim_buf.length] && i - word_len != last)
            {
                count++;
            }
            last = i;
        }
    }
    return count;
}

unittest
{
    import std.stdio;
    writeln("********************************* parse.d *****************************************");
    string response = "HTTP/1.1 200 OK\r\nDate: Sun, 27 May 2018 12:50:06 GMT\r\nConnection: keep-alive\r\nTransfer-Encoding: chunked\r\n\r\nHello World Post!\r\n";

    int i = wordCount(cast(char*)response, cast(const(char*))"\r\n");

    parseResponse(response);

    writeln("********************************* parse.d *****************************************");
}