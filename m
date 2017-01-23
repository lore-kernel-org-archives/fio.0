Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1485184391-11036-4-git-send-email-tkusumi@tuxera.com>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com> <1485184391-11036-4-git-send-email-tkusumi@tuxera.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 23 Jan 2017 19:06:18 +0300
Message-ID: <CANvN+e=SsCxGCcMNktU88+uSS5_TrZ+jNG1K+gLcgS5vH1ZDDA@mail.gmail.com>
Subject: Re: [PATCH 4/8] Remove unused io_u's priv union field
Content-Type: multipart/alternative; boundary=94eb2c19ec0a115bb30546c52e88
To: kusumi.tomohiro@gmail.com
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>, fio@vger.kernel.org, axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

--94eb2c19ec0a115bb30546c52e88
Content-Type: text/plain; charset=UTF-8

This may break some I/O engines.


On Jan 23, 2017 18:13, <kusumi.tomohiro@gmail.com> wrote:

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengine.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ioengine.h b/ioengine.h
index 89873e7..7249df6 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -123,7 +123,6 @@ struct io_u {
                struct ibv_mr *mr;
 #endif
                void *mmap_data;
-               uint64_t null;
        };
 };

--
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--94eb2c19ec0a115bb30546c52e88
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">This may break some I/O engines.<div><br><div class=3D"gm=
ail_extra"><br><div class=3D"gmail_quote">On Jan 23, 2017 18:13,  &lt;<a hr=
ef=3D"mailto:kusumi.tomohiro@gmail.com">kusumi.tomohiro@gmail.com</a>&gt; w=
rote:<br type=3D"attribution"><blockquote class=3D"quote" style=3D"margin:0=
 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">From: Tomohiro Kusum=
i &lt;<a href=3D"mailto:tkusumi@tuxera.com">tkusumi@tuxera.com</a>&gt;<br>
<br>
Signed-off-by: Tomohiro Kusumi &lt;<a href=3D"mailto:tkusumi@tuxera.com">tk=
usumi@tuxera.com</a>&gt;<br>
---<br>
=C2=A0ioengine.h | 1 -<br>
=C2=A01 file changed, 1 deletion(-)<br>
<br>
diff --git a/ioengine.h b/ioengine.h<br>
index 89873e7..7249df6 100644<br>
--- a/ioengine.h<br>
+++ b/ioengine.h<br>
@@ -123,7 +123,6 @@ struct io_u {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ibv_mr *mr;<=
br>
=C2=A0#endif<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *mmap_data;<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uint64_t null;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 };<br>
=C2=A0};<br>
<font color=3D"#888888"><br>
--<br>
2.5.5<br>
<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe fio&quot; in=
<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at=C2=A0 <a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" rel=3D"noreferrer" target=3D"_blank">http://vger.kernel.org/<wbr>m=
ajordomo-info.html</a><br>
</font></blockquote></div><br></div></div></div>

--94eb2c19ec0a115bb30546c52e88--

