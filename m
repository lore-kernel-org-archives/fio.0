Return-Path: <jcasse@google.com>
MIME-Version: 1.0
In-Reply-To: <51FACCF8.2050304@kernel.dk>
References: <CANEJEGsMAS3uYtQx04bq8mPcdnhtXaVwg=vS=TgcY97d2kQeqw@mail.gmail.com>
	<51F98044.1080105@kernel.dk>
	<CANEJEGvQZXa4NhsjZcawQ+Z6MTOgzfJEX+t1WY2yX_+R-qC3Og@mail.gmail.com>
	<20130801022535.GF24569@kernel.dk>
	<51FACCF8.2050304@kernel.dk>
Date: Fri, 2 Aug 2013 10:15:17 -0700
Message-ID: <CAPet_22BG6WKw553pwoyA4SOK2zJu33gg213dKOJdjccHMKjXQ@mail.gmail.com>
Subject: Re: FIO and Storage Data Integrity testing
From: Juan Casse <jcasse@google.com>
Content-Type: multipart/alternative; boundary=089e013a16664f8e5f04e2fa1a90
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@google.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--089e013a16664f8e5f04e2fa1a90
Content-Type: text/plain; charset=ISO-8859-1

Jens, Grant,

Bellow is a summary of the thread as I understood it.
(To keep it simple, I'm using the TODO keyword for both action items and
questions.)

*Requirements for data integrity and retention test*

   1. gpl implementaion
      - fio satisfies this
   2. Verify data written to storage is available and correct
      - fio has axmap to log writes, but
      - prefer linear feedback shift registers (lfsr) to reproduce data for
      verification; fio currently supports this with random_generator=lfsr
         - TODO: Jens says lfsr does not currently work with multiple block
         sizes? I'm missing something here; I thought a single run would have a
         single block size. Please explain.
      - Breadcrumbs for debugging data that is not correct
         - lba - fio has uint64 offset. OK.
         - generation # - fio has unsigned short numberio
            - TODO: Jens says must be used differently? How does it
            currently work? Is it also incremented and written to
storage upon a read?
         - timestamp - fio has unsigned long time_sec and time_usec. OK.
         - magic # - fio has a generic magic number
            - TODO: what does generic mean? is it always the same number
            dor every run of fio?
         - TODO: make this data structure (vhdr_meta) agnostic to 32- vs.
         64-bit
      3. Data retention
      - fio currently can do
         - write workload with do_verify=0
         - read workload with do_verify=1
      - fio currently checksums
         - header information
         - actual data
      4. Test trim/discard
      - TODO: use sepparate lfsr to generate read/wrte/trim part

Grant, if fio currently has lfsr and the breadcrumbs and can do writes with
do_verify=0 and reads with do_verify=1, it seems to me that fio already
satisfies our requirements for data integrity testing, contingent on Jens'
answers to my questions above. Also, wouldn't these features be sufficient
for data retention testing as well? If you write do_verify=0 and then 3
months later read do_verify=1, wouldn't that be enough?

Juan


On Thu, Aug 1, 2013 at 2:02 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 07/31/2013 08:25 PM, Jens Axboe wrote:
> >> I want four pieces of data for bread crumbs:
> >> o timestamp
> >
> > Don't have that, trivial to add.
>
> Just went and looked at what we had for the meta verify. There is
> actually already a timestamp there (sec + usec), and there's the notion
> of a generation number as well (it includes what number write this was).
>
> The structure looks like this:
>
> struct vhdr_meta
> {
>         uint64_t offset;
>         unsigned char thread;
>         unsigned short numberio;
>         unsigned long time_sec;
>         unsigned long time_usec;
> };
>
> Though the 'generation' number might have to be either used differently
> that it is now, or made into a different type. The meta verify is also
> the only one that isn't already 32 vs 64-bit agnostic.
>
> --
> Jens Axboe
>
>

--089e013a16664f8e5f04e2fa1a90
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Jens, Grant,<div><br></div><div>Bellow is a summary of the=
 thread as I understood it.</div><div>(To keep it simple, I&#39;m using the=
 TODO keyword for both action items and questions.)</div><div><br></div><di=
v>
<font size=3D"4"><b>Requirements for data integrity and retention test</b><=
/font></div><div><div><ol><li>gpl implementaion</li><ul><li>fio satisfies t=
his</li></ul><li>Verify data written to storage is available and correct</l=
i>
<ul><li>fio has axmap to log writes, but</li><li>prefer linear feedback shi=
ft registers (lfsr) to reproduce data for verification; fio currently suppo=
rts this with random_generator=3Dlfsr</li><ul><li>TODO: Jens says lfsr does=
 not currently work with multiple block sizes? I&#39;m missing something he=
re; I thought a single run would have a single block size. Please explain.<=
/li>
</ul><li>Breadcrumbs for debugging data that is not correct</li><ul><li>lba=
 - fio has uint64 offset. OK.</li><li>generation # - fio has unsigned short=
 numberio</li><ul><li>TODO: Jens says must be used differently? How does it=
 currently work? Is it also incremented and written to storage upon a read?=
</li>
</ul><li>timestamp - fio has unsigned long time_sec and time_usec. OK.</li>=
<li>magic # - fio has a generic magic number</li><ul><li>TODO: what does ge=
neric mean? is it always the same number dor every run of fio?</li></ul>
<li>TODO: make this data structure (vhdr_meta) agnostic to 32- vs. 64-bit</=
li></ul></ul><li>Data retention</li><ul><li>fio currently can do</li><ul><l=
i>write workload with do_verify=3D0</li><li>read workload with do_verify=3D=
1</li>
</ul><li>fio currently checksums</li><ul><li>header information</li><li>act=
ual data</li></ul></ul><li>Test trim/discard</li><ul><li>TODO: use sepparat=
e lfsr to generate read/wrte/trim part</li></ul></ol></div>Grant, if fio cu=
rrently has lfsr and the breadcrumbs and can do writes with do_verify=3D0 a=
nd reads with do_verify=3D1, it seems to me that fio already satisfies our =
requirements for data integrity testing, contingent on Jens&#39; answers to=
 my questions above. Also, wouldn&#39;t these features be sufficient for da=
ta retention testing as well? If you write do_verify=3D0 and then 3 months =
later read do_verify=3D1, wouldn&#39;t that be enough?</div>
<div><br></div><div>Juan</div></div><div class=3D"gmail_extra"><br><br><div=
 class=3D"gmail_quote">On Thu, Aug 1, 2013 at 2:02 PM, Jens Axboe <span dir=
=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=3D"_blank">axboe@ker=
nel.dk</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 07/31/2013 08:25 PM, Je=
ns Axboe wrote:<br>
&gt;&gt; I want four pieces of data for bread crumbs:<br>
&gt;&gt; o timestamp<br>
&gt;<br>
&gt; Don&#39;t have that, trivial to add.<br>
<br>
</div>Just went and looked at what we had for the meta verify. There is<br>
actually already a timestamp there (sec + usec), and there&#39;s the notion=
<br>
of a generation number as well (it includes what number write this was).<br=
>
<br>
The structure looks like this:<br>
<br>
struct vhdr_meta<br>
{<br>
=A0 =A0 =A0 =A0 uint64_t offset;<br>
=A0 =A0 =A0 =A0 unsigned char thread;<br>
=A0 =A0 =A0 =A0 unsigned short numberio;<br>
=A0 =A0 =A0 =A0 unsigned long time_sec;<br>
=A0 =A0 =A0 =A0 unsigned long time_usec;<br>
};<br>
<br>
Though the &#39;generation&#39; number might have to be either used differe=
ntly<br>
that it is now, or made into a different type. The meta verify is also<br>
the only one that isn&#39;t already 32 vs 64-bit agnostic.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--089e013a16664f8e5f04e2fa1a90--


