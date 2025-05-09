Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3489B8F77
	for <fio@vger.kernel.org>; Fri,  9 May 2025 02:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746756243; cv=none; b=byS+5qADdEMVflWx4wwi5OJpBrmbOVzlum8pFHMFxxiajX7lzAgVDeAFEVRG/+psqrX1Y0udp/CWDkIDi7j1eNv/qNHbj3AkYhIraI3NjOSqadOayKmMtjDsyho7O91VHp4hQ+mC9AKeB+OXoS4/WXzZTFWULLYw3Q6iztNaeqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746756243; c=relaxed/simple;
	bh=v8Acnukl8pQAr5EVZV3c0wLVMw+3gTyi0rorHzl9bKI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EouB2NBT1zapqZj9SRqbTCWkOLd92HzyrrJ88+WN2OJ3jts+F+D6UzmubKNwhXVnGyjcOEiINwf4lFbtVngifP4NxYYOvGPCZZacoO4KEtZjKxGEcBwxdcFxcrMFj/Yu0Ogn6T96eODbiC1PWjMIDviU9mNMAoyOAESFKhYcLhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dzrzso+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dzrzso+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0386C4CEE7;
	Fri,  9 May 2025 02:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746756242;
	bh=v8Acnukl8pQAr5EVZV3c0wLVMw+3gTyi0rorHzl9bKI=;
	h=From:To:Cc:Subject:Date:From;
	b=Dzrzso+4gI3c6Mx8bODWOq10K2sy3r2stx25z+2pZG9d6QlgVmnaPn7ayJ+c/LJb5
	 bcz+juOZZKa/bJOsbSKe8Z1jazLrhCy4X5pPwNg9C7wKwOhFV/yzCuGJLJW47BfDD9
	 NCQpUOeo/WKepHZiifjQ0OHlFu7eTV5vCiS+OiKoE9PwYTpfvjCn6SjaJZord91/aX
	 e7eEgALh7ZGr7q+FZBFCO0v6n8VUuSWu/LQW4RsS/pLqKRCC+zqAZdbC6ITuhJKtcL
	 IOj06CKTHpmDwfvpDiNoDZGsbDnx2Hl/N4zMVi5G9FQ3gpUO3AjYB9OkdqVPqvLayS
	 oNjuDz+rk2+KQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Vincent Fu <vincentfu@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] man: Fix recover_zbd_write_error option description
Date: Fri,  9 May 2025 11:02:50 +0900
Message-ID: <20250509020250.483865-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a missing ".TP" statement after the zone_reset_frequency option
description to get the correct description for the option
recover_zbd_write_error as a new paragraph.

Fixes: 650c4ad385cf ("zbd: add the recover_zbd_write_error option")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fio.1 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fio.1 b/fio.1
index 8476b681..69dd892f 100644
--- a/fio.1
+++ b/fio.1
@@ -890,6 +890,7 @@ A number between zero and one that indicates how often a zone reset should be
 issued if the zone reset threshold has been exceeded. A zone reset is
 submitted after each (1 / zone_reset_frequency) write requests. This and the
 previous parameter can be used to simulate garbage collection activity.
+.TP
 .BI recover_zbd_write_error \fR=\fPbool
 If this option is specified together with the option \fBcontinue_on_error\fR,
 check the write pointer positions after the failed writes to sequential write
-- 
2.49.0

