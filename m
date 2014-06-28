Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53AE26F4.9050808@kernel.dk>
References: <CANvN+ekEc4AW+0WcC2YwmJdXA4WO_APSqPQkhq5oexOdrD+UXw@mail.gmail.com>
	<53AE26F4.9050808@kernel.dk>
Date: Fri, 27 Jun 2014 20:55:35 -0700
Message-ID: <CANvN+ensqZP3_jv=FNy4S_hhuyz8Mdnory7dwQFKHpmMw+4r8Q@mail.gmail.com>
Subject: Re: A typo in io_u.c::get_next_file()?
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Content-Type: multipart/alternative; boundary=047d7b6762cefee30c04fcdd655b
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--047d7b6762cefee30c04fcdd655b
Content-Type: text/plain; charset=UTF-8

Still unsure how it could have worked all the way down to now ;). given
the default profile being null (unless I'm missing it being set
differently).
On Jun 27, 2014 7:22 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

> On 2014-06-27 18:54, Andrey Kuzmin wrote:
>
>> diff --git a/io_u.c b/io_u.c
>> index e132fd9..f487b0a 100644
>> --- a/io_u.c
>> +++ b/io_u.c
>> @@ -1100,7 +1100,7 @@ out:
>>
>>   static struct fio_file *get_next_file(struct thread_data *td)
>>   {
>> -       if (!(td->flags & TD_F_PROFILE_OPS)) {
>> +       if ((td->flags & TD_F_PROFILE_OPS)) {
>>                  struct prof_io_ops *ops = &td->prof_io_ops;
>>
>>                  if (ops->get_next_file)
>>
>
> Hah indeed, good catch! I was wondering why it would not segfault, but I
> guess we fall through normally anyway. So it only impacts profiles that
> have get_next_file set, which makes it a minor issue.
>
> Thanks for the patch! Applied.
>
> --
> Jens Axboe
>
>

--047d7b6762cefee30c04fcdd655b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Still unsure how it could have worked all the way down to no=
w ;). given=C2=A0 the default profile being null (unless I&#39;m missing it=
 being set differently).</p>
<div class=3D"gmail_quote">On Jun 27, 2014 7:22 PM, &quot;Jens Axboe&quot; =
&lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br ty=
pe=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">
On 2014-06-27 18:54, Andrey Kuzmin wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
diff --git a/io_u.c b/io_u.c<br>
index e132fd9..f487b0a 100644<br>
--- a/io_u.c<br>
+++ b/io_u.c<br>
@@ -1100,7 +1100,7 @@ out:<br>
<br>
=C2=A0 static struct fio_file *get_next_file(struct thread_data *td)<br>
=C2=A0 {<br>
- =C2=A0 =C2=A0 =C2=A0 if (!(td-&gt;flags &amp; TD_F_PROFILE_OPS)) {<br>
+ =C2=A0 =C2=A0 =C2=A0 if ((td-&gt;flags &amp; TD_F_PROFILE_OPS)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct prof_i=
o_ops *ops =3D &amp;td-&gt;prof_io_ops;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ops-&gt;g=
et_next_file)<br>
</blockquote>
<br>
Hah indeed, good catch! I was wondering why it would not segfault, but I gu=
ess we fall through normally anyway. So it only impacts profiles that have =
get_next_file set, which makes it a minor issue.<br>
<br>
Thanks for the patch! Applied.<br>
<br>
-- <br>
Jens Axboe<br>
<br>
</blockquote></div>

--047d7b6762cefee30c04fcdd655b--

