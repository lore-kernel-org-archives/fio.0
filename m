Return-Path: <dev.madaari@gmail.com>
MIME-Version: 1.0
In-Reply-To: <246d6db1-ae2f-a4aa-9ca7-d305245b55dc@kernel.dk>
References: <1531732006-11136-1-git-send-email-dev.madaari@gmail.com>
 <1531732006-11136-2-git-send-email-dev.madaari@gmail.com> <246d6db1-ae2f-a4aa-9ca7-d305245b55dc@kernel.dk>
From: Udit agarwal <dev.madaari@gmail.com>
Date: Wed, 25 Jul 2018 00:02:16 +0530
Message-ID: <CAM0bxh82H10mFmsjBSfkbwMUv879z+ov04-6VUDenrPW64tRLg@mail.gmail.com>
Subject: Re: [PATCH] Fio's initial RTEMS port
Content-Type: multipart/alternative; boundary="00000000000051e6830571c2fb5e"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--00000000000051e6830571c2fb5e
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 24, 2018 at 9:17 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 7/16/18 3:06 AM, dev.madaari@gmail.com wrote:
> > diff --git a/cgroup.c b/cgroup.c
> > index 77e31a4..0a3d372 100644
> > --- a/cgroup.c
> > +++ b/cgroup.c
> > @@ -224,7 +224,12 @@ out:
> >       sfree(mnt);
> >  }
> >
> > -static void fio_init cgroup_init(void)
> > +#ifdef __rtems__
> > +void
> > +#else /* __rtems__ */
> > +static void fio_init
> > +#endif /* __rtems__ */
> > +cgroup_init(void)
>
> For all of these, just make the non-static for all platforms. I don't
> like having stuff like this all over the generic code. If need be,
> fio_init can be different for rtems.
>
> Noted.

> > diff --git a/crc/xxhash.h b/crc/xxhash.h
> > index 8850d20..81bf51d 100644
> > --- a/crc/xxhash.h
> > +++ b/crc/xxhash.h
> > @@ -107,9 +107,16 @@ XXH32() :
> >  // Advanced Hash Functions
> >  //****************************
> >
> > +/* Unlike most desktop OS, In Newlib unsigned int and uint32_t are
> different */
> > +#ifndef __rtems__
> >  void*         XXH32_init   (unsigned int seed);
> >  XXH_errorcode XXH32_update (void* state, const void* input, int len);
> >  unsigned int  XXH32_digest (void* state);
> > +#else /* __rtems__ */
> > +void*         XXH32_init   (uint32_t seed);
> > +XXH_errorcode XXH32_update (void* state, const void* input, int len);
> > +uint32_t  XXH32_digest (void* state);
> > +#endif /* __rtems__ */
>
> Same for this stuff, there's no need for this to be any different for
> rtems.
>
> > diff --git a/fio.c b/fio.c
> > index f19db1b..d4e0821 100644
> > --- a/fio.c
> > +++ b/fio.c
> > @@ -65,3 +65,6 @@ done:
> >       deinitialize_fio();
> >       return ret;
> >  }
> > +#ifdef __rtems__
> > +#include <os/rtems/rtems-fio-wrap.h>
> > +#endif /* __rtems__ */
>
> Put that in your OS header.
>
> Ok

> > diff --git a/fio.h b/fio.h
> > index 3ac552b..e382eb7 100644
> > --- a/fio.h
> > +++ b/fio.h
> > @@ -785,7 +785,11 @@ static inline void td_flags_clear(struct
> thread_data *td, unsigned int *flags,
> >       if (!td_async_processing(td))
> >               *flags &= ~value;
> >       else
> > +#ifndef __rtems__
> >               __sync_fetch_and_and(flags, ~value);
> > +#else /* __rtems__ */
> > +             atomic_fetch_and_explicit(flags, ~value,
> memory_order_relaxed);
> > +#endif /* __rtems__ */
>
> Handle this in your OS header as well.
>
> > diff --git a/fio_sem.c b/fio_sem.c
> > index 3b48061..b5bc9c2 100644
> > --- a/fio_sem.c
> > +++ b/fio_sem.c
> > @@ -56,9 +56,15 @@ struct fio_sem *fio_sem_init(int value)
> >  {
> >       struct fio_sem *sem = NULL;
> >
> > +#ifndef __rtems__
> >       sem = (void *) mmap(NULL, sizeof(struct fio_sem),
> >                               PROT_READ | PROT_WRITE,
> >                               OS_MAP_ANON | MAP_SHARED, -1, 0);
> > +#else /* __rtems__ */
> > +     sem = (void *) mmap(NULL, sizeof(struct fio_sem),
> > +                             PROT_READ | PROT_WRITE,
> > +                             OS_MAP_ANON | MAP_PRIVATE, -1, 0);
> > +#endif /* __rtems__ */
>
> Hmm?
>
> General comment - everytime you feel the need to add an ifdef __rtems__
> (or ifndef), you are going down the wrong path. Look at how the other OS
> types handle special cases and mimic that approach. Looks like your main
> difference is that you have to call initializers manually, which is a
> bit nasty. But differences in types etc should not be handled by having
> ifdefs in the generic code.
>
> Great! Thanks for your feedback. I was eagerly waiting for one. I'll make
the changes you told , probably by this weekend and will then resend the
patch.

> --
> Jens Axboe
>
>


-- 
Regards,
Udit kumar agarwal
http://uditagarwal.in/

--00000000000051e6830571c2fb5e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Tue, Jul 24, 2018 at 9:17 PM, Jens Axboe <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:axboe@kernel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</sp=
an> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 7/16/18 3:=
06 AM, <a href=3D"mailto:dev.madaari@gmail.com">dev.madaari@gmail.com</a> w=
rote:<br>
&gt; diff --git a/cgroup.c b/cgroup.c<br>
&gt; index 77e31a4..0a3d372 100644<br>
&gt; --- a/cgroup.c<br>
&gt; +++ b/cgroup.c<br>
&gt; @@ -224,7 +224,12 @@ out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0sfree(mnt);<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; -static void fio_init cgroup_init(void)<br>
&gt; +#ifdef __rtems__<br>
&gt; +void<br>
&gt; +#else /* __rtems__ */<br>
&gt; +static void fio_init<br>
&gt; +#endif /* __rtems__ */<br>
&gt; +cgroup_init(void)<br>
<br>
</span>For all of these, just make the non-static for all platforms. I don&=
#39;t<br>
like having stuff like this all over the generic code. If need be,<br>
fio_init can be different for rtems.<br>
<span class=3D""><br></span></blockquote><div>Noted. <br></div><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex"><span class=3D"">
&gt; diff --git a/crc/xxhash.h b/crc/xxhash.h<br>
&gt; index 8850d20..81bf51d 100644<br>
&gt; --- a/crc/xxhash.h<br>
&gt; +++ b/crc/xxhash.h<br>
&gt; @@ -107,9 +107,16 @@ XXH32() :<br>
&gt;=C2=A0 // Advanced Hash Functions<br>
&gt;=C2=A0 //****************************<br>
&gt;=C2=A0 <br>
&gt; +/* Unlike most desktop OS, In Newlib unsigned int and uint32_t are di=
fferent */<br>
&gt; +#ifndef __rtems__<br>
&gt;=C2=A0 void*=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0XXH32_init=C2=A0 =C2=A0(u=
nsigned int seed);<br>
&gt;=C2=A0 XXH_errorcode XXH32_update (void* state, const void* input, int =
len);<br>
&gt;=C2=A0 unsigned int=C2=A0 XXH32_digest (void* state);<br>
&gt; +#else /* __rtems__ */<br>
&gt; +void*=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0XXH32_init=C2=A0 =C2=A0(uint32=
_t seed);<br>
&gt; +XXH_errorcode XXH32_update (void* state, const void* input, int len);=
<br>
&gt; +uint32_t=C2=A0 XXH32_digest (void* state);<br>
&gt; +#endif /* __rtems__ */<br>
<br>
</span>Same for this stuff, there&#39;s no need for this to be any differen=
t for<br>
rtems.<br>
<span class=3D""><br>
&gt; diff --git a/fio.c b/fio.c<br>
&gt; index f19db1b..d4e0821 100644<br>
&gt; --- a/fio.c<br>
&gt; +++ b/fio.c<br>
&gt; @@ -65,3 +65,6 @@ done:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0deinitialize_fio();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt;=C2=A0 }<br>
&gt; +#ifdef __rtems__<br>
&gt; +#include &lt;os/rtems/rtems-fio-wrap.h&gt;<br>
&gt; +#endif /* __rtems__ */<br>
<br>
</span>Put that in your OS header.<br>
<span class=3D""><br></span></blockquote><div>Ok <br></div><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pad=
ding-left:1ex"><span class=3D"">
&gt; diff --git a/fio.h b/fio.h<br>
&gt; index 3ac552b..e382eb7 100644<br>
&gt; --- a/fio.h<br>
&gt; +++ b/fio.h<br>
&gt; @@ -785,7 +785,11 @@ static inline void td_flags_clear(struct thread_d=
ata *td, unsigned int *flags,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!td_async_processing(td))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*flags &amp;=3D =
~value;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
&gt; +#ifndef __rtems__<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__sync_fetch_and=
_and(flags, ~value);<br>
&gt; +#else /* __rtems__ */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_fetch_and_expl=
icit(<wbr>flags, ~value, memory_order_relaxed);<br>
&gt; +#endif /* __rtems__ */<br>
<br>
</span>Handle this in your OS header as well.<br>
<span class=3D""><br>
&gt; diff --git a/fio_sem.c b/fio_sem.c<br>
&gt; index 3b48061..b5bc9c2 100644<br>
&gt; --- a/fio_sem.c<br>
&gt; +++ b/fio_sem.c<br>
&gt; @@ -56,9 +56,15 @@ struct fio_sem *fio_sem_init(int value)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct fio_sem *sem =3D NULL;<br>
&gt;=C2=A0 <br>
&gt; +#ifndef __rtems__<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0sem =3D (void *) mmap(NULL, sizeof(struct fi=
o_sem),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROT_READ | PROT_WRITE,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0OS_MAP_ANON | MAP_SHARED, -1, 0);<=
br>
&gt; +#else /* __rtems__ */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sem =3D (void *) mmap(NULL, sizeof(struct fio_sem=
),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PROT_READ | PROT_WRITE,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0OS_MAP_ANON | MAP_PRIVATE, -1, 0);<br>
&gt; +#endif /* __rtems__ */<br>
<br>
</span>Hmm?<br>
<br>
General comment - everytime you feel the need to add an ifdef __rtems__<br>
(or ifndef), you are going down the wrong path. Look at how the other OS<br=
>
types handle special cases and mimic that approach. Looks like your main<br=
>
difference is that you have to call initializers manually, which is a<br>
bit nasty. But differences in types etc should not be handled by having<br>
ifdefs in the generic code.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br></font></span></blockquo=
te><div>Great! Thanks for your feedback. I was eagerly waiting for one. I&#=
39;ll make the changes you told , probably by this weekend and will then re=
send the patch.<br></div><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"HOEn=
Zb"><font color=3D"#888888">
-- <br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><=
div>Regards,<br></div>Udit kumar agarwal<br><a href=3D"http://uditagarwal.i=
n/" target=3D"_blank">http://uditagarwal.in/</a><br></div></div>
</div></div>

--00000000000051e6830571c2fb5e--

