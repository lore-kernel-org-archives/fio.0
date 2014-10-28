Return-Path: <d.ketor@gmail.com>
MIME-Version: 1.0
In-Reply-To: <544ED37D.6060800@catalyst.net.nz>
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk>
 <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com>
 <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz>
 <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz>
 <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk>
 <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk>
 <544C2371.1020403@catalyst.net.nz> <544E547C.30009@kernel.dk>
 <CAM9_UU9j2erdGT5kqKi_+5z5ERFMPO1hHwMk8kaFjLkGm-zp-g@mail.gmail.com>
 <544E6330.1000202@kernel.dk> <544E63EA.1010204@kernel.dk> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com>
 <544E6691.106@kernel.dk> <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com>
 <544E6A8D.1040608@kernel.dk> <CAM9_UU8x2uZZUWaPPoy+LHmUhC_3sqKZ9GPsEqDwKUkprg4kdQ@mail.gmail.com>
 <544EC05D.7040807@catalyst.net.nz> <544EC7F1.6010900@kernel.dk> <544ED37D.6060800@catalyst.net.nz>
From: Ketor D <d.ketor@gmail.com>
Date: Tue, 28 Oct 2014 11:23:54 +0800
Message-ID: <CAM9_UU8MHdj+mjAWBziETxPDnwTt0JBuHrQp2Fu9YtF=msae3w@mail.gmail.com>
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
Content-Type: multipart/mixed; boundary=089e01229176168fbe0506732f3e
To: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>
Cc: Jens Axboe <axboe@kernel.dk>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--089e01229176168fbe0506732f3e
Content-Type: text/plain; charset=UTF-8

Hi Mark,
      Wish you could test my patch.I get the best performance using this patch.


2014-10-28 7:21 GMT+08:00 Mark Kirkwood <mark.kirkwood@catalyst.net.nz>:
> ng to see his numbers for patched vs orig!

--089e01229176168fbe0506732f3e
Content-Type: application/octet-stream; name="rbd_no_usleep.patch"
Content-Disposition: attachment; filename="rbd_no_usleep.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1soxba40

ZGlmZiAtLWdpdCBhL2VuZ2luZXMvcmJkLmMgYi9lbmdpbmVzL3JiZC5jCmluZGV4IDZmZTg3Yjgu
LmU2ZjJkZmYgMTAwNjQ0Ci0tLSBhL2VuZ2luZXMvcmJkLmMKKysrIGIvZW5naW5lcy9yYmQuYwpA
QCAtMjQ1LDcgKzI0NSw3IEBAIHN0YXRpYyBpbnQgZmlvX3JiZF9nZXRldmVudHMoc3RydWN0IHRo
cmVhZF9kYXRhICp0ZCwgdW5zaWduZWQgaW50IG1pbiwKIAogCQl9CiAJCWlmIChldmVudHMgPCBt
aW4pCi0JCQl1c2xlZXAoMTAwKTsKKwkJCTsvL3VzbGVlcCgxMDApOwogCQllbHNlCiAJCQlicmVh
azsKIAo=
--089e01229176168fbe0506732f3e--

