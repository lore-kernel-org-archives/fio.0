Return-Path: <dennisszhou@gmail.com>
Return-Path: <dennisszhou@gmail.com>
From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 1/4] options: rename name string operations for more general use
Date: Thu, 20 Sep 2018 14:08:07 -0400
Message-Id: <20180920180810.70608-2-dennis@kernel.org>
In-Reply-To: <20180920180810.70608-1-dennis@kernel.org>
References: <20180920180810.70608-1-dennis@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com, Dennis Zhou <dennis@kernel.org>
List-ID: <fio@vger.kernel.org>

get_next_name() and get_max_str_idx() are helpers that iterate and split
a string separated by ':'. s/name/str/g to make this more generic which
will be used to parse file paths for blktraces to merge.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 options.c | 18 +++++++++---------
 options.h |  2 ++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/options.c b/options.c
index 6bd74555..824abee0 100644
--- a/options.c
+++ b/options.c
@@ -1155,7 +1155,7 @@ static int str_steadystate_cb(void *data, const char *str)
  * is escaped with a '\', then that ':' is part of the filename and does not
  * indicate a new file.
  */
-static char *get_next_name(char **ptr)
+char *get_next_str(char **ptr)
 {
 	char *str = *ptr;
 	char *p, *start;
@@ -1197,14 +1197,14 @@ static char *get_next_name(char **ptr)
 }
 
 
-static int get_max_name_idx(char *input)
+int get_max_str_idx(char *input)
 {
 	unsigned int cur_idx;
 	char *str, *p;
 
 	p = str = strdup(input);
 	for (cur_idx = 0; ; cur_idx++)
-		if (get_next_name(&str) == NULL)
+		if (get_next_str(&str) == NULL)
 			break;
 
 	free(p);
@@ -1224,9 +1224,9 @@ int set_name_idx(char *target, size_t tlen, char *input, int index,
 
 	p = str = strdup(input);
 
-	index %= get_max_name_idx(input);
+	index %= get_max_str_idx(input);
 	for (cur_idx = 0; cur_idx <= index; cur_idx++)
-		fname = get_next_name(&str);
+		fname = get_next_str(&str);
 
 	if (client_sockaddr_str[0] && unique_filename) {
 		len = snprintf(target, tlen, "%s/%s.", fname,
@@ -1247,9 +1247,9 @@ char* get_name_by_idx(char *input, int index)
 
 	p = str = strdup(input);
 
-	index %= get_max_name_idx(input);
+	index %= get_max_str_idx(input);
 	for (cur_idx = 0; cur_idx <= index; cur_idx++)
-		fname = get_next_name(&str);
+		fname = get_next_str(&str);
 
 	fname = strdup(fname);
 	free(p);
@@ -1273,7 +1273,7 @@ static int str_filename_cb(void *data, const char *input)
 	if (!td->files_index)
 		td->o.nr_files = 0;
 
-	while ((fname = get_next_name(&str)) != NULL) {
+	while ((fname = get_next_str(&str)) != NULL) {
 		if (!strlen(fname))
 			break;
 		add_file(td, fname, 0, 1);
@@ -1294,7 +1294,7 @@ static int str_directory_cb(void *data, const char fio_unused *unused)
 		return 0;
 
 	p = str = strdup(td->o.directory);
-	while ((dirname = get_next_name(&str)) != NULL) {
+	while ((dirname = get_next_str(&str)) != NULL) {
 		if (lstat(dirname, &sb) < 0) {
 			ret = errno;
 
diff --git a/options.h b/options.h
index 8fdd1363..5276f31e 100644
--- a/options.h
+++ b/options.h
@@ -16,6 +16,8 @@ void add_opt_posval(const char *, const char *, const char *);
 void del_opt_posval(const char *, const char *);
 struct thread_data;
 void fio_options_free(struct thread_data *);
+char *get_next_str(char **ptr);
+int get_max_str_idx(char *input);
 char* get_name_by_idx(char *input, int index);
 int set_name_idx(char *, size_t, char *, int, bool);
 
-- 
2.17.1


