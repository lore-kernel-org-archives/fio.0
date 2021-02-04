Return-Path: <prvs=6625c2be1=niklas.cassel@wdc.com>
From: Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH] options: free dump options list on exit
Date: Thu,  4 Feb 2021 16:19:46 +0100
Message-Id: <20210204151946.87737-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

Fix the following LeakSanitizer warnings:

Indirect leak of 224 byte(s) in 7 object(s) allocated from:
    #0 0x7f7377b21bc8 in malloc (/lib/x86_64-linux-gnu/libasan.so.5+0x10dbc8)
    #1 0x563951e5e09d in add_to_dump_list /home/nks/src/fio/parse.c:1135
    #2 0x563951e5e09d in add_to_dump_list /home/nks/src/fio/parse.c:1127
    #3 0x563951e5e09d in parse_cmd_option /home/nks/src/fio/parse.c:1162

Indirect leak of 43 byte(s) in 7 object(s) allocated from:
    #0 0x7f7377aaa3dd in strdup (/lib/x86_64-linux-gnu/libasan.so.5+0x963dd)
    #1 0x563951e5e0a8 in add_to_dump_list /home/nks/src/fio/parse.c:1136
    #2 0x563951e5e0a8 in add_to_dump_list /home/nks/src/fio/parse.c:1127
    #3 0x563951e5e0a8 in parse_cmd_option /home/nks/src/fio/parse.c:1162

Indirect leak of 36 byte(s) in 7 object(s) allocated from:
    #0 0x7f7377aaa3dd in strdup (/lib/x86_64-linux-gnu/libasan.so.5+0x963dd)
    #1 0x563951e5e0b9 in add_to_dump_list /home/nks/src/fio/parse.c:1138
    #2 0x563951e5e0b9 in add_to_dump_list /home/nks/src/fio/parse.c:1127
    #3 0x563951e5e0b9 in parse_cmd_option /home/nks/src/fio/parse.c:1162

by moving fio_dump_options_free() to options.h,
so that we can call it during exit.

Reproducer:
LD_PRELOAD=libasan.so.5 fio --name=test --filename=/dev/nullb0 --runtime=2

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 backend.c |  1 +
 init.c    | 13 -------------
 options.c | 13 +++++++++++++
 options.h |  1 +
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/backend.c b/backend.c
index f2efddd6..52b4ca7e 100644
--- a/backend.c
+++ b/backend.c
@@ -2537,6 +2537,7 @@ int fio_backend(struct sk_out *sk_out)
 	for_each_td(td, i) {
 		steadystate_free(td);
 		fio_options_free(td);
+		fio_dump_options_free(td);
 		if (td->rusage_sem) {
 			fio_sem_remove(td->rusage_sem);
 			td->rusage_sem = NULL;
diff --git a/init.c b/init.c
index d6dbaf7c..1a3b4cca 100644
--- a/init.c
+++ b/init.c
@@ -448,19 +448,6 @@ static void dump_opt_list(struct thread_data *td)
 	}
 }
 
-static void fio_dump_options_free(struct thread_data *td)
-{
-	while (!flist_empty(&td->opt_list)) {
-		struct print_option *p;
-
-		p = flist_first_entry(&td->opt_list, struct print_option, list);
-		flist_del_init(&p->list);
-		free(p->name);
-		free(p->value);
-		free(p);
-	}
-}
-
 static void copy_opt_list(struct thread_data *dst, struct thread_data *src)
 {
 	struct flist_head *entry;
diff --git a/options.c b/options.c
index e62e0cfb..b33eaee6 100644
--- a/options.c
+++ b/options.c
@@ -5426,6 +5426,19 @@ void fio_options_free(struct thread_data *td)
 	}
 }
 
+void fio_dump_options_free(struct thread_data *td)
+{
+	while (!flist_empty(&td->opt_list)) {
+		struct print_option *p;
+
+		p = flist_first_entry(&td->opt_list, struct print_option, list);
+		flist_del_init(&p->list);
+		free(p->name);
+		free(p->value);
+		free(p);
+	}
+}
+
 struct fio_option *fio_option_find(const char *name)
 {
 	return find_option(fio_options, name);
diff --git a/options.h b/options.h
index 5276f31e..df80fd98 100644
--- a/options.h
+++ b/options.h
@@ -16,6 +16,7 @@ void add_opt_posval(const char *, const char *, const char *);
 void del_opt_posval(const char *, const char *);
 struct thread_data;
 void fio_options_free(struct thread_data *);
+void fio_dump_options_free(struct thread_data *);
 char *get_next_str(char **ptr);
 int get_max_str_idx(char *input);
 char* get_name_by_idx(char *input, int index);
-- 
2.25.1


