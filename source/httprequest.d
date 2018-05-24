module httprequest;

import socketnogc;
import error;

import core.stdc.stdlib;
import core.stdc.string;
import dplug.core.nogc;
import core.stdc.stdio;

enum Method
{
    GET,
    POST,
    PUT,
    UPDATE,
    DELETE,
    OPTIONS,
    HEAD,
    TRACE,
    CONNECT
}

string methodToString(Method method) nothrow @nogc
{
    switch (method) with (Method)
    {
        case GET: return "GET";
        case POST: return "POST";
        case PUT: return "PUT";
        case UPDATE: return "UPDATE";
        case DELETE: return "DELETE";
        case OPTIONS: return "OPTIONS";
        case HEAD: return "HEAD";
        case TRACE: return "TRACE";
        case CONNECT: return "CONNECT";
        default: return "GET";
    }
}

unittest
{
    //Test methodToString

    string s = methodToString(Method.DELETE);
    assert(s == "DELETE");

    s = methodToString(Method.GET);
    assert(s == "GET");

    s = methodToString(cast(Method)-1);
    assert(s == "GET");
}

class HTTPRequest
{
nothrow:
@nogc:
    this(string url, int port)
    {
        socket = mallocNew!SocketNoGC();

        if(port < 0 || port > 65535)
        {
            socketError =  SocketError.PORT_NOT_IN_RANGE;
        }
        socket.Connect(url, port);
    }

    this(string url, string port)
    {
        int iport = atoi(cast(const(char)*)port);
        this(url, iport);
    }

    void send()
    {
        socket.Send(cast(byte[])"GET /authentication HTTP/1.1\r\n\r\n");
        char[1024] buffer;
        socket.Recieve(buffer);
        printf("%s\n\n", buffer.ptr);
    }

private:
    SocketNoGC socket;
    SocketError socketError;
    char[1024] header;
}

unittest
{
    // import dplug.core.nogc;
    // HTTPRequest request = mallocNew!HTTPRequest("127.0.0.1", 4000);
    // request.send();
}