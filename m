Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14E626D4E5
	for <fio@vger.kernel.org>; Thu,  7 Aug 2025 17:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754586564; cv=none; b=c6N+LkLIZ/bowPjWuMi8BPij/hsz3+FpgOFqWlBtyLUz130mgOH2unxJE8qHzGB06K5Yi2A71zKLtBo16br/HhaEA6JW6FBm2NCV5Wcc6H3Ny1mNVPOvIAcYjEI2waW5MTI1o4I3o3OfSSxjnt1ZgWRjh/WRWORRZ+0542qtz1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754586564; c=relaxed/simple;
	bh=VhHtGJdfspaJ7+WEfqHdnzgieN+A/EenvRRd2i5Xicc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=pUSqwQ8YOX4OMpEng3LjjPfo/Li5S6rqO7aY00ulTmkrKyoNWM+dFnTXfCEMgPB+1CBYyTuFtxv4XrUqseftTeBJlAZPNoNMDxRQ77C2a4Bkf9834oi49gQk4MxDHgdvsho795zV2y03mizpzouH+2E9WsiFXQ7Bp6A3wLFDcTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lA2DdOMT; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lA2DdOMT"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55b829c7f1aso1356472e87.2
        for <fio@vger.kernel.org>; Thu, 07 Aug 2025 10:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754586561; x=1755191361; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EBjSbnCzvmsHHJzNnPLje/t08UKQTgI8lBZ9kW6GHuM=;
        b=lA2DdOMTdFehrt2Z5A+G7PZdtoeOcudfJcsOxbULSHE64RuukucoAgPCU5ugL4w2Y0
         m4HPydEQYoxmF9kx732gYyLN0sj+mzx7ocQWez16OD/yBlpaXxc4zZOI6u7OaX4ILjrS
         c2A8tR+gr5OPWHp/15jK9l2ZP4l698X42Y6tO9VDGAqV8ABstM1GVl83lKQYq6pi52WQ
         11CSxoA9CvyFzBudbffdPjWQWSC08Ctw8VGdyljwkejn5DUlYcj2m68O7puaY6RQw3M8
         2xkTEefAC9Ae/0fayQWE8j4XIwzeoqzKexQwDEEiIj/o6vwuqQjmMNDua1vtdqkDGQfM
         mUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754586561; x=1755191361;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EBjSbnCzvmsHHJzNnPLje/t08UKQTgI8lBZ9kW6GHuM=;
        b=JJUn9DBvlKiuraHQ4BBHAUXA/GhVEsFgq7Jo73aeuy8BBEDpjahmhUVgnNnbYFJI+W
         s0mK902OPSAyOnAZwSTmQXmSFf9g1l002QC48ND6JG2FXSPTB7pX+K/SmMqHFl9th1Ld
         HB+cobo30QKXxv0Tfda6pGz8qWi1HP/LsSVJ836LHIQHcyJTebvLp2VQwmItfwiV0z9d
         srVfY+V0M21EeYwA5oM4Uvi9jV3iD1CEgLqaSNaIi5QGN4lX+tEfLDHCQpnHye00gNHh
         y3wah2WvMlmlGA2F5O/ytyeZ31pbeFijM/+WYYooDC8PW/s5Csu2dIsFw3HGRNFzGZTh
         1dmg==
X-Gm-Message-State: AOJu0Yyux5Ou4EkDwJa2XEHNvukrH8+/QJ7qG4A4bDk4OH85SDzS1Uwb
	Sb+iZdloClwmvVy9TxQT47bIq13iP+WZ4aMM5uAom7vXVSAO01tibREv9AT077OU50yaeP7mrTh
	D2c3l3L/JI1aLZCyeU6KsDJRw2AvbVgiuYENqIrA=
X-Gm-Gg: ASbGncukRKDHeoPT1K4AKYM6sSdsy7qtZ/6aNmJ5SNeDnSZn8qPfV/XGRPfKU17wBid
	88SeyvjDGliwvcz5u3Wz2TiYwFqCLfDs2nfekvRz82rRnlEPCFZctcho+TBP1+ZaKGe8iznB/Kg
	Dxe/qlwKs9v2flRmgU7B4mjy9/wfPAYCVJHv5vIFQLszM7ir1gJ9IB5Xc1LQPEKziUOVBHNO0YY
	wOxdanEkw==
X-Google-Smtp-Source: AGHT+IGZXcojHE36y0ZN0/UXHjIHDyz56HnRA7kmoOthrhCeWlTAFBYqwkA6ylGQMHLTj9KkC0Wo+yMIhLXkVxL6PWY=
X-Received: by 2002:a05:6512:1301:b0:554:f74b:789e with SMTP id
 2adb3069b0e04-55cbe704058mr215082e87.43.1754586560494; Thu, 07 Aug 2025
 10:09:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: micha yonin <michay@gmail.com>
Date: Thu, 7 Aug 2025 20:09:07 +0300
X-Gm-Features: Ac12FXxnGKQ-NuXQC9i7V2DaB4Yx5RCdNgkIzZnMHYbg6w2U77o6r-PmZ_nCKFo
Message-ID: <CALucHwz9a_M1DMa64ssCXSuMz0Y0UXJQvpvfP_1M=6LhDY6aeg@mail.gmail.com>
Subject: verify state & hot reset
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

hey
i'm running fio 3.35 with verify_state_save=1 over an nvme controller
(4K rw test, qd 128)
during the test, i'm doing a power reset to my host PC
this is triggering a hot reset in the controller - so some write
commands for sure are getting lost
after power up i'm doing a read verification with verify_state_load=1
but seeing lots of miscompares
is it possible that verify_state_save will save the lost command as
though they were completed in the verify state file?


-- 
micha
