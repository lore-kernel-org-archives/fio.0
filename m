Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E285697
	for <fio@vger.kernel.org>; Mon, 22 Jan 2024 06:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705904049; cv=none; b=NwFigxlxcur+EKrbBBfMSWUUPv+GhdTSj0TBlNA4p3ADHLaQlFdMmDXvxO4FqlT9Ueo0GZP0rcR0ehINHuA3T7L5AKvuzqryQFBfg0fyCE5++8e8ecpra95tENYlBvQrDT2yMoTHEa2BU1KR/EuyyscGntjoqN8RH0rsRZS2wq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705904049; c=relaxed/simple;
	bh=hmc2+iTbXAbWgwIrFAJwgqXylp/JdpXK0AwOfzyGG0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nyXz57rgEPpTBNjQrRvXhw6FqEm7W04Jy9O8vPeW3xrBlz6s+Hfj9n2GyRi1o1fSxTBmt6wXKPQBCmwqYffX03bTGTlz+t/S9Ygl7uG9X/T5HtyNgPA7b8zQEvwW2xTpma/EDg+5io5jGQSZmkqvMrGDa2ZWM0sFqayBgIV6XiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GV7cVQh4; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GV7cVQh4"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240122061359epoutp03729e8f7adb66b644bd9ad3bbe7ff219a~slq9snu3W1777317773epoutp03N
	for <fio@vger.kernel.org>; Mon, 22 Jan 2024 06:13:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240122061359epoutp03729e8f7adb66b644bd9ad3bbe7ff219a~slq9snu3W1777317773epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705904039;
	bh=2LhUZS+1i/T0Fp7LV+sJUjWjd2h++opUw/7qSAxOGUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GV7cVQh4cIuK4sXIw4/0XXbbefS1nfcxJlfSOFsF6gzJTEykBBs9oMfU4SiWCVylx
	 WIqfOAXlyip9rjQQpZtjvHtw9/hcd2b1Z/Pk4od9Dng2ofT99xWHc2qNJlBcRL+IDr
	 03NxyYIRcAjWfnzPaboVrE1PD4PqEtl3ya42ScRo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240122061358epcas5p4f28ee70b8f8dff069c8c37bb97567627~slq9F2XRe2892928929epcas5p4V;
	Mon, 22 Jan 2024 06:13:58 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TJKfs0T5yz4x9Q7; Mon, 22 Jan
	2024 06:13:57 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A0.19.19369.4A70EA56; Mon, 22 Jan 2024 15:13:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240122060526epcas5p21030269f7690010a4cb98b7ce4e3b729~sljgO7LPJ0892908929epcas5p2Y;
	Mon, 22 Jan 2024 06:05:26 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240122060526epsmtrp2f8697efa5dab496d71433d604275c7b0~sljgOWWfq2013020130epsmtrp2V;
	Mon, 22 Jan 2024 06:05:26 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-a9-65ae07a49223
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	09.3E.07368.6A50EA56; Mon, 22 Jan 2024 15:05:26 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240122060525epsmtip1a3d34cb98d3ef23b6887762a3badc617~sljfgFLE12308423084epsmtip1J;
	Mon, 22 Jan 2024 06:05:25 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/2] docs: update fio man page for log_max_value
Date: Mon, 22 Jan 2024 16:53:00 +0530
Message-Id: <20240122112300.47805-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240122112300.47805-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmlu5S9nWpBvfLLNZc+c1usfpuP5vF
	x1kvmC02tAk6sHjsnHWX3ePy2VKPvi2rGD0+b5ILYInKtslITUxJLVJIzUvOT8nMS7dV8g6O
	d443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2qekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8u
	sVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM6YuE214KtqxbRJ7ewNjN/kuhg5OSQE
	TCQWL/7O1MXIxSEksIdRov3MGnYI5xOjxMbdjawQzjdGiR9LOplgWu6+7GCBSOxllLhx+BUb
	hNPJJHHlZy8LSBWbgLbEq7c3mLsYOThEBDQk1txNBQkzC9hJXD38kg3EFhZwkHje9R5sKIuA
	qsSDKRPAWnkFbCQ+PTjHArFMXmLmpe/sIDangK3E/X8vmCFqBCVOznzCAjFTXqJ562xmkBsk
	BI6xSyz7sYwRotlF4sPv01BXC0u8Or6FHcKWkvj8bi8bhJ0tsenhT6iaAokjL3qZIWx7idZT
	/WD3MwtoSqzfpQ8RlpWYemodE8RePone30+gWnkldsyDsVUl/t67DXW/tMTNd1ehbA+Jl+v6
	WEFsIYEJjBLNi0omMCrMQvLOLCTvzELYvICReRWjVGpBcW56arJpgaFuXmo5PJKT83M3MYKT
	oFbADsbVG/7qHWJk4mA8xCjBwawkwsuvuipViDclsbIqtSg/vqg0J7X4EKMpMMAnMkuJJucD
	03BeSbyhiaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1MM+fPWsvD8ma3
	G+MD3VkvNnOrbxWedcdq6rEZ3Te+KfUsnWhXK6apli3x712va0GAcH6D3fvey1np2wVl/sXf
	/CPwcu2ujCOXu9+Zr44RTX72dNKdCQkJ3K2y560aHu9oz7GbZD+rzTHZU3vm50MqPaeWWEy6
	dPKEzrOC39tPn16e1rjS89qF47fOMfdoBfzn+DtdNe9Zytwrq6f1fDt+XbIuR3Umx9pVWz5r
	yTCLzvOzPh8S4iN6ofX2jknfTzIsyf4b/fL2F1X7hKJrCsFnqjdfWeOeejTe4vf7r59bdn+7
	sDi3Zc77E6lKVx5KrXzAJlQWFtVrkOd6etMnLmPr/oMla43yGUNFBabaLm6ZWqTEUpyRaKjF
	XFScCAAoa0TbCwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSnO4y1nWpBu+vC1qsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUxcZtqwVfV
	immT2tkbGL/JdTFyckgImEjcfdnB0sXIxSEksJtR4t+TGUxdjBxACWmJhesTIWqEJVb+e84O
	UdPOJDH35DZmkASbgLbEq7c3wGwRAS2JY+ua2EBsZgEHiX+7toDZwkD28673TCA2i4CqxIMp
	E1hAbF4BG4lPD86xQCyQl5h56Ts7iM0pYCtx/98LsJlCQDWnN0Ds4hUQlDg58wkLxHx5ieat
	s5knMArMQpKahSS1gJFpFaNkakFxbnpusmGBYV5quV5xYm5xaV66XnJ+7iZGcJhqaexgvDf/
	n94hRiYOxkOMEhzMSiK8/KqrUoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzGs6YnSIkkJ5Ykpqd
	mlqQWgSTZeLglGpgCu02TZQqnvvr7+ztJ4vyeANXf0774sswX85c7ciWctnO+HfdwVWV6ZoG
	zjnXJHM/PA/75hj2O/BwOIdw/Pzq+Hc96XLT17y72BBmfV9oqm6P+KwpSmYJBz5WvezVNk/Q
	/7njuQVz4bEnlyPn6DpenFJtozDtWRbv9oKghVnmrzeHNSu2m+v87dcPeGr+pvTQj/5qkRJv
	v5/Lnyo3PQmcvvfeyrbgfptFEUaWp+4c/D+18Mann+vl/5U0WbtrJ+2LWfDx4Ss12SlLPs9/
	4P7GddP6HzsFgrWNp7iuaTL5nXSRMcvmeu3T6eG3BZU63FZNPeGZJ55aPFPP9ue1pTO/eeTk
	BVl+zu46PGuRo+Z8JZbijERDLeai4kQAPCZL6MICAAA=
X-CMS-MailID: 20240122060526epcas5p21030269f7690010a4cb98b7ce4e3b729
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240122060526epcas5p21030269f7690010a4cb98b7ce4e3b729
References: <20240122112300.47805-1-ankit.kumar@samsung.com>
	<CGME20240122060526epcas5p21030269f7690010a4cb98b7ce4e3b729@epcas5p2.samsung.com>

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 23 ++++++++++++++++-------
 fio.1     | 29 ++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 847c0356..9db27de0 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4088,11 +4088,12 @@ Measurements and reporting
 	histogram logs contain 1216 latency bins. See :option:`write_hist_log`
 	and `Log File Formats`_.
 
-.. option:: log_max_value=bool
+.. option:: log_max_value=int
 
 	If :option:`log_avg_msec` is set, fio logs the average over that window. If
-	you instead want to log the maximum value, set this option to 1. Defaults to
-	0, meaning that averaged values are logged.
+	you instead want to log the maximum value, set this option to 1. If you
+	want to log both the average and maximum value, set this option to 2.
+	Defaults to 0, meaning that averaged values are logged.
 
 .. option:: log_offset=bool
 
@@ -5062,10 +5063,18 @@ by the ioengine specific :option:`cmdprio_percentage`.
 
 Fio defaults to logging every individual I/O but when windowed logging is set
 through :option:`log_avg_msec`, either the average (by default) or the maximum
-(:option:`log_max_value` is set) *value* seen over the specified period of time
-is recorded. Each *data direction* seen within the window period will aggregate
-its values in a separate row. Further, when using windowed logging the *block
-size* and *offset* entries will always contain 0.
+(:option:`log_max_value` is set to 1) *value* seen over the specified period of time
+is recorded. From fio version 3.37 onwards you can record both the average *value*
+and maximum *value1* (:option:`log_max_value` is set to 2), and the log file format
+takes this form:
+
+    *time* (`msec`), *value*, *value1*, *data direction*, *block size* (`bytes`),
+    *offset* (`bytes`), *command priority*
+
+
+Each *data direction*
+seen within the window period will aggregate its values in a separate row. Further,
+when using windowed logging the *block size* and *offset* entries will always contain 0.
 
 
 Client/Server
diff --git a/fio.1 b/fio.1
index 8f659f1d..92a6d70b 100644
--- a/fio.1
+++ b/fio.1
@@ -3782,10 +3782,11 @@ the histogram logs enabled with \fBlog_hist_msec\fR. For each increment
 in coarseness, fio outputs half as many bins. Defaults to 0, for which
 histogram logs contain 1216 latency bins. See \fBLOG FILE FORMATS\fR section.
 .TP
-.BI log_max_value \fR=\fPbool
+.BI log_max_value \fR=\fPint
 If \fBlog_avg_msec\fR is set, fio logs the average over that window. If
-you instead want to log the maximum value, set this option to 1. Defaults to
-0, meaning that averaged values are logged.
+you instead want to log the maximum value, set this option to 1. If you want
+both the average and maximum value, set this option to 2. Defaults to 0,
+meaning that averaged values are logged.
 .TP
 .BI log_offset \fR=\fPbool
 If this is set, the iolog options will include the byte offset for the I/O
@@ -4756,8 +4757,8 @@ time (msec), value, data direction, block size (bytes), offset (bytes),
 command priority
 .RE
 .P
-`Time' for the log entry is always in milliseconds. The `value' logged depends
-on the type of log, it will be one of the following:
+`Time' for the log entry is always in milliseconds. The `value' and `value1'
+logged depends on the type of log, it will be one of the following:
 .RS
 .TP
 .B Latency log
@@ -4798,10 +4799,20 @@ number with the lowest 13 bits indicating the priority value (\fBprio\fR and
 .P
 Fio defaults to logging every individual I/O but when windowed logging is set
 through \fBlog_avg_msec\fR, either the average (by default) or the maximum
-(\fBlog_max_value\fR is set) `value' seen over the specified period of time
-is recorded. Each `data direction' seen within the window period will aggregate
-its values in a separate row. Further, when using windowed logging the `block
-size' and `offset' entries will always contain 0.
+(\fBlog_max_value\fR set to 1) `value' seen over the specified period of time
+is recorded. From fio version 3.37 onwards you can record both the average `value'
+and maximum `value1' (\fBlog_max_value\fR set to 2), and the log file format takes
+this form:
+.RS
+.P
+time (msec), value, value1, data direction, block size (bytes), offset (bytes),
+command priority
+.RE
+.P
+Each `data direction' seen
+within the window period will aggregate its values in a separate row. Further,
+when using windowed logging the `block size' and `offset' entries will always
+contain 0.
 .SH CLIENT / SERVER
 Normally fio is invoked as a stand-alone application on the machine where the
 I/O workload should be generated. However, the backend and frontend of fio can
-- 
2.25.1

