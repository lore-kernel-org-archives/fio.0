Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D8154BEB
	for <fio@vger.kernel.org>; Tue, 27 Aug 2024 07:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742546; cv=none; b=qn8Lf3lwv1DAk3ZHGxQzvLdr+llMgOkeLVrySquBlQpmWD/NsLcCOhe3fZOxJCFLZALpmilINFPhwszLDx7onx5EHBKAEyO0Rj8wKS0hn6qLO7jZ9yUinLJd8/goUqOXG3mtsGe1tuWanv/ERXqXvyO4hM3cM0Eqze3e+LDTc5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742546; c=relaxed/simple;
	bh=Iz9dOuiW+Lih2tLQ1jOMVmpjhEtdqT+dYKGr8srqXqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q79sIYdbYIqJRXV9IlFRx0gqbYEcnwuK9lgzNfCZkStnAu/q4xVwehutyPoc9arFrstL2B+n+4+oZUv10bgJqol/NjYVr+OUuacUgQfLtHq3R+aB4FhSgYwdAKCWC12OOW3hDNcIMFG2UYHR/I58XjfM5VX1E9YUtzzDFD/D/KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Vuc9oMF6; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Vuc9oMF6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724742544; x=1756278544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Iz9dOuiW+Lih2tLQ1jOMVmpjhEtdqT+dYKGr8srqXqM=;
  b=Vuc9oMF6MmoXb5Df0lhkFGQXC07jKHAVI3RihEIvcneAWrhHQgAUNoGF
   kFwQUhfwJ3+OBr2tj9pe+qszNlukB7KiCENNs1x8TWvC+U8f2eAbhh9Hb
   w3qQfs/2c7orAOlbcBi2DLKjAu4/OhMwtsWVABMriBtjxS1FJQJVZ0Dod
   yH4T7chX+cx5vpAt5u88jGgrMJhJFvlw9mGyMxInreVX8eY5fxu1wZL4Y
   TSYD9YSTR01HKbhDYAQEeWiF/o7bbD9s/LyEJ1Q7PgexCCGW6in3nkkrf
   ujaHw73rAoXP7ohDJEb7okiFCem+mBIwFwaFDxhJY2gaqfqopWUBWHDd7
   A==;
X-CSE-ConnectionGUID: KZiUVLILThKwJRTu0yeHkw==
X-CSE-MsgGUID: NWodVABeSsSwjnw7UghwFA==
X-IronPort-AV: E=Sophos;i="6.10,179,1719849600"; 
   d="scan'208";a="25297879"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2024 15:08:59 +0800
IronPort-SDR: 66cd6ecd_bwPmQYLto2/RpqT1ISMA8rOb0Fyo6L7hs15PUpDJnhH5IFd
 OVT/QD5D0ozyqDnxGm+2yjrW6K1Nl5mS+c3aYGg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2024 23:14:37 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2024 00:08:58 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 7/9] doc: describe the log_issue_time option
Date: Tue, 27 Aug 2024 16:08:48 +0900
Message-ID: <20240827070850.947037-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The recent commit introduced the new option log_issue_time. Describe its
feature and restrictions.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 21 +++++++++++++++++----
 fio.1     | 19 +++++++++++++++----
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 49a28464..49486cfd 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4244,6 +4244,14 @@ Measurements and reporting
 	Otherwise, the field shows if the command has the highest RT
 	priority class or not. Also see	`Log File Formats`_.
 
+.. option:: log_issue_time=bool
+
+	If this is set, the iolog options will include the command issue time
+	for the I/O entry as well as the other data values. Defaults to 0
+	meaning that command issue times are not present in logs. Also see
+	`Log File Formats`_. This option shall be set together with
+	:option:`write_lat_log` and :option:`log_offset`.
+
 .. option:: log_compression=int
 
 	If this is set, fio will compress the I/O logs as it goes, to keep the
@@ -5209,7 +5217,7 @@ Fio supports a variety of log file formats, for logging latencies, bandwidth,
 and IOPS. The logs share a common format, which looks like this:
 
     *time* (`msec`), *value*, *data direction*, *block size* (`bytes`),
-    *offset* (`bytes`), *command priority*
+    *offset* (`bytes`), *command priority*, *issue time* (`nsec`)
 
 *Time* for the log entry is always in milliseconds. The *value* logged depends
 on the type of log, it will be one of the following:
@@ -5245,6 +5253,11 @@ the priority value (:option:`prio` and :option:`cmdprio` options) and the
 highest 3 bits indicating the IO priority class (:option:`prioclass` and
 :option:`cmdprio_class` options).
 
+The entry's *issue time* is the command issue time in nanoseconds. The logging
+of the issue time can be toggled with :option:`log_issue_time`. This field has
+valid values in completion latency log file (clat), or submit latency log file
+(slat). The field has value 0 in other logs files.
+
 Fio defaults to logging every individual I/O but when windowed logging is set
 through :option:`log_avg_msec`, either the average (by default), the maximum
 (:option:`log_window_value` is set to max) *value* seen over the specified period
@@ -5253,12 +5266,12 @@ is set to both) is recorded. The log file format when both the values are report
 takes this form:
 
     *time* (`msec`), *value*, *value1*, *data direction*, *block size* (`bytes`),
-    *offset* (`bytes`), *command priority*
+    *offset* (`bytes`), *command priority*, *issue time* (`nsec`)
 
 
 Each *data direction* seen within the window period will aggregate its values in a
-separate row. Further, when using windowed logging the *block size* and *offset*
-entries will always contain 0.
+separate row. Further, when using windowed logging the *block size*, *offset*
+and *issue time* entries will always contain 0.
 
 
 Client/Server
diff --git a/fio.1 b/fio.1
index 0aabe89e..29e5ce95 100644
--- a/fio.1
+++ b/fio.1
@@ -3948,6 +3948,12 @@ shows the priority value and the IO priority class of the command.
 Otherwise, the field shows if the command has the highest RT priority
 class or not. Also see \fBLOG FILE FORMATS\fR section.
 .TP
+.BI log_issue_time \fR=\fPbool
+If this is set, the iolog options will include the command issue time for the
+I/O entry as well as the other data values. Defaults to 0 meaning that command
+issue times are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
+This option shall be set together with \fBwrite_lat_log\fR and \fBlog_offset\fR.
+.TP
 .BI log_compression \fR=\fPint
 If this is set, fio will compress the I/O logs as it goes, to keep the
 memory footprint lower. When a log reaches the specified size, that chunk is
@@ -4943,7 +4949,7 @@ and IOPS. The logs share a common format, which looks like this:
 .RS
 .P
 time (msec), value, data direction, block size (bytes), offset (bytes),
-command priority
+command priority, issue time (nsec)
 .RE
 .P
 `Time' for the log entry is always in milliseconds. The `value' logged depends
@@ -4986,6 +4992,11 @@ number with the lowest 13 bits indicating the priority value (\fBprio\fR and
 \fBcmdprio\fR options) and the highest 3 bits indicating the IO priority class
 (\fBprioclass\fR and \fBcmdprio_class\fR options).
 .P
+The entry's `issue time` is the command issue time in nanoseconds. The logging
+of the issue time can be toggled with \fBlog_issue_time\fR. This field has valid
+values in completion latency log file (clat), or submit latency log file (slat).
+The field has value 0 in other log files.
+.P
 Fio defaults to logging every individual I/O but when windowed logging is set
 through \fBlog_avg_msec\fR, either the average (by default), the maximum
 (\fBlog_window_value\fR is set to max) `value' seen over the specified period of
@@ -4995,12 +5006,12 @@ takes this form:
 .RS
 .P
 time (msec), value, value1, data direction, block size (bytes), offset (bytes),
-command priority
+command priority, issue time (nsec)
 .RE
 .P
 Each `data direction' seen within the window period will aggregate its values
-in a separate row. Further, when using windowed logging the `block size' and
-`offset' entries will always contain 0.
+in a separate row. Further, when using windowed logging the `block size',
+`offset' and `issue time` entries will always contain 0.
 .SH CLIENT / SERVER
 Normally fio is invoked as a stand-alone application on the machine where the
 I/O workload should be generated. However, the backend and frontend of fio can
-- 
2.45.2

