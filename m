Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCAB288521
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730752; cv=none; b=DOUziGSvdS/RA42l3JoHsm2zEMAnlqiDO/RDLnyrcxe8teWckwlvoXNnOY+kH0hveeWVCGmEbhz4KpQhZ8cXBwhuzDH+AmERCRlW06PoIRPnLH+rRYnIuiBXe3p/Frk+WrJV3VRk5keq/rOH1SrAOCCCPiJ4Cb5QQ5jrYJCKFE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730752; c=relaxed/simple;
	bh=xucdfvoESerLJka82l+D1siofOQN8CiYJLLETy3rFps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxtLHT86QQzzhRQO0uq2oa8aLnvV6H+0ZP7rRUCHMKop6PHaESLg+L4ipyOY2PuEX7HZGmN6nGGlOJxjO0Krnv40upfC+jKQNBZlWoyFBal5znEakh/gi5lqruDD/enPm0dBdWpeN3skOb/UwNIPKjS1zwzHxt9jlRNbJjEig9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=doRXYEG7; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="doRXYEG7"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c5a88b34a6so146906485a.3
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730748; x=1747335548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inhbDSUjK2BV1x+cGwexX8AbDH2KTMgihTscuNUAd+U=;
        b=doRXYEG7N/Dy8PCD5SppyBFpKiYRPOC/DR9ReafmiP7TixC577oq8g6DxSrdp6PmhB
         u5ifddodG+MU6GuaArKCnrWlQNMiDj9rZ28hHtyOb5ieVdgzmGY2Yc9EclB7ovRxrDrm
         ZDjPtNbrzuj30AfGLERCv5SCrErAnhaD3HQi63Gzxn+EC6n4UVdHj+amI4Px2mb833i0
         J4RF+N5Hu0Dm8KOVVhyjASFNMcUv8tZsd+THjJYW8M2+hfWjUPUcwIIV0lhybofVHBu6
         jlMjE0ikky4DxZ7aI2uT4OAPnMjuii6Mg3oyF5iI1eDsY5lSqEJnh+cSLuMNdvKAg+DP
         hQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730748; x=1747335548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=inhbDSUjK2BV1x+cGwexX8AbDH2KTMgihTscuNUAd+U=;
        b=ouZvOKmYlzMGtKzXn01qYLW8iBHd7xfSJK90w0nD0GR2n4ia9djPZl4KHKWD1t5ygW
         AXhExry7cq83XIHLt5Wcp8ErQ+fza/y3C7hDn6kES+Jnls5sR05E8h/NnegEqnEjF049
         7JWCuM/LXGkHuf5HitmKo7VuHvSaETn+/oefjlzwpf6TFZpuR0Y3aYHZqABRz4OWhGZu
         PPd1fArjdBjIWU+j0lK3mvrzB3B5QkGreKEpAJ/jMHmlUwlAdef8QN8xB+0BHbmZAvUA
         Ch2xnkXBLxR3juGe/07lOUmuoiQpqW+X49EqLMzzKqxtAonG31BNuds7U0P6OnQKfoHl
         BymA==
X-Gm-Message-State: AOJu0Yydp+z9hzV2VPemOQlqgscFJ9G0K0CctaBRWRKhufLg7ZbVpd/L
	Q8B0TrU/wRnqhzarGtNKkKpPVnZg81yAFTZg6f0W1I7vh9QnoXwCmQwxu2zU
X-Gm-Gg: ASbGnct5pggsYgb6mTgq/jKDTsvcDfKGm/zxk9794CecAxhBBD4rPI8Mab21L7WEvNe
	LJV5vg1GoNNMN6Npnk0uFv9v1N6g4Ng3cpzYdCL2xqsaRyG7HmTELphv4lNUJtBBkId5Zx80X1D
	yEJyRhTOExSdOnIVXrdjSsv/H6JKGRyi78/O5z4T5Iwg7V7bZm33ZNBkKYDf69BqXEUwswrIQHY
	dw2HK3h0BMDq6dkoMXN8OG24bXzzEr6oWpZ+VDvAHkD7WTjYKWiBv/MXn4c0oCCcDSCVhgpceLa
	VH+gB/JkSG5D2L2l5IPnwO3CiQKvoVWmOI+enACoj80BkzM8B/9cpZlh64FLEGzlb6m9GlgTYFW
	9ATrUfmJ9AL5Mrx96ha+W0FFWl8MhW9LRW9y6rvRQ
X-Google-Smtp-Source: AGHT+IGXBSPWBQgaQcQyPTRT6YlLCcOWe1kR8Kx8Uo3bMl9caAfwnNFV5ULoM0x4C0TSv9Aks8mw9g==
X-Received: by 2002:a05:620a:468c:b0:7ca:f3c7:5ba9 with SMTP id af79cd13be357-7cd010d0fdfmr162984885a.7.1746730747629;
        Thu, 08 May 2025 11:59:07 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:07 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 05/11] t/fiotestcommon: lengthen timeout for longer tests
Date: Thu,  8 May 2025 14:58:13 -0400
Message-ID: <20250508185832.3702-6-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250508185832.3702-1-vincent.fu@samsung.com>
References: <20250508185832.3702-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For GitHub-hosted Windows runners t/verify.py runs for longer than 30
min when it tests all checksum methods. Make the timeout for SUCESS_LONG
tests 1hr to accommodate these tests.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/fiotestcommon.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/fiotestcommon.py b/t/fiotestcommon.py
index 9003b4c1..04dfb91f 100644
--- a/t/fiotestcommon.py
+++ b/t/fiotestcommon.py
@@ -22,7 +22,7 @@ SUCCESS_DEFAULT = {
 SUCCESS_LONG = {
     'zero_return': True,
     'stderr_empty': True,
-    'timeout': 1800,
+    'timeout': 3600,
     }
 SUCCESS_NONZERO = {
     'zero_return': False,
-- 
2.47.2

