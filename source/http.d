module http;

import core.stdc.stdlib;
import core.stdc.stdio;
import core.stdc.string;

version(Windows)
{
    import core.sys.windows.windows;
    import core.sys.windows.winsock2;
}
version(linux)
{
    import core.sys.posix.netinet.in_;
    import core.sys.linux.sys.socket;
    import core.sys.linux.unistd;
}

const(char)[] sendHTTPRequest(string hostname, string port)
{
    Socket!("localhost", "8080") sock = new Socket!("localhost", "8080")();
    sock.initialize();
    sock.sendData("GET / HTTP/1.1\r\n");
    sock.sendData("Host: localhost\r\n\r\n");
    const(char)[] recvData = sock.recieveData();
    sock.closeConnection();
    return recvData;
}

class Socket(string hostname, string port)
{
public:

    void initialize()
    {
        version(Windows)
        {
            // Initialize Winsock
            iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
            if (iResult != 0) {
                printf("WSAStartup failed with error: %d\n", iResult);
                return;
            }

            memset(cast(void*)&hints, 0, hints.sizeof);
            hints.ai_family = AF_UNSPEC;
            hints.ai_socktype = SOCK_STREAM;
            hints.ai_protocol = IPPROTO_TCP;

            // Resolve the server address and port
            iResult = getaddrinfo(hostname.ptr, port.ptr, &hints, &result);
            if ( iResult != 0 ) {
                printf("getaddrinfo failed with error: %d\n", iResult);
                WSACleanup();
                return;
            }

            // Attempt to connect to an address until one succeeds
            for(ptr=result; ptr != null ;ptr=ptr.ai_next) {

                // Create a SOCKET for connecting to server
                ConnectSocket = socket(ptr.ai_family, ptr.ai_socktype, 
                    ptr.ai_protocol);
                if (ConnectSocket == INVALID_SOCKET) {
                    printf("socket failed with error: %ld\n", WSAGetLastError());
                    WSACleanup();
                    return;
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
                return;
            }
        }

        version(linux)
        {
            if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
            {
                printf("\n Socket creation error \n");
                return;
            }
        
            memset(&serv_addr, '0', serv_addr.sizeof);
        
            serv_addr.sin_family = AF_INET;
            serv_addr.sin_port = htons(cast(ushort)atoi(port));
            
            // Convert IPv4 and IPv6 addresses from text to binary form
            if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)<=0) 
            {
                printf("\nInvalid address/ Address not supported \n");
                return;
            }
        
            if (connect(sock, cast(sockaddr *)&serv_addr, serv_addr.sizeof) < 0)
            {
                printf("\nConnection Failed \n");
                return;
            }
        }
    }

    void sendData(string data)
    {
        version(Windows)
        {
            // Send an initial buffer
            iResult = send( ConnectSocket, data.ptr, cast(int)data.length, 0 );
            if (iResult == SOCKET_ERROR) {
                printf("send failed with error: %d\n", WSAGetLastError());
                closesocket(ConnectSocket);
                WSACleanup();
                return;
            }
        }

        version(linux)
        {
            if((valread = cast(int)send(sock , data.ptr , cast(int)data.length , 0 )) < 0)
            {
                printf("Socket error: sending data");
            }
        }
    }

    const(char)[] recieveData()
    {
        version(Windows)
        {
            // Receive until the peer closes the connection
            do {

                iResult = recv(ConnectSocket, cast(void*)recvbuf, recvbuflen, 0);
            } while( iResult > 0 );
            return recvbuf;
        }

        version(linux)
        {
            if((valread = cast(int)read( sock , cast(void*)buffer, 1024)) < 0)
            {
                return "Error reading from host.";
            }
            return buffer;
        }
    }

    void closeConnection()
    {
        version(Windows)
        {
            // shutdown the connection since no more data will be sent
            iResult = shutdown(ConnectSocket, SD_SEND);
            if (iResult == SOCKET_ERROR) {
                printf("shutdown failed with error: %d\n", WSAGetLastError());
                closesocket(ConnectSocket);
                WSACleanup();
                return;
            }
            closesocket(ConnectSocket);
            WSACleanup();
        }
    }

private:
    version(Windows)
    {
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

    version(linux)
    {
        sockaddr_in address;
        int sock = 0, valread;
        sockaddr_in serv_addr;
        char *hello = cast(char*)"Hello from client";
        char[1024] buffer= 0;
    }
}
