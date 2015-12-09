Return-Path: <dhong@micron.com>
From: "Deyoung Hong (dhong)" <dhong@micron.com>
Subject: RE: Bug using ramp_time shows cpu over 100%
Date: Wed, 9 Dec 2015 09:56:22 +0000
Message-ID: <a343b7251eb54dae85f0f85e858ee19c@BOWEX36-B.micron.com>
References: <3ccceea7625d474b8afd2a6f6a7ab0ef@BOWEX36-B.micron.com>
 <566796DC.2040308@kernel.dk>
In-Reply-To: <566796DC.2040308@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Sorry, not sure how I made that mistake (didn't even check my email respons=
e).
I ran various fio versions (including the latest Download ZIP) and thought =
I checked and saw cpu way over 100%.
It now looks like my custom engine does not run  with the latest fio code a=
nymore.

Thanks for the fix.

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jens Axboe
Sent: Tuesday, December 08, 2015 6:50 PM
To: Deyoung Hong (dhong); fio@vger.kernel.org
Subject: Re: Bug using ramp_time shows cpu over 100%

On 12/08/2015 02:45 PM, Deyoung Hong (dhong) wrote:
> I saw the response on http://www.spinics.net/lists/fio/msg04392.html (did=
n't get the email), so I'm pasting it here.
>
> I git pulled the latest fio code and observed the specified changes.  I c=
ompiled and ran the latest code but still seeing the same problem:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> test: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio, =
iodepth=3D1
> fio-2.2.12-50-g5261
> Starting 1 thread
>
> test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D10726: Tue Dec  8 13:40:21=
 2015
>    read : io=3D799740KB, bw=3D79966KB/s, iops=3D19991, runt=3D 10001msec
>      slat (usec): min=3D0, max=3D11, avg=3D 0.10, stdev=3D 0.30
>      clat (usec): min=3D26, max=3D2624, avg=3D49.03, stdev=3D34.07
>       lat (usec): min=3D35, max=3D2624, avg=3D49.12, stdev=3D34.07
>      clat percentiles (usec):
>       |  1.00th=3D[   36],  5.00th=3D[   36], 10.00th=3D[   36], 20.00th=
=3D[   37],
>       | 30.00th=3D[   37], 40.00th=3D[   38], 50.00th=3D[   38], 60.00th=
=3D[   39],
>       | 70.00th=3D[   40], 80.00th=3D[   70], 90.00th=3D[   79], 95.00th=
=3D[   87],
>       | 99.00th=3D[   92], 99.50th=3D[   94], 99.90th=3D[  225], 99.95th=
=3D[  298],
>       | 99.99th=3D[ 2128]
>      bw (KB  /s): min=3D    0, max=3D81072, per=3D95.01%, avg=3D75974.80,=
 stdev=3D17896.56
>      lat (usec) : 50=3D71.32%, 100=3D28.42%, 250=3D0.19%, 500=3D0.04%, 75=
0=3D0.01%
>      lat (usec) : 1000=3D0.01%
>      lat (msec) : 2=3D0.01%, 4=3D0.01%
>    cpu          : usr=3D99.99%, sys=3D0.00%, ctx=3D8, majf=3D0, minf=3D0
>    IO depths    : 1=3D157.5%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, >=3D64=3D0.0%
>       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>       complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>       issued    : total=3Dr=3D199935/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0, drop=3Dr=3D0/w=3D0/d=3D0
>       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1
>
> Run status group 0 (all jobs):
>     READ: io=3D799740KB, aggrb=3D79966KB/s, minb=3D79966KB/s, maxb=3D7996=
6KB/s, mint=3D10001msec, maxt=3D10001msec

This is showing 99.99% usr time, for a polled driver that doesn't seem=20
crazy. Why do you think it's broken?

--=20
Jens Axboe

