Return-Path: <prvs=81407a9e8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 05/11] options: make parsing functions available to ioengines
Date: Tue,  6 Jul 2021 09:17:37 +0900
Message-Id: <20210706001743.10818-6-damien.lemoal@wdc.com>
In-Reply-To: <20210706001743.10818-1-damien.lemoal@wdc.com>
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Move the declaration of split_parse_ddir(), str_split_parse() and
of the split_parse_fn typedef to thread_options.h so that
IO engines can use these functions to parse options. The definition of
struct split is also moved to thread_options.h from options.c.

The type of the split_parse_fn callback function is changed to add a
void * argument that can be used for an option parsing callback to pass
a private data pointer to the split_parse_fn function. This can be used
by an IO engine to pass a pointer to its engine specific option
structure as td->eo is not yet set when options are being parsed.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 options.c        | 40 ++++++++++++++++------------------------
 thread_options.h | 16 ++++++++++++++++
 2 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/options.c b/options.c
index a8986d11..50e48815 100644
--- a/options.c
+++ b/options.c
@@ -73,13 +73,7 @@ static int bs_cmp(const void *p1, const void *p2)
 	return (int) bsp1->perc - (int) bsp2->perc;
 }
 
-struct split {
-	unsigned int nr;
-	unsigned long long val1[ZONESPLIT_MAX];
-	unsigned long long val2[ZONESPLIT_MAX];
-};
-
-static int split_parse_ddir(struct thread_options *o, struct split *split,
+int split_parse_ddir(struct thread_options *o, struct split *split,
 			    char *str, bool absolute, unsigned int max_splits)
 {
 	unsigned long long perc;
@@ -138,8 +132,8 @@ static int split_parse_ddir(struct thread_options *o, struct split *split,
 	return 0;
 }
 
-static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str,
-			bool data)
+static int bssplit_ddir(struct thread_options *o, void *eo,
+			enum fio_ddir ddir, char *str, bool data)
 {
 	unsigned int i, perc, perc_missing;
 	unsigned long long max_bs, min_bs;
@@ -211,10 +205,8 @@ static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char *str,
 	return 0;
 }
 
-typedef int (split_parse_fn)(struct thread_options *, enum fio_ddir, char *, bool);
-
-static int str_split_parse(struct thread_data *td, char *str,
-			   split_parse_fn *fn, bool data)
+int str_split_parse(struct thread_data *td, char *str,
+		    split_parse_fn *fn, void *eo, bool data)
 {
 	char *odir, *ddir;
 	int ret = 0;
@@ -223,37 +215,37 @@ static int str_split_parse(struct thread_data *td, char *str,
 	if (odir) {
 		ddir = strchr(odir + 1, ',');
 		if (ddir) {
-			ret = fn(&td->o, DDIR_TRIM, ddir + 1, data);
+			ret = fn(&td->o, eo, DDIR_TRIM, ddir + 1, data);
 			if (!ret)
 				*ddir = '\0';
 		} else {
 			char *op;
 
 			op = strdup(odir + 1);
-			ret = fn(&td->o, DDIR_TRIM, op, data);
+			ret = fn(&td->o, eo, DDIR_TRIM, op, data);
 
 			free(op);
 		}
 		if (!ret)
-			ret = fn(&td->o, DDIR_WRITE, odir + 1, data);
+			ret = fn(&td->o, eo, DDIR_WRITE, odir + 1, data);
 		if (!ret) {
 			*odir = '\0';
-			ret = fn(&td->o, DDIR_READ, str, data);
+			ret = fn(&td->o, eo, DDIR_READ, str, data);
 		}
 	} else {
 		char *op;
 
 		op = strdup(str);
-		ret = fn(&td->o, DDIR_WRITE, op, data);
+		ret = fn(&td->o, eo, DDIR_WRITE, op, data);
 		free(op);
 
 		if (!ret) {
 			op = strdup(str);
-			ret = fn(&td->o, DDIR_TRIM, op, data);
+			ret = fn(&td->o, eo, DDIR_TRIM, op, data);
 			free(op);
 		}
 		if (!ret)
-			ret = fn(&td->o, DDIR_READ, str, data);
+			ret = fn(&td->o, eo, DDIR_READ, str, data);
 	}
 
 	return ret;
@@ -270,7 +262,7 @@ static int str_bssplit_cb(void *data, const char *input)
 	strip_blank_front(&str);
 	strip_blank_end(str);
 
-	ret = str_split_parse(td, str, bssplit_ddir, false);
+	ret = str_split_parse(td, str, bssplit_ddir, NULL, false);
 
 	if (parse_dryrun()) {
 		int i;
@@ -906,8 +898,8 @@ static int str_sfr_cb(void *data, const char *str)
 }
 #endif
 
-static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
-			   char *str, bool absolute)
+static int zone_split_ddir(struct thread_options *o, void *eo,
+			   enum fio_ddir ddir, char *str, bool absolute)
 {
 	unsigned int i, perc, perc_missing, sperc, sperc_missing;
 	struct split split;
@@ -1012,7 +1004,7 @@ static int parse_zoned_distribution(struct thread_data *td, const char *input,
 	}
 	str += strlen(pre);
 
-	ret = str_split_parse(td, str, zone_split_ddir, absolute);
+	ret = str_split_parse(td, str, zone_split_ddir, NULL, absolute);
 
 	free(p);
 
diff --git a/thread_options.h b/thread_options.h
index 05c2d138..23c4f28c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -9,6 +9,7 @@
 #include "lib/ieee754.h"
 #include "lib/pattern.h"
 #include "td_error.h"
+#include "flist.h"
 
 enum fio_zone_mode {
 	ZONE_MODE_NOT_SPECIFIED	= 0,
@@ -36,6 +37,12 @@ enum fio_memtype {
 #define BSSPLIT_MAX	64
 #define ZONESPLIT_MAX	256
 
+struct split {
+	unsigned int nr;
+	unsigned long long val1[ZONESPLIT_MAX];
+	unsigned long long val2[ZONESPLIT_MAX];
+};
+
 struct bssplit {
 	uint64_t bs;
 	uint32_t perc;
@@ -666,4 +673,13 @@ extern void convert_thread_options_to_net(struct thread_options_pack *top, struc
 extern int fio_test_cconv(struct thread_options *);
 extern void options_default_fill(struct thread_options *o);
 
+typedef int (split_parse_fn)(struct thread_options *, void *,
+			     enum fio_ddir, char *, bool);
+
+extern int str_split_parse(struct thread_data *td, char *str,
+			   split_parse_fn *fn, void *eo, bool data);
+
+extern int split_parse_ddir(struct thread_options *o, struct split *split,
+			    char *str, bool absolute, unsigned int max_splits);
+
 #endif
-- 
2.31.1


