Return-Path: <bvanassche@acm.org>
MIME-Version: 1.0
From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 6 Nov 2010 03:35:18 -0600
Subject: RFC: Data pattern buffer filling race condition fix
Message-ID: <201011061035.18709.bvanassche@acm.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <JAxboe@fusionio.com>, Radha Ramachandran <radha@google.com>
List-ID: <fio@vger.kernel.org>

On multicore non-x86 CPUs fio has been observed to frequently reports false
data verification failures with I/O engine libaio and I/O depths above one.
This is because of a race condition in the function fill_pattern(). The cod=
e
in that function only works correct if all CPUs of a multicore system
observe store instructions in the order they were issued. That is the case =
for
multicore x86 systems but not for all other CPU families, such as e.g. the
POWER CPU family.

As far as I can see this bug was introduced via commit
cbe8d7561cf6d81d741d87eb7940db2a111d2144 (July 14, 2010).

I'm posting this patch as an RFC since the fix is GCC-specific.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>

diff --git a/verify.c b/verify.c
index ea1a911..3826198 100644
--- a/verify.c
+++ b/verify.c
@@ -31,18 +31,27 @@ void fill_pattern(struct thread_data *td, void *p, unsi=
gned int len, struct io_u
 		fill_random_buf(p, len);
 		break;
 	case 1:
+#ifdef __GNUC__
+		__sync_synchronize();
+#endif
 		if (io_u->buf_filled_len >=3D len) {
 			dprint(FD_VERIFY, "using already filled verify pattern b=3D0 len=3D%u\n=
", len);
 			return;
 		}
 		dprint(FD_VERIFY, "fill verify pattern b=3D0 len=3D%u\n", len);
 		memset(p, td->o.verify_pattern[0], len);
+#ifdef __GNUC__
+		__sync_synchronize();
+#endif
 		io_u->buf_filled_len =3D len;
 		break;
 	default: {
 		unsigned int i =3D 0, size =3D 0;
 		unsigned char *b =3D p;
=20
+#ifdef __GNUC__
+		__sync_synchronize();
+#endif
 		if (io_u->buf_filled_len >=3D len) {
 			dprint(FD_VERIFY, "using already filled verify pattern b=3D%d len=3D%u\=
n",
 					td->o.verify_pattern_bytes, len);
@@ -58,6 +67,9 @@ void fill_pattern(struct thread_data *td, void *p, unsign=
ed int len, struct io_u
 			memcpy(b+i, td->o.verify_pattern, size);
 			i +=3D size;
 		}
+#ifdef __GNUC__
+		__sync_synchronize();
+#endif
 		io_u->buf_filled_len =3D len;
 		break;
 		}

