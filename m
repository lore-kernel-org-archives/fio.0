Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A50D217659
	for <fio@vger.kernel.org>; Wed, 20 Aug 2025 13:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.152.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755695075; cv=none; b=StzFhFFEW2wfm8fJqRsB1qcB5Lz9ITDKvr9rSR/zPmIcy4vxVekN2lq+Yo6c0RB0RqeiqG22HCD03coPrIBRQm3TXvPTlbZ/aLYXbCb8iBB6O9Sw29nk9+GFBWytCycnb20dLEABrr7lRE0OCMP3qjAy6uo3u0YwYvRdaNNE6Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755695075; c=relaxed/simple;
	bh=99pOlJkvtrYqRilrtl9McZS83S4ht/yOvxPI8jkp8Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ws1JefOgdk9NejDuNb9idnzzi+Dci4Xe5bzlKHFJOCKPAW8yGBQsyVt4R4bD0z4mJ+KuubhvE8/pf6c71Vk4Dn9Gd1Pd8dyRsFZKnmmtCyMuKvNfgV2b+mYRGYbZ4wNa4ubu9OG06SJBVb8wRxLQRX5ZhvykS9DgmM7qnkhlSRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=i8ToSWZG; arc=none smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="i8ToSWZG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1755695074; x=1787231074;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=99pOlJkvtrYqRilrtl9McZS83S4ht/yOvxPI8jkp8Xc=;
  b=i8ToSWZGBVyP4Cag+WOtm7Ap31Qn6aj35E5a9HjAots1De8ZswItt6Ev
   wgPY8yNP12QbQJmD3XKz9qKqoxbew+LO1xIyuiV7EMeRVi4Ju7+usA1gO
   Djd01CeqKWZNfqGD7luwUtEJdic57bC3fkgJsLBwnRqg44PDhVAaA/YFD
   4gsTOVUSRogAg0+aWsJ8C4WphKupf9ypEAQFRA6VO4VqsEDmBOKgWq80O
   8eT4LHV1jp8QkjX9NdtYo6vgJZF5xAtbBmA+ssmM76cjuAnuu0ijhEapH
   GOIVjBXI3+HNp3zAsdtQJb5ndTyytZ728OXnji2KqkWj/khkGZ6GoNAMd
   A==;
X-CSE-ConnectionGUID: 3t+opUtLRt63qbFXrHXCzA==
X-CSE-MsgGUID: HZ1N3i4/QwunKqwAZKvnqA==
Received: from unknown (HELO uls-op-esaep01.corp.sandisk.com) ([129.253.192.43])
  by ob1.hc6817-7.iphmx.com with ESMTP; 20 Aug 2025 06:03:27 -0700
IronPort-SDR: 68a5c79f_5Eor/aFBJxczSgTCwPJRCI0c/o+h/h1o7duVIIAwaXv2B6+
 xNBb0YlHCHKcEpUSDG4MXCt0Y6l21ffmYPNJkYg==
Received: from unknown (HELO uls-op-esaip01.corp.sandisk.com) ([10.15.0.10])
  by uls-op-esaep01.corp.sandisk.com with ESMTP; 20 Aug 2025 06:03:27 -0700
SanDiskIronportException: Internal
Received: from ulssdxvpxsnip.corp.sandisk.com (HELO WDAP-HWJc7y5WZG.wdc.com) ([10.9.34.160])
  by uls-op-esaip01.corp.sandisk.com with ESMTP; 20 Aug 2025 06:03:25 -0700
From: Tomas Winkler <tomas.winkler@sandisk.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org,
	Tomas Winkler <tomas.winkler@sandisk.com>
Subject: [PATCH 0/3] fio: fix static and const correctness
Date: Wed, 20 Aug 2025 16:03:18 +0300
Message-ID: <20250820130321.73376-1-tomas.winkler@sandisk.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix static and const correctness issues across fio.
Mark functions as static when they are not used outside their compilation unit,
and add const qualifiers to input-only parameters. This reduces symbol exposure,
clarifies function contracts.

Tomas Winkler (3):
  stat: make stat.c static and const-correct
  engines/http: make fio_http_getevents static
  engines: make engines static-correct

 engines/cpu.c  |   4 +-
 engines/exec.c |   6 +--
 engines/http.c |   2 +-
 engines/nvme.c |   4 +-
 engines/sg.c   |   2 +-
 stat.c         | 100 ++++++++++++++++++++++++-------------------------
 stat.h         |  24 ++++++------
 steadystate.c  |   4 +-
 steadystate.h  |   4 +-
 9 files changed, 75 insertions(+), 75 deletions(-)

-- 
2.43.0

