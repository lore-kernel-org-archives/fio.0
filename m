Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36383 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbcHHXDY (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 8 Aug 2016 19:03:24 -0400
Received: by mail-wm0-f50.google.com with SMTP id q128so1545135wma.1
        for <fio@vger.kernel.org>; Mon, 08 Aug 2016 16:03:23 -0700 (PDT)
MIME-Version: 1.0
From: "j.Lucas" <j_lucas@wp.pl>
Date: Tue, 9 Aug 2016 01:02:41 +0200
Message-ID: <CANfUGLbSKVO=9+rEnQ-1YZMVs=+diO4Ae9VRczwA0kJ_-nkrgQ@mail.gmail.com>
Subject: Fio latency inconsistent
Content-Type: multipart/mixed; boundary=001a114194344145d10539976cff
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--001a114194344145d10539976cff
Content-Type: text/plain; charset=UTF-8

Hi

I am trying to understand fio latency numbers.
Would be great if you can clarify why latency numbers are inconsistent.

Here is sample fio output:

read_lat: (g=0): rw=randread, bs=512-512/512-512/512-512,
ioengine=libaio, iodepth=1
fio-2.1.10
Starting 1 thread

read_lat: (groupid=0, jobs=1): err= 0: pid=10848: Mon Jul 11 13:34:27 2016
  read : io=7541.2MB, bw=12870KB/s, iops=25740, runt=600001msec
    slat (usec): min=3, max=62, avg= 3.95, stdev= 0.37
    clat (usec): min=0, max=12053, avg=34.19, stdev=24.21
     lat (usec): min=28, max=12057, avg=38.24, stdev=24.21
    clat percentiles (usec):
     |  1.00th=[   25],  5.00th=[   26], 10.00th=[   26], 20.00th=[   26],
     | 30.00th=[   26], 40.00th=[   26], 50.00th=[   26], 60.00th=[   27],
     | 70.00th=[   27], 80.00th=[   27], 90.00th=[   91], 95.00th=[  106],
     | 99.00th=[  112], 99.50th=[  112], 99.90th=[  118], 99.95th=[  120],
     | 99.99th=[  129]
    bw (KB  /s): min=11701, max=13161, per=100.00%, avg=12870.89, stdev=114.55
    lat (usec) : 2=0.01%, 10=0.01%, 20=0.01%, 50=89.85%, 100=5.02%
    lat (usec) : 250=5.12%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%
  cpu          : usr=5.91%, sys=13.98%, ctx=15444904, majf=0, minf=8
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=15444203/w=0/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: io=7541.2MB, aggrb=12870KB/s, minb=12870KB/s, maxb=12870KB/s,
mint=600001msec, maxt=600001msec

Disk stats (read/write):
  sdb: ios=15440539/0, merge=0/0, ticks=506729/0, in_queue=504796, util=84.17%



From output:
Run time = 600001 ms
queue depth = 1
performed IO = 25740

So correct me if i am wrong, but 600001 / 25740 = 23.31 ms
However, fio reports an average latency of 38.24 ms.
Should those numbers be consistent?


Thanks
-- 
Lucas

--001a114194344145d10539976cff
Content-Type: text/plain; charset=US-ASCII; name="fio-read-lat-512.txt"
Content-Disposition: attachment; filename="fio-read-lat-512.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_irmn71ll0

cmVhZF9sYXQ6IChnPTApOiBydz1yYW5kcmVhZCwgYnM9NTEyLTUxMi81MTItNTEyLzUxMi01MTIs
IGlvZW5naW5lPWxpYmFpbywgaW9kZXB0aD0xCmZpby0yLjEuMTAKU3RhcnRpbmcgMSB0aHJlYWQK
CnJlYWRfbGF0OiAoZ3JvdXBpZD0wLCBqb2JzPTEpOiBlcnI9IDA6IHBpZD0xMDg0ODogTW9uIEp1
bCAxMSAxMzozNDoyNyAyMDE2CiAgcmVhZCA6IGlvPTc1NDEuMk1CLCBidz0xMjg3MEtCL3MsIGlv
cHM9MjU3NDAsIHJ1bnQ9NjAwMDAxbXNlYwogICAgc2xhdCAodXNlYyk6IG1pbj0zLCBtYXg9NjIs
IGF2Zz0gMy45NSwgc3RkZXY9IDAuMzcKICAgIGNsYXQgKHVzZWMpOiBtaW49MCwgbWF4PTEyMDUz
LCBhdmc9MzQuMTksIHN0ZGV2PTI0LjIxCiAgICAgbGF0ICh1c2VjKTogbWluPTI4LCBtYXg9MTIw
NTcsIGF2Zz0zOC4yNCwgc3RkZXY9MjQuMjEKICAgIGNsYXQgcGVyY2VudGlsZXMgKHVzZWMpOgog
ICAgIHwgIDEuMDB0aD1bICAgMjVdLCAgNS4wMHRoPVsgICAyNl0sIDEwLjAwdGg9WyAgIDI2XSwg
MjAuMDB0aD1bICAgMjZdLAogICAgIHwgMzAuMDB0aD1bICAgMjZdLCA0MC4wMHRoPVsgICAyNl0s
IDUwLjAwdGg9WyAgIDI2XSwgNjAuMDB0aD1bICAgMjddLAogICAgIHwgNzAuMDB0aD1bICAgMjdd
LCA4MC4wMHRoPVsgICAyN10sIDkwLjAwdGg9WyAgIDkxXSwgOTUuMDB0aD1bICAxMDZdLAogICAg
IHwgOTkuMDB0aD1bICAxMTJdLCA5OS41MHRoPVsgIDExMl0sIDk5LjkwdGg9WyAgMTE4XSwgOTku
OTV0aD1bICAxMjBdLAogICAgIHwgOTkuOTl0aD1bICAxMjldCiAgICBidyAoS0IgIC9zKTogbWlu
PTExNzAxLCBtYXg9MTMxNjEsIHBlcj0xMDAuMDAlLCBhdmc9MTI4NzAuODksIHN0ZGV2PTExNC41
NQogICAgbGF0ICh1c2VjKSA6IDI9MC4wMSUsIDEwPTAuMDElLCAyMD0wLjAxJSwgNTA9ODkuODUl
LCAxMDA9NS4wMiUKICAgIGxhdCAodXNlYykgOiAyNTA9NS4xMiUsIDUwMD0wLjAxJSwgNzUwPTAu
MDElLCAxMDAwPTAuMDElCiAgICBsYXQgKG1zZWMpIDogMj0wLjAxJSwgND0wLjAxJSwgMTA9MC4w
MSUsIDIwPTAuMDElCiAgY3B1ICAgICAgICAgIDogdXNyPTUuOTElLCBzeXM9MTMuOTglLCBjdHg9
MTU0NDQ5MDQsIG1hamY9MCwgbWluZj04CiAgSU8gZGVwdGhzICAgIDogMT0xMDAuMCUsIDI9MC4w
JSwgND0wLjAlLCA4PTAuMCUsIDE2PTAuMCUsIDMyPTAuMCUsID49NjQ9MC4wJQogICAgIHN1Ym1p
dCAgICA6IDA9MC4wJSwgND0xMDAuMCUsIDg9MC4wJSwgMTY9MC4wJSwgMzI9MC4wJSwgNjQ9MC4w
JSwgPj02ND0wLjAlCiAgICAgY29tcGxldGUgIDogMD0wLjAlLCA0PTEwMC4wJSwgOD0wLjAlLCAx
Nj0wLjAlLCAzMj0wLjAlLCA2ND0wLjAlLCA+PTY0PTAuMCUKICAgICBpc3N1ZWQgICAgOiB0b3Rh
bD1yPTE1NDQ0MjAzL3c9MC9kPTAsIHNob3J0PXI9MC93PTAvZD0wCiAgICAgbGF0ZW5jeSAgIDog
dGFyZ2V0PTAsIHdpbmRvdz0wLCBwZXJjZW50aWxlPTEwMC4wMCUsIGRlcHRoPTEKClJ1biBzdGF0
dXMgZ3JvdXAgMCAoYWxsIGpvYnMpOgogICBSRUFEOiBpbz03NTQxLjJNQiwgYWdncmI9MTI4NzBL
Qi9zLCBtaW5iPTEyODcwS0IvcywgbWF4Yj0xMjg3MEtCL3MsIG1pbnQ9NjAwMDAxbXNlYywgbWF4
dD02MDAwMDFtc2VjCgpEaXNrIHN0YXRzIChyZWFkL3dyaXRlKToKICBzZGI6IGlvcz0xNTQ0MDUz
OS8wLCBtZXJnZT0wLzAsIHRpY2tzPTUwNjcyOS8wLCBpbl9xdWV1ZT01MDQ3OTYsIHV0aWw9ODQu
MTclCg==
--001a114194344145d10539976cff--
