module ISocketNoGc;

interface ISocketNoGc
{
    int Connect(string server, int port);

    int Send(byte[] data);

    int Recieve(char[] buffer);

    int Close();
}