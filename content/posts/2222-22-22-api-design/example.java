interface HttpCall {
	void setHeader(String name, String value);
	String request(String url);
}




interface Url {
	static fromString(String url);
	static http(String url);
	static https(String url);
}

class Request {
	Request(Url url);
	Request url(Url url);
	Request url(String url);
	Request header(String name, String value); 
}

interface Response {
	String body();
}

Response send(Request request) {

}

Request r = Request(http("www.example.org"))
	.header("bla", "x");
send(r)
