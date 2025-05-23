Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE06145B27
	for <fio@vger.kernel.org>; Fri, 23 May 2025 15:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748012761; cv=none; b=e/cwymOyWcTkfEPncxco06d0J2SFUbbTdZ/QeuMvhdAOX1DDNneHUgZVzlzHbK9oVyo5EukK9i3aGq4Agfl3tqVHbvUrSl0CIPPE8CaqNGq3Fzt3dPD3cegUnXTLezeTJ9u2aLjXFRLC28lA0BXMlI10xu2NJKupuNQoqnkYvjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748012761; c=relaxed/simple;
	bh=+bckg0S+LMC6ewGcp9nM1GBSTYVbbyBBCGOAU4tQgS8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=mDabkkY/0eVVLS6jUSCk1jQrTYEt6C2uAjGi95VIOZ/8dAl+XNGcB9OvzWZUn1QnLIQLvomfW8tvgYS1HIEJ8hBeW8WT3fTPSUj4q1ek8S8k2mLbvKGNtTogqS90ah9VhMqkOK45MLVQdtDC/NuGwviykvelnRlfxGEYhPzyBl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redpanda.com; spf=pass smtp.mailfrom=redpanda.com; dkim=pass (2048-bit key) header.d=redpanda.com header.i=@redpanda.com header.b=Srf19W6J; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=redpanda.com header.i=@redpanda.com header.b="Srf19W6J"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-30e7bfef364so59182a91.1
        for <fio@vger.kernel.org>; Fri, 23 May 2025 08:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redpanda.com; s=google; t=1748012758; x=1748617558; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+bckg0S+LMC6ewGcp9nM1GBSTYVbbyBBCGOAU4tQgS8=;
        b=Srf19W6JcxZqSeNuqDRLUYKq56GP7/4BtXjkHFyBHtCCbCa6lF2EzCKlDCqnTYmz0d
         6J+QqUw7uV7U2leM04PkvG0aC8v3TOqJwT1Lv2fyamnuOiLQyULjjy+2CG+kpPf+yuGG
         p++yDXLC2mwuJbutez/A45qAXG/qDJepMe+aS/p5ZYXetvudJFmhJhU/VelX2kK/En0C
         NciXFTk8QY5O2vA6KFT0zJazeoa7EXqfCTUSJ7/EW4KjYh+7OlMt5ZXatlMfLVv0w7rb
         SFepYnQFlDNpOdNdNhNZCVv66pY+7HiOvknOiOYmVlI9qbE7yt4z1HjJevvaUQ+jIOgl
         3fPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748012758; x=1748617558;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+bckg0S+LMC6ewGcp9nM1GBSTYVbbyBBCGOAU4tQgS8=;
        b=Kt1scoaTjlm9lF9PMRvl5U1bi7T3pvBp0VgOd1qF+PwSsaET9ZawjQE3dfrnCqYFoB
         IvkqZtQvc3/Je+huEviqQk8fOYKP4XCbiD8yAnf3tqxF8az4q7zi6zFM1RFYeeg3v/kD
         BWKE+EScVtxdTAEvp8yX6cwR85Qcc1qlKIRuqfmJOnB+GtUbV3D3WQFW8Jw0WRXXnkqH
         MLSQrYkotb0MTq6PGxuEqB+cSx/YlJkXQmBuLaLPD3LI3wqotqblIyyKF+aGK/lXlFgO
         VZ5D36U+6aoxvBbnRg2qOgTbv6dGQK8P/yGnax2QOMRRP6h4g8ZlsCOKMLlvFat9TdyX
         OQBw==
X-Gm-Message-State: AOJu0YzgSrqnMXZxWcLLhxC958lV5q83P2GnJkKsWAXoTHmWj7wizRM9
	TH400acZFLyosS8VKYe5Ix2xWwTJ2s7SvrYgQ9pdzzyNwXgFm4NYYyCTyHPV2LO+GnZt9yv42Pr
	wCZKOGlC9QC6/8acBI58/Qarfd2V49RfiL16DfLSU/qEfRcdkFYTzPQUlP+Sq0Iake4lrWPuIr+
	y3tAursVbbFV9SmuakkuZsfEDTVAGK3NTw/bgi
X-Gm-Gg: ASbGncsNmUr6UycZzbgNrbCI6XquWrscZvBxMdupYd5ylsf7dzAbijcbjp/TtIPLD5s
	/NCuevueadkqe8i8cCz7tSuTfG59H0zlY0qwuNxHCQrAIMD1MESvxjDXVdhitYqAxJr/eEIafWG
	wXBxDrPLO9i6WxKXuPns5EUtuzfieRRoRJ
X-Google-Smtp-Source: AGHT+IHhitSx91BJnCgieZlAufeG/7wiK13lh7He3p1mjqv16ZrNnCuxaIpbu+IzGDZncy5co3+bBafljA14XFYDUZI=
X-Received: by 2002:a17:90b:1b4a:b0:30e:77bf:6139 with SMTP id
 98e67ed59e1d1-30e7d4ebdcbmr40815331a91.5.1748012758170; Fri, 23 May 2025
 08:05:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Travis Downs <travis.downs@redpanda.com>
Date: Fri, 23 May 2025 11:05:46 -0400
X-Gm-Features: AX0GCFsLDAH_uwbWYgWXE8bqq5MBbH-TtDxi5g1z66FhR1c6508K8LgUQBV_frg
Message-ID: <CAAWAFP2JMTEUe_XUwW0xuGd2CODg2qPTC=DmY0qfik=U9XpDRQ@mail.gmail.com>
Subject: Behaviour of fio with iodepth > 1 and write, and fsync=1
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Gm-Spam: 0
X-Gm-Phishy: 0

Given a fio benchmark with num_jobs=1, rw=write and iodepth=4 (or
whatever value > 1), nrfiles=1 and fysnc=1, as well as default
arguments for all the submission (`iodepth_batch_submit` et al) how
will the IOs and fsync be issued? If we number the blocks 0, 1, 2,
etc, will the initial submission be like:

write 0
fsync (file)
write 1
fsync (file)

I.e., writes to the first two blocks and (redundant) fsyncs to that
file, all in parallel? Then when any of those completes, write 2, then
another fsync and so on?

Thanks,
Travis
