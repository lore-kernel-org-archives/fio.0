Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 7/8] verify: don't use void* for pointer arithmetic (gcc)
Date: Sat, 24 Jun 2017 01:08:00 +0300
Message-Id: <20170623220801.38178-8-tkusumi@tuxera.com>
In-Reply-To: <20170623220801.38178-1-tkusumi@tuxera.com>
References: <20170623220801.38178-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think gcc extension should be avoided when it can be done by
just changing a pointer type.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 t/verify-state.c | 3 ++-
 verify-state.h   | 2 +-
 verify.c         | 7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/t/verify-state.c b/t/verify-state.c
index 9a2c3df..78a56da 100644
--- a/t/verify-state.c
+++ b/t/verify-state.c
@@ -58,7 +58,8 @@ static void show(struct thread_io_list *s, size_t size)
 		show_s(s, no_s);
 		no_s++;
 		size -= __thread_io_list_sz(s->depth, s->nofiles);
-		s = (void *) s + __thread_io_list_sz(s->depth, s->nofiles);
+		s = (struct thread_io_list *)((char *) s +
+			__thread_io_list_sz(s->depth, s->nofiles));
 	} while (size != 0);
 }
 
diff --git a/verify-state.h b/verify-state.h
index e46265e..1586f63 100644
--- a/verify-state.h
+++ b/verify-state.h
@@ -77,7 +77,7 @@ static inline size_t thread_io_list_sz(struct thread_io_list *s)
 
 static inline struct thread_io_list *io_list_next(struct thread_io_list *s)
 {
-	return (void *) s + thread_io_list_sz(s);
+	return (struct thread_io_list *)((char *) s + thread_io_list_sz(s));
 }
 
 static inline void verify_state_gen_name(char *out, size_t size,
diff --git a/verify.c b/verify.c
index ffd8707..1f177d7 100644
--- a/verify.c
+++ b/verify.c
@@ -388,7 +388,7 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 	(void)paste_format_inplace(pattern, pattern_size,
 				   td->o.verify_fmt, td->o.verify_fmt_sz, io_u);
 
-	buf = (void *) hdr + header_size;
+	buf = (char *) hdr + header_size;
 	len = get_hdr_inc(td, io_u) - header_size;
 	mod = (get_hdr_inc(td, io_u) * vc->hdr_num + header_size) % pattern_size;
 
@@ -1188,9 +1188,10 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 			 unsigned int header_len)
 {
 	unsigned int data_len;
-	void *data, *p;
+	void *data;
+	char *p;
 
-	p = (void *) hdr;
+	p = (char *) hdr;
 
 	fill_hdr(td, io_u, hdr, header_num, header_len, io_u->rand_seed);
 
-- 
2.9.4


