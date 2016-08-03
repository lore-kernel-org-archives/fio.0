Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
References: <CABtFm2X1th74qPOKaT+UG7rA-X8bjiADLE7x3n3qBjS7YAibNg@mail.gmail.com>
 <185b7fb1-e59a-c0e4-9a8a-ed5a21b441e8@kernel.dk> <93206ce7-e4ea-2188-7809-48ea44f1aafa@kernel.dk>
In-Reply-To: <93206ce7-e4ea-2188-7809-48ea44f1aafa@kernel.dk>
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Date: Wed, 03 Aug 2016 16:01:09 +0000
Message-ID: <CABtFm2UfFJ0m78qOh5C=-+5p3qQhCg77OdHXQtK1EdWY9aOHbA@mail.gmail.com>
Subject: Re: create_on_open fails with "err=5/file:backend.c:498"
Content-Type: multipart/alternative; boundary=001a1134ec70bbe48305392cf145
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--001a1134ec70bbe48305392cf145
Content-Type: text/plain; charset=UTF-8

It's failing when there are no files exist in the directory. If I have
files that already exist, it's working. I think that's expected as it
defaults to read if --rw is not specified.

Will try the -git latest and let you know.

On Wed 3 Aug, 2016, 11:54 PM Jens Axboe, <axboe@kernel.dk> wrote:

> On 08/03/2016 08:42 AM, Jens Axboe wrote:
> > On 08/02/2016 07:29 AM, Srinivasa Chamarthy wrote:
> >> Hi All,
> >>
> >> With the latest version of FIO, i see that create_on_open failing
> >> always with error "err=5/file:backend.c:498"
> >>
> >> # fio --name=test --directory=/testdata --nrfiles=10 --size=1g
> >> --refill_buffers=1 --direct=1 --create_on_open=1
> >> test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
> >> fio-2.13-28-g059b6
> >> Starting 1 process
> >> fio: pid=8439, err=5/file:backend.c:498, func=full resid,
> >> error=Input/output error
> >>
> >> test: (groupid=0, jobs=1): err= 5 (file:backend.c:498, func=full
> >> resid, error=Input/output error): pid=8439: Tue Aug  2 10:24:08 2016
> >>   cpu          : usr=0.00%, sys=0.00%, ctx=1, majf=0, minf=57
> >>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
> >> >=64=0.0%
> >>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
> >> >=64=0.0%
> >>      complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
> >> >=64=0.0%
> >>      issued    : total=r=1/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
> >>      latency   : target=0, window=0, percentile=100.00%, depth=1
> >>
> >> Run status group 0 (all jobs):
> >>
> >> Disk stats (read/write):
> >>     dm-0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
> >> aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0,
> >> aggrutil=0.00%
> >>   sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
> >>
> >> # fio --version
> >> fio-2.13-28-g059b6
> >>
> >> The execution was on RHEL7.2 and CentOS7.2
> >
> > Did that ever work for readable workloads? For a writeable workload it
> > should be fine.
>
> I take it back, it should still work. Try current -git, I think I fixed
> it for you.
>
> --
> Jens Axboe
>
>

--001a1134ec70bbe48305392cf145
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

It&#39;s failing when there are no files exist in the directory. If I have =
files that already exist, it&#39;s working. I think that&#39;s expected as =
it defaults to read if --rw is not specified.<div><br></div><div>Will try t=
he -git latest and let you know.<br><div><br></div><div><div class=3D"gmail=
_quote"><div dir=3D"ltr">On Wed 3 Aug, 2016, 11:54 PM Jens Axboe, &lt;<a hr=
ef=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br></div><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex">On 08/03/2016 08:42 AM, Jens Axboe wrote:<br>
&gt; On 08/02/2016 07:29 AM, Srinivasa Chamarthy wrote:<br>
&gt;&gt; Hi All,<br>
&gt;&gt;<br>
&gt;&gt; With the latest version of FIO, i see that create_on_open failing<=
br>
&gt;&gt; always with error &quot;err=3D5/file:backend.c:498&quot;<br>
&gt;&gt;<br>
&gt;&gt; # fio --name=3Dtest --directory=3D/testdata --nrfiles=3D10 --size=
=3D1g<br>
&gt;&gt; --refill_buffers=3D1 --direct=3D1 --create_on_open=3D1<br>
&gt;&gt; test: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dpsync=
, iodepth=3D1<br>
&gt;&gt; fio-2.13-28-g059b6<br>
&gt;&gt; Starting 1 process<br>
&gt;&gt; fio: pid=3D8439, err=3D5/file:backend.c:498, func=3Dfull resid,<br=
>
&gt;&gt; error=3DInput/output error<br>
&gt;&gt;<br>
&gt;&gt; test: (groupid=3D0, jobs=3D1): err=3D 5 (file:backend.c:498, func=
=3Dfull<br>
&gt;&gt; resid, error=3DInput/output error): pid=3D8439: Tue Aug=C2=A0 2 10=
:24:08 2016<br>
&gt;&gt;=C2=A0 =C2=A0cpu=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : usr=3D0.00%, s=
ys=3D0.00%, ctx=3D1, majf=3D0, minf=3D57<br>
&gt;&gt;=C2=A0 =C2=A0IO depths=C2=A0 =C2=A0 : 1=3D100.0%, 2=3D0.0%, 4=3D0.0=
%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,<br>
&gt;&gt; &gt;=3D64=3D0.0%<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 submit=C2=A0 =C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%,<br>
&gt;&gt; &gt;=3D64=3D0.0%<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 complete=C2=A0 : 0=3D50.0%, 4=3D50.0%, 8=3D0.0=
%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%,<br>
&gt;&gt; &gt;=3D64=3D0.0%<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 issued=C2=A0 =C2=A0 : total=3Dr=3D1/w=3D0/d=3D=
0, short=3Dr=3D0/w=3D0/d=3D0, drop=3Dr=3D0/w=3D0/d=3D0<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 latency=C2=A0 =C2=A0: target=3D0, window=3D0, =
percentile=3D100.00%, depth=3D1<br>
&gt;&gt;<br>
&gt;&gt; Run status group 0 (all jobs):<br>
&gt;&gt;<br>
&gt;&gt; Disk stats (read/write):<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0dm-0: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_q=
ueue=3D0, util=3D0.00%,<br>
&gt;&gt; aggrios=3D0/0, aggrmerge=3D0/0, aggrticks=3D0/0, aggrin_queue=3D0,=
<br>
&gt;&gt; aggrutil=3D0.00%<br>
&gt;&gt;=C2=A0 =C2=A0sda: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0=
, util=3D0.00%<br>
&gt;&gt;<br>
&gt;&gt; # fio --version<br>
&gt;&gt; fio-2.13-28-g059b6<br>
&gt;&gt;<br>
&gt;&gt; The execution was on RHEL7.2 and CentOS7.2<br>
&gt;<br>
&gt; Did that ever work for readable workloads? For a writeable workload it=
<br>
&gt; should be fine.<br>
<br>
I take it back, it should still work. Try current -git, I think I fixed<br>
it for you.<br>
<br>
--<br>
Jens Axboe<br>
<br>
</blockquote></div></div></div>

--001a1134ec70bbe48305392cf145--

