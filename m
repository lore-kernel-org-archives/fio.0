Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8362110
	for <fio@vger.kernel.org>; Sat,  9 Aug 2025 01:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754702232; cv=none; b=U7sXyYx26G5q0qr+vFhCcegd2mGMUxzDgTBKoPrOCajQujZSnHmqfNiytaH2bLqfh5GaPxiI2cmla6pcRSWc0pGr0pBCJgAHgTkSABK/v7arA3Jn0YR0ByCaBgqRtUaZmXrGsSM5jFdQrLV7CIAOFWGsdzYh8BKVbRIlvroJNZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754702232; c=relaxed/simple;
	bh=jvYjycXBFWnMSFmfgR3Tln3NW/a2Y5gx34vrZDvuZQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fF4gqdvaU8fFUSiClHzpSU+cZmX4VOnkYo8aSfA5n40ZhSpIjfCAfaeKwlZ0mB2k2xFC+aPvR7QfYLpk1ohCMQ5sHhhb3XM42wwEc4DeM/lAUHmJ08HKiwsCDS5nDtL+/Fkrdd0lmULkMjaYcMhZc3kVOOk+b492uufXjskBqrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cgdX6Hdy; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cgdX6Hdy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1754702231; x=1786238231;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jvYjycXBFWnMSFmfgR3Tln3NW/a2Y5gx34vrZDvuZQk=;
  b=cgdX6HdyE7U1jfg/GEdulWMMQVVuYW1rUedko2viLt6pw9McvzNSB8im
   ynOg3+XngDe8QqKiAp6M1NsA0QtQL+QYmgxkKF3k8c1fCJ1rrERKX+m0Q
   8UcD4PByyKXYOm/P5zUtHHWKohZUp8jjsx/GO++NBIM4nsUE4dR3SSNSa
   i0xvnRIR3XaOSHdy5BfKNiUyRyeJV9pRzL2KEjk6FgbFR/98hyQ5slHb6
   LWwHLntm14Qd4bEagc9CcwvOeXHtvpP8yrh8fkoulJx1O+THKANrsDKIT
   APBKdqGOITngSkibtUuSnzeNwF93V0JDIlehV2Yq459Om4WUCLbKPxsrw
   g==;
X-CSE-ConnectionGUID: rAT+CWkMRgist3k5FCSJjw==
X-CSE-MsgGUID: YeZgU0hhR7KvbQNdv3qD1Q==
X-IronPort-AV: E=Sophos;i="6.17,278,1747670400"; 
   d="scan'208";a="104622431"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2025 09:16:03 +0800
IronPort-SDR: y2jsQtM6pSTt6z7rga8IfyosZ9BN+XRynll6VOCQrWg8v6DjS2kv29bYlW5aQj7sIPlAG40hoH
 /RI9tmZ7DjGEOK+E+mpR5FA6YQkR4tesqMxpGlmfEx3NjEKQTXXgH2Ri9ihQg0q5VjyU+GhcTH
 C7XLOjQnL6dt25pZUIyoeqwv7afDX6N01tWXnyk7/tmWnPvplBw1aSS3jYEwjv7vnUe9D86tk+
 ceGdfC0AFww5GP8HFKs8nVMehOy3c1itOKo98L94LmgcTzEUloHwn9RYSK/j5ttlWXEHA4EiUo
 k+Q=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Aug 2025 17:12:01 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Aug 2025 18:15:56 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	Riley Thomasson <riley.thomasson@gmail.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] verify: fix issues of verify state handling improvement
Date: Sat,  9 Aug 2025 10:15:53 +0900
Message-ID: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently, verify state handling was improved through GitHub PR 1951 [1].
My thank goes to Riley Thomasson. The work provided the fundamental fix
for the out-of-order write completion issue :)

However, I observed the work introduced two issues. The first issue is
unbalanced calls of log_inflight() and invalidate_inflight() during
write failures, which leads to fio run stops by aborts. The second issue
is verify state file data structure change without file version
increment. This patch series addresses these two issues by two patches
respectively.

[1] https://github.com/axboe/fio/pull/1951

Shin'ichiro Kawasaki (2):
  verify: fix write tracking in error cases
  verify: bump up verify state file version

 backend.c      |  2 ++
 io_u.c         | 11 +++++++++--
 verify-state.h |  2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

-- 
2.49.0

