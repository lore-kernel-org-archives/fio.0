Return-Path: <sectorsize512@gmail.com>
MIME-Version: 1.0
Sender: sectorsize512@gmail.com
In-Reply-To: <53BE5357.8050407@kernel.dk>
References: <CAFTzLMPWvQ8+rxmbSruzmHTMvkDXQ_ednA5rkDb3_CVoAtdVVw@mail.gmail.com>
	<53BE5357.8050407@kernel.dk>
Date: Fri, 11 Jul 2014 19:25:41 -0400
Message-ID: <CAFTzLMODqjrycMH08Wi0TUeOs9SBXqeOG9OtYTBHbXM7qjb+dw@mail.gmail.com>
Subject: Re: Disk utilization statistics in terse format
From: Vasily Tarasov <tarasov@vasily.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

If we just remove is_backend in the _v3_v4, then there will be
inconsistencies in the terse output between server-client and
standalone modes. In the server-client mode disk utilization will be
printed in the very end, while in the standalone mode corresponding
fields will be somewhere in the middle.

Actually, there are more inconsistencies between these modes. Check this ou=
t:

In the client-server mode:

<snip starts>
[user@frontend fios-24-reads]$ fio --minimal --status-interval=3D10
--client frontend 1.fio
hostname=3Dbison01, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64, fio=3Dfio-2.=
1.10, flags=3D1
<bison01> sdaa: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M/1M-1M, ioengine=3Dsync=
, iodepth=3D1
<bison01> Starting 1 process
<bison01> =3D1): [] [11.9% done] [191.2M/0K/0K /s] [186/0/0 iops] [eta 10m:=
50s]
fio: terminating on signal 2
<bison01>
3;fio-2.1.10;sdaa;0;0;17233920;195675;191;88074;0;0;0.000000;0.000000;4829;=
10900;5228.857219;220.162611;1.000000%=3D4896;5.000000%=3D4960;10.000000%=
=3D4960;20.000000%=3D5024;30.000000%=3D5088;40.000000%=3D5152;50.000000%=3D=
5280;60.000000%=3D5280;70.000000%=3D5344;80.000000%=3D5408;90.000000%=3D547=
2;95.000000%=3D5472;99.000000%=3D5536;99.500000%=3D5856;99.900000%=3D6432;9=
9.950000%=3D9024;99.990000%=3D9408;0%=3D0;0%=3D0;0%=3D0;4830;10900;5229.256=
982;220.166861;188039;206023;100.000000%;195845.737143;5595.466346;0;0;0;0;=
0;0;0.000000;0.000000;0;0;0.000000;0.000000;1.000000%=3D0;5.000000%=3D0;10.=
000000%=3D0;20.000000%=3D0;30.000000%=3D0;40.000000%=3D0;50.000000%=3D0;60.=
000000%=3D0;70.000000%=3D0;80.000000%=3D0;90.000000%=3D0;95.000000%=3D0;99.=
000000%=3D0;99.500000%=3D0;99.900000%=3D0;99.950000%=3D0;99.990000%=3D0;0%=
=3D0;0%=3D0;0%=3D0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;0.=
130574%;1.704268%;18221;0;286;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.=
00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;99.99%;0.01=
%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%

Run status group 0 (all jobs):
   READ: io=3D16830MB, aggrb=3D195675KB/s, minb=3D195675KB/s,
maxb=3D195675KB/s, mint=3D88074msec, maxt=3D88074msec

Disk stats (read/write):
;sdaa;33614;0;0;0;130703;0;130681;99.31%client: host=3Dbison01 disconnected
<snip ends>

In the server mode:

<snip starts>
root@backend fios-24-reads]# fio --minimal --status-interval=3D10  1.fio
3;fio-2.1.10;sdaa;0;0;1943552;196278;191;9902;0;0;0.000000;0.000000;4835;95=
04;5210.884676;307.928200;1.000000%=3D4896;5.000000%=3D4896;10.000000%=3D49=
60;20.000000%=3D4960;30.000000%=3D4960;40.000000%=3D5024;50.000000%=3D5280;=
60.000000%=3D5344;70.000000%=3D5344;80.000000%=3D5408;90.000000%=3D5472;95.=
000000%=3D5536;99.000000%=3D5600;99.500000%=3D5984;99.900000%=3D9408;99.950=
000%=3D9536;99.990000%=3D9536;0%=3D0;0%=3D0;0%=3D0;4836;9504;5211.332807;30=
7.944109;188039;206023;99.949829%;196179.526316;7200.889724;0;0;0;0;0;0;0.0=
00000;0.000000;0;0;0.000000;0.000000;1.000000%=3D0;5.000000%=3D0;10.000000%=
=3D0;20.000000%=3D0;30.000000%=3D0;40.000000%=3D0;50.000000%=3D0;60.000000%=
=3D0;70.000000%=3D0;80.000000%=3D0;90.000000%=3D0;95.000000%=3D0;99.000000%=
=3D0;99.500000%=3D0;99.900000%=3D0;99.950000%=3D0;99.990000%=3D0;0%=3D0;0%=
=3D0;0%=3D0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;0.090891%=
;1.959200%;2046;0;287;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.00%;0.00=
%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;100.00%;0.00%;0.00%=
;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
3;fio-2.1.10;sdaa;0;0;3913728;196620;192;19905;0;0;0.000000;0.000000;4835;9=
543;5203.414596;282.073042;1.000000%=3D4896;5.000000%=3D4896;10.000000%=3D4=
960;20.000000%=3D4960;30.000000%=3D4960;40.000000%=3D5024;50.000000%=3D5280=
;60.000000%=3D5344;70.000000%=3D5344;80.000000%=3D5408;90.000000%=3D5472;95=
.000000%=3D5536;99.000000%=3D5536;99.500000%=3D5920;99.900000%=3D9280;99.95=
0000%=3D9536;99.990000%=3D9536;0%=3D0;0%=3D0;0%=3D0;4836;9543;5203.836254;2=
82.086563;187665;206023;100.000000%;196695.435897;7344.748539;0;0;0;0;0;0;0=
.000000;0.000000;0;0;0.000000;0.000000;1.000000%=3D0;5.000000%=3D0;10.00000=
0%=3D0;20.000000%=3D0;30.000000%=3D0;40.000000%=3D0;50.000000%=3D0;60.00000=
0%=3D0;70.000000%=3D0;80.000000%=3D0;90.000000%=3D0;95.000000%=3D0;99.00000=
0%=3D0;99.500000%=3D0;99.900000%=3D0;99.950000%=3D0;99.990000%=3D0;0%=3D0;0=
%=3D0;0%=3D0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;0.110525=
%;1.914092%;4106;0;288;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.00%;0.0=
0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;100.00%;0.00%;0.00=
%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
3;fio-2.1.10;sdaa;0;0;5872640;196356;191;29908;0;0;0.000000;0.000000;4835;4=
4944;5210.319038;585.202403;1.000000%=3D4896;5.000000%=3D4896;10.000000%=3D=
4960;20.000000%=3D4960;30.000000%=3D4960;40.000000%=3D5088;50.000000%=3D528=
0;60.000000%=3D5344;70.000000%=3D5344;80.000000%=3D5408;90.000000%=3D5472;9=
5.000000%=3D5536;99.000000%=3D5536;99.500000%=3D5792;99.900000%=3D9152;99.9=
50000%=3D9536;99.990000%=3D44800;0%=3D0;0%=3D0;0%=3D0;4836;44945;5210.72646=
4;585.217778;185256;206023;100.000000%;196535.135593;7198.734852;0;0;0;0;0;=
0;0.000000;0.000000;0;0;0.000000;0.000000;1.000000%=3D0;5.000000%=3D0;10.00=
0000%=3D0;20.000000%=3D0;30.000000%=3D0;40.000000%=3D0;50.000000%=3D0;60.00=
0000%=3D0;70.000000%=3D0;80.000000%=3D0;90.000000%=3D0;95.000000%=3D0;99.00=
0000%=3D0;99.500000%=3D0;99.900000%=3D0;99.950000%=3D0;99.990000%=3D0;0%=3D=
0;0%=3D0;0%=3D0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;0.103=
651%;1.895814%;6174;0;288;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.00%;=
0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;99.98%;0.00%;0.=
02%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
^C
fio: terminating on signal 2
3;fio-2.1.10;sdaa;0;0;7492608;196275;191;38174;0;0;0.000000;0.000000;4835;4=
4944;5212.864015;523.029154;1.000000%=3D4896;5.000000%=3D4960;10.000000%=3D=
4960;20.000000%=3D4960;30.000000%=3D5024;40.000000%=3D5088;50.000000%=3D528=
0;60.000000%=3D5344;70.000000%=3D5344;80.000000%=3D5408;90.000000%=3D5472;9=
5.000000%=3D5472;99.000000%=3D5536;99.500000%=3D5792;99.900000%=3D6432;99.9=
50000%=3D9408;99.990000%=3D44800;0%=3D0;0%=3D0;0%=3D0;4836;44945;5213.26636=
6;523.043881;185256;206023;100.000000%;196534.373333;6663.858266;0;0;0;0;0;=
0;0.000000;0.000000;0;0;0.000000;0.000000;1.000000%=3D0;5.000000%=3D0;10.00=
0000%=3D0;20.000000%=3D0;30.000000%=3D0;40.000000%=3D0;50.000000%=3D0;60.00=
0000%=3D0;70.000000%=3D0;80.000000%=3D0;90.000000%=3D0;95.000000%=3D0;99.00=
0000%=3D0;99.500000%=3D0;99.900000%=3D0;99.950000%=3D0;99.990000%=3D0;0%=3D=
0;0%=3D0;0%=3D0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;0.110=
025%;1.888770%;7891;0;288;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.00%;=
0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;99.99%;0.00%;0.=
01%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
<snip ends>

Notice, it seems like  --status-interval does not work at all in the
client-server mode.

So, I would say that there are two problems:

1) --status-interval does not  work in the client server mode

2) Terse output should look the same in both modes

Do you think what I say is reasonable?..

Thanks,
Vasily

On Thu, Jul 10, 2014 at 4:48 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-07-09 16:21, Vasily Tarasov wrote:
>>
>> Hi All,
>>
>> When I run fio as a standalone application (without using a
>> server-client model) and use terse output format, disk utilization is
>> never printed. Here are the results of my analysis:
>>
>> 1) show_thread_status_terse_v2() does not call show_disk_util() at all.
>>
>> 2) show_thread_status_terse_v3_v4() does call show_disk_util(), but
>> only if is_backend variable is true (which is not, in case of a
>> standalone run).
>>
>> 3) __show_run_stats() call show_disk_util() only in case of
>> FIO_OUTPUT_JSON or FIO_OUTPUT_NORMAL formats.
>>
>> There are several ways to fix this issue. I think the best way is to
>> call show_disk_util() from __show_run_stats() in case of terse format.
>> This will break the current terse format: disk utilization fields will
>> be printed in the end of the lines (after thread statistics), which is
>> not how the HOWTO defines it. But, it seems like the v2 format is
>> already inconsistent with HOWTO. And for v3 format, if client-server
>> model is used, disk utilization fields will be printed in the end of
>> the terse line anyway (at least this is my current understanding of
>> the code). So, what I suggest will bring consistency accross
>> client-server and standalone runs. We will also need to fix HOWTO.
>>
>> Let me know what is the best way to fix this, and I'll be happy to send =
a
>> patch.
>
>
> Seems like the is_backend check in _v3_v4 should just go. Can't come up w=
ith
> a good reason why that is there, it already knows if it should do json
> output, or normal output (and in terse format, if asked).
>
> --
> Jens Axboe
>

