Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C983A2882B1
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730753; cv=none; b=YPzj3I5uKyQbcNrILLs+jixF0CZd20DftMef+XXzvbQUrqxANE4imUCKpfrkZUihcvbDrVT8YkPbc2khMSLUAbZgilXJYlfQ9xZ57Q6rp3DtONPyxFiY7x8WC+xC+ufGhy4xYAct6mLiASC850nkcGhD79AFzHy133cB0oF1Zk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730753; c=relaxed/simple;
	bh=wiidl9CClEZKqT/5ZUPjJrSrWExj+XXMTh51e/BuzNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNdo9qEOqtiuHTM+yRo4mEfR/fAJo4O/FPwProeaC7sJ0zNXvxg5RJZcd9I5ZbTr9AOi4Yeu9Cb/eFMbE358wrxKfYyWx4JKrB+wNjnUdo7lFyLxskRwZcbWDgrYTNxrqdl3UIqtYikw+8uVGXHEj7NI3jHZCDPe2FE3/4BRCNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKdS5byo; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKdS5byo"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7c54b651310so183422485a.0
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730749; x=1747335549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sh8WB5S44Wu9D+5gth5z1Amb/tfD2HsYafwufBDygMo=;
        b=KKdS5byo6TAfiqQaeQlNRxVoniOwJj7ZvA/+Y4H1yBNphXwAJ9d926jMiK9hsZpiqb
         6hL5DiSkBeeenOUDOtQ0lCuez25gdTCUKgQSBinBHRgv5J8FlJn68ia6iYWVeG6vKbrn
         eD4KE7j2iNd3eAGNRJkux5+e6T/N8XN6uzGoDaK9c1fQ/zKEeZyIzi2sjeWKlJj6oW//
         LVQEUnyz6099W/KDQx0Og8bqiqrZ1zEJ1lqU6UQ5uU+FRITI6cc95mYqe8VaLcPEHH+g
         kckKDYHC+oWkoZaDYA7OMi+MkkkAaq7HobMxBz1JMf3Clhwz29EJAAoWPCwTyLfPaHBY
         iD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730749; x=1747335549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sh8WB5S44Wu9D+5gth5z1Amb/tfD2HsYafwufBDygMo=;
        b=WGn51UujIBs0iz8O0r3abGenA7uNHeAAh4lgDEWZ0g3rzYTvT8CYyKEyAzy0xkd12z
         JNAY3YCY/nr0/l6yzRZ2+pmZpxJDlQtEs0z1GhwDpAZlJWkzKBdeKimbZl/4YAamUqXP
         EqoHAxPDUX/bzTFCq9W5aMa4pKBNf23NoWBBM4aVRsJYf6oubP7U7Uk73GLu0Ysd3+6Q
         EcGf3xbC372m4jfGQssw0jQfopEFYGnEMP6ZIpEOcC9Id3iBFTac2yUVM5iT7KrbwDzZ
         wNhvwvdxG6mfLPXAyAjM0hn5mv76gRECaSGNV7d//IVvhlUMEclxeL86kLsoo8Wmbu/b
         neRQ==
X-Gm-Message-State: AOJu0YyLO660I3qSriH6Oy/4NP82qtdK5DEc4SmjSkmiPCCntv4OK3Dh
	ITbFLtMsXJcrrO01UVWC1+aIDebFD9VnQUxoyPlIoukF8woJwVOAgLVWLLBm
X-Gm-Gg: ASbGncuRWiDEPq2dYCfKWqXuZgiOh3qWOyTRtjKFgToAzu1i8eZ7URQWoZMhrabBPLX
	m6mSFNTzmJmQFLsllGQZCfLhX/V4hpYKeIBZJnfymLqwZkzroAYIo/5fb5S6ay9V0qM7AQtFSO1
	6fPe18TT5Soc1zSQAXag5jC/doCVG/jgxwsw4mHu26z9J/epQF7CI0WrYpdt6NpLvT4DEigMiBE
	NLKS5N4lRK+IsL+MIIiKKKBz+yKU0HqUvgKRMKdAKk0ARtACnAIkCeIq0/0khpzMuTm5bgBS6bO
	N5KdwwwDIohThGInU66ne6bGz+VS85fnVl/gsjkXACzbRqo330l0CWUVZ0HrWQrgSN4RCy9QzmB
	PelhIkF4UK7jcccbtRNxXXeZCyALFHQ==
X-Google-Smtp-Source: AGHT+IHiQh6RBcrFu6KV1O5CEgwykg75ZxX1I8dFuHQX34wV+Rxhu+cApzORv82jyGkh+uFN0qdOeQ==
X-Received: by 2002:a05:620a:8328:b0:7cd:145:994a with SMTP id af79cd13be357-7cd01459e06mr68307585a.11.1746730748650;
        Thu, 08 May 2025 11:59:08 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:59:07 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 06/11] ci: for nightly verify tests use all checksum methods
Date: Thu,  8 May 2025 14:58:14 -0400
Message-ID: <20250508185832.3702-7-vincent.fu@samsung.com>
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

By default t/verify.py runs tests with only a small selection of
checksum methods. Run the test script with an option so that our nightly
tests use all of the checksum methods.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 ci/actions-full-test.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 4222a21a..6ff13c4d 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -41,6 +41,8 @@ main() {
 	args+=(
 	    --run-only
 	    1017
+	    -p
+	    "1017:--complete"
 	)
     else
 	skip+=(
-- 
2.47.2

