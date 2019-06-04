Return-Path: <prvs=051d3e551=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/2] Fix string copy compilation warnings
Date: Tue,  4 Jun 2019 16:07:31 +0900
Message-Id: <20190604070732.17952-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Fix the many warnings that gcc 9 spits out.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 exp/expression-parser.y | 6 +++---
 filesetup.c             | 3 ++-
 init.c                  | 5 +++--
 server.c                | 9 ++++++---
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/exp/expression-parser.y b/exp/expression-parser.y
index 04a6e07a..8619025c 100644
--- a/exp/expression-parser.y
+++ b/exp/expression-parser.y
@@ -204,9 +204,9 @@ static void setup_to_parse_string(const char *string)
 {
 	unsigned int len;
 
-	len = strlen(string);
-	if (len > sizeof(lexer_input_buffer) - 3)
-		len = sizeof(lexer_input_buffer) - 3;
+	len = sizeof(lexer_input_buffer) - 3;
+	if (len > strlen(string))
+		len = strlen(string);
 
 	strncpy(lexer_input_buffer, string, len);
 	lexer_input_buffer[len] = '\0'; 
diff --git a/filesetup.c b/filesetup.c
index 24e6fb07..17fa31fb 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -829,7 +829,8 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 			continue;
 
 		fm = calloc(1, sizeof(*fm));
-		strncpy(fm->__base, buf, sizeof(fm->__base) - 1);
+		strncpy(fm->__base, buf, sizeof(fm->__base));
+		fm->__base[255] = '\0'; 
 		fm->base = basename(fm->__base);
 		fm->key = sb.st_dev;
 		flist_add(&fm->list, &list);
diff --git a/init.c b/init.c
index 73834279..f2ba1e20 100644
--- a/init.c
+++ b/init.c
@@ -1438,7 +1438,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		   int recursed, int client_type)
 {
 	unsigned int i;
-	char fname[PATH_MAX];
+	char fname[PATH_MAX + 1];
 	int numjobs, file_alloced;
 	struct thread_options *o = &td->o;
 	char logname[PATH_MAX + 32];
@@ -2040,7 +2040,8 @@ static int __parse_jobs_ini(struct thread_data *td,
 					strncpy(full_fn,
 						file, (ts - file) + 1);
 					strncpy(full_fn + (ts - file) + 1,
-						filename, strlen(filename));
+						filename,
+						len - (ts - file) - 1);
 					full_fn[len - 1] = 0;
 					filename = full_fn;
 				}
diff --git a/server.c b/server.c
index 2a337707..23e549a5 100644
--- a/server.c
+++ b/server.c
@@ -1470,9 +1470,12 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 	memset(&p, 0, sizeof(p));
 
-	strncpy(p.ts.name, ts->name, FIO_JOBNAME_SIZE - 1);
-	strncpy(p.ts.verror, ts->verror, FIO_VERROR_SIZE - 1);
-	strncpy(p.ts.description, ts->description, FIO_JOBDESC_SIZE - 1);
+	strncpy(p.ts.name, ts->name, FIO_JOBNAME_SIZE);
+	p.ts.name[FIO_JOBNAME_SIZE - 1] = '\0';
+	strncpy(p.ts.verror, ts->verror, FIO_VERROR_SIZE);
+	p.ts.verror[FIO_VERROR_SIZE - 1] = '\0';
+	strncpy(p.ts.description, ts->description, FIO_JOBDESC_SIZE);
+	p.ts.description[FIO_JOBDESC_SIZE - 1] = '\0';
 
 	p.ts.error		= cpu_to_le32(ts->error);
 	p.ts.thread_number	= cpu_to_le32(ts->thread_number);
-- 
2.21.0


