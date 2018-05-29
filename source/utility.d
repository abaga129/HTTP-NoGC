module utility;

import core.stdc.stdlib;
import core.stdc.string;

char[] concat(const char* s1, const char* s2) nothrow @nogc
{
    ulong len = strlen(s1)+strlen(s2)+1;
    char* result = cast(char*)malloc(cast(uint)len);
    strcpy(result, s1);
    strcat(result, s2);
    return result[0..cast(uint)len];
}