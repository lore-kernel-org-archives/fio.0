Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18061404BF9
	for <fio@vger.kernel.org>; Fri, 11 Sep 2026 19:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789155937; cv=pass; b=hVkh+qc9Ci8fsy1IleN9vUnyx5TNKTwtx3UhdvA1VNyVcpoRv6brG/9di4v3KIMU4dfNXlSMtfF1q7Vt193KxmimhAsvrFUOrd7W/UeFXgXssddVFDhRU4EYWcErjaPs0l/OYnkLfYN0+OBTUBP/5vV13PV0UCXDckhnRtekKkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789155937; c=relaxed/simple;
	bh=coQegICKr/zhdDj6vIMAeewDNeVf+Nptv9/C5lcPRKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nrigiggkCHLAGB7xsP3B06GO+G5yW0Y5vri9TD6JQYfnv8uBsrY8i8xXzWDUdltosPiOUzdJmB1UY7SO34IaVpJCM+E2Sr34s2GQSzorUPZScUYCB/rzeZglnz09F7FWAPmi/bvbfg6nluSHSovkISDj/IRKAqLg2tK7Om1qI+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WoVAbnB0; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WoVAbnB0"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3a595487d43so8821171fa.3
        for <fio@vger.kernel.org>; Fri, 11 Sep 2026 12:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789155920; cv=none;
        d=google.com; s=arc-20260327;
        b=ORxwcS+tcKP7/ub30UvQ3EilVB04qtu6jmiT5f8r+xp7if+HvKo9W1cl7tDWWbyv0G
         hDdfRwL5bYj29tYiTlRBiHjZmmSu6uvetAQEYXvOlg9pz/ZN2BXUCou2pksxPxsZaPHE
         vLtLdNZTLhKgHjQ3/NDlCmI7yCfKN4sfNTAk1T0mcFyRGj0A91LaQT44TK4EqceWaMYo
         Holf6lxZMF6S6Et5b04KyRaEe+E4DCx39mSiKF00QEZVR1wxUaeTO5zsBGQbdUOqwZ0i
         VRyTw7wet8ape+KBbvFpWD4VQePAbXxkHZtrXPVPnPj9OM1lIyLXusXQFVMIg0M4d3WZ
         Q8pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9IhlUkMRcGadMw712CUmXXTZRL8yYqb/rn27iOJ3Jx0=;
        fh=4U1Hn5Lg8YZkznXeQefaaGN8uE77LIcuj7VRWbLiznE=;
        b=YP47qt8bP2Q2lFV0juk9IS0th4CRfFqyHTP2QIWyNDjTG4SXaCTWb8UXuylovjGHsa
         TcVG/8ezuUxoRq2G0v6gSmS0ZwaGOj3qYbP0riXG9M1VT3VA15fCzSg0ZPGrRWUheJGR
         98BGu32cQ9w59sC35Ce8ZrjEGthinAZ3etV+2trlnz2OmK6FE2UPcBkzo5kc3hBawLas
         v+FxC6EvBOlYq8u6DszDiR7E/fm8pYJefF4YC7mQf7dfxESZJWy4E08WojVIBImaSQcj
         iqbCeHAai0bOIPovFJTeYMjlDuocsjKbm+O9e6/3lpsgCCyyDbZyG601UMtbOfW9I78m
         Nnyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789155920; x=1789760720; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9IhlUkMRcGadMw712CUmXXTZRL8yYqb/rn27iOJ3Jx0=;
        b=WoVAbnB00ta9o17WJdgwddVpQnPyOueppUCYDj0KEcmra2a5VtnRL4clNjQU4mZLVc
         bEk6SWsgLUlgAtyWiN6i5XDTo13F563jsdapWtya93x7pLCKLaNUUHMiv+JvJosB2xPB
         5/WiBcJg3q8gkv2BnIj0RFK3xnFxgR6jfZzeRFKfMdmUuokwN81HSJ+EjAmFm4wy/RA9
         JHut7/uFWcmVnKj5WCvP3erQ2alN1JUQBWLeMPULWcg5Bdl7kNOzZGgqJslC0EQxl+yf
         Z9o1IjlxmbSPk3AsmjRRvScF5cko/yhHJm90YX1n6zExt+VPK6ZdougO0+qaAER88vVB
         kOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155920; x=1789760720;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9IhlUkMRcGadMw712CUmXXTZRL8yYqb/rn27iOJ3Jx0=;
        b=gpOqXmOCSsGQH2D1xswad/Ht/LnogCFpeGKQLZrmi61ab3QUfbjWQayLk8DBsHppy2
         QCUvG3KNhkkKh9W7p1FrmFCsB6xrUTsSy9AeJvhXkXMbdUbdt/OWGEMoQHRdSkTx/hup
         UJH3T8IfaYWja25kyPwonT+87ThPemOdRiDzlyGnKqcfkXwCPIHgPXuBdIGAm1+jj/0b
         8lqRnKnfWF8mOZGfQKbLFjLmudCmCCdJR6eJB6+ye61CwZB239X9WM04j6U+HRwJ2KK2
         W9dWj7YanjRjhkH3KvEQIf4gO5xruqp04p4YJZIszM4ZLTH+D5kOPwsYp4KkVtdqNDpa
         TKpw==
X-Gm-Message-State: AFuF++nGl7NaS4mpr/8OyBNC+ER3FIga+iUed3iGQhAI3p9PIsaloqcA
	2POzxw5PaCFiuk6/C17gs9ZwhBGNJgbYNPuVQ+A38pIqXuugsbsSxk5JI7GMBVOwyhWUMKlKrZX
	jEX/ExGZFmvu7sBnaadT4xU4ZugByfrU=
X-Gm-Gg: AYBFou3cLzuFyO9EfHRCTYv4sL3F40t/sVCaQWX9IWsFD83tg0P3q+y4rw5RQ//BtT3
	oV4EMUKVLUJddyG0q5bjU0UaPUB7KaaCBtgQO/iQhW3T5fCaSZRG7MnRCJy/4XeKIG8iqTGkBhY
	a6m3GtVZ4qJfab/5DXWQwIM/ZmoX0RshZcH9sXbPvyp4iGcTn1A2e3oMsG92D7HazcG9eWM+Gds
	wmpstIjZmBhN0tESkAWxihs2elLnuJOKGC5QZfePhY67fGtXvTJMazz/EjZ3w0lTTDJc2vmgJm2
	ZTq2ZxRMkUSIplOoqrPbNwTB6x7Tc/n+PCR+b2AYQhprXMJb5BQaTafKovD/0/QV9/51DEx2H17
	T91Sz8qJ4Wfo=
X-Received: by 2002:a05:651c:2124:b0:3a3:7682:49a1 with SMTP id
 38308e7fff4ca-3a5a52625f9mr6786511fa.22.1789155919488; Fri, 11 Sep 2026
 12:45:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910161310.1478081-1-kbusch@meta.com>
In-Reply-To: <20260910161310.1478081-1-kbusch@meta.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Fri, 11 Sep 2026 15:45:06 -0400
X-Gm-Features: AcwNN1VE7roU4hFV5qBCWuWzedowtpcF_ij-_s5m95YHn0W78vEb2zh2x75aGXw
Message-ID: <CAOp=CX=LBjGtcF5y2Xddj+j0MpnXxe0vPhK1MpybUSKRZB5aPg@mail.gmail.com>
Subject: Re: [PATCHv2 0/4] fio: fix eta
To: Keith Busch <kbusch@meta.com>
Cc: fio@vger.kernel.org, axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 12:13=E2=80=AFPM Keith Busch <kbusch@meta.com> wrot=
e:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Changes:
>
> Fix up the state machine rather than hack around it.
>
> v1: https://lore.kernel.org/fio/20260903172101.1886315-1-kbusch@meta.com/
>
> Keith Busch (4):
>   eta: count a job that is setting up as running
>   backend: don't mark a job as running before it has set up
>   eta: cap the ETA at the job's own remaining runtime
>   eta: remove now unused done_secs
>
>  backend.c | 23 ++++++++++++++++-------
>  eta.c     | 20 +++++++++++++++-----
>  fio.h     |  1 -
>  libfio.c  |  4 ++--
>  4 files changed, 33 insertions(+), 15 deletions(-)
>
> --
> 2.53.0-Meta
>

Applied. Thanks.

Vincent
