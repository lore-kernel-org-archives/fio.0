Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F2118C343
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 08:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724921910; cv=none; b=t1QYICAk5z1b0V43/hr0WzOLL7HldhyrCLuNMYMwKQWnKjCqAfpyuCwVojr/2bvyl6WGU+gkEwTp63lHDKWAOrkWGv5lk3t3ujoAE2IwiRRiC2KqvXndf+y7JUkaOTfb655VcbD43zq35yyXdR3CFm8eHcvE8jVVpSlJu7KG5sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724921910; c=relaxed/simple;
	bh=oT/bd6m5CR4LTTEYwZmcY8RCgfc45soP3gIqqS44AsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sIzcNmNeCge0cDFk9ouQMT8JeqoIbULmKcaeLVwcyJloXy4Gfts3LMSYHzm4a3JinNJnwnKk0IOC5Ip66CI9uLnTw63mPIuZmbaqhONCR+L9XlMUJkcJy9PoMv4Fd3CgvoXtn1GORvnDVB/FgH9Tdvqk40CJWTV32pRNlmRud2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Q3ahVLoR; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q3ahVLoR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724921909; x=1756457909;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oT/bd6m5CR4LTTEYwZmcY8RCgfc45soP3gIqqS44AsQ=;
  b=Q3ahVLoRc5vbwqBccc+GptMcHnKRW4tQJmoIsYpKB+B4kc01/O5GJ4VE
   tECMnk3zwMfX66n+EBVTrdOWb2X9kUPilktx18W1KoQIp/avocTzR5vQ3
   +CwIUF6cB3JsPF/Dn+v6XmUcKXda/UbTAqlFvl/wG62XVEMvIpQ9eK6Ls
   BcVfB5VXDexFmvt1bSm/LPMH4vEW5aoL4SiKLJWQCWgh3A+aBoJZ083XE
   2f6wWI9cCEPYAfKNLzs1zS7nvaII5q84vLEJXSkmG1pobC75h5iB8gHeh
   SEPOTvRBG2j7Nwprm4AOvKG3h2eeOALfPAZc2r9TIjeqX8R4KB2VMfg/w
   A==;
X-CSE-ConnectionGUID: GW/Fwt5kRMeDi9WSRld0EQ==
X-CSE-MsgGUID: In73bwN4Rca27W5AOwMDdw==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="24854814"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 16:58:27 +0800
IronPort-SDR: 66d02a1e_mM4DQR6l/0iAIVg6veAFlTg/zsyMy2gtIKnCx3QCQRUkI6L
 c6IRR6a7+vSkmUp2f9tkvS4SBz3x5qoT0RjAZgQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Aug 2024 00:58:22 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Aug 2024 01:58:26 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Nick Neumann <nick@pcpartpicker.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/9] introduce the log_issue_time option
Date: Thu, 29 Aug 2024 17:58:17 +0900
Message-ID: <20240829085826.999859-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When write_lat_log option is set, fio outputs the 'clat' completion
latency log file. This clat log can be used to analyze IO latency. This
file can also be considered as an IO trace file as each IO entry can
fully describe an IO when the --log_offset and --log_prio options are
also used. However, using the clat log file as an IO trace is inaccurate
because the time field of each entry uses millisecond units, which is
too coarse for fast IOs (e.g. when using SSDs). Also, the time field
value is recorded not at command completion, but at log sample
recording. The time field value is slightly different from the IO
completion time.

This series proposes the new option 'log_issue_time' to address the
inaccuracy problem. When this option is set, fio adds another field to
the log file entries to log an IO issuing time in nanoseconds.

The first four patches in the series clean up the current code as
preparation. The 5th patch introduces the 'log_issue_time' option. The
following two patches document the new option. The last two patches add
two test cases to check the log file format.

Changes from v1:
* 1st: Described add_*lat_sample() arguments in the commit message
* 5th: Incremented FIO_SERVER_VER and fixed typos
* 8th,9th: Added test requirements and extended job runtime/log_avg_msec

Shin'ichiro Kawasaki (9):
  stat: reduce arguments of add_*lat_sample() functions
  stat: reduce arguments of add_log_sample()
  iolog: refactor flush_samples()
  iolog: drop struct io_sample_offset
  introduce the log_issue_time option
  doc: fix the descriptions of the log_prio option
  doc: describe the log_issue_time option
  t/jobs/t0033: add test for the log file format
  t/jobs/t0034: add test for the log_issue_time option

 HOWTO.rst                |  40 ++++++++--
 cconv.c                  |   2 +
 client.c                 |  36 +++++----
 engines/fileoperations.c |   6 +-
 fio.1                    |  26 +++++--
 init.c                   |  12 +++
 io_u.c                   |  14 +---
 iolog.c                  | 154 ++++++++++++++++++++------------------
 iolog.h                  |  47 +++++++++---
 options.c                |  10 +++
 server.c                 |  10 ++-
 server.h                 |   3 +-
 stat.c                   | 155 ++++++++++++++++++++++++---------------
 stat.h                   |  13 ++--
 t/jobs/t0033.fio         |  28 +++++++
 t/jobs/t0034.fio         |  27 +++++++
 t/run-fio-tests.py       |  66 +++++++++++++++++
 thread_options.h         |   2 +
 18 files changed, 458 insertions(+), 193 deletions(-)
 create mode 100644 t/jobs/t0033.fio
 create mode 100644 t/jobs/t0034.fio

-- 
2.45.2

