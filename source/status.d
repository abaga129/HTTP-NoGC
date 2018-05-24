module status;

class StatusCode
{
public:
nothrow:
@nogc:
    char[] Data;
    this()
    {

    }

    this(char[] data)
    {
        Data = data;
    }

private:
}

// class SuccessCode(ReturnType) : StatusCode!ReturnType
// {

// }

// class ClientError(ReturnType) : StatusCode!ReturnType
// {

// }

// class ServerError(ReturnType) : StatusCode!ReturnType
// {

// }