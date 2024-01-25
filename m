Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E1610A01
	for <fio@vger.kernel.org>; Thu, 25 Jan 2024 06:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706165246; cv=none; b=r8myd6lXDB3yLZ2Hp/iepiJ+9Z7bUlCwN+klNDCxRDLq5KM+gbG7cRmv8WoMoeVUfrQPBe7pj4DVXRd7EJqqhc4SHU56KhI+l1aCnqBNZ6/oVT1BbjNyglDe7ip/jcMS5aLMtME+CITkJ/Oij32L612PA5+6cfQY8/f0DsUYHBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706165246; c=relaxed/simple;
	bh=mzeAik/9hwC3RL5BPc3shIaKBwetm3d7fAs1QgbiMuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dwlXlHmKiy4rDBClR2/aNzDuv477zB8GxUXSzGp49WF9IBYet61yYf3Cq3+scJ4IGMPGoEJcaeRtU5/ZvE9YJzuuvZv29JNSJdARru6o2QmqKQTHi5m7NfqwBURfM6NGmmwmhFZkE8/M1OxULxwHKAFYtXahX1N0RTZC0B/Xxcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bJufwi+o; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bJufwi+o"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240125064721epoutp040d87226232240e930842c28f3ee47e2c~thD9qdpsh0360903609epoutp04m
	for <fio@vger.kernel.org>; Thu, 25 Jan 2024 06:47:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240125064721epoutp040d87226232240e930842c28f3ee47e2c~thD9qdpsh0360903609epoutp04m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706165241;
	bh=D3bEauRLjTrW9umdaEnBvTf/ONSFcBfofoYYi8Zq+Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJufwi+oPSbS6fAevRc09Kl4K1+ovEORjBiHxL89/MDfEhdd9NvoXnl7Qyql1Q0L+
	 dm8qqgVQVmvkp9S5AYwKq5jmsU454LQtmwLcNqt+LoD1sq66pNDhdpse0TuWSu/YKJ
	 ZbeFNE4DQkGh4e43HbXXB/Vu5azNqLYTLt2uiWh0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240125064721epcas5p19b7e89cbb8a6c7e9011012032e9d74aa~thD9LbxF91606316063epcas5p1D;
	Thu, 25 Jan 2024 06:47:21 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4TLBFy6hflz4x9Pq; Thu, 25 Jan
	2024 06:47:18 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	45.E4.08567.6F302B56; Thu, 25 Jan 2024 15:47:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240125054352epcas5p27caba875a26bd7a0427c1ffc791eae5b~tgMh-IfTK2910129101epcas5p2Z;
	Thu, 25 Jan 2024 05:43:52 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240125054352epsmtrp2118fade56d270de73c861de7da41e1fa~tgMh_n7_A2330323303epsmtrp2X;
	Thu, 25 Jan 2024 05:43:52 +0000 (GMT)
X-AuditID: b6c32a44-617fd70000002177-75-65b203f6f856
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	54.90.18939.815F1B56; Thu, 25 Jan 2024 14:43:52 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240125054351epsmtip188041b801b6a2d53a470e545737e89fd~tgMhGy0QO2817128171epsmtip1V;
	Thu, 25 Jan 2024 05:43:51 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 2/2] docs: update fio man page for log_window_value
Date: Thu, 25 Jan 2024 16:31:24 +0530
Message-Id: <20240125110124.55137-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240125110124.55137-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmuu435k2pBjvnG1usufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdsfjlKraCZpOKWc8OsDYwHtPqYuTk
	kBAwkTiw8ghLFyMXh5DAbkaJq3tWMkE4nxglWmbNYYFzHv5pBcpwgLU8W6MOEd/JKLH951V2
	CKeTSeL5gseMIHPZBLQlXr29wQzSICKgIbHmbipImFnATuLq4ZdsIGFhATeJo5tzQMIsAqoS
	u7+2MYPYvAI2Ese/XmWFuE5eYual7+wgNqeArcT7/v/sEDWCEidnPmGBGCkv0bx1NjPICRIC
	h9glVm++zQhxp4vEueuyEHOEJV4d38IOYUtJfH63lw3CzpbY9PAnE4RdIHHkRS8zhG0v0Xqq
	H+x6ZgFNifW79CHCshJTT61jgljLJ9H7+wlUK6/EjnkwtqrE33u3WSBsaYmb765C2R4Smy5d
	ZoOE1ARGiU+3trJMYFSYheSdWUjemYWwegEj8ypGydSC4tz01GTTAsO81HJ4FCfn525iBKdA
	LZcdjDfm/9M7xMjEwXiIUYKDWUmE18R0Y6oQb0piZVVqUX58UWlOavEhRlNgeE9klhJNzgcm
	4bySeEMTSwMTMzMzE0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGpg05ujOV53ldciR
	5UuFN4P3Fo6PC3rCNr0/WdTMnJB682d3TPXtEinVgpiebG/fCfNf3RKd7jDJbrXM4TCd7Rop
	xXHbDfw0UyIaE1bKXLe6aPdZWmtK0q/gQ6dvCW3/usvu8otwG/ZXRmu0ju05zt27ZM2NMK24
	mpWcVV9lkvv03lY8PaOme+Ls5CQuVR2dJ5pBEvfFpnoV1Cj1zz289PGW5/9LC83/+HZ/myBe
	o/36K7da+jLtWX+51a++lT4kfqmClftYUa7iJ/MHzz+K5ji9e7lq8spJR7k3KL8WN5cPOrBj
	48GzedMaLk2XX7Jgd8yOlh0qrw7HmYT7r0nIfbtDS7Pf+wfzWc+I/Kmls78qsRRnJBpqMRcV
	JwIAA8YwHwoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsWy7bCSnK7E142pBtsvCFusufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWx+OUqtoJm
	k4pZzw6wNjAe0+pi5OCQEDCReLZGvYuRi0NIYDujxMcTBxkh4tISC9cndjFyApnCEiv/PWeH
	qGlnklhw9DojSIJNQFvi1dsbzCC2iICWxLF1TWwgNrOAg8S/XVvYQOYIC7hJHN2cAxJmEVCV
	2P21DaycV8BG4vjXq6wQ8+UlZl76zg5icwrYSrzv/w9mCwHVNH/5yQZRLyhxcuYTFojx8hLN
	W2czT2AUmIUkNQtJagEj0ypG0dSC4tz03OQCQ73ixNzi0rx0veT83E2M4ODUCtrBuGz9X71D
	jEwcjIcYJTiYlUR4TUw3pgrxpiRWVqUW5ccXleakFh9ilOZgURLnVc7pTBESSE8sSc1OTS1I
	LYLJMnFwSjUwlXe/l6vzOcq24ew7v43vlhX4HY+I7bg/j2U/3635hapMLVOcHO/OXBEy/Ssn
	X8Wj/bdn9foV5708+J7pzl1xfRnbv29POtgaRWZP1LkUJVOk4PgucQ97Nc/KT3FzNX4x+/9w
	Dm78aei86KN5UqrZy6m1+7hrWl7f0b55/aPZpP7iqDJ/lUdGb/dMeH38UsU33vB9z22/V22a
	l3TzjeCVEtkI17kBf734fLPUvxyds3jdsuR516pFulr/SSW+d59sN2vSl2q52YVtPcm56y+6
	3LdU65rxbumjEH9Zydr76n9fPTsxL2pFZeGZbcsvpE3/lhO3Kr5nRojtw7IDve1Rv+6uKj8h
	cfGs1gqf25dr3ZRYijMSDbWYi4oTAWg72gW9AgAA
X-CMS-MailID: 20240125054352epcas5p27caba875a26bd7a0427c1ffc791eae5b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240125054352epcas5p27caba875a26bd7a0427c1ffc791eae5b
References: <20240125110124.55137-1-ankit.kumar@samsung.com>
	<CGME20240125054352epcas5p27caba875a26bd7a0427c1ffc791eae5b@epcas5p2.samsung.com>

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 45 +++++++++++++++++++++++++++++++++++----------
 fio.1     | 47 +++++++++++++++++++++++++++++++++++++----------
 2 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index d0ba8021..dcea1ea1 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4067,7 +4067,7 @@ Measurements and reporting
 	I/O that completes. When writing to the disk log, that can quickly grow to a
 	very large size. Setting this option makes fio average the each log entry
 	over the specified period of time, reducing the resolution of the log.  See
-	:option:`log_max_value` as well. Defaults to 0, logging all entries.
+	:option:`log_window_value` as well. Defaults to 0, logging all entries.
 	Also see `Log File Formats`_.
 
 .. option:: log_hist_msec=int
@@ -4088,11 +4088,28 @@ Measurements and reporting
 	histogram logs contain 1216 latency bins. See :option:`write_hist_log`
 	and `Log File Formats`_.
 
-.. option:: log_max_value=bool
+.. option:: log_window_value=int, log_max_value=int
 
-	If :option:`log_avg_msec` is set, fio logs the average over that window. If
-	you instead want to log the maximum value, set this option to 1. Defaults to
-	0, meaning that averaged values are logged.
+	If :option:`log_avg_msec` is set, fio by default logs the average over that
+	window. This option determines whether fio logs the average, maximum or
+	both the values over the window. This only affects the latency logging,
+	as both average and maximum values for iops or bw log will be same.
+	Accepted values are:
+
+		**avg**
+			Log average value over the window. The default.
+
+		**max**
+			Log maximum value in the window.
+
+		**both**
+			Log both average and maximum value over the window.
+
+		**0**
+			Backward-compatible alias for **avg**.
+
+		**1**
+			Backward-compatible alias for **max**.
 
 .. option:: log_offset=bool
 
@@ -5061,11 +5078,19 @@ toggled with :option:`log_offset`.
 by the ioengine specific :option:`cmdprio_percentage`.
 
 Fio defaults to logging every individual I/O but when windowed logging is set
-through :option:`log_avg_msec`, either the average (by default) or the maximum
-(:option:`log_max_value` is set) *value* seen over the specified period of time
-is recorded. Each *data direction* seen within the window period will aggregate
-its values in a separate row. Further, when using windowed logging the *block
-size* and *offset* entries will always contain 0.
+through :option:`log_avg_msec`, either the average (by default), the maximum
+(:option:`log_window_value` is set to max) *value* seen over the specified period
+of time, or both the average *value* and maximum *value1* (:option:`log_window_value`
+is set to both) is recorded. The log file format when both the values are reported
+takes this form:
+
+    *time* (`msec`), *value*, *value1*, *data direction*, *block size* (`bytes`),
+    *offset* (`bytes`), *command priority*
+
+
+Each *data direction* seen within the window period will aggregate its values in a
+separate row. Further, when using windowed logging the *block size* and *offset*
+entries will always contain 0.
 
 
 Client/Server
diff --git a/fio.1 b/fio.1
index 8f659f1d..718aed80 100644
--- a/fio.1
+++ b/fio.1
@@ -3764,7 +3764,7 @@ By default, fio will log an entry in the iops, latency, or bw log for every
 I/O that completes. When writing to the disk log, that can quickly grow to a
 very large size. Setting this option makes fio average the each log entry
 over the specified period of time, reducing the resolution of the log. See
-\fBlog_max_value\fR as well. Defaults to 0, logging all entries.
+\fBlog_window_value\fR as well. Defaults to 0, logging all entries.
 Also see \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_hist_msec \fR=\fPint
@@ -3782,10 +3782,28 @@ the histogram logs enabled with \fBlog_hist_msec\fR. For each increment
 in coarseness, fio outputs half as many bins. Defaults to 0, for which
 histogram logs contain 1216 latency bins. See \fBLOG FILE FORMATS\fR section.
 .TP
-.BI log_max_value \fR=\fPbool
-If \fBlog_avg_msec\fR is set, fio logs the average over that window. If
-you instead want to log the maximum value, set this option to 1. Defaults to
-0, meaning that averaged values are logged.
+.BI log_window_value \fR=\fPint "\fR,\fP log_max_value" \fR=\fPint
+If \fBlog_avg_msec\fR is set, fio by default logs the average over that window.
+This option determines whether fio logs the average, maximum or both the
+values over the window. This only affects the latency logging, as both average
+and maximum values for iops or bw log will be same. Accepted values are:
+.RS
+.TP
+.B avg
+Log average value over the window. The default.
+.TP
+.B max
+Log maximum value in the window.
+.TP
+.B both
+Log both average and maximum value over the window.
+.TP
+.B 0
+Backward-compatible alias for \fBavg\fR.
+.TP
+.B 1
+Backward-compatible alias for \fBmax\fR.
+.RE
 .TP
 .BI log_offset \fR=\fPbool
 If this is set, the iolog options will include the byte offset for the I/O
@@ -4797,11 +4815,20 @@ number with the lowest 13 bits indicating the priority value (\fBprio\fR and
 (\fBprioclass\fR and \fBcmdprio_class\fR options).
 .P
 Fio defaults to logging every individual I/O but when windowed logging is set
-through \fBlog_avg_msec\fR, either the average (by default) or the maximum
-(\fBlog_max_value\fR is set) `value' seen over the specified period of time
-is recorded. Each `data direction' seen within the window period will aggregate
-its values in a separate row. Further, when using windowed logging the `block
-size' and `offset' entries will always contain 0.
+through \fBlog_avg_msec\fR, either the average (by default), the maximum
+(\fBlog_window_value\fR is set to max) `value' seen over the specified period of
+time, or both the average `value' and maximum `value1' (\fBlog_window_value\fR is
+set to both) is recorded. The log file format when both the values are reported
+takes this form:
+.RS
+.P
+time (msec), value, value1, data direction, block size (bytes), offset (bytes),
+command priority
+.RE
+.P
+Each `data direction' seen within the window period will aggregate its values
+in a separate row. Further, when using windowed logging the `block size' and
+`offset' entries will always contain 0.
 .SH CLIENT / SERVER
 Normally fio is invoked as a stand-alone application on the machine where the
 I/O workload should be generated. However, the backend and frontend of fio can
-- 
2.25.1

