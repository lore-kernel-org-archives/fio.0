Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6682205E14
	for <fio@vger.kernel.org>; Tue, 30 Apr 2024 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473033; cv=none; b=Ql+kOXZ0NFSVDnsyX35f8xNCmAKtmMo+p4NQ0n2Z+g3Nt6EDfWhhW8vMKOVEQYc0v41GuM9VLP/+6SC+vnmdLUfEQ+z3vnvJrTTkEGlB8GFlXEL5a3y+zjgdZlM0volq09n4ud5lH5d/Fj0Ev8G7FTUfGljXhCoGH1OWRzZwvmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473033; c=relaxed/simple;
	bh=mISd5KCmXqQmj704IuEUrlHYtszTcc6S0u4rD3E71Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tvVa/XjxQkSBuooDmPOSvN7I59lTezR/k4T8Zx/LqhSPTc1FjWGafhoMqZD86yD9XaPYdnir4MdXbigDzcY9kp1eJCeCLWqC7zQADV19SRqaAaleGRjlqkGle/aYxdit0LBaAfqIZGZ7ZDX/TB8hPZUrdK1yVrNRhDVTE/zmgQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nB1kj2uJ; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nB1kj2uJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1714473031; x=1746009031;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mISd5KCmXqQmj704IuEUrlHYtszTcc6S0u4rD3E71Gg=;
  b=nB1kj2uJbhyuImdunpsg5EZVn27dzUNqFySZYQBxN6ij8pn0uxIW+5Ny
   33RozoT6pReB8ewtIv+J7jJRTs18ESx77ow2KMt8mhK6woDI9QnwoPDT4
   TWwPyXb4+OXWOIdKamVdXsK8yGH5+PCZkRTso901UKm4jjiLPKGXPfFxH
   G8sKVUkoFSHh9b9+aURKIhKH+am9T76zCrI84C2Av9CleSVSbsDuMVbWO
   jBLBbEtr6vQa7v3fzmu8xorrpBvfdLz0c532Qi/VgX/eCu33DnoP2qT6g
   sI+TcermiOilb8G/TZLKc+1QgAAilUurZG2xfMdB0fr1lpzuL9gkoEvT3
   A==;
X-CSE-ConnectionGUID: N55HVtliSOuGRpScAcHKsA==
X-CSE-MsgGUID: LEZ1yc3SQzSy/bFVYjOnTQ==
X-IronPort-AV: E=Sophos;i="6.07,241,1708358400"; 
   d="scan'208";a="15244714"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2024 18:30:24 +0800
IronPort-SDR: 0H5ix5Cx/jpEPDmQyPJSEZp8ULL6NFzfkWGuB0jDyCG1jl0tLtjYnntOl79pQFwn15Atoaf0ce
 5GSGL6Ser+JhsZDpob+fGmHdeSQcEQlB3ZVqNF+dEzQZcjNx8k21pign1+KXlLuHZNJSAk9M5T
 30qMdj0MWHaykjSwdM0Kgq6WR5XI2QA+kSzBLPxXcQrFagJQ65iCkHsvAxdr1RPhfshjr0Asfv
 UOULEfzIEyoN+tb1QEn2I0x4jVKMSran1fcda+QKASaG8bC91bbuYPdt4HbRHwHOCzQ1LLkGzk
 SKE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Apr 2024 02:38:27 -0700
IronPort-SDR: j1W5focpTU78QvVq44b+2DE2dEQHWP8Oy8sNqaQc/Qu/ZyfSHpom4HpaqLD25hs3A9y/2aLnQ5
 vfY2cbJJtk3k6O9cV2yAfTERF5Rz1123/B8M1awS/Ns+8XJDjvsLnjm7yzQsQ+S8UUMvb8/Qaf
 tAJ94BrQK3dbHuJOpTbUZQkWqwX/tKIN1nnwlw58RCn3DA8vVWPJsefWUzQYMNkdk/HZ4weC5S
 RBYF20E+7Rr0kX4uyqkxKbq045fNesGH21CUMYgL8EnKlCgBggRR9KOM06pDPRuI6H2DmWVSgm
 k0E=
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 30 Apr 2024 03:30:23 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/3] zbd: fix two zonemode zbd problems
Date: Tue, 30 Apr 2024 19:30:19 +0900
Message-ID: <20240430103022.4136039-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently, two problems were found regarding fio zonemode=zbd option. The first
problem is the unexpected zone resets and the verify failures when
verify_backlog option is specified. The second is the unexpected failure of test
case 31 in t/zbd/test-zbd-support.

The first two patches address the first problem, and the last patch addresses
the second, respectively.

Shin'ichiro Kawasaki (3):
  zbd: remove unnecessary verify_backlog check in zbd_file_reset()
  t/zbd: add test case to confirm verify_backlog=1 options
  t/zbd: avoid test case 31 failure with small devices

 t/zbd/test-zbd-support | 19 +++++++++++++++++--
 zbd.c                  |  3 ---
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.44.0

