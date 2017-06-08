Return-Path: <sbates130272@gmail.com>
Return-Path: <sbates130272@gmail.com>
From: sbates@raithlin.com
Subject: [PATCH] pattern.c: Add support for files in buffer_pattern argument.
Date: Thu,  8 Jun 2017 05:46:46 -0600
Message-Id: <1496922406-10355-1-git-send-email-sbates@raithlin.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: sagi@grimberg.me, logang@deltatee.com, muli@lightbitslabs.com, Stephen Bates <sbates@raithlin.com>
List-ID: <fio@vger.kernel.org>

From: Stephen Bates <sbates@raithlin.com>

It is useful to be able to initialize the buffer contents using an
input file (e.g. when testing certain pathological patterns for
compression). Add support to the buffer_pattern input argument for
reading data from a file via enclosing the filename in ``''``.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-By: Muli Ben-Yehuda <muli@lightbitslabs.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 HOWTO         | 19 +++++++++++------
 lib/pattern.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/HOWTO b/HOWTO
index ea9466a..7959ad1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1401,11 +1401,18 @@ Buffers and memory
 
 .. option:: buffer_pattern=str
 
-	If set, fio will fill the I/O buffers with this pattern. If not set, the
-	contents of I/O buffers is defined by the other options related to buffer
-	contents. The setting can be any pattern of bytes, and can be prefixed with
-	0x for hex values. It may also be a string, where the string must then be
-	wrapped with ``""``, e.g.::
+	If set, fio will fill the I/O buffers with this pattern or with the contents
+	of a file. If not set, the contents of I/O buffers are defined by the other
+	options related to buffer contents. The setting can be any pattern of bytes,
+	and can be prefixed with 0x for hex values. It may also be a string, where
+	the string must then be wrapped with ``""``. Or it may also be a filename,
+	where the filename must be wrapped with ``''`` in which case the file is
+	opened and read. Note that not all the file contents will be read if that
+	would cause the buffers to overflow. So, for example::
+
+		buffer_pattern='filename'
+
+	or::
 
 		buffer_pattern="abcd"
 
@@ -1419,7 +1426,7 @@ Buffers and memory
 
 	Also you can combine everything together in any order::
 
-		buffer_pattern=0xdeadface"abcd"-12
+		buffer_pattern=0xdeadface"abcd"-12'filename'
 
 .. option:: dedupe_percentage=int
 
diff --git a/lib/pattern.c b/lib/pattern.c
index 0aeb935..420d74a 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -4,6 +4,10 @@
 #include <limits.h>
 #include <errno.h>
 #include <assert.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
 
 #include "strntol.h"
 #include "pattern.h"
@@ -11,6 +15,64 @@
 #include "../oslib/strcasestr.h"
 
 /**
+ * parse_file() - parses binary file to fill buffer
+ * @beg - string input, extract filename from this
+ * @out - output buffer where parsed number should be put
+ * @out_len - length of the output buffer
+ * @filled - pointer where number of bytes successfully
+ *           parsed will be put
+ *
+ * Returns the end pointer where parsing has been stopped.
+ * In case of parsing error or lack of bytes in output buffer
+ * NULL will be returned.
+ */
+static const char *parse_file(const char *beg, char *out,
+			      unsigned int out_len,
+			      unsigned int *filled)
+{
+	const char *end;
+	char *file;
+	int fd;
+	ssize_t count;
+
+	if (!out_len)
+		goto err_out;
+
+	assert(*beg == '\'');
+	beg++;
+	end = strchr(beg, '\'');
+	if (!end)
+		goto err_out;
+
+	file = strndup(beg, end - beg);
+	if (file == NULL)
+		goto err_out;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		goto err_free_out;
+
+	count = read(fd, out, out_len);
+	if (count == -1)
+		goto err_free_close_out;
+
+	*filled = count;
+	close(fd);
+	free(file);
+
+	/* Catch up quote */
+	return end + 1;
+
+err_free_close_out:
+	close(fd);
+err_free_out:
+	free(file);
+err_out:
+	return NULL;
+
+}
+
+/**
  * parse_string() - parses string in double quotes, like "abc"
  * @beg - string input
  * @out - output buffer where parsed number should be put
@@ -271,6 +333,9 @@ int parse_and_fill_pattern(const char *in, unsigned int in_len,
 		parsed_fmt = 0;
 
 		switch (*beg) {
+		case '\'':
+			end = parse_file(beg, out, out_len, &filled);
+			break;
 		case '"':
 			end = parse_string(beg, out, out_len, &filled);
 			break;
-- 
2.7.4


