Return-Path: <paolo.valente@linaro.org>
MIME-Version: 1.0
In-Reply-To: <d4c25e14-564d-a77a-274e-5a9cb3717386@kernel.dk>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org>
 <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com>
 <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org> <CALjAwxg02AqDB78Nai_jbZ_EU3S5Wf20jQ1WKuTzb-4SG9Qd0g@mail.gmail.com>
 <FC918187-B671-44DF-B412-077FC7B683D7@linaro.org> <d4c25e14-564d-a77a-274e-5a9cb3717386@kernel.dk>
From: Paolo Valente <paolo.valente@linaro.org>
Date: Fri, 27 Oct 2017 08:22:22 +0200
Message-ID: <CAD7QDb2mYJzVUbscNq72MLYzD_cPish+=5S_fu9awxm7Sz+hzw@mail.gmail.com>
Subject: Re: buffer-cache builds up with invalidate=1 too
Content-Type: multipart/alternative; boundary="001a114b8010cd3427055c814f26"
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--001a114b8010cd3427055c814f26
Content-Type: text/plain; charset="UTF-8"

Il 26/ott/2017 06:32 AM, "Jens Axboe" <axboe@kernel.dk> ha scritto:

On 10/24/2017 08:10 AM, Paolo Valente wrote:
>
>> Il giorno 24 ott 2017, alle ore 08:28, Sitsofe Wheeler <sitsofe@gmail.com>
ha scritto:
>>
>> Hi,
>>
>> If memory serves it's actually slightly more complicated. If you are
>> using loops=<number> then I *think* (you'll have to check) you will
>> find that invalidation happens once per each loop start. However when
>> you use time_based to do the repetition there is essentially only one
>> "loop" (even though the job goes on forever) so loop actions only
>> happen right at the start of the job with that option (that's why I
>> put the scare quotes around "beginning" ;-).
>>
>
> Thanks for this additional, useful piece of information.  Actually,
> this further, possibly different caching behavior makes me think that
> some extra comment in the manpage might be helpful.

Would probably make sense to change 'invalidate' to be a range of
possible values:

0       As it is now, never invalidate
1       As it is now, invalidate initially
once    Same as '1', invalidate initially / once
open    New value, invalidate on every open
close   New value, invalidate on close

as I can definitely see reasons why you would want to invalidate every
time you open the file.

To do that, the 'invalidate' option should be changed from a
FIO_OPT_BOOL to a FIO_OPT_STR, and the above possible values should be
added as posval[] for that option.

Compliment that with the an enum of ranges for the ovals:

enum {
        FIO_FILE_INVALIDATE_OFF = 0,
        FIO_FILE_INVALIDATE_ONCE,
        FIO_FILE_INVALIDATE_OPEN,
        FIO_FILE_INVALIDATE_CLOSE
};

Hope this makes sense, should be trivial to add as most of the work is
already documented in this email :-). The remaining bits is just calling
file_invalidate_cache() in the proper locations,
td_io_{open,close}_file() would be prime candidates.


IMO this solution would make things both clearer and more flexible

Thanks,
Paolo


--
Jens Axboe

--001a114b8010cd3427055c814f26
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">Il 26/ott/2017 06:32 AM, &quot;Jens Axboe&quot; &lt;<a href=3D"ma=
ilto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; ha scritto:<br type=3D"attrib=
ution"><blockquote class=3D"quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><div class=3D"quoted-text">On 10/24/2017 08=
:10 AM, Paolo Valente wrote:<br>
&gt;<br>
&gt;&gt; Il giorno 24 ott 2017, alle ore 08:28, Sitsofe Wheeler &lt;<a href=
=3D"mailto:sitsofe@gmail.com">sitsofe@gmail.com</a>&gt; ha scritto:<br>
&gt;&gt;<br>
&gt;&gt; Hi,<br>
&gt;&gt;<br>
&gt;&gt; If memory serves it&#39;s actually slightly more complicated. If y=
ou are<br>
&gt;&gt; using loops=3D&lt;number&gt; then I *think* (you&#39;ll have to ch=
eck) you will<br>
&gt;&gt; find that invalidation happens once per each loop start. However w=
hen<br>
&gt;&gt; you use time_based to do the repetition there is essentially only =
one<br>
&gt;&gt; &quot;loop&quot; (even though the job goes on forever) so loop act=
ions only<br>
&gt;&gt; happen right at the start of the job with that option (that&#39;s =
why I<br>
&gt;&gt; put the scare quotes around &quot;beginning&quot; ;-).<br>
&gt;&gt;<br>
&gt;<br>
&gt; Thanks for this additional, useful piece of information.=C2=A0 Actuall=
y,<br>
&gt; this further, possibly different caching behavior makes me think that<=
br>
&gt; some extra comment in the manpage might be helpful.<br>
<br>
</div>Would probably make sense to change &#39;invalidate&#39; to be a rang=
e of<br>
possible values:<br>
<br>
0=C2=A0 =C2=A0 =C2=A0 =C2=A0As it is now, never invalidate<br>
1=C2=A0 =C2=A0 =C2=A0 =C2=A0As it is now, invalidate initially<br>
once=C2=A0 =C2=A0 Same as &#39;1&#39;, invalidate initially / once<br>
open=C2=A0 =C2=A0 New value, invalidate on every open<br>
close=C2=A0 =C2=A0New value, invalidate on close<br><br>
as I can definitely see reasons why you would want to invalidate every<br>
time you open the file.<br>
<br>
To do that, the &#39;invalidate&#39; option should be changed from a<br>
FIO_OPT_BOOL to a FIO_OPT_STR, and the above possible values should be<br>
added as posval[] for that option.<br>
<br>
Compliment that with the an enum of ranges for the ovals:<br>
<br>
enum {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FIO_FILE_INVALIDATE_OFF =3D 0,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FIO_FILE_INVALIDATE_ONCE,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FIO_FILE_INVALIDATE_OPEN,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FIO_FILE_INVALIDATE_CLOSE<br>
};<br>
<br>
Hope this makes sense, should be trivial to add as most of the work is<br>
already documented in this email :-). The remaining bits is just calling<br=
>
file_invalidate_cache() in the proper locations,<br>
td_io_{open,close}_file() would be prime candidates.<br>
<font color=3D"#888888"></font></blockquote></div></div></div><div dir=3D"a=
uto"><br></div><div dir=3D"auto">IMO this solution would make things both c=
learer and more flexible</div><div dir=3D"auto"><br></div><div dir=3D"auto"=
>Thanks,</div><div dir=3D"auto">Paolo</div><div dir=3D"auto"><div class=3D"=
gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><font co=
lor=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></blockquote></div><br></div></div></div>

--001a114b8010cd3427055c814f26--

