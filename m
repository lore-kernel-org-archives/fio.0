Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E852628B7EA
	for <fio@vger.kernel.org>; Mon, 16 Mar 2026 15:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773674368; cv=pass; b=EPwEZvTUMV5ownbVlzjEAb1S+QpzS7SD1wqK7KVHJBkGcq/XY/Imh8woBdiZJnopEvaFWFp1FOKMtzXZ9PclckjkHRKBpCmJ/iLmXIysUkOx/XM9QVmSHB/YW7m99K0mgMb1qYt4APz3KhPkYfvqj702XFgsWrU+9x3HvH38M1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773674368; c=relaxed/simple;
	bh=vlSPLOqczSmZu+2OGZHKApUtw4dozqF1eEsELrI6kgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=owzy3sL7AuhL4FpG1LR+IhZ+2dZBMTIjzXc1157fKAW53z3dh1yNCiyk7oa4VuAq6YRyHFjzKStuo+sB6PCgDfqmRmFOW7UpaO9a+CaLinTTXB417fCP7i7jZRDo0ziEgzXB4roeqSv7n0kYcYhindCD1jbwNYvsM4csnAOandY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJRLI0d2; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJRLI0d2"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38a3066b68bso42799721fa.3
        for <fio@vger.kernel.org>; Mon, 16 Mar 2026 08:19:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773674365; cv=none;
        d=google.com; s=arc-20240605;
        b=gXBNHmYjIy+QPruP5znUp+ZVQi1OBxXYgxYjQ2TQMbItVbUfsmniUfuR1F4TnWFJtq
         CnjY+zaFbGxqGY/KR39snnTllaeMRWfVHTx1p0fbyT57C5EXQ3YFaVkmSftBxxr3B4IL
         q5YbEw14oFheaimhGk/ECFdFeBFt9bek5goDjSyRLsRrH34ntkc+DksxLdS56mWH/qdP
         ZeruswzYku9qqCyXhRxhy1W0krj8NxYj9a7uKH4XR4KBNckPm1jM8N89SgNoVrFFpWFS
         GHZHbprpBUYb8I0O771nF+QlnO9fa8ahcfJohwiaXzqJOVSQfpQKFNgLspLXjBpkIO1R
         lFiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vlSPLOqczSmZu+2OGZHKApUtw4dozqF1eEsELrI6kgg=;
        fh=nBltqKqfxTE99M5G9+1rlF/NG4SNbssOl7Ph2vbb53E=;
        b=YtDIemf9bQ5bSFyqRvL3vl3xGs0e3g60JqZ3J1S3KiZciBBrxrL4xy+t6ZJ8qbBPlW
         p/0eIqbPod9g6JzjPfmTXJIaqr0xsmp7PnomHH9Vmriwf/eHe3AQsYK/7iMhIZwwwKa+
         R4pCT/0p98ess+riu+zZWlxfEk67JsNnze9hnmSga9oetnUBQ59rtphXwisCzJAlwtN3
         d8gdmWQa1UuQi3zXQ8W1vvGqWM+3TC/lhU40YlRtD/llz4OqFEsQJm+tg/tocRkG3wyc
         TXG7BfMfwEfC9IT29cO30T046K24W0U2uj9fXgos1fzaa6gMOYjDSgefBNy418QjaTif
         pOrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773674365; x=1774279165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlSPLOqczSmZu+2OGZHKApUtw4dozqF1eEsELrI6kgg=;
        b=KJRLI0d2io1zLebHyiJopx9VKZ5gs8k07ZpL2ZfMn/BHWL/NDoYO39OuvoEuCfywU8
         afebfb66VEEHD7LGCD3EMtM/GoGxN/8cMKboVV7pjNdVSDwiCyVfQ9OmX0n1UShAhNF+
         f7OTj+PecppzD+qhIzpL5k/rMo9jALrzbNDEpTIMcOyGigqLUOeA0A+nGhhSID6H2Zyv
         zp3oRICfC4agB6c8Nf8fjCsTHWOizuKwltszuenxP0ff6VdUA7IBcRHx0520mRztVXun
         xEFsU6Zej0LhelhSNAlaXOOT4i/l+/BlO9MMysQI6rlXD9j8e1nNxjXCtfd3dijbkVin
         75gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773674365; x=1774279165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vlSPLOqczSmZu+2OGZHKApUtw4dozqF1eEsELrI6kgg=;
        b=ROsXBmhUXxVMtPF49FxlH27cOik89AC+rG9B+b7MpW9mG8uDQErCLiKe1SbVsMcgfZ
         AjkAKGbZ6xa5v8kkoKs9vSQ1TjPLHH2+pb0LdMySHk1Htiv9NrpYa4wpQrreuiM+O9v5
         9fjZ+XBXK83phPnhPHqZV1GV5gKt4LA4576pVwM+yE0slhfQ0Ge71g/neEiv8DmrweCa
         PXGdIbSJnEH8X0SnFiAsYHJGdLLgVtJRUeMIOManCXJ4rAxsmDLAbGExeGOD1CmYMPT4
         kTaGSS/MoOLgYlxacY97Ukn6pyfEnp4aADokk726D821aSzVvf31RqhrdiCI2Gh7TKMz
         UeKA==
X-Gm-Message-State: AOJu0Yyvtrxj11vUGMr4Bw8Qsw9Fzj+TDnwp1cobQdp0v6xia5QMP9HG
	S2+5XZH9qdSk5Q3UUfCFJJkfOaKgc/gQuunaw1pkxJYDM7LTHg0aiQyIx6GQf9hgdYv7haJ59KI
	a9DpPqj3FqA5Gn808ZIaC0paDycRFIXch6Q==
X-Gm-Gg: ATEYQzwnlVWeZRR7sVQ5lCqvqpcp2RzrOfnw54F1cW3bYwj16255V8zfc/efrO05QjW
	JCAhecbMGTnCokk8+4ORJkPQQVISzT2ONPugJ/tSm3AdWro4iXhV1Uml3U4oOsDAplTBlnWntot
	jvkydhNKqLALJhXPJ/BH+hpfdavCKpTo6dOpe+bMRiGlpaT8MZSTxit/HcEoWV4fKdFLUP/Lg5T
	eRy5v6m7xvNYsZcgArTNG9ECRMWwQDkIQTIMHUQV1YVHjVI14DRdH8X6wKi3HunB9w75HMcxldj
	1V8beA==
X-Received: by 2002:a2e:bc10:0:b0:38a:81bd:deed with SMTP id
 38308e7fff4ca-38a892f836dmr47620311fa.0.1773674364878; Mon, 16 Mar 2026
 08:19:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+kyTLJ7oyfzM08dH1Xdk_c2ub4hmX7aXTtxJr1YLWhjzTT99g@mail.gmail.com>
 <CAOp=CX=qEYiGLUepFc5myXaUVZFv4CdPRt9g2WzVe-ARBr6_ng@mail.gmail.com>
 <CA+kyTLLmBPoB983JqBWTy_Mv8dW_QNBY8OpFauKJ1ESjx+zP+w@mail.gmail.com> <CA+kyTLL3QJSNdDySa570MypgbhWEc0fB9QG8LBbL1rZui8GWOw@mail.gmail.com>
In-Reply-To: <CA+kyTLL3QJSNdDySa570MypgbhWEc0fB9QG8LBbL1rZui8GWOw@mail.gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Mon, 16 Mar 2026 11:19:12 -0400
X-Gm-Features: AaiRm52MA1nP0CdSe4k3By79sGoGCMEcruXyGFmu1UC2M8u4LujgPWho04tNecM
Message-ID: <CAOp=CXnmKtQf0mK0uWveOsjKpZ04d9icQLyWWOtgQSJJS91Jbw@mail.gmail.com>
Subject: Re: fio parsing issue when trying to use latency_target and latency_window
To: Mark Erdos <mark.erdos@gmail.com>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 2:46=E2=80=AFPM Mark Erdos <mark.erdos@gmail.com> w=
rote:
>
> Hello,
>
> With further testing I can see that the input is in microseconds both
> for the latency target and the window, and that means the manual is
> correct too. So, yes, if the output could match that or per Vincent,
> your suggestion had the unit designation, it would certainly prevent
> confusion for the next person. I am ok, since Vincent gave me the key.
> Thanks, Mark
>

I committed a patch to the repository that adds units to the normal
and JSON output. If you are able to test this, please report back if
you encounter any problems.

There is still a problem that --latency_target=3D10000ns specified in
nsec units is not parsed correctly.

Vincent
