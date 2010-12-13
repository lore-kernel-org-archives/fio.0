Return-Path: <steve@dangyankee.net>
MIME-Version: 1.0
From: Steven Pratt <steve@dangyankee.net>
Date: Mon, 13 Dec 2010 13:58:48 -0700
Subject: resend [PATCH] fix ramp_in
Message-ID: <4D068908.8030205@dangyankee.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <JAxboe@fusionio.com>
List-ID: <fio@vger.kernel.org>

Let's try this again without the mangling.

There are a couple of problems with the relatively new ramp_in feature
of fio.  First, the estimated time
to completion did not correctly take it into account and bounces around.
Second and more importantly,
the runtime was including ramp in time in throughput calculations even
though the IO done during that
time was ignored, thus making throughput metrics incorrect. This patch
fixes both.


Signed-off-by Steven Pratt <slpratt@austin.ibm.com>


 eta.c  |    4 ++--                               =20
 fio.c  |   12 +++++++-----                       =20
 fio.h  |    2 +-                                 =20
 stat.c |    4 ++--                               =20
 4 files changed, 12 insertions(+), 10 deletions(-)

diff -Naur fio-1.44.1/eta.c fio-ramp/eta.c   =20
--- fio-1.44.1/eta.c    2010-10-22 14:44:00.000000000 -0500
+++ fio-ramp/eta.c      2010-12-13 13:28:50.573808191 -0600
@@ -161,12 +161,12 @@                                    =20
                 * if given, otherwise assume it'll run at the specified
rate.
               =20
*/                                                         =20
                if (td->o.timeout)
{                                        =20
-                       t_eta =3D td->o.timeout +
td->o.start_delay;          =20
+                       t_eta =3D td->o.timeout + td->o.start_delay
+td->o.ramp_time;
                                                                           =
      =20

                        if (in_ramp_time(td))
{                                  =20
                                unsigned long
ramp_left;                         =20
                                                                           =
      =20

-                               ramp_left =3D
mtime_since_now(&td->start);         =20
+                               ramp_left =3D
mtime_since_now(&td->epoch);         =20
                                ramp_left =3D (ramp_left + 999) /
1000;            =20
                                if (ramp_left <=3D
t_eta)                          =20
                                        t_eta -=3D
ramp_left;                      =20
diff -Naur fio-1.44.1/fio.c
fio-ramp/fio.c                                       =20
--- fio-1.44.1/fio.c    2010-10-22 14:44:00.000000000
-0500                      =20
+++ fio-ramp/fio.c      2010-12-13 13:29:36.611258945
-0600                      =20
@@ -972,6 +972,8
@@                                                              =20
      =20
}                                                                        =20
                                                                           =
      =20

        fio_gettime(&tv,
NULL);                                                  =20
+       td->ts.runtime[0] =3D
0;                                                   =20
+       td->ts.runtime[1] =3D
0;                                                   =20
        memcpy(&td->epoch, &tv,
sizeof(tv));                                     =20
        memcpy(&td->start, &tv,
sizeof(tv));                                     =20
 }                                                                         =
      =20

@@ -1153,11 +1155,11
@@                                                          =20
                                                                           =
      =20

                if (td_read(td) && td->io_bytes[DDIR_READ])
{                    =20
                        elapsed =3D
utime_since_now(&td->start);                   =20
-                       runtime[DDIR_READ] +=3D
elapsed;                           =20
+                       td->ts.runtime[DDIR_READ] +=3D
elapsed;                    =20
              =20
}                                                                =20
                if (td_write(td) && td->io_bytes[DDIR_WRITE])
{                  =20
                        elapsed =3D
utime_since_now(&td->start);                   =20
-                       runtime[DDIR_WRITE] +=3D
elapsed;                          =20
+                       td->ts.runtime[DDIR_WRITE] +=3D
elapsed;                   =20
              =20
}                                                                =20
                                                                           =
      =20

                if (td->error ||
td->terminate)                                  =20
@@ -1174,15 +1176,15
@@                                                          =20
                                                                           =
      =20

              =20
do_verify(td);                                                   =20
                                                                           =
      =20

-               runtime[DDIR_READ] +=3D
utime_since_now(&td->start);               =20
+               td->ts.runtime[DDIR_READ] +=3D
utime_since_now(&td->start);        =20
                                                                           =
      =20

                if (td->error ||
td->terminate)                                  =20
                        break;
        }

        update_rusage_stat(td);
-       td->ts.runtime[0] =3D (runtime[0] + 999) / 1000;
-       td->ts.runtime[1] =3D (runtime[1] + 999) / 1000;
+       td->ts.runtime[0] =3D (td->ts.runtime[0] + 999) / 1000;
+       td->ts.runtime[1] =3D (td->ts.runtime[1] + 999) / 1000;
        td->ts.total_run_time =3D mtime_since_now(&td->epoch);
        td->ts.io_bytes[0] =3D td->io_bytes[0];
        td->ts.io_bytes[1] =3D td->io_bytes[1];
diff -Naur fio-1.44.1/fio.h fio-ramp/fio.h
--- fio-1.44.1/fio.h    2010-10-22 14:44:00.000000000 -0500
+++ fio-ramp/fio.h      2010-10-29 16:30:55.000000000 -0500
@@ -126,7 +126,7 @@
        unsigned long total_complete;

        unsigned long long io_bytes[2];
-       unsigned long runtime[2];
+       unsigned long long runtime[2];
        unsigned long total_run_time;

        /*
diff -Naur fio-1.44.1/stat.c fio-ramp/stat.c
--- fio-1.44.1/stat.c   2010-10-22 14:44:00.000000000 -0500
+++ fio-ramp/stat.c     2010-10-29 16:33:49.000000000 -0500
@@ -172,7 +172,7 @@
        iops =3D (1000 * ts->total_io_u[ddir]) / runt;
        iops_p =3D num2str(iops, 6, 1, 0);

-       log_info("  %s: io=3D%sB, bw=3D%sB/s, iops=3D%s, runt=3D%6lumsec\n"=
,
+       log_info("  %s: io=3D%sB, bw=3D%sB/s, iops=3D%s, runt=3D%6llumsec\n=
",
                                        ddir_str[ddir], io_p, bw_p, iops_p,
                                        ts->runtime[ddir]);

@@ -380,7 +380,7 @@
        if (ts->runtime[ddir])
                bw =3D ts->io_bytes[ddir] / ts->runtime[ddir];

-       log_info(";%llu;%llu;%lu", ts->io_bytes[ddir] >> 10, bw,
+       log_info(";%llu;%llu;%llu", ts->io_bytes[ddir] >> 10, bw,
                                                        ts->runtime[ddir]);

        if (calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev))


