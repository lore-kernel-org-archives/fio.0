Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720402253A5
	for <fio@vger.kernel.org>; Mon, 17 Feb 2025 16:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739810266; cv=none; b=P9jAd0nSIr1FPuIPCZUI0ttxntFgSbmCl03/Sh/tz3J/uRoM2A2Mg8cuju3XWucxNJySXrFJ4mbmK7oQtMxoMnRsC78L3Pni1HKZbTOMHa3nY8K98CZEkSdPTlzHPAqvqJBdAxX6QFoWorbiDn5ugCldRkfJsSoY3y9a4yJOQ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739810266; c=relaxed/simple;
	bh=bs9BWxGmoE14r1zC5umGgOv7OzRicJju/ZpavdHh4uI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pS/FcBPAQ060HGgnmryaN02dbD0zM3mySLPTDoW0BKaWKpbIamtw0SI6o7tXAQhIuBfqUUuathQTt+WmY2M/ijH/VD2LeULheqwPnVhVHyWu2zKUL4kKa3WQp0EDccVODg9jtHmhS33omVmJl/tu+7+iAF+xJLySc64wqSRJ5wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1riiK1sO; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1riiK1sO"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3ce873818a3so41807085ab.1
        for <fio@vger.kernel.org>; Mon, 17 Feb 2025 08:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739810262; x=1740415062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v5EnstJdZY/QKQQkEz/zD+HnelTPgEriSMRPWeddIog=;
        b=1riiK1sO4vBDZNDKqDIFVesszeX5Toh6NWrqBvm5syVOmYNtn3mWIQYZDNsZ9QfSD8
         pg8AlFIU54wyUa6tQhNFOhsrH5caeJQB8vtRkmD5ul46Pea+66eXadKYY2JIHZregrQt
         zqkmtqStuKps3h04r0SoOjVlGSlox2hgjBSD6hR7bRLHjPi5GVAtBt/3/J4/tORKhvYh
         /vAjgsOVae0gsrDkSPmD5L3KD17LoOdSR3L4twJIZQtDLkud+y4RQRCrSSnR/PKFStKy
         XKMVHtgnRnQlo8tVWktJCDuXhMEaHDPRxEmIplcb6TsJ/Zik6Yz1fmZ4kZ/JrJQ+0PpG
         P8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739810262; x=1740415062;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v5EnstJdZY/QKQQkEz/zD+HnelTPgEriSMRPWeddIog=;
        b=eFFkNbwDh74v88T30oDEWmE1ZyCohbmoGjmyz9p848D5XtooAMPmeXQjN5IZxm1egM
         OiIgD59SYhS7tNidd9TjxcVnKgjDf6oSRoTp/6JyCSLhOQm6Qko4Y9uS9zz+3AHwQByi
         hKpg24dpoSJlTaVpPGeHpwz/9tDQDVO0qoLA4QSQ7brZLhs9JC3cICYMpVTEBP2PFUR2
         KCdUkoD230YQ8IJy9DWcJKvlkVo7Oh5KRRbwkgYUuSxqTbfHSL3BiUHrcBND4EA0ynKp
         hBcFUHNEGfFWWXD6LPY6kEq7g54jYtz3gxdGBwhgyVCYg8iFag8UYOa1ET9VtMQKFz12
         uqmQ==
X-Gm-Message-State: AOJu0YyKTady8TeE02RPFrtPLF0NA4E3RRmxaTyRD/YwJ/aWawRrFM01
	AKeQxR6gVsJM1kLvxB7fRy7g7evWaqjvsvbXOZH6xAZp0NX3wCvqAF24eHdP8/IcGvHVzE4dS44
	e
X-Gm-Gg: ASbGncsfHmlRYL5bT9gecZ0fN2TxOim1W0T9Qp6AJU+7jdkFeQi7CA7jsKQnQfiDD4z
	Rowax6fhca6Z9gd/j8EEuwpgRRrs/2yiaNl0LpwHM5ehMtnLPQ8p3D1q4/gk1ox5JUCHz0+L2If
	rHYNX6YJxSXDPU0voyyjSoZBmmX6n21S0I2MJwi3zflfZwgLzzJX9JrKImA9MnqkgjCw4Wiynl/
	yPXKw1HZNuax4SU9ws45ivAqy50nFUyEDxG73qhlJvjJzMB3ZFnZUUtabbLPWqKnIK+lJRcMSfr
	cwz+nV0=
X-Google-Smtp-Source: AGHT+IGchVUeaLldKZGsCMzpGMPH9cgpHP4zZaqm3HjhdRky2OW23MYL9HeGFsreq1kQL43dqyzbmA==
X-Received: by 2002:a05:6e02:b29:b0:3d1:8c0a:df5c with SMTP id e9e14a558f8ab-3d2809d97fbmr78755495ab.20.1739810262213;
        Mon, 17 Feb 2025 08:37:42 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee974302c0sm674921173.31.2025.02.17.08.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 08:37:41 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
In-Reply-To: <f0d66512e3df3d2142910e996c42389c21232d12.1739608655.git.ritesh.list@gmail.com>
References: <f0d66512e3df3d2142910e996c42389c21232d12.1739608655.git.ritesh.list@gmail.com>
Subject: Re: [PATCH] libaio: Add vectored io support
Message-Id: <173981026149.858393.3258255240811331706.b4-ty@kernel.dk>
Date: Mon, 17 Feb 2025 09:37:41 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Sat, 15 Feb 2025 14:11:30 +0530, Ritesh Harjani (IBM) wrote:
> This adds support for doing vectored I/O to libaio.
> Instead of using pread/pwrite calls, this allows libaio to use
> preadv/pwritev calls which uses iovecs.
> option: libaio_vectored=1
> 
> 

Applied, thanks!

[1/1] libaio: Add vectored io support
      commit: 1ceaf63b291789e96348d033d4016203178dd6a2

Best regards,
-- 
Jens Axboe



