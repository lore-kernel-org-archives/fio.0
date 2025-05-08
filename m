Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D63E288527
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730757; cv=none; b=L5r2uxv/gStNhecakkCAPcH3NAsWbTWAwpeppYAlS13Mn7asjfis76YapFnRdggdD72+5A0mrN6XHX49RJAxhOTb1BvdXXp2L2GDfMsXZLqboY4JZDMpEfVgv2ZcRiiKzL8koid4ry5bF64SEzoWgSCRlq9irsHlAR1wjIQS/Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730757; c=relaxed/simple;
	bh=LiYToU9pSl9zkTzavngP0uAugzEnCPLNsKKWrlZf7NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EY1Jyz1U0ofs2+uNJpsqsIf+7GzW2QemmEvkPrEPwl0tEtdwAckK9q/B72yF8XShYEK4fyyRDwlod9JW7E7Q+yQzlUivt9TLnjaXd8pwNHzHaY4bdvhpDpZyuvLsrtAOCj8AK6/6x+xiyZym4LnvupZsKlvlux/DApLNd0w3qLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bFaeB6+y; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bFaeB6+y"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7c58974ed57so152423885a.2
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730754; x=1747335554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wabEivCqTpyN1BvqOwaxkPwrE/BDeGCRg6mWCydP+Dw=;
        b=bFaeB6+y0ZVKYFrbd9ANJfUmfZemTvKiqYXi/cAOTIXxwnDVEQ9IlVUg6FYd9wnN1Q
         biiJbrR2dJO73u+OH803UAwNlUin4AVor8r92j0+SB2uBFXSGUjyi7C0MlZniIEVHIYP
         FwLNq9ygHm9E7uzeOa/lQpAQRHHgXRcUoTuhrPeAAqYVbCUqVYNJFqEw03gfEZFG6Erf
         RoyLFcw7xqgwm+oDlVBzWWVertFbS5yWO6tr+ZptzrKbNho9HtBnsywr0Qhd7poZ0zTn
         Vj+2h5Zyiv61zgSkO5ynrmIdk1dMGazIdLmN4G8mFRHonI/Sv6db6Uw9B7MmJ8qGjnY2
         xU7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730754; x=1747335554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wabEivCqTpyN1BvqOwaxkPwrE/BDeGCRg6mWCydP+Dw=;
        b=b9dNS0NfY9AD70AywVOAf2ftKWRG1HEHudpnFyyT7V5iO4owRRbb0Vc11I5qtY6Lse
         0BZz2mmw4zLrUgWYSqCTvFmpZ2VJkJ6T4uXAD3byu1lBetzZWZrYCGl1M2xlQI/XPjMS
         ey6vq7JrFVXDGOHaN2vqjGZJO6+nohy7IpPRboCAIrOYaiiCXT2EHKE9UimhFOL65q/d
         G8hycSeef1brbc3xyaePfvBKy1zE3rxSMmMcAaAsKt7UKuR7fY3rJZ+P92tcCFD/cONN
         Taf+U5P6QhtFKy39UYHCEN2y+e29Ea+5BSzLlDqlt7NP8V5UUPqwNB3mhYg+mn7Fgxi0
         DXhA==
X-Gm-Message-State: AOJu0Yxwz+c+7IdnAwa+wUiW2lAufyv8mjgrZHmFKXInCLqUa0X74SFh
	pDQcRiZ4hX0Oh/oDJr+Md21+Kra0IAU6sND8xkb+uxoxgE8w0OzlOdpqEyZ0
X-Gm-Gg: ASbGnct7PMRrYyKHqLfIaEjRD1TEuwgcquw7XJ1QFA20MVShwiYZUXjNorZ2xPqLbJL
	Qogeh2rJ/+DhAFOiSwaF4XS9vG8dg007cbQBI6/e/nHGGjigApMa7+S9SeHpd+YjWCXtsZtAITy
	21cfvbz8aex7nkC9/yqZRnhmYvXEpbaYC9FtIw3RvXCDknOHBpECrslCbdeKF7hORaIvdbCsYVm
	BPiZMjNw+QWi4RPaHy+2NgBZXY1dtF3K6tlMnSN7Ie8T+YClkpVE+pdTsAHWjOUb2+DqadSg80S
	FkOMUmk+bEEQVNATiH0jbEY9hJqAiUhWjc38v8huRmW6AvubaPILWqLz0LsmKHsfhumYeGLlL/N
	t/+icRcTescRUiGTYp2zGTz+b6U3XPg==
X-Google-Smtp-Source: AGHT+IFV/LDhLE9cHUt2JwEmlL+wEFNHy4sftU6ZeMoA+63DV4Dm9chr5pomgGz63PnE3hha+dHjvg==
X-Received: by 2002:a05:620a:288e:b0:7ca:ca5d:779e with SMTP id af79cd13be357-7cd0116e26fmr119230985a.47.1746730753596;
        Thu, 08 May 2025 11:59:13 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:12 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 10/11] t/verify: Windows --output work-around
Date: Thu,  8 May 2025 14:58:18 -0400
Message-ID: <20250508185832.3702-11-vincent.fu@samsung.com>
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

For a reason I do not understand Cygwin chokes when fio is given an
option like the following:

--output==/home/vincent.fu/fio-vpi/verify-test-20250505-172034/pattern_%o_vpi_10_vi_1024/3001/verify3001.output

This is the resulting error:

pattern: %o, verify_pattern_interval: 129, verify_interval: 1024
Test 3000 FAILED: [Errno 2] No such file or directory: '/home/vincent.fu/fio-vpi/verify-test-20250505-172034/pattern_%o_vpi_129_vi_1024/3000/verify3000.output' 3000
Test 3001 FAILED: [Errno 2] No such file or directory: '/home/vincent.fu/fio-vpi/verify-test-20250505-172034/pattern_%o_vpi_129_vi_1024/3001/verify3001.output' 3001
0 test(s) passed, 2 failed, 0 skipped

It's not the length because other paths are longer. Even if I escape the
% the error still occurs.

Work around this by simply using the filename instead of the entire
path. The job runs with the test directory as the current working
directory, so it's fine to just use the filename only.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 t/verify.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/verify.py b/t/verify.py
index 8f0cb1ef..99ed61dc 100755
--- a/t/verify.py
+++ b/t/verify.py
@@ -74,7 +74,7 @@ class VerifyTest(FioJobCmdTest):
             f"--ioengine={self.fio_opts['ioengine']}",
             f"--rw={self.fio_opts['rw']}",
             f"--verify={self.fio_opts['verify']}",
-            f"--output={self.filenames['output']}",
+            f"--output={os.path.basename(self.filenames['output'])}",
         ]
         for opt in VERIFY_OPT_LIST:
             if opt in self.fio_opts:
-- 
2.47.2

