Return-Path: <igor.j.konopko@intel.com>
From: Igor Konopko <igor.j.konopko@intel.com>
Subject: [PATCH] stat: fix --bandwidth-log segfault
Date: Fri,  8 Jun 2018 10:26:25 +0200
Message-Id: <20180608082625.2884-1-igor.j.konopko@intel.com>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: igor.j.konopko@intel.com
List-ID: <fio@vger.kernel.org>

Since bandwidth log has no corresponding thread data
and pending struct, we cannot access any fields inside it.

Signed-off-by: Igor Konopko <igor.j.konopko@intel.com>
---
 stat.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/stat.c b/stat.c
index c89a7f06..1ec2849c 100644
--- a/stat.c
+++ b/stat.c
@@ -2212,12 +2212,14 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 	 * submissions, flag 'td' as needing a log regrow and we'll take
 	 * care of it on the submission side.
 	 */
-	if (iolog->td->o.io_submit_mode == IO_MODE_OFFLOAD ||
+	if ((iolog->td && iolog->td->o.io_submit_mode == IO_MODE_OFFLOAD) ||
 	    !per_unit_log(iolog))
 		return regrow_log(iolog);
 
-	iolog->td->flags |= TD_F_REGROW_LOGS;
-	assert(iolog->pending->nr_samples < iolog->pending->max_samples);
+	if (iolog->td)
+		iolog->td->flags |= TD_F_REGROW_LOGS;
+	if (iolog->pending)
+		assert(iolog->pending->nr_samples < iolog->pending->max_samples);
 	return iolog->pending;
 }
 
-- 
2.14.3


