Return-Path: <vapier@google.com>
MIME-Version: 1.0
Sender: vapier@google.com
In-Reply-To: <1414183357-31504-1-git-send-email-gwendal@chromium.org>
References: <1414183357-31504-1-git-send-email-gwendal@chromium.org>
From: Mike Frysinger <vapier@chromium.org>
Date: Fri, 24 Oct 2014 16:47:36 -0400
Message-ID: <CAAbOScn8QgtqeM6A20p9Zy1vBkcyDuk4R1ia34u+Q=KKJtnc+Q@mail.gmail.com>
Subject: Re: [PATCH] fio: fix alignement to prevent bus error on ARM
Content-Type: multipart/alternative; boundary=bcaec511e5faddf12c0506314b4e
To: Gwendal Grignou <gwendal@chromium.org>
Cc: axboe@kernel.dk, fio@vger.kernel.org, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

--bcaec511e5faddf12c0506314b4e
Content-Type: text/plain; charset=UTF-8

the code seems to be fine with gcc-isms, so i might suggest anon unions
instead to make it harder to break:
union {
  uint64_t __aligner;
  uint16_t continue_on_error;
};
-mike

On Fri, Oct 24, 2014 at 4:42 PM, Gwendal Grignou <gwendal@chromium.org>
wrote:

> Add a filler field to be ensure 64bit alignment.
> Otherwise, we would trigger SIGBUS error in sum_stat()
>
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---
>  stat.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/stat.h b/stat.h
> index 32ea226..9595e59 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -172,6 +172,7 @@ struct thread_stat {
>          * IO Error related stats
>          */
>         uint16_t continue_on_error;
> +       uint16_t filler[3];
>         uint64_t total_err_count;
>         uint32_t first_error;
>
> --
> 2.1.0.rc2.206.gedb03e5
>
>

--bcaec511e5faddf12c0506314b4e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">the code seems to be fine with gcc-isms, so i might sugges=
t anon unions instead to make it harder to break:<div>union {</div><div>=C2=
=A0 uint64_t __aligner;</div><div>=C2=A0 uint16_t continue_on_error;</div><=
div>};<div>-mike</div></div></div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Fri, Oct 24, 2014 at 4:42 PM, Gwendal Grignou <span dir=
=3D"ltr">&lt;<a href=3D"mailto:gwendal@chromium.org" target=3D"_blank">gwen=
dal@chromium.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Ad=
d a filler field to be ensure 64bit alignment.<br>
Otherwise, we would trigger SIGBUS error in sum_stat()<br>
<br>
Signed-off-by: Gwendal Grignou &lt;<a href=3D"mailto:gwendal@chromium.org">=
gwendal@chromium.org</a>&gt;<br>
---<br>
=C2=A0stat.h | 1 +<br>
=C2=A01 file changed, 1 insertion(+)<br>
<br>
diff --git a/stat.h b/stat.h<br>
index 32ea226..9595e59 100644<br>
--- a/stat.h<br>
+++ b/stat.h<br>
@@ -172,6 +172,7 @@ struct thread_stat {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* IO Error related stats<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uint16_t continue_on_error;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0uint16_t filler[3];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uint64_t total_err_count;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uint32_t first_error;<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.1.0.rc2.206.gedb03e5<br>
<br>
</font></span></blockquote></div><br></div>

--bcaec511e5faddf12c0506314b4e--

