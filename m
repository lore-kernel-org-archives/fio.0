Return-Path: <learner.study@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20090902063114.GK12579@kernel.dk>
References: <7efa8a7d0908311900o2f0bfbb8t52a8b518782e2bdc@mail.gmail.com> 
	<20090901053838.GK12579@kernel.dk> <7efa8a7d0909011643r5c86384uedb6c8ef0e1c33ab@mail.gmail.com> 
	<20090902063114.GK12579@kernel.dk>
From: Learner Study <learner.study@gmail.com>
Date: Wed, 2 Sep 2009 01:24:59 -0700
Message-ID: <7efa8a7d0909020124j4be78b7au33774be150f09c7c@mail.gmail.com>
Subject: Re: FIO for MIPS
Content-Type: multipart/alternative; boundary=00504502e141e301c40472940197
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--00504502e141e301c40472940197
Content-Type: text/plain; charset=ISO-8859-1

Hi Jens:

Do you mean using CLONE_IO with posixaio would be better than O_DIRECT with
posixaio?

Thanks!

On Tue, Sep 1, 2009 at 11:31 PM, Jens Axboe <jens.axboe@oracle.com> wrote:

> Hi,
>
> Yes, if you can live with O_DIRECT, libaio performs a lot better than
> posixaio. Nobody should use posixaio in their apps if they care just a
> bit about performance, it just doesn't work very well. Using CLONE_IO
> would help, but even with that it's still pretty suboptimal.
>
>
> On Tue, Sep 01 2009, Learner Study wrote:
> > Hi Jens:
> >
> > Thanks - it works well.
> >
> > I'm using FIO with posixaio ioengine and performance is pretty bad. I'm
> > trying to get libaio to work  in my MIPS environment. Based on my tests
> in
> > previous x86 env, I had seen libaio to give better performance with FIO
> as
> > compared to posixaio.
> >
> > Again, thanks for your prompt help.
> >
> > On Mon, Aug 31, 2009 at 10:38 PM, Jens Axboe <jens.axboe@oracle.com>
> wrote:
> >
> > > On Mon, Aug 31 2009, Learner Study wrote:
> > > > Hello:
> > > >
> > > > I checked README for FIO and apparently it isn't yet supported on
> MIPS64
> > > > platform yet (atleast until version 1.30)
> > > > Does someone have a patch I could use to do this? Any other ideas...
> > >
> > > I just checked in the below patch. I haven't checked the memory
> ordering
> > > defines yet, not sure if any of the mips cpus are weaker ordered. I'll
> > > check that later, this should at least get you started.
> > >
> > > commit c28b912f77c3dafbdcdcf4def2c8c1f9c127100c
> > > Author: Jens Axboe <jens.axboe@oracle.com>
> > > Date:   Tue Sep 1 07:23:57 2009 +0200
> > >
> > >    MIPS support
> > >
> > >    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > >
> > > diff --git a/arch/arch-mips.h b/arch/arch-mips.h
> > > new file mode 100644
> > > index 0000000..759d3a9
> > > --- /dev/null
> > > +++ b/arch/arch-mips.h
> > > @@ -0,0 +1,25 @@
> > > +#ifndef ARCH_MIPS64_H
> > > +#define ARCH_MIPS64_H
> > > +
> > > +#define ARCH   (arch_mips)
> > > +
> > > +#ifndef __NR_ioprio_set
> > > +#define __NR_ioprio_set                314
> > > +#define __NR_ioprio_get                315
> > > +#endif
> > > +
> > > +#ifndef __NR_fadvise64
> > > +#define __NR_fadvise64         215
> > > +#endif
> > > +
> > > +#ifndef __NR_sys_splice
> > > +#define __NR_sys_splice                263
> > > +#define __NR_sys_tee           265
> > > +#define __NR_sys_vmsplice      266
> > > +#endif
> > > +
> > > +#define read_barrier()         __asm__ __volatile__("": : :"memory")
> > > +#define write_barrier()                __asm__ __volatile__("": :
> > > :"memory")
> > > +#define nop                    __asm__ __volatile__("": : :"memory")
> > > +
> > > +#endif
> > > diff --git a/arch/arch.h b/arch/arch.h
> > > index 28c6632..87db222 100644
> > > --- a/arch/arch.h
> > > +++ b/arch/arch.h
> > > @@ -31,6 +31,8 @@ enum {
> > >  #include "arch-sparc64.h"
> > >  #elif defined(__arm__)
> > >  #include "arch-arm.h"
> > > +#elif defined(__mips__) || defined(__mips64__)
> > > +#include "arch-mips.h"
> > >  #else
> > >  #error "Unsupported arch"
> > >  #endif
> > >
> > > --
> > > Jens Axboe
> > >
> > >
>
> --
> Jens Axboe
>
>

--00504502e141e301c40472940197
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jens:<br><br>Do you mean using CLONE_IO with posixaio would be better th=
an O_DIRECT with posixaio?<br><br>Thanks!<br><br><div class=3D"gmail_quote"=
>On Tue, Sep 1, 2009 at 11:31 PM, Jens Axboe <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jens.axboe@oracle.com">jens.axboe@oracle.com</a>&gt;</span> wrot=
e:<br>

<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi,<br>
<br>
Yes, if you can live with O_DIRECT, libaio performs a lot better than<br>
posixaio. Nobody should use posixaio in their apps if they care just a<br>
bit about performance, it just doesn&#39;t work very well. Using CLONE_IO<b=
r>
would help, but even with that it&#39;s still pretty suboptimal.<br>
<div><div></div><div class=3D"h5"><br>
<br>
On Tue, Sep 01 2009, Learner Study wrote:<br>
&gt; Hi Jens:<br>
&gt;<br>
&gt; Thanks - it works well.<br>
&gt;<br>
&gt; I&#39;m using FIO with posixaio ioengine and performance is pretty bad=
. I&#39;m<br>
&gt; trying to get libaio to work =A0in my MIPS environment. Based on my te=
sts in<br>
&gt; previous x86 env, I had seen libaio to give better performance with FI=
O as<br>
&gt; compared to posixaio.<br>
&gt;<br>
&gt; Again, thanks for your prompt help.<br>
&gt;<br>
&gt; On Mon, Aug 31, 2009 at 10:38 PM, Jens Axboe &lt;<a href=3D"mailto:jen=
s.axboe@oracle.com">jens.axboe@oracle.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Mon, Aug 31 2009, Learner Study wrote:<br>
&gt; &gt; &gt; Hello:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I checked README for FIO and apparently it isn&#39;t yet sup=
ported on MIPS64<br>
&gt; &gt; &gt; platform yet (atleast until version 1.30)<br>
&gt; &gt; &gt; Does someone have a patch I could use to do this? Any other =
ideas...<br>
&gt; &gt;<br>
&gt; &gt; I just checked in the below patch. I haven&#39;t checked the memo=
ry ordering<br>
&gt; &gt; defines yet, not sure if any of the mips cpus are weaker ordered.=
 I&#39;ll<br>
&gt; &gt; check that later, this should at least get you started.<br>
&gt; &gt;<br>
&gt; &gt; commit c28b912f77c3dafbdcdcf4def2c8c1f9c127100c<br>
&gt; &gt; Author: Jens Axboe &lt;<a href=3D"mailto:jens.axboe@oracle.com">j=
ens.axboe@oracle.com</a>&gt;<br>
&gt; &gt; Date: =A0 Tue Sep 1 07:23:57 2009 +0200<br>
&gt; &gt;<br>
&gt; &gt; =A0 =A0MIPS support<br>
&gt; &gt;<br>
&gt; &gt; =A0 =A0Signed-off-by: Jens Axboe &lt;<a href=3D"mailto:jens.axboe=
@oracle.com">jens.axboe@oracle.com</a>&gt;<br>
&gt; &gt;<br>
&gt; &gt; diff --git a/arch/arch-mips.h b/arch/arch-mips.h<br>
&gt; &gt; new file mode 100644<br>
&gt; &gt; index 0000000..759d3a9<br>
&gt; &gt; --- /dev/null<br>
&gt; &gt; +++ b/arch/arch-mips.h<br>
&gt; &gt; @@ -0,0 +1,25 @@<br>
&gt; &gt; +#ifndef ARCH_MIPS64_H<br>
&gt; &gt; +#define ARCH_MIPS64_H<br>
&gt; &gt; +<br>
&gt; &gt; +#define ARCH =A0 (arch_mips)<br>
&gt; &gt; +<br>
&gt; &gt; +#ifndef __NR_ioprio_set<br>
&gt; &gt; +#define __NR_ioprio_set =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0314<br>
&gt; &gt; +#define __NR_ioprio_get =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0315<br>
&gt; &gt; +#endif<br>
&gt; &gt; +<br>
&gt; &gt; +#ifndef __NR_fadvise64<br>
&gt; &gt; +#define __NR_fadvise64 =A0 =A0 =A0 =A0 215<br>
&gt; &gt; +#endif<br>
&gt; &gt; +<br>
&gt; &gt; +#ifndef __NR_sys_splice<br>
&gt; &gt; +#define __NR_sys_splice =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0263<br>
&gt; &gt; +#define __NR_sys_tee =A0 =A0 =A0 =A0 =A0 265<br>
&gt; &gt; +#define __NR_sys_vmsplice =A0 =A0 =A0266<br>
&gt; &gt; +#endif<br>
&gt; &gt; +<br>
&gt; &gt; +#define read_barrier() =A0 =A0 =A0 =A0 __asm__ __volatile__(&quo=
t;&quot;: : :&quot;memory&quot;)<br>
&gt; &gt; +#define write_barrier() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__asm__ _=
_volatile__(&quot;&quot;: :<br>
&gt; &gt; :&quot;memory&quot;)<br>
&gt; &gt; +#define nop =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__asm__ __vol=
atile__(&quot;&quot;: : :&quot;memory&quot;)<br>
&gt; &gt; +<br>
&gt; &gt; +#endif<br>
&gt; &gt; diff --git a/arch/arch.h b/arch/arch.h<br>
&gt; &gt; index 28c6632..87db222 100644<br>
&gt; &gt; --- a/arch/arch.h<br>
&gt; &gt; +++ b/arch/arch.h<br>
&gt; &gt; @@ -31,6 +31,8 @@ enum {<br>
&gt; &gt; =A0#include &quot;arch-sparc64.h&quot;<br>
&gt; &gt; =A0#elif defined(__arm__)<br>
&gt; &gt; =A0#include &quot;arch-arm.h&quot;<br>
&gt; &gt; +#elif defined(__mips__) || defined(__mips64__)<br>
&gt; &gt; +#include &quot;arch-mips.h&quot;<br>
&gt; &gt; =A0#else<br>
&gt; &gt; =A0#error &quot;Unsupported arch&quot;<br>
&gt; &gt; =A0#endif<br>
&gt; &gt;<br>
&gt; &gt; --<br>
&gt; &gt; Jens Axboe<br>
&gt; &gt;<br>
&gt; &gt;<br>
<br>
</div></div>--<br>
<font color=3D"#888888">Jens Axboe<br>
<br>
</font></blockquote></div><br>

--00504502e141e301c40472940197--


