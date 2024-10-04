Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE9E1D9A41
	for <fio@vger.kernel.org>; Fri,  4 Oct 2024 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728054617; cv=none; b=bbsxVKtrK8eL7mV1N8RsJFW1MtDoEBYEFj08MB5LQqzYJaeM1OAKb6a4LanKldzJxmZ/OPpYbWSpUdMOBkea+3ZT1ZxbEy/4f3ExeRiH+vH8J6vMK6y+muKSh/HwCr7NeN/mZ0k1XbZWHB54noIK3GZofbbZfRTZYpJ9qepxO8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728054617; c=relaxed/simple;
	bh=XxsupIVPl7B4fkDXoGgxgp99f0uhhF8DwakxLkoDXF4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=g3D/ampnyw2jXRCDpcBPe2LO2NIcibe6c2kgT25KphOthkVteAnxm1hFlIQ6cL9izKGXGzRWgYh14P6dfADYzpSqe9nzQs2x0ME8V9aC50aJVdYRpX0gV735qS0WlMkEc6BdGs5CBc81Gq0N3dw1cWyWydoAp8liKhE9kgBRhVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=B2fMhKKJ; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="B2fMhKKJ"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fad0f66d49so35859971fa.3
        for <fio@vger.kernel.org>; Fri, 04 Oct 2024 08:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1728054610; x=1728659410; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XxsupIVPl7B4fkDXoGgxgp99f0uhhF8DwakxLkoDXF4=;
        b=B2fMhKKJBYDHvhHR085GcCyyWWnO6tHTUI4IqlxllV6kd41Np72ePiWD3VjKiInjo7
         EM7wnu5CK2qYmoGPdjNJ3HKVcsp7b0WZn4+CNnSLCLkW0c4BccW9CbgfH0YkgLtkhGks
         aoWIF/A4QOWFVFvdZuyoSFRDpaKLwxWmBZKozFXAZNg3gZ0df+6xyBeuY7dCEN614miG
         Et81gOXnB4vHRYfNUafsOuMw53S7zSh/2O1N0LFh449TgFUUni1XGEcWu3kVMgPGg2/V
         Y4gOyFeUEJKgOy+vp/lIAi7VUF5dUdX7o8mgXcXJ4Q4PoDQldxfM91puGLWHdHpy0iY+
         U5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728054610; x=1728659410;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XxsupIVPl7B4fkDXoGgxgp99f0uhhF8DwakxLkoDXF4=;
        b=WeWRv9zVnI4Bqmwhu5QYs1ZFDXxImS61LbspLXKUcbzNTPGgeAgEMURNM/e7Q+nWjh
         Vjhw0CTvLUDrFp0Jp+tMTX+9rjr4xwRsDKlPkg1uTNrjWQMUTNqZg50nRv+uD+Rqu7Ld
         zMAJyx33qFJla77FG8Ao8+wWOwl2cZSbBfuLVP+1lf2JAh5TKum9V75yvzdxXQY0SSgW
         gyL/7M+U9n/6WlIW372c0zdbygz9Bbbw+Body0R5LZ8Vm3oPfc57FGAN3ag3NJfpj545
         e4u+uuVzBFr0tI6m1J+9yB6M0quAIGpS/NHxtz2H6v9kqCWIwShimy2tV18XYDpnwJ+l
         Kqzg==
X-Gm-Message-State: AOJu0YzzPI4OqyFnEhO2bGgkvc79clUtQzVRzxfY9Fj8/ARYmcsHJK6p
	3huseTDNkouxQE1h2jYP4Q/bxAM0z8UEES1+mltUSCgurvtvMZbotrWA1g4ye7p7eBHNs/Lbp8J
	Fm5G7QfYT7M0xDp5R8Odd7M9FgA6Wc9uJMo0nTITC+rvXo9rFyeAN5w==
X-Google-Smtp-Source: AGHT+IH65+nrs4kBqh+rtJdScP0s7hLHaeEiNe/3O0oToGr2Ax0MDo0azCPWD6A4utzRCaG/wdeewUVtFCtFgAfmV6Q=
X-Received: by 2002:a2e:b8c4:0:b0:2f8:c0bd:d65f with SMTP id
 38308e7fff4ca-2faf3c1e753mr15350441fa.20.1728054610122; Fri, 04 Oct 2024
 08:10:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Fri, 4 Oct 2024 17:09:59 +0200
Message-ID: <CAJpMwygnT=KmzZHxJGUWgg1AJe-UbAP_bP5mN7iCLdtFoYwNdQ@mail.gmail.com>
Subject: Question about an fio profile which leads to a CPU lockup
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I am running the following fio profile on an RDMA storage stack with a
raid5 in the back end, and I see a CPU lockup. (I can provide more
details about the setup if needed).

""
[global]
description=Emulation of Storage Server Access Pattern
bssplit=512/20:1k/16:2k/9:4k/12:8k/19:16k/10:32k/8:64k/4
fadvise_hint=0
rw=randrw
direct=1
random_distribution=zipf:1.2
time_based=1
runtime=60
ramp_time=1
ioengine=libaio
iodepth=128
iodepth_batch_submit=128
iodepth_batch_complete_min=1
iodepth_batch_complete_max=128
numjobs=1
group_reporting

[job1]
filename=/dev/rnbd0
""

First question I have is, is there wrong with the above profile?
Next, if I simply change the iodepth_batch_complete_min=0 in the above
profile, I see no hangup.

My next step is to reach out to the kernel raid group, but before that
I wanted to confirm that the fio profile leading to the hangup isn't
incorrect/illegal or something.

Regards
-Haris
