Return-Path: <learner.study@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20090901053838.GK12579@kernel.dk>
References: <7efa8a7d0908311900o2f0bfbb8t52a8b518782e2bdc@mail.gmail.com>
	 <20090901053838.GK12579@kernel.dk>
Date: Tue, 1 Sep 2009 16:43:59 -0700
Message-ID: <7efa8a7d0909011643r5c86384uedb6c8ef0e1c33ab@mail.gmail.com>
Subject: Re: FIO for MIPS
From: Learner Study <learner.study@gmail.com>
Content-Type: multipart/alternative; boundary=0016e64b92dc7cfc0504728cb969
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org, vmurgai@yahoo.com
List-ID: <fio@vger.kernel.org>

--0016e64b92dc7cfc0504728cb969
Content-Type: text/plain; charset=ISO-8859-1

Hi Jens:

Thanks - it works well.

I'm using FIO with posixaio ioengine and performance is pretty bad. I'm
trying to get libaio to work  in my MIPS environment. Based on my tests in
previous x86 env, I had seen libaio to give better performance with FIO as
compared to posixaio.

Again, thanks for your prompt help.

On Mon, Aug 31, 2009 at 10:38 PM, Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Aug 31 2009, Learner Study wrote:
> > Hello:
> >
> > I checked README for FIO and apparently it isn't yet supported on MIPS64
> > platform yet (atleast until version 1.30)
> > Does someone have a patch I could use to do this? Any other ideas...
>
> I just checked in the below patch. I haven't checked the memory ordering
> defines yet, not sure if any of the mips cpus are weaker ordered. I'll
> check that later, this should at least get you started.
>
> commit c28b912f77c3dafbdcdcf4def2c8c1f9c127100c
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Tue Sep 1 07:23:57 2009 +0200
>
>    MIPS support
>
>    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>
> diff --git a/arch/arch-mips.h b/arch/arch-mips.h
> new file mode 100644
> index 0000000..759d3a9
> --- /dev/null
> +++ b/arch/arch-mips.h
> @@ -0,0 +1,25 @@
> +#ifndef ARCH_MIPS64_H
> +#define ARCH_MIPS64_H
> +
> +#define ARCH   (arch_mips)
> +
> +#ifndef __NR_ioprio_set
> +#define __NR_ioprio_set                314
> +#define __NR_ioprio_get                315
> +#endif
> +
> +#ifndef __NR_fadvise64
> +#define __NR_fadvise64         215
> +#endif
> +
> +#ifndef __NR_sys_splice
> +#define __NR_sys_splice                263
> +#define __NR_sys_tee           265
> +#define __NR_sys_vmsplice      266
> +#endif
> +
> +#define read_barrier()         __asm__ __volatile__("": : :"memory")
> +#define write_barrier()                __asm__ __volatile__("": :
> :"memory")
> +#define nop                    __asm__ __volatile__("": : :"memory")
> +
> +#endif
> diff --git a/arch/arch.h b/arch/arch.h
> index 28c6632..87db222 100644
> --- a/arch/arch.h
> +++ b/arch/arch.h
> @@ -31,6 +31,8 @@ enum {
>  #include "arch-sparc64.h"
>  #elif defined(__arm__)
>  #include "arch-arm.h"
> +#elif defined(__mips__) || defined(__mips64__)
> +#include "arch-mips.h"
>  #else
>  #error "Unsupported arch"
>  #endif
>
> --
> Jens Axboe
>
>

--0016e64b92dc7cfc0504728cb969
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jens:<br><br>Thanks - it works well. <br><br>I&#39;m using FIO with posi=
xaio ioengine and performance is pretty bad. I&#39;m trying to get libaio t=
o work=A0 in my MIPS environment. Based on my tests in previous x86 env, I =
had seen libaio to give better performance with FIO as compared to posixaio=
.<br>
<br>Again, thanks for your prompt help.<br><br><div class=3D"gmail_quote">O=
n Mon, Aug 31, 2009 at 10:38 PM, Jens Axboe <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jens.axboe@oracle.com">jens.axboe@oracle.com</a>&gt;</span> wrot=
e:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"im"=
>On Mon, Aug 31 2009, Learner Study wrote:<br>
</div><div><div></div><div class=3D"h5">&gt; Hello:<br>
&gt;<br>
&gt; I checked README for FIO and apparently it isn&#39;t yet supported on =
MIPS64<br>
&gt; platform yet (atleast until version 1.30)<br>
&gt; Does someone have a patch I could use to do this? Any other ideas...<b=
r>
<br>
</div></div><div><div></div><div class=3D"h5">I just checked in the below p=
atch. I haven&#39;t checked the memory ordering<br>
defines yet, not sure if any of the mips cpus are weaker ordered. I&#39;ll<=
br>
check that later, this should at least get you started.<br>
<br>
commit c28b912f77c3dafbdcdcf4def2c8c1f9c127100c<br>
Author: Jens Axboe &lt;<a href=3D"mailto:jens.axboe@oracle.com">jens.axboe@=
oracle.com</a>&gt;<br>
Date: =A0 Tue Sep 1 07:23:57 2009 +0200<br>
<br>
 =A0 =A0MIPS support<br>
<br>
 =A0 =A0Signed-off-by: Jens Axboe &lt;<a href=3D"mailto:jens.axboe@oracle.c=
om">jens.axboe@oracle.com</a>&gt;<br>
<br>
diff --git a/arch/arch-mips.h b/arch/arch-mips.h<br>
new file mode 100644<br>
index 0000000..759d3a9<br>
--- /dev/null<br>
+++ b/arch/arch-mips.h<br>
@@ -0,0 +1,25 @@<br>
+#ifndef ARCH_MIPS64_H<br>
+#define ARCH_MIPS64_H<br>
+<br>
+#define ARCH =A0 (arch_mips)<br>
+<br>
+#ifndef __NR_ioprio_set<br>
+#define __NR_ioprio_set =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0314<br>
+#define __NR_ioprio_get =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0315<br>
+#endif<br>
+<br>
+#ifndef __NR_fadvise64<br>
+#define __NR_fadvise64 =A0 =A0 =A0 =A0 215<br>
+#endif<br>
+<br>
+#ifndef __NR_sys_splice<br>
+#define __NR_sys_splice =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0263<br>
+#define __NR_sys_tee =A0 =A0 =A0 =A0 =A0 265<br>
+#define __NR_sys_vmsplice =A0 =A0 =A0266<br>
+#endif<br>
+<br>
+#define read_barrier() =A0 =A0 =A0 =A0 __asm__ __volatile__(&quot;&quot;: =
: :&quot;memory&quot;)<br>
+#define write_barrier() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__asm__ __volatile_=
_(&quot;&quot;: : :&quot;memory&quot;)<br>
+#define nop =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__asm__ __volatile__(&q=
uot;&quot;: : :&quot;memory&quot;)<br>
+<br>
+#endif<br>
diff --git a/arch/arch.h b/arch/arch.h<br>
index 28c6632..87db222 100644<br>
--- a/arch/arch.h<br>
+++ b/arch/arch.h<br>
@@ -31,6 +31,8 @@ enum {<br>
=A0#include &quot;arch-sparc64.h&quot;<br>
=A0#elif defined(__arm__)<br>
=A0#include &quot;arch-arm.h&quot;<br>
+#elif defined(__mips__) || defined(__mips64__)<br>
+#include &quot;arch-mips.h&quot;<br>
=A0#else<br>
=A0#error &quot;Unsupported arch&quot;<br>
=A0#endif<br>
<br>
--<br>
Jens Axboe<br>
<br>
</div></div></blockquote></div><br>

--0016e64b92dc7cfc0504728cb969--


