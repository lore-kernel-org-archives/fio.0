Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34375 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbcAKOD2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Jan 2016 09:03:28 -0500
Received: by mail-lb0-f170.google.com with SMTP id cl12so37163181lbc.1
        for <fio@vger.kernel.org>; Mon, 11 Jan 2016 06:03:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADr68Wam45zdOL_d_4PPAZ-O8nfuoVxHDHnPUkCYqSd720FwYA@mail.gmail.com>
References: <CADr68WZJ0+r4M5WArqvRkHHTAj=uLg8bi8xmGr+mMJ=KamQ+UQ@mail.gmail.com>
	<CADr68Wam45zdOL_d_4PPAZ-O8nfuoVxHDHnPUkCYqSd720FwYA@mail.gmail.com>
Date: Mon, 11 Jan 2016 15:03:26 +0100
Message-ID: <CADr68WaLSogc_a9PptZ0Q7MeG3Dhnp4QDAfbFzAOeykQNzj37A@mail.gmail.com>
Subject: Re: engine rbd broken after commit 2466096336bd0fbc1a94811aa338926af6baf42f
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Content-Type: multipart/mixed; boundary=001a1134c436a1905305290f6624
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

--001a1134c436a1905305290f6624
Content-Type: text/plain; charset=UTF-8

2016-01-11 12:09 GMT+01:00 Jens Rosenboom <j.rosenboom@x-ion.de>:
> 2016-01-08 12:15 GMT+01:00 Jens Rosenboom <j.rosenboom@x-ion.de>:
>> When running fio-2.3 with the rbd engine, the tests themselves run
>> fine, but instead of the results being printed, I get:
>>
>> fio: mutex.c:163: fio_mutex_down: Assertion `mutex->magic ==
>> 0x4d555445U' failed.
>>
>> The command I am using is
>>
>> fio --ioengine=rbd --clientname=admin --pool=test --rbdname=test1
>> --rw=randwrite --runtime=10 --ramp_time=None --numjobs=1 --direct=1
>> --bs=1048576B --iodepth=64 --name=test1
>>
>> If I instead use another engine, everything is fine, e.g.:
>>
>> fio --ioengine=libaio --filename=/dev/sdb1 --rw=randwrite --runtime=10
>> --ramp_time=None --numjobs=1 --direct=1 --bs=1048576B --iodepth=64
>> --name=test1
>>
>> Going back to fio-2.2.13 makes the error go away and running a git
>> bisect leads to the commit mentioned in the subject as the culprit,
>> the error turns into a Segmentation Fault at that point, though.
>
> Accidentally I found out that I can also reproduce the bug with libaio if I set
>
> LD_PRELOAD=../jemalloc/lib/libjemalloc.so
>
> compiled from https://github.com/jemalloc/jemalloc.git (tested with
> 3.6.0 and 4.0.4)
>
> So it seems there is some use-after-free issue in this commit. I'll
> try to dig into this a bit more when I get the time, but I won't be
> sad if someone else is faster. ;)

In the standalone case, sk_out_key is used uninitialized, which may
happen to work fine until some other library also uses a pthread_key,
like it seems both librbd and libjemalloc do.

Attached is a patch that fixes this.

--001a1134c436a1905305290f6624
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-Don-t-use-uninitialized-pthread_key.patch"
Content-Disposition: attachment; 
	filename="0001-Don-t-use-uninitialized-pthread_key.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ija1h3yl0

RnJvbSBmZDRmMmRmMzI0M2IyMTU2MjJmYzM1ZWQ3YzE3NWM5ZTZjMGQxZjYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIFJvc2VuYm9vbSA8ai5yb3NlbmJvb21AeC1pb24uZGU+
CkRhdGU6IE1vbiwgMTEgSmFuIDIwMTYgMTQ6NDE6NDEgKzAxMDAKU3ViamVjdDogW1BBVENIXSBE
b24ndCB1c2UgdW5pbml0aWFsaXplZCBwdGhyZWFkX2tleQoKV2hlbiBydW5uaW5nIHN0YW5kYWxv
bmUgaW5zdGVhZCBvZiBhcyBhIHNlcnZlciwgc2tfb3V0X2tleSBkb2Vzbid0IGdldAppbml0aWFs
aXplZCwgYnV0IHN0aWxsIHdpbGwgYmUgcmVmZXJlbmNlZCBsYXRlcm9uLCB3aGljaCBhY2NvcmRp
bmcgdG8KUE9TSVggaXMgdW5zcGVjaWZpZWQuCgpTaWduZWQtb2ZmLWJ5OiBKZW5zIFJvc2VuYm9v
bSA8ai5yb3NlbmJvb21AeC1pb24uZGU+Ci0tLQogZmlvLmMgICAgfCAgNiArKysrLS0KIHNlcnZl
ci5jIHwgMTQgKysrKysrKysrKy0tLS0KIHNlcnZlci5oIHwgIDIgKy0KIDMgZmlsZXMgY2hhbmdl
ZCwgMTUgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9maW8uYyBi
L2Zpby5jCmluZGV4IGJkM2UyNjAuLmQ1OWM1NjcgMTAwNjQ0Ci0tLSBhL2Zpby5jCisrKyBiL2Zp
by5jCkBAIC01Niw4ICs1NiwxMCBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdLCBj
aGFyICplbnZwW10pCiAJCWlmIChmaW9fc3RhcnRfYWxsX2NsaWVudHMoKSkKIAkJCWdvdG8gZG9u
ZTsKIAkJcmV0ID0gZmlvX2hhbmRsZV9jbGllbnRzKCZmaW9fY2xpZW50X29wcyk7Ci0JfSBlbHNl
Ci0JCXJldCA9IGZpb19iYWNrZW5kKE5VTEwpOworCX0gZWxzZSB7CisJCWlmICghc2VydmVyX2Ny
ZWF0ZV9za19vdXRfa2V5KCkpCisJCQlyZXQgPSBmaW9fYmFja2VuZChOVUxMKTsKKwl9CiAKIGRv
bmU6CiAJZGVpbml0aWFsaXplX2ZpbygpOwpkaWZmIC0tZ2l0IGEvc2VydmVyLmMgYi9zZXJ2ZXIu
YwppbmRleCBlY2NkOWQzLi44NTE3NGMyIDEwMDY0NAotLS0gYS9zZXJ2ZXIuYworKysgYi9zZXJ2
ZXIuYwpAQCAtMjE4NiwxNyArMjE4NiwyMyBAQCBzdGF0aWMgdm9pZCBzZXRfc2lnX2hhbmRsZXJz
KHZvaWQpCiAJc2lnYWN0aW9uKFNJR0lOVCwgJmFjdCwgTlVMTCk7CiB9CiAKLXN0YXRpYyBpbnQg
ZmlvX3NlcnZlcih2b2lkKQotewotCWludCBzaywgcmV0OwotCitpbnQgc2VydmVyX2NyZWF0ZV9z
a19vdXRfa2V5KHZvaWQpIHsKIAlpZiAocHRocmVhZF9rZXlfY3JlYXRlKCZza19vdXRfa2V5LCBO
VUxMKSkgewogCQlsb2dfZXJyKCJmaW86IGNhbid0IGNyZWF0ZSBza19vdXQgYmFja2VuZCBrZXlc
biIpOwogCQlyZXR1cm4gLTE7CiAJfQogCiAJcHRocmVhZF9zZXRzcGVjaWZpYyhza19vdXRfa2V5
LCBOVUxMKTsKKwlyZXR1cm4gMDsKK30KIAorc3RhdGljIGludCBmaW9fc2VydmVyKHZvaWQpCit7
CisJaW50IHNrLCByZXQ7CisKKworCWlmIChzZXJ2ZXJfY3JlYXRlX3NrX291dF9rZXkoKSkKKwkJ
cmV0dXJuIC0xOwogCWRwcmludChGRF9ORVQsICJzdGFydGluZyBzZXJ2ZXJcbiIpOwogCiAJaWYg
KGZpb19oYW5kbGVfc2VydmVyX2FyZygpKQpkaWZmIC0tZ2l0IGEvc2VydmVyLmggYi9zZXJ2ZXIu
aAppbmRleCA5MjA1YWU2Li4zYWU1NWQ0IDEwMDY0NAotLS0gYS9zZXJ2ZXIuaAorKysgYi9zZXJ2
ZXIuaApAQCAtMjIyLDUgKzIyMiw1IEBAIGV4dGVybiBpbnQgZmlvX25ldF9zZW5kX3F1aXQoaW50
IHNrKTsKIAogZXh0ZXJuIGludCBleGl0X2JhY2tlbmQ7CiBleHRlcm4gaW50IGZpb19uZXRfcG9y
dDsKLQorZXh0ZXJuIGludCBzZXJ2ZXJfY3JlYXRlX3NrX291dF9rZXkodm9pZCk7CiAjZW5kaWYK
LS0gCjIuNC4xMAoK
--001a1134c436a1905305290f6624--
