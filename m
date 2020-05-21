Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 1/5] verify: decouple seed generation from buffer fill
Date: Fri, 22 May 2020 02:17:12 +0300
Message-Id: <20200521231716.28832-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: adobriyan@gmail.com, damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

It is nicer this way and there will be more code in this area
with ZBD verification.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 backend.c |  6 ------
 verify.c  | 20 +++++++-------------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/backend.c b/backend.c
index f519728c..0075a733 100644
--- a/backend.c
+++ b/backend.c
@@ -1006,12 +1006,6 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		if (td->o.verify != VERIFY_NONE && io_u->ddir == DDIR_READ &&
 		    ((io_u->flags & IO_U_F_VER_LIST) || !td_rw(td))) {
 
-			if (!td->o.verify_pattern_bytes) {
-				io_u->rand_seed = __rand(&td->verify_state);
-				if (sizeof(int) != sizeof(long *))
-					io_u->rand_seed *= __rand(&td->verify_state);
-			}
-
 			if (verify_state_should_stop(td, io_u)) {
 				put_io_u(td, io_u);
 				break;
diff --git a/verify.c b/verify.c
index cf299ebf..b7fa6693 100644
--- a/verify.c
+++ b/verify.c
@@ -46,15 +46,6 @@ static void __fill_buffer(struct thread_options *o, uint64_t seed, void *p,
 	__fill_random_buf_percentage(seed, p, o->compress_percentage, len, len, o->buffer_pattern, o->buffer_pattern_bytes);
 }
 
-static uint64_t fill_buffer(struct thread_data *td, void *p,
-			    unsigned int len)
-{
-	struct frand_state *fs = &td->verify_state;
-	struct thread_options *o = &td->o;
-
-	return fill_random_buf_percentage(fs, p, o->compress_percentage, len, len, o->buffer_pattern, o->buffer_pattern_bytes);
-}
-
 void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 			 struct io_u *io_u, uint64_t seed, int use_seed)
 {
@@ -63,10 +54,13 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 	if (!o->verify_pattern_bytes) {
 		dprint(FD_VERIFY, "fill random bytes len=%u\n", len);
 
-		if (use_seed)
-			__fill_buffer(o, seed, p, len);
-		else
-			io_u->rand_seed = fill_buffer(td, p, len);
+		if (!use_seed) {
+			seed = __rand(&td->verify_state);
+			if (sizeof(int) != sizeof(long *))
+				seed *= (unsigned long)__rand(&td->verify_state);
+		}
+		io_u->rand_seed = seed;
+		__fill_buffer(o, seed, p, len);
 		return;
 	}
 
-- 
2.26.2


