Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:36904 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbbA0Wme (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Jan 2015 17:42:34 -0500
Received: from mail.micron.com (ntxboicas01.micron.com [137.201.84.60])
	by mailout.micron.com (8.14.4/8.14.6) with ESMTP id t0RMgX2S027347
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <fio@vger.kernel.org>; Tue, 27 Jan 2015 15:42:33 -0700
From: "Justin Eno (jeno)" <jeno@micron.com>
Subject: RE: last_block() vs. min_bs when > blockalign
Date: Tue, 27 Jan 2015 22:42:31 +0000
Message-ID: <5A8251503902B84E89CE171AD126BCFB2DE52B5F@NTXBOIMBX01.micron.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_5A8251503902B84E89CE171AD126BCFB2DE52B5FNTXBOIMBX01micr_"
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

--_002_5A8251503902B84E89CE171AD126BCFB2DE52B5FNTXBOIMBX01micr_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The attached updated patch produces the desired behavior.  If min_bs is lar=
ger than blockalign, last_block() now returns a suitable value.

Thanks,
Justin

-----Original Message-----
From: Justin Eno (jeno)=20
Sent: Tuesday, January 27, 2015 1:35 PM
To: 'fio@vger.kernel.org'
Subject: RE: last_block() vs. min_bs when > blockalign

Please disregard the patch - it incorrectly limits the target write range. =
 I will work on a proper fix.  Sorry for the noise.

-Justin

-----Original Message-----
From: Justin Eno (jeno)=20
Sent: Tuesday, January 27, 2015 12:00 PM
To: 'fio@vger.kernel.org'
Subject: last_block() vs. min_bs when > blockalign

Hi Jens and all,

I have found that when performing mixed-sized random writes, fio ceases wri=
ting early due to last_block() not respecting min_bs.
The attached workload demonstrates the issue.  When run with io debugging e=
nabled, "failed getting buflen" is reported, and the written data falls sho=
rt of the total requested (in this case, 10M), e.g., ######################=
#########################
[jeno@rhel fio-clean]$ ./fio --debug=3Dio examples/random-fill.fio
fio: Any use of blockalign=3D turns off randommap
fio: set debug option io
io       25214 load ioengine sync
write-phase: (g=3D0): rw=3Drandwrite, bs=3D1K-5K/1K-5K/1K-5K, ioengine=3Dsy=
nc, iodepth=3D1 fio-2.2.5-3-g209e Starting 1 thread
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
=3D7588msec, maxt=3D7588msec ...
###############################################

The attached patch changes last_block() to respect min_bs.

Thanks,
Justin


--_002_5A8251503902B84E89CE171AD126BCFB2DE52B5FNTXBOIMBX01micr_
Content-Type: application/octet-stream; name="last_block_v2.patch"
Content-Description: last_block_v2.patch
Content-Disposition: attachment; filename="last_block_v2.patch"; size=957;
	creation-date="Tue, 27 Jan 2015 22:35:45 GMT";
	modification-date="Tue, 27 Jan 2015 22:35:45 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmNGY5ZGQ2ZWIzYjgxZjJjYjc5YWEzYzQxZmQ0ZDEzMWNjYTkxYjZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKdXN0aW4gRW5vIDxqZW5vQG1pY3Jvbi5jb20+CkRhdGU6IFR1
ZSwgMjcgSmFuIDIwMTUgMTQ6MjM6MjAgLTA4MDAKU3ViamVjdDogW1BBVENIXSBCZXR0ZXIgYWNj
b21tb2RhdGUgcmFuZG9tIHdyaXRlcyBsYXJnZXIgdGhhbiBibG9ja2FsaWduCgpmaWxsX2lvX3Uo
KSBmYWlscyBwcmVtYXR1cmVseSBpZiB0aGUgcmFuZG9tbHktY2hvc2VuIG9mZnNldCBzYXRpc2Zp
ZXMKYmxvY2thbGlnbiBidXQgbm90IG1pbl9icywgaS5lLiwgdGhlIG9mZnNldCBsaWVzIHRvbyBu
ZWFyIHRoZSBlbmQgb2YKdGhlIHRhcmdldCByZWdpb24uICBUaGlzIGNoYW5nZSBob25vcnMgYm90
aCBwYXJhbWV0ZXJzLgoKU2lnbmVkLW9mZi1ieTogSnVzdGluIEVubyA8amVub0BtaWNyb24uY29t
PgotLS0KIGlvX3UuYyB8ICAgIDMgKysrCiAxIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pb191LmMgYi9pb191LmMKaW5kZXggNTk3
MWQ3OC4uNzdhM2FiZiAxMDA2NDQKLS0tIGEvaW9fdS5jCisrKyBiL2lvX3UuYwpAQCAtNjgsNiAr
NjgsOSBAQCBzdGF0aWMgdWludDY0X3QgbGFzdF9ibG9jayhzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRk
LCBzdHJ1Y3QgZmlvX2ZpbGUgKmYsCiAJaWYgKHRkLT5vLnpvbmVfcmFuZ2UpCiAJCW1heF9zaXpl
ID0gdGQtPm8uem9uZV9yYW5nZTsKIAorCWlmICh0ZC0+by5taW5fYnNbZGRpcl0gPiB0ZC0+by5i
YVtkZGlyXSkKKwkJbWF4X3NpemUgLT0gdGQtPm8ubWluX2JzW2RkaXJdIC0gdGQtPm8uYmFbZGRp
cl07CisKIAltYXhfYmxvY2tzID0gbWF4X3NpemUgLyAodWludDY0X3QpIHRkLT5vLmJhW2RkaXJd
OwogCWlmICghbWF4X2Jsb2NrcykKIAkJcmV0dXJuIDA7Ci0tIAoxLjcuMQoK

--_002_5A8251503902B84E89CE171AD126BCFB2DE52B5FNTXBOIMBX01micr_--
