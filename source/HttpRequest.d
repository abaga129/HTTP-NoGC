module HttpRequest;

import SocketNoGC;
import error;

import core.stdc.stdlib;
import core.stdc.string;
import dplug.core.nogc;

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

    void setMethod(Method m)
    {
        //header = methodToString(m) ~ " / HTTP/1.1\r\n";
    }

private:
    SocketNoGC socket;
    SocketError socketError;
    char[1024] header;
}

unittest
{
    import dplug.core.nogc;
    HTTPRequest request = mallocNew!HTTPRequest("localhost", 8080);
    request.setMethod(Method.GET);
}