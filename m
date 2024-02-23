Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02C07AE50
	for <fio@vger.kernel.org>; Fri, 23 Feb 2024 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708693218; cv=none; b=ZS50O2EwGJmnbddth9PC7GmcVsy4qnip4QJmkYJZJpmSSFMtWtM6s0s7dQb+IEc7tcpDmjAutsDA2jqYP+wCX8BGSLtEwgFJB3es4cbfRq4KPR6eW/x7bbV2L4kklU6xJK8097KQPDluinOUa+vlzURTd4qqv8LjetvRvfDzJZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708693218; c=relaxed/simple;
	bh=ElT9aEypPiA8zcKkbjPR26WryEbHViZ9jTJO6mFUMy4=;
	h=Subject:From:To:Message-Id:Date; b=jMKd68HxM5yqmQb1dLUKDcuFfZOlAnXcZMcDI6VYsjbP8Xj16C66TRwqhm7YFwiq6B6IR25psDsmK/Yb98PJMLcLnszvflFXp0rsxyRPdrrH9adI019HdlRRtLmx92lvL1EvyvI6D+bdMte7ZQ/Oqja3jYSc4K9k7jODsYJuBL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SGIBZslm; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SGIBZslm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=t8/lWzYGqo2+V1618HYCR5gV/QS3iQ4yZHhBphKfy2E=; b=SGIBZslmF4FGw0Zo9uUYCjkAUx
	xg+edJaHmz/xFIOjDVCV3Wc1h7yMSZh1dgP7VzspLUo1bhQTAo+NBycJkXbkApa/NImeqD6HOes5a
	zzK9rvXpK3WwlhesqilxxLgol/ygYT3qhqRqJyxfJ3tbQUqgmfVPA5PPZWVAZmnKrL3HoX34IuqnY
	zBdYeWRYlJHTGId4GJxQnjf8Gjo+7G5fiOVzsKStQpC5KaE8V1QFxpjWXxP7j39AlycXhjc+G2LvW
	I0vxhN3sTaU2YBCqXkfmmCmkA6059nfCG8q1xdKuJxs31xwLU14a4YV+LRYqQLIs7eJKpHPrudrp7
	VXQgwqNQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdV9v-000000075ll-2YAM
	for fio@vger.kernel.org;
	Fri, 23 Feb 2024 13:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5A44C1BC0129; Fri, 23 Feb 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240223130001.5A44C1BC0129@kernel.dk>
Date: Fri, 23 Feb 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 38d01cc56366aa2fd3af42dbab522888b6359dec:

  verify: fix integer sizes in verify state file (2024-02-16 09:25:35 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9af4af7ab40c4e505033d0e077cc42ac84996b09:

  ci: fix macOS sphinx install issues (2024-02-22 20:01:27 -0500)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-tests-cfi' of https://github.com/mikoxyz/fio

Miko Larsson (3):
      t/io_uring: include libgen.h
      t/io_uring: use char * for name arg in detect_node
      options: declare *__val as long long

Vincent Fu (1):
      ci: fix macOS sphinx install issues

 ci/actions-install.sh |  5 ++---
 options.c             | 12 ++++++------
 t/io_uring.c          |  3 ++-
 3 files changed, 10 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 76335fbc..6eb2d795 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -86,9 +86,8 @@ install_macos() {
     #echo "Updating homebrew..."
     #brew update >/dev/null 2>&1
     echo "Installing packages..."
-    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs sphinx-doc pygments python-certifi
-    brew link sphinx-doc --force
-    pip3 install scipy six statsmodels
+    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs
+    pip3 install scipy six statsmodels sphinx
 }
 
 install_windows() {
diff --git a/options.c b/options.c
index 25e042d0..de935efc 100644
--- a/options.c
+++ b/options.c
@@ -647,7 +647,7 @@ static int fio_clock_source_cb(void *data, const char *str)
 	return 0;
 }
 
-static int str_rwmix_read_cb(void *data, unsigned long long *val)
+static int str_rwmix_read_cb(void *data, long long *val)
 {
 	struct thread_data *td = cb_data_to_td(data);
 
@@ -656,7 +656,7 @@ static int str_rwmix_read_cb(void *data, unsigned long long *val)
 	return 0;
 }
 
-static int str_rwmix_write_cb(void *data, unsigned long long *val)
+static int str_rwmix_write_cb(void *data, long long *val)
 {
 	struct thread_data *td = cb_data_to_td(data);
 
@@ -1625,7 +1625,7 @@ static int str_gtod_reduce_cb(void *data, int *il)
 	return 0;
 }
 
-static int str_offset_cb(void *data, unsigned long long *__val)
+static int str_offset_cb(void *data, long long *__val)
 {
 	struct thread_data *td = cb_data_to_td(data);
 	unsigned long long v = *__val;
@@ -1646,7 +1646,7 @@ static int str_offset_cb(void *data, unsigned long long *__val)
 	return 0;
 }
 
-static int str_offset_increment_cb(void *data, unsigned long long *__val)
+static int str_offset_increment_cb(void *data, long long *__val)
 {
 	struct thread_data *td = cb_data_to_td(data);
 	unsigned long long v = *__val;
@@ -1667,7 +1667,7 @@ static int str_offset_increment_cb(void *data, unsigned long long *__val)
 	return 0;
 }
 
-static int str_size_cb(void *data, unsigned long long *__val)
+static int str_size_cb(void *data, long long *__val)
 {
 	struct thread_data *td = cb_data_to_td(data);
 	unsigned long long v = *__val;
@@ -1711,7 +1711,7 @@ static int str_io_size_cb(void *data, unsigned long long *__val)
 	return 0;
 }
 
-static int str_zoneskip_cb(void *data, unsigned long long *__val)
+static int str_zoneskip_cb(void *data, long long *__val)
 {
 	struct thread_data *td = cb_data_to_td(data);
 	unsigned long long v = *__val;
diff --git a/t/io_uring.c b/t/io_uring.c
index 46b153dc..18e8b38e 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -28,6 +28,7 @@
 #include <string.h>
 #include <pthread.h>
 #include <sched.h>
+#include <libgen.h>
 
 #include "../arch/arch.h"
 #include "../os/os.h"
@@ -819,7 +820,7 @@ static void set_affinity(struct submitter *s)
 #endif
 }
 
-static int detect_node(struct submitter *s, const char *name)
+static int detect_node(struct submitter *s, char *name)
 {
 #ifdef CONFIG_LIBNUMA
 	const char *base = basename(name);
