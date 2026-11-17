Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794952925;
	b=T8AB19wIrXZdmWSV1zW/DcJYO/cy+OacwGzN/K3uIkQgS5ICU4ujtIegEX9SN7XU9y6g
	 XyMLflTrqIdDlr2gyNj0QPL2WqKDAejDAQUeBxc6wuFCsbE26rNEWsb7zuHeg1xUIwbK6
	 ZPvoXr1HdfXP8lpXiE9eJG1JsuSResXNPSFLUxNosjtwGMPaO60e4CHiwc5ZVwlXeZkXR
	 e0yMZaheDZNdzhwtaykcvsV/x+rAd9Y3Jurv0fLkY74/9Zu4POfp2wGzmh6mLDPbHMj5r
	 EJ9mZsbm9bWflfNtayUquSxOFaC7MO52bu96vKUQnG5Vz5LrycVyPqLqgHKHt7CshIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794952925;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=BMs09XGQpND5XXSMPIuoLfOsO9QI2cW+7riwB5KCB0M=;
	b=h+9G0EJhEMMV0ODJThxLUu4KI/uNEIPk7OX6xybmpK4V/Kz3TDQiLUnGVWdDwjgs96gE
	 3EHlpqOr2JL2MB2dICylagSBPsBGUFz1GpKOqOcjsNddegAXXr5ouTEvHVvhAir5fMvzH
	 WTiZg0JclO2OAYb0uhcEqBXifQ7P5BQAm2+ydLemfVvYotGzjxlfi3u3OyBEJb/74EmmY
	 yY8CUPrLgI/1Q4pGpCjJ6W7PsgSfcy19gvXSdqvzqpf1b94fv1HeXfn6f88ve00Tu+SWh
	 sLecYnpx//vmnm9UO/uPMPRwksSSheQgORVCadtZ1KlzyZWAod1kgkC1a3d776UyCkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qy1b6Yes;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.172
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B5A606A330
	for <fio@vger.kernel.org>; Tue, 17 Nov 2026 22:02:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7B5A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qy1b6Yes
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3adfe77d336so4124171fa.1
        for <fio@vger.kernel.org>; Tue, 17 Nov 2026 14:02:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794952923; cv=none;
        d=google.com; s=arc-20260327;
        b=opDF2EQoEQu7Ywrpcdy1gVhTYfNG469zXkyJyYz0JJDp1mMs+rjVrZkJ0EUd99uZG6
         +e7lw1qOkgYHI6YQ3fmKJimNxjKCl2f4Dge7xe1AhyGlFWsG/977BxhekTS51e0bY3L8
         sKKf7yxKQkqoPYb1zT9suKXGIdEpnqm3ia9hYT+aVhkT6jF4/62cQ8EVYUMOrIptkYds
         XDqVfHLnN7u/7mw9/bNHbX2yV0LAQXk3ASVCxdHOJp0rJQBmw3LkVooqveoEKb6Y9pl1
         PhbpdXskL/kEux30OsjmiZ+gugYbLTBFb+6NYzXRfMKvoPa3dL0vNsjx8ckpQjsDDMK2
         FOig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BMs09XGQpND5XXSMPIuoLfOsO9QI2cW+7riwB5KCB0M=;
        fh=KL7ocyCi8wo5NHSBJvo6lb6F81rZv995ihw3PDTBT8M=;
        b=c6y0V54FYYDtFiWCEEOsx8qpd/Ni2WlKT6aUvPQMd4xqWF34xE2cw0CI0yfUSOiESP
         DcpWxgZ8d4QzPLaRY0Lmh0nrmoM+3ZGFTxOW+ib4hLxwNkkU29+5cXUWXdxuhdpxLJdt
         QvDPvHR0jxKiBtd2AvQ651yYu083GFMC+MPP7RvNXovOBZHT4ib1Kyi/MC9Yy/T673uk
         +YElXVbmHXjjzlr/pw1KEteifDfiAoP1PNJO4FJ0uzk2QpaEFjCHwIUlUhNp+RBRplYF
         hvHDgeqEbRbRSybvxMUzUYMQt9g+ryqpNadMy2erww52HsBAyyG563Vheky0YLDv1CXI
         dUaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794952923; x=1795557723; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BMs09XGQpND5XXSMPIuoLfOsO9QI2cW+7riwB5KCB0M=;
        b=qy1b6YesUPIsyXGMKmveGilNKIF1nUvvCxSFt+s5NghDaegjmGPqrBkjWxfvAPGgBd
         zvyDNZcp5VMNHtsL6/4QsWrWQ+fh1ITb25goNYEDm7GEt8cKPVYTEoXfTm1OyE0jw+hF
         Xmv3tiaUhUZRZvUNsiAKkXsTls6niaVrtnmgIMECTtztWYrwOQXPItuEZYlot1pxBS3H
         EdlYZv5dnsTluRF92EE/XtvdrjMvTnqdfdmemoyDqLzDgGh4UGJZ3RRZDaewRIoWmSNk
         Rr+pzLoi6K09dMrW1HhNXaP0eXw8FcFkZ9ZSnNoMuTCrfZ6VJDsKQ0T5F5X8ui5V3qDQ
         5MVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794952923; x=1795557723;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BMs09XGQpND5XXSMPIuoLfOsO9QI2cW+7riwB5KCB0M=;
        b=kGkrvEQ0QIts32t/Wum6aJfQ8u+nlQ49+rvvFgT3FVn9TXArnWBockXBQDTY8uLiX5
         hBeqcYO5QxUy+IfUNFFOX7PLlp5Z/kJImh5GvXt+g/G5ISSOHXUhLlp176UzI6OL9aQ3
         cL6wHAFBKJcphHHRYFrYsr5pElY4U/B1rVO7mXIAoSOdYryPow6jHXvsCjWOCi4Ox9uN
         WLa46zjA+Msj6SnvJdoQpE7pl1yopIlUkHj9mbRHxVQj5vD8T9XLnssnGU/QgUKLPYKZ
         +sOW/agyNGqugCi4QL0E96oFU0v3Ve4U4fxdkIJajZmCGAvg3oTck5AvJelBqt24Srvn
         vVVA==
X-Gm-Message-State: APuU4Z+LCmV1Jv5iHziSOVBm6ZbzqoMwr+XNQk4RHKCBHxcw9MTkyyNq
	BFtpUEpTscrbRFTVL3fmKb73bT15nDQQRKGiTKXnoqsERVrtZdVhIT1esGcZdQCjdzrwuGskW43
	MM12HMcEC4UWkBVVQ17Y2Jz+WwSTPy01Il6sL
X-Gm-Gg: AYBFou2U+ew/efkEgbyZSSVBmg9dzhgK8kLDEnd9+t0/JQ/R1Kf02QeIzedJUT8bYBH
	IZXGzInUMBPkPVCUgAVQpMhReStMAFYgufHYFvnx/RKCftBgV+EnzMPXLOZnD9UYIKHcYfOtfFW
	s8i5bt6pjf2KhkjOtSygtMQbuDcpWhfbfTuEiY58i+ChXjS9kPvbSUE7iGCX+f8Obk72Ob3kWLS
	9mKRt29lIEYoMBAtEP4fg+lsT1G2gu+EcDEjw5Jq8pXgAIJ54Q6cphLI/6+D4BXJkiNoOBvQ17p
	Bhwe6mvtr3nkMOorpUaP2rJWn2LUtKCGbRf1scVM18odVyncgvDHdSPXao6QLk4nNL39CdTc0Gu
	o9E8cKfS09xw3mSj/x3QGQLhETBCoZ3jin44X2ZizIGnGx4v7DgSn+fa9XKo1JhymOTs=
X-Received: by 2002:a05:651c:a333:b0:3ac:b371:68c1 with SMTP id
 38308e7fff4ca-3ae670be907mr1694261fa.14.1794952922516; Tue, 17 Nov 2026
 14:02:02 -0800 (PST)
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <PH8PR04MB994107D250DB2434D563DC57E88A772@PH8PR04MB994107.namprd04.prod.outlook.com>
In-Reply-To: <PH8PR04MB994107D250DB2434D563DC57E88A772@PH8PR04MB994107.namprd04.prod.outlook.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Tue, 17 Nov 2026 17:01:49 -0500
X-Gm-Features: AclHuK-VqL9VPzcZwucQ7zVTLAQFFnLW7Ijp3feDklrxWQHGCby0PWKdzsqt2AI
Message-ID: <CAOp=CXnuSiNwChAbsWhXpCWyJb7NGFL5EMnL4ZHk0pRm3iaMWA@mail.gmail.com>
Subject: Re: fio Write Workload with Verify Enabled Aborts with
 inflight_issued When Write Error Occurs at Runtime Start
To: Siriporn Swart <Siriporn.Swart@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jon Whittaker <jonathan.whittaker@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 1:34=E2=80=AFPM Siriporn Swart <Siriporn.Swart@wdc.c=
om> wrote:
>
> Hello,
> We observed a problem in fio versions 3.41 and later and would like to re=
port the issue.
>
>
> Summary: fio v3.41+ verify-enabled write workload aborts with inflight_is=
sued when a write error occurs shortly after runtime start.
> Regression:  The issue is not present in fio 3.39 or 3.40 but is reproduc=
ible in fio 3.41 and later versions.
> Environment: Windows (windowsaio)  and Linux (libaio)
>
> Error message:
> <Windows>
> c:\>fio .\random_1_4k_0%_fio_job_file.fio
> fio_getaffinity: pid 14376 is associated with 2 process groups
> 4k_randwrite_1: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096B-=
4096B, (T) 4096B-4096B, ioengine=3Dwindowsaio, iodepth=3D1
> fio-3.43
> Starting 1 thread
> Jobs: 1 (f=3D0): [/(1)][-.-%][etainflight_issued does not match: numberio=
=3D0, inflight_issued=3D7109
>
> <Fedora>
> [jon@111-perf-jrw ~]$ sudo fio linux_4kb_randwrite.fio
> 4k_randwrite_1: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096B-=
4096B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D1
> fio-3.43
> Starting 1 thread
> inflight_issued does not match: numberio=3D0, inflight_issued=3D24377
> Aborted                    sudo fio linux_4kb_randwrite.fio
>

Hello Siriporn, thank you for reporting this issue.
The typical use case for ramp_time is for performance measurement in order =
to
warm up the CPU caches and branch predictors. So it is unusual to use this
option with a verify workload as Fio does considerable extra work for
verification. The trigger for this issue is that when ramp_time expires, Fi=
o
resets a counter that is used for the verify_state_save option. This code w=
as
changed in recent Fio versions which led to the error you encountered.

The most straightforward fix is to simply drop the ramp_time option.

Nevertheless, Fio should not abort the job with this combination of options=
.
Here is a branch that allows your job to complete successfully:

https://github.com/vincentkfu/fio/tree/ramp_time-verify
Please let me know if it resolves the issue for you.

Vincent
