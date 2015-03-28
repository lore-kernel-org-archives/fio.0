Return-Path: <akashv@google.com>
MIME-Version: 1.0
In-Reply-To: <550C4CAE.7070905@kernel.dk>
References: <CAFFT=U=vjqCZDoP5M31ifDWaLcG7LEhjgYHKzhdJ6mc6gDO0Sg@mail.gmail.com>
 <550C4CAE.7070905@kernel.dk>
From: Akash Verma <akashv@google.com>
Date: Fri, 27 Mar 2015 18:25:37 -0700
Message-ID: <CAFFT=Undnp5+T=8p+MS9Kh=gaJsrz-pUS1XJfH1HyoOMt=xjCA@mail.gmail.com>
Subject: Re: Buggy behavior with zone, random IOs since specific commit
Content-Type: multipart/alternative; boundary=001a114724ac8de11705124f216e
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, Brian Fulton <bfulton@google.com>
List-ID: <fio@vger.kernel.org>

--001a114724ac8de11705124f216e
Content-Type: text/plain; charset=UTF-8

Hi Jens,
Apologies for the late response - it doesn't look like we'll be able to
work on this bug anytime soon.

On Fri, Mar 20, 2015 at 9:37 AM, Jens Axboe <axboe@kernel.dk> wrote:

> On 03/18/2015 10:24 PM, Akash Verma wrote:
>
>> This commit seems to have broken the behavior of random IOs with zone
>> options:
>>
>> 4c8be5b1569f0aca8c7769803e57b79280d1f668
>>
>> Using this example job file:
>> [zoned_out]
>> rw=read
>> bs=1k
>> offset=510k
>> ioengine=sync
>> zonesize=1k
>> zonerange=512k
>> zoneskip=512k
>> write_iolog=ios_meec.iolog
>> filename=10MFile
>>
>> where 10M file was created as:
>> dd if=/dev/zero of=./10MFile bs=1M count=10
>>
>> Prior to the above commit, FIO does one read per zone, and the job
>> exits after the last zone. This is as expected.
>>
>> Post the above commit, FIO loops back to the first zone and may or may
>> not succeed in finding a valid offset to seek to. With offset=510k, it
>> fails on the first loop-back. With offset=100k, it fails on the
>> second; with no offset, it did about a 100 loops. With --debug=random,
>> I see messages like:
>>
>> file     1885  get file 10MFile, ref=1
>> random   1885  off rand 1823528783
>> io       1885  get_next_offset: offset 18446744073708827648 >= size
>> 10485760
>> io       1885  io_u 0x8c8e80, failed getting offset
>>
>> There should be no loop-back happening at all unless this is specified
>> as desired (e.g. using runtime and time_based, or io_limit, or
>> number_ios).
>>
>
> It might be more work, but yes, that I think is a good start. Care to send
> a patch to stop looping unless we're forced to? At least that will fix the
> case of buggy looping.
>
> --
> Jens Axboe
>
>

--001a114724ac8de11705124f216e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Jens,<div>Apologies for the late response - it doesn&#3=
9;t look like we&#39;ll be able to work on this bug anytime soon.</div></di=
v><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri, Mar 20,=
 2015 at 9:37 AM, Jens Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@=
kernel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span> wrote:<br><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 03/18/=
2015 10:24 PM, Akash Verma wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
This commit seems to have broken the behavior of random IOs with zone optio=
ns:<br>
<br>
4c8be5b1569f0aca8c7769803e57b7<u></u>9280d1f668<br>
<br>
Using this example job file:<br>
[zoned_out]<br>
rw=3Dread<br>
bs=3D1k<br>
offset=3D510k<br>
ioengine=3Dsync<br>
zonesize=3D1k<br>
zonerange=3D512k<br>
zoneskip=3D512k<br>
write_iolog=3Dios_meec.iolog<br>
filename=3D10MFile<br>
<br>
where 10M file was created as:<br>
dd if=3D/dev/zero of=3D./10MFile bs=3D1M count=3D10<br>
<br>
Prior to the above commit, FIO does one read per zone, and the job<br>
exits after the last zone. This is as expected.<br>
<br>
Post the above commit, FIO loops back to the first zone and may or may<br>
not succeed in finding a valid offset to seek to. With offset=3D510k, it<br=
>
fails on the first loop-back. With offset=3D100k, it fails on the<br>
second; with no offset, it did about a 100 loops. With --debug=3Drandom,<br=
>
I see messages like:<br>
<br>
file=C2=A0 =C2=A0 =C2=A01885=C2=A0 get file 10MFile, ref=3D1<br>
random=C2=A0 =C2=A01885=C2=A0 off rand 1823528783<br>
io=C2=A0 =C2=A0 =C2=A0 =C2=A01885=C2=A0 get_next_offset: offset 18446744073=
708827648 &gt;=3D size 10485760<br>
io=C2=A0 =C2=A0 =C2=A0 =C2=A01885=C2=A0 io_u 0x8c8e80, failed getting offse=
t<br>
<br>
There should be no loop-back happening at all unless this is specified<br>
as desired (e.g. using runtime and time_based, or io_limit, or<br>
number_ios).<br>
</blockquote>
<br></div></div>
It might be more work, but yes, that I think is a good start. Care to send =
a patch to stop looping unless we&#39;re forced to? At least that will fix =
the case of buggy looping.<span class=3D"HOEnZb"><font color=3D"#888888"><b=
r>
<br>
-- <br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--001a114724ac8de11705124f216e--

