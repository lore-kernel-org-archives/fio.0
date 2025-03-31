Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A031E4A35
	for <fio@vger.kernel.org>; Mon, 31 Mar 2025 14:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743429755; cv=none; b=kHGwchO57vG3dghTmzMRpECZCfy4pIZxkEJLLOJ4my/EtI9Avi9cHj3HOAIXn+l6Y/theymYDqdSG9S4LHPjIvouengehjBJUw7EFKNoPmmMXdNrYb5pA9LBkHfCK5CO7LVNHk68e0Xj3QSgaDJ+p4kGGoJi/E4LLqk/AXqhoPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743429755; c=relaxed/simple;
	bh=8Zg5x52BDMZrj2KdtFPh3I1CLWcbnyD1BvPSnboTnoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QCKAVWuLX6C1qTk/qA5hrG5FmAfX0qnDXakH7Akv/9hNbV/2lTyD+a3ISmGpDmxoyAupu+Fn/alnRojGwZGirX59ksqsOq6s4ZUB3RaDT7j2AdXa9qWRjPidUTRZjCDQ1zpaeMx43TLGfHrI9XASNj33z7xrrQMge1bx+8Q4akM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQHDS7k6; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQHDS7k6"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-47663aeff1bso44267261cf.0
        for <fio@vger.kernel.org>; Mon, 31 Mar 2025 07:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743429752; x=1744034552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xhcqq3EHnvb2MtZyvhk4eUmspWtcovhSKVtfxuI8sOo=;
        b=CQHDS7k6dnIptYZ/zvml8NXvZp4hZFYQdnwsgzUhP08lBAo3e00QDn20oXCNFCBkDE
         TFswuUrTirYGymTgMUHLSHRX0iJ8YgFTZwJzRsWPGvHsM1Jt+MJz5wPWUQpQccRRWdnm
         nY/hGmRZRwtjz4WTYopoh9yGXkpzJSNZ2U72cC2SQQbMX9JX4gLr5iA82DY/E1PP2xsV
         QvGm5iecUQ6clP3w9pdg02VxBAw3zefmSfDo79MOXhDaLt5PTfEu8Z+/l74vWPg9LNz4
         KoYwHcZne+1toUoCwyh1zwnyB5TLoAL0mWdNTK03/tofabUwGC11Wuak4vMFueEoa9vE
         N2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743429752; x=1744034552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xhcqq3EHnvb2MtZyvhk4eUmspWtcovhSKVtfxuI8sOo=;
        b=Ptb10aCRNMSH0ufvDRPMJzQyJL6FGACM92HgHFiFphzHiBZkNS94N5owlMtieFtQy8
         lvy3ajuERMxWnB03LYN6iUPkY6+oqL6OSbAdSKKD6luecomy1StQj2AfihhES2Cv3yMH
         IashIya0op5RxMrw5k8sLN28au10h4UnCHIeKqzMbah5tFYGboPxdgp9dSawjge/2sy2
         ZylosRBkZEFJSOmojPARJmifPtoBWJ/McGetxOGMrYKwdJyt49YuZGc07h7tzxw5L4w+
         BNy878VxW062Fpk/SPgahD86KXyyEawWGmXyl2r7ezlFedQ0qWZtIO1d62+COhfHR7YB
         x3jg==
X-Gm-Message-State: AOJu0YzOvglGm+P462UuGggCfxSS6o40TYmr/CYvFiOUPf2HyFujqVx4
	YUwbXJKU3h2jC6zZT66gkOXeuI5/ONjjPWoCYuWFoFJGMbJGT+pJVtUW1A==
X-Gm-Gg: ASbGncumg7jyxJYmrQV3K5SR4GLxONDaaqIxxkT/uB9LTvnyg49A48qCFf5VxaiH7Sh
	OFisTQ5hQ7MgBYMAe3plpAoyVUozphonTvCTsUjPCqEuaenRDxO+l+ZPuQrWlgt7EIBJ4dv7DH1
	T6rtLBk/6nWfpelkfNarb1OXp3kD5+5nKi1I49FtG70vhzVsxD6cTlkwEVD6j4/jV8agDj07CKb
	7gjCKkMSQW0+F00vCcEsJeAE1cPsiDx/SXuGgWIoBHwjCXuAKn4SqunMACvJ0E81QjLvvQHBUMX
	3fiQmnqPRPTgdG915CF1xKp3i0nR/RteEbedUy6TuiKkehfL2nprlSkFg+S5qNlc0K3pLpt/22i
	CyaN0WsVHJ8PxqRenrG1JabjTH6qei887Ew==
X-Google-Smtp-Source: AGHT+IFh3CnxPrDnI6e1rG4JgzTGGb38UrQRbD+s2fv/2CfYDBqcXoH68pISyRxtwLsr39wvFEPjoQ==
X-Received: by 2002:a05:6214:29e3:b0:6e6:6aa5:2326 with SMTP id 6a1803df08f44-6eed60a792fmr119429576d6.24.1743429751526;
        Mon, 31 Mar 2025 07:02:31 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6eec965a7d0sm47231246d6.62.2025.03.31.07.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 07:02:30 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/7] verify trim operations
Date: Mon, 31 Mar 2025 10:01:27 -0400
Message-ID: <20250331140204.1971-1-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fio's trim verification feature was broken by me several years ago. Here
is a patch series that re-enables it and cleans up some related issues
along the way. Happy to hear any feedback.

Vincent Fu (7):
  fio: allow trim operations for verify/trim workloads
  trim_verify: include a trim panel in the output
  init: error out when readonly is set for a trim/verify workload
  verify/trim: stop issuing trims if we run out
  verify/trim: make trim_backlog_batch work
  t/verify-trim.py: superficial test script for verify/trim
  ci: add verify-trim.py test script

 .github/workflows/qemu.yml |   4 +
 backend.c                  |   3 +-
 ci/actions-full-test.sh    |   2 +
 fio.h                      |  10 +-
 init.c                     |   9 +-
 io_u.c                     |  18 ++-
 t/run-fio-tests.py         |   8 +
 t/verify-trim.py           | 309 +++++++++++++++++++++++++++++++++++++
 8 files changed, 354 insertions(+), 9 deletions(-)
 create mode 100755 t/verify-trim.py

-- 
2.47.2

