Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44539 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaBHNAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 8 Feb 2014 08:00:08 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WC7Vv-0003lD-Er
	for fio@vger.kernel.org; Sat, 08 Feb 2014 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140208130003.7FA0B41E3B@strynoevaenget.dk>
Date: Sat,  8 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f940128526dbe468a1951cce10c2fe5dbd23875f:

  verify: always log IO in the order they are issued (2014-02-06 12:17:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 782744ef60b7ed47a529d30b9f8e0c528c436fdb:

  crc: add option to list possible crc types (2014-02-07 20:54:39 -0700)

----------------------------------------------------------------
Jens Axboe (6):
      Fix crash with file locking and dup'ed files
      Prioritize lockfile= option
      Add support for testing checksumming speed
      README: update for crctest
      crc: ensure we properly match test name
      crc: add option to list possible crc types

 README      |    1 +
 crc/test.c  |  348 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 filesetup.c |    5 +
 fio.1       |    8 ++
 init.c      |   12 +++
 options.c   |    1 +
 6 files changed, 375 insertions(+)
 create mode 100644 crc/test.c

---

Diff of recent changes:

diff --git a/README b/README
index 4da0d24..f8aaef2 100644
--- a/README
+++ b/README
@@ -142,6 +142,7 @@ $ fio
 	--version		Print version info and exit
 	--help			Print this page
 	--cpuclock-test		Perform test/validation of CPU clock
+	--crctest[=test]	Test speed of checksum functions
 	--cmdhelp=cmd		Print command help, "all" for all of them
 	--enghelp=engine	Print ioengine help, or list available ioengines
 	--enghelp=engine,cmd	Print help for an ioengine cmd
diff --git a/crc/test.c b/crc/test.c
new file mode 100644
index 0000000..2f6d9ee
--- /dev/null
+++ b/crc/test.c
@@ -0,0 +1,348 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "../fio.h"
+#include "../gettime.h"
+#include "../time.h"
+#include "../verify.h"
+
+#include "../crc/md5.h"
+#include "../crc/crc64.h"
+#include "../crc/crc32.h"
+#include "../crc/crc32c.h"
+#include "../crc/crc16.h"
+#include "../crc/crc7.h"
+#include "../crc/sha1.h"
+#include "../crc/sha256.h"
+#include "../crc/sha512.h"
+
+#define CHUNK		131072U
+#define NR_CHUNKS	  2048U
+
+struct test_type {
+	const char *name;
+	unsigned int mask;
+	uint64_t (*fn)(void);
+};
+
+enum {
+	T_MD5		= 1U << 0,
+	T_CRC64		= 1U << 1,
+	T_CRC32		= 1U << 2,
+	T_CRC32C	= 1U << 3,
+	T_CRC16		= 1U << 4,
+	T_CRC7		= 1U << 5,
+	T_SHA1		= 1U << 6,
+	T_SHA256	= 1U << 7,
+	T_SHA512	= 1U << 8,
+};
+
+static void randomize_buf(void *buf, unsigned int size, int seed)
+{
+	struct frand_state state;
+
+	init_rand_seed(&state, seed);
+	fill_random_buf(&state, buf, size);
+}
+
+static uint64_t t_md5(void)
+{
+	uint32_t digest[4];
+	struct fio_md5_ctx ctx = { .hash = digest };
+	struct timeval s;
+	uint64_t ret;
+	void *buf;
+	int i;
+
+	fio_md5_init(&ctx);
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
+	fio_gettime(&s, NULL);
+	for (i = 0; i < NR_CHUNKS; i++)
+		fio_md5_update(&ctx, buf, CHUNK);
+
+	ret = utime_since_now(&s);
+	free(buf);
+	return ret;
+}
+
+static uint64_t t_crc64(void)
+{
+	struct timeval s;
+	uint64_t ret;
+	void *buf;
+	int i;
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
+	fio_gettime(&s, NULL);
+	for (i = 0; i < NR_CHUNKS; i++)
+		fio_crc64(buf, CHUNK);
+
+	ret = utime_since_now(&s);
+	free(buf);
+	return ret;
+}
+
+static uint64_t t_crc32(void)
+{
+	struct timeval s;
+	uint64_t ret;
+	void *buf;
+	int i;
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
+	fio_gettime(&s, NULL);
+	for (i = 0; i < NR_CHUNKS; i++)
+		fio_crc32(buf, CHUNK);
+
+	ret = utime_since_now(&s);
+	free(buf);
+	return ret;
+}
+
+static uint64_t t_crc32c(void)
+{
+	struct timeval s;
+	uint64_t ret;
+	void *buf;
+	int i;
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
+	fio_gettime(&s, NULL);
+	for (i = 0; i < NR_CHUNKS; i++)
+		fio_crc32c(buf, CHUNK);
+
+	ret = utime_since_now(&s);
+	free(buf);
+	return ret;
+}
+
+static uint64_t t_crc16(void)
+{
+	struct timeval s;
+	uint64_t ret;
+	void *buf;
+	int i;
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
+	fio_gettime(&s, NULL);
+	for (i = 0; i < NR_CHUNKS; i++)
+		fio_crc16(buf, CHUNK);
+
+	ret = utime_since_now(&s);
+	free(buf);
+	return ret;
+}
+
+static uint64_t t_crc7(void)
+{
+	struct timeval s;
+	uint64_t ret;
+	void *buf;
+	int i;
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
+	fio_gettime(&s, NULL);
+	for (i = 0; i < NR_CHUNKS; i++)
+		fio_crc7(buf, CHUNK);
+
+	ret = utime_since_now(&s);
+	free(buf);
+	return ret;
+}
+
+static uint64_t t_sha1(void)
+{
+	uint32_t sha[5];
+	struct fio_sha1_ctx ctx = { .H = sha };
+	struct timeval s;
+	uint64_t ret;
+	void *buf;
+	int i;
+
+	fio_sha1_init(&ctx);
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
+	fio_gettime(&s, NULL);
+	for (i = 0; i < NR_CHUNKS; i++)
+		fio_sha1_update(&ctx, buf, CHUNK);
+
+	ret = utime_since_now(&s);
+	free(buf);
+	return ret;
+}
+
+static uint64_t t_sha256(void)
+{
+	uint8_t sha[64];
+	struct fio_sha256_ctx ctx = { .buf = sha };
+	struct timeval s;
+	uint64_t ret;
+	void *buf;
+	int i;
+
+	fio_sha256_init(&ctx);
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
+	fio_gettime(&s, NULL);
+	for (i = 0; i < NR_CHUNKS; i++)
+		fio_sha256_update(&ctx, buf, CHUNK);
+
+	ret = utime_since_now(&s);
+	free(buf);
+	return ret;
+}
+
+static uint64_t t_sha512(void)
+{
+	uint8_t sha[128];
+	struct fio_sha512_ctx ctx = { .buf = sha };
+	struct timeval s;
+	uint64_t ret;
+	void *buf;
+	int i;
+
+	fio_sha512_init(&ctx);
+
+	buf = malloc(CHUNK);
+	randomize_buf(buf, CHUNK, 0x8989);
+
+	fio_gettime(&s, NULL);
+	for (i = 0; i < NR_CHUNKS; i++)
+		fio_sha512_update(&ctx, buf, CHUNK);
+
+	ret = utime_since_now(&s);
+	free(buf);
+	return ret;
+}
+
+static struct test_type t[] = {
+	{
+		.name = "md5",
+		.mask = T_MD5,
+		.fn = t_md5,
+	},
+	{
+		.name = "crc64",
+		.mask = T_CRC64,
+		.fn = t_crc64,
+	},
+	{
+		.name = "crc32",
+		.mask = T_CRC32,
+		.fn = t_crc32,
+	},
+	{
+		.name = "crc32c",
+		.mask = T_CRC32C,
+		.fn = t_crc32c,
+	},
+	{
+		.name = "crc16",
+		.mask = T_CRC16,
+		.fn = t_crc16,
+	},
+	{
+		.name = "crc7",
+		.mask = T_CRC7,
+		.fn = t_crc7,
+	},
+	{
+		.name = "sha1",
+		.mask = T_SHA1,
+		.fn = t_sha1,
+	},
+	{
+		.name = "sha256",
+		.mask = T_SHA256,
+		.fn = t_sha256,
+	},
+	{
+		.name = "sha512",
+		.mask = T_SHA512,
+		.fn = t_sha512,
+	},
+	{
+		.name = NULL,
+	},
+};
+
+static unsigned int get_test_mask(const char *type)
+{
+	char *ostr, *str = strdup(type);
+	unsigned int mask;
+	char *name;
+	int i;
+
+	ostr = str;
+	mask = 0;
+	while ((name = strsep(&str, ",")) != NULL) {
+		for (i = 0; t[i].name; i++) {
+			if (!strcmp(t[i].name, name)) {
+				mask |= t[i].mask;
+				break;
+			}
+		}
+	}
+
+	free(ostr);
+	return mask;
+}
+
+static int list_types(void)
+{
+	int i;
+
+	for (i = 0; t[i].name; i++)
+		printf("%s\n", t[i].name);
+
+	return 0;
+}
+
+int fio_crctest(const char *type)
+{
+	unsigned int test_mask = 0;
+	uint64_t mb = CHUNK * NR_CHUNKS;
+	int i;
+
+	crc32c_intel_probe();
+
+	if (!type)
+		test_mask = ~0U;
+	else if (!strcmp(type, "help") || !strcmp(type, "list"))
+		return list_types();
+	else
+		test_mask = get_test_mask(type);
+
+	for (i = 0; t[i].name; i++) {
+		double mb_sec;
+		uint64_t usec;
+
+		if (!(t[i].mask & test_mask))
+			continue;
+
+		usec = t[i].fn();
+		mb_sec = (double) mb / (double) usec;
+		mb_sec /= (1.024 * 1.024);
+		printf("%s:\t%.2f MB/sec\n", t[i].name, mb_sec);
+	}
+
+	return 0;
+}
diff --git a/filesetup.c b/filesetup.c
index d67f112..d1702e2 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1343,6 +1343,11 @@ void dup_files(struct thread_data *td, struct thread_data *org)
 			__f->filetype = f->filetype;
 		}
 
+		if (td->o.file_lock_mode == FILE_LOCK_EXCLUSIVE)
+			__f->lock = f->lock;
+		else if (td->o.file_lock_mode == FILE_LOCK_READWRITE)
+			__f->rwlock = f->rwlock;
+
 		td->files[i] = __f;
 	}
 }
diff --git a/fio.1 b/fio.1
index 3cdfd27..ec10377 100644
--- a/fio.1
+++ b/fio.1
@@ -41,6 +41,14 @@ Set terse version output format (Current version 3, or older version 2).
 .B \-\-help
 Display usage information and exit.
 .TP
+.B \-\-cpuclock-test
+Perform test and validation of internal CPU clock
+.TP
+.BI \-\-crctest[\fR=\fPtest]
+Test the speed of the builtin checksumming functions. If no argument is given,
+all of them are tested. Or a comma separated list can be passed, in which
+case the given ones are tested.
+.TP
 .BI \-\-cmdhelp \fR=\fPcommand
 Print help information for \fIcommand\fR.  May be `all' for all commands.
 .TP
diff --git a/init.c b/init.c
index 6c48d3a..b26dc9f 100644
--- a/init.c
+++ b/init.c
@@ -208,6 +208,11 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'T',
 	},
 	{
+		.name		= (char *) "crctest",
+		.has_arg	= optional_argument,
+		.val		= 'G',
+	},
+	{
 		.name		= (char *) "idle-prof",
 		.has_arg	= required_argument,
 		.val		= 'I',
@@ -1405,6 +1410,7 @@ static void usage(const char *name)
 	printf("  --version\t\tPrint version info and exit\n");
 	printf("  --help\t\tPrint this page\n");
 	printf("  --cpuclock-test\tPerform test/validation of CPU clock\n");
+	printf("  --crctest\t\tTest speed of checksum functions\n");
 	printf("  --cmdhelp=cmd\t\tPrint command help, \"all\" for all of"
 		" them\n");
 	printf("  --enghelp=engine\tPrint ioengine help, or list"
@@ -1604,6 +1610,8 @@ void parse_cmd_client(void *client, char *opt)
 	fio_client_add_cmd_option(client, opt);
 }
 
+extern int fio_crctest(const char *);
+
 int parse_cmd_line(int argc, char *argv[], int client_type)
 {
 	struct thread_data *td = NULL;
@@ -1868,6 +1876,10 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			do_exit++;
 			exit_val = fio_monotonic_clocktest();
 			break;
+		case 'G':
+			do_exit++;
+			exit_val = fio_crctest(optarg);
+			break;
 		case 'L': {
 			long long val;
 
diff --git a/options.c b/options.c
index 8287011..57e9af5 100644
--- a/options.c
+++ b/options.c
@@ -1227,6 +1227,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_STR,
 		.off1	= td_var_offset(file_lock_mode),
 		.help	= "Lock file when doing IO to it",
+		.prio	= 1,
 		.parent	= "filename",
 		.hide	= 0,
 		.def	= "none",
