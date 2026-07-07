Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75A943C7D6
	for <fio@vger.kernel.org>; Tue,  7 Jul 2026 18:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783448583; cv=pass; b=PVKUw6OR41K8V0Nh/wEDb7TVdy8VJlSgqzV0Gt3ayxwNK6MOJydP0J3mWitAxFcolBwf9WVeG7lsMUlPsUUHZGrh5QDnqAylvN7C/UPCtwj6wo3m7jN1npPNP3Yk2X9DDoh/j1E4zYEIq0/Th+fgFvJ7/pbNijUj6T10DDUebrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783448583; c=relaxed/simple;
	bh=J1QQNcep6uh0VKWNIxeVVJIRSZRi/MGYApydvQ/0lRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=lKcqJzcpDMOmCckN9mE2ZmoSjJD6JyOy1aTNqkgSvyVc8YtAJKK/lGBjsfvxb2jBqEBeMiaVFGpKCU2l1sc9/exuxNVJcgF9sFqQ6cqlJEPq21GF3TnZp5DiGac2Wa36KyM2yllWbQLEyTgB58o3NTMpM+FV7Ykmuv/7aG9OfLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MBG3FDKZ; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBG3FDKZ"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39c7050a48fso4864331fa.2
        for <fio@vger.kernel.org>; Tue, 07 Jul 2026 11:23:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783448580; cv=none;
        d=google.com; s=arc-20260327;
        b=CXQBTVb6CFTj4mKMM+eAm+1HKkBPdbNdKt4AyPg4F68JI1oE4SQ6Kp0dZfB7/ekTjR
         h7GHs7uTcBr/rck9YMXbmFVK0xtrWNK68aWo7Fp/L0vdBNQilRmKVMX4O3sssox/9Cuz
         pqCE1kVbWJx4K+thbh6Dr1eaA8D9XpLfXobwQOcv4qCoUpzJHG0jDmIpmU9GEtmlhrxM
         6Yk0tZ65ofy5t+tZMtZHqYtu2h+J05v86eTavbJI1dHWe1Y82BWubxyu85a8t9GeJRDe
         NJZyR33szGict7dVLgStXWp+W1FkTR/gh526eMpCdjSQg4RL1QeRbsmKjJbIAXa/fQIh
         cd1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Me5ongFUaYhycjZ8bXhnyL9Ey4aTyfRjjswJ6V5WROY=;
        fh=2Nm8zKwukH8ggRHWPIuA7y4xMjdzs3HgSU7QmjubHt4=;
        b=kjQ7FuYhrU2Q6826R4Oib6JqjTlNdcYIF/XIO0vb0GgIFyMDlHG60VrceBY8RYFL7z
         v5piuXwPXQUUKFT4uRQ4V7IBSeu3gGFO2hGRIzbRJTJTbzJL+m38GmKgvist235367tg
         Uxx87WAlN7u5xrsoGnQQskr6br70JJLft1QL0qvjBT9oU1eO8lhSLxWWuBkiozUPH8WG
         3lX1yG6BybxLSXVXfiLVE/ktGV9BC+Mliyc3SoBvGkd3F8lGTPUPuq+AHXawO81ql+Dg
         3fYkLisduoUrqGdmzvwzkFcCV8gRssnSlpvmOBi6VoOqkN+vMYAn7k5W5C0CZPQ2nsgj
         e1Sw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783448580; x=1784053380; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Me5ongFUaYhycjZ8bXhnyL9Ey4aTyfRjjswJ6V5WROY=;
        b=MBG3FDKZzDl5CTJqM/e4lwCok5wBg8Df7bCa6ePtjZaTbnm45vl1aeM6hYxox8k/59
         UkFnv0nbcKTEdx91v2QnDxch8UhcY/d+P2ucEp581wfIbPZ5w8hJ3NYzKEcPMKZWSyaD
         yKz8S1qpFXCNv/Y6rCpwsnHquYx74vllzflQcT+234Wck810UP+i1ZWKZl9cUYDliGe+
         glarKmQGuOclyDw0qEGjlvzzfX3OV6uu6iEDlhZ00eo/eeuzSa3ar7WKvHRuLbp7HsT0
         z/uziWSZOWb5dKFKHSG0LFoR2qYabIQHStpy1riaIK+eMVoYqIwFoM2xzeSV7jBuw0ke
         oQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783448580; x=1784053380;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Me5ongFUaYhycjZ8bXhnyL9Ey4aTyfRjjswJ6V5WROY=;
        b=LwyjYwNBgUE686uiXSuDLiuSq/+etgX2d27+1vU7+F1NSmdJcbswC4VGn33NYdGNe5
         SLRP4KiNegFsfZH+Y3ylUHYxS03F3dBhCFeFmCq4X7yDoqSApp0V7+T8xCVkwodM3/AC
         lOypvMGz0473Q9ejHy/bvCor4HO2Fqc3J/CtqwUhcgTBKfk0XPvSYgfQPF2ISd/2Qk0r
         uOjY2REnT1Onj3qoQxW1EIXr1ERMzoyn/szqR1Vv8q1YQFVbJPwYRQEl4c7QXvFjrxWG
         e5LOHPe/94Y5rqhJuXio2UrKjp4ZCy+ifDg/cQvDu8kYEc4qlFG0bLD3lJysG8KjB9zt
         AaJw==
X-Forwarded-Encrypted: i=1; AHgh+RpZE1pCMmLBRwOw3mYNA66lw/vEwafJtsCSS/g8xC1ECD+4yRwgWQZRi4/2TTcNGnxWO9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy08rs+AluTFPWLxMlVzJ/9HKbvTxeeQ2PXxIWNxuZ2V9rFPbRN
	d8sXRbmdES7qn4H8n7zfF4YX1+Jnqnu0UCiE6VntxfLg8xkHrTr4fukp/t8phI86dbXCSryQKv1
	DC1CYYVmTSODOqrFFUHOu8i3aV4tkLXiYsFFo
X-Gm-Gg: AfdE7cn3pz0oMawOBX57V1CHUIObn7i7EhtLviyfrd7UGVIE5papOdWL/GlPpu06MOI
	kYih9kP4DZDQgpT2c565RzYkOZvKqju7Ymy5xMUDFEtnAM+vIeFysSOU5b0MyplEx2Sw2ibSZqK
	efsRSt7ejb4lbd599fxutpU9065nt/0eXHTkj1jXRj/+nWwK/zCWDNZqz2iLQ4NVQQyB8GVAejb
	qBtgFrbRPu9GoF5L9gPRX83rCpsaFdhViBH2qrD362O9Sl5ebeCPAUNnsFjEZBD88LLsJhXAZvx
	aKc0uBUGbhlvF9dWjlBjte58BDqT
X-Received: by 2002:a2e:a99d:0:b0:39a:e3c7:6649 with SMTP id
 38308e7fff4ca-39c5ffdeddbmr17053411fa.28.1783448579735; Tue, 07 Jul 2026
 11:22:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <PH3PPF87283933B8D3A50EAACC80498FE7887F52@PH3PPF87283933B.namprd10.prod.outlook.com>
 <CAOp=CXkW4206EoW0AY-7xzvg+Zrwjjt6DiXfyL-UO8S+njK-Pw@mail.gmail.com> <PH3PPF87283933B9384B6F2149D5B66D4E587F12@PH3PPF87283933B.namprd10.prod.outlook.com>
In-Reply-To: <PH3PPF87283933B9384B6F2149D5B66D4E587F12@PH3PPF87283933B.namprd10.prod.outlook.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Tue, 7 Jul 2026 14:22:47 -0400
X-Gm-Features: AVVi8CfRSIvb767jFHttafvyAmCvoJwQaS4ix_nG05tHzsYXdvV3aF5KugS_jdQ
Message-ID: <CAOp=CXnQo+hKaZqqijvdE5_-eLr74NG1zJApHJO4T1b1aTVWYg@mail.gmail.com>
Subject: Re: Bug report - Trim QD1 using io_uring is hitting unreal clat values
To: Alexa Mercado Sanchez <Alexa.Mercado@solidigm.com>, fio <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 6, 2026 at 1:44=E2=80=AFPM Alexa Mercado Sanchez
<Alexa.Mercado@solidigm.com> wrote:
>
> Following your suggestions, I minimized the job and ran git bisect (good =
fio-3.37, bad fio-3.42) with an automated build+run harness. It landed clea=
nly and reproducibly on:
>
> commit 980fb7f2d9981bbfe4a3158d6293308c76a6d77a
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Mon Sep 30 09:42:22 2024 -0600
>
>     engines/io_uring: add support for async TRIM
>
>     6.12 kernels and newer support async trim, which means the non-cmd pa=
th
>     no longer needs to quiesce the queue and issue a sync trim for a work=
load
>     that includes trim/discard requests.
>
>     The engine will assume the support is there, and if it gets -EINVAL w=
hen
>     trying an async trim, then it'll punt back to the using the sync trim
>     again.
>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
>  engines/io_uring.c  | 37 +++++++++++++++++++++++++++++++------
>  os/linux/io_uring.h |  5 ++++-
>  2 files changed, 35 insertions(+), 7 deletions(-)
> - Bisect found first bad commit
>
>
> Minimal reproducer (QD1):
>
> [trim_qd1]
> ioengine=3Dio_uring
> filename=3D/dev/nvmeXn1
> rw=3Drandtrim
> bs=3D128k
> iodepth=3D1
> direct=3D1
> time_based=3D1
> runtime=3D20
>
> Symptom: trim clat_ns.mean =E2=89=88 runtime/2 in seconds (min =E2=89=88 =
ramp_time, max =E2=89=88 ramp_time+runtime, all IOs in one histogram bin), =
while trim lat_ns.mean is correct (~195 =C2=B5s). So the completion latency=
 is being computed against an unset/zero issue_time.
>
> Note on kernels: you couldn't reproduce on 6.6, but I see it on both 5.15=
 and a RHEL10 6.12 build. I did some further debug and understood the diffe=
rences in code better. On both of mine the async discard returns -EINVAL, s=
o fio takes the punt-to-sync branch in fio_ioring_queue() (do_io_u_trim() =
=E2=86=92 FIO_Q_COMPLETED). That path never stamps io_u->issue_time, wherea=
s the normal ring path stamps it in fio_ioring_queued(). Since the engine s=
ets FIO_ASYNCIO_SETS_ISSUE_TIME, the sync-trim completion ends up with a ze=
ro issue time, which matches the observed clat. The real device latency (la=
t) is unaffected.
>

(Resending this with the HTML stripped out so that it makes it to the
mailing list)

With the help of the troubleshooting you did, I have committed a patch
that should fix the issue. Please try the tip of the master branch and
report back if there are any remaining problems.
Also, next time please include the mailing list in your reply and
avoid top posting.

Vincent
