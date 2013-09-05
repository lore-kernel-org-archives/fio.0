Return-Path: <brianclam@gmail.com>
References: <20130905151559.GG32553@wattwurm.rz.uni-ulm.de> <5228DDC8.9070201@kernel.dk>
Mime-Version: 1.0 (1.0)
In-Reply-To: <5228DDC8.9070201@kernel.dk>
Content-Type: multipart/alternative;
	boundary=Apple-Mail-9666B5FB-05B8-429D-B0CE-39D324CDA77C
Content-Transfer-Encoding: 7bit
Message-Id: <99ACE6A4-9A15-4084-BEF8-1E4ABF274023@gmail.com>
From: "Brian L." <brianclam@gmail.com>
Subject: Re: Invalid argument error (EINVAL) on Lustre filesystem with ioengine=libaio enabled
Date: Thu, 5 Sep 2013 13:01:23 -0700
To: Jens Axboe <axboe@kernel.dk>
Cc: Juergen Salk <juergen.salk@uni-ulm.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


--Apple-Mail-9666B5FB-05B8-429D-B0CE-39D324CDA77C
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable

I experienced an error when trying to use libaio on local disks, eg /dev/sdb=
. I will check when I get back to my desk to see if it is similiar to your e=
rror.  I vaguely remember getting a segfault so I am not sure if they are re=
lated.=20

Brian L.

On Sep 5, 2013, at 12:38 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 09/05/2013 09:15 AM, Juergen Salk wrote:
>> Hi,
>>=20
>> I tried to run fio on a Lustre filesystem with ioengine=3Dlibaio enabled:=

>>=20
>> $ ../tools/fio/2.1.2/bin/fio seqwrite.fio=20
>> sequential_write: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M/1M-1M, ioengine=3D=
libaio, iodepth=3D32
>> fio-2.1.2
>> Starting 1 process
>> fio: pid=3D31956, err=3D22/file:ioengines.c:381, func=3Dio commit, error=3D=
Invalid argument
>>=20
>> sequential_write: (groupid=3D0, jobs=3D1): err=3D22 (file:ioengines.c:381=
, func=3Dio commit, error=3DInvalid argument): pid=3D31956: Thu Sep  5 16:43=
:56 2013
>>  cpu          : usr=3D0.00%, sys=3D100.00%, ctx=3D23, majf=3D0, minf=3D49=

>>  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
>>     submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
>>     complete  : 0=3D100.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%
>>     issued    : total=3Dr=3D0/w=3D1/d=3D0, short=3Dr=3D0/w=3D0/d=3D0
>>=20
>> Run status group 0 (all jobs):
>>=20
>> This is the content of the job file:
>>=20
>> --- snip ---
>>=20
>> [global]
>> ioengine=3Dlibaio
>> # ioengine=3Dsync
>> iodepth=3D32
>> direct=3D1
>> invalidate=3D1
>> filename_format=3Dfile.$jobnum
>> group_reporting
>> bs=3D1024k
>> size=3D1g
>> numjobs=3D1
>> directory=3D/scratch1/ws/jsalk-bench-0
>>=20
>> [sequential_write]
>> rw=3Dwrite
>>=20
>> --- snip ---
>>=20
>> It works with ioengine=3Dsync, though. It also works on the same machine
>> with ioengine=3Dlibaio enabled but with the work directory located on a
>> locally attached disk (with ext3 file system).
>>=20
>> An strace log is attached. Are there any ideas of what might be
>> causing this problem on Lustre?
>=20
> I'm guessing that lustre doesn't support async IO, though I have never
> tried it myself. =46rom the error out of fio and the strace, io_submit()
> is returning EINVAL. The context id is valid, fio is submitting 1 iocb,
> and the opcode is a read operation on fd 3 - all of which are good.
>=20
> --=20
> Jens Axboe
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Apple-Mail-9666B5FB-05B8-429D-B0CE-39D324CDA77C
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=3D=
utf-8"></head><body dir=3D"auto"><div><span style=3D"font-family: '.Helvetic=
a NeueUI'; font-size: 15px; -webkit-tap-highlight-color: rgba(26, 26, 26, 0.=
296875); -webkit-composition-fill-color: rgba(175, 192, 227, 0.230469); -web=
kit-composition-frame-color: rgba(77, 128, 180, 0.230469); ">I experienced a=
n error when trying to use libaio on local disks, eg /dev/sdb. I will check w=
hen I get back to my desk to see if it is similiar to your error. &nbsp;I va=
guely remember getting a segfault so I am not sure if they are related.&nbsp=
;</span><br><br>Brian L.</div><div><br>On Sep 5, 2013, at 12:38 PM, Jens Axb=
oe &lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br>=
<br></div><blockquote type=3D"cite"><div><span>On 09/05/2013 09:15 AM, Juerg=
en Salk wrote:</span><br><blockquote type=3D"cite"><span>Hi,</span><br></blo=
ckquote><blockquote type=3D"cite"><span></span><br></blockquote><blockquote t=
ype=3D"cite"><span>I tried to run fio on a Lustre filesystem with ioengine=3D=
libaio enabled:</span><br></blockquote><blockquote type=3D"cite"><span></spa=
n><br></blockquote><blockquote type=3D"cite"><span>$ ../tools/fio/2.1.2/bin/=
fio seqwrite.fio </span><br></blockquote><blockquote type=3D"cite"><span>seq=
uential_write: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M/1M-1M, ioengine=3Dlibai=
o, iodepth=3D32</span><br></blockquote><blockquote type=3D"cite"><span>fio-2=
.1.2</span><br></blockquote><blockquote type=3D"cite"><span>Starting 1 proce=
ss</span><br></blockquote><blockquote type=3D"cite"><span>fio: pid=3D31956, e=
rr=3D22/file:ioengines.c:381, func=3Dio commit, error=3DInvalid argument</sp=
an><br></blockquote><blockquote type=3D"cite"><span></span><br></blockquote>=
<blockquote type=3D"cite"><span>sequential_write: (groupid=3D0, jobs=3D1): e=
rr=3D22 (file:ioengines.c:381, func=3Dio commit, error=3DInvalid argument): p=
id=3D31956: Thu Sep &nbsp;5 16:43:56 2013</span><br></blockquote><blockquote=
 type=3D"cite"><span> &nbsp;cpu &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;: usr=3D0.00%, sys=3D100.00%, ctx=3D23, majf=3D0, minf=3D49</span>=
<br></blockquote><blockquote type=3D"cite"><span> &nbsp;IO depths &nbsp;&nbs=
p;&nbsp;: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, &g=
t;=3D64=3D0.0%</span><br></blockquote><blockquote type=3D"cite"><span> &nbsp=
;&nbsp;&nbsp;&nbsp;submit &nbsp;&nbsp;&nbsp;: 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 1=
6=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%</span><br></blockquote><blo=
ckquote type=3D"cite"><span> &nbsp;&nbsp;&nbsp;&nbsp;complete &nbsp;: 0=3D10=
0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%<=
/span><br></blockquote><blockquote type=3D"cite"><span> &nbsp;&nbsp;&nbsp;&n=
bsp;issued &nbsp;&nbsp;&nbsp;: total=3Dr=3D0/w=3D1/d=3D0, short=3Dr=3D0/w=3D=
0/d=3D0</span><br></blockquote><blockquote type=3D"cite"><span></span><br></=
blockquote><blockquote type=3D"cite"><span>Run status group 0 (all jobs):</s=
pan><br></blockquote><blockquote type=3D"cite"><span></span><br></blockquote=
><blockquote type=3D"cite"><span>This is the content of the job file:</span>=
<br></blockquote><blockquote type=3D"cite"><span></span><br></blockquote><bl=
ockquote type=3D"cite"><span>--- snip ---</span><br></blockquote><blockquote=
 type=3D"cite"><span></span><br></blockquote><blockquote type=3D"cite"><span=
>[global]</span><br></blockquote><blockquote type=3D"cite"><span>ioengine=3D=
libaio</span><br></blockquote><blockquote type=3D"cite"><span># ioengine=3Ds=
ync</span><br></blockquote><blockquote type=3D"cite"><span>iodepth=3D32</spa=
n><br></blockquote><blockquote type=3D"cite"><span>direct=3D1</span><br></bl=
ockquote><blockquote type=3D"cite"><span>invalidate=3D1</span><br></blockquo=
te><blockquote type=3D"cite"><span>filename_format=3Dfile.$jobnum</span><br>=
</blockquote><blockquote type=3D"cite"><span>group_reporting</span><br></blo=
ckquote><blockquote type=3D"cite"><span>bs=3D1024k</span><br></blockquote><b=
lockquote type=3D"cite"><span>size=3D1g</span><br></blockquote><blockquote t=
ype=3D"cite"><span>numjobs=3D1</span><br></blockquote><blockquote type=3D"ci=
te"><span>directory=3D/scratch1/ws/jsalk-bench-0</span><br></blockquote><blo=
ckquote type=3D"cite"><span></span><br></blockquote><blockquote type=3D"cite=
"><span>[sequential_write]</span><br></blockquote><blockquote type=3D"cite">=
<span>rw=3Dwrite</span><br></blockquote><blockquote type=3D"cite"><span></sp=
an><br></blockquote><blockquote type=3D"cite"><span>--- snip ---</span><br><=
/blockquote><blockquote type=3D"cite"><span></span><br></blockquote><blockqu=
ote type=3D"cite"><span>It works with ioengine=3Dsync, though. It also works=
 on the same machine</span><br></blockquote><blockquote type=3D"cite"><span>=
with ioengine=3Dlibaio enabled but with the work directory located on a</spa=
n><br></blockquote><blockquote type=3D"cite"><span>locally attached disk (wi=
th ext3 file system).</span><br></blockquote><blockquote type=3D"cite"><span=
></span><br></blockquote><blockquote type=3D"cite"><span>An strace log is at=
tached. Are there any ideas of what might be</span><br></blockquote><blockqu=
ote type=3D"cite"><span>causing this problem on Lustre?</span><br></blockquo=
te><span></span><br><span>I'm guessing that lustre doesn't support async IO,=
 though I have never</span><br><span>tried it myself. =46rom the error out o=
f fio and the strace, io_submit()</span><br><span>is returning EINVAL. The c=
ontext id is valid, fio is submitting 1 iocb,</span><br><span>and the opcode=
 is a read operation on fd 3 - all of which are good.</span><br><span></span=
><br><span>-- </span><br><span>Jens Axboe</span><br><span></span><br><span>-=
-</span><br><span>To unsubscribe from this list: send the line "unsubscribe f=
io" in</span><br><span>the body of a message to <a href=3D"mailto:majordomo@=
vger.kernel.org">majordomo@vger.kernel.org</a></span><br><span>More majordom=
o info at &nbsp;<a href=3D"http://vger.kernel.org/majordomo-info.html">http:=
//vger.kernel.org/majordomo-info.html</a></span><br></div></blockquote></bod=
y></html>=

--Apple-Mail-9666B5FB-05B8-429D-B0CE-39D324CDA77C--


