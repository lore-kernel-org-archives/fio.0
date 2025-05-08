Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557F728640E
	for <fio@vger.kernel.org>; Thu,  8 May 2025 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746724503; cv=none; b=MsSWMQdNxUg1w9jRiOYQxxde7KIbANdxU5HSxYmT8+fyZeIO2OYa1c/KN7FGDVm0zfh84/vHdSkrsk//CuZ2kzvVv1Asv+k5GvjXNEhxDzsykmFPT6SL4Zm4l/68JKJwRt+PAW4vQp/HsugdXP4HRW/7kU3sLwRbtBO5HC3sFYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746724503; c=relaxed/simple;
	bh=W1b1S3bwIcouS2a8xD3yTbQYGZXjiAcrqkAuf9XiXSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=INBSiwpkPOhL1Un7CHGfqV2uo9YQs+vz68+bpCJo3y/lt0fhrgCQSlkSg+lN0LOdT9aUx4MqQJPlhgysjKMYZFWqAsyRrHDdTtH2DVTfI0pAsQ/RS4tGZ7eAsLCzedaM1oyD6gBb1ScNDmu2m74pR7btQdAFs2J0IaLNOS8meXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PmOANZyB; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PmOANZyB"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c54f67db99so260980885a.1
        for <fio@vger.kernel.org>; Thu, 08 May 2025 10:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746724500; x=1747329300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JlgeMDyw10/xz85KJ9MyipfDzNUs17u6ehbSgsa3OfI=;
        b=PmOANZyB+1N3CCf6elE4Ko4NU3xLcBAQGP6JBBdmTzvs+OmgqpH4eqiuPcpiwANBsb
         xatAlQUsi14qYEm2zR2ev1sebNEK1pxQe83H8I/8OKgAj0fUZRUqTb3QH286keWiQjhb
         EsDDQCnYTz18+pZV1iABwIdICqF4b9qMMIKuZv9QmQmJyGU9ari2Pap33gFFHKdQ5MmU
         yAHCHUylPSSmO+mZcmglfCpvZWK7qVV8vmZceT3T0yfuQ/JmmenNcCGtaZ6e8x/5zaV6
         3/1NnF2t1qGLJwcwAd4HqBJxM/3OwSx0H7bSPHW4x4YoJxF8zTmatnw5yVgWvJUsP4df
         zw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746724500; x=1747329300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JlgeMDyw10/xz85KJ9MyipfDzNUs17u6ehbSgsa3OfI=;
        b=aR3W1gh+TCu8RiOGubLCi+xvg/4/uk32P7iiqwPNA+8exCbbwiRNMjyOzNbHfnp2UP
         E2WXwQTQCdPyUJLtR96Oz8s3hS4DEsjSdqDWi9BscK2701S1/5bAtpdfPXM+pUIw92qF
         gf2ZlQ+hOtRaMt1dCZTrBSn4SgZDDj2UczKHVW4lGNCWyd+l6knuxgmd4M6xvvOAan+5
         xPawKpTGlncMjJuVZMeQeCitT9I0Or0ZMeKnW902cZcKjZOK13e7iZdZ61OULQtSWCXQ
         nX5qopT976klowVi7E/AjchV0RJvlgEryJcCNm1Y6mT80MgSusTH0/bPuiknEfCcqfnu
         aT2w==
X-Gm-Message-State: AOJu0YwNJFzGdblkt/SWu1sd3Wnhpmhgd3KvfvnG/TlVRgRSlS2BY+kx
	JZqhChEMmpgeZRF6XwKSJ/ADebv58DC6Og85Oig7+MQuNyQWyGmTmnQlvxIA
X-Gm-Gg: ASbGnctv7Iy1IyW48SwiR8bP2b/VoUeKpoKjC9s1IK0mgmWoWct9Wy5MtL2C9YI23Zm
	CeNGEizJlcC03DTaL9ImGbSEYrmzOiN3b5arSaY/Rn25xH7NFS+Fu+0aHR4/VVQ4ToiVRt8f7xN
	CmupDrKtsa+WzI6vjk26BarTB5EN4jXH+77QMsKYhMlCeUm+8Rw9YYZVWxhQTjrG66+uz31O0bY
	lbuXjr9LYcuBd5Ee/rvx/cODLYdcpsYRrdrZZ0rcnirXJaP3/dIKrK27kBejHrAgK70rNJMrBd/
	L7sfdXT1jYgZUNDQipxRuMPGO9oVKI3xNNVTfniFWp+RDrSd8TO2E7cgbwGxmqrqRW7zg9IkxMl
	K6WHzBFqZzMP8JkOtLCUa6bb35pvAHQ==
X-Google-Smtp-Source: AGHT+IF/MimbWjZU+xO1zTrrW7PXAYIOOBqIapjdW3kbJ2Gjlf0LJ5bX1nz4BbWAAHOfTAQ0joJ7rw==
X-Received: by 2002:a05:620a:400f:b0:7c5:9480:7cb4 with SMTP id af79cd13be357-7cd01771585mr10128085a.9.1746724499821;
        Thu, 08 May 2025 10:14:59 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00f4d54fsm17027385a.14.2025.05.08.10.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 10:14:59 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH] windows: fix pread/pwrite
Date: Thu,  8 May 2025 13:14:34 -0400
Message-ID: <20250508171444.2113-1-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pread and pwrite functions for Windows posix emulation never actually seek
to the requested offset. Fix this so that the psync ioengine works correctly on
Windows.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 os/windows/posix.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/os/windows/posix.c b/os/windows/posix.c
index e3abf383..3e48c3ff 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -830,18 +830,24 @@ ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
 		off_t offset)
 {
 	int64_t pos = _telli64(fildes);
-	ssize_t len = _write(fildes, buf, nbyte);
+	ssize_t len;
 
+	_lseeki64(fildes, offset, SEEK_SET);
+	len = _write(fildes, buf, nbyte);
 	_lseeki64(fildes, pos, SEEK_SET);
+
 	return len;
 }
 
 ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset)
 {
 	int64_t pos = _telli64(fildes);
-	ssize_t len = read(fildes, buf, nbyte);
+	ssize_t len;
 
+	_lseeki64(fildes, offset, SEEK_SET);
+	len = read(fildes, buf, nbyte);
 	_lseeki64(fildes, pos, SEEK_SET);
+
 	return len;
 }
 
-- 
2.47.2

