Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
In-Reply-To: <554B766A.2090703@kernel.dk>
References: <CABtFm2U5t2=sM4MDKhaPn7n9nsJTSBUCSUeZ=9irt8EEBTogBQ@mail.gmail.com>
	<5547D8F3.6090408@kernel.dk>
	<CABtFm2Xwk7krWgobsW0JfCMuGvjFaUzeORggei7+gdVqg2rjhg@mail.gmail.com>
	<CAF+0mvkxEvMfjE3r2ffAz6QWMrHMLfmJOhNU5_3kcYO9Qdm9dg@mail.gmail.com>
	<CABtFm2VhjHURUMHfB=iPoXZfa+_m8xm9qpBCQmv=2UB+Rd-BYA@mail.gmail.com>
	<554B766A.2090703@kernel.dk>
Date: Thu, 7 May 2015 23:30:53 +0800
Message-ID: <CABtFm2UF+Bgj9NpxSnt5SfUE7ZT9+qau9HXVgqMNPWmR1+6vQg@mail.gmail.com>
Subject: Re: achieving a workload to get specific unique duplicate blocks
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: multipart/alternative; boundary=047d7b10c94de11caa05157f9814
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Matthew Eaton <m.eaton82@gmail.com>
List-ID: <fio@vger.kernel.org>

--047d7b10c94de11caa05157f9814
Content-Type: text/plain; charset=UTF-8

Sorry for that. Thanks for clarification on refill_buffers.
On 07-May-2015 10:27 pm, "Jens Axboe" <axboe@kernel.dk> wrote:

> On 05/06/2015 09:58 PM, Srinivasa Chamarthy wrote:
>
>> Thanks Eaton. One question thought. From the man page for refill_buffers:
>>
>> "If this option is given, fio will refill the IO buffers on every
>> submit. The default is to only fill it at init time and reuse that
>> data. Only makes sense if zero_buffers isn't specified, naturally. If
>> data verification is enabled, refill_buffers is also automatically
>> enabled."
>>
>> Every IO submitted will have a new pattern for repeated workloads?
>> using refill_buffers, i seem to get same pattern repeatedly. Is that
>> how it should be? i was under the impression that refill will use new
>> pattern every time.
>>
>> # fio --filename=test_refill --readwrite=randwrite --size=1m
>> --refill_buffers --bs=256k --norandommap --name=refill
>> # for each in {0..3}; do dd if=test_refill bs=262144 count=1
>> skip=$each 2>/dev/null | md5sum; done
>> 86c3e47e173a58ad93470fd8db856f8c  -
>> 6fe5ce86d04522889c99809d6d97cb94  -
>> 9113ce00f3781861afc41aaf6da32428  -
>> f0b575c40e9da23b524f585723cbea4e  -
>>
>> # fio --filename=test_refill --readwrite=randwrite --size=1m
>> --refill_buffers --bs=256k --norandommap --name=refill
>> # for each in {0..3}; do dd if=test_refill bs=262144 count=1
>> skip=$each 2>/dev/null | md5sum; done
>> 86c3e47e173a58ad93470fd8db856f8c  -
>> 6fe5ce86d04522889c99809d6d97cb94  -
>> 9113ce00f3781861afc41aaf6da32428  -
>> f0b575c40e9da23b524f585723cbea4e  -
>>
>
> First of all, please stop top posting. It breaks the flow of conversations.
>
> Secondly, this is expected behavior, and it's done to get identical
> behavior between runs. If you had longer runs, each buffer would be
> different. But if you did a new run after that, the sequence of buffers
> would be the same. Same thing happens with the offsets generated, the
> buffer lengths generated, etc.
>
> If you want a truly different run everytime, you have a few options. One
> is to simply set randrepeat=0, then OS entropy will seed the random
> generators. Or you can use randseed= to set a specific seed, which would
> allow you to reproduce a specific run.
>
>
> --
> Jens Axboe
>
>

--047d7b10c94de11caa05157f9814
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Sorry for that. Thanks for clarification on refill_buffers. =
</p>
<div class=3D"gmail_quote">On 07-May-2015 10:27 pm, &quot;Jens Axboe&quot; =
&lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br ty=
pe=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">On 05/06/2015 09:58 PM, S=
rinivasa Chamarthy wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Thanks Eaton. One question thought. From the man page for refill_buffers:<b=
r>
<br>
&quot;If this option is given, fio will refill the IO buffers on every<br>
submit. The default is to only fill it at init time and reuse that<br>
data. Only makes sense if zero_buffers isn&#39;t specified, naturally. If<b=
r>
data verification is enabled, refill_buffers is also automatically<br>
enabled.&quot;<br>
<br>
Every IO submitted will have a new pattern for repeated workloads?<br>
using refill_buffers, i seem to get same pattern repeatedly. Is that<br>
how it should be? i was under the impression that refill will use new<br>
pattern every time.<br>
<br>
# fio --filename=3Dtest_refill --readwrite=3Drandwrite --size=3D1m<br>
--refill_buffers --bs=3D256k --norandommap --name=3Drefill<br>
# for each in {0..3}; do dd if=3Dtest_refill bs=3D262144 count=3D1<br>
skip=3D$each 2&gt;/dev/null | md5sum; done<br>
86c3e47e173a58ad93470fd8db856f8c=C2=A0 -<br>
6fe5ce86d04522889c99809d6d97cb94=C2=A0 -<br>
9113ce00f3781861afc41aaf6da32428=C2=A0 -<br>
f0b575c40e9da23b524f585723cbea4e=C2=A0 -<br>
<br>
# fio --filename=3Dtest_refill --readwrite=3Drandwrite --size=3D1m<br>
--refill_buffers --bs=3D256k --norandommap --name=3Drefill<br>
# for each in {0..3}; do dd if=3Dtest_refill bs=3D262144 count=3D1<br>
skip=3D$each 2&gt;/dev/null | md5sum; done<br>
86c3e47e173a58ad93470fd8db856f8c=C2=A0 -<br>
6fe5ce86d04522889c99809d6d97cb94=C2=A0 -<br>
9113ce00f3781861afc41aaf6da32428=C2=A0 -<br>
f0b575c40e9da23b524f585723cbea4e=C2=A0 -<br>
</blockquote>
<br>
First of all, please stop top posting. It breaks the flow of conversations.=
<br>
<br>
Secondly, this is expected behavior, and it&#39;s done to get identical beh=
avior between runs. If you had longer runs, each buffer would be different.=
 But if you did a new run after that, the sequence of buffers would be the =
same. Same thing happens with the offsets generated, the buffer lengths gen=
erated, etc.<br>
<br>
If you want a truly different run everytime, you have a few options. One is=
 to simply set randrepeat=3D0, then OS entropy will seed the random generat=
ors. Or you can use randseed=3D to set a specific seed, which would allow y=
ou to reproduce a specific run.<br>
<br>
<br>
-- <br>
Jens Axboe<br>
<br>
</blockquote></div>

--047d7b10c94de11caa05157f9814--

