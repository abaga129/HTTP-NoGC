module error;

enum SocketError : long
{
    OK = 0x0000,
    PORT_NOT_IN_RANGE = 0x0010,
    INVALID_URL = 0x0100
}