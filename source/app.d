import http;
import std.stdio;
import std.conv;
import dplug.core.nogc;
import core.stdc.stdio;

void main(string[] args) nothrow @nogc
{
	char[100] hostname;
	char[100] port;
	if(args.length == 3)
	{
		snprintf(hostname.ptr, hostname.length, "%.*s", args[1].length, args[1].ptr);
		printf("\nHostname: %s\n", hostname.ptr);
		snprintf(port.ptr, port.length, "%.*s", args[2].length, args[2].ptr);
		printf("\nPort: %s\n", port.ptr);
		printf("\n%s\n", httpRequest(hostname, port).ptr);
	}
	else
	{
		printf("\nNote enough args\nProper usage: nogchttp.exe <hostname> <port>\n");
	}
}
