Return-Path: <evelu@redhat.com>
Date: Mon, 15 Feb 2016 09:26:10 -0500 (EST)
From: Erwan Velu <evelu@redhat.com>
Message-ID: <894625484.28673864.1455546370170.JavaMail.zimbra@redhat.com>
In-Reply-To: <20160214130002.5D67B2C0145@kernel.dk>
References: <20160214130002.5D67B2C0145@kernel.dk>
Subject: Re: Recent changes (master)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks Jens for clarifying this use case.

The part I don't really get is _when_ does the log is reported.
By a short read of the source code, I don't get how does the commited IO is=
 reported on the server side.
I did find some code when we fire the IO but not when the IO is completed. =
In a power-failure case, that's pretty important reporting only completed o=
nes.
Thanks,
Erwan

----- Mail original -----
De: "Jens Axboe" <axboe@kernel.dk>
=C3=80: fio@vger.kernel.org
Envoy=C3=A9: Dimanche 14 F=C3=A9vrier 2016 14:00:02
Objet: Recent changes (master)

The following changes since commit e0ee7a8ba4e6badc6cb73814315aa11c15d86ef9=
:

  fio.1: man page fixes (2016-02-12 15:00:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c0821a08db2fd3e37e16db73c3c4c9c7ff601e88:

  Allow for the include file specification to be relative. (2016-02-13 12:3=
1:00 -0700)

----------------------------------------------------------------
Andrey Kuzmin (1):
      Allow for the include file specification to be relative.

 init.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 5ee4082..c7ce2cc 100644
--- a/init.c
+++ b/init.c
@@ -1773,15 +1773,48 @@ int __parse_jobs_ini(struct thread_data *td,
 =09=09=09strip_blank_end(p);
=20
 =09=09=09if (!strncmp(p, "include", strlen("include"))) {
-=09=09=09=09char *filename =3D p + strlen("include") + 1;
+=09=09=09=09char *filename =3D p + strlen("include") + 1,
+=09=09=09=09=09*ts, *full_fn =3D NULL;
=20
-=09=09=09=09if ((ret =3D __parse_jobs_ini(td, filename,
-=09=09=09=09=09=09is_buf, stonewall_flag, type, 1,
-=09=09=09=09=09=09name, &opts, &alloc_opts, &num_opts))) {
-=09=09=09=09=09log_err("Error %d while parsing include file %s\n",
+=09=09=09=09/*
+=09=09=09=09 * Allow for the include filename
+=09=09=09=09 * specification to be relative.
+=09=09=09=09 */
+=09=09=09=09if (access(filename, F_OK) &&
+=09=09=09=09    (ts =3D strrchr(file, '/'))) {
+=09=09=09=09=09int len =3D ts - file +
+=09=09=09=09=09=09strlen(filename) + 2;
+
+=09=09=09=09=09if (!(full_fn =3D calloc(1, len))) {
+=09=09=09=09=09=09ret =3D ENOMEM;
+=09=09=09=09=09=09break;
+=09=09=09=09=09}
+
+=09=09=09=09=09strncpy(full_fn,
+=09=09=09=09=09=09file, (ts - file) + 1);
+=09=09=09=09=09strncpy(full_fn + (ts - file) + 1,
+=09=09=09=09=09=09filename, strlen(filename));
+=09=09=09=09=09full_fn[len - 1] =3D 0;
+=09=09=09=09=09filename =3D full_fn;
+=09=09=09=09}
+
+=09=09=09=09ret =3D __parse_jobs_ini(td, filename, is_buf,
+=09=09=09=09=09=09       stonewall_flag, type, 1,
+=09=09=09=09=09=09       name, &opts,
+=09=09=09=09=09=09       &alloc_opts, &num_opts);
+
+=09=09=09=09if (ret) {
+=09=09=09=09=09log_err("Error %d while parsing "
+=09=09=09=09=09=09"include file %s\n",
 =09=09=09=09=09=09ret, filename);
-=09=09=09=09=09break;
 =09=09=09=09}
+
+=09=09=09=09if (full_fn)
+=09=09=09=09=09free(full_fn);
+
+=09=09=09=09if (ret)
+=09=09=09=09=09break;
+
 =09=09=09=09continue;
 =09=09=09}
=20
