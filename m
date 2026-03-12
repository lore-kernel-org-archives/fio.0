Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F6A3C73E0
	for <fio@vger.kernel.org>; Thu, 12 Mar 2026 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773341221; cv=pass; b=JRjVMmeljQsXO4RhbfZzfMblrQO3TdkdgN2gfaB6Dp6IE1mvROj3ppfiiL6bCe7NFiogCla9btnvcLFxcry4jPs3BEB9mhKvrvsdTjj1MhCVGXKLtPEj6p8YQaXK/zc0C3xgP4GPv9bYY7OeqUPuxzgMKeEMRHmHv6Qh4PPLZeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773341221; c=relaxed/simple;
	bh=C/4SQUGsyjF8i77Bf89pti5tNnM83oCqwlFQctP4Aiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IuqfbmsjTdAs5MvPp6cK2hGuxUmroxhIxysg9P3m53c4Zi4JmSVt/PW771scmu7VVnHwvqCtptWtTt+F83SFAzYkaCletW/HOxCAUtu+5nJXdyXr4PVJu1Te9g0RY8HZbthzGsAdx0g4EFpyKt+7T9CPG0aekKJ8M07q/+WYBmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fVXz3i0j; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fVXz3i0j"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-89a0d53f3d1so18221636d6.3
        for <fio@vger.kernel.org>; Thu, 12 Mar 2026 11:46:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773341218; cv=none;
        d=google.com; s=arc-20240605;
        b=JRwRND99sFOjVsr5ysYt6IAvjAb/J8xsoF9uagylRoyy1oTiMwaKDWIxb8TJLYdPgM
         j1OenLperM56t3XHl5zuPaMxWiL3GKqBu8H03wWj/w3vSWznTeVIdynYyB+kCdrKmgZm
         DJn/1Kn8MEof0PDu3wxCeoGWC1jfzvnpwY7fAKJrRzzXnuZmwRQUkNwxaeewRmjCMC6E
         OKR/K1ixGJpPH1aoO4E6DZTq7PGCQYfmmL8SeyD8v0V2Roo40w+OV9+5mAvV3LrPea95
         4ls1QYXM5SFdjOBkxEbqD3OkShzoY3g+Jf3sjTH9f9g5v9oQeNmmnS+ktXH+/zbBEY0B
         01TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yeE+egMUEp1G9rdo8gZtOynliXepOP8VPPUztZAvk2E=;
        fh=8lAvoeAhQGGnOguJiNVAptl3OhyVf7zuXxuJWbYxEqE=;
        b=P0TVIlVjOfsO9TfygQWWQ+7K57OrxLZYKhIC6u2xMaMn9tCkKdSbLu/7CnjvUDpyDb
         rZhK5UkJqe0EDaksfnkL32P9XKFGTHgf/Eg8bRvvQv/dQLgaaS6kZzF4yzetVYmh/AZ4
         rWHuoh75KLFymJtZ/B0wspuBO2qS/nh9FitXeqbUGScqjAliMporm9xTuaoPV8Fujsfp
         cq5Ep4+702T9ltIKQB9FKhrjzydaHvXt5ckpsKr9Uz+4O/Mx9DVnRwbDFJUaWNtjC+66
         fp8+mBDK+6yBPEo8f9LEVSs/Ey523tNQXCBbm7OlXs6GxNSJdWZBqH5QShmEudMF7ML9
         uGGg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773341218; x=1773946018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yeE+egMUEp1G9rdo8gZtOynliXepOP8VPPUztZAvk2E=;
        b=fVXz3i0jVokZipa8s5lP81iFDRbJW4g8K3HZH/XtewZDUHW/IrPKB5+jiCJwN2wX/Z
         yWJIQBYg1+YeIV6UR5x1dSreJqLUMbWdVjevaRi6a4tR4AMVxaWFI8jguHr4zpr0E3oi
         IFxk2E6hBAOaTnYhfu3L+y3Et0vxoXTk6SXJg6Q4l2TEJDkzoX7vc8wn9n+dJDVXv5Lt
         4SKIUQ4jZ6h9g9K8KoCraY9NGaAKnUrkkvGC0A/BemKAWLUotBH21kqa1o6T9S381Nnr
         pf68w0rvSHV09p2/uTt6eIOIrgewxuCIxf1PohvC2mAgLsa4gzImnoOTaFxpohpRrcZE
         DFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773341218; x=1773946018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yeE+egMUEp1G9rdo8gZtOynliXepOP8VPPUztZAvk2E=;
        b=JoeZFedVtSA6fkKqkeOUVndNEXC4VyGQCjOp92IepgJOpCpSq6kf0m7USPMB4sFyni
         lMpZ2FfgG8DWWj+VInVL1KxZl0G0gtwsEQ63dmQEkZiRHxL+p8qIWs7Uot8r6it3otGs
         JT67dA++knZOOblbA/mFs9fkna5rY1lv+c/Z6m/hq55U7vmCrhUPqxiOQGZMugRLPpja
         I69nud+QP/sEAYmQOJeKMzYesupefPjqMkZqJRjAuIiM3Tlhn6gJe8bTOvG9DfLNVF6C
         GwJGrWpvx/nfnGlsHm87ECUXki5Uo01gnwrU6ayhKpJTBeHu0oa8OK9351ByBpUQlc2s
         G4Zg==
X-Gm-Message-State: AOJu0YyFiRsedLr8zRtohCLv4p+sUSBKXIKGAc3c7QeT/3moyKai+1O2
	VnUnosZtNW4fhbGReZu4lzG83RLX9L8hyxARF7FV9WNQ7xO+jLA5687q0dSAVvovbWZs+CePkc2
	t0zS9FfKTblVztCG+lJy3WcMKvNJo+jg=
X-Gm-Gg: ATEYQzyvF2qpERDWKoNpRC1oWcmcjb3ie0YW/ANRpgp/Cq8nYAurum7vFl6toni//kK
	i+OpnnUWq1U5H0D9onK8BFUAJA1C/XWgtNnur5m0Yd3rX4L9aal3wRZVsJr1OEwuPNq36ss3d6i
	uUOK1oXwx8mawBYDqjaQp+MiCEZmLG2HvCsrHUsIbc2FMV1J+79N4y5bxqJw0iPyw0iqPAFJOd3
	qMVjIiH0OaWz98esETFIsMkZ3bl2klzO8pNNhHjLNjeKbkTQAF+xLm2CLqykfHgebYzAjuCU0Pd
	G+o3+8A=
X-Received: by 2002:a05:6214:194d:b0:899:be2c:7005 with SMTP id
 6a1803df08f44-89a81e2415cmr12388936d6.30.1773341218306; Thu, 12 Mar 2026
 11:46:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+kyTLJ7oyfzM08dH1Xdk_c2ub4hmX7aXTtxJr1YLWhjzTT99g@mail.gmail.com>
 <CAOp=CX=qEYiGLUepFc5myXaUVZFv4CdPRt9g2WzVe-ARBr6_ng@mail.gmail.com> <CA+kyTLLmBPoB983JqBWTy_Mv8dW_QNBY8OpFauKJ1ESjx+zP+w@mail.gmail.com>
In-Reply-To: <CA+kyTLLmBPoB983JqBWTy_Mv8dW_QNBY8OpFauKJ1ESjx+zP+w@mail.gmail.com>
From: Mark Erdos <mark.erdos@gmail.com>
Date: Thu, 12 Mar 2026 11:46:47 -0700
X-Gm-Features: AaiRm51vgjnToFz8TgX-9mxARcBI6RQO-rmUE26n5dmg28vZ9OmluBCyDIdV0Vg
Message-ID: <CA+kyTLL3QJSNdDySa570MypgbhWEc0fB9QG8LBbL1rZui8GWOw@mail.gmail.com>
Subject: Re: fio parsing issue when trying to use latency_target and latency_window
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

With further testing I can see that the input is in microseconds both
for the latency target and the window, and that means the manual is
correct too. So, yes, if the output could match that or per Vincent,
your suggestion had the unit designation, it would certainly prevent
confusion for the next person. I am ok, since Vincent gave me the key.
Thanks, Mark

On Thu, Mar 12, 2026 at 10:21=E2=80=AFAM Mark Erdos <mark.erdos@gmail.com> =
wrote:
>
> [resending in plain text mode according to the auto reply message]
>
> Thank you so much for the very quick reply!!!
>
> 1. Your suggestion would be very helpful to better interpret the
> output, especially since it might be using different units from the
> default unit in input, which is documented as  microseconds in the
> manual (see next point on that).
> 2. Do you know if your explanation is also true for the input values
> in the fio profile? That would mean that the manual which describes
> both as microsecond would need an update. I will start to test in my
> lab around this, but if you could confirm that would be great!
>
> Thank you, Mark
>
>
> On Thu, Mar 12, 2026 at 7:38=E2=80=AFAM Vincent Fu <vincentfu@gmail.com> =
wrote:
> >
> > On Thu, Mar 12, 2026 at 12:03=E2=80=AFAM Mark Erdos <mark.erdos@gmail.c=
om> wrote:
> > >
> > > Hello,
> > >
> > > I am more and more convinced that this is a bug, but I will be the ha=
ppiest to learn if it isn't as it would be a shorter path to fix. I believe=
 the below is some parsing bug or misinterpretation of the manual by me.
> > >
> > > Using fio-3.41 now, but the experience is similar in fio-3.35 I used =
prior.
> > >
> > > I am running an openshift KubeVirt VM environment with NVMe/TCP block=
 storage backend using portworx free CSI and Pure FlashArray. There is a ma=
ster and 3 VMs as the fio workers.
> > >
> > > Output (attached):
> > > It is definitely an issue that in the output "latency   : target=3D50=
00, window=3D5000000, percentile=3D99.00%, depth=3D1" there are no time uni=
ts used, so it is difficult to know how my changes in the input affect the =
output.
> > >
> > > Input (attached):
> > > Per the manual https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-=
latency, latency_target and latency_window both should be in microseconds i=
f unit is omitted. However, as in this example, input latency_target=3D5 pr=
oduces in the output target=3D5000, while input latency_window=3D5000000 pr=
oduces window=3D5000000 in the output. So the two are not handled the same.=
 I tested using units usec, msec, us, ms, s, I was not able to find one tha=
t I was sure about what is happening, especially as the output is void of u=
nit after the number. I can only indirectly infer, looking at the storage l=
atency from the storage GUI, but that is not very scientific and has not yi=
elded yet.
> > >
> > > I found some reference here, https://github.com/axboe/fio/discussions=
/2006, but it suggested the issue is solved. Not sure how to use, or not so=
lved.
> > >
> > > Can you please guide me or let me know if I should file a bug (or two=
) on git?
> > >
> > > Sincerely, thank you,
> > >
> > > --
> > > Mark
> > > mark.erdos@gmail.com
> >
> > Would everything make sense if the output had these units?
> >
> >      latency   : target=3D5000ns, window=3D5000000us, percentile=3D90.0=
0%, depth=3D1
> >
> > Internally it looks like latency_target is stored as nsec and
> > latency_window is stored as usec.
> >
> > Vincent
>
>
>
> --
> Mark
> mark.erdos@gmail.com



--=20
Mark
mark.erdos@gmail.com
