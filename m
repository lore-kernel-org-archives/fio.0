Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FC93B7B67
	for <fio@vger.kernel.org>; Tue, 17 Mar 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748815; cv=none; b=ZoaIy6oQB1oNfE95MmNTJbwnz38kX8XOVzwYcNnbv+SvTg00Oq6/jvICeunwOwvz20mgqPICI4dP76apGsJpERJoo4Twlsrjtb5weSjH6y3mopx9LFkoLgkK3Uc4TCEmE0tonVxPfgF8U4DFRr/42hLvsJ0al0jN5dbzTurHeB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748815; c=relaxed/simple;
	bh=DtYPUUxPRXJzjbVxtlRHCY4MOfUKcq6VvMhWKjbhkFk=;
	h=Subject:From:To:Date:Message-Id; b=QNE0u2pTw7ZR/Q0PJ9UlBTpj28pWAqqP85XZjkzDpamWEqvnil2vel9sjoS+u3vLxHcB8OXSRrvbHehvJdeZWSb3Oy0hqNFqASoIpbTFL29v24YfJwsVanwiMSByU6lz8T94vbmGWQauqQ5u3TJFUi8Ku9U5likvImkmMQiMLcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c/0ZeITp; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c/0ZeITp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=uJ/xl4FgeUIBEDfLk0+6aIIW/4D2Jq1qiFKjOtcjE7A=; b=c/0ZeITpLF9jPzwN7YXxnJOlmD
	rlf1Jx3XOaJtJdS+N44Ta12WPHzDD0kakehBorQgtTYX4QRk0MhJgpMUmP5GZDh9lkQy9Am0swHxB
	ilK/VZHBvRJaFQFotQLjJ7bgRu09soQhKAz7Ei2QZ1h796O/jkc5B2HHEdpUO1GRZFy2qIsBFYii5
	ty5ZcR3xRPEuennIYpmkk8XOPMQ3OKdws5qH3B1swjH+mU8ZIQPIwRzatzZMKbvaCp148sxrcMEb3
	b4YtZj5iECFnbCNzMB9wjCpuueHFoMGe1tbKHviOGR0z2XoRHGmhDcy5ABO57bN4+9RuZ9SM7qdOV
	kAJMzemA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2T5j-00000002eCb-1kNL
	for fio@vger.kernel.org;
	Tue, 17 Mar 2026 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 287A51BC0192; Tue, 17 Mar 2026 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 17 Mar 2026 06:00:02 -0600
Message-Id: <20260317120002.287A51BC0192@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 3a0e8ddf28ad32785ea3130ce0ee42524d835d60:

  backend: correctly handle rate_iops combined with bssplit (2026-03-11 05:37:00 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4db5740d27942e5a36b091ace763b188888b6f9e:

  stat: improve latency target reporting (2026-03-16 11:13:04 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      stat: improve latency target reporting

 stat.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index aea573f5..63c9927f 100644
--- a/stat.c
+++ b/stat.c
@@ -1205,6 +1205,27 @@ static void show_disk_util(int terse, struct json_object *parent,
 	}
 }
 
+static double scale_down_ns(unsigned long long val, const char **unit)
+{
+	double retval;
+
+	if (val >= 2000000000) {
+		retval = (double) val / 1000000000.0;
+		*unit = "s";
+	} else if (val >= 2000000) {
+		retval = (double) val / 1000000.0;
+		*unit = "ms";
+	} else if (val >= 2000) {
+		retval = (double) val / 1000.0;
+		*unit = "us";
+	} else {
+		retval = (double) val;
+		*unit = "ns";
+	}
+
+	return retval;
+}
+
 static void show_thread_status_normal(struct thread_stat *ts,
 				      const struct group_run_stats *rs,
 				      struct buf_output *out)
@@ -1306,9 +1327,14 @@ static void show_thread_status_normal(struct thread_stat *ts,
 					strerror(ts->first_error));
 	}
 	if (ts->latency_depth) {
-		log_buf(out, "     latency   : target=%llu, window=%llu, percentile=%.2f%%, depth=%u\n",
-					(unsigned long long)ts->latency_target,
-					(unsigned long long)ts->latency_window,
+		double target, window;
+		const char *target_unit, *window_unit;
+
+		target = scale_down_ns(ts->latency_target, &target_unit);
+		window = scale_down_ns(ts->latency_window*1000, &window_unit);
+		log_buf(out, "     latency   : target=%.2f%s, window=%.2f%s, percentile=%.2f%%, depth=%u\n",
+					target, target_unit,
+					window, window_unit,
 					ts->latency_percentile.u.f,
 					ts->latency_depth);
 	}
@@ -1869,8 +1895,10 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	if (ts->latency_depth) {
 		json_object_add_value_int(root, "latency_depth", ts->latency_depth);
 		json_object_add_value_int(root, "latency_target", ts->latency_target);
+		json_object_add_value_int(root, "latency_target_ns", ts->latency_target);
 		json_object_add_value_float(root, "latency_percentile", ts->latency_percentile.u.f);
 		json_object_add_value_int(root, "latency_window", ts->latency_window);
+		json_object_add_value_int(root, "latency_window_us", ts->latency_window);
 	}
 
 	/* Additional output if description is set */
