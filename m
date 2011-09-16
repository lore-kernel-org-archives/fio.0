Return-Path: <gnehzuil@gmail.com>
MIME-Version: 1.0
From: Zheng Liu <gnehzuil@gmail.com>
Date: Thu, 15 Sep 2011 21:55:05 -0600
Subject: [PATCH RESEND] Fix sum_stat() bug in group_reporting.
Message-ID: <1316145305-10492-1-git-send-email-gnehzuil@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Jens Axboe <JAxboe@fusionio.com>, Yu-ju Hong <yjhong@google.com>
List-ID: <fio@vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Write samples in io_stat does not be counted with rw=3Drandread, vice versa=
.
Then, in sum_stat() function, it will cause 0/0 in calculating mean and S,
and 'nan' is printed. So it should return immediately when src->samples is
equal to 0.

the error result is as follows:
  write: io=3D8328.0KB, bw=3D1582.7KB/s, iops=3D395 , runt=3D  5262msec
    clat (usec): min=3D58 , max=3D293353 , avg=3D -nan, stdev=3D -nan
     lat (usec): min=3D59 , max=3D293353 , avg=3D -nan, stdev=3D -nan
    bw (KB/s) : min=3D   92, max=3D  804, per=3D-nan%, avg=3D -nan, stdev=
=3D -nan

the configuration file used:

[global]
direct=3D1
ioengine=3Dpsync
bs=3D4k
filename=3D/dev/sdb1
runtime=3D5
group_reporting
loops=3D50

[read]
rw=3Drandread
numjobs=3D8

[write]
rw=3Drandwrite
numjobs=3D8

CC: Jens Axboe <jaxboe@fusionio.com>
CC: Yu-ju Hong <yjhong@google.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 stat.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/stat.c b/stat.c
index d2cc775..3662fd9 100644
--- a/stat.c
+++ b/stat.c
@@ -618,6 +618,9 @@ static void sum_stat(struct io_stat *dst, struct io_sta=
t *src, int nr)
 {
 	double mean, S;
=20
+	if (src->samples =3D=3D 0)
+		return;
+
 	dst->min_val =3D min(dst->min_val, src->min_val);
 	dst->max_val =3D max(dst->max_val, src->max_val);
=20
--=20
1.7.1


