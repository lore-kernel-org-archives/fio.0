Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FEC18C900
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 08:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724921918; cv=none; b=HtAFEuGx30sRHc2zjUc1xapMwaBeffO3ForByerV0xB4BFwc/OpUZ4obl+U1ffEdaGJdRrlaGa1/DTOUBfgOJCz7AmY4T24xs+RX9LDrt7nJA1xfpfWqj+kyPP4+NPNeuUdiffvzqrwZSmvhBuDtTLvlhGv5X3cekbzZ57r9/gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724921918; c=relaxed/simple;
	bh=Iz9dOuiW+Lih2tLQ1jOMVmpjhEtdqT+dYKGr8srqXqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8jRNvueGmwPrt9CE3Z4GKwaCMNv7mn3Jux2PbGPFLE3GxEgOXO6dtbtE4/17Jf2Achv3bApzjgkkYWLVOAy88j1wZJ31ciyezCSOoTL31+QZa4mkj+AYToEM46uOX7usqdfJgR/GA2l3XWO2bSEc8OkPaf3KMyNRYDlZKMN9T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=r2oK4Cym; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="r2oK4Cym"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724921917; x=1756457917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Iz9dOuiW+Lih2tLQ1jOMVmpjhEtdqT+dYKGr8srqXqM=;
  b=r2oK4CymLWrS7a9j2XZrnXsdbdI5o8ivmzMhvYkmanK4xHMuypOqdA3V
   qth0b/FxeW100c99bT1Vicgyx6jgurubVZz/vFVIGh6+Kgqh4qE/8CNp3
   YiODkZv7PqhAIm8O00i1tv5MbknLi7C0DwYL10v1ApVfMvin3xL4IOVq8
   3ct027WSPDvd+AsKLYBcNdeUe8Wve19bVd59q6ScHS5q/EWpXnpeaiqSm
   0Tf/bbede/eVqkz9GxGWmDcy7Rztaa60EEpUJm1FnylWdYrvRrude962X
   gngwD5yLVB6TzTa68CslQFVY8GDYEqdelpwPmpvobH5LrMAblcH7nMaxr
   g==;
X-CSE-ConnectionGUID: LWMopA4xT7uafovh89MJlg==
X-CSE-MsgGUID: lUcedXa9T1mEhuA+h+TVeQ==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="24854839"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 16:58:36 +0800
IronPort-SDR: 66d02a26_M0jNwFue8HphmcOQssMFb7A0iC605Oq9DzWFsrYvR3+mK+F
 8FUK5DULcarycw7pPDFs+/c/oOo2W4EzHtv8xSw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Aug 2024 00:58:31 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Aug 2024 01:58:35 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Nick Neumann <nick@pcpartpicker.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 7/9] doc: describe the log_issue_time option
Date: Thu, 29 Aug 2024 17:58:24 +0900
Message-ID: <20240829085826.999859-8-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
References: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
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

