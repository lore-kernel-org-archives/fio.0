Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:65165 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaJ0K0F (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Oct 2014 06:26:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAM9_UU_S7qhenZW34Lw3r=RHoVa1__610RRsFScgt0adi1dpFw@mail.gmail.com>
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk>
 <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com>
 <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz>
 <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz>
 <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk>
 <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk>
 <544C2371.1020403@catalyst.net.nz> <CAM9_UU_S7qhenZW34Lw3r=RHoVa1__610RRsFScgt0adi1dpFw@mail.gmail.com>
From: Ketor D <d.ketor@gmail.com>
Date: Mon, 27 Oct 2014 18:25:32 +0800
Message-ID: <CAM9_UU8X7xVst+OR0__POkaXY6eG=D4_uiWK1T_iTFNJkRo3Gg@mail.gmail.com>
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
Content-Type: multipart/mixed; boundary=089e01227a2a3214d2050664f5b4
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>
Cc: Jens Axboe <axboe@kernel.dk>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>

--089e01227a2a3214d2050664f5b4
Content-Type: text/plain; charset=UTF-8

Hi Jens:
      After debug the v3 patch, I found there is a bug in the patch.
      On the first fio_rbd_getevents loop, the fri->io_seen is set to
1, and this variable never set to 0 again. So the program get into
endless loop in such code:

do {
this_events = rbd_iter_events(td, &events, min, wait);

if (events >= min)
break;
if (this_events)
continue;

wait = 1;
} while (1);

this_events and events always be 0, because the fri->io_seen is always
1, so no events can be getted.

The Bug fix is:
in the function _fio_rbd_finish_read_aiocb,
_fio_rbd_finish_write_aiocb and _fio_rbd_finish_sync_aiocb add
"fio_rbd_iou->io_seen = 0;" after "fio_rbd_iou->io_complete = 1;".


The attchment is the new patch.

2014-10-27 17:27 GMT+08:00 Ketor D <d.ketor@gmail.com>:
> Hi, Jens:
>           I have test your v2 and v3 patch.
>           The v2 patch get SIGABT and crash. The v3 patch hang.
>
>          Why not simply comment usleep?
>
>
> 2014-10-26 6:25 GMT+08:00 Mark Kirkwood <mark.kirkwood@catalyst.net.nz>:
>>
>> On 26/10/14 08:20, Jens Axboe wrote:
>>>
>>> On 10/24/2014 10:50 PM, Mark Kirkwood wrote:
>>>>
>>>> On 25/10/14 16:47, Jens Axboe wrote:
>>>>>
>>>>>
>>>>> Since you're running rbd tests... Mind giving this patch a go? I don't
>>>>> have an easy way to test it myself. It has nothing to do with this
>>>>> issue, it's just a potentially faster way to do the rbd completions.
>>>>>
>>>>
>>>> Sure - but note I'm testing this on my i7 workstation (4x osd's running
>>>> on 2x Crucial M550) so not exactly server grade :-)
>>>>
>>>> With that in mind, I'm seeing slightly *slower* performance with the
>>>> patch applied: e.g: for 128k blocks - 2 runs, 1 uncached and the next
>>>> cached.
>>>
>>>
>>> Yeah, that doesn't look good. Mind trying this one out? I wonder if we
>>> doubly wait on them - or perhaps rbd_aio_wait_for_complete() isn't
>>> working correctly. If you try this one, we should know more...
>>>
>>> Goal is, I want to get rid of that usleep() in getevents.
>>>
>>
>> Testing with v3 patch applied hangs. I did wonder if we had somehow hit a
>> new variant of the cache issue - so reran with it disabled in ceph.conf.
>> Result is the same:
>>
>> $ fio read-test.fio
>> rbd_thread: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K,
>> ioengine=rbd, iodepth=32
>> fio-2.1.13-88-gb2ee7
>> Starting 1 process
>> rbd engine: RBD version: 0.1.8
>> Jobs: 1 (f=1): [R(1)] [0.1% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
>> 01h:25m:15s]
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--089e01227a2a3214d2050664f5b4
Content-Type: application/octet-stream; name="rbd-comp-v4.patch"
Content-Disposition: attachment; filename="rbd-comp-v4.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1rojnr50

ZGlmZiAtLWdpdCBhL2VuZ2luZXMvcmJkLmMgYi9lbmdpbmVzL3JiZC5jCmluZGV4IDZmZTg3Yjgu
LjNmZDgxNWMgMTAwNjQ0Ci0tLSBhL2VuZ2luZXMvcmJkLmMKKysrIGIvZW5naW5lcy9yYmQuYwpA
QCAtMTEsNyArMTEsOSBAQAogCiBzdHJ1Y3QgZmlvX3JiZF9pb3UgewogCXN0cnVjdCBpb191ICpp
b191OworCXJiZF9jb21wbGV0aW9uX3QgY29tcGxldGlvbjsKIAlpbnQgaW9fY29tcGxldGU7CisJ
aW50IGlvX3NlZW47CiB9OwogCiBzdHJ1Y3QgcmJkX2RhdGEgewpAQCAtMTcwLDYgKzE3Miw3IEBA
IHN0YXRpYyB2b2lkIF9maW9fcmJkX2ZpbmlzaF93cml0ZV9haW9jYihyYmRfY29tcGxldGlvbl90
IGNvbXAsIHZvaWQgKmRhdGEpCiAJICAgIChzdHJ1Y3QgZmlvX3JiZF9pb3UgKilpb191LT5lbmdp
bmVfZGF0YTsKIAogCWZpb19yYmRfaW91LT5pb19jb21wbGV0ZSA9IDE7CisJZmlvX3JiZF9pb3Ut
PmlvX3NlZW4gPSAwOwogCiAJLyogaWYgd3JpdGUgbmVlZHMgdG8gYmUgdmVyaWZpZWQgLSB3ZSBz
aG91bGQgbm90IHJlbGVhc2UgY29tcCBoZXJlCiAJICAgd2l0aG91dCBmZXRjaGluZyB0aGUgcmVz
dWx0ICovCkBAIC0xODcsNiArMTkwLDcgQEAgc3RhdGljIHZvaWQgX2Zpb19yYmRfZmluaXNoX3Jl
YWRfYWlvY2IocmJkX2NvbXBsZXRpb25fdCBjb21wLCB2b2lkICpkYXRhKQogCSAgICAoc3RydWN0
IGZpb19yYmRfaW91ICopaW9fdS0+ZW5naW5lX2RhdGE7CiAKIAlmaW9fcmJkX2lvdS0+aW9fY29t
cGxldGUgPSAxOworCWZpb19yYmRfaW91LT5pb19zZWVuID0gMDsKIAogCS8qIGlmIHJlYWQgbmVl
ZHMgdG8gYmUgdmVyaWZpZWQgLSB3ZSBzaG91bGQgbm90IHJlbGVhc2UgY29tcCBoZXJlCiAJICAg
d2l0aG91dCBmZXRjaGluZyB0aGUgcmVzdWx0ICovCkBAIC0yMDQsNiArMjA4LDcgQEAgc3RhdGlj
IHZvaWQgX2Zpb19yYmRfZmluaXNoX3N5bmNfYWlvY2IocmJkX2NvbXBsZXRpb25fdCBjb21wLCB2
b2lkICpkYXRhKQogCSAgICAoc3RydWN0IGZpb19yYmRfaW91ICopaW9fdS0+ZW5naW5lX2RhdGE7
CiAKIAlmaW9fcmJkX2lvdS0+aW9fY29tcGxldGUgPSAxOworCWZpb19yYmRfaW91LT5pb19zZWVu
ID0gMDsKIAogCS8qIGlmIHN5bmMgbmVlZHMgdG8gYmUgdmVyaWZpZWQgLSB3ZSBzaG91bGQgbm90
IHJlbGVhc2UgY29tcCBoZXJlCiAJICAgd2l0aG91dCBmZXRjaGluZyB0aGUgcmVzdWx0ICovCkBA
IC0yMjEsMzQgKzIyNiw3MCBAQCBzdGF0aWMgc3RydWN0IGlvX3UgKmZpb19yYmRfZXZlbnQoc3Ry
dWN0IHRocmVhZF9kYXRhICp0ZCwgaW50IGV2ZW50KQogCXJldHVybiByYmRfZGF0YS0+YWlvX2V2
ZW50c1tldmVudF07CiB9CiAKLXN0YXRpYyBpbnQgZmlvX3JiZF9nZXRldmVudHMoc3RydWN0IHRo
cmVhZF9kYXRhICp0ZCwgdW5zaWduZWQgaW50IG1pbiwKLQkJCSAgICAgdW5zaWduZWQgaW50IG1h
eCwgY29uc3Qgc3RydWN0IHRpbWVzcGVjICp0KQorc3RhdGljIGlubGluZSBpbnQgZnJpX2NoZWNr
X2NvbXBsZXRlKHN0cnVjdCByYmRfZGF0YSAqcmJkX2RhdGEsCisJCQkJICAgICBzdHJ1Y3QgaW9f
dSAqaW9fdSwKKwkJCQkgICAgIHVuc2lnbmVkIGludCAqZXZlbnRzKQoreworCXN0cnVjdCBmaW9f
cmJkX2lvdSAqZnJpID0gaW9fdS0+ZW5naW5lX2RhdGE7CisKKwlpZiAoZnJpLT5pb19jb21wbGV0
ZSkgeworCQlmcmktPmlvX2NvbXBsZXRlID0gMDsKKwkJZnJpLT5pb19zZWVuID0gMTsKKwkJcmJk
X2RhdGEtPmFpb19ldmVudHNbKmV2ZW50c10gPSBpb191OworCQkoKmV2ZW50cykrKzsKKwkJcmV0
dXJuIDE7CisJfQorCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgcmJkX2l0ZXJfZXZlbnRz
KHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHVuc2lnbmVkIGludCAqZXZlbnRzLAorCQkJICAgdW5z
aWduZWQgaW50IG1pbl9ldnRzLCBpbnQgd2FpdCkKIHsKIAlzdHJ1Y3QgcmJkX2RhdGEgKnJiZF9k
YXRhID0gdGQtPmlvX29wcy0+ZGF0YTsKLQl1bnNpZ25lZCBpbnQgZXZlbnRzID0gMDsKKwl1bnNp
Z25lZCBpbnQgdGhpc19ldmVudHMgPSAwOwogCXN0cnVjdCBpb191ICppb191OwogCWludCBpOwot
CXN0cnVjdCBmaW9fcmJkX2lvdSAqZm92OwogCi0JZG8gewotCQlpb191X3FpdGVyKCZ0ZC0+aW9f
dV9hbGwsIGlvX3UsIGkpIHsKLQkJCWlmICghKGlvX3UtPmZsYWdzICYgSU9fVV9GX0ZMSUdIVCkp
Ci0JCQkJY29udGludWU7CisJaW9fdV9xaXRlcigmdGQtPmlvX3VfYWxsLCBpb191LCBpKSB7CisJ
CXN0cnVjdCBmaW9fcmJkX2lvdSAqZnJpID0gaW9fdS0+ZW5naW5lX2RhdGE7CiAKLQkJCWZvdiA9
IChzdHJ1Y3QgZmlvX3JiZF9pb3UgKilpb191LT5lbmdpbmVfZGF0YTsKKwkJaWYgKCEoaW9fdS0+
ZmxhZ3MgJiBJT19VX0ZfRkxJR0hUKSkKKwkJCWNvbnRpbnVlOworCQlpZiAoZnJpLT5pb19zZWVu
KQorCQkJY29udGludWU7CiAKLQkJCWlmIChmb3YtPmlvX2NvbXBsZXRlKSB7Ci0JCQkJZm92LT5p
b19jb21wbGV0ZSA9IDA7Ci0JCQkJcmJkX2RhdGEtPmFpb19ldmVudHNbZXZlbnRzXSA9IGlvX3U7
Ci0JCQkJZXZlbnRzKys7Ci0JCQl9CisJCWlmIChmcmlfY2hlY2tfY29tcGxldGUocmJkX2RhdGEs
IGlvX3UsIGV2ZW50cykpeworCQkJdGhpc19ldmVudHMrKzsKKwkJfQorCQllbHNlIGlmICh3YWl0
KSB7CisJCQlyYmRfYWlvX3dhaXRfZm9yX2NvbXBsZXRlKGZyaS0+Y29tcGxldGlvbik7CiAKKwkJ
CWlmIChmcmlfY2hlY2tfY29tcGxldGUocmJkX2RhdGEsIGlvX3UsIGV2ZW50cykpCisJCQkJdGhp
c19ldmVudHMrKzsKIAkJfQotCQlpZiAoZXZlbnRzIDwgbWluKQotCQkJdXNsZWVwKDEwMCk7Ci0J
CWVsc2UKKwkJaWYgKCpldmVudHMgPj0gbWluX2V2dHMpCisJCQlicmVhazsKKwl9CisKKwlyZXR1
cm4gdGhpc19ldmVudHM7Cit9CisKK3N0YXRpYyBpbnQgZmlvX3JiZF9nZXRldmVudHMoc3RydWN0
IHRocmVhZF9kYXRhICp0ZCwgdW5zaWduZWQgaW50IG1pbiwKKwkJCSAgICAgdW5zaWduZWQgaW50
IG1heCwgY29uc3Qgc3RydWN0IHRpbWVzcGVjICp0KQoreworCXVuc2lnbmVkIGludCB0aGlzX2V2
ZW50cywgZXZlbnRzID0gMDsKKwlpbnQgd2FpdCA9IDA7CisKKwlkbyB7CisJCXRoaXNfZXZlbnRz
ID0gcmJkX2l0ZXJfZXZlbnRzKHRkLCAmZXZlbnRzLCBtaW4sIHdhaXQpOworCisJCWlmIChldmVu
dHMgPj0gbWluKQogCQkJYnJlYWs7CisJCWlmICh0aGlzX2V2ZW50cykKKwkJCWNvbnRpbnVlOwog
CisJCXdhaXQgPSAxOwogCX0gd2hpbGUgKDEpOwogCiAJcmV0dXJuIGV2ZW50czsKQEAgLTI1OCw3
ICsyOTksNyBAQCBzdGF0aWMgaW50IGZpb19yYmRfcXVldWUoc3RydWN0IHRocmVhZF9kYXRhICp0
ZCwgc3RydWN0IGlvX3UgKmlvX3UpCiB7CiAJaW50IHIgPSAtMTsKIAlzdHJ1Y3QgcmJkX2RhdGEg
KnJiZF9kYXRhID0gdGQtPmlvX29wcy0+ZGF0YTsKLQlyYmRfY29tcGxldGlvbl90IGNvbXA7CisJ
c3RydWN0IGZpb19yYmRfaW91ICpmcmkgPSBpb191LT5lbmdpbmVfZGF0YTsKIAogCWZpb19yb19j
aGVjayh0ZCwgaW9fdSk7CiAKQEAgLTI2Niw3ICszMDcsNyBAQCBzdGF0aWMgaW50IGZpb19yYmRf
cXVldWUoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwgc3RydWN0IGlvX3UgKmlvX3UpCiAJCXIgPSBy
YmRfYWlvX2NyZWF0ZV9jb21wbGV0aW9uKGlvX3UsCiAJCQkJCSAgICAgIChyYmRfY2FsbGJhY2tf
dCkKIAkJCQkJICAgICAgX2Zpb19yYmRfZmluaXNoX3dyaXRlX2Fpb2NiLAotCQkJCQkgICAgICAm
Y29tcCk7CisJCQkJCSAgICAgICZmcmktPmNvbXBsZXRpb24pOwogCQlpZiAociA8IDApIHsKIAkJ
CWxvZ19lcnIKIAkJCSAgICAoInJiZF9haW9fY3JlYXRlX2NvbXBsZXRpb24gZm9yIERESVJfV1JJ
VEUgZmFpbGVkLlxuIik7CkBAIC0yNzQsNyArMzE1LDggQEAgc3RhdGljIGludCBmaW9fcmJkX3F1
ZXVlKHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdCBpb191ICppb191KQogCQl9CiAKIAkJ
ciA9IHJiZF9haW9fd3JpdGUocmJkX2RhdGEtPmltYWdlLCBpb191LT5vZmZzZXQsCi0JCQkJICBp
b191LT54ZmVyX2J1ZmxlbiwgaW9fdS0+eGZlcl9idWYsIGNvbXApOworCQkJCSAgaW9fdS0+eGZl
cl9idWZsZW4sIGlvX3UtPnhmZXJfYnVmLAorCQkJCSAgZnJpLT5jb21wbGV0aW9uKTsKIAkJaWYg
KHIgPCAwKSB7CiAJCQlsb2dfZXJyKCJyYmRfYWlvX3dyaXRlIGZhaWxlZC5cbiIpOwogCQkJZ290
byBmYWlsZWQ7CkBAIC0yODQsNyArMzI2LDcgQEAgc3RhdGljIGludCBmaW9fcmJkX3F1ZXVlKHN0
cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdCBpb191ICppb191KQogCQlyID0gcmJkX2Fpb19j
cmVhdGVfY29tcGxldGlvbihpb191LAogCQkJCQkgICAgICAocmJkX2NhbGxiYWNrX3QpCiAJCQkJ
CSAgICAgIF9maW9fcmJkX2ZpbmlzaF9yZWFkX2Fpb2NiLAotCQkJCQkgICAgICAmY29tcCk7CisJ
CQkJCSAgICAgICZmcmktPmNvbXBsZXRpb24pOwogCQlpZiAociA8IDApIHsKIAkJCWxvZ19lcnIK
IAkJCSAgICAoInJiZF9haW9fY3JlYXRlX2NvbXBsZXRpb24gZm9yIERESVJfUkVBRCBmYWlsZWQu
XG4iKTsKQEAgLTI5Miw3ICszMzQsOCBAQCBzdGF0aWMgaW50IGZpb19yYmRfcXVldWUoc3RydWN0
IHRocmVhZF9kYXRhICp0ZCwgc3RydWN0IGlvX3UgKmlvX3UpCiAJCX0KIAogCQlyID0gcmJkX2Fp
b19yZWFkKHJiZF9kYXRhLT5pbWFnZSwgaW9fdS0+b2Zmc2V0LAotCQkJCSBpb191LT54ZmVyX2J1
ZmxlbiwgaW9fdS0+eGZlcl9idWYsIGNvbXApOworCQkJCSBpb191LT54ZmVyX2J1ZmxlbiwgaW9f
dS0+eGZlcl9idWYsCisJCQkJIGZyaS0+Y29tcGxldGlvbik7CiAKIAkJaWYgKHIgPCAwKSB7CiAJ
CQlsb2dfZXJyKCJyYmRfYWlvX3JlYWQgZmFpbGVkLlxuIik7CkBAIC0zMDMsMTQgKzM0NiwxNCBA
QCBzdGF0aWMgaW50IGZpb19yYmRfcXVldWUoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwgc3RydWN0
IGlvX3UgKmlvX3UpCiAJCXIgPSByYmRfYWlvX2NyZWF0ZV9jb21wbGV0aW9uKGlvX3UsCiAJCQkJ
CSAgICAgIChyYmRfY2FsbGJhY2tfdCkKIAkJCQkJICAgICAgX2Zpb19yYmRfZmluaXNoX3N5bmNf
YWlvY2IsCi0JCQkJCSAgICAgICZjb21wKTsKKwkJCQkJICAgICAgJmZyaS0+Y29tcGxldGlvbik7
CiAJCWlmIChyIDwgMCkgewogCQkJbG9nX2VycgogCQkJICAgICgicmJkX2Fpb19jcmVhdGVfY29t
cGxldGlvbiBmb3IgRERJUl9TWU5DIGZhaWxlZC5cbiIpOwogCQkJZ290byBmYWlsZWQ7CiAJCX0K
IAotCQlyID0gcmJkX2Fpb19mbHVzaChyYmRfZGF0YS0+aW1hZ2UsIGNvbXApOworCQlyID0gcmJk
X2Fpb19mbHVzaChyYmRfZGF0YS0+aW1hZ2UsIGZyaS0+Y29tcGxldGlvbik7CiAJCWlmIChyIDwg
MCkgewogCQkJbG9nX2VycigicmJkX2ZsdXNoIGZhaWxlZC5cbiIpOwogCQkJZ290byBmYWlsZWQ7
CkBAIC00MzksMjIgKzQ4MiwyMSBAQCBzdGF0aWMgaW50IGZpb19yYmRfaW52YWxpZGF0ZShzdHJ1
Y3QgdGhyZWFkX2RhdGEgKnRkLCBzdHJ1Y3QgZmlvX2ZpbGUgKmYpCiAKIHN0YXRpYyB2b2lkIGZp
b19yYmRfaW9fdV9mcmVlKHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdCBpb191ICppb191
KQogewotCXN0cnVjdCBmaW9fcmJkX2lvdSAqbyA9IGlvX3UtPmVuZ2luZV9kYXRhOworCXN0cnVj
dCBmaW9fcmJkX2lvdSAqZnJpID0gaW9fdS0+ZW5naW5lX2RhdGE7CiAKLQlpZiAobykgeworCWlm
IChmcmkpIHsKIAkJaW9fdS0+ZW5naW5lX2RhdGEgPSBOVUxMOwotCQlmcmVlKG8pOworCQlmcmVl
KGZyaSk7CiAJfQogfQogCiBzdGF0aWMgaW50IGZpb19yYmRfaW9fdV9pbml0KHN0cnVjdCB0aHJl
YWRfZGF0YSAqdGQsIHN0cnVjdCBpb191ICppb191KQogewotCXN0cnVjdCBmaW9fcmJkX2lvdSAq
bzsKKwlzdHJ1Y3QgZmlvX3JiZF9pb3UgKmZyaTsKIAotCW8gPSBtYWxsb2Moc2l6ZW9mKCpvKSk7
Ci0Jby0+aW9fY29tcGxldGUgPSAwOwotCW8tPmlvX3UgPSBpb191OwotCWlvX3UtPmVuZ2luZV9k
YXRhID0gbzsKKwlmcmkgPSBjYWxsb2MoMSwgc2l6ZW9mKCpmcmkpKTsKKwlmcmktPmlvX3UgPSBp
b191OworCWlvX3UtPmVuZ2luZV9kYXRhID0gZnJpOwogCXJldHVybiAwOwogfQogCg==
--089e01227a2a3214d2050664f5b4--
