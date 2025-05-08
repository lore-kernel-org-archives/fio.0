Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA26027A12B
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730754; cv=none; b=JBzpW05SecDUrhgPasadzvXLUUJTS09qp/N7d5nrGUmvzzLuIAPM4t1b/ePo4TZHzlwNepRwhCAzOfyB3bq4SotYVu7J8SOWkUHm/saBjf0ezlCGFavqP40sSYdet9+AAwubuJMS3KfNoag3vmjUw8PfUmKv5SwF6PyzzeBapQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730754; c=relaxed/simple;
	bh=ERljTyFeynBHy/7QtP012Q7pBdV4JgyIc4KV7wT5IeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbNxoStSViwP1YjjwYu/G3ga09NWf9PBG5fjJxU0nudOCy2idl43rTJp/xZStOwBCxXLSAEJBMvclK5T2dcd90E92u6y/3Offxm2mvNHmkdjfPV2vnHiW5IH+sqWuoEhr8BWm7gLlYhGiVuO6J54/raXMz+6KUUo+ZY61KvU3iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=biDwHg5j; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="biDwHg5j"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7c5b2472969so139199685a.1
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730751; x=1747335551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZplZcmxYEVarCw005hg2R0fBygRUR++NafuCtftvSY=;
        b=biDwHg5jxv12ZQKFAHioOL+Hno8Akz+J9ZJ1sKB2lrg5L3j7lfCun5/xD1jALi5Nkn
         ZcEcZuxJahObK4qyxyIsdW53We6aqnK0lrjEtcD+KISnNQuHCcFQR9fFznggEjlD6lS8
         YFpoHMutyBW+qMzzOsYJ0SPQiIeBwDAs+/ksiSQbhBnJDWpOViQTy79L1I29LYZWZclS
         yyYqhA2hqQtMdtBXtpgOHuOxsDvUHdXgHiQiNqBWmgBXkPDD6RbIrb/lCel7Fz2r2m3Q
         n6bFouDIdoRjk31ap4TL9f+wPmrSbSDNbq56hYDJpStponlWCoHtjILAmZaBugXCMweC
         RHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730751; x=1747335551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iZplZcmxYEVarCw005hg2R0fBygRUR++NafuCtftvSY=;
        b=CNXumhJtpY62frJuQlOCfXcfA0rk0KEbX3/L+ylXhlW4XJM2Da0hgFKt7N2u1VZFyf
         V2k7LMaNMUc/cYJSdJDu06uaSHKKDuCEOVxyZa6FtHbtwEpr8mDs0G0sgADONFwfPyR6
         1qYfDTeQccEe0/omcL+2/k2futwtz5cPMRYcKG8hQh/BVpMUu1PhnheY5uqzD5/Ln6H+
         7oKjmpPjJC4aHkejZM8Dv/b8wpTdZt0eXcfCIGHmwLD+hNGis6P8ZbyB5h5G+5ilrRS7
         5XZT+73jpa7lDiOSN7osS662ghPLCbf2eCbPD7AkN30JNgh0gllbuCxYK3qbyWem/y3z
         qt4A==
X-Gm-Message-State: AOJu0Yw7HQ/C3P7fUrHFGGW3GoQkgos2fYiB4dfLUJbwNOKbDGjKLRx9
	s/jeYXYim6+m6kKATxo0xV0RQ66yqfIlj/K+XRQEWdlzDvCkqR0OhYjfx9qH
X-Gm-Gg: ASbGncuVCgivm2ylwPrawAUZVUpl3r/yDZJb51drP8y8C9C27glK2jVMGtiYxQgmi+D
	IzRFl+ipPmWLo99MCuk7h57Y7W7W1X98e8WBSLdCOzqxi7NG4aoW+CxylOrQYKPipNiDDBqbrJR
	iCfTm81Jr9GQYjwfSWDz175PuqHAGuqaVWpc4lFOlkhZlGrENXBmPwQdLuo7oD1fPGHZnsZ1VzN
	In3+R+YdUG85AFpLmjFIkmRPo0MPJEzRjInBPFWbgFjnMUPzn8M4VVeNl7IFNXDVA5NUFGKwAwb
	sLNsn1shCAcgCdC3/A8l3uvv1cnG3rA60afFdFwTCFRA6sACWeI4BtNdxeljIuQpmYv66/7uZC4
	SCtxGxa7FgNVRU00C5AR7fFcla7VaPg==
X-Google-Smtp-Source: AGHT+IEMZdN4wbjQO6ApQd44XzCyzVLSOtEc++SeEd0KMye/WMFzk2yRCkFne565QsdVzYLeVA6uqA==
X-Received: by 2002:a05:620a:2628:b0:7c7:93ae:fe56 with SMTP id af79cd13be357-7cd01168d7dmr120424385a.51.1746730750640;
        Thu, 08 May 2025 11:59:10 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:08 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 07/11] ci: don't skip verify tests when triggered manually
Date: Thu,  8 May 2025 14:58:15 -0400
Message-ID: <20250508185832.3702-8-vincent.fu@samsung.com>
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

When our test suite is triggered manually it skips the verify test
script. Change this so that the verify test script is run when the tests
are manually kicked off. This is accomplished by skipping the verify
test suite only when a push or pull request triggers our tests.

With this change we don't have to wait overnight to see the results of
the verify tests.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 ci/actions-full-test.sh | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 6ff13c4d..6fa9f4ad 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -35,8 +35,9 @@ main() {
 
     fi
 
-    # If we are running a nightly test just run the verify tests.
-    # Otherwise skip the verify test script because it takes so long.
+    # If we are running a nightly test just run the verify tests.  Skip the
+    # verify test script with pull requests and pushes because it takes so
+    # long. When this workflow is run manually everything will be run.
     if [ "${GITHUB_EVENT_NAME}" == "schedule" ]; then
 	args+=(
 	    --run-only
@@ -44,7 +45,7 @@ main() {
 	    -p
 	    "1017:--complete"
 	)
-    else
+    elif [ "${GITHUB_EVENT_NAME}" == "pull_request" ] || [ "${GITHUB_EVENT_NAME}" == "push" ]; then
 	skip+=(
 	    1017
 	)
-- 
2.47.2

