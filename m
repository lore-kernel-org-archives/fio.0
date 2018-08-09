Return-Path: <dev.madaari@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1533105246-15148-1-git-send-email-dev.madaari@gmail.com>
References: <1533105246-15148-1-git-send-email-dev.madaari@gmail.com>
From: Udit agarwal <dev.madaari@gmail.com>
Date: Thu, 9 Aug 2018 11:50:16 +0530
Message-ID: <CAM0bxh9WprimFUgqQk-78V1mWqLwzd14GxchqpKUr=ty4N1sBQ@mail.gmail.com>
Subject: Re: [PATCH] Fix function definition and declaration mismatch
Content-Type: multipart/alternative; boundary="00000000000022072d0572faa0cf"
To: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Udit kumar agarwal <dev.madaari@gmail.com>
List-ID: <fio@vger.kernel.org>

--00000000000022072d0572faa0cf
Content-Type: text/plain; charset="UTF-8"

Hi,
Just a ping ;) Does this patch sounds reasonable?
On Wed, Aug 1, 2018 at 12:04 PM, <dev.madaari@gmail.com> wrote:

> From: Udit kumar agarwal <dev.madaari@gmail.com>
>
> during the declaration of, let's say XXH32_init parameter type is
> 'unsigned int' while during the definition it is 'uint32_t'. Now, on
> most desktop os, they are are usually same, however on some embedded
> platforms, for example RTEMS which uses newlib as it's standard c library,
> they both are different.
> ---
>  crc/xxhash.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/crc/xxhash.h b/crc/xxhash.h
> index 8850d20..9019089 100644
> --- a/crc/xxhash.h
> +++ b/crc/xxhash.h
> @@ -107,9 +107,9 @@ XXH32() :
>  // Advanced Hash Functions
>  //****************************
>
> -void*         XXH32_init   (unsigned int seed);
> +void*         XXH32_init   (uint32_t seed);
>  XXH_errorcode XXH32_update (void* state, const void* input, int len);
> -unsigned int  XXH32_digest (void* state);
> +uint32_t  XXH32_digest (void* state);
>
>  /*
>  These functions calculate the xxhash of an input provided in several
> small packets,
> @@ -135,7 +135,7 @@ Memory will be freed by XXH32_digest().
>
>
>  int           XXH32_sizeofState(void);
> -XXH_errorcode XXH32_resetState(void* state, unsigned int seed);
> +XXH_errorcode XXH32_resetState(void* state, uint32_t seed);
>
>  #define       XXH32_SIZEOFSTATE 48
>  typedef struct { long long ll[(XXH32_SIZEOFSTATE+(sizeof(long
> long)-1))/sizeof(long long)]; } XXH32_stateSpace_t;
> @@ -151,7 +151,7 @@ use the structure XXH32_stateSpace_t, which will
> ensure that memory space is lar
>  */
>
>
> -unsigned int XXH32_intermediateDigest (void* state);
> +uint32_t XXH32_intermediateDigest (void* state);
>  /*
>  This function does the same as XXH32_digest(), generating a 32-bit hash,
>  but preserve memory context.
> --
> 1.9.1
>
>


-- 
Regards,
Udit kumar agarwal
http://uditagarwal.in/

--00000000000022072d0572faa0cf
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><div class=3D"gmail_extra">Just a ping ;) Does this=
 patch sounds reasonable?<br></div><div class=3D"gmail_extra"><div class=3D=
"gmail_quote">On Wed, Aug 1, 2018 at 12:04 PM,  <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:dev.madaari@gmail.com" target=3D"_blank">dev.madaari@gmail.com=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">From: Udit kumar a=
garwal &lt;<a href=3D"mailto:dev.madaari@gmail.com">dev.madaari@gmail.com</=
a>&gt;<br>
<br>
during the declaration of, let&#39;s say XXH32_init parameter type is<br>
&#39;unsigned int&#39; while during the definition it is &#39;uint32_t&#39;=
. Now, on<br>
most desktop os, they are are usually same, however on some embedded<br>
platforms, for example RTEMS which uses newlib as it&#39;s standard c libra=
ry,<br>
they both are different.<br>
---<br>
=C2=A0crc/xxhash.h | 8 ++++----<br>
=C2=A01 file changed, 4 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/crc/xxhash.h b/crc/xxhash.h<br>
index 8850d20..9019089 100644<br>
--- a/crc/xxhash.h<br>
+++ b/crc/xxhash.h<br>
@@ -107,9 +107,9 @@ XXH32() :<br>
=C2=A0// Advanced Hash Functions<br>
=C2=A0//****************************<br>
<br>
-void*=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0XXH32_init=C2=A0 =C2=A0(unsigned in=
t seed);<br>
+void*=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0XXH32_init=C2=A0 =C2=A0(uint32_t se=
ed);<br>
=C2=A0XXH_errorcode XXH32_update (void* state, const void* input, int len);=
<br>
-unsigned int=C2=A0 XXH32_digest (void* state);<br>
+uint32_t=C2=A0 XXH32_digest (void* state);<br>
<br>
=C2=A0/*<br>
=C2=A0These functions calculate the xxhash of an input provided in several =
small packets,<br>
@@ -135,7 +135,7 @@ Memory will be freed by XXH32_digest().<br>
<br>
<br>
=C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0XXH32_sizeofState(void);<=
br>
-XXH_errorcode XXH32_resetState(void* state, unsigned int seed);<br>
+XXH_errorcode XXH32_resetState(void* state, uint32_t seed);<br>
<br>
=C2=A0#define=C2=A0 =C2=A0 =C2=A0 =C2=A0XXH32_SIZEOFSTATE 48<br>
=C2=A0typedef struct { long long ll[(XXH32_SIZEOFSTATE+(sizeof(<wbr>long lo=
ng)-1))/sizeof(long long)]; } XXH32_stateSpace_t;<br>
@@ -151,7 +151,7 @@ use the structure XXH32_stateSpace_t, which will ensure=
 that memory space is lar<br>
=C2=A0*/<br>
<br>
<br>
-unsigned int XXH32_intermediateDigest (void* state);<br>
+uint32_t XXH32_intermediateDigest (void* state);<br>
=C2=A0/*<br>
=C2=A0This function does the same as XXH32_digest(), generating a 32-bit ha=
sh,<br>
=C2=A0but preserve memory context.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">-- <br>
1.9.1<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><=
div>Regards,<br></div>Udit kumar agarwal<br><a href=3D"http://uditagarwal.i=
n/" target=3D"_blank">http://uditagarwal.in/</a><br></div></div>
</div></div>

--00000000000022072d0572faa0cf--

