## Access member data

First we’ll try to access an authenticated controller without a JWT token.

```
$ curl -XGET -H "Content-Type: application/json" http://localhost:3000/member-data
```

This will fail. Because we’re not logged in.

```
=> <html><body>You are being <a href="http://localhost:3000/users/sign_in">redirected</a>.</body></html>%
```

But it will work after we get our JWT auth token.

## Register an account

```
$ curl -XPOST -H "Content-Type: application/json" -d '{ "user": { "email": "test@example.com", "password": "12345678" } }' http://localhost:3000/users
```

### Response:

```
=> {"message":"Signed up sucessfully."}
```

## Login with registered account

Now login to the account we just created.

```
$ curl -XPOST -i -H "Content-Type: application/json" -d '{ "user": { "email": "test@example.com", "password": "12345678" } }' http://localhost:3000/users/sign_in
```

The `-i` flag is very important. It prints the response headers, which contain the JWT token for authorizing future requests.

You’ll get a header in the response (see below) because you used the `-i` flag in your request.

### Response:

```
HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Permitted-Cross-Domain-Policies: none
Referrer-Policy: strict-origin-when-cross-origin
Content-Type: application/json; charset=utf-8
Vary: Accept, Origin
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjIwNDkzOTUzLCJleHAiOjE2MjA0OTc1NTMsImp0aSI6IjlmZjkzMDA2LTAxNTMtNDc5YS1hYjY2LTZiMDBhOWU2NjM1ZCJ9.K6oHIUI0AuZ4HfDV1iElFe9OZoMh_st3l1rfhD0PIqY
ETag: W/"4f46b654dd4b5ef6187f2663ef5a55c4"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 498ef50b-4bbb-44b6-9b39-dd45d03aa7b4
X-Runtime: 0.293374
Transfer-Encoding: chunked

{"message":"You are logged in."}
```

I’ve highlighted the auth token above.

## Access member data with JWT token

Let’s try making another request to the members endpoint, but this time using the auth token returned in the last response header.

```
$ curl -XGET -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjIwNDkzOTUzLCJleHAiOjE2MjA0OTc1NTMsImp0aSI6IjlmZjkzMDA2LTAxNTMtNDc5YS1hYjY2LTZiMDBhOWU2NjM1ZCJ9.K6oHIUI0AuZ4HfDV1iElFe9OZoMh_st3l1rfhD0PIqY" -H "Content-Type: application/json" http://localhost:3000/member-data
```

***Remember to use your own auth token. Mine won’t work for you.***

And you should receive a successful response.

```
=> {"message":"If you see this, you're in!"}
```

## Sign out

You’ll eventually want a way for users to log out of your platform.

Making a request to /users/sign_out will add a token to the denylist table we created above. Subsequent requests with this token will now be invalid. And the user will need to sign in again and get a new token in order to hit the members endpoint.

```
$ curl -XDELETE -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjIwNDk2NTE3LCJleHAiOjE2MjA1MDAxMTcsImp0aSI6IjAyMjY4NTQzLTg0M2YtNGI1Zi1iMTBkLTgwYmU4NzYxOWI2ZCJ9.3sp3LWO1UB-qPBj2YQjPnTt4GFyyuc6UptmLpFkrvL4" -H "Content-Type: application/json" http://localhost:3000/users/sign_out
```

### Response:

```
=> {"message":"You are logged out."}
```
