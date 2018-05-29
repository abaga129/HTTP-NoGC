module http;

import status;
import socketnogc;
import utility;

import core.stdc.stdio;
import dplug.core.nogc;
import core.stdc.stdlib;
/// Class for performing nothrow @nogc synchronous HTTP requests in D 
public static class Http(ResponseType)
{
public:
nothrow:
@nogc:

    static StatusCode Get(string server, string queryString, int port = 80)
    {
        SocketNoGC socket = mallocNew!SocketNoGC();
        socket.Connect(cast(string)server, port);

        char[] header = concat(cast(const char*)"GET ", cast(const(char*))queryString);
        header = concat(cast(const char*)header, cast(const char*)" ");
        header = concat(cast(const char*)header, cast(const char*)"HTTP/1.1\r\n\r\n");

        socket.Send(cast(byte[])header);
        char[] buffer = (cast (char*)malloc(char.sizeof * 5024))[0..5024];
        socket.Recieve(buffer);
        socket.Close();
        StatusCode response = mallocNew!(StatusCode)(buffer);
        return response;
    }

    static StatusCode Post(string server, string queryString, string contentBody, int port = 80, string contentType = "application/json")
    {
        SocketNoGC socket = mallocNew!SocketNoGC();
        socket.Connect(cast(string)server, port);

        char* contentLength = cast(char*)malloc(char.sizeof * 32);
        sprintf(contentLength, "%d".ptr, contentBody.length);
        char[] header = concat(cast(const char*)"POST ", cast(const(char*))queryString);
        header = concat(cast(const char*)header, cast(const char*)" HTTP/1.1\r\n");
        header = concat(cast(const char*)header, cast(const char*)"Content-Type: ");
        header = concat(cast(const char*)header, cast(const char*)contentType);
        header = concat(cast(const char*)header, cast(const char*)"\r\n");
        header = concat(cast(const char*)header, cast(const char*)"Content-Length: ");
        header = concat(cast(const char*)header, cast(const char*)contentLength);
        header = concat(cast(const char*)header, cast(const char*)"\r\n\r\n");
        header = concat(cast(const char*)header, cast(const char*) contentBody);
        header = concat(cast(const char*)header, cast(const char*)"\r\n");
        socket.Send(cast(byte[])header);
        char[] buffer = (cast (char*)malloc(char.sizeof * 5024))[0..5024];
        socket.Recieve(buffer);
        socket.Close();
        StatusCode response = mallocNew!(StatusCode)(buffer);
        return response;
    }

private:
    string _contentType = "application/json";
}

unittest
{
    auto s = Http!(string).Get("127.0.0.1", "/", 4000);
    printf(s.Data.ptr);
    printf("\n\n");

    string contentBody = "{ \"username\" : \"Ethan Reker\" }";

    auto postResult = Http!(string).Post("127.0.0.1", "/", contentBody, 4000);
    printf(postResult.Data.ptr);
    printf("\n");
}