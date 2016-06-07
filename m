Return-Path: <karasing@redhat.com>
MIME-Version: 1.0
In-Reply-To: <5756D05D.2050205@kernel.dk>
References: <CAKapHkMhGrnb1g=b9Pz_D_Frx8OSP65aiXBBM_KgVy5wpSz-kw@mail.gmail.com>
	<5756D05D.2050205@kernel.dk>
Date: Wed, 8 Jun 2016 00:00:41 +0300
Message-ID: <CAKapHkOvjdOXsOTsvWx8dWtfo0mQWC=C23+-NcJLs53hoFx+-w@mail.gmail.com>
Subject: Re: System IOPS vs. fio IOPS
From: Karan Singh <karan@redhat.com>
Content-Type: multipart/alternative; boundary=001a113d1c2652d7490534b67b0e
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--001a113d1c2652d7490534b67b0e
Content-Type: text/plain; charset=UTF-8

On Tue, Jun 7, 2016 at 4:47 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 06/06/2016 03:41 PM, Karan Singh wrote:
>
>> #1  : Is r/s and w/s fields in iostat output corresponds to read and
>> write IOPS ? (
>> https://serverfault.com/questions/342273/disk-iops-count-in-gnu-linux
>> mentions r/s and w/s as IOPS)
>> #2  : If yes then why does they dont match with FIO IOPS results ?
>>
>
> The answer is no, and that goes for any application. You could have an app
> that does sequential ios in 4k chunks, and the kernel merges them into 512k
> IOs. From the application perspective, it's doing 128 as many iops as the
> device is. The converse can also be true, like in your case, since the
> application is submitting IO that is larger than the device can handle.
> Hence it's broken up, and the result is that the device is now doing a lot
> more IOPS than the application is issuing.


Thanks Jens for answering

You said kernel merges / divides IO into 512k chunk.

#1 How can i verify this (512k) value, any command or file to look this
into ?
#2 Out of curiosity is there a way to disable this merging / division of IO
? it might be not efficient but just want to play around this.
#3 Is it true that merging /division of IO is irrespective of pattern (
sequential or random ) i.e kernel will perform this whether the IO is seq.
or random ?


>
> --
> Jens Axboe
>
>

--001a113d1c2652d7490534b67b0e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Tue, Jun 7, 2016 at 4:47 PM, Jens Axboe <span dir=3D"ltr">&lt;<a href=3D=
"mailto:axboe@kernel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span> w=
rote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;borde=
r-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 06/06/2016 03:4=
1 PM, Karan Singh wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
#1=C2=A0 : Is r/s and w/s fields in iostat output corresponds to read and<b=
r>
write IOPS ? ( <a href=3D"https://serverfault.com/questions/342273/disk-iop=
s-count-in-gnu-linux" rel=3D"noreferrer" target=3D"_blank">https://serverfa=
ult.com/questions/342273/disk-iops-count-in-gnu-linux</a><br>
mentions r/s and w/s as IOPS)<br>
#2=C2=A0 : If yes then why does they dont match with FIO IOPS results ?<br>
</blockquote>
<br></span>
The answer is no, and that goes for any application. You could have an app =
that does sequential ios in 4k chunks, and the kernel merges them into 512k=
 IOs. From the application perspective, it&#39;s doing 128 as many iops as =
the device is. The converse can also be true, like in your case, since the =
application is submitting IO that is larger than the device can handle. Hen=
ce it&#39;s broken up, and the result is that the device is now doing a lot=
 more IOPS than the application is issuing.</blockquote><div><br></div><div=
>Thanks Jens for answering<br></div><div><br></div><div>You said kernel mer=
ges / divides IO into 512k chunk.=C2=A0</div><div><br></div><div>#1 How can=
 i verify this (512k) value, any command or file to look this into ?</div><=
div>#2 Out of curiosity is there a way to disable this merging / division o=
f IO ? it might be not efficient but just want to play around this.</div><d=
iv>#3 Is it true that merging /division of IO is irrespective of pattern ( =
sequential or random ) i.e kernel will perform this whether the IO is seq. =
or random ?</div><div><br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
-- <br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div></div>

--001a113d1c2652d7490534b67b0e--

