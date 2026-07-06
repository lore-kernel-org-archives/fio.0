Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA7137266D
	for <fio@vger.kernel.org>; Mon,  6 Jul 2026 15:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783352781; cv=pass; b=V2Agl84SECpgCDeZmp6K1vPlvpQcl/Pm4FlpmHSt1ydXwnkoaeYDWKKikf8JIkhVJoujjuKZwsjjw4G8j8GYKFlN8TiVczKabnJCsyz4tscHULPJuVBLbEvmkcFZZzgf1ekWl+iiUTUnPeYESEcNPrvnTxX6pZztthn8vK1sU6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783352781; c=relaxed/simple;
	bh=2SEKpaBTHFzp+0RJv7VkuOVYPQ7YezkJFu9RJ0srglI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JAfwvh6dvD0xqbrejJ0QrmzdM/VfAEuNMrKAI2uMzNpP5t7FQAaj0HjS1GAN6XlpPKwvg3Bn0KvMpk1kAC+SVSs2DOna65QE97YIx+wezTcqt5/aSYo4KIOfl0MO0yvGbNBqBeJfGDdKi0A8uQjCK2NKle6Mb7nJ+qpNojcxFKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jalfap1u; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jalfap1u"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39af64026dcso25584711fa.1
        for <fio@vger.kernel.org>; Mon, 06 Jul 2026 08:46:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783352778; cv=none;
        d=google.com; s=arc-20260327;
        b=PAjtv9+01Ee/rPP08JcAHXNPCHq6qyCE728cTdJxvghcYXUhKPlLAvYyLWPgrmxdVH
         EX1zcWDwI/tVPrpHypUQlEpyoY/N02dvD069H7r0XJLgfSKZ9qAJ7tLr7lH/b17c3RyH
         FuqJakdKp+4cMVNGJqU8jF9ZhoTBqXPi2QG8hEbRHpodwl5wz9XxfLSnpC/owf+sGF1y
         kXZNml5XYUBiwKYmSpB0CP7YOiFvKlPa3aTBnwkQ9wikE9zmXMs0rk84poOF9LDJ8ABs
         fnIuLQkaNZAqda1QvjCXmDCHE+vs5gf32oQGggy3nRd4l9m3kUGP3PFUOwVHBSwkjS4u
         orkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pmsVWA9+Afgfj7EDki3bnSj2oGKJnaVmK3ViGIbmu5Y=;
        fh=xRZezKE7AS/L42XdpSvDT92YA7ZY7UgXg2iw2Tf6wxA=;
        b=QAfvITdZBSqfhMmZzPvp1rYBSR5pQP6DuLwrWl3iDD2xgxX7OSqsY75ksXxQw0X4Ne
         yzZb+WfpS2oDJlhA1SYmWIp0f2xxMZtA2OAbnqznlXoAeVR6Yxs2XJ04v44JTcOcFZO0
         azy5HtwpP71jlwXTlpZS7uI3HPQ/VOlSa8IhKfIcH/PI7ADQLNOtMkdq1/HGa2ViLuR7
         oyJzc5pPFVPV/8eTn0YneXG62kDR1IAKd7zyeqLmnOUvI9iDdTZpJhh8xhL3jfYQdzO2
         JxFLO9jMmKPW6sEwP3heAd7VRnL4INeteoAJ65JBBS7IoT7bKMGo7ERrP3Hb5JJtaqaO
         HVvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783352778; x=1783957578; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pmsVWA9+Afgfj7EDki3bnSj2oGKJnaVmK3ViGIbmu5Y=;
        b=Jalfap1uR7Jt0dWqen2AUIRZYNJpBvqWT6TSj2+731bOG7ar33RRs4XYR/QrL1ELum
         /3wLAPfVsnH6mocSqVcjv2h3Fnc4ivkWuWqWpvedgeEmjTAAJiA3VSF1WqrlYkdonnZy
         yLAtzvTgdjsYt27fH6JCdqeYyAOgbtg6EW3nN1ctg+MEnI70PTY+VG2/43DMusR6zn3X
         uaQ8Xv+SO9eMKHTGCCry3pa2MmyDHWM5iqhhUHvDZ6gJMxA1e+SgYVILbSbgtBIIKgzq
         MFHQCoMPLBdWyoURsbbsY8AjRYpsMES3BPFH7A4Wp3B81PaNyc0ReO0slM/W8/x5JJVc
         iTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783352778; x=1783957578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pmsVWA9+Afgfj7EDki3bnSj2oGKJnaVmK3ViGIbmu5Y=;
        b=A1W1x5EEpEClV3YaDXsSwa63wtrZKwUT357ycwMkA8ty3JwsFIgVrv66CdMOR3mdTA
         XnW6cWhJwePp0xjERhpqGCOKfAxnWix3X14+S2+fXJwh4RERKY/aMrmmDRXXe3tQdJ5/
         QadynpJKHEPC51cQHnjO9sZP/7tPcZX2BeB/BZQvZNUQgnufUq6BpDI8HLS0g3zLu6tU
         aftbJrpC4m9GjP+q++ShfgQpwXxXXxw/JUAO7iwMwmMiVPy4PI2Kmu7ImqiaacFuYzIv
         gBHBR3BNCQC434b0L+E4pVmyrg89RjrauKdgscncGByri8sFn5XUyf47rA02E1hOUYu/
         beFg==
X-Gm-Message-State: AOJu0YyWrg6PKG/5TjL/v0ECA0qJrZcYhnoC/B/Y57IgCE9GMB8Bt4Nr
	CXp88TcPNkK8o6QZxka/7a40tQ2fqEg9SuZMEkjnpne+KeatTG83UL0z9UdQnRJ+Ov2KpIDXPKb
	Tw4xCx+k2jNfoq6AexWE4NC/HaNnT0aA=
X-Gm-Gg: AfdE7ckIj7iSnGeGwMzPThGPIsigVZNTx1IOLPik830uAql6cQ+yZEG9EPG/uRvK6y9
	dznd0zQ/sJvKfL74CAf1PneZ8laupBHbJKxw9T3Fh3eaR78dRBH0u0OGem6WmxqTL71fBfRKs//
	Z8Dz97V5zrS/PJSuC3gTglVH/Oxzclhi3Fvb8pi7FS691kQpmq3boVUITiAkVPR2Omeh+wYVcR3
	aE1y5bvWmWwKzdAA7jjjr6oz/T1o6ykg3H33ReHamo5o621utoiUTQAHdPmJCcKqGKKjFshUcFV
	R8QFGDoEY8lVibZn3Btde9We8LMd
X-Received: by 2002:a2e:9893:0:b0:39b:7cd:e1c6 with SMTP id
 38308e7fff4ca-39c6003bf90mr2254481fa.35.1783352777967; Mon, 06 Jul 2026
 08:46:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <PH3PPF87283933B8D3A50EAACC80498FE7887F52@PH3PPF87283933B.namprd10.prod.outlook.com>
In-Reply-To: <PH3PPF87283933B8D3A50EAACC80498FE7887F52@PH3PPF87283933B.namprd10.prod.outlook.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Mon, 6 Jul 2026 11:46:05 -0400
X-Gm-Features: AVVi8Ce73yqmAe_LHs7IUAABnpW8y-7sS_7MD3ZNqddyEAOtmjDkUExRi4hhtso
Message-ID: <CAOp=CXkW4206EoW0AY-7xzvg+Zrwjjt6DiXfyL-UO8S+njK-Pw@mail.gmail.com>
Subject: Re: Bug report - Trim QD1 using io_uring is hitting unreal clat values
To: Alexa Mercado Sanchez <Alexa.Mercado@solidigm.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Daniel Fernandez <Daniel.Fernandez1@solidigm.com>, 
	Adrian Tintas <Adrian.Tintas@solidigm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 5:35=E2=80=AFPM Alexa Mercado Sanchez
<Alexa.Mercado@solidigm.com> wrote:
>
>
> Description
>
> When performing a pure trim QD1 RND/SEQ operation using io_uring, clat/cl=
at_hist/clat_ns entry in summary log seems faulty. I was able to reproduce =
this issue with different drives on different environments with different b=
lock sizes and in concurrency with another workload. If I switch the ioengi=
ne to libaio, I obtain the expected latencies in ms, with io_uring we are h=
itting latencies of 17 seconds across all the QoS buckets. I also tested on=
 older fio versions, 3.37 is not showing this behavior. The files I append =
here are for both 3.42 (filenames starting with 342) latest branch and 3.37=
 (filenames starting with 337). All logs appended here were tested on the s=
ame drive, same system. By opening the 342_clat_hist file appended, I reali=
zed the histogram is just parsing a single massive data point at the last c=
olumn of the histogram entries. I haven't seen this behavior in other opera=
tions other than trims.
>
>
> Environment
>
> Reproduced issue on two different environments
>
> -    OS: rocky 8.5
>
> -    Kernel: 5.15.24
>
>
> -    OS: rocky 10.1
>
> -    Kernel: 6.12.0-124.56.1.el10_1.x86_64
>
>
> fio version
>
> 3.42
>
>
> Reproduction steps
>
> 1. Drive sequentially filled to run trim operations
>
> 2. Run the appended trim_rnd_qd_1_128k_1w_itr6.fio
>
>
> Thank you for your attention to this matter,
>
> Alexa Mercado
> SSD Power and Performance Lead Software Engineer

I did some quick experiments on platforms with kernel 6.6 and 7.0 and
could not reproduce this issue. Please do the following:

1. Simplify your job to the minimum set of options required to trigger the =
issue
2. Since you have a build that works well and one that manifests this
issue, please do some more troubleshooting to narrow down the source
of the issue. Try versions between 3.37 and 3.42. Even better use git
bisect with multiple rounds of testing to pinpoint the exact commit
that triggers this issue.

Starting with kernel 6.12 the io_uring interface gained the ability to
send async trim operations. Previously it was only possible to use the
BLKDISCARD IOCTL for trim operations, so it is possible that something
is going wrong with how Fio is handling this, but more troubleshooting
is needed.

Vincent
