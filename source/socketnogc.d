module socketnogc;

import isocketnogc;
import dplug.core.nogc;

version(linux)
    import posixsocket;
else version(Windows)
    import winsocket;

class SocketNoGC : ISocketNoGc
{
nothrow:
@nogc:
    this()
    {
        version(linux)
        {
            sockAdapter = mallocNew!PosixSocket();
        }
        version(Windows)
        {
            sockAdapter = mallocNew!WinSocket();
        }
    }

    override int Connect(string server, int port)
    {
        return sockAdapter.Connect(server,port);
    }

    override int Send(byte[] data)
    {
        return sockAdapter.Send(data);
    }

    override int Recieve(char[] buffer)
    {
        return sockAdapter.Recieve(buffer);
    }

    override int Close()
    {
        return sockAdapter.Close();
    }

private:
    ISocketNoGc sockAdapter;
}

unittest
{
    import std.stdio;

    char[] buffer = new char[120];
    SocketNoGC socket = new SocketNoGC();
    socket.Connect("localhost", 8080);
    socket.Send(cast(byte[])"Hello world!");
    socket.Recieve(buffer);
    socket.Close();

    writeln(cast(string)buffer);
}