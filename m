Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224DF1854
	for <fio@vger.kernel.org>; Tue, 27 Aug 2024 07:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742541; cv=none; b=RXcXWE3evW32EGg8BiI8DPVb6geB/4D/ctbZAC6jgsnKNmpUqncwPRMh+6MYFiSefh1Rm3YWcCLtDYlNeXAa9GF9/zrKzByGs+GP5b0+XiN/1/LAOrXPZ66oL8Z8zVUxoZ8vj/1G4gx07wz+hviN4pOqohnAaKJU4qv3HbRvVvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742541; c=relaxed/simple;
	bh=r/QEMcab38sPDThAVZirvT+j54qWQjSfRORb3qP6Gd4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JnLB701hnjrpgiDJdmR/3fqa62h21pu7IXqg/Hu/Y520osM8VkKq+ipizOH0PLiA/zrh22zbVeJ73Y6uQJImHJVCerKVkUL5PpJZs1I3PWzh1bOIY3Up2kVOtz9FtmdFiF32bzrxzXfuLIH1HmKpj3AudTUeENfa5r0PRyHVCQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UQqVc2Pd; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UQqVc2Pd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724742539; x=1756278539;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r/QEMcab38sPDThAVZirvT+j54qWQjSfRORb3qP6Gd4=;
  b=UQqVc2PdMqIf2CgvcfMz7zAGXDUJmhCCRVB4M2aUTCalDdv9tGfSxPiV
   3HGotiMZ6PBfxun+4QosyNEVq86kQH4pjAO/mFYpPhdy6uzQsuEevEUzb
   tw6FEQNp37d8GF/HP6eWxu1GSV4tGxGZR+p5MaPj5tQN33bBydx5nGK6Q
   q9AkslSMl7TSSCIOLNzNYnlfRUUvd+PC9zGS1wzdZeJ+4MqyOGs/rNYcP
   YGz1qv1++ld0k/UrufrqGsLhD3oHu9u6wf/iXGiQYDd9HWoP7veGwqsZz
   +Ov7sUNriuyW2tHdgy7oXpXtLQn0gW0f6FWZ9eXqhFlamFPxR9CTibplt
   w==;
X-CSE-ConnectionGUID: 3FEP3RmBSOG3hlDBcAgJTw==
X-CSE-MsgGUID: LjTFUnrhRs6AL4oGYObRBA==
X-IronPort-AV: E=Sophos;i="6.10,179,1719849600"; 
   d="scan'208";a="25297866"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2024 15:08:51 +0800
IronPort-SDR: 66cd6ec5_ikFUsNY/KokGxRfNHYFXD8E6O06Bbwd7H99KGJIblphXQtZ
 CPudHfz9PlFRZW0XDPwhSMVv7SGn9A3c6lPzxuQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2024 23:14:30 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2024 00:08:51 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/9] introduce the log_issue_time option
Date: Tue, 27 Aug 2024 16:08:41 +0900
Message-ID: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
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
too coarse for fast IOs (e.g. when using SSDs). This series proposes the
new option 'log_issue_time' to address the inaccuracy problem. When this
option is set, fio adds another field to the log file entries to log an
IO issuing time in nanoseconds.

The first four patches in the series clean up the current code as
preparation. The 5th patch introduces the 'log_issue_time' option. The
following two patches document the new option. The last two patches add
two test cases to check the log file format.


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
 server.h                 |   1 +
 stat.c                   | 155 ++++++++++++++++++++++++---------------
 stat.h                   |  13 ++--
 t/jobs/t0033.fio         |  28 +++++++
 t/jobs/t0034.fio         |  27 +++++++
 t/run-fio-tests.py       |  66 +++++++++++++++++
 thread_options.h         |   2 +
 18 files changed, 457 insertions(+), 192 deletions(-)
 create mode 100644 t/jobs/t0033.fio
 create mode 100644 t/jobs/t0034.fio

-- 
2.45.2

