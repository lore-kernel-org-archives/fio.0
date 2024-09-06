Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E59158543
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 21:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657787; cv=none; b=WWTyfZHQSARwKxy3FptoVpfIzArVd78R+RKrHA+DBZhUP1OQRXMpy95XCn13Rx5MpVw7AIq4Jeajb4FPVdoNrhGDEiCWEkvq1HHd1Squ6O7Ds99EwKvmAXFwfKHUHlvYiTBssaYrCvx++gQGQgs59kY2NARVM2CO3RmYGZou44o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657787; c=relaxed/simple;
	bh=Ms0SW9ouGbJKn869XIT3ZN+fQk18tPFxyyJw6/MZgYQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=de6dwTymWsdOSL4m9Ez3JrcWccP6lUSwrV3+MaauvPPKaSP/awLzCTYOsPLnTfHdoSc1sXdeB2GPJ9l5yEeSQ0Cnlxqeg4nt/ttjzEWgFhUYOrF5O7DgPndqnDMEHobk6i3s1M91SQs3Bt7SYCQOxuHhnTPmKUHhKGm0AbpOWgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q1zpVzv3; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q1zpVzv3"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70cec4aa1e4so1789254b3a.1
        for <fio@vger.kernel.org>; Fri, 06 Sep 2024 14:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725657783; x=1726262583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fo5oj061P7wLISNLtoEWKisBCB4GkTNXf6LThXzKTGA=;
        b=Q1zpVzv36lKGEUR65SCNtp/+SjTnc+QpkiBgjjwCCs61c8631EMiImJHlqc0kBqSPo
         yjq+Nen6/VppjEiSBXy6n7HI96XqhNgsEGGi7zOIUOtRaNKkS9OkQxvUdMxGSDbWtS1/
         fBGiIfVoUdtKFVJC3Q5p8PFlxt3P/SEHRHwHP4Ma9poffdSetpXK3iDPkP6R6+thANlm
         oIAIXfWhdOlW6AlPCz8s5zgnfeZB3lmTlmcATLFBG/OpYnKsh2+iMlUP3EFhSSA+HpcC
         FTSgnyWASpQ9oZYfDhb7GOnjE7Pw2JtHZBwOypIWBpVYoszg4/qDAO7L/COCYL/B9quG
         Df9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725657783; x=1726262583;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fo5oj061P7wLISNLtoEWKisBCB4GkTNXf6LThXzKTGA=;
        b=r0XfXiUM0I+yCGzq8eXrwT0Zp2KTr9E1GvPzJNtc5GjPCz1GqOw/9PnZgn548WX29q
         z7A8GP08aoUbGLavonZC3d2RKR8B/TbH1akGDZwYWiHva5VrzTdLqHCbUDC3T3re//ZV
         ootDUaEyTdPa0A7SbNYIE/PpkSTss/BC0KU7sT1DIP3KPyT2UnIHoRb7/siYOK4D0BpT
         3id5b9eVeF9+av31sz1iD5J7847gWcDL3n6d+r+eEimvn6Q2ap+wanpBI8DQXoHyvnJ9
         zVzttdETkSuJVC+Od+Q+zSU1wY5lEG1F6uJg65UMggIflJZrzhX7p5Q7Sp0IK70ZQqD1
         WBlw==
X-Gm-Message-State: AOJu0YziJTtNL2ADVGEAKI3kzt5YSlAj1GO6DvnT/V/SyiUic7/MsG+H
	yaGth4ZziVVAexRG/Doch/8H0SRDfi1MFGU+vcEVluMWJm+xOCS1wz9+hxlzadu5+DcVPDRNwcK
	V
X-Google-Smtp-Source: AGHT+IEKuJyx1o1g7w7WESWhmwJUCGR/dg6P/tcHYCzybC0MOkOV1tqgxEK/q07qRPyUS66TV2gO5A==
X-Received: by 2002:a05:6a00:23d4:b0:70b:cf1:8dc9 with SMTP id d2e1a72fcca58-718e3491e3dmr970868b3a.25.1725657782784;
        Fri, 06 Sep 2024 14:23:02 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718087382ccsm2040376b3a.169.2024.09.06.14.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 14:23:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Rebecca Cran <rebecca@bsdio.com>
In-Reply-To: <20240906211941.850156-1-rebecca@bsdio.com>
References: <20240906211941.850156-1-rebecca@bsdio.com>
Subject: Re: [PATCH] Update mailing list details in README.rst
Message-Id: <172565778187.235238.5288574256759085965.b4-ty@kernel.dk>
Date: Fri, 06 Sep 2024 15:23:01 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Fri, 06 Sep 2024 15:19:40 -0600, Rebecca Cran wrote:
> Majordomo commands are no longer used, so update README.rst with the new
> method of subscribing to the mailing list.
> 
> 

Applied, thanks!

[1/1] Update mailing list details in README.rst
      commit: f0af0812543d3d9a4019e2979c6e32f479ee70c4

Best regards,
-- 
Jens Axboe



