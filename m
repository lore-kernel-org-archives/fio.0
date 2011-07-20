Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
From: Dan Ehrenberg <dehrenberg@google.com>
Date: Wed, 20 Jul 2011 15:11:18 -0600
Subject: [PATCH 1/2] Respect iodepth_batch_complete=0 in main loop
Message-ID: <1311196279-7373-1-git-send-email-dehrenberg@google.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <JAxboe@fusionio.com>
Cc: Dan Ehrenberg <dehrenberg@google.com>
List-ID: <fio@vger.kernel.org>

If the iodepth_batch_complete is 0, then even if the queue is full,
we still don't make min_events be 1 in the main loop. Instead, poll
in a non-blocking way until a result is found.

Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>
---
 fio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fio.c b/fio.c
index 120431e..7396421 100644
--- a/fio.c
+++ b/fio.c
@@ -557,7 +557,7 @@ sync_done:
 		if (full || !td->o.iodepth_batch_complete) {
 			min_events =3D min(td->o.iodepth_batch_complete,
 					 td->cur_depth);
-			if (full && !min_events)
+			if (full && !min_events && td->o.iodepth_batch_complete !=3D 0)
 				min_events =3D 1;
=20
 			do {
@@ -719,7 +719,7 @@ sync_done:
 		if (full || !td->o.iodepth_batch_complete) {
 			min_evts =3D min(td->o.iodepth_batch_complete,
 					td->cur_depth);
-			if (full && !min_evts)
+			if (full && !min_evts && td->o.iodepth_batch_complete !=3D 0)
 				min_evts =3D 1;
=20
 			if (__should_check_rate(td, 0) ||
--=20
1.7.3.1


