Return-Path: <brianjamesarb@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130123182100.GC30268@kernel.dk>
References: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
	<20130111091010.GA32674@kernel.dk>
	<50F12401.8090606@kernel.dk>
	<CABYizFLj4LSJApybuRfUfCiuqhVNac0T733BcMnpUOAivWhi7A@mail.gmail.com>
	<20130118204040.GT3571@kernel.dk>
	<20130121212925.GA1300@kernel.dk>
	<20130123182100.GC30268@kernel.dk>
Date: Wed, 23 Jan 2013 13:52:40 -0500
Message-ID: <CABYizFJhzsBbEd4t6cpZr6NesJvTLcYVrDz=ck7mFTNWaAcUZQ@mail.gmail.com>
Subject: Re: fio is being killed by the oom-killer after fio verify runs for
 some time ~13 hours
From: brian arb <brianjamesarb@gmail.com>
Content-Type: multipart/alternative; boundary=bcaec54eea24dba2e004d3f9328a
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--bcaec54eea24dba2e004d3f9328a
Content-Type: text/plain; charset=ISO-8859-1

The changes you made are much appreciated! I'll test it out and give you
some feedback soon.

On Wed, Jan 23, 2013 at 1:21 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On Mon, Jan 21 2013, Jens Axboe wrote:
> > On Fri, Jan 18 2013, Jens Axboe wrote:
> > > On Fri, Jan 18 2013, brian arb wrote:
> > > > adding the option --verify_backlog=1024 resolved my issue.
> > > > On a side note how would one determine what the optimum number is
> for this
> > > > option?
> > >
> > > It's easier if you know the internals... The version you are running
> > > will store some metadata for each block written, for verification
> > > purposes. Standard install is 80 bytes per block. So if you have a 2TB
> > > disk and use 4K IO sizes, the memory required runs into the gigabytes.
> > > Quite unfortunate, really, will be fixed up shortly.
> > >
> > > In any case, with a backlog of just 1024, you wont use more than 80KB
> > > memory for verifies. So you could easily size it larger. I'd improve
> the
> > > option documentation, but I think it's better to just improve fio to
> not
> > > require the stored meta data to be able to verify. It will be in the
> > > 2.0.14 release.
> >
> > Current -git has it implemented. If you do your normal verify workload
> > but add --experimental_verify=1 to the options, it wont track meta data
> > needed for verify, but rather just re-wind the various attributes to
> > replay the workload for read and verify instead. Just tested it on one
> > box here, bringing the needed memory down for a job from 25G to 1M. The
> > worst part about the verify memory consumption was the slowly growing
> > job, meaning that it could have the OOM consequences that you described
> > for long running jobs. No allocations are taking place for IO when
> > experimental_verify is set now.
> >
> > Side note, this doesn't work for mixed write/trim workloads for now. We
> > need a bit of extra tracking for that.
>
> Final bits are in now, works for both trim and mixed workloads etc. So
> to recap, testing now with minimal mem pressure does not need
> verify_backlog= being set. Suggested new parameters:
>
> --experimental_verify=1 --random_generator=lfsr
>
> if you could try that and report back if things ran successfully, I
> would much appreciate it.
>
> --
> Jens Axboe
>
>

--bcaec54eea24dba2e004d3f9328a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The changes you made are much=A0appreciated! I&#39;ll test it out and give =
you some feedback soon.<br><br><div class=3D"gmail_quote">On Wed, Jan 23, 2=
013 at 1:21 PM, Jens Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@ke=
rnel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On M=
on, Jan 21 2013, Jens Axboe wrote:<br>
&gt; On Fri, Jan 18 2013, Jens Axboe wrote:<br>
&gt; &gt; On Fri, Jan 18 2013, brian arb wrote:<br>
&gt; &gt; &gt; adding the option --verify_backlog=3D1024 resolved my issue.=
<br>
&gt; &gt; &gt; On a side note how would one determine what the optimum numb=
er is for this<br>
&gt; &gt; &gt; option?<br>
&gt; &gt;<br>
&gt; &gt; It&#39;s easier if you know the internals... The version you are =
running<br>
&gt; &gt; will store some metadata for each block written, for verification=
<br>
&gt; &gt; purposes. Standard install is 80 bytes per block. So if you have =
a 2TB<br>
&gt; &gt; disk and use 4K IO sizes, the memory required runs into the gigab=
ytes.<br>
&gt; &gt; Quite unfortunate, really, will be fixed up shortly.<br>
&gt; &gt;<br>
&gt; &gt; In any case, with a backlog of just 1024, you wont use more than =
80KB<br>
&gt; &gt; memory for verifies. So you could easily size it larger. I&#39;d =
improve the<br>
&gt; &gt; option documentation, but I think it&#39;s better to just improve=
 fio to not<br>
&gt; &gt; require the stored meta data to be able to verify. It will be in =
the<br>
&gt; &gt; 2.0.14 release.<br>
&gt;<br>
&gt; Current -git has it implemented. If you do your normal verify workload=
<br>
&gt; but add --experimental_verify=3D1 to the options, it wont track meta d=
ata<br>
&gt; needed for verify, but rather just re-wind the various attributes to<b=
r>
&gt; replay the workload for read and verify instead. Just tested it on one=
<br>
&gt; box here, bringing the needed memory down for a job from 25G to 1M. Th=
e<br>
&gt; worst part about the verify memory consumption was the slowly growing<=
br>
&gt; job, meaning that it could have the OOM consequences that you describe=
d<br>
&gt; for long running jobs. No allocations are taking place for IO when<br>
&gt; experimental_verify is set now.<br>
&gt;<br>
&gt; Side note, this doesn&#39;t work for mixed write/trim workloads for no=
w. We<br>
&gt; need a bit of extra tracking for that.<br>
<br>
</div></div>Final bits are in now, works for both trim and mixed workloads =
etc. So<br>
to recap, testing now with minimal mem pressure does not need<br>
verify_backlog=3D being set. Suggested new parameters:<br>
<br>
--experimental_verify=3D1 --random_generator=3Dlfsr<br>
<br>
if you could try that and report back if things ran successfully, I<br>
would much appreciate it.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br>

--bcaec54eea24dba2e004d3f9328a--


