module ISocketNoGc;

interface ISocketNoGc
{
    int Connect(string server, int port) nothrow @nogc;

    int Send(byte[] data) nothrow @nogc;

    int Recieve(char[] buffer) nothrow @nogc;

    int Close() nothrow @nogc;
}