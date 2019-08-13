Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Subject: Re: [PATCH 3/5] Refine packed annotations in stat.h
References: <20190813020136.15798-1-bvanassche@acm.org>
 <20190813020136.15798-4-bvanassche@acm.org>
 <cfaf773a-8fe0-ceaa-3b7d-bbfe7116e2bf@kernel.dk>
 <a5ab1f27-72b6-7d27-5eae-be61294df3f9@acm.org>
 <2ae2b675-2da9-c4a2-4b29-cb21afc19b1f@kernel.dk>
 <d0e9560f-2584-f439-fd27-e1ccfc768da8@acm.org>
 <77dec459-8f07-abd6-d2e0-4089bccb380e@kernel.dk>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <008388f7-72b4-6b42-51f8-c824ff884839@acm.org>
Date: Tue, 13 Aug 2019 14:46:55 -0700
MIME-Version: 1.0
In-Reply-To: <77dec459-8f07-abd6-d2e0-4089bccb380e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/13/19 2:04 PM, Jens Axboe wrote:
> I was more thinking at build time. It'd be nice if you could do
> something ala:
>=20
> struct bla {
> 	int a;
> 	long b;
> };
>=20
> struct bla b1;
> struct bla b2 __attribute__((__packed__));
>=20
> BUILD_BUG_ON(sizeof(b1) !=3D sizeof(b2));
>=20
> If we rely on external components to do this, we might as well not do
> it.

Perhaps something like this?

diff --git a/eta.c b/eta.c
index 647a1bdd8eed..4095a257d206 100644
--- a/eta.c
+++ b/eta.c
@@ -736,6 +736,8 @@ void print_thread_status(void)

 void print_status_init(int thr_number)
 {
+	BUILD_BUG_ON(sizeof(struct jobs_eta) !=3D sizeof(struct jobs_eta_packed=
));
+
 	DRD_IGNORE_VAR(__run_str);
 	__run_str[thr_number] =3D 'P';
 	update_condensed_str(__run_str, run_str);
diff --git a/fio.h b/fio.h
index 2094d30b863e..4bf96fc1cd62 100644
--- a/fio.h
+++ b/fio.h
@@ -66,6 +66,8 @@
 #include <cuda.h>
 #endif

+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)])=
)
+
 struct fio_sem;

 /*
diff --git a/stat.h b/stat.h
index e9551381ce7b..c209ab6c7a96 100644
--- a/stat.h
+++ b/stat.h
@@ -251,32 +251,36 @@ struct thread_stat {
 	uint64_t cachemiss;
 } __attribute__((packed));

-struct jobs_eta {
-	uint32_t nr_running;
-	uint32_t nr_ramp;
-
-	uint32_t nr_pending;
-	uint32_t nr_setting_up;
-
-	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];
-	uint64_t rate[DDIR_RWDIR_CNT];
-	uint32_t m_iops[DDIR_RWDIR_CNT], t_iops[DDIR_RWDIR_CNT];
-	uint32_t iops[DDIR_RWDIR_CNT];
-	uint64_t elapsed_sec;
-	uint64_t eta_sec;
-	uint32_t is_pow2;
-	uint32_t unit_base;
-
-	uint32_t sig_figs;
-
-	uint32_t files_open;
+#define JOBS_ETA {							\
+	uint32_t nr_running;						\
+	uint32_t nr_ramp;						\
+									\
+	uint32_t nr_pending;						\
+	uint32_t nr_setting_up;						\
+									\
+	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];	\
+	uint64_t rate[DDIR_RWDIR_CNT];					\
+	uint32_t m_iops[DDIR_RWDIR_CNT] __attribute__((packed));	\
+	uint32_t t_iops[DDIR_RWDIR_CNT] __attribute__((packed));	\
+	uint32_t iops[DDIR_RWDIR_CNT] __attribute__((packed));		\
+	uint64_t elapsed_sec __attribute__((packed));			\
+	uint64_t eta_sec __attribute__((packed));			\
+	uint32_t is_pow2;						\
+	uint32_t unit_base;						\
+									\
+	uint32_t sig_figs;						\
+									\
+	uint32_t files_open;						\
+									\
+	/*								\
+	 * Network 'copy' of run_str[]					\
+	 */								\
+	uint32_t nr_threads;						\
+	uint8_t run_str[];						\
+}

-	/*
-	 * Network 'copy' of run_str[]
-	 */
-	uint32_t nr_threads;
-	uint8_t run_str[];
-} __attribute__((packed));
+struct jobs_eta JOBS_ETA;
+struct jobs_eta_packed JOBS_ETA __attribute__((packed));

 struct io_u_plat_entry {
 	struct flist_head list;

Thanks,

Bart.


