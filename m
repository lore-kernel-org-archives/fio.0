Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2A42135BB
	for <fio@vger.kernel.org>; Mon, 31 Mar 2025 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743429763; cv=none; b=YbpZPzG8JIllLmLgRzXhGZqwj+lvUI5r5YfXtXu4NOyJEjAd4qsT72N3c2vKEx6DWthWrpQevRI+BzssC3R2+V4buKsjqKn5oynnDqp5wpyca7ymjd7r6bga1QNmZHzwexIgJkY5XJzkM+7cd9kVNHh3yzxPWAPr21PAz+syW5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743429763; c=relaxed/simple;
	bh=JTe0AjBRaoVR+o6LMtZBEtmO+QhLyZQRJ1L7HGYaCuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPPwaS/PyFlKJZhap3bZnEWy+kqXfgwSQ30LAaIP2RYQOz0wr4HO+EcFfvJ4FNi6wV5vgF3OaEWkSDjuF8YLIcKc7M4tSFq1zhVnTgul1ePGbiGWbqX/mbipT4xiSMFDNuBZHeVol7zYZoc+TBRZp+Hm30rIqWoBwtDVd4hiv20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLlr94Mc; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLlr94Mc"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7c081915cf3so587649585a.1
        for <fio@vger.kernel.org>; Mon, 31 Mar 2025 07:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743429761; x=1744034561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PdFLQEEkNHyaOspJuh84S7lnkGYC5YsMIv2tFGUBnyk=;
        b=iLlr94McATFoE30alil+PRi/ZGX48rydNJ83fDxp4siu8mU1GaDRNQmtNvIkcoC/aw
         CdkKM0tXDZv8qLOnRsHAcAtMGBz3jEYFehj1nxsxJVgjApfOZYF6klsC48ASvrQpJbyi
         m4bhUeGglN9j9yBLLSHuvIgFziU5TsZK4W2Bv7FT/Kpbqdyxpj/1ELSqjJukDGL6bqrG
         tIZSXZ65/ajkiOKJH4/O01RUnksqh5QnRq4GsOWI/W26aDLFrkoTqxSlgzcMJCU648CF
         6abNpeuhtfGnVKZPukinqyq8wL8JEKIbXB9BcWOXV+hhaB+QwX0VSLzHJqzaUZeg74Wn
         ArWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743429761; x=1744034561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PdFLQEEkNHyaOspJuh84S7lnkGYC5YsMIv2tFGUBnyk=;
        b=apqCR1i3Lzug18RO0ryBYKEZDIm4hZxeWIcdDwmEGyxf7ylBVtojpijlBLC6VeHHk0
         7rBfsRmvWKMQuI2q/DTANd2VvsyXAiBwtHPHv6qaTpz9BOAJnrz7Sdj5By6JzIosVrBJ
         lsHzCGQL7nKr6yvh5TTQkSIeAWA8Y8ZP37Y2HewUGj9vltFdv8Nq+5Sbbai3hNTkAaTD
         DlJpqIHXl2CFmpt29KrZ0tgRP3KbYOOdDS30mlsTPO7mHt+Ib6eOWHinGMwGe26wclHL
         POvbcMHbeXATDRnsL3H8qxkfbl66ZW424XqfU/T3E4lzBrX5aVWd7T+TKiUXZ5v8T6dD
         4JWg==
X-Gm-Message-State: AOJu0Yw4lLnXXj37CzCFIZpfaff7HkU/EGJ9SMeXdy5buB4o+QBLBlTZ
	KzUBtgtXX6TteDELvcssMCHX2HkgALof3wm9spTsIARbwQFGts9RgwDvCA==
X-Gm-Gg: ASbGncsbatOaLMtAVKQgyPdhWmXwsK9L1e+R8lRvmK4xthCLquc6U4NZ/MrGFNEE5jO
	YOAt9nLBpl7UQvpSOAXFjT0pxZtoTmUM+6/JAZx6x6v0cUMOYqj2i4sKqxsqWZFyQcSedPJ/3MQ
	ccTPjZq9FUeXw1La8qUyASNDtGdOm407lIhF1rdq2S1A/VHb09AsCLitJzzGrJA8WBh7wEAAMNE
	SdDbu85W6pyEd1Qc30N7IHNMcFUeL8jtpKpO0yNLM2FCOZwbq/vNLJ4FM/5FVnvzxil/sAjZIsb
	G/kQFDOt18sQdqs5VSzE1/wZojR3W5uajo+6Ei7oKP09rpUUW8TSTU9qV/3krCprY9i21gVD8gi
	Q6TJr106xS9a9k75xWnY/QeUNJskbUIzb4g==
X-Google-Smtp-Source: AGHT+IEWHMg7r/bbCRzHBivua909Us/xJNOCLlCnavKKuaWYTkR0SEb2677EsXUGaB5VbwPFaaPXOw==
X-Received: by 2002:a05:620a:4454:b0:7c5:6291:904d with SMTP id af79cd13be357-7c6908758e1mr1210862685a.38.1743429760547;
        Mon, 31 Mar 2025 07:02:40 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6eec965a7d0sm47231246d6.62.2025.03.31.07.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 07:02:39 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 7/7] ci: add verify-trim.py test script
Date: Mon, 31 Mar 2025 10:01:34 -0400
Message-ID: <20250331140204.1971-8-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250331140204.1971-1-vincent.fu@samsung.com>
References: <20250331140204.1971-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On GitHub Actions we cannot insert kernel modules, so skip this script
on tests that run with pull requests and after every push. Instead run
this test with our nightly tests that run in a QEMU environment.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 .github/workflows/qemu.yml | 4 ++++
 ci/actions-full-test.sh    | 2 ++
 t/run-fio-tests.py         | 8 ++++++++
 3 files changed, 14 insertions(+)

diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index db71fbe8..16787018 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -49,6 +49,10 @@ jobs:
               -device nvme-ns,id=nvm-1,drive=nvm-1,bus=nvme0,nsid=1,logical_block_size=4096,physical_block_size=4096,fdp.ruhs=0-63
             test_cmd: "nvme fdp status /dev/ng0n1 && python3 t/nvmept_fdp.py --fio ./fio --dut /dev/ng0n1"
             extra_pkgs: "nvme-cli"
+          - config: verify-trim
+            device:
+            test_cmd: "python3 t/verify-trim.py"
+            extra_pkgs: sg3-utils
           - config: ZBD
             device:
             test_cmd: "./t/zbd/run-tests-against-nullb"
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 854788c1..4222a21a 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -10,10 +10,12 @@ main() {
 
     echo "Running long running tests..."
     export PYTHONUNBUFFERED="TRUE"
+    # We can't load modules so skip 1018 which requires null_blk
     skip=(
         6
 	1007
 	1008
+	1018
     )
     args=(
         --debug
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 7ceda067..b4863297 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1115,6 +1115,14 @@ TEST_LIST = [
         'success':          SUCCESS_LONG,
         'requirements':     [],
     },
+    {
+        'test_id':          1018,
+        'test_class':       FioExeTest,
+        'exe':              't/verify-trim.py',
+        'parameters':       ['-f', '{fio_path}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux],
+    },
 ]
 
 
-- 
2.47.2

