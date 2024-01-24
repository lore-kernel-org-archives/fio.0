Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B791640B
	for <fio@vger.kernel.org>; Wed, 24 Jan 2024 07:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080433; cv=none; b=ChrCvtcmRLRHu+gHDu0Yt8G8Y8Jx1dSPrYPYBU6TISl8TjXbpzOZpgpM2wuaINl6gTlk7Hg6yX8W0Z0yGDepqIIwMfAFtEybJ+CE7On4w9tyMQXO4x5g0tXBtUthLocNPP2xVxXFnHnQyMDdRrKv884ERv4EJay1j2xFl6vZ1xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080433; c=relaxed/simple;
	bh=vGAaZfsstap0ZRNlbVApw8w/lw9dclGpPTFPSoctKxg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rZOM4Pl3jt0k/Tn0CL4vpTx9aSZqgXIw8Cc+fbsNOd7n3Cuav24oUuTrx6YI3S03qs8SWytAfBsckLfw5bl0eV1XpaxAps81iL1dmMd6VJVvSx2eVjEHsiQfcR/O2YKWui+RAT/GwKTlYxTaG7zY4tckiBnBQOqdm4wZQCnYjgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=p8n94vwB; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="p8n94vwB"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240124071348epoutp02096f34eee342b888f42ead41dc9d2ceb~tNxxG7fd93238932389epoutp02e
	for <fio@vger.kernel.org>; Wed, 24 Jan 2024 07:13:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240124071348epoutp02096f34eee342b888f42ead41dc9d2ceb~tNxxG7fd93238932389epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706080428;
	bh=j06Z4lfQDRraaJ/K8xVJBbge4DSApwyFzRUkeHowbkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8n94vwBAgWH44RX2ZYkYqXUFvGU+pt3IQwt6OaZCzrJY/Y3527xcSr/8gaSUDHMD
	 1VRBD8E0CmE7b3gp/hEQyvjG6No4fOjgKIkiwypgTEEV8D1KIzLt/poO/hNElU19CL
	 C0izaqxgJw9hjStzTxGw4arDSo08zJOKIj7FRDv0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240124071348epcas5p457b4a3ce96dc5916d338ef0c92305c5c~tNxw5_C_H2966129661epcas5p47;
	Wed, 24 Jan 2024 07:13:48 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4TKZty31kdz4x9Pr; Wed, 24 Jan
	2024 07:13:46 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	07.B8.08567.AA8B0B56; Wed, 24 Jan 2024 16:13:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240124061716epcas5p3c60fd0138f74a40bd020f1f31a298a07~tNAaDmNu71701817018epcas5p3e;
	Wed, 24 Jan 2024 06:17:16 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240124061716epsmtrp1fbb6251c484e598310be8e43c7c49a41~tNAaC-phx0248402484epsmtrp1B;
	Wed, 24 Jan 2024 06:17:16 +0000 (GMT)
X-AuditID: b6c32a44-3abff70000002177-35-65b0b8aa0ceb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AD.28.07368.C6BA0B56; Wed, 24 Jan 2024 15:17:16 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240124061715epsmtip1d863a0e1a3976fb15a8112a3a2858659~tNAZRZJRe1272112721epsmtip1a;
	Wed, 24 Jan 2024 06:17:15 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 2/2] docs: update fio man page for log_window_value
Date: Wed, 24 Jan 2024 17:04:13 +0530
Message-Id: <20240124113413.52550-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240124113413.52550-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmpu6qHRtSDdp+C1usufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdsWvOD6aCHeYV/1/zNzAu1O1i5OSQ
	EDCRuP90ElMXIxeHkMBuRoln3zqhnE+MEpNb17BAON8YJZ58vwfkcIC1XHshDRHfyyjxtOkC
	M4TTySSx5tt0FpC5bALaEq/e3mAGaRAR0JBYczcVJMwsYCdx9fBLNhBbWMBNomPfD3YQm0VA
	VeL/q1ZWEJtXwEZi4qWdTBDnyUvMvPQdrIZTwFZiy7ZjjBA1ghInZz5hgZgpL9G8dTbYDRIC
	x9glvu97zALR7CJxZ+1JqEHCEq+Ob2GHsKUkXva3QdnZEpse/oSqKZA48qKXGcK2l2g91Q92
	P7OApsT6XfoQYVmJqafWMUHs5ZPo/f0EqpVXYsc8GFtV4u+921AnSEvcfHcVyvaQ+NV2BBq6
	ExglVkxvYp3AqDALyT+zkPwzC2H1AkbmVYySqQXFuempyaYFhnmp5fA4Ts7P3cQIToJaLjsY
	b8z/p3eIkYmD8RCjBAezkgjvDcl1qUK8KYmVValF+fFFpTmpxYcYTYEBPpFZSjQ5H5iG80ri
	DU0sDUzMzMxMLI3NDJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYJpurLtn+rPKadMTd30+
	uVXfo+92ydu1k6Y6qTFtdLq6VEK/+vene45Mz9W8b7Nem2N+MaJVsiUvg2FXWlP3/IbgbcYR
	2poMrttaNh67oHXuxKIfZ5XXVt5lXaXDHXpzYej08w828L7u6/MyTHVWPnqlVHXqzdqOt7I8
	zwy6w9Y8eSsk2Jqdyyjt8/OngVru02c+3Xnu4Ulml501wyVc2P1/uYr9O6tdwaZ0KeJ6t8Xz
	3Tv2On5RuMRp9HSaX+riazJTZu476mN16ax6auai5adbFv45m1tnUh2qaCF6yLBivZ0EX8Ya
	Vcm87zlb/ym5bDjXZlqU6vo7JCdb6fFc8Y9ntr1PDgtfx33K+c9bAyWW4oxEQy3mouJEAJMk
	tq4LBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSnG7O6g2pBt0nhSzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MrYNecHU8EO
	84r/r/kbGBfqdjFycEgImEhceyHdxcjFISSwm1Hi1LypTBBxaYmF6xO7GDmBTGGJlf+es0PU
	tDNJtEx7zgySYBPQlnj19gaYLSKgJXFsXRMbiM0s4CDxb9cWMFtYwE2iY98PdhCbRUBV4v+r
	VlYQm1fARmLipZ1MEAvkJWZe+g5WwylgK7Fl2zFGEFsIqObwtidMEPWCEidnPmGBmC8v0bx1
	NvMERoFZSFKzkKQWMDKtYpRMLSjOTc9NNiwwzEst1ytOzC0uzUvXS87P3cQIDlItjR2M9+b/
	0zvEyMTBeIhRgoNZSYT3huS6VCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8hjNmpwgJpCeWpGan
	phakFsFkmTg4pRqYZDdv4qw4dLdWzspOSsTluHevkagoq61PUMXfoimytRWHn6QvFw3OnW37
	PLnZNKBSUPLkKt6yW1Z8F3s9epcWL/twiMFqW+eSG3vabS4HOPG5XviceviUsp2Kv5je3R1X
	3hyZ2Vq2YqaLbfN+o5lpOqEMx3mvzFojzy268NyX9cf4/DJEUkI1Hwh/fV7rb7P2rUvXb4W6
	5hkJL0QYE1/3PVCt+3hnyRQ7p8L/sh/2X+B+dW51g+UORelV25estApav0O55Phez5S5TxZO
	r7T4u6jjTry2m/tm/WXTb19N+uSmsG2/VfECPtWKudfUbDJ3PjQ79Crk+vQ75xkNF5kvfiU3
	+U359VOrl306+iFNS4mlOCPRUIu5qDgRAHhmTFjBAgAA
X-CMS-MailID: 20240124061716epcas5p3c60fd0138f74a40bd020f1f31a298a07
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240124061716epcas5p3c60fd0138f74a40bd020f1f31a298a07
References: <20240124113413.52550-1-ankit.kumar@samsung.com>
	<CGME20240124061716epcas5p3c60fd0138f74a40bd020f1f31a298a07@epcas5p3.samsung.com>

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst | 45 +++++++++++++++++++++++++++++++++++----------
 fio.1     | 52 ++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 75 insertions(+), 22 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index d0ba8021..f83a8b53 100644
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
+through :option:`log_lat_msec`, either the average (by default), the maximum
+(:option:`log_window_value` is set to max) *value* seen over the specified period
+of time, or both the average *value* and maximum *value1* (:option:`log_window_value`
+set to both) is recorded. The log file format when both the values are reported
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
index 8f659f1d..6f1a46fd 100644
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
@@ -4756,8 +4774,8 @@ time (msec), value, data direction, block size (bytes), offset (bytes),
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
@@ -4797,11 +4815,21 @@ number with the lowest 13 bits indicating the priority value (\fBprio\fR and
 (\fBprioclass\fR and \fBcmdprio_class\fR options).
 .P
 Fio defaults to logging every individual I/O but when windowed logging is set
-through \fBlog_avg_msec\fR, either the average (by default) or the maximum
-(\fBlog_max_value\fR is set) `value' seen over the specified period of time
-is recorded. Each `data direction' seen within the window period will aggregate
-its values in a separate row. Further, when using windowed logging the `block
-size' and `offset' entries will always contain 0.
+through \fBlog_avg_msec\fR, either the average (by default), the maximum
+(\fBlog_window_value\fR set to max) `value' seen over the specified period of
+time, or both the average `value' and maximum `value1' (\fBlog_window_value\fR set
+to both) is recorded. The log file format when both the values are reported
+takes this form:
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

