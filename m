Return-Path: <jcagle@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20090620062702.GI31415@kernel.dk>
References: <7efa8a7d0906191519l5b268430o3ec4c96e60dfcb7a@mail.gmail.com>
	 <20090620062702.GI31415@kernel.dk>
Date: Sat, 20 Jun 2009 08:21:46 -0500
Message-ID: <6863f0c90906200621l48000095xc46ef1fbcfc159d8@mail.gmail.com>
Subject: Re: Ques on FIO output (how to interpret iops)
From: John Cagle <jcagle@gmail.com>
Content-Type: multipart/alternative; boundary=0016364ee4a8d5c31c046cc785f7
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Learner Study <learner.study@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--0016364ee4a8d5c31c046cc785f7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Sat, Jun 20, 2009 at 1:27 AM, Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Jun 19 2009, Learner Study wrote:
> > Hi:
> >
> > How do I calculate total IOPS done by different FIO threads/jobs?
> >
> > Following is output from FIO (with two threads)...
> >
> > Each thread shows "bw" and "iops" numbers. Towards the end of output log,
> > there is "aggrb" which is sum of individual "bw" of threads, but "io"
> field
> > (3 line from the bottom of output below) doesn't seem to be sum of
> > individual thread iops....
> >
> > For example, Thread_1 has bw: 15k iops: 29366
> > Thread_2 has bw: 15k iops: 29445
> > But, the summary towards the end (third line from bottom of output), says
> > "io=1,723MiB, aggrb=30,105KiB/s".
> >
> > In this aggrb is good but io doesn't match up (it should be 58781) ! Can
> > someone please educate what am I missing?
>
> Can you try a newer version? If the problem is still there, the best way
> to get it fixed is to send my a simple job file that reproduces the
> problem, and then I can easily fix it for you.
>

I thought the "io=" summary at the end was the total amount of I/O performed
(in megabytes), not the total number of IOPS.

What were your block size and length of run for the example?

John

--0016364ee4a8d5c31c046cc785f7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 20, 2009 at 1:27 AM, Jens Axboe <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jens.axboe@oracle.com">jens.axboe@oracle.com</a>&gt;</span> wrot=
e:<br><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D=
"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padd=
ing-left: 1ex;">
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
O performed (in megabytes), not the total number of IOPS.<br>
<br>
What were your block size and length of run for the example?<br><br>John<br=
>

--0016364ee4a8d5c31c046cc785f7--


