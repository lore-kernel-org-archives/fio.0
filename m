Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD9C154423
	for <fio@vger.kernel.org>; Tue, 27 Aug 2024 07:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742545; cv=none; b=olQmhx/z9DFjNeWwILhlPb4Pd7uhZm4eLqTU+1/Iv5wNHveu+qVpKy8d1+mOZR5hAUUgwyu45LWI87AcTlwGq0QfGxiAUhjWLO3ambcBzblWd7RxnHZFP+Pj8VQ/12btal9oE5H2rggLaaQps1DoMLiuaBJrpLxYEBR1UgNafnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742545; c=relaxed/simple;
	bh=4tk1Iq6zIUyXNfJXn+SoQK2AUYcmQCIncMZPa3TXNCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vE9jgwCSAHJepH3sxTlKZLM860M5owIJxn6k+R2UGVvScE9pYO/xG/26xF3LjiRziYxRyKNri3aXmKo+z7LkM/SBZV5P3Jrtdl1X3Ubn/Ajy6XOhyvuyPTRmvPNPw5dyT7Nk2WdAN/WyJRUkx0sSv5p8ihFnf4dG8dpNK5m7iEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mLPrWV+a; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mLPrWV+a"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724742543; x=1756278543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4tk1Iq6zIUyXNfJXn+SoQK2AUYcmQCIncMZPa3TXNCE=;
  b=mLPrWV+aO1X7iE8BKabeL1GW/fnLOCHdQLWWj79Z6vCEaGwn1/CHR8cI
   tVyJLBUsIm3mzlsER350nq5VfTvYzsrgl9f0dN/EEatzG8AesAWVk66x7
   ZiBKmxXw714X+KizuB75Ej12CTz9GD5fR5EXvF0yNDvMKjNgPxoSBuGc4
   tof0OhPTkGoZhPvE7LWu9nRktE4PGOFrXLogvz8frecUOFXhVtFlDJhWk
   ROEOpo1GylQ0R43ARd/5XX2U1p2TEHTUdSJjJXdyF17Du4OaiBTaeKBGu
   rUdR0RrEXtH6mhPKl7vxQccYL7+dVMXDjA2JMm0GH4q8CrplFw36YPU2u
   Q==;
X-CSE-ConnectionGUID: iUlv69JqR4aV4uZCQWCqAA==
X-CSE-MsgGUID: +3lS4a6eQrafk7ZGq4fKCw==
X-IronPort-AV: E=Sophos;i="6.10,179,1719849600"; 
   d="scan'208";a="25297877"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2024 15:08:58 +0800
IronPort-SDR: 66cd6ecc_jfF7fn8+6Wa7YZ3FoyiZDQu0TYmtanJU3nA/e66DCUWPME/
 qqHGPaZvPJjimbfLZtd3KIblXxhSKlQUfKN8Vbg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2024 23:14:36 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2024 00:08:57 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 6/9] doc: fix the descriptions of the log_prio option
Date: Tue, 27 Aug 2024 16:08:47 +0900
Message-ID: <20240827070850.947037-7-shinichiro.kawasaki@wdc.com>
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

Commit 03ec570f6e57 ("fio: Introduce the log_prio option") added the
description of the log_prio option to fio.1. However, the description
was wrong. It mentioned that the log_prio option would change the number
of fields in the Log File Format, but actually it does not do so. Fix
the description.

Also, the commit did not update HOWTO.rst for the log_prio option. To
keep HOWTO.rst same as fio.1, add the missing descriptions to HOWTO.rst.

Fixes: 03ec570f6e57 ("fio: Introduce the log_prio option")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 HOWTO.rst | 19 +++++++++++++++++--
 fio.1     |  7 ++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 11b1c669..49a28464 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4237,6 +4237,13 @@ Measurements and reporting
 	entry as well as the other data values. Defaults to 0 meaning that
 	offsets are not present in logs. Also see `Log File Formats`_.
 
+.. option:: log_prio=bool
+
+	If this is set, the *Command priority* field in `Log File Formats`_
+	shows the priority value and the IO priority class of the command.
+	Otherwise, the field shows if the command has the highest RT
+	priority class or not. Also see	`Log File Formats`_.
+
 .. option:: log_compression=int
 
 	If this is set, fio will compress the I/O logs as it goes, to keep the
@@ -5227,8 +5234,16 @@ The entry's *block size* is always in bytes. The *offset* is the position in byt
 from the start of the file for that particular I/O. The logging of the offset can be
 toggled with :option:`log_offset`.
 
-*Command priority* is 0 for normal priority and 1 for high priority. This is controlled
-by the ioengine specific :option:`cmdprio_percentage`.
+If :option:`log_prio` is not set, the entry's *Command priority* is 1 for an IO
+executed with the highest RT priority class (:option:`prioclass` =1 or
+:option:`cmdprio_class` =1) and 0 otherwise. This is controlled by the
+:option:`prioclass` option and the ioengine specific
+:option:`cmdprio_percentage`  :option:`cmdprio_class` options. If
+:option:`log_prio` is set, the entry's *Command priority* is the priority set
+for the IO, as a 16-bits hexadecimal number with the lowest 13 bits indicating
+the priority value (:option:`prio` and :option:`cmdprio` options) and the
+highest 3 bits indicating the IO priority class (:option:`prioclass` and
+:option:`cmdprio_class` options).
 
 Fio defaults to logging every individual I/O but when windowed logging is set
 through :option:`log_avg_msec`, either the average (by default), the maximum
diff --git a/fio.1 b/fio.1
index 6db76b2c..0aabe89e 100644
--- a/fio.1
+++ b/fio.1
@@ -3943,9 +3943,10 @@ entry as well as the other data values. Defaults to 0 meaning that
 offsets are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_prio \fR=\fPbool
-If this is set, the iolog options will include the I/O priority for the I/O
-entry as well as the other data values. Defaults to 0 meaning that
-I/O priorities are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
+If this is set, the `Command priority` field in \fBLOG FILE FORMATS\fR
+shows the priority value and the IO priority class of the command.
+Otherwise, the field shows if the command has the highest RT priority
+class or not. Also see \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_compression \fR=\fPint
 If this is set, fio will compress the I/O logs as it goes, to keep the
-- 
2.45.2

