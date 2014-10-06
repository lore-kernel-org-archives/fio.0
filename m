Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57132 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJFXCo (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Oct 2014 19:02:44 -0400
Received: by mail-ob0-f180.google.com with SMTP id va2so4694384obc.25
        for <fio@vger.kernel.org>; Mon, 06 Oct 2014 16:02:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <543318E1.2070701@cran.org.uk>
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>
	<543318E1.2070701@cran.org.uk>
Date: Mon, 6 Oct 2014 18:02:43 -0500
Message-ID: <CADzpL0Sqn7fC5MNBYViR7mLP4HFHnO98pf=VnWiS6PhicsRejg@mail.gmail.com>
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
From: Stephen Cameron <stephenmcameron@gmail.com>
Content-Type: multipart/mixed; boundary=047d7b2e41d893b4210504c91480
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

--047d7b2e41d893b4210504c91480
Content-Type: text/plain; charset=UTF-8

On Mon, Oct 6, 2014 at 5:34 PM, Bruce Cran <bruce@cran.org.uk> wrote:
> On 10/6/2014 3:44 PM, Stephen Cameron wrote:
>>
>> I suspect that your version of yacc does not comprehend the --no-lines
>> option (which we needed only in order to avoid a bug in some other
>> versions of yacc).  From the usage message it does appear to
>> understand both -d and -l though.
>>
>> Try changing the --no-lines option in the Makefile to -l instead, and
>> see if that helps.
>
>
> The same problem occurs on FreeBSD 10. After changing "--no-lines" to "-l"
> the build works, with the following warnings:
>
>   YACC y.tab.c
>     CC lex.yy.o
> lex.yy.c:1245:3: warning: incompatible pointer types passing 'yy_size_t *'
> (aka 'unsigned long *') to parameter of type 'int *'
> [-Wincompatible-pointer-types]
>                 YY_INPUT(
> (&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> exp/expression-parser.l:31:25: note: expanded from macro 'YY_INPUT'
>                 lexer_input((buffer), &(bytes_read), (bytes_requested))
>                                       ^~~~~~~~~~~~~
> exp/expression-parser.l:27:43: note: passing argument to parameter 'nbytes'
> here
> extern int lexer_input(char* buffer, int *nbytes, int buffersize);
>

I think Jens mentioned seeing something similar on Mac OSX (which
makes sense as it's a BSD derivative).  I think it will work so long
as sizeof(int) <= sizeof(unsigned long) and you're on a little endian
architecture and the buffer is not ridiculously huge.  I suspect on a
big endian arch where sizeof(long) > sizeof(int), it would fail.

Can you see if the attached patch fixes it?

-- steve

--047d7b2e41d893b4210504c91480
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-fix-problem-with-yy_size_t-vs-int-param-to-lexer_inp.patch"
Content-Disposition: attachment; 
	filename="0001-fix-problem-with-yy_size_t-vs-int-param-to-lexer_inp.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i0yfb6hq0

RnJvbSA1YTc2YjdmNDQxODNjNjVhZmQ3YWY5ZDU3ODcyOTk2NWMzYmE4ZTc1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiU3RlcGhlbiBNLiBDYW1lcm9uIiA8c3RlcGhlbm1jYW1lcm9u
QGdtYWlsLmNvbT4KRGF0ZTogTW9uLCA2IE9jdCAyMDE0IDE3OjU4OjMyIC0wNTAwClN1YmplY3Q6
IFtQQVRDSF0gZml4IHByb2JsZW0gd2l0aCB5eV9zaXplX3QgdnMgaW50IHBhcmFtIHRvIGxleGVy
X2lucHV0CgpCU0QgeWFjYyB1c2VzICJpbnQiIGZvciB0aGlzIHBhcmFtLCBsaW51eCB1c2VzIHNp
emVfdAotLS0KIE1ha2VmaWxlICAgICAgICAgICAgICAgIHwgICAgNCArKystCiBleHAvZXhwcmVz
c2lvbi1wYXJzZXIueSB8ICAgIDQgKysrLQogMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUgYi9NYWtlZmlsZQppbmRl
eCBkNzM1ZWM3Li40MjRhMTEyIDEwMDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtlZmlsZQpA
QCAtMjY4LDcgKzI2OCw3IEBAIG92ZXJyaWRlIENGTEFHUyArPSAtREZJT19WRVJTSU9OPSciJChG
SU9fVkVSU0lPTikiJwogCiBpZmRlZiBDT05GSUdfQVJJVEhNRVRJQwogbGV4Lnl5LmM6IGV4cC9l
eHByZXNzaW9uLXBhcnNlci5sCi0JJChRVUlFVF9MRVgpJChMRVgpIGV4cC9leHByZXNzaW9uLXBh
cnNlci5sCisJJChRVUlFVF9MRVgpJChMRVgpIC0taGVhZGVyLWZpbGU9bGV4ZXIuaCBleHAvZXhw
cmVzc2lvbi1wYXJzZXIubAogCiBsZXgueXkubzogbGV4Lnl5LmMgeS50YWIuaAogCSQoUVVJRVRf
Q0MpJChDQykgLW8gJEAgJChDRkxBR1MpICQoQ1BQRkxBR1MpIC1jICQ8CkBAIC0yODEsNiArMjgx
LDggQEAgeS50YWIuYzogZXhwL2V4cHJlc3Npb24tcGFyc2VyLnkKIAogeS50YWIuaDogeS50YWIu
YwogCitsZXhlci5oOiBsZXgueXkuYworCiBleHAvdGVzdC1leHByZXNzaW9uLXBhcnNlci5vOiBl
eHAvdGVzdC1leHByZXNzaW9uLXBhcnNlci5jCiAJJChRVUlFVF9DQykkKENDKSAtbyAkQCAkKENG
TEFHUykgJChDUFBGTEFHUykgLWMgJDwKIGV4cC90ZXN0LWV4cHJlc3Npb24tcGFyc2VyOiBleHAv
dGVzdC1leHByZXNzaW9uLXBhcnNlci5vCmRpZmYgLS1naXQgYS9leHAvZXhwcmVzc2lvbi1wYXJz
ZXIueSBiL2V4cC9leHByZXNzaW9uLXBhcnNlci55CmluZGV4IGU0MzczZDQuLjgzYjViMzAgMTAw
NjQ0Ci0tLSBhL2V4cC9leHByZXNzaW9uLXBhcnNlci55CisrKyBiL2V4cC9leHByZXNzaW9uLXBh
cnNlci55CkBAIC0yMSw2ICsyMSw4IEBACiAjaW5jbHVkZSA8c3RkaW8uaD4KICNpbmNsdWRlIDxz
dHJpbmcuaD4KICNpbmNsdWRlIDxtYXRoLmg+CisjaW5jbHVkZSAibGV4ZXIuaCIKKwogc3RydWN0
IHBhcnNlcl92YWx1ZV90eXBlIHsKIAlkb3VibGUgZHZhbDsKIAlsb25nIGxvbmcgaXZhbDsKQEAg
LTE4Niw3ICsxODgsNyBAQCBleHByZXNzaW9uOglleHByZXNzaW9uICcrJyBleHByZXNzaW9uIHsK
IHN0YXRpYyBpbnQgbGV4ZXJfcmVhZF9vZmZzZXQgPSAwOwogc3RhdGljIGNoYXIgbGV4ZXJfaW5w
dXRfYnVmZmVyWzEwMDBdOwogCi1pbnQgbGV4ZXJfaW5wdXQoY2hhciogYnVmZmVyLCBpbnQgKmJ5
dGVzX3JlYWQsIGludCBieXRlc19yZXF1ZXN0ZWQpCitpbnQgbGV4ZXJfaW5wdXQoY2hhciogYnVm
ZmVyLCB5eV9zaXplX3QgKmJ5dGVzX3JlYWQsIGludCBieXRlc19yZXF1ZXN0ZWQpCiB7CiAJaW50
IGJ5dGVzX2xlZnQgPSBzdHJsZW4obGV4ZXJfaW5wdXRfYnVmZmVyKSAtIGxleGVyX3JlYWRfb2Zm
c2V0OwogCi0tIAoxLjcuOS41Cgo=
--047d7b2e41d893b4210504c91480--
