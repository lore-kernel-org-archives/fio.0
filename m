Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:12278 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759531AbbA0UAJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Jan 2015 15:00:09 -0500
Received: from mail.micron.com (ntxboicas03.micron.com [137.201.84.59])
	by mailout.micron.com (8.14.4/8.14.6) with ESMTP id t0RK07bN009202
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Tue, 27 Jan 2015 13:00:07 -0700
From: "Justin Eno (jeno)" <jeno@micron.com>
Subject: last_block() vs. min_bs when > blockalign
Date: Tue, 27 Jan 2015 20:00:06 +0000
Message-ID: <5A8251503902B84E89CE171AD126BCFB2DE51B21@NTXBOIMBX01.micron.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_003_5A8251503902B84E89CE171AD126BCFB2DE51B21NTXBOIMBX01micr_"
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

--_003_5A8251503902B84E89CE171AD126BCFB2DE51B21NTXBOIMBX01micr_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Jens and all,

I have found that when performing mixed-sized random writes, fio ceases wri=
ting early due to last_block() not respecting min_bs.
The attached workload demonstrates the issue.  When run with io debugging e=
nabled, "failed getting buflen" is reported, and the
written data falls short of the total requested (in this case, 10M), e.g.,
###############################################
[jeno@rhel fio-clean]$ ./fio --debug=3Dio examples/random-fill.fio
fio: Any use of blockalign=3D turns off randommap
fio: set debug option io
io       25214 load ioengine sync
write-phase: (g=3D0): rw=3Drandwrite, bs=3D1K-5K/1K-5K/1K-5K, ioengine=3Dsy=
nc, iodepth=3D1
fio-2.2.5-3-g209e
Starting 1 thread
write-phase: Laying out IO file(s) (1 file(s) / 5MB)
io       25214 invalidate cache datafile.tmp: 0/5242880
io       25214 invalidate cache datafile.tmp: 0/5242880
io       25214 fill_io_u: io_u 0x7fe49c003d40: off=3D315904/len=3D1024/ddir=
=3D1/datafile.tmp
io       25214 prep: io_u 0x7fe49c003d40: off=3D315904/len=3D1024/ddir=3D1/=
datafile.tmp
io       25214 ->prep(0x7fe49c003d40)=3D0
io       25214 queue: io_u 0x7fe49c003d40: off=3D315904/len=3D1024/ddir=3D1=
/datafile.tmp
io       25214 io complete: io_u 0x7fe49c003d40: off=3D315904/len=3D1024/dd=
ir=3D1/datafile.tmp
...
io       25214 fill_io_u: io_u 0x7fe49c003d40: off=3D4930560/len=3D5120/ddi=
r=3D1/datafile.tmp
io       25214 prep: io_u 0x7fe49c003d40: off=3D4930560/len=3D5120/ddir=3D1=
/datafile.tmp
io       25214 ->prep(0x7fe49c003d40)=3D0
io       25214 queue: io_u 0x7fe49c003d40: off=3D4930560/len=3D5120/ddir=3D=
1/datafile.tmp
io       25214 io complete: io_u 0x7fe49c003d40: off=3D4930560/len=3D5120/d=
dir=3D1/datafile.tmp
io       25214 io_u 0x7fe49c003d40, failed getting buflen
io       25214 io_u 0x7fe49c003d40, setting file failed
io       25214 get_io_u failed
io       25214 close ioengine sync
io       25214 free ioengine sync

write-phase: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D25281: Tue Jan 27 10:=
33:50 2015
  write: io=3D4335.0KB, bw=3D585007B/s, iops=3D195, runt=3D  7588msec
    clat (usec): min=3D762, max=3D17788, avg=3D5100.38, stdev=3D2509.05
     lat (usec): min=3D764, max=3D17790, avg=3D5101.80, stdev=3D2509.06
    clat percentiles (usec):
     |  1.00th=3D[  868],  5.00th=3D[ 1240], 10.00th=3D[ 1704], 20.00th=3D[=
 2544],
     | 30.00th=3D[ 3440], 40.00th=3D[ 4192], 50.00th=3D[ 5024], 60.00th=3D[=
 5984],
     | 70.00th=3D[ 6752], 80.00th=3D[ 7648], 90.00th=3D[ 8384], 95.00th=3D[=
 8896],
     | 99.00th=3D[ 9280], 99.50th=3D[10304], 99.90th=3D[17792], 99.95th=3D[=
17792],
     | 99.99th=3D[17792]
    bw (KB  /s): min=3D  520, max=3D  640, per=3D99.98%, avg=3D570.87, stde=
v=3D35.30
    lat (usec) : 1000=3D2.76%
    lat (msec) : 2=3D11.25%, 4=3D22.76%, 10=3D62.63%, 20=3D0.61%
  cpu          : usr=3D0.12%, sys=3D0.28%, ctx=3D1486, majf=3D0, minf=3D1
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D1485/d=3D0, short=3Dr=3D0/w=3D0/d=3D0, d=
rop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
  WRITE: io=3D4335KB, aggrb=3D571KB/s, minb=3D571KB/s, maxb=3D571KB/s, mint=
=3D7588msec, maxt=3D7588msec
...
###############################################

The attached patch changes last_block() to respect min_bs.

Thanks,
Justin


--_003_5A8251503902B84E89CE171AD126BCFB2DE51B21NTXBOIMBX01micr_
Content-Type: application/octet-stream; name="last_block.patch"
Content-Description: last_block.patch
Content-Disposition: attachment; filename="last_block.patch"; size=1173;
	creation-date="Tue, 27 Jan 2015 19:24:40 GMT";
	modification-date="Tue, 27 Jan 2015 19:39:32 GMT"
Content-Transfer-Encoding: base64

RnJvbSA1YTczZGIyNmQ1ZWJkODEzN2IxNDQ2ZjZiYjE0ZTJiNGU0ZjQ4ZWE5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKdXN0aW4gRW5vIDxqZW5vQG1pY3Jvbi5jb20+CkRhdGU6IFR1
ZSwgMjcgSmFuIDIwMTUgMTE6MTI6NTAgLTA4MDAKU3ViamVjdDogW1BBVENIXSBCZXR0ZXIgYWNj
b21tb2RhdGUgcmFuZG9tIHdyaXRlcyBsYXJnZXIgdGhhbiBibG9ja2FsaWduCgpmaWxsX2lvX3Uo
KSBmYWlscyBwcmVtYXR1cmVseSBpZiB0aGUgcmFuZG9tbHktY2hvc2VuIG9mZnNldCBzYXRpc2Zp
ZXMKYmxvY2thbGlnbiBidXQgbm90IG1pbl9icywgaS5lLiwgdGhlIG9mZnNldCBsaWVzIHRvbyBu
ZWFyIHRoZSBlbmQgb2YKdGhlIHRhcmdldCByZWdpb24uICBUaGlzIGNoYW5nZSBob25vcnMgYm90
aCBwYXJhbWV0ZXJzLgoKU2lnbmVkLW9mZi1ieTogSnVzdGluIEVubyA8amVub0BtaWNyb24uY29t
PgotLS0KIGlvX3UuYyB8ICAgIDcgKysrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlv
bnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW9fdS5jIGIvaW9fdS5jCmluZGV4
IDU5NzFkNzguLmIxYWE4YTggMTAwNjQ0Ci0tLSBhL2lvX3UuYworKysgYi9pb191LmMKQEAgLTU1
LDYgKzU1LDcgQEAgc3RhdGljIHVpbnQ2NF90IGxhc3RfYmxvY2soc3RydWN0IHRocmVhZF9kYXRh
ICp0ZCwgc3RydWN0IGZpb19maWxlICpmLAogewogCXVpbnQ2NF90IG1heF9ibG9ja3M7CiAJdWlu
dDY0X3QgbWF4X3NpemU7CisJdWludDY0X3QgbWluX3NpemU7CiAKIAlhc3NlcnQoZGRpcl9ydyhk
ZGlyKSk7CiAKQEAgLTY5LDYgKzcwLDEyIEBAIHN0YXRpYyB1aW50NjRfdCBsYXN0X2Jsb2NrKHN0
cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdCBmaW9fZmlsZSAqZiwKIAkJbWF4X3NpemUgPSB0
ZC0+by56b25lX3JhbmdlOwogCiAJbWF4X2Jsb2NrcyA9IG1heF9zaXplIC8gKHVpbnQ2NF90KSB0
ZC0+by5iYVtkZGlyXTsKKwltaW5fc2l6ZSA9IHRkLT5vLmJhW2RkaXJdOworCXdoaWxlIChtaW5f
c2l6ZSA8IHRkLT5vLm1pbl9ic1tkZGlyXSkgeworCQltaW5fc2l6ZSArPSB0ZC0+by5iYVtkZGly
XTsKKwl9CisKKwltYXhfYmxvY2tzID0gbWF4X3NpemUgLyBtaW5fc2l6ZTsKIAlpZiAoIW1heF9i
bG9ja3MpCiAJCXJldHVybiAwOwogCi0tIAoxLjcuMQoK

--_003_5A8251503902B84E89CE171AD126BCFB2DE51B21NTXBOIMBX01micr_
Content-Type: application/octet-stream; name="random-fill.fio"
Content-Description: random-fill.fio
Content-Disposition: attachment; filename="random-fill.fio"; size=220;
	creation-date="Tue, 27 Jan 2015 19:25:42 GMT";
	modification-date="Tue, 27 Jan 2015 19:29:39 GMT"
Content-Transfer-Encoding: base64

OyB3cml0ZXMgbWl4ZWQtc2l6ZSBibG9ja3MKW2dsb2JhbF0KdGhyZWFkPTEKZGlyZWN0PTEKaW9l
bmdpbmU9c3luYwpic3JhbmdlPTFrOjVrCmJsb2NrYWxpZ249NTEyCm9mZnNldD0wCnNpemU9NU0K
aW9fbGltaXQ9MTBNCgpbd3JpdGUtcGhhc2VdCmZpbGVuYW1lPWRhdGFmaWxlLnRtcAk7IG9yIHVz
ZSBhIGZ1bGwgZGlzaywgZm9yIGV4YW1wbGUgL2Rldi9zZGEKcnc9cmFuZHdyaXRlCg==

--_003_5A8251503902B84E89CE171AD126BCFB2DE51B21NTXBOIMBX01micr_--
