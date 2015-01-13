Return-Path: <yo-satoh@sios.com>
MIME-Version: 1.0
In-Reply-To: <54B45DAB.7060406@kernel.dk>
References: <CAL_XjKXUkmDm2kVn3b-PEuRjFP9gyx6hCorVADkUAcfcYM4=BA@mail.gmail.com>
 <54B45DAB.7060406@kernel.dk>
From: Yoshinori Sato <yo-satoh@sios.com>
Date: Tue, 13 Jan 2015 13:51:52 +0900
Message-ID: <CAL_XjKUwK6RTDjSesXDTVWUyxmr_z3aODOAGL7Z-j-3LwpMhfw@mail.gmail.com>
Subject: Re: [PATCH] mmap backend broken
Content-Type: multipart/mixed; boundary=001a11c174b0e751ba050c8162ae
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--001a11c174b0e751ba050c8162ae
Content-Type: text/plain; charset=UTF-8

Oh. Sorry
Attached it.

Thanks.

2015-01-13 8:50 GMT+09:00 Jens Axboe <axboe@kernel.dk>:
> On 01/06/2015 08:30 PM, Yoshinori Sato wrote:
>> Program received signal SIGSEGV, Segmentation fault.
>> 0x00000000004345c2 in fio_mmapio_invalidate (td=0x7fffeed6e790,
>>     f=0x7ffff75dc3d0) at engines/mmap.c:260
>> warning: Source file is more recent than executable.
>> 260 static struct ioengine_ops ioengine = {
>> (gdb) bt
>> #0  0x00000000004345c2 in fio_mmapio_invalidate (td=0x7fffeed6e790,
>>     f=0x7ffff75dc3d0) at engines/mmap.c:260
>> #1  0x000000000041b1da in __file_invalidate_cache (td=0x7fffeed6e790,
>>     f=0x7ffff75dc3d0, off=0, len=1456128) at filesetup.c:402
>> #2  0x000000000041c465 in setup_files (td=0x7fffeed6e790) at filesetup.c:924
>> #3  0x0000000000443d7a in run_threads () at backend.c:1892
>> #4  fio_backend () at backend.c:2197
>> #5  0x0000003506a1ed1d in __libc_start_main (main=0x453980 <main>, argc=2,
>>     ubp_av=0x7fffffffe228, init=<value optimized out>,
>>     fini=<value optimized out>, rtld_fini=<value optimized out>,
>>     stack_end=0x7fffffffe218) at libc-start.c:226
>> #6  0x000000000040aa19 in _start ()
>
> Oops thanks, your patch looks correct, but unfortunately it's garbled in
> the mailer. Can you resend it attached?
>
> --
> Jens Axboe
>

--001a11c174b0e751ba050c8162ae
Content-Type: application/octet-stream; 
	name="0001-mmap-backend-invalidate-fix.patch"
Content-Disposition: attachment; 
	filename="0001-mmap-backend-invalidate-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i4usyc2f0

RnJvbSAwYTMzNmFmMDM1ZDQyYWUzYzYzYWI0YmQwM2I1ZjI3YmYwY2M5YTlkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb3NoaW5vcmkgU2F0byA8eW8tc2F0b2hAc2lvcy5jb20+CkRh
dGU6IFdlZCwgNyBKYW4gMjAxNSAxMjoxNjozNiArMDkwMApTdWJqZWN0OiBbUEFUQ0hdIG1tYXAg
YmFja2VuZCBpbnZhbGlkYXRlIGZpeAoKbWFkdmljZSBiZWZvcmUgbW1hcC4gbW92ZWQgbGF0ZXIu
CgpTaWduZWQtb2ZmLWJ5IFlvc2hpbm9yaSBTYXRvIDx5by1zYXRvaEBzaW9zLmNvbT4KLS0tCiBl
bmdpbmVzL21tYXAuYyB8IDI1ICsrKysrKysrKystLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFu
Z2VkLCAxMCBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9lbmdp
bmVzL21tYXAuYyBiL2VuZ2luZXMvbW1hcC5jCmluZGV4IDhiY2Q0MmMuLjY5YWRkNzggMTAwNjQ0
Ci0tLSBhL2VuZ2luZXMvbW1hcC5jCisrKyBiL2VuZ2luZXMvbW1hcC5jCkBAIC02Miw2ICs2Miwx
NiBAQCBzdGF0aWMgaW50IGZpb19tbWFwX2ZpbGUoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwgc3Ry
dWN0IGZpb19maWxlICpmLAogCQkJZ290byBlcnI7CiAJCX0KIAl9CisJaWYgKHBvc2l4X21hZHZp
c2UoZm1kLT5tbWFwX3B0ciwgbGVuZ3RoLCBQT1NJWF9NQURWX0RPTlRORUVEKSA8IDApIHsKKwkJ
dGRfdmVycm9yKHRkLCBlcnJubywgIm1hZHZpc2UiKTsKKwkJZ290byBlcnI7CisJfQorCisjaWZk
ZWYgRklPX01BRFZfRlJFRQorCWlmIChmLT5maWxldHlwZSA9PSBGSU9fVFlQRV9CRCkKKwkJKHZv
aWQpIHBvc2l4X21hZHZpc2UoZm1kLT5tbWFwX3B0ciwgZm1kLT5tbWFwX3N6LCBGSU9fTUFEVl9G
UkVFKTsKKyNlbmRpZgorCiAKIGVycjoKIAlpZiAodGQtPmVycm9yICYmIGZtZC0+bW1hcF9wdHIp
CkBAIC0yNTIsMjAgKzI2Miw2IEBAIHN0YXRpYyBpbnQgZmlvX21tYXBpb19jbG9zZV9maWxlKHN0
cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdCBmaW9fZmlsZSAqZikKIAlyZXR1cm4gZ2VuZXJp
Y19jbG9zZV9maWxlKHRkLCBmKTsKIH0KIAotc3RhdGljIGludCBmaW9fbW1hcGlvX2ludmFsaWRh
dGUoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwgc3RydWN0IGZpb19maWxlICpmKQotewotCXN0cnVj
dCBmaW9fbW1hcF9kYXRhICpmbWQgPSBGSUxFX0VOR19EQVRBKGYpOwotCWludCByZXQ7Ci0KLQly
ZXQgPSBwb3NpeF9tYWR2aXNlKGZtZC0+bW1hcF9wdHIsIGZtZC0+bW1hcF9zeiwgUE9TSVhfTUFE
Vl9ET05UTkVFRCk7Ci0jaWZkZWYgRklPX01BRFZfRlJFRQotCWlmIChmLT5maWxldHlwZSA9PSBG
SU9fVFlQRV9CRCkKLQkJKHZvaWQpIHBvc2l4X21hZHZpc2UoZm1kLT5tbWFwX3B0ciwgZm1kLT5t
bWFwX3N6LCBGSU9fTUFEVl9GUkVFKTsKLSNlbmRpZgotCi0JcmV0dXJuIHJldDsKLX0KLQogc3Rh
dGljIHN0cnVjdCBpb2VuZ2luZV9vcHMgaW9lbmdpbmUgPSB7CiAJLm5hbWUJCT0gIm1tYXAiLAog
CS52ZXJzaW9uCT0gRklPX0lPT1BTX1ZFUlNJT04sCkBAIC0yNzQsNyArMjcwLDYgQEAgc3RhdGlj
IHN0cnVjdCBpb2VuZ2luZV9vcHMgaW9lbmdpbmUgPSB7CiAJLnF1ZXVlCQk9IGZpb19tbWFwaW9f
cXVldWUsCiAJLm9wZW5fZmlsZQk9IGZpb19tbWFwaW9fb3Blbl9maWxlLAogCS5jbG9zZV9maWxl
CT0gZmlvX21tYXBpb19jbG9zZV9maWxlLAotCS5pbnZhbGlkYXRlCT0gZmlvX21tYXBpb19pbnZh
bGlkYXRlLAogCS5nZXRfZmlsZV9zaXplCT0gZ2VuZXJpY19nZXRfZmlsZV9zaXplLAogCS5mbGFn
cwkJPSBGSU9fU1lOQ0lPIHwgRklPX05PRVhURU5ELAogfTsKLS0gCjEuNy4xMi40Cgo=
--001a11c174b0e751ba050c8162ae--

