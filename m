Return-Path: <gwendal@google.com>
MIME-Version: 1.0
Sender: gwendal@google.com
In-Reply-To: <53CCCF60.9090208@kernel.dk>
References: <CAMHSBOXb0f9iZFLiJSXPiT+8yXe8QbF-bS_4KA1c1+=Wps_K_A@mail.gmail.com>
 <53C8D124.60202@kernel.dk> <53CCCF60.9090208@kernel.dk>
From: Gwendal Grignou <gwendal@chromium.org>
Date: Mon, 21 Jul 2014 10:41:23 -0700
Message-ID: <CAMHSBOXntY7AoEkbO18M0kKBD6SjS7ytnJZyyAwhQN0SNmnX7g@mail.gmail.com>
Subject: Re: [fio-2.1.9] verify and bssplit do not work together
Content-Type: multipart/alternative; boundary=bcaec51dd641d1117104feb79e7e
To: Jens Axboe <axboe@kernel.dk>
Cc: Gwendal Grignou <gwendal@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--bcaec51dd641d1117104feb79e7e
Content-Type: text/plain; charset=UTF-8

Jens,

Without the patch, experimental_verify=1 produced more error, it looks like
every 64k.

With the patch above, fio behaves as expected: do_verify and
experimental_verify
works for mixed writes.

There is still a problem when bs is mixed and one argument is less than the
verify interval.
For instance:
bssplit=4k/50:1M/50
...
verify_interval=64k


But looking at the code, it won't be possible to fix, because we can not
guarantee to always have 16 4K write contiguous.

Thanks for the patch.

Gwendal.




On Mon, Jul 21, 2014 at 1:29 AM, Jens Axboe <axboe@kernel.dk> wrote:

> On 2014-07-18 09:47, Jens Axboe wrote:
>
>> On 2014-07-17 22:36, Gwendal Grignou wrote:
>>
>>> Jens,
>>>
>>> I notice that when I enable bssplit and verify, verify always fails:
>>>
>>> ...
>>> meta: verify failed at file /tmp/test offset 7143424, length 65536
>>> open verify buf file: Read-only file system
>>> ....
>>> In my tests, the offsets that fails are always:
>>> 7143424, 15073280, 2647654, 450397184, 88080384, 88211456
>>>
>>> it does not happen when I set a fixed size with bs, or when I do not
>>> verify.
>>>
>>> Here is the fio control file I use:
>>>
>>> [stress]
>>> filename=/tmp/test
>>> size=107374182
>>>
>>> readwrite=randrw
>>> bssplit=64k/50:1M/50
>>> ;bs=64k
>>>
>>> do_verify=1
>>> verify=meta
>>> verify_interval=64k
>>> verify_dump=1
>>> continue_on_error=verify
>>>
>>
>> That does sound like a bug. Out of curiosity, does anything change if
>> you set experimental_verify=1 in the job?
>>
>> I'll take a look at this next week, currently away on vacation.
>>
>>  Also, if I set a verify_interval larger than the smallest io size in
>>> bssplt, I get another kind of error.
>>> Error messages with bssplt=4k/50:1M/50:
>>>
>>> verify: bad magic header a678, wanted acca at file /tmp/test offset
>>> 9097216, length 429524186
>>> verify: bad magic header 84b9, wanted acca at file /tmp/test offset
>>> 25268224, length 21518097
>>> verify: bad magic header ba51, wanted acca at file /tmp/test offset
>>> 26505216, length 536429778
>>> verify: bad magic header 1197, wanted acca at file /tmp/test offset
>>> 42139648, length 373139796
>>> verify: bad magic header 22bf, wanted acca at file /tmp/test offset
>>> 42209280, length 493427719
>>> meta: verify failed at file /tmp/test offset 50462720, length 65536
>>> open verify buf file: Read-only file system
>>> open verify buf file: Read-only file system
>>> verify: bad magic header d1f6, wanted acca at file /tmp/test offset
>>> 52305920, length 322125536
>>> verify: bad magic header 76ee, wanted acca at file /tmp/test offset
>>> 92106752, length 355054425
>>> verify: bad magic header 821, wanted acca at file /tmp/test offset
>>> 94904320, length 460051914
>>>
>>> I don't get these error when I set bs=4k.
>>> Are you aware of such a limitation in fio?
>>>
>>
>> Fio doesn't support verify intervals larger than a single written block,
>> so that is something the parser or option checker should catch.
>> Apparently it doesn't. I'll take a look at this too.
>>
>
> Looks like it's numberio biting us again... Can you try with this patch?
> For the mixed case, haven't looked into interval > bs yet.
>
> --
> Jens Axboe
>
>

--bcaec51dd641d1117104feb79e7e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Jens,<div><br></div><div>Without the patch,=C2=A0<span sty=
le=3D"font-family:arial,sans-serif;font-size:13px">experimental_verify=3D1 =
produced more error, it looks like every 64k.</span></div><div><font face=
=3D"arial, sans-serif"><br>


</font></div><div><font face=3D"arial, sans-serif">With the patch above, fi=
o behaves as expected: do_verify and=C2=A0</font><span style=3D"font-family=
:arial,sans-serif;font-size:13px">experimental_verify works for mixed write=
s.</span></div>


<div><font face=3D"arial, sans-serif"><br></font></div><div><font face=3D"a=
rial, sans-serif">There is still a problem when bs is mixed and one argumen=
t is less than the verify interval.</font></div><div><font face=3D"arial, s=
ans-serif">For instance:</font></div>


<div><font face=3D"arial, sans-serif"><div>bssplit=3D4k/50:1M/50</div><div>=
...</div><div><div>verify_interval=3D64k</div></div><div><br></div></font><=
/div><div><font face=3D"arial, sans-serif"><br></font></div><div><font face=
=3D"arial, sans-serif">But looking at the code, it won&#39;t be possible to=
 fix, because we can not guarantee to always have 16 4K write contiguous.</=
font></div>


<div><font face=3D"arial, sans-serif"><br></font></div><div><font face=3D"a=
rial, sans-serif">Thanks for the patch.</font></div><div><font face=3D"aria=
l, sans-serif"><br></font></div><div><font face=3D"arial, sans-serif">Gwend=
al.<br>


</font><div><br><div><br></div></div></div></div><div class=3D"gmail_extra"=
><br><br><div class=3D"gmail_quote">On Mon, Jul 21, 2014 at 1:29 AM, Jens A=
xboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=3D"_bl=
ank">axboe@kernel.dk</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 2=
014-07-18 09:47, Jens Axboe wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 2014-07-17 22:36, Gwendal Grignou wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Jens,<br>
<br>
I notice that when I enable bssplit and verify, verify always fails:<br>
<br>
...<br>
meta: verify failed at file /tmp/test offset 7143424, length 65536<br>
open verify buf file: Read-only file system<br>
....<br>
In my tests, the offsets that fails are always:<br>
7143424, 15073280, 2647654, 450397184, 88080384, 88211456<br>
<br>
it does not happen when I set a fixed size with bs, or when I do not<br>
verify.<br>
<br>
Here is the fio control file I use:<br>
<br>
[stress]<br>
filename=3D/tmp/test<br>
size=3D107374182<br>
<br>
readwrite=3Drandrw<br>
bssplit=3D64k/50:1M/50<br>
;bs=3D64k<br>
<br>
do_verify=3D1<br>
verify=3Dmeta<br>
verify_interval=3D64k<br>
verify_dump=3D1<br>
continue_on_error=3Dverify<br>
</blockquote>
<br>
That does sound like a bug. Out of curiosity, does anything change if<br>
you set experimental_verify=3D1 in the job?<br>
<br>
I&#39;ll take a look at this next week, currently away on vacation.<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Also, if I set a verify_interval larger than the smallest io size in<br>
bssplt, I get another kind of error.<br>
Error messages with bssplt=3D4k/50:1M/50:<br>
<br>
verify: bad magic header a678, wanted acca at file /tmp/test offset<br>
9097216, length 429524186<br>
verify: bad magic header 84b9, wanted acca at file /tmp/test offset<br>
25268224, length 21518097<br>
verify: bad magic header ba51, wanted acca at file /tmp/test offset<br>
26505216, length 536429778<br>
verify: bad magic header 1197, wanted acca at file /tmp/test offset<br>
42139648, length 373139796<br>
verify: bad magic header 22bf, wanted acca at file /tmp/test offset<br>
42209280, length 493427719<br>
meta: verify failed at file /tmp/test offset 50462720, length 65536<br>
open verify buf file: Read-only file system<br>
open verify buf file: Read-only file system<br>
verify: bad magic header d1f6, wanted acca at file /tmp/test offset<br>
52305920, length 322125536<br>
verify: bad magic header 76ee, wanted acca at file /tmp/test offset<br>
92106752, length 355054425<br>
verify: bad magic header 821, wanted acca at file /tmp/test offset<br>
94904320, length 460051914<br>
<br>
I don&#39;t get these error when I set bs=3D4k.<br>
Are you aware of such a limitation in fio?<br>
</blockquote>
<br>
Fio doesn&#39;t support verify intervals larger than a single written block=
,<br>
so that is something the parser or option checker should catch.<br>
Apparently it doesn&#39;t. I&#39;ll take a look at this too.<br>
</blockquote>
<br></div></div>
Looks like it&#39;s numberio biting us again... Can you try with this patch=
? For the mixed case, haven&#39;t looked into interval &gt; bs yet.<span cl=
ass=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
-- <br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--bcaec51dd641d1117104feb79e7e--

