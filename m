Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
From: Dan Ehrenberg <dehrenberg@google.com>
Date: Wed, 20 Jul 2011 15:11:19 -0600
Subject: [PATCH 2/2] Libaio engine support for iodepth_batch_complete=0
Message-ID: <1311196279-7373-2-git-send-email-dehrenberg@google.com>
References: <1311196279-7373-1-git-send-email-dehrenberg@google.com>
In-Reply-To: <1311196279-7373-1-git-send-email-dehrenberg@google.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <JAxboe@fusionio.com>
Cc: Dan Ehrenberg <dehrenberg@google.com>
List-ID: <fio@vger.kernel.org>

Previously, even if iodepth_batch_complete=3D0, the libaio engine
passed in non-zero values for the min_nr value for io_getevents.
This patch makes min_nr always 0 if iodepth_batch_complete =3D=3D 0,
and if multiple events are required at a higher level, then
we poll io_getevents multiple times for the events.

Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>
---
 engines/libaio.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/engines/libaio.c b/engines/libaio.c
index 439cd24..c837ab6 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -62,22 +62,18 @@ static int fio_libaio_getevents(struct thread_data *td,=
 unsigned int min,
 				unsigned int max, struct timespec *t)
 {
 	struct libaio_data *ld =3D td->io_ops->data;
-	int r;
+	unsigned actual_min =3D td->o.iodepth_batch_complete =3D=3D 0 ? 0 : min;
+	int r, events =3D 0;
=20
 	do {
-		r =3D io_getevents(ld->aio_ctx, min, max, ld->aio_events, t);
-		if (r >=3D (int) min)
-			break;
-		else if (r =3D=3D -EAGAIN) {
+		r =3D io_getevents(ld->aio_ctx, actual_min, max, ld->aio_events + events=
, t);
+		if (r >=3D 0)
+			events +=3D r;
+		else if (r =3D=3D -EAGAIN)
 			usleep(100);
-			continue;
-		} else if (r =3D=3D -EINTR)
-			continue;
-		else if (r !=3D 0)
-			break;
-	} while (1);
+	} while (events < min);
=20
-	return r;
+	return r < 0 ? r : events;
 }
=20
 static int fio_libaio_queue(struct thread_data *td, struct io_u *io_u)
--=20
1.7.3.1


