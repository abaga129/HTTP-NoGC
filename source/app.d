import http;
import std.stdio;

void main()
{
	writeln(sendHTTPRequest("localhost", "8080"));
}
