Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.141.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761631;
	b=YJA4UHNYAxld4qUj2eU9cKKRiY0cixDsMY/HjzjE0ezLp6Ijs9ZySIhQT73tNjUemZwE
	 fy9q1IYkhJC1k111DrjZ6ge0CYFy8dRJCvHT0Li5J2fILSRXxKE/mKQH9bJvJc7KNJD9N
	 pyboEvvxRiIN/HG3/u2ukBrihOsJkvTvwKtOsqdn0QHMg3N7kq11pZuv8OQpM+KFK9/Mu
	 GUF44lVSoH/LAov7NrmE2S3dhvJgAhc5/lQSK/qAvC4IWm2NtXB4iWX8X3Coyp1PsDpjV
	 VyG9kB91s8WwOVYURSm6utKI28MfdOd+8JBm2lJzMIYaqSWf+hM+xFRzb4ZNOxcJ+1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761631;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=b9nqa9r3rrdQ5GO19/akWVfuZ2WMhLNS4vAkoNoKZ5Y=;
	b=iD26ffx6Pp0wJYfIvAYwetXXCo6yv16bAIsJIXpf80Gy8AfEgkGWjbk3JrHj5n+rQmA/
	 9qQGHwXRAQkl8kf5eELCqy6UNCeA/zmHfBNdIWR0h1k3iSLhdIza1moJc2l0W91JNyBZP
	 vz5afnwGXQDpJS9qiUQnJvHn/YuXV1P6DZgC6Ib99w7Uwri97FNDOSpEbZlkjxA+Ba6UJ
	 p4q4N7hfpw9HsUCRQTZF/VbzIf54GSGNjMYtegrHqfikgtHc/dTDiSgKsMS0lSeDUW0kb
	 Id46UKmNlI2e3QFhyJefYpRXKT571OteE9dgWEuTvT/50Gf9c/zKWtHCxB4S83UWxxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BY1gwwbI;
	arc=none smtp.remote-ip=68.232.141.245
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5963F606A321
	for <fio@vger.kernel.org>; Fri, 27 Nov 2026 06:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5963F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=BY1gwwbI
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795761639; x=1827297639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AZmzqoqH6hZ5sIza/Lu4GkGDZkhf0s+fs8UJwbceavc=;
  b=BY1gwwbIo9QlfVLvNCOqZpU/rJTbaTmmCw6Ts8A1+eYruybFVp6h7Jn4
   B2ygyz7ezI+DiOkmbTkhVDBMn+cQBNclWKQFlr7n06MBirS45IzfBiPwP
   4Zi1BroAvH/svsl5xMHnDLtTHsD47FHNkpHXi1UocmL6FEBOsGllMv+lM
   S8G1HY2NaU/NbsKXqG/PF++r1g07uGJGK27Qc0yLgK8ebV+kpnWtm3QI2
   o9DdVJwqjcQQTvs+4ZGFKSRg0knN5n+Hx6QlqeOnBR/uX0J5Y9jkBOQX9
   x5idPleoPfrqaTLvI39bfOMwZiRfvgYX6/HZgi+k4Jc+LWYJfDvh/NSrZ
   w==;
X-CSE-ConnectionGUID: +YxvwUGzRZukgJZgxBhUBg==
X-CSE-MsgGUID: 7Nn5U62OQReYGrn+s+jE0Q==
X-IronPort-AV: E=Sophos;i="6.27,236,1786982400"; 
   d="scan'208";a="161815430"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2026 14:40:39 +0800
X-CSE-ConnectionGUID: sE9dsqPqSpCrO1jWNcundA==
X-CSE-MsgGUID: EH+RgDMXTwm7HY18WLFdSw==
IronPort-SDR: 6b0925df_y1RSRSXsn4cYbcyntFPkJlEu8y+FM/TYXkuaChgp0BRRQmZ
 ZXlnKQQMWeDVVyO7f0o/6hsSc1Naph632at6Wtw==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Nov 2026 22:40:31 -0800
X-CSE-ConnectionGUID: QHOW5QsVSQm2gR6i8ujNzA==
X-CSE-MsgGUID: n8QkzQvgTIaj7xDxu9lpyw==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai2-o.wdc.com with ESMTP; 26 Nov 2026 22:40:30 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/8] blktrace: fix merge_blktrace_iologs() return value check
Date: Fri, 27 Nov 2026 15:40:21 +0900
Message-ID: <20261127064027.1909326-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261127064027.1909326-1-shinichiro.kawasaki@wdc.com>
References: <20261127064027.1909326-1-shinichiro.kawasaki@wdc.com>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

merge_blktrace_iologs() returns 0 on success, but add_job() treats a
zero return value as failure. As a result, a successful blktrace merge
makes fio fail: with --merge-blktrace-only the merged file is written
but fio exits with status 1, and without it, the merged trace is never
replayed. Fix the wrong check. Also, return -1 from the stub
merge_blktrace_iologs() for platforms without blktrace support, which
should always return non-zero value to report failure.

While at it, fix the error paths that did not return non-zero value:

 - return -1 when fread() fails since fread() may return zero
 - return -ENOMEM when the cursor or the merge buffer allocation fails
 - return -errno when fopen() fails for the merged output file
 - return -EINVAL when the given file is not a blktrace

Fixes: b9921d1a56d9 ("blktrace: add support to interleave blktrace files")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 blktrace.c | 16 ++++++++++++++--
 blktrace.h |  2 +-
 init.c     |  2 +-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index 59f25741..1edebc8f 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -706,7 +706,7 @@ read_skip:
 	ret = fread(t, 1, sizeof(*t), bc->f);
 	if (ferror(bc->f)) {
 		td_verror(td, errno, "read blktrace file");
-		return ret;
+		return -1;
 	} else if (feof(bc->f)) {
 		if (!bc->length)
 			bc->length = bc->t.time;
@@ -752,6 +752,9 @@ int merge_blktrace_iologs(struct thread_data *td)
 	char *str, *ptr, *name, *merge_buf = NULL;
 	int i, ret;
 
+	if (!bcs)
+		return -ENOMEM;
+
 	ret = init_merge_param_list(td->o.merge_blktrace_scalars, bcs, nr_logs,
 				    100, offsetof(struct blktrace_cursor,
 						  scalar));
@@ -772,9 +775,17 @@ int merge_blktrace_iologs(struct thread_data *td)
 
 	/* setup output file */
 	merge_fp = fopen(td->o.merge_blktrace_file, "w");
+	if (!merge_fp) {
+		ret = -errno;
+		log_err("fio: could not open merge file: %s\n",
+			td->o.merge_blktrace_file);
+		goto err_param;
+	}
 	merge_buf = malloc(128 * 1024);
-	if (!merge_buf)
+	if (!merge_buf) {
+		ret = -ENOMEM;
 		goto err_out_file;
+	}
 	ret = setvbuf(merge_fp, merge_buf, _IOFBF, 128 * 1024);
 	if (ret)
 		goto err_out_file;
@@ -794,6 +805,7 @@ int merge_blktrace_iologs(struct thread_data *td)
 
 		if (!is_blktrace(name, &bcs[i].swap)) {
 			log_err("fio: file is not a blktrace: %s\n", name);
+			ret = -EINVAL;
 			free(str);
 			goto err_file;
 		}
diff --git a/blktrace.h b/blktrace.h
index c53b717b..aa797495 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -46,7 +46,7 @@ static inline bool read_blktrace(struct thread_data* td)
 
 static inline int merge_blktrace_iologs(struct thread_data *td)
 {
-	return false;
+	return -1;
 }
 
 #endif
diff --git a/init.c b/init.c
index 7f332417..3724fed4 100644
--- a/init.c
+++ b/init.c
@@ -1954,7 +1954,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (td_steadystate_init(td))
 		goto err;
 
-	if (o->merge_blktrace_file && !merge_blktrace_iologs(td))
+	if (o->merge_blktrace_file && merge_blktrace_iologs(td))
 		goto err;
 
 	if (merge_blktrace_only) {
-- 
2.56.0

