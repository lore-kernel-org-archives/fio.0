Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 09/11] libaio: relax cdmprio_percentage constraints
Date: Tue,  6 Jul 2021 09:17:41 +0900
Message-Id: <20210706001743.10818-10-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

When an AIO is issued without a priority set, Linux kernel will execute
it using the issuing context IO priority set with ioprio_set(). In fio,
a job IO priority is controlled with the prioclass and prio options and
these options cannot be used together with the cmdprio_percentage
option.

Allow a user to have AIO priorities to default to the job defined IO
priority by removing the mutual exclusion between the options
cmdprio_percentage and prioclass/prio.

With the introduction of the aioprioclass option, an AIO priority may be
lower than the job default priority, resulting in reversed clat
statistics showed for high and low priority IOs when fio completes.
Solve this by setting an io_u IO_U_F_PRIORITY flag depending on a
comparison between the aio priority and job default IO priority. The job
default IO priority is added as the ioprio field in struct thread_data
for convenience, avoiding referencing the job options for every IO.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 backend.c        |  1 +
 engines/libaio.c | 28 ++++++++++++++++------------
 fio.h            |  5 +++++
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/backend.c b/backend.c
index 6290e0d6..ff53e8b5 100644
--- a/backend.c
+++ b/backend.c
@@ -1760,6 +1760,7 @@ static void *thread_main(void *data)
 			td_verror(td, errno, "ioprio_set");
 			goto err;
 		}
+		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio);
 	}
 
 	if (o->cgroup && cgroup_setup(td, cgroup_list, &cgroup_mnt))
diff --git a/engines/libaio.c b/engines/libaio.c
index e0f8a3d3..c0cbf97b 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -282,13 +282,26 @@ static int fio_libaio_need_prio(struct libaio_options *o, struct io_u *io_u)
 static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct libaio_options *o = td->eo;
-	enum fio_ddir ddir = io_u->ddir;
 	unsigned int p = fio_libaio_need_prio(o, io_u);
+	enum fio_ddir ddir = io_u->ddir;
+	unsigned int aioprio =
+		ioprio_value(o->aioprio_class[ddir], o->aioprio[ddir]);
 
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->iocb.aio_reqprio =
-			ioprio_value(o->aioprio_class[ddir], o->aioprio[ddir]);
+		io_u->iocb.aio_reqprio = aioprio;
 		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
+		if (!td->ioprio || aioprio < td->ioprio) {
+			/*
+			 * The AIO priortity is higher than the default context
+			 * priority.
+			 */
+			io_u->flags |= IO_U_F_PRIORITY;
+		}
+	} else if (td->ioprio && td->ioprio < aioprio) {
+		/*
+		 * The IO will be executed with the default context priority
+		 * and it is higher than the aio priority.
+		 */
 		io_u->flags |= IO_U_F_PRIORITY;
 	}
 }
@@ -605,15 +618,6 @@ static int fio_libaio_init(struct thread_data *td)
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
 	}
-	if (p &&
-	    (fio_option_is_set(to, ioprio) ||
-	     fio_option_is_set(to, ioprio_class))) {
-		log_err("%s: cmdprio_percentage option and mutually exclusive "
-			"prio or prioclass option is set, exiting\n",
-			to->name);
-		td_verror(td, EINVAL, "fio_libaio_init");
-		return 1;
-	}
 
 	ld->use_aioprio = p || nr_aioprio_bssplits;
 
diff --git a/fio.h b/fio.h
index 83334652..fa7e42dd 100644
--- a/fio.h
+++ b/fio.h
@@ -274,6 +274,11 @@ struct thread_data {
 
 	int shm_id;
 
+	/*
+	 * Job default IO priority set with prioclass and prio options.
+	 */
+	unsigned int ioprio;
+
 	/*
 	 * IO engine hooks, contains everything needed to submit an io_u
 	 * to any of the available IO engines.
-- 
2.31.1


