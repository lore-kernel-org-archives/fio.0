Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0BF1DE2CF
	for <fio@vger.kernel.org>; Sun, 15 Jun 2025 08:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749975180; cv=none; b=Lx3w7ROaIPgmtQ7KtgE1Dfc1/JJVXTTm7v76s1AXeaordwtS1XE4L28N2wo7rY0Y9ri6dM28P08FJquRq5oGCL3YQH8acPdos6p2D8ps4Ol7XDUBeGVcRNeHSEdIlJlBrcCTeygP740ZWZczptTg4Dfd18dkqgSRAzfN+LTdG1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749975180; c=relaxed/simple;
	bh=o8cBbckU6vzdu1zbI7DFbQnzRdLLBJvR4wFchPcSiKM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=M9fPqYZrjRFHyWUG8c4hjH0LAy6F9bpD4SyUNDkshY71ud8iY6/wwY/pP22S/AjwgsIutPBZGk5GGldIyCRGpBZORCotTrWXyUbo+5bS2MzBHvjbBWjvBkonNMOd60uSCAToUMXL3kyWsfPxqsdLrVsvqrAr+N501+CwTVlrDOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mc0Qegr8; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mc0Qegr8"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4e80edfa06fso142670137.2
        for <fio@vger.kernel.org>; Sun, 15 Jun 2025 01:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749975177; x=1750579977; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jT/OLDPjhHFoiHWYZATWzP3MQngNpog910S3yLge7Pw=;
        b=mc0Qegr8b3vY4hj3Ro25yr/ebO8hhhHGIFZG8yGeDZZ2LMfFBnF1Uh8X34f5mr2mSN
         RRBMTixjb+EoLgrMhIdAwDAybJAFuccN56bEFVNzFsZKH6FE8+1zkCF+wj9LmxCTiPWS
         l8ajqPftrMamAIx4ZaBhmjw7rYWoe6qN4CplLRHx4T+ldMrlp0eho4wg4g3dAH1QuQ7t
         8UXPBPh2OsHTLyF33osZifYdBuznanK49Gg7VfBZqDO/Ka9Bcn8Ev4f/L8rqd+o+t6ny
         bi7rFvLTZi+Ua8iOjZjUGSrzImCWbWchUX32yJsHIemwsslA8gTsoMQAYX4aBfsvrg5F
         F7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749975177; x=1750579977;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jT/OLDPjhHFoiHWYZATWzP3MQngNpog910S3yLge7Pw=;
        b=HkldTG/aBbTVlmpvbS0MEBp8wlNSmoswnDu6y/HoV1RVtwBqS7ouE2Y2I9hHsGLBzt
         bKOSFc/BAWYxNj8VedjZsQyEzW9RthofOgok3qp8Khn9mD8p+YiEeXi1Z3Cf1sCRDiXD
         ltWIADO6Qge/TdSSEY6GVdrGLxdXCVD0+yv15X3jSB0i18UIhqDOhHcCelq9lQd10jY9
         roB17iYxuY30yrd9fzGPMFYkMfVY2Raa9MQPEg57F2K9Ci6SKdbSGQuiVbP4pTXxVhSO
         mbnbFvCViyYveNI8C2l0CS4Kue7bNibN1SuLsIehvs5ydrX2Jwnu08vPzY3L9/FcwYjT
         HVQw==
X-Gm-Message-State: AOJu0YxHFE86Ouuu0rWotaqgCGMnep3M7CfoiCEKHTl3QOVqLamx4vvD
	+LyApwsnPyBkyES8XR5URe2c+SFs+M3u+bEkDK86h5sSRf8ZcUHRX5YXrzJbRgHnfhqFeAdngzA
	EGOY3g8ehjz15MZZiLsV5QEv9/C7hWBhbrBtg2MTnQgY5
X-Gm-Gg: ASbGncvRgIvbdew5st6OkrnSLNdYWHy3pIdSvMNgVZw4GXMYAFFb+bwRFDEpATUquTV
	+G7/dAT7vCgQbk623GTxIn5F84AZiwEmuP5PuREKjhNB7egLMPGoTU0f26BJ7gzUBwF/CfrLin9
	3SSZFzA0Rh6ePLDynU8clGhvIg0MwwfquEWBAT19eMd5Xm
X-Google-Smtp-Source: AGHT+IHQ84rBXio9S26shay/S7q2pQ1X9n5g27u/zRAakFNzicLRXBRLHgqgBCcxw35LM+uGwRBgzzNXt49ClawcJKY=
X-Received: by 2002:a05:6102:4bcd:b0:4e2:ecd8:a27 with SMTP id
 ada2fe7eead31-4e7f632330fmr3392638137.4.1749975177491; Sun, 15 Jun 2025
 01:12:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: CyberGym <cybergym.io@gmail.com>
Date: Sun, 15 Jun 2025 16:12:46 +0800
X-Gm-Features: AX0GCFu8TTlMMI6UQLD6Zw7ymxg7G_kv7-xcyrir86TOnbv5_EzBQUo1n0i0AOI
Message-ID: <CAMjwZPGTg_xv6-YPA6PQGyJ1QgMup9k0atw_VT4qw1=hixYkKA@mail.gmail.com>
Subject: Null Pointer Dereference in __bloom_check via Uninitialized
 file_bloom in fio
To: fio@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000d22745063797d82f"

--000000000000d22745063797d82f
Content-Type: multipart/alternative; boundary="000000000000d22744063797d82d"

--000000000000d22744063797d82d
Content-Type: text/plain; charset="UTF-8"

Hi,

We are a team of security researchers at UC Berkeley. We recently
identified a bug in the latest version of the fio library. In
fio/lib/bloom.c, a null pointer dereference exception is triggered on line
103 in the __bloom_check function. It seems that certain inputs cause the
function file_bloom_exists, in the file fio/filehash.c, to call the
function bloom_string on line 103 when the variable file_bloom has yet to
be initialized. file_bloom is passed as the first argument to the
bloom_string function, which itself is located in the fio/lib/bloom.c file.
bloom_string then calls __bloom_check with the null pointer as the first
argument, ultimately leading to the exception.

You may find the original input that caused this error below (please unzip
first), with sha256 checksum
78ac354e97f09a8b5fef7332dc3653a328ae955feded239b95eebaff6db9e553.

Though, the following input is more concise and preserves the same program
behavior:
[global]
numjobs=2
filename=x

Sincerely,
UC Berkeley CyberGym Team

--000000000000d22744063797d82d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>We are a team of security researchers at UC Ber=
keley. We recently identified a bug in the latest version of the fio librar=
y. In fio/lib/bloom.c, a null pointer dereference exception is triggered on=
 line 103 in the __bloom_check function. It seems that certain inputs cause=
 the function file_bloom_exists, in the file fio/filehash.c, to call the fu=
nction bloom_string on line 103 when the variable file_bloom has yet to be =
initialized. file_bloom is passed as the first argument to the bloom_string=
 function, which itself is located in the fio/lib/bloom.c file. bloom_strin=
g then calls __bloom_check with the null pointer as the first argument, ult=
imately leading to the exception.<br><br><div>You may find the original inp=
ut that caused this error below (please unzip first), with sha256 checksum =
78ac354e97f09a8b5fef7332dc3653a328ae955feded239b95eebaff6db9e553.<br><br>Th=
ough, the following input is more concise and preserves the same program be=
havior:<br>[global]<br>numjobs=3D2<br>filename=3Dx<br><br>Sincerely,<br>UC =
Berkeley CyberGym Team</div></div>

--000000000000d22744063797d82d--
--000000000000d22745063797d82f
Content-Type: application/zip; 
	name="3b2a5347be2e4029b27ed8e706a926a8.bin.zip"
Content-Disposition: attachment; 
	filename="3b2a5347be2e4029b27ed8e706a926a8.bin.zip"
Content-Transfer-Encoding: base64
Content-ID: <f_mbxe0sd11>
X-Attachment-Id: f_mbxe0sd11

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
AGsGAAAAAA==
--000000000000d22745063797d82f--
