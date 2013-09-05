Return-Path: <brianclam@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5228DDC8.9070201@kernel.dk>
References: <20130905151559.GG32553@wattwurm.rz.uni-ulm.de>
	<5228DDC8.9070201@kernel.dk>
Date: Thu, 5 Sep 2013 13:03:07 -0700
Message-ID: <CAAAK+WUcZycNa7wNc1XcAOEkni1kNKOe=YV2MpCwHKhs54H3hg@mail.gmail.com>
Subject: Re: Invalid argument error (EINVAL) on Lustre filesystem with
 ioengine=libaio enabled
From: "Brian L." <brianclam@gmail.com>
Content-Type: multipart/alternative; boundary=001a11c2a0f421e05a04e5a8690c
To: Jens Axboe <axboe@kernel.dk>
Cc: Juergen Salk <juergen.salk@uni-ulm.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--001a11c2a0f421e05a04e5a8690c
Content-Type: text/plain; charset=ISO-8859-1

I experienced an error when trying to use libaio on local disks, eg /dev/sdb.
I will check when I get back to my desk to see if it is similiar to your
errors.  I vaguely remember getting a segfault so I am not sure if they are
related.

brian

On Thursday, September 5, 2013, Jens Axboe wrote:

> On 09/05/2013 09:15 AM, Juergen Salk wrote:
> > Hi,
> >
> > I tried to run fio on a Lustre filesystem with ioengine=libaio enabled:
> >
> > $ ../tools/fio/2.1.2/bin/fio seqwrite.fio
> > sequential_write: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M,
> ioengine=libaio, iodepth=32
> > fio-2.1.2
> > Starting 1 process
> > fio: pid=31956, err=22/file:ioengines.c:381, func=io commit,
> error=Invalid argument
> >
> > sequential_write: (groupid=0, jobs=1): err=22 (file:ioengines.c:381,
> func=io commit, error=Invalid argument): pid=31956: Thu Sep  5 16:43:56 2013
> >   cpu          : usr=0.00%, sys=100.00%, ctx=23, majf=0, minf=49
> >   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
> >=64=0.0%
> >      submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
> >=64=0.0%
> >      complete  : 0=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
> >=64=0.0%
> >      issued    : total=r=0/w=1/d=0, short=r=0/w=0/d=0
> >
> > Run status group 0 (all jobs):
> >
> > This is the content of the job file:
> >
> > --- snip ---
> >
> > [global]
> > ioengine=libaio
> > # ioengine=sync
> > iodepth=32
> > direct=1
> > invalidate=1
> > filename_format=file.$jobnum
> > group_reporting
> > bs=1024k
> > size=1g
> > numjobs=1
> > directory=/scratch1/ws/jsalk-bench-0
> >
> > [sequential_write]
> > rw=write
> >
> > --- snip ---
> >
> > It works with ioengine=sync, though. It also works on the same machine
> > with ioengine=libaio enabled but with the work directory located on a
> > locally attached disk (with ext3 file system).
> >
> > An strace log is attached. Are there any ideas of what might be
> > causing this problem on Lustre?
>
> I'm guessing that lustre doesn't support async IO, though I have never
> tried it myself. From the error out of fio and the strace, io_submit()
> is returning EINVAL. The context id is valid, fio is submitting 1 iocb,
> and the opcode is a read operation on fd 3 - all of which are good.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org <javascript:;>
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Sent from iPhone

--001a11c2a0f421e05a04e5a8690c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<span style=3D"font-family:&#39;.Helvetica NeueUI&#39;;line-height:normal">=
I experienced an error when trying to use libaio on local disks, eg /dev/sd=
b<span></span>. I will check when I get back to my desk to see if it is sim=
iliar to your errors. =A0I vaguely remember getting a segfault so I am not =
sure if they are related.=A0</span><div>
<font face=3D".Helvetica NeueUI"><span style=3D"line-height:normal"><br></s=
pan></font></div><div><font face=3D".Helvetica NeueUI"><span style=3D"line-=
height:normal">brian<br></span></font><br>On Thursday, September 5, 2013, J=
ens Axboe  wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">On 09/05/2013 09:15 AM, Juergen Salk wrote:<=
br>
&gt; Hi,<br>
&gt;<br>
&gt; I tried to run fio on a Lustre filesystem with ioengine=3Dlibaio enabl=
ed:<br>
&gt;<br>
&gt; $ ../tools/fio/2.1.2/bin/fio seqwrite.fio<br>
&gt; sequential_write: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M/1M-1M, ioengin=
e=3Dlibaio, iodepth=3D32<br>
&gt; fio-2.1.2<br>
&gt; Starting 1 process<br>
&gt; fio: pid=3D31956, err=3D22/file:ioengines.c:381, func=3Dio commit, err=
or=3DInvalid argument<br>
&gt;<br>
&gt; sequential_write: (groupid=3D0, jobs=3D1): err=3D22 (file:ioengines.c:=
381, func=3Dio commit, error=3DInvalid argument): pid=3D31956: Thu Sep =A05=
 16:43:56 2013<br>
&gt; =A0 cpu =A0 =A0 =A0 =A0 =A0: usr=3D0.00%, sys=3D100.00%, ctx=3D23, maj=
f=3D0, minf=3D49<br>
&gt; =A0 IO depths =A0 =A0: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D=
0.0%, 32=3D0.0%, &gt;=3D64=3D0.0%<br>
&gt; =A0 =A0 =A0submit =A0 =A0: 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%<br>
&gt; =A0 =A0 =A0complete =A0: 0=3D100.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%<br>
&gt; =A0 =A0 =A0issued =A0 =A0: total=3Dr=3D0/w=3D1/d=3D0, short=3Dr=3D0/w=
=3D0/d=3D0<br>
&gt;<br>
&gt; Run status group 0 (all jobs):<br>
&gt;<br>
&gt; This is the content of the job file:<br>
&gt;<br>
&gt; --- snip ---<br>
&gt;<br>
&gt; [global]<br>
&gt; ioengine=3Dlibaio<br>
&gt; # ioengine=3Dsync<br>
&gt; iodepth=3D32<br>
&gt; direct=3D1<br>
&gt; invalidate=3D1<br>
&gt; filename_format=3Dfile.$jobnum<br>
&gt; group_reporting<br>
&gt; bs=3D1024k<br>
&gt; size=3D1g<br>
&gt; numjobs=3D1<br>
&gt; directory=3D/scratch1/ws/jsalk-bench-0<br>
&gt;<br>
&gt; [sequential_write]<br>
&gt; rw=3Dwrite<br>
&gt;<br>
&gt; --- snip ---<br>
&gt;<br>
&gt; It works with ioengine=3Dsync, though. It also works on the same machi=
ne<br>
&gt; with ioengine=3Dlibaio enabled but with the work directory located on =
a<br>
&gt; locally attached disk (with ext3 file system).<br>
&gt;<br>
&gt; An strace log is attached. Are there any ideas of what might be<br>
&gt; causing this problem on Lustre?<br>
<br>
I&#39;m guessing that lustre doesn&#39;t support async IO, though I have ne=
ver<br>
tried it myself. From the error out of fio and the strace, io_submit()<br>
is returning EINVAL. The context id is valid, fio is submitting 1 iocb,<br>
and the opcode is a read operation on fd 3 - all of which are good.<br>
<br>
--<br>
Jens Axboe<br>
<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe fio&quot; in=
<br>
the body of a message to <a href=3D"javascript:;" onclick=3D"_e(event, &#39=
;cvml&#39;, &#39;majordomo@vger.kernel.org&#39;)">majordomo@vger.kernel.org=
</a><br>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.=
html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</blockquote></div><br><br>-- <br>Sent from iPhone<br>

--001a11c2a0f421e05a04e5a8690c--


