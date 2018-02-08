module winsocket;

version(Windows)
{
import core.stdc.stdlib;
import core.stdc.stdio;
import core.stdc.string;
import dplug.core.nogc;
import isocketnogc;
import core.sys.windows.windows;
import core.sys.windows.winsock2;

class WinSocket : ISocketNoGc
{
    this() nothrow @nogc
    {

    }

    override int Connect(string server, int port) nothrow @nogc
    {
        char* portString = cast(char*)malloc(6);
        sprintf(portString, "%d", port);

        iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
        if (iResult != 0) {
            printf("WSAStartup failed with error: %d\n", iResult);
            return iResult;
        }

        memset(cast(void*)&hints, 0, hints.sizeof);
        hints.ai_family = AF_UNSPEC;
        hints.ai_socktype = SOCK_STREAM;
        hints.ai_protocol = IPPROTO_TCP;

        // Resolve the server address and port
        iResult = getaddrinfo(server.ptr, portString, &hints, &result);
        if ( iResult != 0 ) {
            printf("getaddrinfo failed with error: %d\n", iResult);
            WSACleanup();
            return iResult;
        }

        // Attempt to connect to an address until one succeeds
        for(ptr=result; ptr != null ;ptr=ptr.ai_next) {

            // Create a SOCKET for connecting to server
            ConnectSocket = socket(ptr.ai_family, ptr.ai_socktype, 
                ptr.ai_protocol);
            if (ConnectSocket == INVALID_SOCKET) {
                printf("socket failed with error: %ld\n", WSAGetLastError());
                WSACleanup();
                return iResult;
            }

            // Connect to server.
            iResult = connect( ConnectSocket, ptr.ai_addr, cast(int)ptr.ai_addrlen);
            if (iResult == SOCKET_ERROR) {
                closesocket(ConnectSocket);
                ConnectSocket = INVALID_SOCKET;
                continue;
            }
            break;
        }

        freeaddrinfo(result);

        if (ConnectSocket == INVALID_SOCKET) {
            printf("Unable to connect to server!\n");
            WSACleanup();
            return -1;
        }

        return 0;
    }

    override int Send(byte[] data) nothrow @nogc
    {
        iResult = send( ConnectSocket, data.ptr, cast(int)data.length, 0 );
        if (iResult == SOCKET_ERROR) {
            printf("send failed with error: %d\n", WSAGetLastError());
            closesocket(ConnectSocket);
            WSACleanup();
            return iResult;
        }

        return 0;
    }

    override int Recieve(char[] buffer) nothrow @nogc
    {
        return 0;
    }

    override int Close() nothrow @nogc
    {
        return 0;
    }

private:
    static const int DEFAULT_BUFLEN = 512;
    WSADATA wsaData;
    SOCKET ConnectSocket = INVALID_SOCKET;
    addrinfo* result = null;
    addrinfo* ptr = null;
    addrinfo hints;
    const(char)* sendbuf = "this is a test";
    char[DEFAULT_BUFLEN] recvbuf;
    int iResult;
    int recvbuflen = DEFAULT_BUFLEN;

}
}