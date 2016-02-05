Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 5 Feb 2016 11:59:48 +0300
Message-ID: <CANvN+emGxSfGdx=XO9_Lgfgjuybd1+PDJMW1xsMN-LVUQFw_Cw@mail.gmail.com>
Subject: Copy/paste nit in io_ddir.h?
Content-Type: multipart/alternative; boundary=001a11418eb8f58024052b021364
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--001a11418eb8f58024052b021364
Content-Type: text/plain; charset=UTF-8

diff --git a/io_ddir.h b/io_ddir.h
index e5eff68..071b036 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -17,7 +17,7 @@ enum fio_ddir {
 static inline const char *io_ddir_name(enum fio_ddir ddir)
 {
        const char *name[] = { "read", "write", "trim", "sync", "datasync",
-                               "sync_file_range", "write", };
+                               "sync_file_range", "wait", };

        if (ddir < DDIR_LAST)
                return name[ddir];

Regards,
Andrey

--001a11418eb8f58024052b021364
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>diff --git a/io_ddir.h b/io_ddir.h</div><div>index e5=
eff68..071b036 100644</div><div>--- a/io_ddir.h</div><div>+++ b/io_ddir.h</=
div><div>@@ -17,7 +17,7 @@ enum fio_ddir {</div><div>=C2=A0static inline co=
nst char *io_ddir_name(enum fio_ddir ddir)</div><div>=C2=A0{</div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 const char *name[] =3D { &quot;read&quot;, &quot;w=
rite&quot;, &quot;trim&quot;, &quot;sync&quot;, &quot;datasync&quot;,</div>=
<div>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;sync_file_range&quot;, &quot;w=
rite&quot;, };</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;sync_file_ra=
nge&quot;, &quot;wait&quot;, };</div><div>=C2=A0</div><div>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 if (ddir &lt; DDIR_LAST)</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return name[ddir];</div><div><br></div>Rega=
rds,<br>Andrey<br></div>

--001a11418eb8f58024052b021364--

