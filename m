Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E0E13A258
	for <fio@vger.kernel.org>; Fri,  1 May 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777636810; cv=none; b=mzIojTCdDKUgRAg1Qde4YQZF3gQ3uCgV1TdaI/bb62nhYjco5TbXK7mjgEWz4aoZAMNsYoPDaDuwR+kREV1aL93MyG659RH3ChNYZq/xKpbqwv0oWj3qqd8tibc7enZF1/QbLt/8162pN9GHXo6ikuPizDuYX/Vkn00PiIP/ZbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777636810; c=relaxed/simple;
	bh=Oy/hhj0o3MeoXnEr7zcwrHgFJHk7Ms8IievPOgJxMOE=;
	h=Subject:From:To:Date:Message-Id; b=DHZi02RnHn6GfSlsv1iQ139GqBcd4XGYXQ2yli/dZcT2PfqFbG7tkrZUfZzWZjLS2ti1PCWVAVQ4tc/FqtG5poXFesYvD5yP8ly+AwedKW1xxpRDTzbulseeRjxc8IDpq6dtSPwALRJOmf3LUm2A7x/mLitZYTb21XHeXGJO1Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M1F3bIFy; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M1F3bIFy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=FXb4a4n4gMvVhSpbGbhFRsmZgMRJU8sBQ8pyOMqRNgQ=; b=M1F3bIFyX3yLIyWVipxZNiGBvP
	yFg03R6xOi8XzpE6H5sZTmiE0yc7VLx3RVAqkpVlMGcXHsXHkguLl0C3zgtW+vU2GjuYXyDNj1/4P
	mHbTD+wfc5M519f1MVU6oM9ZPW9oIZKI63iud5TrHK8Twc+H//pgcs4mWQADQKznD0Tk2coEle2Sc
	EOuN/0ERWcwLAe4OHxkGg978geA6b1QgBnO8CkcEz2yNmbO0dgE14b//7iMGj2xJjAs0ZX9ISnwh/
	BMSHSksUCW22qomaML+/seHkiHY9gz2wFCpJo4lG73bJqgL/scqejlE0fSLF89FZK3BJLSdoJdsA2
	1TdVyTOA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wImXM-00000008u6d-2ZWQ
	for fio@vger.kernel.org;
	Fri, 01 May 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C73C01BC00FD; Fri,  1 May 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri,  1 May 2026 06:00:01 -0600
Message-Id: <20260501120001.C73C01BC00FD@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a95f84caad2300e73ec9bf7077879f30246f3185:

  sprandom: relax power of 2 block size requirement (2026-04-28 12:25:01 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 72156dca3d41df7d05ea4e5a4e59623c2d393a92:

  Merge branch 'codex/cgroup-path-overflows' of https://github.com/linuxholic/fio (2026-04-30 06:53:46 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'codex/cgroup-path-overflows' of https://github.com/linuxholic/fio

yangpeng (1):
      cgroup: fix path buffer overflows for long cgroup names

 Makefile             |   6 ++
 cgroup.c             |  48 +++++++++++++---
 unittests/cgroup.c   | 160 +++++++++++++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.c |   3 +
 unittests/unittest.h |   3 +
 5 files changed, 212 insertions(+), 8 deletions(-)
 create mode 100644 unittests/cgroup.c

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 099e2f94..e3960ece 100644
--- a/Makefile
+++ b/Makefile
@@ -455,6 +455,12 @@ UT_OBJS += unittests/oslib/strlcat.o
 UT_OBJS += unittests/oslib/strndup.o
 UT_OBJS += unittests/oslib/strcasestr.o
 UT_OBJS += unittests/oslib/strsep.o
+ifeq ($(CONFIG_TARGET_OS), Linux)
+UT_OBJS += unittests/cgroup.o
+endif
+ifeq ($(CONFIG_TARGET_OS), Android)
+UT_OBJS += unittests/cgroup.o
+endif
 UT_TARGET_OBJS = lib/memalign.o
 UT_TARGET_OBJS += lib/num2str.o
 UT_TARGET_OBJS += lib/strntol.o
diff --git a/cgroup.c b/cgroup.c
index 77e31a4d..0a26fc8d 100644
--- a/cgroup.c
+++ b/cgroup.c
@@ -18,6 +18,32 @@ struct cgroup_member {
 	unsigned int cgroup_nodelete;
 };
 
+static char *cgroup_path(struct thread_data *td, const char *path,
+			 const char *name, const char *onerr)
+{
+	size_t path_len = strlen(path);
+	size_t name_len = strlen(name);
+	size_t len;
+	char *str;
+	int err;
+
+	if (path_len > SIZE_MAX - name_len - 2) {
+		td_verror(td, ENAMETOOLONG, onerr);
+		return NULL;
+	}
+
+	len = path_len + name_len + 2;
+	str = malloc(len);
+	if (!str) {
+		err = errno;
+		td_verror(td, err, onerr);
+		return NULL;
+	}
+
+	snprintf(str, len, "%s/%s", path, name);
+	return str;
+}
+
 static struct cgroup_mnt *find_cgroup_mnt(struct thread_data *td)
 {
 	struct cgroup_mnt *cgroup_mnt = NULL;
@@ -113,32 +139,35 @@ void cgroup_kill(struct flist_head *clist)
 
 static char *get_cgroup_root(struct thread_data *td, struct cgroup_mnt *mnt)
 {
-	char *str = malloc(64);
-
 	if (td->o.cgroup)
-		sprintf(str, "%s/%s", mnt->path, td->o.cgroup);
+		return cgroup_path(td, mnt->path, td->o.cgroup,
+				   "cgroup root path");
 	else
-		sprintf(str, "%s/%s", mnt->path, td->o.name);
-
-	return str;
+		return cgroup_path(td, mnt->path, td->o.name,
+				   "cgroup root path");
 }
 
 static int write_int_to_file(struct thread_data *td, const char *path,
 			     const char *filename, unsigned int val,
 			     const char *onerr)
 {
-	char tmp[256];
+	char *tmp;
 	FILE *f;
 
-	sprintf(tmp, "%s/%s", path, filename);
+	tmp = cgroup_path(td, path, filename, onerr);
+	if (!tmp)
+		return 1;
+
 	f = fopen(tmp, "w");
 	if (!f) {
+		free(tmp);
 		td_verror(td, errno, onerr);
 		return 1;
 	}
 
 	fprintf(f, "%u", val);
 	fclose(f);
+	free(tmp);
 	return 0;
 
 }
@@ -178,6 +207,9 @@ int cgroup_setup(struct thread_data *td, struct flist_head *clist, struct cgroup
 	 * Create container, if it doesn't exist
 	 */
 	root = get_cgroup_root(td, *mnt);
+	if (!root)
+		return 1;
+
 	if (mkdir(root, 0755) < 0) {
 		int __e = errno;
 
diff --git a/unittests/cgroup.c b/unittests/cgroup.c
new file mode 100644
index 00000000..cc99c3d1
--- /dev/null
+++ b/unittests/cgroup.c
@@ -0,0 +1,160 @@
+#include "../fio.h"
+#include "./unittest.h"
+
+ssize_t log_err(const char *format, ...)
+{
+	return 0;
+}
+
+void *smalloc(size_t size)
+{
+	return malloc(size);
+}
+
+void *scalloc(size_t nmemb, size_t size)
+{
+	return calloc(nmemb, size);
+}
+
+void sfree(void *ptr)
+{
+	free(ptr);
+}
+
+char *smalloc_strdup(const char *str)
+{
+	return strdup(str);
+}
+
+void sinit(void)
+{
+}
+
+void scleanup(void)
+{
+}
+
+void smalloc_debug(size_t size)
+{
+}
+
+unsigned int smalloc_pool_size;
+
+struct fio_sem *fio_sem_init(int value)
+{
+	return NULL;
+}
+
+void fio_sem_remove(struct fio_sem *sem)
+{
+}
+
+void fio_sem_down(struct fio_sem *sem)
+{
+}
+
+void fio_sem_up(struct fio_sem *sem)
+{
+}
+
+#include "../cgroup.c"
+
+static char *test_path_join(const char *path, const char *name)
+{
+	size_t path_len = strlen(path);
+	size_t name_len = strlen(name);
+	size_t len = path_len + name_len + 2;
+	char *joined = malloc(len);
+
+	CU_ASSERT_PTR_NOT_NULL_FATAL(joined);
+	snprintf(joined, len, "%s/%s", path, name);
+	return joined;
+}
+
+static void test_get_cgroup_root_long_path(void)
+{
+	struct thread_data td = { 0 };
+	char mnt_path[] = "/sys/fs/cgroup/blkio";
+	char cgroup_name[] =
+		"/system/pod51ec34a2-12b8-4a51-8b98-b49dace8366f/"
+		"af7853ad741dee19af1b8e14ee2142a7a9314b2dc98a091a29f8aa96106c0a22";
+	struct cgroup_mnt mnt = {
+		.path = mnt_path,
+		.cgroup2 = false,
+	};
+	char *root;
+	char *expected;
+
+	td.o.cgroup = cgroup_name;
+
+	root = get_cgroup_root(&td, &mnt);
+	CU_ASSERT_PTR_NOT_NULL_FATAL(root);
+
+	expected = test_path_join(mnt.path, td.o.cgroup);
+	CU_ASSERT_STRING_EQUAL(root, expected);
+	CU_ASSERT(strlen(root) > 64);
+	CU_ASSERT_EQUAL(td.error, 0);
+
+	free(expected);
+	free(root);
+}
+
+static void test_write_int_to_file_long_path(void)
+{
+	struct thread_data td = { 0 };
+	char tmpdir[] = "/tmp/fio-cgroup-XXXXXX";
+	char leaf[231];
+	char *dir;
+	char *file_path;
+	FILE *f;
+	char buf[32];
+
+	CU_ASSERT_PTR_NOT_NULL_FATAL(mkdtemp(tmpdir));
+
+	memset(leaf, 'x', sizeof(leaf) - 1);
+	leaf[sizeof(leaf) - 1] = '\0';
+
+	dir = test_path_join(tmpdir, leaf);
+	CU_ASSERT_EQUAL_FATAL(mkdir(dir, 0700), 0);
+
+	file_path = test_path_join(dir, "blkio.weight");
+	CU_ASSERT(strlen(file_path) > 256);
+	free(file_path);
+
+	CU_ASSERT_EQUAL(write_int_to_file(&td, dir, "blkio.weight", 1234,
+					  "write_int_to_file"), 0);
+	CU_ASSERT_EQUAL(td.error, 0);
+
+	file_path = test_path_join(dir, "blkio.weight");
+	f = fopen(file_path, "r");
+	CU_ASSERT_PTR_NOT_NULL_FATAL(f);
+	CU_ASSERT_PTR_NOT_NULL(fgets(buf, sizeof(buf), f));
+	CU_ASSERT_STRING_EQUAL(buf, "1234");
+	fclose(f);
+
+	CU_ASSERT_EQUAL(unlink(file_path), 0);
+	CU_ASSERT_EQUAL(rmdir(dir), 0);
+	CU_ASSERT_EQUAL(rmdir(tmpdir), 0);
+
+	free(file_path);
+	free(dir);
+}
+
+static struct fio_unittest_entry tests[] = {
+	{
+		.name	= "cgroup/get-root-long-path",
+		.fn	= test_get_cgroup_root_long_path,
+	},
+	{
+		.name	= "cgroup/write-int-to-file-long-path",
+		.fn	= test_write_int_to_file_long_path,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+CU_ErrorCode fio_unittest_cgroup(void)
+{
+	return fio_unittest_add_suite("cgroup.c", NULL, NULL, tests);
+}
diff --git a/unittests/unittest.c b/unittests/unittest.c
index 4a034b40..c4316322 100644
--- a/unittests/unittest.c
+++ b/unittests/unittest.c
@@ -55,6 +55,9 @@ int main(void)
 	fio_unittest_register(fio_unittest_oslib_strndup);
 	fio_unittest_register(fio_unittest_oslib_strcasestr);
 	fio_unittest_register(fio_unittest_oslib_strsep);
+#if defined(__linux__) || defined(__ANDROID__)
+	fio_unittest_register(fio_unittest_cgroup);
+#endif
 
 	CU_basic_set_mode(CU_BRM_VERBOSE);
 	CU_basic_run_tests();
diff --git a/unittests/unittest.h b/unittests/unittest.h
index 0f45bfbd..6f2ac776 100644
--- a/unittests/unittest.h
+++ b/unittests/unittest.h
@@ -22,5 +22,8 @@ CU_ErrorCode fio_unittest_oslib_strlcat(void);
 CU_ErrorCode fio_unittest_oslib_strndup(void);
 CU_ErrorCode fio_unittest_oslib_strcasestr(void);
 CU_ErrorCode fio_unittest_oslib_strsep(void);
+#if defined(__linux__) || defined(__ANDROID__)
+CU_ErrorCode fio_unittest_cgroup(void);
+#endif
 
 #endif
