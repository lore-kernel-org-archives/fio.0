Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <a0dc59e7-9c81-ab5d-45b6-d1d252179837@gmail.com>
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com> <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com> <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
 <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com> <CALjAwxhsvfH0-D=4U6nkjFg109Z1ZgVRsOx37X+Lb-EqTf_jOA@mail.gmail.com>
 <6b2cacaf-2946-6046-51c2-b909c6ee0784@gmail.com> <CANvN+emLjb9idri9r42V3W9ia6v0EDGdJYFfhzq6rAuzGWec8Q@mail.gmail.com>
 <CANvN+emJBzMeUmjBw5PBSZc66LmjG8-Pz+39dBeL5GseMCdo6g@mail.gmail.com>
 <fca1cdb1-aa66-b21f-d1a0-029ba895d3f2@gmail.com> <CANvN+emQ0AYPgT0e6KMKphDTZAY=cW6FyroLw=smReHGpd-=TA@mail.gmail.com>
 <a0dc59e7-9c81-ab5d-45b6-d1d252179837@gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Tue, 24 Jan 2017 12:40:35 +0300
Message-ID: <CANvN+e=qsexdU6Pp4kKQXy-jQKixZhR-WWLQb=713NNAA0ziVg@mail.gmail.com>
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
Content-Type: multipart/alternative; boundary=001a113fc3028982b70546d3e850
To: Tobias Oberstein <tobias.oberstein@gmail.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--001a113fc3028982b70546d3e850
Content-Type: text/plain; charset=UTF-8

On Jan 24, 2017 12:28, "Tobias Oberstein" <tobias.oberstein@gmail.com>
wrote:

My current preliminary conclusions on this box / workload:
>
> - running psync is much better than sync
>
> So you likely have a convincing case for Postgres guys to switch over to
> pread/pwrite.
>

I will approach them, but I want to make sure I did all my homework first.

One question that bugs me:

the difference in performance between sync and psync engines only surface
with MD, _not_ when running over individual devices.



My guess is, with individual devices there's no cpu headroom for press
savings to show up. Once MD bottleneck gets in, you're not bound by cpu
anymore and the difference between doing a single syscall vs. two shows up.


---

I ran Linux perf with these results:

https://github.com/oberstet/scratchbox/blob/master/cruncher/
sync-engines-perf/individual-nvmes-sync.md

https://github.com/oberstet/scratchbox/blob/master/cruncher/
sync-engines-perf/individual-nvmes-psync.md

https://github.com/oberstet/scratchbox/blob/master/cruncher/
sync-engines-perf/md-nvmes-sync.md

https://github.com/oberstet/scratchbox/blob/master/cruncher/
sync-engines-perf/md-nvmes-psync.md

---

md-nvmes-sync shows the "issue":

Overhead  Command  Shared Object       Symbol
  73.48%  fio      [kernel.kallsyms]   [k] osq_lock


So while I think it would be good in general if PostgreSQL used
pread/pwrite instead of lseek/read/write when available, I am afraid there
might be a bottleneck in MD.

What do you think?

And if so, where should I raise this rgd MD? I have no clue where the
hackers of MD hang out ..


Yup, I believe it makes sense to post to the md mail list.

Regards,
Andrey


Cheers,
/Tobias

--001a113fc3028982b70546d3e850
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">On Jan 24, 2017 12:28, &quot;Tobias Oberstein&quot; &lt;<a href=
=3D"mailto:tobias.oberstein@gmail.com">tobias.oberstein@gmail.com</a>&gt; w=
rote:<br type=3D"attribution"><blockquote class=3D"quote" style=3D"margin:0=
 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"quoted=
-text"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-=
left:1px #ccc solid;padding-left:1ex">
My current preliminary conclusions on this box / workload:<br>
<br>
- running psync is much better than sync<br>
<br>
So you likely have a convincing case for Postgres guys to switch over to<br=
>
pread/pwrite.<br>
</blockquote>
<br></div>
I will approach them, but I want to make sure I did all my homework first.<=
br>
<br>
One question that bugs me:<br>
<br>
the difference in performance between sync and psync engines only surface w=
ith MD, _not_ when running over individual devices.<br></blockquote></div><=
/div></div><div dir=3D"auto"><br></div><div dir=3D"auto"><br></div><div dir=
=3D"auto">My guess is, with individual devices there&#39;s no cpu headroom =
for press savings to show up. Once MD bottleneck gets in, you&#39;re not bo=
und by cpu anymore and the difference between doing a single syscall vs. tw=
o shows up.</div><div dir=3D"auto"><br></div><div dir=3D"auto"><div class=
=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"quote" sty=
le=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
---<br>
<br>
I ran Linux perf with these results:<br>
<br>
<a href=3D"https://github.com/oberstet/scratchbox/blob/master/cruncher/sync=
-engines-perf/individual-nvmes-sync.md" rel=3D"noreferrer" target=3D"_blank=
">https://github.com/oberstet/sc<wbr>ratchbox/blob/master/cruncher/<wbr>syn=
c-engines-perf/individual-<wbr>nvmes-sync.md</a><br>
<br>
<a href=3D"https://github.com/oberstet/scratchbox/blob/master/cruncher/sync=
-engines-perf/individual-nvmes-psync.md" rel=3D"noreferrer" target=3D"_blan=
k">https://github.com/oberstet/sc<wbr>ratchbox/blob/master/cruncher/<wbr>sy=
nc-engines-perf/individual-<wbr>nvmes-psync.md</a><br>
<br>
<a href=3D"https://github.com/oberstet/scratchbox/blob/master/cruncher/sync=
-engines-perf/md-nvmes-sync.md" rel=3D"noreferrer" target=3D"_blank">https:=
//github.com/oberstet/sc<wbr>ratchbox/blob/master/cruncher/<wbr>sync-engine=
s-perf/md-nvmes-<wbr>sync.md</a><br>
<br>
<a href=3D"https://github.com/oberstet/scratchbox/blob/master/cruncher/sync=
-engines-perf/md-nvmes-psync.md" rel=3D"noreferrer" target=3D"_blank">https=
://github.com/oberstet/sc<wbr>ratchbox/blob/master/cruncher/<wbr>sync-engin=
es-perf/md-nvmes-<wbr>psync.md</a><br>
<br>
---<br>
<br>
md-nvmes-sync shows the &quot;issue&quot;:<br>
<br>
Overhead=C2=A0 Command=C2=A0 Shared Object=C2=A0 =C2=A0 =C2=A0 =C2=A0Symbol=
<br>
=C2=A0 73.48%=C2=A0 fio=C2=A0 =C2=A0 =C2=A0 [kernel.kallsyms]=C2=A0 =C2=A0[=
k] osq_lock<br>
<br>
<br>
So while I think it would be good in general if PostgreSQL used pread/pwrit=
e instead of lseek/read/write when available, I am afraid there might be a =
bottleneck in MD.<br>
<br>
What do you think?<br>
<br>
And if so, where should I raise this rgd MD? I have no clue where the hacke=
rs of MD hang out ..<br></blockquote></div></div></div><div dir=3D"auto"><b=
r></div><div dir=3D"auto">Yup, I believe it makes sense to post to the md m=
ail list.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Regards,</div>=
<div dir=3D"auto">Andrey</div><div dir=3D"auto"><div class=3D"gmail_extra">=
<div class=3D"gmail_quote"><blockquote class=3D"quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Cheers,<br>
/Tobias<br>
</blockquote></div><br></div></div></div>

--001a113fc3028982b70546d3e850--

