Return-Path: <swise@opengridcomputing.com>
Message-ID: <53F7D66E.9070809@opengridcomputing.com>
Date: Fri, 22 Aug 2014 18:46:54 -0500
From: Steve Wise <swise@opengridcomputing.com>
MIME-Version: 1.0
Subject: Re: fio terse output for WRITE not working.
References: <005e01cfb339$774e4640$65ead2c0$@opengridcomputing.com>	<002d01cfb896$19657b40$4c3071c0$@opengridcomputing.com> <CAFTzLMM=-vUtz8NRZBn7W_whH0Kgw0fzX5R0VsppaO_4xxv85A@mail.gmail.com> <003501cfb89e$07474ad0$15d5e070$@opengridcomputing.com> <53F7C3BE.8070204@kernel.dk> <53F7D109.8070503@opengridcomputing.com> <53F7D3A3.6030009@kernel.dk>
In-Reply-To: <53F7D3A3.6030009@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, 'Vasily Tarasov' <tarasov@vasily.name>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


>
> Yes, I'm saying I don't see this happening. This is my quickie test cas=
e:
>
> 3;fio-2.1.11-19-g0297;null;0;0;21019592;7006530;1751632;3000;0;0;0.0000=
00;0.000000;0;31;0.028879;0.181874;1.000000%=3D0;5.000000%=3D0;10.000000%=
=3D0;20.000000%=3D0;30.000000%=3D0;40.000000%=3D0;50.000000%=3D0;60.00000=
0%=3D0;70.000000%=3D0;80.000000%=3D0;90.000000%=3D0;95.000000%=3D0;99.000=
000%=3D1;99.500000%=3D1;99.900000%=3D1;99.950000%=3D1;99.990000%=3D1;0%=3D=
0;0%=3D0;0%=3D0;0;32;0.055929;0.249507;5932824;7322384;99.011636%;6937280=
=2E000000;569503.420436;21014252;7004750;1751187;3000;0;0;0.000000;0.0000=
00;0;48;0.029822;0.186289;1.000000%=3D0;5.000000%=3D0;10.000000%=3D0;20.0=
00000%=3D0;30.000000%=3D0;40.000000%=3D0;50.000000%=3D0;60.000000%=3D0;70=
=2E000000%=3D0;80.000000%=3D0;90.000000%=3D0;95.000000%=3D0;99.000000%=3D=
1;99.500000%=3D1;99.900000%=3D1;99.950000%=3D1;99.990000%=3D1;0%=3D0;0%=3D=
0;0%=3D0;0;48;0.074062;0.286370;5932824;7324072;98.994494%;6934316.800000=
;568074.804612;99.666667%;0.000000%;4;0;3;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%=
;0.0%;100.00%;0.01%;0.01%;0.01%;0.01%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%=
;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;=20
>
> 0.00%
>
> or when run with normal output:
>
> null: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D26423: Fri Aug 22 17:33:=
46 2014
>   read : io=3D20499MB, bw=3D6833.2MB/s, iops=3D1749.3K, runt=3D  3000ms=
ec
>     clat (usec): min=3D0, max=3D82, avg=3D 0.03, stdev=3D 0.19
>      lat (usec): min=3D0, max=3D83, avg=3D 0.06, stdev=3D 0.26
>     clat percentiles (usec):
>      |  1.00th=3D[    0],  5.00th=3D[    0], 10.00th=3D[    0], 20.00th=
=3D[   =20
> 0],
>      | 30.00th=3D[    0], 40.00th=3D[    0], 50.00th=3D[    0], 60.00th=
=3D[   =20
> 0],
>      | 70.00th=3D[    0], 80.00th=3D[    0], 90.00th=3D[    0], 95.00th=
=3D[   =20
> 0],
>      | 99.00th=3D[    1], 99.50th=3D[    1], 99.90th=3D[    1], 99.95th=
=3D[   =20
> 1],
>      | 99.99th=3D[    1]
>     bw (MB  /s): min=3D 5617, max=3D 7119, per=3D98.96%, avg=3D6762.01,=
=20
> stdev=3D641.65
>   write: io=3D20495MB, bw=3D6831.6MB/s, iops=3D1748.9K, runt=3D  3000ms=
ec
>     clat (usec): min=3D0, max=3D144, avg=3D 0.03, stdev=3D 0.20
>      lat (usec): min=3D0, max=3D144, avg=3D 0.07, stdev=3D 0.30
>     clat percentiles (usec):
>      |  1.00th=3D[    0],  5.00th=3D[    0], 10.00th=3D[    0], 20.00th=
=3D[   =20
> 0],
>      | 30.00th=3D[    0], 40.00th=3D[    0], 50.00th=3D[    0], 60.00th=
=3D[   =20
> 0],
>      | 70.00th=3D[    0], 80.00th=3D[    0], 90.00th=3D[    0], 95.00th=
=3D[   =20
> 0],
>      | 99.00th=3D[    1], 99.50th=3D[    1], 99.90th=3D[    1], 99.95th=
=3D[   =20
> 1],
>      | 99.99th=3D[    1]
>     bw (MB  /s): min=3D 5617, max=3D 7118, per=3D98.94%, avg=3D6759.24,=
=20
> stdev=3D640.28
>     lat (usec) : 2=3D100.00%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%, 50=3D0=
=2E01%
>     lat (usec) : 100=3D0.01%, 250=3D0.01%
>   cpu          : usr=3D100.00%, sys=3D0.00%, ctx=3D7, majf=3D0, minf=3D=
3
>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%,=20
> >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
> >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,=20
> >=3D64=3D0.0%
>      issued    : total=3Dr=3D5247840/w=3D5246653/d=3D0, short=3Dr=3D0/w=
=3D0/d=3D0
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1
>
> Run status group 0 (all jobs):
>    READ: io=3D20499MB, aggrb=3D6833.2MB/s, minb=3D6833.2MB/s,=20
> maxb=3D6833.2MB/s, mint=3D3000msec, maxt=3D3000msec
>   WRITE: io=3D20495MB, aggrb=3D6831.6MB/s, minb=3D6831.6MB/s,=20
> maxb=3D6831.6MB/s, mint=3D3000msec, maxt=3D3000ms

hmm.

I'll try with the latest fio from the git repo.  Perhaps this has been=20
fixed since the version I'm using (2.1.10)?

Thanks,

Steve.


