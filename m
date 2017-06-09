Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35858 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdFIMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Jun 2017 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dJIaE-0006Am-QE
        for fio@vger.kernel.org; Fri, 09 Jun 2017 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170609120002.3C6B22C14E3@kernel.dk>
Date: Fri,  9 Jun 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a35ef7cb514d02671bdcb029a64785bbc288fe96:

  HOWTO: mention some details of ignore_error= option (2017-06-07 14:23:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 85c705e55c2bbeb3c74d96ef4ec1ae90203c4083:

  man: Update buffer_pattern entry in man pages (2017-06-08 12:12:36 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Add strndup() function, if we don't have it
      configure: remember to initialize 'strndup' to "no"
      oslib/strndup: cleanup and remember to include for aux programs

Stephen Bates (2):
      pattern: Add support for files in buffer_pattern argument.
      man: Update buffer_pattern entry in man pages

 HOWTO           | 19 +++++++++++------
 Makefile        |  8 +++++--
 configure       | 22 +++++++++++++++++++
 fio.1           | 19 +++++++++++------
 lib/pattern.c   | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 oslib/strndup.c | 18 ++++++++++++++++
 oslib/strndup.h |  7 ++++++
 7 files changed, 145 insertions(+), 14 deletions(-)
 create mode 100644 oslib/strndup.c
 create mode 100644 oslib/strndup.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 289c518..d3a5783 100644
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
 
diff --git a/Makefile b/Makefile
index c3e551d..d7786d2 100644
--- a/Makefile
+++ b/Makefile
@@ -107,6 +107,9 @@ endif
 ifndef CONFIG_STRLCAT
   SOURCE += oslib/strlcat.c
 endif
+ifndef CONFIG_HAVE_STRNDUP
+  SOURCE += oslib/strndup.c
+endif
 ifndef CONFIG_GETOPT_LONG_ONLY
   SOURCE += oslib/getopt_long.c
 endif
@@ -209,7 +212,8 @@ T_IEEE_PROGS = t/ieee754
 
 T_ZIPF_OBS = t/genzipf.o
 T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/pattern.o lib/zipf.o \
-		lib/strntol.o lib/gauss.o t/genzipf.o oslib/strcasestr.o
+		lib/strntol.o lib/gauss.o t/genzipf.o oslib/strcasestr.o \
+		oslib/strndup.o
 T_ZIPF_PROGS = t/fio-genzipf
 
 T_AXMAP_OBJS = t/axmap.o
@@ -222,7 +226,7 @@ T_LFSR_TEST_PROGS = t/lfsr-test
 
 T_GEN_RAND_OBJS = t/gen-rand.o
 T_GEN_RAND_OBJS += t/log.o t/debug.o lib/rand.o lib/pattern.o lib/strntol.o \
-			oslib/strcasestr.o
+			oslib/strcasestr.o oslib/strndup.o
 T_GEN_RAND_PROGS = t/gen-rand
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
diff --git a/configure b/configure
index 2c6bfc8..afb88ca 100755
--- a/configure
+++ b/configure
@@ -1971,6 +1971,25 @@ fi
 print_config "bool" "$have_bool"
 
 ##########################################
+# Check whether we have strndup()
+strndup="no"
+cat > $TMPC << EOF
+#include <string.h>
+#include <stdlib.h>
+int main(int argc, char **argv)
+{
+  char *res = strndup("test string", 8);
+
+  free(res);
+  return 0;
+}
+EOF
+if compile_prog "" "" "strndup"; then
+  strndup="yes"
+fi
+print_config "strndup" "$strndup"
+
+##########################################
 # check march=armv8-a+crc+crypto
 if test "$march_armv8_a_crc_crypto" != "yes" ; then
   march_armv8_a_crc_crypto="no"
@@ -2227,6 +2246,9 @@ fi
 if test "$have_bool" = "yes" ; then
   output_sym "CONFIG_HAVE_BOOL"
 fi
+if test "$strndup" = "yes" ; then
+  output_sym "CONFIG_HAVE_STRNDUP"
+fi
 if test "$disable_opt" = "yes" ; then
   output_sym "CONFIG_DISABLE_OPTIMIZATIONS"
 fi
diff --git a/fio.1 b/fio.1
index e153d46..96eceaf 100644
--- a/fio.1
+++ b/fio.1
@@ -611,13 +611,20 @@ the remaining zeroed. With this set to some chunk size smaller than the block
 size, fio can alternate random and zeroed data throughout the IO buffer.
 .TP
 .BI buffer_pattern \fR=\fPstr
-If set, fio will fill the IO buffers with this pattern. If not set, the contents
-of IO buffers is defined by the other options related to buffer contents. The
-setting can be any pattern of bytes, and can be prefixed with 0x for hex
-values. It may also be a string, where the string must then be wrapped with
-"", e.g.:
+If set, fio will fill the I/O buffers with this pattern or with the contents
+of a file. If not set, the contents of I/O buffers are defined by the other
+options related to buffer contents. The setting can be any pattern of bytes,
+and can be prefixed with 0x for hex values. It may also be a string, where
+the string must then be wrapped with ``""``. Or it may also be a filename,
+where the filename must be wrapped with ``''`` in which case the file is
+opened and read. Note that not all the file contents will be read if that
+would cause the buffers to overflow. So, for example:
 .RS
 .RS
+\fBbuffer_pattern\fR='filename'
+.RS
+or
+.RE
 \fBbuffer_pattern\fR="abcd"
 .RS
 or
@@ -632,7 +639,7 @@ or
 Also you can combine everything together in any order:
 .LP
 .RS
-\fBbuffer_pattern\fR=0xdeadface"abcd"-12
+\fBbuffer_pattern\fR=0xdeadface"abcd"-12'filename'
 .RE
 .RE
 .TP
diff --git a/lib/pattern.c b/lib/pattern.c
index 0aeb935..31ee4ea 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -4,11 +4,74 @@
 #include <limits.h>
 #include <errno.h>
 #include <assert.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
 
 #include "strntol.h"
 #include "pattern.h"
 #include "../minmax.h"
 #include "../oslib/strcasestr.h"
+#include "../oslib/strndup.h"
+
+/**
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
 
 /**
  * parse_string() - parses string in double quotes, like "abc"
@@ -271,6 +334,9 @@ int parse_and_fill_pattern(const char *in, unsigned int in_len,
 		parsed_fmt = 0;
 
 		switch (*beg) {
+		case '\'':
+			end = parse_file(beg, out, out_len, &filled);
+			break;
 		case '"':
 			end = parse_string(beg, out, out_len, &filled);
 			break;
diff --git a/oslib/strndup.c b/oslib/strndup.c
new file mode 100644
index 0000000..7b0fcb5
--- /dev/null
+++ b/oslib/strndup.c
@@ -0,0 +1,18 @@
+#include <stdlib.h>
+#include "strndup.h"
+
+#ifndef CONFIG_HAVE_STRNDUP
+
+char *strndup(const char *s, size_t n)
+{
+	char *str = malloc(n + 1);
+
+	if (str) {
+		strncpy(str, s, n);
+		str[n] = '\0';
+	}
+
+	return str;
+}
+
+#endif
diff --git a/oslib/strndup.h b/oslib/strndup.h
new file mode 100644
index 0000000..2cb904d
--- /dev/null
+++ b/oslib/strndup.h
@@ -0,0 +1,7 @@
+#include <string.h>
+
+#ifndef CONFIG_HAVE_STRNDUP
+
+char *strndup(const char *s, size_t n);
+
+#endif
