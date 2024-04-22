Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8EC15444B
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808546; cv=none; b=QgI+fxMLV5e+pnN2GBw7v++kfEOk2ZhUxzxVlyOmDGWSMM/xOptwwPcMDNbeHCPRsUXq5cA+fFDN/2ZZEXrs2NNuv7+vls2CkZ34lXcM2ZEGuqNXgyHrtzyJ/AEt9xhnJKuWPWy52JtgqA3J1bpUwxAjAYXFeoOSUauCcb9pFKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808546; c=relaxed/simple;
	bh=O6b9I5EsoEWGiCrLfyh7m/4IjU39/V/jVXjk4jtsHK8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SEd8FoAa9L7gZN3hB0KiLseUxtD6B9ETDWZP7jDxD/j7U/LYf0HoSCcCN48W6VmYOHEZMLNG/8kL9Il7v8xMg47yblxEFxwjwbX2+m1N54u8cwjmRfjXJ0Jcvm4pAzOInqm02bXTLQVs1fxvji9ed7h76W/k5hXRxbFHxE7tsGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mXaznGn8; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mXaznGn8"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3c70999ff96so2932358b6e.2
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808544; x=1714413344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yU52rgX3GJbgsvUZVaMlpNAB1DhqQqILKmoKtUI7IHk=;
        b=mXaznGn8Zmr2XtE943A5i+yLbaXsf6tF1ex05pHoeo+dLwKEtOHt9UuK6VrUJ2XpAA
         6uhsdh0/WcxB6p82/oJdtUoYICrJ2fATtOf5/wF5HTD2FaYlzr1J2gKVn9O8UdQCULnI
         FiI9N4pcleJ7MY4IECqZhzwwmNmdbrfNZ77fR+B8bjffP/IkVr8grJgNs6F3qzLi+42a
         jcLVKkagQxpEaa+VWzgmYvAk4SwFqcIX3XrHcJJSsb7bA5fTFljwBzcxmaXhlCQBei40
         rbLsdkOPuQu/Jd70ytX2TiHOxbIBgS46NkmR7COeZlkbXR7HqKyThKB0E6g7FSvoQBbJ
         Fi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808544; x=1714413344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yU52rgX3GJbgsvUZVaMlpNAB1DhqQqILKmoKtUI7IHk=;
        b=QMD6PbLnYzl7mOMVCb6dNQgJDO4Y57yVKj1LBdMVve8dlXsPFJ6o2TvVrP31q4C97o
         Tove/qrDmbMyBkrxHisHbzVVLSdDloX3Uecx12GcjzCE+bMx04F7GhfzM8UfaXotgIcm
         LGR/TkLbudw9iit2yHjkDt00KD2ls1/66TcffOukFCQWoUiZ6jOeFIZKhBAN0Kxjqw5+
         biEswUpyQpw5x8U937nPGXZmGNE1V4JZEF1LuZcexZ4RfzohTWtyAKrkuxkCs1BVhHgo
         dYRJsSzFgH2FKfne59yvUkcjLap6/xi/RMP8RR9nppAW39hS1avazC6RoWTSom7mqe6l
         c4fA==
X-Forwarded-Encrypted: i=1; AJvYcCWPtvYiydHCwBGtdjMcJB0400yjn4pWlZoR7LJET71qfYsuoOdlGA0VD3JM8ueXViI/ois/ImgHvuo76V/bErsqwJAH
X-Gm-Message-State: AOJu0YzUa952X5dYfeLKBMHsfB3ytcoK/yyIG9wd9ZBLDnR7wVMpNAP0
	caRqX0wZJshCeQAuWrUjD2f0UXCT4H5i8SiPbnN6sbZYllNknS5L
X-Google-Smtp-Source: AGHT+IGLGBF1KYunY9lFOXqkU4/jhwbE5rJ3laMTLT4nO5yYo+AZeBXt2FkL2FXaIoVd+oThl1QTcA==
X-Received: by 2002:a05:6808:198c:b0:3c7:50ac:c570 with SMTP id bj12-20020a056808198c00b003c750acc570mr11370768oib.44.1713808543659;
        Mon, 22 Apr 2024 10:55:43 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:42 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/9] FDP tweaks, NVMe streams support
Date: Mon, 22 Apr 2024 13:49:46 -0400
Message-ID: <20240422175522.4614-1-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series adds support for NVMe streams. As a byproduct these
patches also introduce a new set of data placement options that
encompass both FDP and streams. The two technologies are similar enough
to be supported by a common set of options. The original FDP options
are retained for backward compatibility.

Also included are test scripts for FDP and streams.

Vincent Fu (9):
  fio: rename fdp.[c,h] to dataplacement.[c,h]
  fio: create over-arching data placement option
  t/nvmept_fdp.py: test script for FDP
  fio: support NVMe streams
  options: reject placement IDs larger than the max
  options: parse placement IDs as unsigned values
  dataplacement: add a debug print for IOs
  t/nvmept_streams: test NVMe streams support
  docs: update for new data placement options

 HOWTO.rst                |  36 +-
 Makefile                 |   2 +-
 cconv.c                  |  18 +-
 fdp.c => dataplacement.c |  37 +-
 dataplacement.h          |  37 ++
 engines/xnvme.c          |   2 +-
 fdp.h                    |  29 --
 filesetup.c              |   4 +-
 fio.1                    |  35 +-
 init.c                   |  10 +-
 io_u.c                   |   4 +-
 ioengines.h              |   2 +-
 options.c                |  61 +++-
 server.h                 |   2 +-
 t/nvmept_fdp.py          | 745 +++++++++++++++++++++++++++++++++++++++
 t/nvmept_streams.py      | 520 +++++++++++++++++++++++++++
 thread_options.h         |  15 +-
 17 files changed, 1465 insertions(+), 94 deletions(-)
 rename fdp.c => dataplacement.c (69%)
 create mode 100644 dataplacement.h
 delete mode 100644 fdp.h
 create mode 100755 t/nvmept_fdp.py
 create mode 100755 t/nvmept_streams.py

-- 
2.43.0

