#!/usr/bin/env python

import hashlib

def application(environ, start_response):
    environ_summary = "ENVIRON:\n\n" + "\n".join(["{0}: {1}".format(k, environ[k]) for k in sorted(environ.keys())]) + "\n"
    log = environ['wsgi.errors']

    body = ''
    try:
        length = int(environ.get('CONTENT_LENGTH', '0'))
    except ValueError:
        length = 0

    if length != 0:
        body = environ['wsgi.input'].read(length)
        m = hashlib.md5()
        m.update(body)
        response_body = "%d:%s\n" % (len(body), m.hexdigest())
        log.write("content-type: %s, body.len=%d, body.md5=%s\n" % (environ['CONTENT_TYPE'], len(body), m.hexdigest()))
    else:
        response_body = environ_summary

    status = '200 OK'
    response_headers = [('Content-Type', 'text/plain'),
                        ('Content-Length', str(len(response_body)))]

    start_response(status, response_headers)

    return [response_body]

if __name__ == '__main__':
    try:
        from wsgiref.simple_server import make_server
        httpd = make_server('', 8080, application)
        print('Serving on port 8080...')
        httpd.serve_forever()
    except KeyboardInterrupt:
        print('Goodbye.')
