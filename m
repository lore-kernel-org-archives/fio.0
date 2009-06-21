Return-Path: <jcagle@gmail.com>
MIME-Version: 1.0
In-Reply-To: <7efa8a7d0906202215s581f4f17t14afaac9f7aea2e6@mail.gmail.com>
References: <7efa8a7d0906191519l5b268430o3ec4c96e60dfcb7a@mail.gmail.com>
	 <20090620062702.GI31415@kernel.dk>
	 <6863f0c90906200621l48000095xc46ef1fbcfc159d8@mail.gmail.com>
	 <5048B694-088C-4C4A-B53A-95E250C004A5@kernel.dk>
	 <7efa8a7d0906201338n7a70dc03y67cb956e5da5e765@mail.gmail.com>
	 <7efa8a7d0906201417x4b3d3c76o91b52627da1e623c@mail.gmail.com>
	 <6863f0c90906202031h54c9f74bwdb09ca084d05ddfa@mail.gmail.com>
	 <7efa8a7d0906202215s581f4f17t14afaac9f7aea2e6@mail.gmail.com>
Date: Sun, 21 Jun 2009 07:30:06 -0500
Message-ID: <6863f0c90906210530u369cbd43g47359b384a2d36b6@mail.gmail.com>
Subject: Re: Ques on FIO output (how to interpret iops)
From: John Cagle <jcagle@gmail.com>
Content-Type: multipart/alternative; boundary=0016360e3b3ce62147046cdaea0d
To: Learner Study <learner.study@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--0016360e3b3ce62147046cdaea0d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Probably.  Give it a try.

On Sun, Jun 21, 2009 at 12:15 AM, Learner Study <learner.study@gmail.com>wrote:

> I'm using 1.24 version - does latest 1.27 fix this issue?
>
> Thanks!
>
>
> On Sat, Jun 20, 2009 at 8:31 PM, John Cagle <jcagle@gmail.com> wrote:
>
>> Actually, 1KiB is 1024 bytes, but you're right -- the io values and the
>> aggrb values don't seem to agree.
>>
>> What version of fio are you using?  There was a bug in one of the earlier
>> version (around 1.24 or 1.25) where it was using 1000 instead of 1024 when
>> doing some calculations.
>>
>> John
>>
>>
>> On Sat, Jun 20, 2009 at 4:17 PM, Learner Study <learner.study@gmail.com>wrote:
>>
>>> The summary says, io=1,723MiB, aggrb=30,105KiB/s
>>>
>>> So, aggrb = io/runtime => 1723/60 => 28.716 => 28, 716 KiB/s (assuming
>>> 1KiB = 1000 B)....still != aggrb shown in the result...
>>>
>>> Thanks!
>>>
>>>
>>>
>>> On Sat, Jun 20, 2009 at 1:38 PM, Learner Study <learner.study@gmail.com>wrote:
>>>
>>>> runtime = 60 and blocksize=512
>>>>
>>>> The exact cmd is:
>>>> ./fio --name=global --runtime=60 --rw=read --bs=512 --direct=1
>>>> --ioengine=aio --iodepth=4000 --loops=100 --name=job1 --filename=/dev/sdb
>>>> --name=job2 --filename=/dev/sdb
>>>>
>>>> Thanks!
>>>>
>>>>
>>>>
>>>> On Sat, Jun 20, 2009 at 7:12 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>>> On 20/06/2009, at 15.21, John Cagle <jcagle@gmail.com> wrote:
>>>>>
>>>>> On Sat, Jun 20, 2009 at 1:27 AM, Jens Axboe < <jens.axboe@oracle.com>
>>>>> jens.axboe@oracle.com> wrote:
>>>>>
>>>>>> On Fri, Jun 19 2009, Learner Study wrote:
>>>>>> > Hi:
>>>>>> >
>>>>>> > How do I calculate total IOPS done by different FIO threads/jobs?
>>>>>> >
>>>>>> > Following is output from FIO (with two threads)...
>>>>>> >
>>>>>> > Each thread shows "bw" and "iops" numbers. Towards the end of output
>>>>>> log,
>>>>>> > there is "aggrb" which is sum of individual "bw" of threads, but
>>>>>> "io" field
>>>>>> > (3 line from the bottom of output below) doesn't seem to be sum of
>>>>>> > individual thread iops....
>>>>>> >
>>>>>> > For example, Thread_1 has bw: 15k iops: 29366
>>>>>> > Thread_2 has bw: 15k iops: 29445
>>>>>> > But, the summary towards the end (third line from bottom of output),
>>>>>> says
>>>>>> > "io=1,723MiB, aggrb=30,105KiB/s".
>>>>>> >
>>>>>> > In this aggrb is good but io doesn't match up (it should be 58781) !
>>>>>> Can
>>>>>> > someone please educate what am I missing?
>>>>>>
>>>>>> Can you try a newer version? If the problem is still there, the best
>>>>>> way
>>>>>> to get it fixed is to send my a simple job file that reproduces the
>>>>>> problem, and then I can easily fix it for you.
>>>>>>
>>>>>
>>>>> I thought the "io=" summary at the end was the total amount of I/O
>>>>> performed (in megabytes), not the total number of IOPS.
>>>>>
>>>>>
>>>>> It is, you are correct. Seems I misread the problem.
>>>>>
>>>>
>>>>
>>>
>>
>

--0016360e3b3ce62147046cdaea0d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Probably.=A0 Give it a try.<br><br><div class=3D"gmail_quote">On Sun, Jun 2=
1, 2009 at 12:15 AM, Learner Study <span dir=3D"ltr">&lt;<a href=3D"mailto:=
learner.study@gmail.com">learner.study@gmail.com</a>&gt;</span> wrote:<br><=
blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 2=
04, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I&#39;m using 1.24 version - does latest 1.27 fix this issue?<br><br>Thanks=
!<div><div></div><div class=3D"h5"><br><br><div class=3D"gmail_quote">On Sa=
t, Jun 20, 2009 at 8:31 PM, John Cagle <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:jcagle@gmail.com" target=3D"_blank">jcagle@gmail.com</a>&gt;</span> wro=
te:<br>

<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Actually, 1KiB is=
 1024 bytes, but you&#39;re right -- the io values and the aggrb values don=
&#39;t seem to agree.<br>

<br>What version of fio are you using?=A0 There was a bug in one of the ear=
lier version (around 1.24 or 1.25) where it was using 1000 instead of 1024 =
when doing some calculations.<br><font color=3D"#888888">
<br>John</font><div><div></div><div><br><br><div class=3D"gmail_quote">On S=
at, Jun 20, 2009 at 4:17 PM, Learner Study <span dir=3D"ltr">&lt;<a href=3D=
"mailto:learner.study@gmail.com" target=3D"_blank">learner.study@gmail.com<=
/a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
The summary says, io=3D1,723MiB, aggrb=3D30,105KiB/s<br><br>So, aggrb =3D i=
o/runtime =3D&gt; 1723/60 =3D&gt; 28.716 =3D&gt; 28, 716 KiB/s (assuming 1K=
iB =3D 1000 B)....still !=3D aggrb shown in the result...<br><br>Thanks!<di=
v><div></div>


<div><br><br><br><div class=3D"gmail_quote">
On Sat, Jun 20, 2009 at 1:38 PM, Learner Study <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:learner.study@gmail.com" target=3D"_blank">learner.study@gmail.=
com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"bor=
der-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-=
left: 1ex;">



runtime =3D 60 and blocksize=3D512<br>
<br>
The exact cmd is:<br>
./fio --name=3Dglobal --runtime=3D60 --rw=3Dread --bs=3D512 --direct=3D1
--ioengine=3Daio --iodepth=3D4000 --loops=3D100 --name=3Djob1
--filename=3D/dev/sdb --name=3Djob2 --filename=3D/dev/sdb<br>
<br>
Thanks!<div><div></div><div><br>
<br><br><div class=3D"gmail_quote">On Sat, Jun 20, 2009 at 7:12 AM, Jens Ax=
boe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=3D"_bla=
nk">axboe@kernel.dk</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quo=
te" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt=
 0.8ex; padding-left: 1ex;">




<div bgcolor=3D"#FFFFFF"><div><div></div><div><div><span>On 20/06/2009, at =
15.21, John Cagle &lt;<a href=3D"mailto:jcagle@gmail.com" target=3D"_blank"=
>jcagle@gmail.com</a>&gt; wrote:</span><br></div><div><br></div><div>
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
</div></div></blockquote></div><br>
</div></div></blockquote></div><br>
</div></div></blockquote></div><br>
</div></div></blockquote></div><br>

--0016360e3b3ce62147046cdaea0d--


