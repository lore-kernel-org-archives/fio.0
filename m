Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E8C12E73
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 07:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536744; cv=none; b=Veb94t6EBXIle2DcItxLvCbjlvMJmfY02uR7LS1uoKxPyrfNClzfvrtod9vQuyYGVECt0K0lD/AOjgVuzGnXmcuIzrIYXG8bjT4CUmsyL/MGIuv+VUQfXzCY6cWZg5C3CK5Yp8oKDSJ6TYh/wizIuuoZkVLqfxsmcEYlzrHhBUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536744; c=relaxed/simple;
	bh=HsYGw6hB8qk4b8Zk8VvDWhklJxD/7W1cqr5UbajWhJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jL0wyN1l1etLXMyaA/G3EYCcUOHBwS6nyDaDTZ6I870yMB13pq07WU4eFAB10hin8rkWyfZu9Oy6iKXjVowA0uRGX/yBp61zQoSv23atcVWyAxPJIC7hFaMoBWeCAUU0pkW2is3K+2/fksegtad2ilSmBTOBHwI4vkMVgXDfnsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Jyuerv+v; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Jyuerv+v"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709536742; x=1741072742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HsYGw6hB8qk4b8Zk8VvDWhklJxD/7W1cqr5UbajWhJg=;
  b=Jyuerv+va03Vld6aaVM2G6fEpO3mK7LWcenmmKGOzQhYkXBEvJIsRcnF
   DKoXvO1wvr1DQI0viPGU5ojt0Yk9GRKZVA6bIPFxfYJ0Zi543GXP4N2Fb
   /abMBWjJyWgC0LgbpuUfZHXwIaQKUhvdVxUamgWtlF+EfKe12LLdZk190
   rPtC6TLUAMM+bUbX5ToQtjaXpQl6yCijE9xTRZg7g7fLkVnIziBiC1u87
   lpo2fdW6sVpGJrU62FvOZFS/iFeMkrZTKzSaqAimAw8Vp4EW8vYp7PnJt
   vWNPYdbC/zHY8WSaosuuaLZmT30eQ+WN2V74ZasdGJyR24VdX78UVspTF
   Q==;
X-CSE-ConnectionGUID: JV+ayI5eRU+J/nUegDpE+g==
X-CSE-MsgGUID: zIAGjk5LTsK3XI2Wic5iQA==
X-IronPort-AV: E=Sophos;i="6.06,203,1705334400"; 
   d="scan'208";a="11318342"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2024 15:19:00 +0800
IronPort-SDR: hRUBWbcBL3dNLnRUqk5rpRSFdO5T/XM2w9RcWx9g8hcQlmOKm7ewJ1lJqjJCocecYxK4CWtCHm
 NcoPAAYM7S3w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2024 22:28:13 -0800
IronPort-SDR: j7s0MkdlGWochIWsPB58jIR0l53KM0fKToVH6AGte4VOpKK1bh4O/DjPNPW26BG+K3H0GoG2Zm
 XUJL7wGOyY6g==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Mar 2024 23:18:59 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 1/6] fio: Some minor code cleanups
Date: Mon,  4 Mar 2024 09:18:46 +0200
Message-ID: <20240304071851.982-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304071851.982-1-avri.altman@wdc.com>
References: <20240304071851.982-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

limit the scope of variables when possible, fix style isses etc.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 HOWTO.rst | 2 +-
 backend.c | 4 ++--
 eta.c     | 8 +++++---
 io_u.c    | 3 ++-
 parse.h   | 2 +-
 stat.h    | 1 -
 6 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 169cdc2a..c404d724 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2786,7 +2786,7 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: sg_write_mode=str : [sg]
 
-	Specify the type of write commands to issue. This option can take three values:
+	Specify the type of write commands to issue. This option can take ten values:
 
 	**write**
 		This is the default where write opcodes are issued as usual.
diff --git a/backend.c b/backend.c
index 2f2221bf..fb7dc68a 100644
--- a/backend.c
+++ b/backend.c
@@ -2094,14 +2094,14 @@ static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
 			 uint64_t *m_rate)
 {
 	unsigned int cputhreads, realthreads, pending;
-	int status, ret;
+	int ret;
 
 	/*
 	 * reap exited threads (TD_EXITED -> TD_REAPED)
 	 */
 	realthreads = pending = cputhreads = 0;
 	for_each_td(td) {
-		int flags = 0;
+		int flags = 0, status;
 
 		if (!strcmp(td->o.ioengine, "cpuio"))
 			cputhreads++;
diff --git a/eta.c b/eta.c
index cc342461..7d07708f 100644
--- a/eta.c
+++ b/eta.c
@@ -215,8 +215,9 @@ static unsigned long thread_eta(struct thread_data *td)
 				perc = td->o.rwmix[DDIR_WRITE];
 
 			bytes_total += (bytes_total * perc) / 100;
-		} else
+		} else {
 			bytes_total <<= 1;
+		}
 	}
 
 	if (td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING) {
@@ -228,8 +229,9 @@ static unsigned long thread_eta(struct thread_data *td)
 			perc = (double) bytes_done / (double) bytes_total;
 			if (perc > 1.0)
 				perc = 1.0;
-		} else
+		} else {
 			perc = 0.0;
+		}
 
 		if (td->o.time_based) {
 			if (timeout) {
@@ -395,7 +397,7 @@ static bool skip_eta()
  * Print status of the jobs we know about. This includes rate estimates,
  * ETA, thread state, etc.
  */
-bool calc_thread_status(struct jobs_eta *je, int force)
+static bool calc_thread_status(struct jobs_eta *je, int force)
 {
 	int unified_rw_rep;
 	bool any_td_in_ramp;
diff --git a/io_u.c b/io_u.c
index 2b8e17f8..09e5f15a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1895,8 +1895,9 @@ struct io_u *get_io_u(struct thread_data *td)
 					io_u->buflen);
 			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
 				   !(td->flags & TD_F_COMPRESS) &&
-				   !(td->flags & TD_F_DO_VERIFY))
+				   !(td->flags & TD_F_DO_VERIFY)) {
 				do_scramble = 1;
+			}
 		} else if (io_u->ddir == DDIR_READ) {
 			/*
 			 * Reset the buf_filled parameters so next time if the
diff --git a/parse.h b/parse.h
index d68484ea..806a76ee 100644
--- a/parse.h
+++ b/parse.h
@@ -32,7 +32,7 @@ enum fio_opt_type {
  */
 struct value_pair {
 	const char *ival;		/* string option */
-	unsigned long long oval;/* output value */
+	unsigned long long oval;	/* output value */
 	const char *help;		/* help text for sub option */
 	int orval;			/* OR value */
 	void *cb;			/* sub-option callback */
diff --git a/stat.h b/stat.h
index bd986d4e..0d57cceb 100644
--- a/stat.h
+++ b/stat.h
@@ -345,7 +345,6 @@ extern void stat_exit(void);
 
 extern struct json_object * show_thread_status(struct thread_stat *ts, struct group_run_stats *rs, struct flist_head *, struct buf_output *);
 extern void show_group_stats(struct group_run_stats *rs, struct buf_output *);
-extern bool calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
 extern void __show_run_stats(void);
 extern int __show_running_run_stats(void);
-- 
2.42.0

