Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <56CCD5D1.3020508@kernel.dk>
References: <CANvN+e=-VtHTeaRftjvPJUjhgVY9nD85gn=6D4+TyQeLrEE_cw@mail.gmail.com>
	<56CCD5D1.3020508@kernel.dk>
Date: Wed, 24 Feb 2016 01:02:25 +0300
Message-ID: <CANvN+e=DNFrp6j4+nAtm84BWZn7u-eWqbFWM0fFMLFd-B+Lx3g@mail.gmail.com>
Subject: Re: [PATCH]: Let I/O engine provide methods to allocate/free I/O memory.
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Content-Type: multipart/alternative; boundary=001a113fa848c9c766052c771a16
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--001a113fa848c9c766052c771a16
Content-Type: text/plain; charset=UTF-8

On Feb 24, 2016 00:57, "Jens Axboe" <axboe@kernel.dk> wrote:
>
> On 02/23/2016 02:16 PM, Andrey Kuzmin wrote:
>>
>> I/O engine may have special needs as to how the I/O memory should be
>> allocated. The below patch adds respective methods to the I/O engine
>> interface.
>
>
> What kind of special needs? It's not that I mind adding an IO engine
alloc hook, the only issue is that it potentially voids the various job
file settings for memory backing etc without the user knowing it. So I
think we need some decent justification here, other than "special needs" :-)
>

My engine talks directly to the hardware, and has to comply with the
hardware requirements re the io memory. Is that enough justification ;)?

Regards,
A.
>
>
> --
> Jens Axboe
>

--001a113fa848c9c766052c771a16
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Feb 24, 2016 00:57, &quot;Jens Axboe&quot; &lt;<a href=3D"mailto:axboe@k=
ernel.dk">axboe@kernel.dk</a>&gt; wrote:<br>
&gt;<br>
&gt; On 02/23/2016 02:16 PM, Andrey Kuzmin wrote:<br>
&gt;&gt;<br>
&gt;&gt; I/O engine may have special needs as to how the I/O memory should =
be<br>
&gt;&gt; allocated. The below patch adds respective methods to the I/O engi=
ne<br>
&gt;&gt; interface.<br>
&gt;<br>
&gt;<br>
&gt; What kind of special needs? It&#39;s not that I mind adding an IO engi=
ne alloc hook, the only issue is that it potentially voids the various job =
file settings for memory backing etc without the user knowing it. So I thin=
k we need some decent justification here, other than &quot;special needs&qu=
ot; :-)<br>
&gt;</p>
<p dir=3D"ltr">My engine talks directly to the hardware, and has to comply =
with the hardware requirements re the io memory. Is that enough justificati=
on ;)?</p>
<p dir=3D"ltr">Regards,<br>
A.<br>
&gt;<br>
&gt;<br>
&gt; -- <br>
&gt; Jens Axboe<br>
&gt;<br>
</p>

--001a113fa848c9c766052c771a16--

