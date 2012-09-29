Return-Path: <akashv@google.com>
MIME-Version: 1.0
In-Reply-To: <50669495.1080801@kernel.dk>
References: <CAFFT=U=WusZz8z+J93NvS8QEe=4NuDtiHHJ6_KJQ=gLAggdouA@mail.gmail.com>
 <50669495.1080801@kernel.dk>
From: Akash Verma <akashv@google.com>
Date: Sat, 29 Sep 2012 00:32:32 -0700
Message-ID: <CAFFT=U=BbSVnFPYP1D81397OZVNv1Zv-_h69Y1KWS=nSu+x58g@mail.gmail.com>
Subject: Re: Should group_reporting be clumping together different groups?
Content-Type: multipart/alternative; boundary=90e6ba10a6a925175c04cad22ecc
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--90e6ba10a6a925175c04cad22ecc
Content-Type: text/plain; charset=ISO-8859-1

That's odd, because I understood it differently. I have gone through the
HOWTO again to be sure. Please bear with me; I'm copying succeeding lines
from the HOWTO from version 2.0.9:

new_group Start a new reporting group. If this option isn't given,
jobs in a file will be part of the same reporting group
 unless separated by a stone wall (or if it's a group
by itself, with the numjobs option).

numjobs=int Create the specified number of clones of this job. May be
used to setup a larger number of threads/processes doing
 the same thing. We regard that grouping of jobs as a
specific group.

group_reporting If 'numjobs' is set, it may be interesting to display
 statistics for the group as a whole instead of for each
individual job. This is especially true of 'numjobs' is
 large, looking at individual thread/process output quickly
becomes unwieldy. If 'group_reporting' is specified, fio
 will show the final report per-group instead of per-job.

Is it just me? Reading that, I don't see any confusion about the
group_reporting flag being specifically for clumping together results that
would otherwise be discrete for each job clone because of numjobs.

Even here, the description for new_group implies that jobs in a job file
are in the same reporting group, unless <condition 1> and <condition 2>.
But it seems to be the default behavior to not have them in the same
reporting group. For example, I used the file included in the first email,
but without numjobs and group_reporting. Then I get one report for each job.

In my opinion, the current functionality is fine, but the documentation
isn't clear on it.

Thanks,
Akash


On Fri, Sep 28, 2012 at 11:26 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 2012-09-29 04:11, Akash Verma wrote:
> > Let's say I use FIO with the following job file:
> >
> >
> > [group_1]
> > rw=randwrite
> > size=1024k
> > ioengine=libaio
> > time_based=1
> > runtime=10
> > direct=1
> > do_verify=0
> > numjobs=2
> > group_reporting=1
> >
> > [group_2]
> > rw=randread
> > size=1024k
> > ioengine=libaio
> > time_based=1
> > runtime=10
> > direct=1
> > numjobs=2
> > group_reporting=1
> >
> >
> > I get a single report, named after group_1 but actually including
> > results for group_2 as well. Since I'm using group_reporting with
> > numjobs, shouldn't I be getting two reports, one for group_1 and one
> > for group_2?
> >
> > I am able to get the desired functionality using:
> > new_group=1
> > under group_2, causing FIO to specifically treat that group as
> > separate for reporting purposes. However the current behavior still
> > doesn't conform with the description given for both group_reporting
> > and new_group.
>
> Hmm, I think it's perfectly aligned with what is described. The
> documentation states that jobs are part of the same group, except if:
>
> - They are separated by a stone wall, which implies starting a new
>   group.
>
> - or the new_group primitive is used explicitly.
>
> --
> Jens Axboe
>
>

--90e6ba10a6a925175c04cad22ecc
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>That&#39;s odd, because I understood it differently.=A0I have gone thr=
ough the HOWTO again to be sure. Please bear with me; I&#39;m copying succe=
eding lines from the HOWTO from version 2.0.9:</div><div><br></div><div><di=
v>

new_group<span class=3D"" style=3D"white-space:pre">	</span>Start a new rep=
orting group. If this option isn&#39;t given,</div><div><span class=3D"" st=
yle=3D"white-space:pre">		</span>jobs in a file will be part of the same re=
porting group</div>

<div><span class=3D"" style=3D"white-space:pre">		</span>unless separated b=
y a stone wall (or if it&#39;s a group</div><div><span class=3D"" style=3D"=
white-space:pre">		</span>by itself, with the numjobs option).</div><div><b=
r></div>

<div>numjobs=3Dint<span class=3D"" style=3D"white-space:pre">	</span>Create=
 the specified number of clones of this job. May be</div><div><span class=
=3D"" style=3D"white-space:pre">		</span>used to setup a larger number of t=
hreads/processes doing</div>

<div><span class=3D"" style=3D"white-space:pre">		</span>the same thing. We=
 regard that grouping of jobs as a</div><div><span class=3D"" style=3D"whit=
e-space:pre">		</span>specific group.</div><div><br></div><div>group_report=
ing<span class=3D"" style=3D"white-space:pre">	</span>If &#39;numjobs&#39; =
is set, it may be interesting to display</div>

<div><span class=3D"" style=3D"white-space:pre">		</span>statistics for the=
 group as a whole instead of for each</div><div><span class=3D"" style=3D"w=
hite-space:pre">		</span>individual job. This is especially true of &#39;nu=
mjobs&#39; is</div>

<div><span class=3D"" style=3D"white-space:pre">		</span>large, looking at =
individual thread/process output quickly</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>becomes unwieldy. If &#39;group_reporting&#39=
; is specified, fio</div>

<div><span class=3D"" style=3D"white-space:pre">		</span>will show the fina=
l report per-group instead of per-job.</div></div><div><br></div><div>Is it=
 just me? Reading that, I don&#39;t see any confusion about the group_repor=
ting flag being specifically for clumping together results that would other=
wise be discrete for each job clone because of numjobs.</div>

<div><br></div><div>Even here, the description for new_group implies that j=
obs in a job file are in the same reporting group, unless &lt;condition 1&g=
t; and &lt;condition 2&gt;. But it seems to be the default behavior to not =
have them in the same reporting group. For example, I used the file include=
d in the first email, but without numjobs and group_reporting. Then I get o=
ne report for each job.</div>

<div><br></div><div>In my opinion, the current functionality is fine, but t=
he documentation isn&#39;t clear on it.</div><div><br></div><div>Thanks,</d=
iv><div>Akash</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_q=
uote">

On Fri, Sep 28, 2012 at 11:26 PM, Jens Axboe <span dir=3D"ltr">&lt;<a href=
=3D"mailto:axboe@kernel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span=
> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex">

<div class=3D"HOEnZb"><div class=3D"h5">On 2012-09-29 04:11, Akash Verma wr=
ote:<br>
&gt; Let&#39;s say I use FIO with the following job file:<br>
&gt;<br>
&gt;<br>
&gt; [group_1]<br>
&gt; rw=3Drandwrite<br>
&gt; size=3D1024k<br>
&gt; ioengine=3Dlibaio<br>
&gt; time_based=3D1<br>
&gt; runtime=3D10<br>
&gt; direct=3D1<br>
&gt; do_verify=3D0<br>
&gt; numjobs=3D2<br>
&gt; group_reporting=3D1<br>
&gt;<br>
&gt; [group_2]<br>
&gt; rw=3Drandread<br>
&gt; size=3D1024k<br>
&gt; ioengine=3Dlibaio<br>
&gt; time_based=3D1<br>
&gt; runtime=3D10<br>
&gt; direct=3D1<br>
&gt; numjobs=3D2<br>
&gt; group_reporting=3D1<br>
&gt;<br>
&gt;<br>
&gt; I get a single report, named after group_1 but actually including<br>
&gt; results for group_2 as well. Since I&#39;m using group_reporting with<=
br>
&gt; numjobs, shouldn&#39;t I be getting two reports, one for group_1 and o=
ne<br>
&gt; for group_2?<br>
&gt;<br>
&gt; I am able to get the desired functionality using:<br>
&gt; new_group=3D1<br>
&gt; under group_2, causing FIO to specifically treat that group as<br>
&gt; separate for reporting purposes. However the current behavior still<br=
>
&gt; doesn&#39;t conform with the description given for both group_reportin=
g<br>
&gt; and new_group.<br>
<br>
</div></div>Hmm, I think it&#39;s perfectly aligned with what is described.=
 The<br>
documentation states that jobs are part of the same group, except if:<br>
<br>
- They are separated by a stone wall, which implies starting a new<br>
=A0 group.<br>
<br>
- or the new_group primitive is used explicitly.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--90e6ba10a6a925175c04cad22ecc--


