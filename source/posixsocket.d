module posixsocket;

version(linux)
{
    
import isocketnogc;
import core.stdc.stdlib;
import core.stdc.stdio;
import core.stdc.string;
import dplug.core.nogc;

import core.sys.posix.netinet.in_;
import core.sys.linux.sys.socket;
import core.sys.linux.unistd;


class PosixSocket : ISocketNoGc
{
nothrow:
@nogc:
    override int Connect(string server, int port)
    {
        if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
        {
            printf("\n Socket creation error \n");
            return -1;
        }
    
        memset(&serv_addr, '0', serv_addr.sizeof);
    
        serv_addr.sin_family = AF_INET;
        serv_addr.sin_port = htons(cast(ushort)port);
        
        // Convert IPv4 and IPv6 addresses from text to binary form
        if(inet_pton(AF_INET, cast(const(char)*)server, &serv_addr.sin_addr)<=0) 
        {
            printf("\nInvalid address/ Address not supported \n");
            return -1;
        }
    
        if (connect(sock, cast(sockaddr *)&serv_addr, serv_addr.sizeof) < 0)
        {
            printf("\nConnection Failed \n");
            return -1;
        }
        return 0;
    }

    override int Send(byte[] data)
    {
        if((valread = cast(int)send(sock , data.ptr , cast(int)data.length , 0 )) < 0)
        {
            return valread;
        }
        return 0;
    }

    override int Recieve(char[] buffer)
    {
        if((valread = cast(int)read( sock , cast(void*)buffer, 1024)) < 0)
        {
            return valread;
        }
        return 0;
    }

    override int Close()
    {
        return 0;
    }

private:
    sockaddr_in address;
    int sock = 0, valread;
    sockaddr_in serv_addr;
    char *hello = cast(char*)"Hello from client";
    //char[1024] buffer= 0;
}

}