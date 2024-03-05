Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40BF4F211
	for <fio@vger.kernel.org>; Tue,  5 Mar 2024 09:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709629224; cv=none; b=VXMcMMVL54s5gLzy9NXH4QJZH90ZSrgrlRjaO2Zsgd3/NNP9fX/tFdyEfvjJjF2oXjJxzyfRgNzyN45ZGqaPbAbIYF9lJ1MmrpUAV2h1r6NO6s4g2eERH0VS7OhgIhbfVgpM+1j/LAlwBms/8u2Rm4CEyksyoImav13uIdJbv8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709629224; c=relaxed/simple;
	bh=HsYGw6hB8qk4b8Zk8VvDWhklJxD/7W1cqr5UbajWhJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSvpbGPCH65x4MVs1piDLtJRNOozPcIrwiW7vRmX6gUqz2WcjEbA2Wh9ZWkVBStEZfHHwoIkgkQAQIKqDjSmpEFfsdZQPx9bY/HL/1i6SkVRlK0U11ML30Tly9Qe00IPHh7ICw1WDFJcyaCqPRUrZP1oX/fHuZBEqSOhkL5i9+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lcd8XME5; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lcd8XME5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709629222; x=1741165222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HsYGw6hB8qk4b8Zk8VvDWhklJxD/7W1cqr5UbajWhJg=;
  b=lcd8XME5WaCCOxk1vA8+IDNxnrmfLZxlN2lrEDZmliS0zGEeULTaJujN
   Vx76dF2s+nTdbulx+GMZJCqio4hhzFDQCbmqhHqa9YOYto3rIgcexa1Pq
   rpZNdEyjOGLXyrb+mr275H0Lk70JJ5mbhGVzf9WDUA6DtGNRE6ZBBxE1L
   8HUHX2qAitLxSjPI9/jwJZz3h5GQcbryfQ7FSoXkuFW5+VCpMHVZc2dpF
   uwgMNKRV5EIOXhHDUxY5J0/cJNfLLcd4cmtfjG66cPRuqqHVmCwF8lJps
   MEXgHTIesdjYHcmcTTEc4I7DCe7TW1iyWKQ48peWJF6Z3WkHsm5PEKBzI
   Q==;
X-CSE-ConnectionGUID: WdJNJUNXTsWRVBKqUbriCA==
X-CSE-MsgGUID: 1RTtZPxPQaabWzRXIsQbxw==
X-IronPort-AV: E=Sophos;i="6.06,205,1705334400"; 
   d="scan'208";a="10678184"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2024 17:00:21 +0800
IronPort-SDR: 3CWO7Mu2Idt3ZW2SOXMMrKUvF06om2Ppfhg59VVayfWH7it9QKuBkv1gThVEA86rSh5PA+/Ocs
 4C9CS73vEtKQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2024 00:09:32 -0800
IronPort-SDR: eGY4jqpQLucH9UXLBoWEd31hMIXxi+aONnqIZDZd86iKVzZeZn6WdHlqNf2A/+VaLBCBlOFBHM
 tPXhC881IJaw==
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Mar 2024 01:00:20 -0800
From: Avri Altman <avri.altman@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 1/5] fio: Some minor code cleanups
Date: Tue,  5 Mar 2024 11:00:04 +0200
Message-ID: <20240305090008.1216-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240305090008.1216-1-avri.altman@wdc.com>
References: <20240305090008.1216-1-avri.altman@wdc.com>
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

