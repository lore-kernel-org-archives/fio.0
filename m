Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090FB1BDCE
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 12:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913213; cv=none; b=G6Y1P38j2bAL2z/umaQTyTXKJ7BxQx1nrulcvm45ACVt1vKJ8kJJv6q6ji5HYJ6i2O+hom2/BL+eNUm4JNZXD5TmrxVdzEMrCTJFa0MhJ9OA0qbHE7D9+Hu03aitqjNsQQXuqvlbnd9ScPW89qH2tU4Gx62hltKwV41CfObwGnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913213; c=relaxed/simple;
	bh=tHHysqNrYLz+wtpaSSz8CBKpmN0I63phMJYHUjRILIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I0Hau2fZtfRZv2jEXYi5jBVr7P3EROTlijZC9PBgsofmadcoi4fWDMk/joJdd0sECGekZ37vgxvpXJ0Ms9gRYghRAAVUtFfRHk3ECF17914WQpunyxgwUaHO/wbE8s6krxkk0hGKQw7vE6sH0sABY+zM2lp8ZviwDmJjp81TUQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LYXNhsTi; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LYXNhsTi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707913211; x=1739449211;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tHHysqNrYLz+wtpaSSz8CBKpmN0I63phMJYHUjRILIU=;
  b=LYXNhsTiR8VP9cRUx4KJFQ9Lyosc2/HBC6doXuzUxsjLiCjxz71cg5Yp
   iwryHYLtMdRoUcEvmay1H8abW5dzf5lBhf+dDPwRJ5ZrNHtu9kMDWv5+z
   opteeid0F3tMBHX+Juzh3YOuEQhf6CB6GOWLoe+PIVg8Cjf5aDv/MVKft
   xEuNj49cU0tXzSnsmKl73cfsn+Tou8XL4gb6X/h/Uk6uvxP+IpuuE9KZh
   Rqe3v4UaKj0zc6RRLIGvjJTX5pTsq6Jg+5cDpmFkTXE+588N/jnWW5/lE
   uqymr32Akbi8kvGJZgJTyJD87XN9rY3CZW0SPIe48yL+6kq+lUQneYgxF
   g==;
X-CSE-ConnectionGUID: ZHni9YKYShut7jSQ6Edvpw==
X-CSE-MsgGUID: UOs8qVAUSPqy12J1Cjhx7w==
X-IronPort-AV: E=Sophos;i="6.06,159,1705334400"; 
   d="scan'208";a="9479622"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2024 20:20:10 +0800
IronPort-SDR: Fs0lqt/DDPxTe6kZQMlzz8NQGyQsAcSnK+S3udH+nLt+3DC/s/Z4asx6K9Vbedj9e+7UzhOp/v
 TVXYur8065yA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2024 03:29:46 -0800
IronPort-SDR: D6X+mmzmyZvFFk6JXS/rh3qiRUba3XKXsdDPd3K3U4VGjTy4MalLCi4nBVpMW0zQLGvbx32LcO
 YIfbECsCnpnQ==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Feb 2024 04:20:08 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] fix loops option behavior of read-very workloads
Date: Wed, 14 Feb 2024 21:20:06 +0900
Message-ID: <20240214122008.4123286-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the commit 191d6634e8a6 ("verify: fix bytes_done accounting of
experimental verify") in fio version 3.33, loops option does not work
good with verify-read workloads. The first patch in this series fixes
it. The second patch adds a test case to confirm the fix.

Shin'ichiro Kawasaki (2):
  verify: fix loops option behavior of read-verify workloads
  test: add the test for loops option and read-verify workloads

 io_u.c             |  3 ++-
 t/jobs/t0029.fio   | 14 ++++++++++++++
 t/run-fio-tests.py | 21 +++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 t/jobs/t0029.fio

-- 
2.43.0

