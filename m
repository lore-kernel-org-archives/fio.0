Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DA82BDC33
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466324; cv=none; b=UyozW/Q+WxC3WZJUzcs3LOJi4kiyqi589/w8KzgxNt1pZgE6OFqLtsbIW92qC6WBQ5XrfSo0puyc7ENdIYSEIn7QaxmdATtynxgwvU0Od7y1Qdc2D5f8AjHCj28xlhuJeKOMnkRIoBVIaj6LtYDkk82ykK/o9SBCcgb80uN51oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466324; c=relaxed/simple;
	bh=TImaXEN6pwMROLTXh4r71cxUZXNIjbO5uaX4YTNsLYA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UzTn1VuhItl2X5H14tYIp5RHCnvkcHXfKUB78PP/EtrsfcWC2Dnh1lQu7Ezgz8LMUqb+xX+AOICXo+etjfICfJzD2pbqzNn5LWXggtcW9iZ+ZUsnjVf9r9YfYPrNfxsKcgR8qCSrkA/e+fSgsqZ4i53vY/BARSWcautWN7uiXGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TSloaCRX; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TSloaCRX"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-7072628404dso7429966d6.2
        for <fio@vger.kernel.org>; Fri, 25 Jul 2025 10:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753466320; x=1754071120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a5AqjsWhg1jZzVn3CZokwNiIhDL/HMtzkE8yi1a3v/4=;
        b=TSloaCRXf3oKG4Z6snNxz+OBr9hh1sUv+kfPmbxtbndk2LXoQ9addV64zfOLtVNLDM
         U1lPvk03f5x1sfqBzzQqO+EkCkqy5bMmJKDsi3oWMhGk6cBfVnzudeuTkEw6UEBAMphe
         hZ+XEjCOYIShH4xM1g5AdRbsl8fQR9TcqS87ENJH9Ae5qbtTTDWaM43wBufRfFbX30AI
         il+xCECy+gMPIlZHaXlCRLeygV3SX90SB8oTMaNK+XkHIwGh8kOTBc3kh2B9oPQOocps
         e7Dzy/G6aliMHg5gnANZbTDsF+HSX2kZ7Ah7+MvhmgGkTb6V3IHnIfGoTLcLyZGAtzDy
         LBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466320; x=1754071120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a5AqjsWhg1jZzVn3CZokwNiIhDL/HMtzkE8yi1a3v/4=;
        b=gCZgikjIind/KDD3Eg02mtozcHpsT5nnn2EFRC6qy07oKSK3vM0YlrMxrugLaVJWkM
         +uySLt77KjYF3m0Lh2VaDxrgj0d1ToAqIVtSOSu10pXcJL5xqaaCuN9mVvHSG10oXel/
         ceExdQ3cpJUuQllOJAFOv1h4xipUvECZtMhpYW+8+26bktaAXsGekQjRexuGcLsCZ/c6
         24TN78K9hpD0zlrsPYhouZtKr0XpliJ6en53CdH9TzS2JkGBAGvoIeav9qxHmqQNDsWK
         jDJViQ3RffSYDIBtt+qbQpE+QWUPRaHQvBo04vn/ItpQK7E/HIPNRoDjB9LX3VBpKAEp
         mz1A==
X-Forwarded-Encrypted: i=1; AJvYcCXQPVoY9XllhOk6MSnUvJDvracUSbqVQh0ssuZlly5Q5mOHvANofleu5++96Z+Mrcq+y74=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8SR7d+ES/dEElQqwnaYaHKQoVlUBSMWzq7MwLWhijKhKiH+18
	LbcUdZGSMxyJy5c/iQeDTvibnwh8ZWtN4q56kqsMPB5tJMMC+iAOZ3f7
X-Gm-Gg: ASbGncudTcWUBAarIgkUuyp9Y9aiAWsdVmezWPf+tdWW+XmTa/V05Cwv1PRx375yMbm
	E03RlHfM+YwxGW7RY2q/OPnk2Zr1ZoawdXe8Q56WHjYOBzksAq9p9Wb/6M9rHA7DMhRqcGU08HL
	ZMauOUgauU6t+v82yU+kZRtl1gN+x/UcVCVAIGQcSbLc5qG2/CSwJUoovXi3Ba8PeH6Fta7d60M
	R/B5mk9L9TZGQC/ANvkwq6xFYuPeMFJlfOn1w73SBbPEvWKMVxE0IOed6SNJyPkmeUy7yXpJvOT
	GrZ6YebDnrhN0ODDrgNY9a3+1OUEIPGOTXs33xCXuQpV/PWCifMCq/vDc5AZXhiS5207IiRoBX1
	aAjRqipaQqNskcw26iQD5Q7WjnR/EhB2JmnBaoD21Or0PfJ6W8eWpzoVjqfpXqC3I9XH9ZLh2Kf
	89Fq+di8la
X-Google-Smtp-Source: AGHT+IHmwaK4XhEXDVgEkiopGfR1n2H+fZ9pAHPoeQT1EecKTkrj8HFg06zHI9XKTATaeF9w5OP0fw==
X-Received: by 2002:a05:6214:500d:b0:702:d418:1484 with SMTP id 6a1803df08f44-707205ef609mr39367496d6.43.1753466320375;
        Fri, 25 Jul 2025 10:58:40 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-70729c8ab8asm2839186d6.94.2025.07.25.10.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:58:39 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	anuj1072538@gmail.com,
	hch@infradead.org,
	joshi.k@samsung.com,
	anuj20.g@samsung.com,
	fio@vger.kernel.org,
	gost.dev@samsung.com,
	ankit.kumar@samsung.com,
	martin.petersen@oracle.com
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH v2 0/7] io_uring r/w with metadata
Date: Fri, 25 Jul 2025 13:57:56 -0400
Message-ID: <20250725175808.2632-1-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for io_uring read and write operations for
block devices with metadata.

Patches 1-5 are refactors and cleanups to prepare for the new feature.
Patch 6 adds the actual support for read and write operations with metadata.
Patch 7 adds a test script for this feature using NVMe devices.

This code has been tested using the kernel below:
tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.17.integrity

The new feature has passed testing under the following settings:

QEMU NVMe device 512B data size; 8B, 16B, 64B metadata size; 16b Guard PI
QEMU NVMe device 4K data size; 16B, 64B metadata size, 64b Guard PI

I have not been able to run the following tests due to platform
issues:

QEMU NVMe device 4K data size; 16B, 64B metadata size; 16b Guard PI
   nvme format fails
scsi-debug device 
   module is loaded with dif=1,2,or 3 but PI support is not detected

Would appreciate help anyone can provide for the missing test setups.

This series has passed regression testing with fio's automated tests:
https://github.com/vincentkfu/fio/actions/runs/16526902163
https://github.com/vincentkfu/fio/actions/runs/16526978984

These patches are available as a branch in my fork of fio:
https://github.com/vincentkfu/fio/commits/pi-block-v2/

Changes compared to v1:
 - Added patch 1 to store ioengine id in ioengine data
 - Move refactoring changes from original feature patch to prep patches
   (Jens)
 - Added patch 4 to simplify io_u_free
 - Added patch 5 to fill in guard generation options at init time
 - Move metadata-specific code out of line to separate functions (Jens)

Vincent Fu (7):
  engines/io_uring: store ioengine id in ioengine data
  engines/nvme: move inline functions from .c to .h file
  engines/nvme: refactor filling protection information
  engines/io_uring: simplify io_u_free
  engines/io_uring: fill in guard generation options at init time
  engines/io_uring: support r/w with metadata
  t/io_uring_pi: test script for io_uring PI

 engines/io_uring.c  | 315 +++++++++++++++++++++++++++++-----
 engines/nvme.c      |  35 ++--
 engines/nvme.h      |  18 ++
 io_u.h              |   1 +
 os/linux/io_uring.h |  15 ++
 t/io_uring_pi.py    | 408 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 731 insertions(+), 61 deletions(-)
 create mode 100644 t/io_uring_pi.py

-- 
2.47.2

