Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A83367F44
	for <fio@vger.kernel.org>; Thu, 12 Mar 2026 14:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773326287; cv=pass; b=sUhTzC10XSuDSwvzhhLwaFCHmRBjsJTiiTUBLF5NV+LX/pyo+AAbkD3PRShgkaJd4UBSMPpVLXFcVogGzyLY/ENorzn4zpfyKf0yoeR2ynNVHFOlAtSXoe8Vhav1CFwARbCF3Wl9G2kFMwALgbdJMMDFxfYFthGvvYO5Gm89GvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773326287; c=relaxed/simple;
	bh=CODRsP7yMs/O0f8H+9vzaLj8yfx22N+frKhHnsY5NOI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qpDTmY+v9gexHTId4mCB17Ir2DvkdkNGwecy6VE0MKK74vfBcH06Lxl1cfU2Ht7yWP9nNzcVyK4BZe/RYqCBSJ+oBx5OnSm3c0qDFXK9pgmB4frL6mkWFnEQslQPdGxAFt9UV+k2+xMge/uPX3+JH89fch9mVGH8aHfiy+P57mE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FxurI4O0; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FxurI4O0"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38a76ba6a78so6345951fa.0
        for <fio@vger.kernel.org>; Thu, 12 Mar 2026 07:38:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773326283; cv=none;
        d=google.com; s=arc-20240605;
        b=KDQboy3WJ9zFu32XcGiGLW5utRwUaJ5Ph0WZ9sPp1RACbUFTcQi7Cgpjqz3kjrFK8h
         3DczdmH1CGRK3pDsj6V1CEliRMiz99ZNlhwJR4McelxHwZtbSrJOkxOZfrKQIcre2FD8
         8XSuVdAHXRZUDBilS5UQhPZA0OhyYUGSQERvEUL5p58Tuz+PIFjalgc7AZ+n1L6aR7hk
         icLVk8EyCewEiaD4VEEW20RKoUi3I1Bf5V3d5XVTEE505Fz5RujhQ1DaQPDxWx6LTyoV
         hP3eHSCA0rYSFLRFCH7i0cESpB0upDbW14peOYI9VACvNMgZESzn3ndR3OfXJtr4pFAp
         kZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/KmTU5UENligpp7Fhe73ih+OE8kYsSUhjezRJ40ArV0=;
        fh=nBltqKqfxTE99M5G9+1rlF/NG4SNbssOl7Ph2vbb53E=;
        b=LYyj4lRkGNBrWq31OzRjeXOcljsMeSt2pCPg0pQZ/ftAG4VlhYeM35wQDUydnfPWsw
         Y3qs/kuY/yLTEDl8tCcYzZBnY8GlmiOSZq6+FUTZpLxyrx4NPxjOsVkvZitGMh2YU/iE
         6PsMRbhKE/WCH4FPQ9+k1g3Vc9pMu4Enq40xbGrj8QrOZI42b0dTWa/piYPuElIofxKt
         wfjx5M2Vc8yrvjA5H3H5lly2kzkbHamB9LoChf8wUO9dV76fvZK9gGuoWXoz9Y2gw5fo
         jaKt2kMK1KrKctXQrWnjK6FY3+EqyJmqy2apJGXriDXNKVBaLTqZYApqFWQZg+HEKiHj
         m/Rw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773326283; x=1773931083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/KmTU5UENligpp7Fhe73ih+OE8kYsSUhjezRJ40ArV0=;
        b=FxurI4O0qfr2cf8SYOy8h/OPjE8Gv4CjWM6mzuCmG+HiAUSLJnaYI6jUKmDZXPtBwo
         r1U+zUlL1SIr6xFMTu7TIqF1Vbjl5LNYfLBvWx5oxGyIMtfU5+mj60CIJ/Az/VVHDInV
         ZLaFqbe/LSObujk3OXMNzXiAGZtK2eFcOlSJHW4LXo/RJMYCTPweyoQvnP4TcPCpxywI
         hB74/0Zu6rxILg4IHpI205MMcEDANt70KQvUAbfC6bPZ4FhIDJXKzzkjPOzUc2ZYyT5n
         jOOL/s53tzps0zhQH1L26hrAbGtrc7wiiNSzG96n1hJzXLjT7dd3lrRM+kWvEyfxN6So
         oWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773326283; x=1773931083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/KmTU5UENligpp7Fhe73ih+OE8kYsSUhjezRJ40ArV0=;
        b=UxIO0GuR1oCjMe+oHwj6DyzQgq4cGvDpy21KIQPG2S0HJ4+jd+pRQj+cZzDxtpubAF
         v7r1Eob0rrNQrhOeoe246wpjsAapf6ZcCkkACFb9OInBGzXnwDGV4rPtRDyyFGhCtbHW
         w9G9N3Ln3t4LRoeU0Q43ICfJamAgA5bZ4F60YOmpWTk7EdelV/LKCG5unB+DdvyIx4Rk
         QX4UkQSbkqRso8GC3FIdVq/kL/L/uJdguZT7NDNvm+UrDBQO7Io0mwe5wkttCLePhLlL
         0lRxXgYLVaEeNltXcd0d09gZA7Xdo3r/IqD+Tzz2JqTnX9iuYbGgkdcTVAj7aRF5cfEH
         oXiQ==
X-Gm-Message-State: AOJu0YwuuFF5lQgfjYyXlmr6STvaxiSLdR62U9IU6EKW4IIBsR4mT0at
	P+hGmjj6obHU1akFBcNwxl51kJzy6hlDAwH3A2mAX+O/9hoJ8+bF9UQ8VeqOEGY7npCkYNbBBJk
	9fta/NoN7RJiWQSnaGTNECwCRci1p+83ArrS8
X-Gm-Gg: ATEYQzynOkbdC0vRAeJWnbzvDVsNvJRYE/ONuTelgAZRIHtfE5Wf51YD5MuHbm1Bi2s
	9dsaJ1OlwWyiiFlwWIeSZuMRa/Is6dsEaVDAuPKy49+r7EPwzSLvTaCJuiblTv+KMKjzCzHbvub
	XlziNAxtqdIkzAW1DPFaGuWyCnU8g9W5cU3LLBzsuZ7TF/l+8bmJFDxru2VSZ6pySdEfsHYsTjR
	WZ6ZTT+ycfY3AJ647M1nKFsIu233AmHpMuxKNIaHkCZ+bReRCWQ50W06cHlhVP2rGxU+nrE2BYb
	/2W9Dg==
X-Received: by 2002:a2e:b896:0:b0:383:1d66:c1fa with SMTP id
 38308e7fff4ca-38a67ddefc0mr22416561fa.10.1773326282220; Thu, 12 Mar 2026
 07:38:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+kyTLJ7oyfzM08dH1Xdk_c2ub4hmX7aXTtxJr1YLWhjzTT99g@mail.gmail.com>
In-Reply-To: <CA+kyTLJ7oyfzM08dH1Xdk_c2ub4hmX7aXTtxJr1YLWhjzTT99g@mail.gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Thu, 12 Mar 2026 10:37:50 -0400
X-Gm-Features: AaiRm51KtLvDyc9OLmj-pOlkLSsuTB_CRvdW5zc-eff-s-E0aXTKH0sIEdS4imI
Message-ID: <CAOp=CX=qEYiGLUepFc5myXaUVZFv4CdPRt9g2WzVe-ARBr6_ng@mail.gmail.com>
Subject: Re: fio parsing issue when trying to use latency_target and latency_window
To: Mark Erdos <mark.erdos@gmail.com>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 12:03=E2=80=AFAM Mark Erdos <mark.erdos@gmail.com> =
wrote:
>
> Hello,
>
> I am more and more convinced that this is a bug, but I will be the happie=
st to learn if it isn't as it would be a shorter path to fix. I believe the=
 below is some parsing bug or misinterpretation of the manual by me.
>
> Using fio-3.41 now, but the experience is similar in fio-3.35 I used prio=
r.
>
> I am running an openshift KubeVirt VM environment with NVMe/TCP block sto=
rage backend using portworx free CSI and Pure FlashArray. There is a master=
 and 3 VMs as the fio workers.
>
> Output (attached):
> It is definitely an issue that in the output "latency   : target=3D5000, =
window=3D5000000, percentile=3D99.00%, depth=3D1" there are no time units u=
sed, so it is difficult to know how my changes in the input affect the outp=
ut.
>
> Input (attached):
> Per the manual https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-late=
ncy, latency_target and latency_window both should be in microseconds if un=
it is omitted. However, as in this example, input latency_target=3D5 produc=
es in the output target=3D5000, while input latency_window=3D5000000 produc=
es window=3D5000000 in the output. So the two are not handled the same. I t=
ested using units usec, msec, us, ms, s, I was not able to find one that I =
was sure about what is happening, especially as the output is void of unit =
after the number. I can only indirectly infer, looking at the storage laten=
cy from the storage GUI, but that is not very scientific and has not yielde=
d yet.
>
> I found some reference here, https://github.com/axboe/fio/discussions/200=
6, but it suggested the issue is solved. Not sure how to use, or not solved=
.
>
> Can you please guide me or let me know if I should file a bug (or two) on=
 git?
>
> Sincerely, thank you,
>
> --
> Mark
> mark.erdos@gmail.com

Would everything make sense if the output had these units?

     latency   : target=3D5000ns, window=3D5000000us, percentile=3D90.00%, =
depth=3D1

Internally it looks like latency_target is stored as nsec and
latency_window is stored as usec.

Vincent
