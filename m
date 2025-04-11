Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877BC221260
	for <fio@vger.kernel.org>; Fri, 11 Apr 2025 11:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369943; cv=none; b=uBYkixIHx5W30Bh7w0YUghK04bwqbk5zxM+6NYGRgsAQfEjLfArtJfBI1Uc9fMVePlcKO/rrYbzQDTiapP8Sl7oXG26LUu/O+vIlT3tMjAGtaLE4T1j8ZAFBfkcxfQuDUZImT8HSTBrCaE5NpOLSPqYYGLweJA1+NU5W1yfGJh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369943; c=relaxed/simple;
	bh=RRXvolrRewebznjEfZPRKeRtVDfYnQvj5b7QnUiUfAs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sZ9ACCp3GEVtNUhwsBdyMgrryy/hlLJ+Te7vLpdKx7N5k0PTk5QXTK3Kv8YWhjcdksABqRpzel5OoCkRQHQm+c9YvZ7nRxCY5GxlyQQvfc6zuHEGiC+CFI21P4sOaCLFrhjKKrXBHAUDqR2CEnj3vdQ0eOxHvZOqOjefDgnarNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Luv++sbE; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Luv++sbE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744369942; x=1775905942;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RRXvolrRewebznjEfZPRKeRtVDfYnQvj5b7QnUiUfAs=;
  b=Luv++sbE3t9Jmf8w0Afq5KJmdPMKV6vYWvlkVvy4cF3SsfufFI4b6LED
   w56nLbFDCDGAsavWRf0ybe9o9hNWr5jNjFV++wT8O4YvLawfDIJsyZlIf
   eHSwfONionfe8wSV1+wpqYTruaJdh2fzKmvqAgucGAvo40eFEHa02U5Hw
   RRojMFZYbsBk50nkLTPKAxQ7/JhhQ78i3k5dAixUpv2NIQXxtCAzQ45mC
   keZkR2rrQPT6hUDPoHhBjR5rdNIalNRUlZU1jYJQh8PLfdye2n49HCbmy
   nI345Z6pTD1vPhl7lf2hOFXidsmFT83mKq00ODKOsbb683lSqeDGAf04c
   w==;
X-CSE-ConnectionGUID: cKb5gVhiSNOWWIrb6z/rkQ==
X-CSE-MsgGUID: 2cgUQhjWQam2MdxaXpS5tA==
X-IronPort-AV: E=Sophos;i="6.15,205,1739808000"; 
   d="scan'208";a="81898582"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2025 19:12:21 +0800
IronPort-SDR: 67f8eb0e_/UvKvFYxuWnCyjdP3gbweRDdtSfMghDWqrKnZ4Hb2fIJzru
 VvVa9bEgiAMCkB3pZi7+cxXzQxYrM1g+BRjB91Q==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Apr 2025 03:12:31 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Apr 2025 04:12:19 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/4] zbd: fix unexpected random write stop
Date: Fri, 11 Apr 2025 20:12:15 +0900
Message-ID: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a random write target offset points to a zone that is not writable,
zbd_convert_to_write_zone() attempts to convert the write offset to a
different, writable zone. However, the conversion fails under a specific
set of conditions. This series addresses the failure. The first two
patches prepare for the fix. The third patch fixes the failure. The
fourth patch adds a test case to confirm the fix.

Shin'ichiro Kawasaki (4):
  zbd: move zone finish operation to zbd_convert_to_write_zone()
  zbd: factor out zbd_pick_write_zone()
  zbd: finish zone when all random write target zones have small
    remainder
  t/zbd: add test for the case all write zones have small remainder

 t/zbd/test-zbd-support |  48 +++++++++++
 zbd.c                  | 191 ++++++++++++++++++++++++-----------------
 2 files changed, 162 insertions(+), 77 deletions(-)

-- 
2.49.0

