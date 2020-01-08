Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lj1-f175.google.com ([209.85.208.175]:43031 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbgAHRvy (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Jan 2020 12:51:54 -0500
Received: by mail-lj1-f175.google.com with SMTP id a13so4205673ljm.10
        for <fio@vger.kernel.org>; Wed, 08 Jan 2020 09:51:52 -0800 (PST)
MIME-Version: 1.0
From: smitha sunder <sundersmitha@gmail.com>
Date: Wed, 8 Jan 2020 09:51:39 -0800
Message-ID: <CA+zhgFSVYMYkDeGEc1Tn3yEy24PgmFRiKABcCQkuEByMuLsnsQ@mail.gmail.com>
Subject: 4KiB + 64 B formatted drive : Invalid or incomplete multibyte or wide
 character: write offset=4096, buflen=4096
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello,

If I format the drive with 512+8 LBAF run fio, I don=E2=80=99t see any issu=
e :

# nvme list
Node             SN                   Model
        Namespace Usage                      Format           FW Rev
---------------- --------------------
---------------------------------------- ---------
-------------------------- ---------------- --------
/dev/nvme0n1     160401RICHC01        PM1733V4TLC
        1           1.92  TB /   1.92  TB    512   B +  8 B   TEMC8881
/dev/nvme1n1     160401RICHC01        PM1733V4TLC
        1           1.92  TB /   1.92  TB    512   B +  8 B   TEMC8881
[root@smitha-Z390-hawk tmp]# fio --filename=3D/dev/nvme0n1 --size=3D1M
--rw=3Dwrite --ioengine=3Dlibaio --direct=3D1 --verify=3Dcrc32 --verify_dum=
p=3D1
--name=3Dtest --bs=3D512
test: (g=3D0): rw=3Dwrite, bs=3D(R) 512B-512B, (W) 512B-512B, (T) 512B-512B=
,
ioengine=3Dlibaio, iodepth=3D1
fio-3.7
Starting 1 process

test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D32631: Wed Jan  8 09:40:32 2=
020
   read: IOPS=3D18.0k, BW=3D9481KiB/s (9709kB/s)(1024KiB/108msec)
 <snip>=E2=80=A6<snip>
  write: IOPS=3D27.3k, BW=3D13.3MiB/s (13.0MB/s)(1024KiB/75msec)

Run status group 0 (all jobs):
   READ: bw=3D9481KiB/s (9709kB/s), 9481KiB/s-9481KiB/s
(9709kB/s-9709kB/s), io=3D1024KiB (1049kB), run=3D108-108msec
  WRITE: bw=3D13.3MiB/s (13.0MB/s), 13.3MiB/s-13.3MiB/s
(13.0MB/s-13.0MB/s), io=3D1024KiB (1049kB), run=3D75-75msec

Disk stats (read/write):
  nvme0n1: ios=3D1288/2048, merge=3D0/0, ticks=3D67/66, in_queue=3D0, util=
=3D58.63%

How ever if I format the drive with LBAF type 4 that is supported by
the drive, then I get the following error :

# nvme format /dev/nvme1 --namespace-id=3D1 --lbaf=3D4   --pi=3D1 --ms=3D0
Success formatting namespace:1
#  nvme list
Node             SN                   Model
        Namespace Usage                      Format           FW Rev
---------------- --------------------
---------------------------------------- ---------
-------------------------- ---------------- --------
/dev/nvme0n1     160401RICHC01        PM1733V4TLC
        1           1.92  TB /   1.92  TB      4 KiB + 64 B   TEMC8881
/dev/nvme1n1     160401RICHC01        PM1733V4TLC
        1           1.92  TB /   1.92  TB      4 KiB + 64 B   TEMC8881


# fio --filename=3D/dev/nvme0n1 --size=3D1M --rw=3Dwrite --ioengine=3Dlibai=
o
--direct=3D1 --verify=3Dcrc32 --verify_dump=3D1 --name=3Dtest --bs=3D4096
test: (g=3D0): rw=3Dwrite, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=3Dlibaio, iodepth=3D1
fio-3.7
Starting 1 process
fio: io_u error on file /dev/nvme0n1: Invalid or incomplete multibyte
or wide character: write offset=3D4096, buflen=3D4096
fio: pid=3D32709, err=3D84/file:io_u.c:1747, func=3Dio_u error,
error=3DInvalid or incomplete multibyte or wide character

test: (groupid=3D0, jobs=3D1): err=3D84 (file:io_u.c:1747, func=3Dio_u erro=
r,
error=3DInvalid or incomplete multibyte or wide character): pid=3D32709:
Wed Jan  8 09:42:12 2020
  write: IOPS=3D2000, BW=3D4000KiB/s (4096kB/s)(4096B/1msec)
    slat (nsec): min=3D12142, max=3D27097, avg=3D19619.50, stdev=3D10574.78
    clat (nsec): min=3D24389, max=3D24389, avg=3D24389.00, stdev=3D 0.00
     lat (nsec): min=3D52811, max=3D52811, avg=3D52811.00, stdev=3D 0.00
  lat (usec)   : 50=3D50.00%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D2, majf=3D0, minf=3D22

     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
  WRITE: bw=3D4000KiB/s (4096kB/s), 4000KiB/s-4000KiB/s
(4096kB/s-4096kB/s), io=3D4096B (4096B), run=3D1-1msec

Disk stats (read/write):
  nvme0n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00%

Am I missing something?
Thanks for the help !

Smitha

