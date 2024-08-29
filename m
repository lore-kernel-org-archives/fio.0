Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3321E18C336
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 08:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724921918; cv=none; b=h5aOpZpX9FWMq5rjcZvqwwcTK1Ww4gGrGnqKsBX6tBX/f5wCyJnVChWsM+aQdGwkR5qJUNKZbk4qO0VGYTRqqmpp2BhPMHP2oVxoQUq34vc6G7ZIj1AVXZSZo9O8T7F69TNCNr/IGRdpN7tqZ4FkPSUwXE8qo7gVlnT06hHmS2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724921918; c=relaxed/simple;
	bh=4tk1Iq6zIUyXNfJXn+SoQK2AUYcmQCIncMZPa3TXNCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+i5np2Zmz70c7k1+G37D51252SCxxZGk+ve+QKr4rHXbJZVAtQsBZZKa7KSFVL882CAIbuh7/TPhU/wjjpYtmurrx0Jb85aKN3QAmLGhfo3nHljC4t9ubPjWOeAZGBh42Is/Ucg5D1mI8wIGyj/flYS4dLX7x2cjcujkjwj5JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=E8ZyyIMM; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="E8ZyyIMM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724921915; x=1756457915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4tk1Iq6zIUyXNfJXn+SoQK2AUYcmQCIncMZPa3TXNCE=;
  b=E8ZyyIMMJBzdE9/wAHs1eki0HslTpI7BYrTTTMjL5+P7eC7PrH7FDnR3
   TKxj5XZ35qHIjCh/s8eXyxJmeV4fyO07HWozh8bXNG+5pUIALS6ztj+qK
   8cNqmWGQMXw9RSSz0cmtsvkdqp9O87c9Cjyf1wahQcadlLCV7k5ei9sHt
   FY3w3KJ/U0AOSrDZkDM9sKTeoEO/i5KlORNRSkkZRPLmHlXq9wk3jZoRj
   I5I04dzzBzOYooyK6eXtdXTGKNaKdpZr3m8P1VZjWes4ANabQKoY8GC/F
   jakHAWkjojlfp5iMxSl+w+cfS6q2MOwC1Zj7hbsAooICvKecvaY4n4CHo
   w==;
X-CSE-ConnectionGUID: 52mOcX//Qjek8h2cf5lwzw==
X-CSE-MsgGUID: fvNbCRQ+QIqvBHsoneY6xQ==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="24854831"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 16:58:35 +0800
IronPort-SDR: 66d02a25_tra14G6AXALQZ5k+r+zPNLZknnvnL2wvsLvMIHpA4bpfgrK
 P95zIqjI5MjLZ1niUZL0LirVKSSS9S++PQnymVQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Aug 2024 00:58:29 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Aug 2024 01:58:33 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Nick Neumann <nick@pcpartpicker.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 6/9] doc: fix the descriptions of the log_prio option
Date: Thu, 29 Aug 2024 17:58:23 +0900
Message-ID: <20240829085826.999859-7-shinichiro.kawasaki@wdc.com>
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

