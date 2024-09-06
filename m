Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC0827450
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 02:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725590247; cv=none; b=uayxitVQOg1+ICWjiWY/J0XKybVN4bY9b8dDw42a2+RXGW0AwgJymgvnLL/dTXpOx4Zv4zBYAc+vf7CgzVTUsgpJF8wRLX0feW2HSX0B5kfdReLBqNgjrgXTPiqtEWv6G61GHkVNK56/UJBR1umFhM9ksA5l+9XL/D2/alxOUCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725590247; c=relaxed/simple;
	bh=F48ZpC2yYFohJOZD3ZgU6Q2imO2BO5gN9n0n2cWilas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CIrXKPLSPTBGrgxHHezsJ3+JKqhJOnGwUngDKV6uzTq2Wj777Im+/eO9YeLk5NczG4i7Xwd/wekyy6xnT4RlCh0jR9K/N4T/b05w22DpbOM7lMqoXeiXwRpoxeSB93AYZZXhykm3RmWWd0C2k8dN3OJBGzB10hfwuM4egNPAAsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=g+rT15Rw; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="g+rT15Rw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1725590245; x=1757126245;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F48ZpC2yYFohJOZD3ZgU6Q2imO2BO5gN9n0n2cWilas=;
  b=g+rT15Rw92LMC0UyWHJXBNjngG1goAnU45KQUCUR7OiB7xsnXcP7JLKg
   6fi290/tbI9oEYULWmLbtk7TM4k36PmPaW1Bj2vWEfXBZOJpotzN+nLsB
   5stl876jHJuL0VRA9RLzWL49uXah8hv57hxzLE5w8MQftcelDOa6Br1ft
   MZ97AkZGzEaVd7XlztxK6EqlrwAzmo6Flbrpk3kodyGYwbCHKfxfDrYOv
   fk6pcLLKYOPn5xzV7lEtr4cv/UcoW8FjYJbfQzQ58T0SlhaJ5rEm+Mi10
   Iu7u2zAx2wz89KOEpzC/qfiqffIT2P3yC8dm+z3vmIUVKl+RqGvFPDrqf
   Q==;
X-CSE-ConnectionGUID: 2fZ3a9FbQSOTjsuWUprhcQ==
X-CSE-MsgGUID: XzhNtFVzRIOyVXl6Yz4ZYg==
X-IronPort-AV: E=Sophos;i="6.10,206,1719849600"; 
   d="scan'208";a="26440237"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2024 10:37:18 +0800
IronPort-SDR: 66da5cc0_rbctqceIzPhjwtYE9aBCCoKaLglP69DKFF6pPR3GeL8jnyb
 jI4QamUHwibVyFvhBLV2SoDYZft12iS17gVAR2g==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2024 18:37:04 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2024 19:37:18 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] stat: fix the null io_u dereference in add_clat_sample()
Date: Fri,  6 Sep 2024 11:37:15 +0900
Message-ID: <20240906023717.1464031-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 14d3134a5fc0 ("introduce the log_issue_time option") introduced a
null pointer dereference failure. The first patch fixes it, and the
second patch adds the test to confirm the fix.

Shin'ichiro Kawasaki (2):
  stat: fix the null io_u dereference in add_clat_sample()
  t/jobs/t0035: add test for the file operations IO engine

 stat.c             |  7 +++++--
 t/jobs/t0035.fio   | 27 +++++++++++++++++++++++++++
 t/run-fio-tests.py | 10 ++++++++++
 3 files changed, 42 insertions(+), 2 deletions(-)
 create mode 100644 t/jobs/t0035.fio

-- 
2.45.2

