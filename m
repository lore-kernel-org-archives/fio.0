Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B4C31A057
	for <fio@vger.kernel.org>; Wed, 20 Aug 2025 13:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.152.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755695079; cv=none; b=YX2MmfhqPeCxhto4c4QTWwub7nm6LU4orfIkLAnL4uaaj+jfPVkSY4Dc0HgJoe+1MLj1Pt6BC55t35+Rn/gJzBeNyNDjIybfWxXyR6iLTHWTGmt9VMhD1uV2scLPXuVtYph5zcyvhM9DoYj0qrwZeJnxFn2LQX7dGCtuczC2ynY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755695079; c=relaxed/simple;
	bh=QvL1nWMa4SMWMUrZ5XouqyVUGIo1PFT07fI7zlDhM2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tctlESgAU2pc7CYHuyS9Q2KE8DVR1gxGuLMZ0WqBtjClf71ZpN/0WR4SXM8pxtVvWfUui+9u04xDogGOsJUWIy/tj+uDVYLgckgH7NCVBzK7cPGBscEmCJmCL2crn83ByUyDJfs2IreoxgwXN1MWa8VuhaSMtBIxmV3lrQDciUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=xg8gY6d5; arc=none smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="xg8gY6d5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1755695078; x=1787231078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QvL1nWMa4SMWMUrZ5XouqyVUGIo1PFT07fI7zlDhM2M=;
  b=xg8gY6d5Vv/NaKH1fPjIjAwM7bDXcJ8A4wVG6VxMYxZ366GJ6c1ohMHG
   ihot6mc+H5W9NJaSckWskYxk7IQGSAMJI6YXB5kNSuB5KK3QWZoxwZFze
   Wstd8oehgKJtg/tB7tEY1I1i6cfuoRmqR9xthz2gq7hFZHRSiRPEISRbG
   0RnsAvAH2HyNPAUpxbOAb+62ryc1Znq1M02PbpddUsYgEGrC49b3r/Dju
   2pxlXbbaFrW554ecvipE5E7OxW7w8E/jlW6xg86UzdlSTMGZCBYEzvj/D
   cQBpmVtia7vNA9ZKqpuKwPuvf0tU6DCydv1PBzfUyHXypMWH88wZKzmGX
   g==;
X-CSE-ConnectionGUID: +uUas/Q9R2StZxMhjOHLxA==
X-CSE-MsgGUID: LIHb3tPFTc2zxmKzjW6HLQ==
Received: from unknown (HELO uls-op-esaep01.corp.sandisk.com) ([129.253.192.43])
  by ob1.hc6817-7.iphmx.com with ESMTP; 20 Aug 2025 06:03:32 -0700
IronPort-SDR: 68a5c7a4_swP+q+lhf4xj7M5nSKTpxuYOsuYsRTVzprKSOPxGxfp9BUr
 dtwSrFUA8Sz4ZTTEkYJ1bD6WbiPuBU39yPwOCpA==
Received: from unknown (HELO uls-op-esaip01.corp.sandisk.com) ([10.15.0.10])
  by uls-op-esaep01.corp.sandisk.com with ESMTP; 20 Aug 2025 06:03:32 -0700
SanDiskIronportException: Internal
Received: from ulssdxvpxsnip.corp.sandisk.com (HELO WDAP-HWJc7y5WZG.wdc.com) ([10.9.34.160])
  by uls-op-esaip01.corp.sandisk.com with ESMTP; 20 Aug 2025 06:03:31 -0700
From: Tomas Winkler <tomas.winkler@sandisk.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org,
	Tomas Winkler <tomas.winkler@sandisk.com>
Subject: [PATCH 3/3] engines: make engines static-correct
Date: Wed, 20 Aug 2025 16:03:21 +0300
Message-ID: <20250820130321.73376-4-tomas.winkler@sandisk.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820130321.73376-1-tomas.winkler@sandisk.com>
References: <20250820130321.73376-1-tomas.winkler@sandisk.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mark internal function static.

Signed-off-by: Tomas Winkler <tomas.winkler@sandisk.com>
---
 engines/cpu.c  | 4 ++--
 engines/exec.c | 6 +++---
 engines/nvme.c | 4 ++--
 engines/sg.c   | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/engines/cpu.c b/engines/cpu.c
index ce74dbce..898fc00e 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -9,7 +9,7 @@
 #include "../optgroup.h"
 
 // number of 32 bit integers to sort
-size_t qsort_size = (256 * (1ULL << 10)); // 256KB
+static size_t qsort_size = (256 * (1ULL << 10)); // 256KB
 
 struct mwc {
 	uint32_t w;
@@ -93,7 +93,7 @@ static struct fio_option options[] = {
  *      fast pseudo random number generator, see
  *      http://www.cse.yorku.ca/~oz/marsaglia-rng.html
  */
-uint32_t mwc32(struct mwc *mwc)
+static uint32_t mwc32(struct mwc *mwc)
 {
         mwc->z = 36969 * (mwc->z & 65535) + (mwc->z >> 16);
         mwc->w = 18000 * (mwc->w & 65535) + (mwc->w >> 16);
diff --git a/engines/exec.c b/engines/exec.c
index 20e50e00..af20d5e1 100644
--- a/engines/exec.c
+++ b/engines/exec.c
@@ -62,7 +62,7 @@ static struct fio_option options[] = {
 	},
 };
 
-char *str_replace(char *orig, const char *rep, const char *with)
+static char *str_replace(char *orig, const char *rep, const char *with)
 {
 	/*
 	 * Replace a substring by another.
@@ -106,7 +106,7 @@ char *str_replace(char *orig, const char *rep, const char *with)
 	return result;
 }
 
-char *expand_variables(struct thread_options *o, char *arguments)
+static char *expand_variables(const struct thread_options *o, char *arguments)
 {
 	char str[16];
 	char *expanded_runtime, *expanded_name;
@@ -122,7 +122,7 @@ char *expand_variables(struct thread_options *o, char *arguments)
 	return expanded_name;
 }
 
-static int exec_background(struct thread_options *o, struct exec_options *eo)
+static int exec_background(const struct thread_options *o, struct exec_options *eo)
 {
 	char *outfilename = NULL, *errfilename = NULL;
 	int outfd = 0, errfd = 0;
diff --git a/engines/nvme.c b/engines/nvme.c
index 4b3d3860..528b2a29 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -312,8 +312,8 @@ next:
 
 	return 0;
 }
-void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-				  struct nvme_dsm *dsm)
+static void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+					 struct nvme_dsm *dsm)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	struct trim_range *range;
diff --git a/engines/sg.c b/engines/sg.c
index 9df70bd2..7912e9c8 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -1136,7 +1136,7 @@ static int fio_sgio_open(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-int fio_sgio_close(struct thread_data *td, struct fio_file *f)
+static int fio_sgio_close(struct thread_data *td, struct fio_file *f)
 {
 	struct sg_options *o = td->eo;
 	int ret;
-- 
2.43.0

