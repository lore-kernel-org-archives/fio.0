Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549031BDCF
	for <fio@vger.kernel.org>; Mon, 31 Mar 2025 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743429760; cv=none; b=IwXvWXaNSfgjZsNLQetoZO61rBCNk9MAnBNHSrAMVz96Q0mRFP4WLE/kQi+26nB1Mr6ws7/FVYCxfxZ9kVj+jocEuw9OVbnidh0U2zeoMPEaFcMkTCx5M8riUcS37cC9ovxrJ8529gLUEmCf18VJYjW1MHHLveGR77U4GwRNo40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743429760; c=relaxed/simple;
	bh=Su1womhPZm7SYkltaiUrFEFkSkAUDFFJ96shqnRWztQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIHQQ4hx6aP1vLHfK9yITPQ8X2Lot6v/msroF2nXX+UnBk0VQ2bIWPy8Yr3ojwVZ/bjJRgb+IhGKLn/Z9SGrlY5xzntRycUVhPhimmfbi2rJ0f7FQpvW6PtLOpDTKfUYlkpmqG4Lg9rvLFnWPYRVPDWhwCSuIpN9qhHE7i2Djkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxWsGgdb; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxWsGgdb"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c3bf231660so531125985a.0
        for <fio@vger.kernel.org>; Mon, 31 Mar 2025 07:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743429757; x=1744034557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rP23PwD3ipBJx+QYmwqBgJ/FK1utvoYV6JF7p0WKSf8=;
        b=LxWsGgdbHAkVA6GYhEElzf+0zFaComUvgX8fWwhaTvpj6VzWRwMdCbk4QdeVlikbBS
         yqkbeJ+pXij42clS0guv4SnvLaDENTt04PIfdf6sdjzFvtnGgL/3Si0dUQCprzcHAQ7+
         ou3wzZsW1QacnPySS3tlk2QwXWOjpSJB5/RJhs4asiR0n3ZiBLD2Gl10yXi8U1NT3ayj
         D3yPdRekpGHB+ASqPY5mxBxGUPz91XsOz7FvOz8QrRic3S6zD22eOdmQ/cmyGLTlGmc5
         ioBWCspGwfvYeNkgOYTkctKj+wS+t56nSbLrxuFRlci9LyIDeonX3nfauaOnAmVmQgGZ
         5kAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743429757; x=1744034557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rP23PwD3ipBJx+QYmwqBgJ/FK1utvoYV6JF7p0WKSf8=;
        b=xILFQA0TdZtKkY5KSDjm7khnmHrGanHmN9MobdHb9JtVvDxfG9ABrWi1U+arXGCEpX
         hoTZdRPcTCx2yOoJKUs+p2M5aQVimeoZ+zNm+4RHfCNBEUYIEitP8ibDdPLWj5cSNPPG
         PQelnj7SJZoudKsNQ585Le5fz7ce9I20Dx3/VA3NkJjezkP/kK/NgYipscAv2XbIGPkr
         dldirhkEOTZPIuXydhERHp+b/qRa6ACwEQF1NldftpU1gZrsJheSCgM/qKX9yxSZ7ftK
         SxENNANFr11XXeYxoHIDfoCdeS61auwQYAyhNgm1YlvapbLElWGvZucqJmwiZr7Ncqqm
         5OVg==
X-Gm-Message-State: AOJu0YzulK1ruXjYLm66xyXGrxu+7duklTZ2JAkdUrJa7BGkklzuIsJ2
	BIpPZ6zjsVB9IpCAXVTdZWyhmYSo4dJ0OSERDR01wmu9oDpqsFao4AOkvQ==
X-Gm-Gg: ASbGncsqvv4AHhRKflIl+xUvhxKx0uw19cq26kRM9N3L7PV3jq9JwISiYHHtaupkWmY
	yuTufwXCSWUzhmPerxy4oZdWmm1Sbc6Qp6zH/8vRdQbALWh7UhQr7YwoFcS8LEHlD5uApKzDpHv
	PCBL+1s5G95wofhqw3zxY2rxUdVaBBCK3EdBRDo33IO4Tch+AwgI/kPzXSYsKVAIz3ezONw5nSH
	Y98jwIvkdE2XgRdDtfDuhxE0dxsttIhVCCMuKQKTEgrl2QZ2IQS0t1q0nFrqRSkdNpsnVx5Fm9b
	1Dx/KcMHOE8lgJnXbCtunIx8zAOfPlogln9WpiYgkWoD4oT4Merw7a7LMztoRcMYrqbIZ5p1nCz
	WLF1K8KNu+quhSFQaXDCQkV29YFQiNOxMrg==
X-Google-Smtp-Source: AGHT+IFHTElPX5kS1JV4SH7K3x5AZXoUaGx2sYtjQwG56t6JqSoua36EZUWAZrEInPVDr1DuEQiZTw==
X-Received: by 2002:a05:6214:dab:b0:6e4:2872:45f5 with SMTP id 6a1803df08f44-6eed620e7cbmr170128776d6.25.1743429756732;
        Mon, 31 Mar 2025 07:02:36 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6eec965a7d0sm47231246d6.62.2025.03.31.07.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 07:02:36 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: fio@vger.kernel.org,
	axboe@kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 4/7] verify/trim: stop issuing trims if we run out
Date: Mon, 31 Mar 2025 10:01:31 -0400
Message-ID: <20250331140204.1971-5-vincent.fu@samsung.com>
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

If we have drained the list of trim operations but its original contents
were fewer than a full batch we should zero out the running batch count
to make sure that we issue another full set of trim_backlog write
operations before considering trims again. Otherwise we will immediately
trim after each subsequent write operation until we have met the batch
size requirement.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 io_u.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index f7824717..66cfa16a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1749,13 +1749,17 @@ static bool check_get_trim(struct thread_data *td, struct io_u *io_u)
 {
 	if (!(td->flags & TD_F_TRIM_BACKLOG))
 		return false;
-	if (!td->trim_entries)
+	if (!td->trim_entries) {
+		td->trim_batch = 0;
 		return false;
+	}
 
 	if (td->trim_batch) {
 		td->trim_batch--;
 		if (get_next_trim(td, io_u))
 			return true;
+		else
+			td->trim_batch = 0;
 	} else if (!(td->io_hist_len % td->o.trim_backlog) &&
 		     td->last_ddir_completed != DDIR_READ) {
 		td->trim_batch = td->o.trim_batch;
-- 
2.47.2

