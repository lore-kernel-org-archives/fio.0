Return-Path: <bruce@cran.org.uk>
Message-ID: <4E33D245.6060301@cran.org.uk>
Date: Sat, 30 Jul 2011 10:43:33 +0100
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: [PATCH] Use pthread_self instead of thr_self on BSD
Content-Type: multipart/mixed;
 boundary="------------000002040100040905010006"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000002040100040905010006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch uses pthread_self to get the thread ID instead of the 
non-POSIX thr_self This fixes a compiler warning on FreeBSD.

-- 
Bruce Cran

--------------000002040100040905010006
Content-Type: text/plain;
 name="fio.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fio.diff"

ZGlmZiAtLWdpdCBhL29zL29zLWZyZWVic2QuaCBiL29zL29zLWZyZWVic2QuaA0KaW5kZXgg
ZmFkMDUxZi4uOWRhNzkyZSAxMDA2NDQNCi0tLSBhL29zL29zLWZyZWVic2QuaA0KKysrIGIv
b3Mvb3MtZnJlZWJzZC5oDQpAQCAtMiw2ICsyLDcgQEANCiAjZGVmaW5lIEZJT19PU19GUkVF
QlNEX0gNCg0KICNpbmNsdWRlIDxlcnJuby5oPg0KKyNpbmNsdWRlIDxwdGhyZWFkLmg+DQog
I2luY2x1ZGUgPHN5cy9zeXNjdGwuaD4NCiAjaW5jbHVkZSA8c3lzL2Rpc2suaD4NCg0KQEAg
LTU0LDEwICs1NSw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBsb25nIG9zX3Bo
eXNfbWVtKHZvaWQpDQoNCiBzdGF0aWMgaW5saW5lIGludCBnZXR0aWQodm9pZCkNCiB7DQot
ICAgICAgIGxvbmcgbHdwaWQ7DQotDQotICAgICAgIHRocl9zZWxmKCZsd3BpZCk7DQotICAg
ICAgIHJldHVybiAoaW50KSBsd3BpZDsNCisgICAgICAgcmV0dXJuIChpbnQpIHB0aHJlYWRf
c2VsZigpOw0KIH0NCg0KICNpZmRlZiBNQURWX0ZSRUUNCmRpZmYgLS1naXQgYS9vcy9vcy1u
ZXRic2QuaCBiL29zL29zLW5ldGJzZC5oDQppbmRleCA3ZjVmNDg0Li5jNGE5MjNmIDEwMDY0
NA0KLS0tIGEvb3Mvb3MtbmV0YnNkLmgNCisrKyBiL29zL29zLW5ldGJzZC5oDQpAQCAtMiw2
ICsyLDcgQEANCiAjZGVmaW5lIEZJT19PU19ORVRCU0RfSA0KDQogI2luY2x1ZGUgPGVycm5v
Lmg+DQorI2luY2x1ZGUgPHB0aHJlYWQuaD4NCiAjaW5jbHVkZSA8c3lzL3BhcmFtLmg+DQog
LyogWFhYIGhhY2sgdG8gYXZvaWQgY29uZmlsY3RzIGJldHdlZW4gcmJ0cmVlLmggYW5kIDxz
eXMvcmIuaD4gKi8NCiAjZGVmaW5lICAgICAgICByYl9ub2RlIF9yYl9ub2RlDQpAQCAtNDgs
MTAgKzQ5LDcgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGxvbmcgb3NfcGh5c19t
ZW0odm9pZCkNCg0KIHN0YXRpYyBpbmxpbmUgaW50IGdldHRpZCh2b2lkKQ0KIHsNCi0gICAg
ICAgbG9uZyBsd3BpZDsNCi0NCi0gICAgICAgdGhyX3NlbGYoJmx3cGlkKTsNCi0gICAgICAg
cmV0dXJuIChpbnQpIGx3cGlkOw0KKyAgICAgICByZXR1cm4gKGludCkgcHRocmVhZF9zZWxm
KCk7DQogfQ0KDQogI2lmZGVmIE1BRFZfRlJFRQ==
--------------000002040100040905010006--


