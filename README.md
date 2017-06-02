
## Generate JWT key
```
ssh-keygen -t rsa -b 2048 -f jwtRS256.key
# Don't add passphrase
openssl rsa -in jwtRS256.key -pubout -outform PEM -out jwtRS256.key.pub
cat jwtRS256.key
```
It will print something like this
```
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA2MBhga9j06SCZcYr9JLfQg3TnUZnJfN6fl5c/nAoTx8kv/iV
P2EtxQt89KcXyKNLnl2z5HQfQgAGnioPkDHcqd2XVyNxxXa2DAtfL34EeNnl/4gV
6WXPw6hZ8s2X+OkTTTStqdxfgtxXCKbRRcOBTJa/F3eY9jBW16jujygkyt+WwD28
XcQSs4enLhHOyljslhLv6ebqJ3cNI7+j3St4JYmB+SAAK2di1tzU2OaMlcUo7bEt
yqzDiZKsXBtLKTBVQ9TbwFiFQ+9IfkegOMEC7P02N9iQ/11urMU/rTrb6fKB6/G7
KfFCQhWj+QKZGewXC+PYOMYJgUMk1WRsDcQScwIDAQABAoIBAF1Hja7t+Bwg9C0w
d8ItYv9eS++nWMSwX8r6eTLWucIzOPGU3UYFYFkodIIlVsr125kv4jcy8jDJKg/v
MftwOfKwdmz9x/ye9gGA81nQ9cO8ooqx2hwzwJIHZY5khD6Or8vOG966BDCg+qOy
huVrGb4IMfy7b4yjiPwOq3vYXt0fSU/zA8U6akCFrIAFICH1rmWqwSsz9CtN5Bz2
61+seqEtEFLRDtdSxzrYEn1GnWni8DayOaB35fHdDuVRsaxKtSfQ7yIOrPXlRkqT
e/sNz891TlwS0G6NHas6E+ZPQljtGBef/AIrtTEHmUdc5wXS0Mmgu+yvzSgVRntN
hfX4QiECgYEA7ugr2NDDRgg7el0CspJAzPWH/JotoVb715lZJJ8tbu7NTQfL6bnU
zQj6kF78DXOyXYp11lTiEpRzLOKXUKy1VdJ5Du0XkKC/ogR4/5QEdk7RZ1In9Dwd
E2AXX57hUri3ObMsVpF0+nZWmF1wRs+JYUh2fTBeo1ZWPA/DvHFGTTcCgYEA6EJo
60gug7z6zVBorZBgTGZCfg8DwW7CvTGQ785sK5TYcKHgXM2PQhDXEqai1rNoIgmR
YtYHDDeS39kR6UuJCRPZbnkDwEcXbpCE5rqmTa+7yO4s0E5di57z9Jos31jPqMFb
YU73cHPy8XnlMD8KiHwR/krGgacukK+pdfXlIqUCgYBnlVSFgiZYc/NN34vu3sin
1QEr/bExFeTFmuByp21sfq+W6X15DjB84Zq6A+Tm9DXuprzmvBD1G1ZArNIMkYVh
+4qvdQ7Vj0znM2c+8O9qWEwkrxNRqsq0fuJDfECXvCz9IHll41VDzxFGqKSonw0i
l+d/6fvud92V1wP37WkcywKBgQChfKM0jBCDWl9LZ9AQdaTvGd67hTcIRDm0kAUF
J5JATxKaZYL5I5eqyMixWBk6jK0nlV13yfZGgVFmwKfafMGABUQVsqBwDT32ixdM
0ZQVyc0YLLoN757NGCzo8lWmyTpBTId7xgr3LjdJvIYlIH/zW8iq9VTGCvaudOSv
dtPlXQKBgHmHsipMpFlZeJDtFnlyAGJTte/lowVN9rHm8q8gYioWgLaCxY2bqQRl
BzCiVnvhBfKY04QbvwGMBriFhQisaV/0tdr7NgTVSPbFog3+LmlZ7EGGoYgXqmyH
APibHAScbdHrjOGP3lPasJmKqtVgN11dtJoNRj8GkQle2s1Hljnf
-----END RSA PRIVATE KEY-----
```
Remove the BEGIN and END delimiters and the line breaks before adding it to jwt.json

<p align="center">
    <img src="https://cloud.githubusercontent.com/assets/1342803/24797159/52fb0d88-1b90-11e7-85a5-359fff0496a4.png" width="320" alt="MySQL">
    <br>
    <br>
    <a href="http://beta.docs.vapor.codes/getting-started/hello-world/">
        <img src="http://img.shields.io/badge/read_the-docs-92A8D1.svg" alt="Documentation">
    </a>
    <a href="http://vapor.team">
        <img src="http://vapor.team/badge.svg" alt="Slack Team">
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/mysql">
        <img src="https://circleci.com/gh/vapor/mysql.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://travis-ci.org/vapor/api-template">
    	<img src="https://travis-ci.org/vapor/api-template.svg?branch=master" alt="Build Status">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-3.1-brightgreen.svg" alt="Swift 3.1">
    </a>
</center>
