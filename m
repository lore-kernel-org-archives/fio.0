Return-Path: <jcasse@google.com>
MIME-Version: 1.0
In-Reply-To: <20130801022535.GF24569@kernel.dk>
References: <CANEJEGsMAS3uYtQx04bq8mPcdnhtXaVwg=vS=TgcY97d2kQeqw@mail.gmail.com>
	<51F98044.1080105@kernel.dk>
	<CANEJEGvQZXa4NhsjZcawQ+Z6MTOgzfJEX+t1WY2yX_+R-qC3Og@mail.gmail.com>
	<20130801022535.GF24569@kernel.dk>
Date: Fri, 2 Aug 2013 14:18:07 -0700
Message-ID: <CAPet_20=Nqwsz6kGQajMdd3TQ_=10RSQ015tUTfigcTJ4jWnUA@mail.gmail.com>
Subject: Re: FIO and Storage Data Integrity testing
From: Juan Casse <jcasse@google.com>
Content-Type: multipart/alternative; boundary=089e013a1666bbf24004e2fd7e60
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@google.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--089e013a1666bbf24004e2fd7e60
Content-Type: text/plain; charset=ISO-8859-1

Jens, Grant,

Below is a summary of the thread as I understood it.
(To keep it simple, I'm using the TODO keyword for both action items and
questions.)

Requirements for data integrity and retention test

1) gpl implementaion:

fio satisfies this

2) Verify data written to storage is available and correct:

fio has axmap to log writes, but
prefer linear feedback shift registers (lfsr) to reproduce data for
verification; fio currently supports this with random_generator=lfsr

TODO: Jens says lfsr does not currently work with multiple block sizes? I'm
missing something here; I thought a single run would have a single block
size. Please explain.

3) Breadcrumbs for debugging data that is not correct:

a) lba - fio has uint64 offset. OK.
b) generation # - fio has unsigned short numberio

TODO: Jens says must be used differently? How does it currently work? Is it
also incremented and written to storage upon a read?

c) timestamp - fio has unsigned long time_sec and time_usec. OK.
d) magic # - fio has a generic magic number

TODO: what does generic mean? is it always the same number dor every run of
fio?

TODO: make this data structure (vhdr_meta) agnostic to 32- vs. 64-bit

4) Data retention:

fio currently can do:

a) write workload with do_verify=0
b) read workload with do_verify=1

fio currently checksums:

a) header information
b) actual data

5) Test trim/discard:

TODO: use separate lfsr to generate read/write/trim part

Grant, if fio currently has lfsr and the breadcrumbs and can do writes with
do_verify=0 and reads with do_verify=1, it seems to me that fio already
satisfies our requirements for data integrity testing, contingent on Jens'
answers to my questions above. Also, wouldn't these features be sufficient
for data retention testing as well? If you write do_verify=0 and then 3
months later read do_verify=1, wouldn't that be enough?

Juan



On Wed, Jul 31, 2013 at 7:25 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On Wed, Jul 31 2013, Grant Grundler wrote:
> > On Wed, Jul 31, 2013 at 2:23 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > ...
> > >> o log writes (save a map) so we can repeatedly verify writes at a
> > >> later date (weeks or months later)
> > >
> > > One approach that I have started favoring is instead providing coverage
> > > through the use of an lfsr.
> >
> > "Log File Structured <something>?" Expand that and I can better assess
> > if I think this is a good idea or not.
>
> Linear feedback shift registers. Basically a way to generate a "random"
> sequence of numbers that are guarenteed not to repeat until the cycle is
> repeated. Then you never have to do on-the-side tracking to avoid
> overlaps or overwrites.
>
> For verify, you simple re-set the seed to the value when the sequence
> started to hit all of the same blocks again. Or variations around that
> theme, if you only want some of them.
>
> > I'm not too picky about the implementation that meets the requirement.
> > I understand maps or sparse maps can get very awkward to handle for
> > devices with more than a few billion blocks. ("Can plz haz 4k blox?"
> > :)
>
> Indeed, fio has the "axmap" to track it otherwise, which gets very close
> to 1 bit per block without having the pathological behavior when the map
> gets near full.
>
> >
> > > This negates the need for dedicated tracking
> > > map or log. Fio supports this through random_generator=lfsr. The one
> > > thing that does not YET work is lfsr and multiple block sizes. Should
> be
> > > doable through layered use of multiple lfsrs. Something for your intern
> > > to tackle?
> >
> > Yes. That would be fair game.
>
> Excellent!
>
> > >> o provide some "bread crumbs" for debugging when data is NOT correct.
> > >>    (Not available typically will result in reported errors)
> > >
> > > So lets say that one of the fio verify modes was augmented to include a
> > > time stamp (say the meta mode, or could even be added to all the verify
> > > modes), that could be part of the bread crumbs and aid in judging
> > > retention of the data.
> >
> > I want four pieces of data for bread crumbs:
> > o timestamp
>
> Don't have that, trivial to add.
>
> > o LBA written (e.g. if it's a partition, that means the offset into
> > the partition)
>
> Got it.
>
> > o magic number for that test run (think of it as a GUID - verifies the
> > block was written by fio)
>
> Got it, but it's a fio generic magic. We could add a specific magic as
> well, would be trivial.
>
> > o generation number in the case that we rewrite an LBA - so we can
> > detect stale data
>
> Don't have that, trivial to add.
>
> > I haven't checked if fio provides all four of those.
> >
> > BTW, to eventually support adding "trim/discard command" testing into
> > the mix, we would need to know when a block is explicitly unmapped and
> > should be all zeros if we attempt to read it.
>
> This possibly again could be done without on-the-side tracking, if we
> used a separate lfsr to generate the read/write/trim part. This would
> keep the memory foot print down. Fio does support trim already.
>
> > >> o be done in < 6 weeks by a full time intern. :)
> > >
> > > Depends on the quality of the intern :-)
> >
> > Juan is capable enough. He's also extremely persistent. So I think
> > yes, he can get this done.
>
> Excellent!
>
> > >> Questions:
> > >> 1) You know anyone else developing data integrity/retention testing
> with fio?
> > >
> > > I know of lots of people/companies using it for data integrity testing
> > > (I even work for one of them), but not data retention. So I think that
> > > would be a very interesting feature to add.
> >
> > Good. thanks!
> >
> > My review a few months ago of fio docs didn't give me the impression
> > the data integrity checking was providing enough bread crumbs for good
> > debugging or able to detect stale data. But my memory isn't very good
> > and I could be wrong or just out of date.
>
> Depends on your use case. Fio checksums the verify header separate. If
> that is good, we can check the actual data. If that is not good, we can
> recreate the original content and compare with what is on disk. That
> gives you a pretty good idea of what was destroyed and how. But it does
> not have the required bits for real retention testing, like timestamp
> and/or sequence. That could be added to the verify_header structure, or
> it could be a specific part of eg the meta verify. The latter has the
> offset written already, for instance.
>
> > >> 3) You have a preference on how this might be implemented if (a) we
> > >> used code from OR (b) integrated this functionality into fio?
> > >
> > > I think the the data retention aspect should be integrated into the
> > > verify modes. The fio verification modes checksum both the stored
> > > header, as well as the actual contents. There might be additional
> > > tracking required on the side for retention, to be able to pass some
> > > interesting info on where we seem to fall off a cliff.
> >
> > Ok. Let me clarify the requirement for data retention: I wanted
> > "verify" to be an option to the "read" workload mix. So not
> > necessarily all data that gets written will get verified "during" the
> > write workload. The reason is performance statistics need to be as
> > consistent as possible without "verify" in a mixed read/write
> > workload.
>
> Fio already supports that. Simply do the write workload with
> do_verify=0, then do a similar read workload with do_verify=1 and the
> same verify checksum etc settings.
>
> > To verify everything that was written or trimmed, we can invoke fio
> > again (think autotest invoking fio twice per test run) to check for
> > retention. And then invoke fio many more times while the device is
> > getting baked in a thermal chamber.
>
> Trim verification can be done if the device supports persistent and
> guaranteed zero return on a completed trim. trim_verify_zero. If that
> isn't set, trimmed regions are simply ignored for a verify.
>
> > > I'll be happy to work with you guys on this, both on the initial
> > > design phase and the final integration into fio.
> >
> > Awesome - thank you!
> >
> > Design phase?! :) This is design phase. :)
>
> Agree :-)
>
> --
> Jens Axboe
>
>

--089e013a1666bbf24004e2fd7e60
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Jens, Grant,</div><div><br></div><div>Below is a summ=
ary of the thread as I understood it.</div><div>(To keep it simple, I&#39;m=
 using the TODO keyword for both action items and questions.)</div><div><br=
>
</div><div>Requirements for data integrity and retention test</div><div><br=
></div><div>1) gpl implementaion:</div><div><br></div><div>fio satisfies th=
is</div><div><br></div><div>2) Verify data written to storage is available =
and correct:</div>
<div><br></div><div>fio has axmap to log writes, but</div><div>prefer linea=
r feedback shift registers (lfsr) to reproduce data for verification; fio c=
urrently supports this with random_generator=3Dlfsr</div><div><br></div><di=
v>
TODO: Jens says lfsr does not currently work with multiple block sizes? I&#=
39;m missing something here; I thought a single run would have a single blo=
ck size. Please explain.</div><div><br></div><div>3) Breadcrumbs for debugg=
ing data that is not correct:</div>
<div><br></div><div>a) lba - fio has uint64 offset. OK.</div><div>b) genera=
tion # - fio has unsigned short numberio</div><div><br></div><div>TODO: Jen=
s says must be used differently? How does it currently work? Is it also inc=
remented and written to storage upon a read?</div>
<div><br></div><div>c) timestamp - fio has unsigned long time_sec and time_=
usec. OK.</div><div>d) magic # - fio has a generic magic number</div><div><=
br></div><div>TODO: what does generic mean? is it always the same number do=
r every run of fio?</div>
<div><br></div><div>TODO: make this data structure (vhdr_meta) agnostic to =
32- vs. 64-bit</div><div><br></div><div>4) Data retention:</div><div><br></=
div><div>fio currently can do:</div><div><br></div><div>a) write workload w=
ith do_verify=3D0</div>
<div>b) read workload with do_verify=3D1</div><div><br></div><div>fio curre=
ntly checksums:</div><div><br></div><div>a) header information</div><div>b)=
 actual data</div><div><br></div><div>5) Test trim/discard:</div><div><br>
</div><div>TODO: use separate lfsr to generate read/write/trim part</div><d=
iv><br></div><div>Grant, if fio currently has lfsr and the breadcrumbs and =
can do writes with do_verify=3D0 and reads with do_verify=3D1, it seems to =
me that fio already satisfies our requirements for data integrity testing, =
contingent on Jens&#39; answers to my questions above. Also, wouldn&#39;t t=
hese features be sufficient for data retention testing as well? If you writ=
e do_verify=3D0 and then 3 months later read do_verify=3D1, wouldn&#39;t th=
at be enough?</div>
<div><br></div><div>Juan</div><div><br></div></div><div class=3D"gmail_extr=
a"><br><br><div class=3D"gmail_quote">On Wed, Jul 31, 2013 at 7:25 PM, Jens=
 Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=3D"_=
blank">axboe@kernel.dk</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Wed, Jul 31 2013, Grant=
 Grundler wrote:<br>
&gt; On Wed, Jul 31, 2013 at 2:23 PM, Jens Axboe &lt;<a href=3D"mailto:axbo=
e@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br>
&gt; ...<br>
&gt; &gt;&gt; o log writes (save a map) so we can repeatedly verify writes =
at a<br>
&gt; &gt;&gt; later date (weeks or months later)<br>
&gt; &gt;<br>
&gt; &gt; One approach that I have started favoring is instead providing co=
verage<br>
&gt; &gt; through the use of an lfsr.<br>
&gt;<br>
&gt; &quot;Log File Structured &lt;something&gt;?&quot; Expand that and I c=
an better assess<br>
&gt; if I think this is a good idea or not.<br>
<br>
</div>Linear feedback shift registers. Basically a way to generate a &quot;=
random&quot;<br>
sequence of numbers that are guarenteed not to repeat until the cycle is<br=
>
repeated. Then you never have to do on-the-side tracking to avoid<br>
overlaps or overwrites.<br>
<br>
For verify, you simple re-set the seed to the value when the sequence<br>
started to hit all of the same blocks again. Or variations around that<br>
theme, if you only want some of them.<br>
<div class=3D"im"><br>
&gt; I&#39;m not too picky about the implementation that meets the requirem=
ent.<br>
&gt; I understand maps or sparse maps can get very awkward to handle for<br=
>
&gt; devices with more than a few billion blocks. (&quot;Can plz haz 4k blo=
x?&quot;<br>
&gt; :)<br>
<br>
</div>Indeed, fio has the &quot;axmap&quot; to track it otherwise, which ge=
ts very close<br>
to 1 bit per block without having the pathological behavior when the map<br=
>
gets near full.<br>
<div class=3D"im"><br>
&gt;<br>
&gt; &gt; This negates the need for dedicated tracking<br>
&gt; &gt; map or log. Fio supports this through random_generator=3Dlfsr. Th=
e one<br>
&gt; &gt; thing that does not YET work is lfsr and multiple block sizes. Sh=
ould be<br>
&gt; &gt; doable through layered use of multiple lfsrs. Something for your =
intern<br>
&gt; &gt; to tackle?<br>
&gt;<br>
&gt; Yes. That would be fair game.<br>
<br>
</div>Excellent!<br>
<div class=3D"im"><br>
&gt; &gt;&gt; o provide some &quot;bread crumbs&quot; for debugging when da=
ta is NOT correct.<br>
&gt; &gt;&gt; =A0 =A0(Not available typically will result in reported error=
s)<br>
&gt; &gt;<br>
&gt; &gt; So lets say that one of the fio verify modes was augmented to inc=
lude a<br>
&gt; &gt; time stamp (say the meta mode, or could even be added to all the =
verify<br>
&gt; &gt; modes), that could be part of the bread crumbs and aid in judging=
<br>
&gt; &gt; retention of the data.<br>
&gt;<br>
&gt; I want four pieces of data for bread crumbs:<br>
&gt; o timestamp<br>
<br>
</div>Don&#39;t have that, trivial to add.<br>
<div class=3D"im"><br>
&gt; o LBA written (e.g. if it&#39;s a partition, that means the offset int=
o<br>
&gt; the partition)<br>
<br>
</div>Got it.<br>
<div class=3D"im"><br>
&gt; o magic number for that test run (think of it as a GUID - verifies the=
<br>
&gt; block was written by fio)<br>
<br>
</div>Got it, but it&#39;s a fio generic magic. We could add a specific mag=
ic as<br>
well, would be trivial.<br>
<div class=3D"im"><br>
&gt; o generation number in the case that we rewrite an LBA - so we can<br>
&gt; detect stale data<br>
<br>
</div>Don&#39;t have that, trivial to add.<br>
<div class=3D"im"><br>
&gt; I haven&#39;t checked if fio provides all four of those.<br>
&gt;<br>
&gt; BTW, to eventually support adding &quot;trim/discard command&quot; tes=
ting into<br>
&gt; the mix, we would need to know when a block is explicitly unmapped and=
<br>
&gt; should be all zeros if we attempt to read it.<br>
<br>
</div>This possibly again could be done without on-the-side tracking, if we=
<br>
used a separate lfsr to generate the read/write/trim part. This would<br>
keep the memory foot print down. Fio does support trim already.<br>
<div class=3D"im"><br>
&gt; &gt;&gt; o be done in &lt; 6 weeks by a full time intern. :)<br>
&gt; &gt;<br>
&gt; &gt; Depends on the quality of the intern :-)<br>
&gt;<br>
&gt; Juan is capable enough. He&#39;s also extremely persistent. So I think=
<br>
&gt; yes, he can get this done.<br>
<br>
</div>Excellent!<br>
<div class=3D"im"><br>
&gt; &gt;&gt; Questions:<br>
&gt; &gt;&gt; 1) You know anyone else developing data integrity/retention t=
esting with fio?<br>
&gt; &gt;<br>
&gt; &gt; I know of lots of people/companies using it for data integrity te=
sting<br>
&gt; &gt; (I even work for one of them), but not data retention. So I think=
 that<br>
&gt; &gt; would be a very interesting feature to add.<br>
&gt;<br>
&gt; Good. thanks!<br>
&gt;<br>
&gt; My review a few months ago of fio docs didn&#39;t give me the impressi=
on<br>
&gt; the data integrity checking was providing enough bread crumbs for good=
<br>
&gt; debugging or able to detect stale data. But my memory isn&#39;t very g=
ood<br>
&gt; and I could be wrong or just out of date.<br>
<br>
</div>Depends on your use case. Fio checksums the verify header separate. I=
f<br>
that is good, we can check the actual data. If that is not good, we can<br>
recreate the original content and compare with what is on disk. That<br>
gives you a pretty good idea of what was destroyed and how. But it does<br>
not have the required bits for real retention testing, like timestamp<br>
and/or sequence. That could be added to the verify_header structure, or<br>
it could be a specific part of eg the meta verify. The latter has the<br>
offset written already, for instance.<br>
<div class=3D"im"><br>
&gt; &gt;&gt; 3) You have a preference on how this might be implemented if =
(a) we<br>
&gt; &gt;&gt; used code from OR (b) integrated this functionality into fio?=
<br>
&gt; &gt;<br>
&gt; &gt; I think the the data retention aspect should be integrated into t=
he<br>
&gt; &gt; verify modes. The fio verification modes checksum both the stored=
<br>
&gt; &gt; header, as well as the actual contents. There might be additional=
<br>
&gt; &gt; tracking required on the side for retention, to be able to pass s=
ome<br>
&gt; &gt; interesting info on where we seem to fall off a cliff.<br>
&gt;<br>
&gt; Ok. Let me clarify the requirement for data retention: I wanted<br>
&gt; &quot;verify&quot; to be an option to the &quot;read&quot; workload mi=
x. So not<br>
&gt; necessarily all data that gets written will get verified &quot;during&=
quot; the<br>
&gt; write workload. The reason is performance statistics need to be as<br>
&gt; consistent as possible without &quot;verify&quot; in a mixed read/writ=
e<br>
&gt; workload.<br>
<br>
</div>Fio already supports that. Simply do the write workload with<br>
do_verify=3D0, then do a similar read workload with do_verify=3D1 and the<b=
r>
same verify checksum etc settings.<br>
<div class=3D"im"><br>
&gt; To verify everything that was written or trimmed, we can invoke fio<br=
>
&gt; again (think autotest invoking fio twice per test run) to check for<br=
>
&gt; retention. And then invoke fio many more times while the device is<br>
&gt; getting baked in a thermal chamber.<br>
<br>
</div>Trim verification can be done if the device supports persistent and<b=
r>
guaranteed zero return on a completed trim. trim_verify_zero. If that<br>
isn&#39;t set, trimmed regions are simply ignored for a verify.<br>
<div class=3D"im"><br>
&gt; &gt; I&#39;ll be happy to work with you guys on this, both on the init=
ial<br>
&gt; &gt; design phase and the final integration into fio.<br>
&gt;<br>
&gt; Awesome - thank you!<br>
&gt;<br>
&gt; Design phase?! :) This is design phase. :)<br>
<br>
</div>Agree :-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--089e013a1666bbf24004e2fd7e60--


