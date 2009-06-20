Return-Path: <axboe@kernel.dk>
References: <7efa8a7d0906191519l5b268430o3ec4c96e60dfcb7a@mail.gmail.com> <20090620062702.GI31415@kernel.dk> <6863f0c90906200621l48000095xc46ef1fbcfc159d8@mail.gmail.com>
Message-Id: <5048B694-088C-4C4A-B53A-95E250C004A5@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6863f0c90906200621l48000095xc46ef1fbcfc159d8@mail.gmail.com>
Content-Type: multipart/alternative;
	boundary=Apple-Mail-1-911991842
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: Ques on FIO output (how to interpret iops)
Date: Sat, 20 Jun 2009 16:12:43 +0200
To: John Cagle <jcagle@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Learner Study <learner.study@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


--Apple-Mail-1-911991842
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

On 20/06/2009, at 15.21, John Cagle <jcagle@gmail.com> wrote:

> On Sat, Jun 20, 2009 at 1:27 AM, Jens Axboe <jens.axboe@oracle.com>  
> wrote:
> On Fri, Jun 19 2009, Learner Study wrote:
> > Hi:
> >
> > How do I calculate total IOPS done by different FIO threads/jobs?
> >
> > Following is output from FIO (with two threads)...
> >
> > Each thread shows "bw" and "iops" numbers. Towards the end of  
> output log,
> > there is "aggrb" which is sum of individual "bw" of threads, but  
> "io" field
> > (3 line from the bottom of output below) doesn't seem to be sum of
> > individual thread iops....
> >
> > For example, Thread_1 has bw: 15k iops: 29366
> > Thread_2 has bw: 15k iops: 29445
> > But, the summary towards the end (third line from bottom of  
> output), says
> > "io=1,723MiB, aggrb=30,105KiB/s".
> >
> > In this aggrb is good but io doesn't match up (it should be  
> 58781) ! Can
> > someone please educate what am I missing?
>
> Can you try a newer version? If the problem is still there, the best  
> way
> to get it fixed is to send my a simple job file that reproduces the
> problem, and then I can easily fix it for you.
>
> I thought the "io=" summary at the end was the total amount of I/O  
> performed (in megabytes), not the total number of IOPS.

It is, you are correct. Seems I misread the problem.

--Apple-Mail-1-911991842
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: 7bit

<html><body bgcolor="#FFFFFF"><div><span class="Apple-style-span" style="-webkit-tap-highlight-color: rgba(26, 26, 26, 0.296875); -webkit-composition-fill-color: rgba(175, 192, 227, 0.230469); -webkit-composition-frame-color: rgba(77, 128, 180, 0.230469); ">On 20/06/2009, at 15.21, John Cagle &lt;<a href="mailto:jcagle@gmail.com">jcagle@gmail.com</a>&gt; wrote:</span><br></div><div><br></div><div></div><blockquote type="cite"><div>On Sat, Jun 20, 2009 at 1:27 AM, Jens Axboe <span dir="ltr">&lt;<a href="mailto:jens.axboe@oracle.com"><a href="mailto:jens.axboe@oracle.com">jens.axboe@oracle.com</a></a>&gt;</span> wrote:<br><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On Fri, Jun 19 2009, Learner Study wrote:<br>
&gt; Hi:<br>
&gt;<br>
&gt; How do I calculate total IOPS done by different FIO threads/jobs?<br>
&gt;<br>
&gt; Following is output from FIO (with two threads)...<br>
&gt;<br>
&gt; Each thread shows "bw" and "iops" numbers. Towards the end of output log,<br>
&gt; there is "aggrb" which is sum of individual "bw" of threads, but "io" field<br>
&gt; (3 line from the bottom of output below) doesn't seem to be sum of<br>
&gt; individual thread iops....<br>
&gt;<br>
&gt; For example, Thread_1 has bw: 15k iops: 29366<br>
&gt; Thread_2 has bw: 15k iops: 29445<br>
&gt; But, the summary towards the end (third line from bottom of output), says<br>
&gt; "io=1,723MiB, aggrb=30,105KiB/s".<br>
&gt;<br>
&gt; In this aggrb is good but io doesn't match up (it should be 58781) ! Can<br>
&gt; someone please educate what am I missing?<br>
<br>
Can you try a newer version? If the problem is still there, the best way<br>
to get it fixed is to send my a simple job file that reproduces the<br>
problem, and then I can easily fix it for you.<br></blockquote></div><br>I thought the "io=" summary at the end was the total amount of I/O performed (in megabytes), not the total number of IOPS.<br></div></blockquote><div><br></div>It is, you are correct. Seems I misread the problem.<br></body></html>
--Apple-Mail-1-911991842--


