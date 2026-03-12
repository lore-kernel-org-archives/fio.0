Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E35437B011
	for <fio@vger.kernel.org>; Thu, 12 Mar 2026 17:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773336103; cv=pass; b=PjHyOPA71A2s/Y48H7Vqr2LZj6vNr87tcrXroRT4VBOI7BZz+wWw8hKpjyxuS7nDvZIEaAgB7a1+iF65YS30SsgI6fiuJcxwOh7vBo8n7PX+Vzt4KfNP6mCsIdotdpEiV2rDo58aPQAixV8l9jGU/S2HzUh9A24v/k0w2r7sFX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773336103; c=relaxed/simple;
	bh=C9eAKTJGOdoAnPcD7AVhwnBCkxrFoPfHOw8Dxtq9Wbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mToq1YL8UXGgG0LG2L+CLjrQKBOEiXCpid3KdueCxqvF3M+Eu+8TRCbATSC0WwdRXg+vY8Y9NMbLc5MimKa4w7kz1VHUHlwbjHl2JVCshyMzEEH10YiSg6rnlslRTD3mWQ09q/WJwco5ER0cz9VryVBw1TE2eoP4fTrlAgIc1iI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WLakrOcg; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WLakrOcg"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50917e02532so15396571cf.3
        for <fio@vger.kernel.org>; Thu, 12 Mar 2026 10:21:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773336101; cv=none;
        d=google.com; s=arc-20240605;
        b=GKwsdxRfZm2GKLEM+Y+ReLyoUI92jKXsn2Xh0Dn6n21edDs5eTCqCg5zFXOVlm8Ae/
         nOPJnHApZfzcwAHWuwsYC16IMckMJMVqUqD31UH4/cguSonCxN+cmZnJLydDpJ8oibzi
         tCjLTeHi0HojqJRmiGuxAyGCYpU4K0Uw6cUn7nCyzVINBEqYhXZ1l/gZg3Hkc6OQuma5
         zxFSFfXA0+omOubbB6a6lhZxmJ4csMu3pvBysGPVKGatlDy7MYdE4Vsy0sZ5DjROumCH
         jSw0W2tLWe8v51Kjx1qHzWvuOmAW6omLxcnkPhyMF3eO4b10aARSNaQ07pH1wMI5zG18
         /NKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gMSIGxeQNrtAWfw2lDfKbe3cTEnrpwadLqg/+wpLmAY=;
        fh=8lAvoeAhQGGnOguJiNVAptl3OhyVf7zuXxuJWbYxEqE=;
        b=OkLk3DaZVdU/669faHjT0wKO8BSQfE+1yNnpEFuO4WAbfFiav/aVfdBORGLHmhwPiq
         FJcttXcteAcK2JA8OR/f1Ea7SRzpmcpAWFDqQ2jKFvbHG/OjYtoKxul+0HNnJH2VHJSk
         PSf4vAyp0Lf/UcHeXFR0iIq2/QBut8PFOTw3ihgwdeltJyL1xBzYl75xBM8BilgFC6NB
         bE7vjI6DQZU3d1ro1ULiv4KTpWsSpIPy/aisET44fb6c33eS9XPu6Ys8SslMOrfy5/NJ
         0o3FjnrK3xRW3yZdG2d5h5Wz2vjfLPfRf8RbuJyiLD8Jnrxq4T7P78SnD8OCMBbDl32g
         lDzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773336101; x=1773940901; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMSIGxeQNrtAWfw2lDfKbe3cTEnrpwadLqg/+wpLmAY=;
        b=WLakrOcgrtSolnhyeaihlWH9qQIZyNDk7O80ymZV8UbQ8QsZ/EntCv9jn4OtpUfXkY
         OeUrphXTYmUYKpLMF4q3Bxw6Myv+cL4tZVQwyma+P2yo4+Jdn7YwP+X2tl9Uq+K0bOMw
         cc2ZgY3PfWWISDebUh+70tCh3ihTsXTCTKmNWEo2k/OI83HPdnuiAwqPa6nDjj7loKfF
         KR531SAvqE8V5EIf56rTTLRD0tSo5wymNlMD3zw6HBxCktHCzaGDX7nwb9SBtwUzWqmj
         9eVG6Mm65Xz9rW89oa/FS3owAatBV6MqrXEY7SaySObJtC0OiqGdfrZTgaCPy7BiSzlT
         KpPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773336101; x=1773940901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gMSIGxeQNrtAWfw2lDfKbe3cTEnrpwadLqg/+wpLmAY=;
        b=n4Qb3J9jDS23VZhkiaFW6DrNy8FFG27ecT4oF3OCuXu5FVCIpF4j0o3F9zjHN1CLzl
         e8K+AX9ZWAFCTqVT1OUhaUg0i71uQ3MuYTuA4vMX3cZwy3ECNShY0dLUF0tncaPkQuHU
         2M6PlgDUdjIMscRkg0Mwr9jn1shziJuv0dn/ot9fT3T4kHVc15bi8roLdeFyktwGmH1C
         fAn+t5Zqtr16S7OcRhkBLIqvFGv6k9Cpd8mE0Qq2UNKCPzOSCf0RVDKhZKsXPDTaPa3W
         lV6BS7VS7QR0I+IeCvi+7pKwcRekcGQ/ME9sFZVsnWmCjJ/0YVpdVS3A/ZMuCQwqRyY6
         I7lw==
X-Gm-Message-State: AOJu0YwcFR1A0C2Bbre2gmWPOy2+eBrxa8wobfL2OQ3rZhEA0v4Y+8Rc
	WH9qrmMp9Z0Di/BmcvVb7c+lIWrEKv7PQHblcbH1hOdZT3ltDGwJ+SPYDIQYYCG8bu3SGC5pSYO
	XeK/tp7KAaoEfgwra5YHqLLzhrekVJy/qBpqL
X-Gm-Gg: ATEYQzxmJNBamrufojdVnx91KqWWYkU4SXxn7kekSU1GS23h+8g7JDc4vaDdJC6i2lB
	WJ6gxqLr7lmxYO+lG2l4J3ASJbLkw+A0Oa3Dm71TWqI6hjNU0rfz7oVnTN7y1QKkIvp/YXHIpSp
	fujH93IJ6vuGzI9qDplbFkj2bLBRcKev69hUQkMG4i78L17xgEMfaVMAl9UVHxjIN+L6yw02Djn
	b0f5EMRn6vZllKw4swYSjDMKgMY7PK1hfYszfFp1KQEwx+8WZrJkiidZLKAH2tasIXnRh5NY0TL
	EA2zM18=
X-Received: by 2002:a05:622a:18a2:b0:509:4d26:25d9 with SMTP id
 d75a77b69052e-50957ecfec8mr2774031cf.58.1773336100957; Thu, 12 Mar 2026
 10:21:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+kyTLJ7oyfzM08dH1Xdk_c2ub4hmX7aXTtxJr1YLWhjzTT99g@mail.gmail.com>
 <CAOp=CX=qEYiGLUepFc5myXaUVZFv4CdPRt9g2WzVe-ARBr6_ng@mail.gmail.com>
In-Reply-To: <CAOp=CX=qEYiGLUepFc5myXaUVZFv4CdPRt9g2WzVe-ARBr6_ng@mail.gmail.com>
From: Mark Erdos <mark.erdos@gmail.com>
Date: Thu, 12 Mar 2026 10:21:30 -0700
X-Gm-Features: AaiRm53DgXD3nxDiiRFJjYuhgGHxtxyqS_sIB4SYOL9MidvkkM8bqhJCMgRUAZo
Message-ID: <CA+kyTLLmBPoB983JqBWTy_Mv8dW_QNBY8OpFauKJ1ESjx+zP+w@mail.gmail.com>
Subject: Re: fio parsing issue when trying to use latency_target and latency_window
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[resending in plain text mode according to the auto reply message]

Thank you so much for the very quick reply!!!

1. Your suggestion would be very helpful to better interpret the
output, especially since it might be using different units from the
default unit in input, which is documented as  microseconds in the
manual (see next point on that).
2. Do you know if your explanation is also true for the input values
in the fio profile? That would mean that the manual which describes
both as microsecond would need an update. I will start to test in my
lab around this, but if you could confirm that would be great!

Thank you, Mark


On Thu, Mar 12, 2026 at 7:38=E2=80=AFAM Vincent Fu <vincentfu@gmail.com> wr=
ote:
>
> On Thu, Mar 12, 2026 at 12:03=E2=80=AFAM Mark Erdos <mark.erdos@gmail.com=
> wrote:
> >
> > Hello,
> >
> > I am more and more convinced that this is a bug, but I will be the happ=
iest to learn if it isn't as it would be a shorter path to fix. I believe t=
he below is some parsing bug or misinterpretation of the manual by me.
> >
> > Using fio-3.41 now, but the experience is similar in fio-3.35 I used pr=
ior.
> >
> > I am running an openshift KubeVirt VM environment with NVMe/TCP block s=
torage backend using portworx free CSI and Pure FlashArray. There is a mast=
er and 3 VMs as the fio workers.
> >
> > Output (attached):
> > It is definitely an issue that in the output "latency   : target=3D5000=
, window=3D5000000, percentile=3D99.00%, depth=3D1" there are no time units=
 used, so it is difficult to know how my changes in the input affect the ou=
tput.
> >
> > Input (attached):
> > Per the manual https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-la=
tency, latency_target and latency_window both should be in microseconds if =
unit is omitted. However, as in this example, input latency_target=3D5 prod=
uces in the output target=3D5000, while input latency_window=3D5000000 prod=
uces window=3D5000000 in the output. So the two are not handled the same. I=
 tested using units usec, msec, us, ms, s, I was not able to find one that =
I was sure about what is happening, especially as the output is void of uni=
t after the number. I can only indirectly infer, looking at the storage lat=
ency from the storage GUI, but that is not very scientific and has not yiel=
ded yet.
> >
> > I found some reference here, https://github.com/axboe/fio/discussions/2=
006, but it suggested the issue is solved. Not sure how to use, or not solv=
ed.
> >
> > Can you please guide me or let me know if I should file a bug (or two) =
on git?
> >
> > Sincerely, thank you,
> >
> > --
> > Mark
> > mark.erdos@gmail.com
>
> Would everything make sense if the output had these units?
>
>      latency   : target=3D5000ns, window=3D5000000us, percentile=3D90.00%=
, depth=3D1
>
> Internally it looks like latency_target is stored as nsec and
> latency_window is stored as usec.
>
> Vincent



--=20
Mark
mark.erdos@gmail.com
