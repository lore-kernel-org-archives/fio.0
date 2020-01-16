Return-Path: <michael.c@excelero.com>
MIME-Version: 1.0
References: <CAA6um5PoJSafFa6Xa9ZeZqXUyXPA5b2fGNWA=+OoRVhkkXgogg@mail.gmail.com>
 <7b667f2f-dbe9-7ff1-72f4-d41d0994e21d@kernel.dk> <CALjAwxi-W2-5Xg=3mBMakfmeTJ7KjnQC=L0DrsESQAEY45Y3rw@mail.gmail.com>
In-Reply-To: <CALjAwxi-W2-5Xg=3mBMakfmeTJ7KjnQC=L0DrsESQAEY45Y3rw@mail.gmail.com>
From: Michael Chichik <michael.c@excelero.com>
Date: Thu, 16 Jan 2020 14:09:27 +0200
Message-ID: <CAA6um5Pv=7x_SxkXZk_kNYh8nhOsq_Uxt2n2ryJjoqL_t7Q9Kw@mail.gmail.com>
Subject: Re: FIO verify bad header question
Content-Type: multipart/alternative; boundary="000000000000058d35059c40b3cb"
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Matan Ramrazker <matan@excelero.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--000000000000058d35059c40b3cb
Content-Type: text/plain; charset="UTF-8"

I thought that if i use size=1g with nomjobs=10 the 1G is a range for each
job so no job interfere with other jobs
thanks a lot!!

On Thu, Jan 16, 2020 at 1:47 AM Sitsofe Wheeler <sitsofe@gmail.com> wrote:

> Hi,
>
> On Wed, 15 Jan 2020 at 15:32, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > Please use the fio list for this, CC'ed.
> >
> > On 1/15/20 8:28 AM, Michael Chichik wrote:
> > >
> > > */usr/bin/fio --time_based --runtime=1d --ioengine=libaio --iodepth=32
> --rw=randrw --bs=24k --direct=0 --io_size=60G --numjobs=10 --size=1G
> --rwmixread=0 --verify=md5 --verify_fatal=1 --output-format=json
> --output=4_randrw_0_10_32_libaio_xfs_1G.json --directory
> /mnt/test-vol-23206-36 --name host1_test-vol-23206-36
>
> ^^^numjobs=10 will mean all the jobs are working inside the same
> region. Because you're using randrw it's likely each job will write
> blocks in a different sequence to other jobs.
>
> > > *
> > > FIO failed with the following error:
> > > *
> > > *
> > > *verify: bad header rand_seed 1089408830752521594, wanted
> 7280637923435198810 at file /mnt/test-vol-23206-36/filename offset
> 776945664, length 24576
>
> This means job 2 can interfere with the writes of job 1 so when job
> one comes to do a verify it can't find the blocks written by itself
> (because it may find job 2's data). If you're going to use numjobs I'd
> strongly look into use offset_increment
> (
> https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-offset-increment
> ) and size (
> https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-size
> ) to ensure each job is working within a different region to any other
> job.
>
>
> > > *
> > >
> > > but when we compare the block level data is consistent.
> > >
> > > what is the meaning of the Error? does it really indicate data
> corruption?
>
> It means the data a given job had written isn't there and if no one
> else has interfered with the data that usually means corruption (but
> in this case other jobs may be interfering). Also using randrw with
> verify makes things complicated because are you expecting it to verify
> data it might try to read in the first pass which that job has never
> written?
>
> --
> Sitsofe | http://sucs.org/~sits/
>

--000000000000058d35059c40b3cb
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I thought that if i use size=3D1g with nomjobs=3D10 t=
he 1G is a range for each job so no job interfere with other jobs</div>than=
ks a lot!!</div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gm=
ail_attr">On Thu, Jan 16, 2020 at 1:47 AM Sitsofe Wheeler &lt;<a href=3D"ma=
ilto:sitsofe@gmail.com">sitsofe@gmail.com</a>&gt; wrote:<br></div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px =
solid rgb(204,204,204);padding-left:1ex">Hi,<br>
<br>
On Wed, 15 Jan 2020 at 15:32, Jens Axboe &lt;<a href=3D"mailto:axboe@kernel=
.dk" target=3D"_blank">axboe@kernel.dk</a>&gt; wrote:<br>
&gt;<br>
&gt; Please use the fio list for this, CC&#39;ed.<br>
&gt;<br>
&gt; On 1/15/20 8:28 AM, Michael Chichik wrote:<br>
&gt; &gt;<br>
&gt; &gt; */usr/bin/fio --time_based --runtime=3D1d --ioengine=3Dlibaio --i=
odepth=3D32 --rw=3Drandrw --bs=3D24k --direct=3D0 --io_size=3D60G --numjobs=
=3D10 --size=3D1G --rwmixread=3D0 --verify=3Dmd5 --verify_fatal=3D1 --outpu=
t-format=3Djson --output=3D4_randrw_0_10_32_libaio_xfs_1G.json --directory =
/mnt/test-vol-23206-36 --name host1_test-vol-23206-36<br>
<br>
^^^numjobs=3D10 will mean all the jobs are working inside the same<br>
region. Because you&#39;re using randrw it&#39;s likely each job will write=
<br>
blocks in a different sequence to other jobs.<br>
<br>
&gt; &gt; *<br>
&gt; &gt; FIO failed with the following error:<br>
&gt; &gt; *<br>
&gt; &gt; *<br>
&gt; &gt; *verify: bad header rand_seed 1089408830752521594, wanted 7280637=
923435198810 at file /mnt/test-vol-23206-36/filename offset 776945664, leng=
th 24576<br>
<br>
This means job 2 can interfere with the writes of job 1 so when job<br>
one comes to do a verify it can&#39;t find the blocks written by itself<br>
(because it may find job 2&#39;s data). If you&#39;re going to use numjobs =
I&#39;d<br>
strongly look into use offset_increment<br>
(<a href=3D"https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg=
-offset-increment" rel=3D"noreferrer" target=3D"_blank">https://fio.readthe=
docs.io/en/latest/fio_man.html#cmdoption-arg-offset-increment</a><br>
) and size (<a href=3D"https://fio.readthedocs.io/en/latest/fio_man.html#cm=
doption-arg-size" rel=3D"noreferrer" target=3D"_blank">https://fio.readthed=
ocs.io/en/latest/fio_man.html#cmdoption-arg-size</a><br>
) to ensure each job is working within a different region to any other<br>
job.<br>
<br>
<br>
&gt; &gt; *<br>
&gt; &gt;<br>
&gt; &gt; but when we compare the block level data is consistent.<br>
&gt; &gt;<br>
&gt; &gt; what is the meaning of the Error? does it really indicate data co=
rruption?<br>
<br>
It means the data a given job had written isn&#39;t there and if no one<br>
else has interfered with the data that usually means corruption (but<br>
in this case other jobs may be interfering). Also using randrw with<br>
verify makes things complicated because are you expecting it to verify<br>
data it might try to read in the first pass which that job has never<br>
written?<br>
<br>
--<br>
Sitsofe | <a href=3D"http://sucs.org/~sits/" rel=3D"noreferrer" target=3D"_=
blank">http://sucs.org/~sits/</a><br>
</blockquote></div>

--000000000000058d35059c40b3cb--

