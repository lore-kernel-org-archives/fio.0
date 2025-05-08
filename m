Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC92165E8
	for <fio@vger.kernel.org>; Thu,  8 May 2025 18:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730743; cv=none; b=so4W2TfnA0r62BvarbhdZDPgWAb+ZQ3QEfYLApYrtiwFtlcF7bxHFsX+N97axQFz/R81HCiMpJNNqgd+pgECp0/SY/Xx3EghjPI2gu/+Eq+58KK0O3RHOmMui9brgvUcy6i/0hUbCYKXxSnWG7pfns38RJdTaEd1vtlokqPCV48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730743; c=relaxed/simple;
	bh=P0G8+cbeqcchIl2iylPM7emZiqfr0Pi/cCuB2ZJtoUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oCbODQjeyMnX6GKeg0OY3AVaw4LnnHyN9GyfTXSDmZN+wVf+LcVSff2KbEgx/bPrmVVpPe/oXjhMsFX6gM/D5onBKH/qDsXg+JQAjSAPmTbme3eJmICwdiA4Ucu4CiR63pinRzI+LO4N0N3udmO0zLWSDyQCxyUK2kx2a/IkX1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d6kCi0IV; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6kCi0IV"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7c5f720c717so294825485a.0
        for <fio@vger.kernel.org>; Thu, 08 May 2025 11:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746730740; x=1747335540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FtBqDsQ3f7QFZGDBjtZBaWK39cDvBnHniqGSyBCLarg=;
        b=d6kCi0IVsBKNiBFF38ljJ4nSSbXHoYmi2GHTFxzn5tr6uO1rysK9nnWA2RbkJdY13F
         VuJ6BulUrzWgJiwNC1pBy9ThsnpBgGoT380UPdZPKG6rISFni0leT1kXCbj1YJtLctek
         Ggw/2DiKW3HpJySS4jiZJUVC6tYXp9EfnN6KH+MgzVVNjnq34rZnL4x2nRleqeh2G5uE
         vu2WGrd5mhyxmKDdDxoNgavA3QQS4jKF2+dX0IJOWpmhQT8Zy2DHG1QyFH0DdU2VL8nM
         d92snL+1nZXud79zphazsLg1WFP7rIqLJjxrDzhEGwknFAk9z3xX/x+EpthUK0EjgESv
         y/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746730740; x=1747335540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FtBqDsQ3f7QFZGDBjtZBaWK39cDvBnHniqGSyBCLarg=;
        b=GgavaZLtWfDPX+/t9aw6fCpSh+rAwSmidlYbKqIFZjtOeG9/xuD9e1ijmtQfKqs6/A
         02zW++KnklXYlHCDvvwQm1nDQI9bQNoT2QyIx2GVyFP+rVJ6eKaSS7VTfXUvv8wJzMiZ
         gKGqkzeQOrYtaS0LSJiuKOIBdrYAUQ6LG4fJuVigdqlg9l+HR4vcABbG/Bt4HLEPrsLE
         Hmg5AwbUW2T7GPN3fyzjMy3r8QG9KYgLI3emM+NS8UE7STiU58st+VQtkY0vMRkuNQn2
         cmaYkOg6lr2h+1cgGjZ/BrGU+WbZE6ifwSAxFELewMSjgh86jWzUoUwhVjZcNnKtrMWh
         WwkA==
X-Gm-Message-State: AOJu0YxeWXbddRy60kaNwV71y+HWYk76sxgwcwQc9EhACzlg9W3YBhQC
	G8uKEbI7SohSNb0u8kELMEvWvotJkj/ZbPTyc+huSoAZDxFO9FssbIrTK9fX
X-Gm-Gg: ASbGnct0C5UrMjulyX2/MbV4lnU7HHsH+o9hdhlxhUfewNiWOGVuNY31zEzsvKi1X3u
	YuuqLW/KunLXihL4xKKHjqgG3hKpq4TZl0c1GQdpGS2FcsBLlHtSZs0tjVxBc8NYL7GOxK+RKX4
	BNBmBkuxliZQGzxvRDfJw3NQy8ANKl8nsnlgxb6hQnA+g2RSw8M3yTPaHJ+thd1amutLhs1uqyW
	FNLX77kwICSq13XE/thMqLMmCj31TXPVyjSCSyewCX8yBtBEZ8sO035OJl1If61tUD/OLsQuG8d
	F1AFvTYER7TbJlvbdZdTZ3A07FhOOaxEBn0T/bmO2OsaJEtZq69wipjqa3FjwMiTXZ/p2E9ZBoO
	mGAlVJm4T6Vi1xKdK3nOLnfwG3WqEJw==
X-Google-Smtp-Source: AGHT+IEcmBtq3oqiAGYY5D8ZQGwHS/7HRPrbl4uS2kBWkkV459aXljw96Jxl3IU8Ew8k4pOqLcYKiA==
X-Received: by 2002:a05:620a:d95:b0:7c5:9566:83dc with SMTP id af79cd13be357-7cd017d2ea0mr53289285a.25.1746730739526;
        Thu, 08 May 2025 11:58:59 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7cd00fdc59csm26611785a.77.2025.05.08.11.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 11:58:58 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.dk
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 00/11] verify pattern interval
Date: Thu,  8 May 2025 14:58:08 -0400
Message-ID: <20250508185832.3702-1-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds the verify_pattern_interval option which
refreshes and restarts the verify_pattern every N bytes. This is
intended to be used when verify_pattern contains the %o format specifier
in order to write each offset with its LBA. Doing this 512 bytes at a
time for a large device is slow, so verify_pattern_interval allows fio
to write this pattern in larger chunks.

Patch 1 makes testing easier by adding a verify=pattern_hdr option.
Patches 2-3 fix two bugs found while testing the new feature.
Patch 4 directs fio to omit an inappropriate error message.
Patches 5-7 improve testing.
Patch 8 implements this new feature.
Patches 9-11 add tests to verify the new feature.

Vincent Fu (11):
  verify: add verify mode for a pattern with header
  verify: fix verify_offset when used with pattern_hdr
  verify: make verify_pattern=%o thread safe
  verify: omit verify type mismatch error message for pattern verify
  t/fiotestcommon: lengthen timeout for longer tests
  ci: for nightly verify tests use all checksum methods
  ci: don't skip verify tests when triggered manually
  verify: add verify_pattern_interval option
  t/verify: test cases for running pattern and pattern_hdr
  t/verify: Windows --output work-around
  t/verify: add tests to exercise verify_pattern_interval

 HOWTO.rst               |  11 +++
 cconv.c                 |   2 +
 ci/actions-full-test.sh |   9 ++-
 fio.1                   |  10 +++
 options.c               |  16 ++++
 server.h                |   2 +-
 t/fiotestcommon.py      |   2 +-
 t/verify.py             | 123 ++++++++++++++++++++++++++++++-
 thread_options.h        |   3 +
 verify.c                | 158 ++++++++++++++++++++++++++++++++--------
 10 files changed, 295 insertions(+), 41 deletions(-)

-- 
2.47.2

