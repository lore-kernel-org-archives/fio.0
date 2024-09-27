Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041EAA920
	for <fio@vger.kernel.org>; Fri, 27 Sep 2024 03:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727406552; cv=none; b=hAaX6oBFL5nVLTM7zu9aVepHPK67pro8rqN+2492uN3co5lsVqDBwZZmMjdWx90Jq0VEjUA18u9INvQbNpggUA2h0qZmS7nzH96jqEyChjOsR1y/sSwWFDeXQKX/1m3Mpdk+pKSi7mb01iiNTXOkQLOzH1E/7HGd32Z3fkeDzC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727406552; c=relaxed/simple;
	bh=NSZnfPktMKqWvGHZV/b+gPv/oF8lDp/E2AHqTMNxOBI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tfiBA08haPAcJ8NNnrFy9UeyFIiW10277T6h9c4pzwCiWEp2IwMRSp1/eQje6AoW2b/uPeDQxWRGHHJgcRUGevvV/BGxsVaDNWAGYFfpz4PT3sNukl1Y2F/D/BzjYXHFw6a4pLpwO2HgnetJiAxouIT4p5JThK/aBun4nDUvbos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3snr2S4; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3snr2S4"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-718e25d8b67so117943b3a.3
        for <fio@vger.kernel.org>; Thu, 26 Sep 2024 20:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727406550; x=1728011350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L430UzJfql/ARLq/Zku08v+T8emucEHQyzjq18IzxDQ=;
        b=Z3snr2S4TC+/CePnVsD+LIXu89F12Omer34wHTpSQUkYevy9oaXgn4vK5guHohHVOG
         GS+x3yOo0k13Hd/Oko29dz0U8fqZgJhC9hF5uY7IO5ByoleEVf0cHdHhansoldglXe+0
         gK9u9qsnWlp4ljMP3gZwz1hbe6hR3Ex9hCZjzvBnRvVP7BsGnTZ8uXMnOeuauLZCEiLs
         YmXeRoshOyEL2zTypfmWDPsDgrm3F0M/pbUjI1yQXYyuRC8o1cThco8GfkW4ZHfpGH9W
         37TqEBE104ZhNaoRdBo3hzj0Aqv53UTy3jqzVNErMgryIV2UDV5Otfhfw8nxXLNSQsth
         MP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727406550; x=1728011350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L430UzJfql/ARLq/Zku08v+T8emucEHQyzjq18IzxDQ=;
        b=bNcKhCDunCGgx7ZLZPANXGBaOvLchISEILELAMh7lVuoS+/ofsGaKYQ8rvjA70loDX
         t6qhtrprYhvkp1PZ5NLBut5NO0lR8WyXguQviOl0IapTxfnUZTQpujESiSCh0eO0e1EN
         JB/6oH7I56LA6ZF6uOGG8+BQLplvXtj2ooPTBfV6ezPI9HlGJqCgHsSXN5m2AacxHXrz
         +b+Q1uD0K6r8Jl1MNzod78bwFbZV+140vL1jbArYUVA+N+c54iK/73YVJzNTmgD+LyMh
         GqY4UcjJ25l67JaKJeS0CUDsxWBY+t1dCVewaH8p4Nw1PPPFZWjZDjohvp878NWQymAY
         VAoA==
X-Gm-Message-State: AOJu0YyVh2nc6XL5ul+FPsg8MuxOAhCaMIpibFRcV4GzhNSuPKxEeD8T
	CKW5XV6bfrmYunDQM0aEeowvqWfMpUW/Yu7HQ0+mUvJYdYXJ37EBHlKbrQ==
X-Google-Smtp-Source: AGHT+IHlpiErVIBxspLpx0Tm/mi72ZjGQaahYvM6uEBL+ojVGdhxT8yhthunfdWfSV8cf6r2mbtpww==
X-Received: by 2002:a05:6a00:39a8:b0:710:5243:4161 with SMTP id d2e1a72fcca58-71b26079b75mr1222225b3a.5.1727406549954;
        Thu, 26 Sep 2024 20:09:09 -0700 (PDT)
Received: from localhost ([116.121.76.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b265181f9sm601126b3a.133.2024.09.26.20.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 20:09:09 -0700 (PDT)
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Minwoo Im <minwoo.im.dev@gmail.com>
Subject: [PATCH] engines/io_uring: Fix negative errno in io_u->error
Date: Fri, 27 Sep 2024 12:08:57 +0900
Message-Id: <20240927030857.17001-1-minwoo.im.dev@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_u->error can have either negative errno value or device-specific
error status as a positive value.  fio always tries to parse the errno
with strerrno() and it expects the value to be a positive one.

Commit ebe67b667f25 ("io_uring: Add IO_U_F_DEVICE_ERRROR to identify
error types") tried to abs(io_u->error) to convert it first.  And it
caused the following build warning:

  engines/io_uring.c:553:16: error: taking the absolute value of unsigned type 'unsigned int' has no effect [-Werror,-Wabsolute-value]
          io_u->error = abs(io_u->error);
                        ^
  engines/io_uring.c:553:16: note: remove the call to 'abs' since unsigned values cannot be negative
          io_u->error = abs(io_u->error);
                        ^~~

Commit 9eaa8e7c8e0b ("engines/io_uring: don't use abs() on an unsigned
value") tried to remove the warning by removing abs() on io_u->error,
but if so, negative errno (e.g., -EINVAL) can't be parsed properly like:

  fio: io_u error on file /dev/ng0n1: Unknown error -22: write offset=429916160, buflen=1048576

This patch fixed this fixed to convert to positive value properly by
casting it first to int and then do abs() on it.

Fixes: 9eaa8e7c8e0b ("engines/io_uring: don't use abs() on an unsigned value")

Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
---
 engines/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 6c07c1011c40..85cebf8371cf 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -589,7 +589,7 @@ ret:
 		io_u_set(td, io_u, IO_U_F_DEVICE_ERROR);
 	else
 		io_u_clear(td, io_u, IO_U_F_DEVICE_ERROR);
-	io_u->error = io_u->error;
+	io_u->error = abs((int)io_u->error);
 	return io_u;
 }
 
-- 
2.34.1

