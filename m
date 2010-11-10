Return-Path: <Udi.S.Karni@kp.org>
MIME-Version: 1.0
From: "Udi.S.Karni@kp.org" <Udi.S.Karni@kp.org>
Date: Wed, 10 Nov 2010 14:32:51 -0700
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: 
 <OF07E686E5.45391A88-ON882577D7.0075C3B1-882577D7.00765E2A@kp.org>
In-Reply-To: <4CDAF701.8000301@fusionio.com>
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_OF07E686E545391A88ON882577D70075C3B1882577D700765E2Akpo_"
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "fio-owner@vger.kernel.org" <fio-owner@vger.kernel.org>, "sebastian@skayser.de" <sebastian@skayser.de>
List-ID: <fio@vger.kernel.org>

--_000_OF07E686E545391A88ON882577D70075C3B1882577D700765E2Akpo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Guys - if top IOPS is really crucial and you have the luxury of not needing=
 too much space - I heard of a credit card company that only used 1 cylinde=
r on every disk.

So -

(1) no seek time - the disk arm is always above the "one" cylinder
(2) no actual search time - the contents of a single cylinder can easily be=
 completely cached in the cache buffer of the disk
(3) writes still need to be commited to the platter from the cache - but wi=
th only 1 cylinder - it's not a problem keeping up
(4) so Random IO isn't any more onerous than Sequential IO

In other words - SSD performance on disk. If you need more space you can us=
e 2 or 3 cylinders.... however many can fit on the disk cache. The seek tim=
e to move a couple of cylinders over is pretty negligible.

Regards,

Udi Karni
DBA
Pharmacy Analytical Services
Kaiser Pharmacy
desk: 562.401.4229 / 8-345
cell: 310.995.4104
email: udi.s.karni@kp.org



NOTICE TO RECIPIENT:  If you are not the intended recipient of this e-mail,=
 you are prohibited from sharing, copying, or otherwise using or disclosing=
 its contents.  If you have received this e-mail in error, please notify th=
e sender immediately by reply e-mail and permanently delete this e-mail and=
 any attachments without reading, forwarding or saving them.  Thank you.



Jens Axboe <jaxboe@fusionio.com>
Sent by: fio-owner@vger.kernel.org

11/10/2010 11:48 AM
To
Sebastian Kayser <sebastian@skayser.de>
cc
<fio@vger.kernel.org>
Subject
Re: IOPS higher than expected on randwrite, direct=3D1 tests





On 2010-11-10 18:18, Sebastian Kayser wrote:
> * Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 2010-11-10 09:22, Sebastian Kayser wrote:
>>> Just to make sure my understanding is correct:
>>> - direct=3D1 should mitigate (disable?) OS caching effects
>>> - sync=3D1, iodepth=3D1 should make sure that an I/O has really made it=
 to
>>>   disk before the next on is issued, i.e. should de-facto disable
>>>   I/O coalescing or device caching
>>>
>>> Are these sane/valid assumptions?
>>
>> Yes, your assumptions are valid. I think the issue here is that you give
>> randwrite, but don't also specify that you want overwrites. So what
>> happens is that the file will be truncated and then randomly written,
>> allowing the file system to place randomly chosen file block together.
>> If you remove the test file and re-run with overwrite=3D1 added, then se=
e
>> if those results are more in line with what you expect.
>
> Thanks for the additional aspect! So the possible pitfall is that w/o
> overwrite=3D1 the test file could be sparse and the file system then
> re-arrange random file addresses to fall onto consecutive device blocks?
>
> (If so, wouldn't that be evil / deliberate data fragmentation?)

Depends on whether you care about the write performance or the read-back
performance :-)

> Tested it again with overwrite=3D1, same IOPS figures. Test file size as
> measured with du -ks is the same in both cases btw. (which combined with
> the limited runtime=3D120 doesn't seem to indicate sparseness in case of
> overwrite=3D0, right?).

Was the file pre-created? I'm pretty sure that fio will not lay it out
first with a write workload, even for random writes (I could be wrong
though, and if the file is indeed non-sparse and the test stopped before
all IO was written, then it would have been sparse for this case).

> What I will do now is to export the whole 2TB of the disk (instead of
> just 10GB) and increase size=3D to see whether that makes any difference
> (hopefully). Other than that, further ideas?

Lets see what that yields.

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--_000_OF07E686E545391A88ON882577D70075C3B1882577D700765E2Akpo_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


<br><font size=3D2 face=3D"sans-serif">Guys - if top IOPS is really crucial
and you have the luxury of not needing too much space - I heard of a credit
card company that only used 1 cylinder on every disk.</font>
<br>
<br><font size=3D2 face=3D"sans-serif">So - </font>
<br>
<br><font size=3D2 face=3D"sans-serif">(1) no seek time - the disk arm is a=
lways
above the &quot;one&quot; cylinder</font>
<br><font size=3D2 face=3D"sans-serif">(2) no actual search time - the cont=
ents
of a single cylinder can easily be completely cached in the cache buffer
of the disk</font>
<br><font size=3D2 face=3D"sans-serif">(3) writes still need to be commited
to the platter from the cache - but with only 1 cylinder - it's not a probl=
em
keeping up</font>
<br><font size=3D2 face=3D"sans-serif">(4) so Random IO isn't any more oner=
ous
than Sequential IO</font>
<br>
<br><font size=3D2 face=3D"sans-serif">In other words - SSD performance on
disk. If you need more space you can use 2 or 3 cylinders.... however many
can fit on the disk cache. The seek time to move a couple of cylinders
over is pretty negligible.</font>
<br><font size=3D2 face=3D"sans-serif"><br>
Regards,<br>
<br>
Udi Karni<br>
DBA<br>
Pharmacy Analytical Services<br>
Kaiser Pharmacy<br>
desk: 562.401.4229 / 8-345<br>
cell: 310.995.4104<br>
email: udi.s.karni@kp.org <br>
<br>
<br>
<br>
</font><font size=3D1 color=3Dblue face=3D"Arial"><b>NOTICE TO RECIPIENT:</=
b></font><font size=3D1 face=3D"Arial">
&nbsp;If you are not the intended recipient of this e-mail, you are prohibi=
ted
from sharing, copying, or otherwise using or disclosing its contents. &nbsp=
;If
you have received this e-mail in error, please notify the sender immediatel=
y
by reply e-mail and permanently delete this e-mail and any attachments
without reading, forwarding or saving them. &nbsp;Thank you.<br>
</font>
<br>
<br>
<br>
<table width=3D100%>
<tr valign=3Dtop>
<td width=3D40%><font size=3D1 face=3D"sans-serif"><b>Jens Axboe &lt;jaxboe=
@fusionio.com&gt;</b>
</font>
<br><font size=3D1 face=3D"sans-serif">Sent by: fio-owner@vger.kernel.org</=
font>
<p><font size=3D1 face=3D"sans-serif">11/10/2010 11:48 AM</font>
<td width=3D59%>
<table width=3D100%>
<tr valign=3Dtop>
<td>
<div align=3Dright><font size=3D1 face=3D"sans-serif">To</font></div>
<td><font size=3D1 face=3D"sans-serif">Sebastian Kayser &lt;sebastian@skays=
er.de&gt;</font>
<tr valign=3Dtop>
<td>
<div align=3Dright><font size=3D1 face=3D"sans-serif">cc</font></div>
<td><font size=3D1 face=3D"sans-serif">&lt;fio@vger.kernel.org&gt;</font>
<tr valign=3Dtop>
<td>
<div align=3Dright><font size=3D1 face=3D"sans-serif">Subject</font></div>
<td><font size=3D1 face=3D"sans-serif">Re: IOPS higher than expected on ran=
dwrite,
direct=3D1 tests</font></table>
<br>
<table>
<tr valign=3Dtop>
<td>
<td></table>
<br></table>
<br>
<br>
<br><font size=3D2><tt>On 2010-11-10 18:18, Sebastian Kayser wrote:<br>
&gt; * Jens Axboe &lt;jaxboe@fusionio.com&gt; wrote:<br>
&gt;&gt; On 2010-11-10 09:22, Sebastian Kayser wrote:<br>
&gt;&gt;&gt; Just to make sure my understanding is correct:<br>
&gt;&gt;&gt; - direct=3D1 should mitigate (disable?) OS caching effects<br>
&gt;&gt;&gt; - sync=3D1, iodepth=3D1 should make sure that an I/O has reall=
y
made it to<br>
&gt;&gt;&gt; &nbsp; disk before the next on is issued, i.e. should de-facto
disable<br>
&gt;&gt;&gt; &nbsp; I/O coalescing or device caching<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Are these sane/valid assumptions?<br>
&gt;&gt;<br>
&gt;&gt; Yes, your assumptions are valid. I think the issue here is that
you give<br>
&gt;&gt; randwrite, but don't also specify that you want overwrites. So
what<br>
&gt;&gt; happens is that the file will be truncated and then randomly writt=
en,<br>
&gt;&gt; allowing the file system to place randomly chosen file block toget=
her.<br>
&gt;&gt; If you remove the test file and re-run with overwrite=3D1 added,
then see<br>
&gt;&gt; if those results are more in line with what you expect.<br>
&gt; <br>
&gt; Thanks for the additional aspect! So the possible pitfall is that
w/o<br>
&gt; overwrite=3D1 the test file could be sparse and the file system then<b=
r>
&gt; re-arrange random file addresses to fall onto consecutive device block=
s?<br>
&gt; <br>
&gt; (If so, wouldn't that be evil / deliberate data fragmentation?)<br>
<br>
Depends on whether you care about the write performance or the read-back<br=
>
performance :-)<br>
<br>
&gt; Tested it again with overwrite=3D1, same IOPS figures. Test file size
as<br>
&gt; measured with du -ks is the same in both cases btw. (which combined
with<br>
&gt; the limited runtime=3D120 doesn't seem to indicate sparseness in case
of<br>
&gt; overwrite=3D0, right?).<br>
<br>
Was the file pre-created? I'm pretty sure that fio will not lay it out<br>
first with a write workload, even for random writes (I could be wrong<br>
though, and if the file is indeed non-sparse and the test stopped before<br=
>
all IO was written, then it would have been sparse for this case).<br>
<br>
&gt; What I will do now is to export the whole 2TB of the disk (instead
of<br>
&gt; just 10GB) and increase size=3D to see whether that makes any differen=
ce<br>
&gt; (hopefully). Other than that, further ideas?<br>
<br>
Lets see what that yields.<br>
<br>
-- <br>
Jens Axboe<br>
<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe fio&quot;
in<br>
the body of a message to majordomo@vger.kernel.org<br>
More majordomo info at &nbsp;http://vger.kernel.org/majordomo-info.html<br>
</tt></font>
<br>=

--_000_OF07E686E545391A88ON882577D70075C3B1882577D700765E2Akpo_--


