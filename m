Return-Path: <d.ketor@gmail.com>
MIME-Version: 1.0
In-Reply-To: <544C2371.1020403@catalyst.net.nz>
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk>
 <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com>
 <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz>
 <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz>
 <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk>
 <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk> <544C2371.1020403@catalyst.net.nz>
From: Ketor D <d.ketor@gmail.com>
Date: Mon, 27 Oct 2014 17:27:36 +0800
Message-ID: <CAM9_UU_S7qhenZW34Lw3r=RHoVa1__610RRsFScgt0adi1dpFw@mail.gmail.com>
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
Content-Type: multipart/alternative; boundary=089e01184810eb91bc0506642545
To: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>
Cc: Jens Axboe <axboe@kernel.dk>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--089e01184810eb91bc0506642545
Content-Type: text/plain; charset=UTF-8

Hi, Jens:
          I have test your v2 and v3 patch.
          The v2 patch get SIGABT and crash. The v3 patch hang.

         Why not simply comment usleep?


2014-10-26 6:25 GMT+08:00 Mark Kirkwood <mark.kirkwood@catalyst.net.nz>:

> On 26/10/14 08:20, Jens Axboe wrote:
>
>> On 10/24/2014 10:50 PM, Mark Kirkwood wrote:
>>
>>> On 25/10/14 16:47, Jens Axboe wrote:
>>>
>>>>
>>>> Since you're running rbd tests... Mind giving this patch a go? I don't
>>>> have an easy way to test it myself. It has nothing to do with this
>>>> issue, it's just a potentially faster way to do the rbd completions.
>>>>
>>>>
>>> Sure - but note I'm testing this on my i7 workstation (4x osd's running
>>> on 2x Crucial M550) so not exactly server grade :-)
>>>
>>> With that in mind, I'm seeing slightly *slower* performance with the
>>> patch applied: e.g: for 128k blocks - 2 runs, 1 uncached and the next
>>> cached.
>>>
>>
>> Yeah, that doesn't look good. Mind trying this one out? I wonder if we
>> doubly wait on them - or perhaps rbd_aio_wait_for_complete() isn't
>> working correctly. If you try this one, we should know more...
>>
>> Goal is, I want to get rid of that usleep() in getevents.
>>
>>
> Testing with v3 patch applied hangs. I did wonder if we had somehow hit a
> new variant of the cache issue - so reran with it disabled in ceph.conf.
> Result is the same:
>
> $ fio read-test.fio
> rbd_thread: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K,
> ioengine=rbd, iodepth=32
> fio-2.1.13-88-gb2ee7
> Starting 1 process
> rbd engine: RBD version: 0.1.8
> Jobs: 1 (f=1): [R(1)] [0.1% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
> 01h:25m:15s]
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--089e01184810eb91bc0506642545
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi, Jens:<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 I have te=
st your v2 and v3 patch.</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 The v=
2 patch get SIGABT and crash. The v3 patch hang.</div><div><br></div><div>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Why not simply comment usleep?</div><div>=
<br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2=
014-10-26 6:25 GMT+08:00 Mark Kirkwood <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:mark.kirkwood@catalyst.net.nz" target=3D"_blank">mark.kirkwood@catalyst=
.net.nz</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOE=
nZb"><div class=3D"h5">On 26/10/14 08:20, Jens Axboe wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 10/24/2014 10:50 PM, Mark Kirkwood wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 25/10/14 16:47, Jens Axboe wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
Since you&#39;re running rbd tests... Mind giving this patch a go? I don&#3=
9;t<br>
have an easy way to test it myself. It has nothing to do with this<br>
issue, it&#39;s just a potentially faster way to do the rbd completions.<br=
>
<br>
</blockquote>
<br>
Sure - but note I&#39;m testing this on my i7 workstation (4x osd&#39;s run=
ning<br>
on 2x Crucial M550) so not exactly server grade :-)<br>
<br>
With that in mind, I&#39;m seeing slightly *slower* performance with the<br=
>
patch applied: e.g: for 128k blocks - 2 runs, 1 uncached and the next<br>
cached.<br>
</blockquote>
<br>
Yeah, that doesn&#39;t look good. Mind trying this one out? I wonder if we<=
br>
doubly wait on them - or perhaps rbd_aio_wait_for_complete() isn&#39;t<br>
working correctly. If you try this one, we should know more...<br>
<br>
Goal is, I want to get rid of that usleep() in getevents.<br>
<br>
</blockquote>
<br></div></div>
Testing with v3 patch applied hangs. I did wonder if we had somehow hit a n=
ew variant of the cache issue - so reran with it disabled in ceph.conf. Res=
ult is the same:<span class=3D""><br>
<br>
$ fio read-test.fio<br>
rbd_thread: (g=3D0): rw=3Dread, bs=3D128K-128K/128K-128K/128K-<u></u>128K, =
ioengine=3Drbd, iodepth=3D32<br>
fio-2.1.13-88-gb2ee7<br>
Starting 1 process<br>
rbd engine: RBD version: 0.1.8<br></span>
Jobs: 1 (f=3D1): [R(1)] [0.1% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 01h:=
25m:15s]<div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
<br>
<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe ceph-devel&q=
uot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org" targe=
t=3D"_blank">majordomo@vger.kernel.org</a><br>
More majordomo info at=C2=A0 <a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/<u></u>majordomo-info.htm=
l</a><br>
</div></div></blockquote></div><br></div>

--089e01184810eb91bc0506642545--

