Return-Path: <elliott@hp.com>
Subject: [PATCH] fio: fix hangs due to iodepth_low
From: Robert Elliott <elliott@hp.com>
Date: Wed, 03 Sep 2014 19:23:43 -0500
Message-ID: <20140904002343.24650.74664.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, elliott@hp.com, fio@vger.kernel.org, scameron@beardog.cce.hp.com
List-ID: <fio@vger.kernel.org>

With some combinations of iodepth, iodepth_batch, iodepth_batch_complete,
and io_depth_low, do_io hangs after reaping the first set of completions
since io_u_queued_complete is called requesting more completions than
td->cur_depth.

Example printing min_evts and td->cur_depth in the do/while loop:
waiting on min=96 cd=627
waiting on min=96 cd=531
waiting on min=96 cd=435
waiting on min=96 cd=339
waiting on min=96 cd=243
waiting on min=96 cd=147
waiting on min=96 cd=51
Jobs: 12 (f=12): [r(12)] [43.8% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 00m:09s]
...
Jobs: 12 (f=12): [r(12)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 2863d:18h:28m:38s]
<fio never exits>

Fix this by adjusting min_evts to the current_depth if that is smaller.

Tested with a jobfile including:
iodepth=1011
iodepth_batch=96
iodepth_batch_complete=96
iodepth_low=1
runtime=15
time_based

Made the same change to do_verify, but not tested there.

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 backend.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/backend.c b/backend.c
index 7cb0a39..ce97f6d 100644
--- a/backend.c
+++ b/backend.c
@@ -606,6 +606,8 @@ reap:
 				 * and do the verification on them through
 				 * the callback handler
 				 */
+				if (min_events < td->cur_depth)
+					min_events = td->cur_depth;
 				if (io_u_queued_complete(td, min_events, bytes_done) < 0) {
 					ret = -1;
 					break;
@@ -873,6 +875,8 @@ reap:
 				fio_gettime(&comp_time, NULL);
 
 			do {
+				if (min_evts < td->cur_depth)
+					min_evts = td->cur_depth;
 				ret = io_u_queued_complete(td, min_evts, bytes_done);
 				if (ret < 0)
 					break;


