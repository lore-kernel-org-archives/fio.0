Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9BF3398A
	for <fio@vger.kernel.org>; Tue, 27 Jan 2026 02:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769480172; cv=pass; b=FgQTDRS5YeRAAjmDKpFcptCcLiGtbWM5HoxIeiuZc7UD75SZ5E5tAl24wAfSh65N2xdj/cVHPyc+p6NmnR6L224orrxnyobRFytwGpZLPhWqNxmKftK2Y6qjD0gCGZW1cwlmNMPc7M3pv40uBqS/iW83mXn4iODAle/VeG/Cd3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769480172; c=relaxed/simple;
	bh=oVwkOJV4k7GwN9TJVjM2zTD2yUdLp+WYcfZSAX8LXwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZFewVoJNvTLDzfSoUg33hHsv8yndTeMsxYj/Khft/guZdw6Q4ytpr0/hJK36isdD8iLI32vpGq4kNmBSO3Zx2IjVwvIwbV99SlY3Gke2s0k+B+pzTSTDMiaJxwzm6L3fWqumq3xbToNm7ixIq8Gj6tC2Z6AvJizSR1q5Fi+AymA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSSEjoJR; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSSEjoJR"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-385b6a15affso56375051fa.0
        for <fio@vger.kernel.org>; Mon, 26 Jan 2026 18:16:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769480170; cv=none;
        d=google.com; s=arc-20240605;
        b=lYE7p1TB8jqca/FfCoR++zcR1JZgAp2k2zg1YvZf/WGmvoEGymprlJhUsiBSOe5Wyy
         /51GtDPdseCyx24lz+Xny0C2etVBeef+BZQFZSsbBGLlzeC0m+u31RlAy0hJF4/acxb8
         4vWUHDAXNpCjmhjFxumyA6oBzpK5BpCJj1PZXVCxrQ59hrIxAd5/o/ctl4VxmCJa+Ksi
         g54UpJR9GFFX8+swtN97tPN6EQOh5cb8yvE7y7ldxXhsDy0afPGvzlx21bnqGWTH33XA
         DWPvWTs5Skm6u9wgBmX3Z7XifnX0mOozMERKWvg4hVWdu/GckCssBxsTzSNcfcShS9oq
         poLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gU/2me84dz8znByCqsqfCkCcQpBVadUDaCMc+91J+PM=;
        fh=gL87eSS4wBti6cZNwPiXv6/aOCcYnKaiDV7C9q1zHRY=;
        b=AQbxNHY9v++s7L02gIWL8WsNwkMwyevp1qESF3OI4nHD5s7zF/C5UdAc0BqI7vi+/+
         6XG/ufXwCk20zgrdbHNJEzKKrwCC2PQWuZvurWbCWmBrLK2i6piQSv3jo1Z7kgi6fQ8T
         FOx2GWSVLJzF1jwmNWl80TK6+VRHjjc6KeuWkI76r0CexbJMQsfh9ozZ+d0vvRryrkBT
         h0bTtmbLVALwMF8gObhvj8F41N/udt15IcRPRVnhWjh24JKQ0yhtQJBLrltq5ZZvs+8F
         bWpsHd2drpVBy2t7NHLxerIjBN3Kg5orSN3LZ35zU4BV+gXfiOJcJZMuIkTUvUN44z4I
         MHFQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769480170; x=1770084970; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gU/2me84dz8znByCqsqfCkCcQpBVadUDaCMc+91J+PM=;
        b=GSSEjoJR1mPWYwBX3wURvTlTlIDDa0UwN2ytNOPkza3K2/Osdui8QgF113v4c21oz4
         UOfAIYZFXTbxivG17Bp3lPov64+RJj5sa4qVSITLMQooy0LR84byiPeyUHOQ4s9ZPJ51
         8Mf0mquxG8dlDgojEBTgF+4aMLF6luFZ1oVrGaRqdkwTUq1GqYEin/ZvMNToCEPTxvuK
         amZzXxCXOXJZuc5ffo/yDlchOnqvto9vWq1jQYC2XE9neAh3EBY/5hsxTAkJm7astISZ
         mRnE+xa9e3G1BrN2fuP2gr4REq4G4agBlRUEgSFq/61eDFD3YLm/Ytz0YCxCmcFqwS+g
         VpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769480170; x=1770084970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gU/2me84dz8znByCqsqfCkCcQpBVadUDaCMc+91J+PM=;
        b=dQSILGARXeG8alVfrjxMD4wiJJlEU6qRU6TGmktNxO0yzU/1gymTTdhgI1/7KpkVpU
         4LnV22TuIM6Bynv7QfFTN5a3Ws80g98eT2PHOSOmHrHrufAwv0ZWJ4hGI37bIqjn7Z6d
         Zg+VcfdJi0uxgytANZYFp8OYm+r+u+sDtne0dHFsiZYa5Fl5FXAgdJhm1rRtaQOFzg1I
         QwqtN+NSNnlmfpC7qEoxoAhSOGD4gsEP2Z9nBq0iIrH9l3drox2JsFJ7RLf4766ZMjWB
         6NdSvW13vDhqpGYD3/g2UoWEgnLEcE+lTXz4Y7I5uDm7uPzb5xVvI2MKWAVTXM+ppQQN
         MVEg==
X-Gm-Message-State: AOJu0YzTrtvgzeDmh40eIYUckwSuMzmvczqqPUbunWw31FpRzNkDWEU8
	JXmJT46VBaOj3cFbxSSFSvsPc9sVWdLB0oWlk4+P6KHRicy1W0hUWx5itJv1nCc8SITvHxyp8De
	ukXBPJ9V4NfC+AUFZfpj3/hylfNC6IfrRAg==
X-Gm-Gg: AZuq6aKfLdFWd8IMuergQZpK+OeiE9WzcgjwvfDddtkQ3QeTx2MCjF/Yt6o8AzrKm8j
	DZnWdFuXkh8HTVFxr/KqFK9XREFVhjjbBY/QjEwzahT6WXWe61bD+EAjwE3LC0N2plTS7EeIaVX
	ZYpHgdzfrwatWJaYrlWo9vmD3+OHLsBE+bQ99V31cUbc2MU2KP15iLsqzDyzZ0NgITu+jfyD4BC
	pzYiSIBvjA9REXXNXMjOVi1Ajw+P0+WYrfQjpMMw2MwEaqPJ9810wkwlTjT2Mru6GfwSQ==
X-Received: by 2002:a2e:be84:0:b0:385:f547:183f with SMTP id
 38308e7fff4ca-3861cddd999mr401311fa.3.1769480169334; Mon, 26 Jan 2026
 18:16:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126061721.270448-1-dlemoal@kernel.org> <CAOp=CX=dWPmgjKhZFK8BDKA57qyYJKCJkYBKYOLynU1n6bi=ug@mail.gmail.com>
 <83b16ae2-4a7f-4165-8c8f-adbde7e581d5@kernel.org>
In-Reply-To: <83b16ae2-4a7f-4165-8c8f-adbde7e581d5@kernel.org>
From: Vincent Fu <vincentfu@gmail.com>
Date: Mon, 26 Jan 2026 21:15:57 -0500
X-Gm-Features: AZwV_QgMiARJISpWaRrGNrxvgDULJfHkw6SwWGgDIT59XG1UwJwmKlUwl6tsL0c
Message-ID: <CAOp=CXnJ3Sr2ZGDjiAHdPhi4eKfUo-RtJ0h1oF072ew+Xfcy7Q@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce the end_syncfs option
To: Damien Le Moal <dlemoal@kernel.org>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2026 at 9:05=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> On 1/27/26 10:01, Vincent Fu wrote:
> > On Mon, Jan 26, 2026 at 1:22=E2=80=AFAM Damien Le Moal <dlemoal@kernel.=
org> wrote:
> >>
> > <snip>
> >>                 }
> >> +
> >> +               if (td->o.end_syncfs) {
> >> +                       td_set_runstate(td, TD_FSYNCING);
> >> +
> >> +                       for_each_file(td, f, i) {
> >> +                               if (fio_file_syncfs(td, f))
> >> +                                       log_err("fio: end_syncfs faile=
d\n");
> >> +                               break;
> >
> > This seems like it will break out of the loop after syncfs-ing the firs=
t file.
> > Is this intentional or should fio break only if there is an error?
>
> It is intentional and it is the entire point of this patch: doing syncfs =
for the
> first file will sync the entire FS, so all the other files will be sync-e=
d as
> well. We thus avoid the entire loop on all files which is extremely slow =
when
> running with a large number of files. We only need to do syncfs() once fo=
r the
> first file. Ideally, we should do it for the directory specified for the =
files,
> but that is a little more involved as a change.

Ok thank you for clarifying.
Please emphasize in the documentation that this feature assumes that
all files will reside on the same file system.

Vincent
