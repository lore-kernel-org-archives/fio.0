Return-Path: <learner.study@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5048B694-088C-4C4A-B53A-95E250C004A5@kernel.dk>
References: <7efa8a7d0906191519l5b268430o3ec4c96e60dfcb7a@mail.gmail.com>
	 <20090620062702.GI31415@kernel.dk>
	 <6863f0c90906200621l48000095xc46ef1fbcfc159d8@mail.gmail.com>
	 <5048B694-088C-4C4A-B53A-95E250C004A5@kernel.dk>
Date: Sat, 20 Jun 2009 13:38:03 -0700
Message-ID: <7efa8a7d0906201338n7a70dc03y67cb956e5da5e765@mail.gmail.com>
Subject: Re: Ques on FIO output (how to interpret iops)
From: Learner Study <learner.study@gmail.com>
Content-Type: multipart/alternative; boundary=0016e644d02c1f0ad5046ccd9e05
To: Jens Axboe <axboe@kernel.dk>
Cc: John Cagle <jcagle@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--0016e644d02c1f0ad5046ccd9e05
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

runtime = 60 and blocksize=512

The exact cmd is:
./fio --name=global --runtime=60 --rw=read --bs=512 --direct=1
--ioengine=aio --iodepth=4000 --loops=100 --name=job1 --filename=/dev/sdb
--name=job2 --filename=/dev/sdb

Thanks!


On Sat, Jun 20, 2009 at 7:12 AM, Jens Axboe <axboe@kernel.dk> wrote:

> On 20/06/2009, at 15.21, John Cagle <jcagle@gmail.com> wrote:
>
> On Sat, Jun 20, 2009 at 1:27 AM, Jens Axboe < <jens.axboe@oracle.com>
> jens.axboe@oracle.com> wrote:
>
>> On Fri, Jun 19 2009, Learner Study wrote:
>> > Hi:
>> >
>> > How do I calculate total IOPS done by different FIO threads/jobs?
>> >
>> > Following is output from FIO (with two threads)...
>> >
>> > Each thread shows "bw" and "iops" numbers. Towards the end of output
>> log,
>> > there is "aggrb" which is sum of individual "bw" of threads, but "io"
>> field
>> > (3 line from the bottom of output below) doesn't seem to be sum of
>> > individual thread iops....
>> >
>> > For example, Thread_1 has bw: 15k iops: 29366
>> > Thread_2 has bw: 15k iops: 29445
>> > But, the summary towards the end (third line from bottom of output),
>> says
>> > "io=1,723MiB, aggrb=30,105KiB/s".
>> >
>> > In this aggrb is good but io doesn't match up (it should be 58781) ! Can
>> > someone please educate what am I missing?
>>
>> Can you try a newer version? If the problem is still there, the best way
>> to get it fixed is to send my a simple job file that reproduces the
>> problem, and then I can easily fix it for you.
>>
>
> I thought the "io=" summary at the end was the total amount of I/O
> performed (in megabytes), not the total number of IOPS.
>
>
> It is, you are correct. Seems I misread the problem.
>

--0016e644d02c1f0ad5046ccd9e05
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

runtime =3D 60 and blocksize=3D512<br>
<br>
The exact cmd is:<br>
./fio --name=3Dglobal --runtime=3D60 --rw=3Dread --bs=3D512 --direct=3D1
--ioengine=3Daio --iodepth=3D4000 --loops=3D100 --name=3Djob1
--filename=3D/dev/sdb --name=3Djob2 --filename=3D/dev/sdb<br>
<br>
Thanks!<br>
<br><br><div class=3D"gmail_quote">On Sat, Jun 20, 2009 at 7:12 AM, Jens Ax=
boe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.d=
k</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"borde=
r-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-le=
ft: 1ex;">
<div bgcolor=3D"#FFFFFF"><div><div></div><div class=3D"h5"><div><span>On 20=
/06/2009, at 15.21, John Cagle &lt;<a href=3D"mailto:jcagle@gmail.com" targ=
et=3D"_blank">jcagle@gmail.com</a>&gt; wrote:</span><br></div><div><br></di=
v><div>
</div><blockquote type=3D"cite"><div>On Sat, Jun 20, 2009 at 1:27 AM, Jens =
Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:jens.axboe@oracle.com" target=
=3D"_blank"></a><a href=3D"mailto:jens.axboe@oracle.com" target=3D"_blank">=
jens.axboe@oracle.com</a>&gt;</span> wrote:<br>
<div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"borde=
r-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-le=
ft: 1ex;">
On Fri, Jun 19 2009, Learner Study wrote:<br>
&gt; Hi:<br>
&gt;<br>
&gt; How do I calculate total IOPS done by different FIO threads/jobs?<br>
&gt;<br>
&gt; Following is output from FIO (with two threads)...<br>
&gt;<br>
&gt; Each thread shows &quot;bw&quot; and &quot;iops&quot; numbers. Towards=
 the end of output log,<br>
&gt; there is &quot;aggrb&quot; which is sum of individual &quot;bw&quot; o=
f threads, but &quot;io&quot; field<br>
&gt; (3 line from the bottom of output below) doesn&#39;t seem to be sum of=
<br>
&gt; individual thread iops....<br>
&gt;<br>
&gt; For example, Thread_1 has bw: 15k iops: 29366<br>
&gt; Thread_2 has bw: 15k iops: 29445<br>
&gt; But, the summary towards the end (third line from bottom of output), s=
ays<br>
&gt; &quot;io=3D1,723MiB, aggrb=3D30,105KiB/s&quot;.<br>
&gt;<br>
&gt; In this aggrb is good but io doesn&#39;t match up (it should be 58781)=
 ! Can<br>
&gt; someone please educate what am I missing?<br>
<br>
Can you try a newer version? If the problem is still there, the best way<br=
>
to get it fixed is to send my a simple job file that reproduces the<br>
problem, and then I can easily fix it for you.<br></blockquote></div><br>I =
thought the &quot;io=3D&quot; summary at the end was the total amount of I/=
O performed (in megabytes), not the total number of IOPS.<br></div></blockq=
uote>
<div><br></div></div></div>It is, you are correct. Seems I misread the prob=
lem.<br></div></blockquote></div><br>

--0016e644d02c1f0ad5046ccd9e05--


