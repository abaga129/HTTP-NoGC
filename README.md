# NoGCHTTP

## Send HTTP Requests from D without using the runtime

The goal with this small project is to make a simple and reliable package for making HTTP requests in D without using the D runtime. It will allow you to make requests from within @nogc classes and functions.

## How To Use

Currently this is not available on the dub package repository. 
Clone this repository and add it your `dub.json` config file in the dependencies section.

```json
"dependencies": {
  "nogchttp": {"path": "pathToThisPackage"}
},
```
Then from within your source file you can use it like this
```D
import nogchttp.httprequest;

void main()
{
    HTTPRequest req = new HTTPRequest("localhost", 80);
    string res = req.send(Method.GET, "some/uri/here");
}
```

## Roadmap
In it's current state, NoGCHTTP is not completely functional!  I plan to get the basics working first.  Things like HTTP/1.1 and the expected returned document type will be hardcoded and then make more rubust later.
