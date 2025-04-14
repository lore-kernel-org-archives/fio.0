Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4771D86F6
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 20:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744662157; cv=none; b=Z3mBIesNwoKovqYtS5EOzCwlQwWFtVuW7SvfCDNwMJX79xwC9N+9k8vtUN/9cuDAFFbK1mTSrPunj3jtNfvnpfM9aP+7HpgPjmTgk7J5tkeIrAC2/Qb4Ijmi+XCXUH6ovYbcy9TsGiGgBYhsCpI6aQMH2zNbbBCod3cHD+NF4DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744662157; c=relaxed/simple;
	bh=tDHtSd4cyiunbBZZJCmYK2hytR9ftuZuTH6XEwMFCCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dgVLTB8eV9bKZ0vFbDGMo5dUW9vtmo4ZqBlvMyZnKLvaeOfNT27bkrgcNdp8GsXabRZND64BbQ8WNy77wgu7upol4GbgCnFvmJ/iLs4MlQC2zW677HhSlSh9baxmTFk4xKzBaJdqd76ENxy5M+c3JNZGh910NtxZkRsV1yQ5knw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=gv5kw4to; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="gv5kw4to"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5ebf57360b6so601790a12.3
        for <fio@vger.kernel.org>; Mon, 14 Apr 2025 13:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1744662153; x=1745266953; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hkg+igROZY2XXnZ/y5nJwCLSmxMPf8/2UGsBkQBvJgY=;
        b=gv5kw4toS3rAypF48P55EGMmIzwvNTFCfOTiKwastIh1GJeNGDGpd1b4V4q4qM2SeU
         iw0TlCd1eMs/yNDEmrEDVNfG2MCFhYtF+niGIcl4VA7svQ4KAlkGoWX6iEH+z3JmxdGD
         y+oE045mDl1Vww5Bw6CJ/vNn8NdT4zPvQBExPWHd9ca4i4zg0MRGWc+iVXNiUtzm1a51
         lJwLJb/KCKx4TmeGJEAS8B9ytiSeopsr+QpQ0yX4ohheicE8Wf2MYbZQGdwtg2lESztR
         XrA/SG21eNRf/AoBwNur3Rs/TEthz2Wp/bpTCWaRlMT/S7DqamO7UnXLXGaVliBbmwW9
         IauQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744662153; x=1745266953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hkg+igROZY2XXnZ/y5nJwCLSmxMPf8/2UGsBkQBvJgY=;
        b=G29BrH3eyHsXAbQAK1owaxCREiKSX76/mzjxH2AGQsRsoJa7xEcBBTdxcAN8Ks6Snu
         TuaW19askTTAn8ltUnDv1llPnXEH4Mo42qjKBn9CTSqhIJOHxwIEFK8fEUZvQu8nqlET
         6zHLpWC7UUtaNxqEcHgdh/EnJb55DBLq6ear8gJ7ln810brqG7YRBnFAU9rb7Bunr8r7
         30ODjgo284PeJTBuH7T7vBX6W4ycai6FNNVdQf84iRBVKtLxeWaVn+g5aPPH5rxtx8cr
         cgOUYPizdnZOrNXlJNuGwgNFFEk2xGS8ZHx2AoJNw9pysV5oxtKbYw1kBzqR3aRnkCSH
         AIcQ==
X-Gm-Message-State: AOJu0YxSDnJVOFvFxMbrN/Q8SVLdFTrQIyddZttT8YuEGlZY4+by4N43
	EAHcM+ryqy29RYJ8xexFQicjp2rb7Rr/pv310W5FNHm7VvE6LNBvB2fmCEJtet2r88sflgyKXxR
	GdOott/FHZqu6pRWy0RdmPtg8JDfjiJdlPn4eKFiez0O2IAenLOc=
X-Gm-Gg: ASbGnctJ3ToiI6kFmYTd24I5Bh3bsJk4APbFmMqzmB6np1B+ovgaQzINlWysfmE6ERN
	1OBMMNLljJpTYY3FTzpE3PzXyJPwucaI77D6+5WynxGVUl5VNQ9Lizg0VVQOYsLC4XB+GfEnS5T
	TJR2mhAMVmH5IdK5kgBmUy5A==
X-Google-Smtp-Source: AGHT+IHJJZjqqBZOhPUv/egbvUqEyd/hdt3LTpryz11+VVveVxSyuEKTimF2npC0DtWKc8669KvfnGeBat595AusIxk=
X-Received: by 2002:a17:907:db13:b0:ac6:c179:1446 with SMTP id
 a640c23a62f3a-acb138f48d8mr34856666b.2.1744662153187; Mon, 14 Apr 2025
 13:22:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADqNVTpRsQXDsW034A8SWeWEbpsAUcidWiKgpj+Xm74NYNPjQQ@mail.gmail.com>
 <faad816b-3683-43e6-a700-65eba76d9a0d@kernel.org>
In-Reply-To: <faad816b-3683-43e6-a700-65eba76d9a0d@kernel.org>
From: Nick Neumann <nick@pcpartpicker.com>
Date: Mon, 14 Apr 2025 15:22:20 -0500
X-Gm-Features: ATxdqUF2eoxMRSPPM5E_LueJne3FIVzbDwJBmUeAyFqh3Xbs7tEyki5_52zeLrg
Message-ID: <CADqNVTrptG5b4Un=Q9Hqe5WPMTdcaCDtbjzR753j9YWorEBnxA@mail.gmail.com>
Subject: Re: Performance variation in traditional HDDs?
To: Damien Le Moal <dlemoal@kernel.org>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sincere thanks for the thoughtful response.

On Mon, Apr 14, 2025 at 4:24=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
> Did you mount all drives exactly the same way ? Do the HDD mounts you use=
 have
> proper vibration dampening ?
>
> Generally, HDD performance variations come from different vibration
> characteristics, due to external factors, including noise.
> E.g. a drive in an enclosure that is close to a fan may not perform as we=
ll as
> another drive that is mounted further away from the fan.

This definitely could be the/an issue. We have some dampening but it
isn't as good as it could be.

On the other hand, the machines we do the benchmarking on are
identical in physical layout, components, etc, and the performance
characteristics have followed the drives so far. Only one drive is in
a machine at a time.

I think the path forward is to improve the mounting, and then test n
identical HDDs on n identical machines, cycling through the different
machines. This way each drive instance is benchmarked on each machine
instance, and then the results can be compared to determine if the
identical drives really are behaving differently.

> Another thing: what fio command line did you use ? If you did not use dir=
ect
> IOs at high queue depth, you can have problems getting the maximum speed.
> Generally, something like this is good:
>
> fio --name=3Dtest --filename=3D/dev/sdX --ioengine=3Dlibaio --iodepth=3D3=
2 \
>         --rw=3Dread --direct=3D1 --bs=3D1M

Yes, this is actually exactly the set of options we use for full drive
sequential write (libaio ioengine, iodepth 32, direct=3D1, bs=3D1M)
