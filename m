Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F4886328
	for <fio@vger.kernel.org>; Wed, 23 Jul 2025 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753290353; cv=none; b=fuY4HEzZV9P7NDyxiZJ4rsylyeytfRxZsvXRAG9sDCsVpDvh/z+Uqhqit+VPYk+UKUp2iNZ7Slw4Aa11m/1aow8nyRJGAeRN2JedlzoDveXItzSaloeguoehpBLn7ocIukmePHxSkHDR8/LJHHqWYe/B0iA0cZeF/48/uCXXP5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753290353; c=relaxed/simple;
	bh=nHrWdDhywF+MP+oaHxXoCP7SceZVe/T9aw+QEA8csX8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P1CW/Fzgwc5vus0c9mJZicXRcIww/epS914WoJV/IW41cuMsj9neHPZb4mx+oCPmJ8EBjLX4XISG2GvzDcphDeRTPNkAnSFwRFZDtvQk+EhXpmEtHCiaclHhp28hpA0+zEDzOQU/nZmrObGt4M2HlRkAZvoQSTFavRcPH1SHtIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J3iWrU7f; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J3iWrU7f"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e62a1cbf82so8157485a.2
        for <fio@vger.kernel.org>; Wed, 23 Jul 2025 10:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753290351; x=1753895151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cD0xrvlhuPPMBotrT934FM5nKLYlIiKLvnNjpdzoWY0=;
        b=J3iWrU7f9e8kCDoTS3/XFvnHQMfxGv/S3/6h4jLfxUTO3a7T7OHc+zjrkIVL4Qaexw
         13CX7z+RQTQ5M7TWnkzCxjZMTOiqu5rCJIuYOruAF60Vhl2ufvR07zS1jd3WlIr1lTaC
         cWLTZHgsqz9ei1XWUhsb1dfONwTUbmL9CIFj8lAb/Ic090QdU8yX3P4yx0qTf58GiE24
         iLnHT10ESwhXfTKAsXSayIga+ftZVAMXXSGNLd+CT7QtTEo0Z1qdZjTLTenaylcsh1L6
         DDx6I66Sc6S+KMwr8o5Y6ZSQGkB/3KTysjPCxZj7Ad87YGfTlOwwptV59m6n5iKieGw2
         KaLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753290351; x=1753895151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cD0xrvlhuPPMBotrT934FM5nKLYlIiKLvnNjpdzoWY0=;
        b=amIkT+AdyFEH8mwXp3br9s6x5BzgaNr3idLwEQ/qkKRrxZIf9SkfRc9DllAVkYuUdY
         8sFbj1A5945nXMcp30TewFSZ+Co5YG1GEYTg2Dd7NcDKUGDsz3aOQkQXg1JOQtgEbz+y
         6R/vyfuwfuKSCQd3drKMBKGL12kcWRHvCaT/i3c80fccsC/KXRNtE8q6gFUGZJ7J/F+n
         8Aq6oTtRJTBxGmSDAtHzNLFEWBVUZgoE11NCc1LPNk1ZG4hc82Y2Psjuny49L6XXbPUN
         uxeY3RVO0JOzNUPJAN0QDyX4rDAdNJLHd8zEIxU3mb+YUytd0fqL+F5ivOOJgsUOzjF9
         i8qA==
X-Forwarded-Encrypted: i=1; AJvYcCXltfEl0O+yb/9ngSjTesQ6awOwN3LWQfoKOnob0Vg8x6rYAmlJwJRDb2Orie/gT6T4yZ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsD1T7wBmZ9jXx1fX0NkXYkOGM2gi56We6isAPHuODBkf/SsvA
	88XoXjwP0LTgzvJldik3O45Qnedr4MJx5LG+4sdwnw58bz2JyWxUkN1m
X-Gm-Gg: ASbGncsq1oTwmA2VBhZr31uEAJA3z0yZTdJ0yI+OH/CNS+oU/crvFJVFRZlB3g8IHgj
	ewqRGG43MH5Ut0Y/Mf3wOHd49h2dpE95/OokkjOqNyfKRYaWb1XeB7jskdNDSwnNHRhWJd0mRnE
	GmSo2NQwu6JqIRZObF8euLXJkG8gfjorGzOHyp0sIs0AzIW0mQgkdop7X2BLE4g+HNG8rQsUL3t
	r0ZKZBejDMA49jEchtlY/3MgupRot6opJKx7Lj7EVBanoLkYZM88aZA3fCRuraI8Yn7RzTaefG0
	FIQ4Qdq85hTH3YY+bUm27+EPMZwmH3RuaiTgRqSh3i0HmVjWUgTWGC5fE94l65xbRqbyOACMM8R
	GVP5eClU3N2swbvnKQCLN/wMqzgd22DMfjXnRqtgbO3AaumxuJZJWbm76Ev4Tti6nJP1Qf2jfu1
	5wFswFa9JVvIFWnq0DkNY=
X-Google-Smtp-Source: AGHT+IHsXL7CUwLH499dqCQMRbAChxETs8PrNOycHRzA3SWieNOe9sA6ep982tqZP8M21vm4qLRuPg==
X-Received: by 2002:a05:620a:2894:b0:7e0:e7b0:967e with SMTP id af79cd13be357-7e62a097ec2mr428258985a.7.1753290350379;
        Wed, 23 Jul 2025 10:05:50 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e356cbfad9sm675482785a.110.2025.07.23.10.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 10:05:49 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: anuj1072538@gmail.com,
	axboe@kernel.dk,
	hch@infradead.org,
	joshi.k@samsung.com,
	anuj20.g@samsung.com,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/2] io_uring r/w with metadata
Date: Wed, 23 Jul 2025 13:04:55 -0400
Message-ID: <cover.1753282479.git.vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These two patches add support for io_uring read and write operations for
block devices with metadata. The first patch adds this support to the
io_uring ioengine and the second patch adds a script for this feature
using NVMe devices.

This code has been tested on the kernel below:
tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.17.integrity

with the patch below applied

https://lore.kernel.org/linux-block/20250722120755.87501-1-anuj20.g@samsung.com/

This code has passed testing under the following settings:

QEMU NVMe device 512B data size; 8B, 16B, 64B metadata size; 16b Guard PI
QEMU NVMe device 4K data size; 16B, 64B metadata size, 64b Guard PI

I have not been able to run the following tests due to platform
issues:

QEMU NVMe device 4K data size; any metadata size; 16b Guard PI
   nvme format fails
scsi-debug device 
   module is loaded with dif=1,2,or 3 but PI support is not detected

Would appreciate help anyone can provide for the missing test platforms.

Vincent Fu (2):
  engines/io_uring: support r/w with metadata
  t/io_uring_pi: test script for io_uring PI

 engines/io_uring.c  | 241 ++++++++++++++++++++++++--
 engines/nvme.c      |  35 ++--
 engines/nvme.h      |  18 ++
 io_u.h              |   1 +
 os/linux/io_uring.h |  15 ++
 t/io_uring_pi.py    | 408 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 681 insertions(+), 37 deletions(-)
 create mode 100644 t/io_uring_pi.py

-- 
2.47.2

