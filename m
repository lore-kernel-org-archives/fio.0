Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 09/17] Remove unassigned fio_unused variable
Date: Tue,  7 Mar 2017 22:13:00 +0200
Message-Id: <20170307201308.66814-10-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This doesn't need to exist.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 rate-submit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/rate-submit.c b/rate-submit.c
index 42927ff..4738dc4 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -98,7 +98,6 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 {
 	struct thread_data *parent = sw->wq->td;
 	struct thread_data *td = sw->priv;
-	int fio_unused ret;
 
 	memcpy(&td->o, &parent->o, sizeof(td->o));
 	memcpy(&td->ts, &parent->ts, sizeof(td->ts));
-- 
2.9.3


