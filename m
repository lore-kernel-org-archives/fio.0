Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03322A1AA
	for <fio@vger.kernel.org>; Fri,  2 May 2025 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746214454; cv=none; b=Kr0uqMiTeU9ZxA/BaD8RopQFR6i4LwseRGmQzwDOup2PY6FOVaKmYqj7HRSlre0RgFHGlsp5WCl2UnoG7rw+YO812rO6G1+9Jq7Khk2Ab3ZTYHnG2FyemBnMY/IDxZFf1D3xViAiNaAFSlFWRNUtxik6Zo5EYaxYjJgQLPGRq1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746214454; c=relaxed/simple;
	bh=g9dtI7roTqslVHFLr4I9JeMzslEbVl0qbsoj/s0rADc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gkin8huGLY8UF9yWgJiOs3GoNqd21vQgwKPggHquXxksabXPL4zB55uZ2Z2v00tXGy80FDm+lZnhNn9sOod23ckThVwe0oZq4MzWn+6TZS/HvAIbH5rkvBCeTYRQ92J3D6xacTByntDtIQXHP712te6pECYd5OT0KvRYJQ94LCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=JLAYP1Bm; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="JLAYP1Bm"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac2c7a367d9so31748566b.3
        for <fio@vger.kernel.org>; Fri, 02 May 2025 12:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1746214450; x=1746819250; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9dtI7roTqslVHFLr4I9JeMzslEbVl0qbsoj/s0rADc=;
        b=JLAYP1BmmdA3rUM2j2PKwKbAydlo/Ifn4owWG33J8lsWQd/B5E3wnWxAhmqqJ6ljWd
         nb9zIrhYlentDnE/61j3vltOpUdJTbLleLOeYA7orf7P3un8Jg9cSzrb/CSEyY5VXZVB
         m0jJOA4uMHA/b1mhKp8vXS878wcyx3e4X8fu6CcDXm4Am9c/q1Ku0lWGfPkLzhPs/UGt
         aegMmP3UMk49g+3MYeJNZ0YhQ24yr1KgrKhy9Cfo6Nt7lX6bCE03H4BPr5C162w6Q/Hu
         3bRSq+Xe7STWrXC/ILFOCUqs4UzHkrNRiKTfar1qUQx5ChPZ4pU660D3ljG7ShUeN9qo
         4nzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746214450; x=1746819250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9dtI7roTqslVHFLr4I9JeMzslEbVl0qbsoj/s0rADc=;
        b=lmuJfGirBk9MTR2IwkoExwFaCg+dzye98USW/O5bmION49ykO4U9GrRLJmBtixX2f3
         URux2lEc+eMDmR+anm3Fe3dNnsEgh2H2YkTC8cCL5y/XtV/f2Tqb4drpTew2C0VdcJ1p
         /g7K/Wo1PCRZ27movwv84lhM09St+0CfbCu2fz/kE9MfNZtRQ2PnPh5KtdJ9yXjuoOa8
         pq9n8+RWMG0dxHTYQLT7MHx/d2u3jvmrTXxSXFYpfzfPY7OxBCIezweHWh+ing+bkLBH
         R4o94haMq0mFjvVzm/vSxXK5OuVfplpTmkMmp6v5wGFhAxn4J+6YzzDitGXGjvUMhC47
         70Zw==
X-Gm-Message-State: AOJu0YzRsOk4/y4Ygwk/a1qk9c6PnkTdzKCSZZNxmI9yERaFVPSPd1Ic
	4/Ha+RJOA1k9BlEaZ0EX9M1SoIjtjZDaePqvFtwlj10yymMgNnQpZkG3fL4Gl8U+Hh0RQMgVhPM
	JVueOwWFG1r+Qzbq87VTCWLynxzLZaFOdNuRT0O2nssOGsI9dHPA=
X-Gm-Gg: ASbGnct6v0LlprgmD8SW2Mp+6FvrB27GTzaqJuf7O2TxPWqUiuwqAwhoS614OAXWkFM
	sssp0UpM62xeeicULXcCHSy5aW11wo1qKbbBd0i5vx0+QB/7IgOt+EMZVSdx4EKSM3TqaDK7tAg
	oEiXlVp+Vz+FmABaWqkfZWlDo9b3eY9rYv
X-Google-Smtp-Source: AGHT+IHgQiCXdBr/kAEFATMYkHoIHzMLErIeenziS8lBf2wFnz+gtv0462lDXpxAiKn11ofUHrllKq2Hye2GtRPGHFQ=
X-Received: by 2002:a17:907:1c1e:b0:abf:6166:d0e8 with SMTP id
 a640c23a62f3a-ad17acd3243mr128492366b.3.1746214450189; Fri, 02 May 2025
 12:34:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADqNVTpRsQXDsW034A8SWeWEbpsAUcidWiKgpj+Xm74NYNPjQQ@mail.gmail.com>
 <faad816b-3683-43e6-a700-65eba76d9a0d@kernel.org> <CADqNVTrptG5b4Un=Q9Hqe5WPMTdcaCDtbjzR753j9YWorEBnxA@mail.gmail.com>
 <CADqNVTqM3se6L=qJUh5U3kwpWCCbuR3GjE+xQ+JCQVRL=t60OA@mail.gmail.com>
 <e5c59cb4-4613-415b-a8df-9926bfecee64@kernel.org> <CADqNVTpdEgAgp3tvCEVGq1trdJwMO=EVZ5bwBQppWVfaBUOeFw@mail.gmail.com>
In-Reply-To: <CADqNVTpdEgAgp3tvCEVGq1trdJwMO=EVZ5bwBQppWVfaBUOeFw@mail.gmail.com>
From: Nick Neumann <nick@pcpartpicker.com>
Date: Fri, 2 May 2025 14:33:57 -0500
X-Gm-Features: ATxdqUHQQ4J6V7uc6wuaEyu2ulZI7KM1Rl53-GIgjJwbTWBZxIzeodoxtH4XFFU
Message-ID: <CADqNVTr=172CGUwUGUzDHtONV5YWw2hirKXzebmb0rp2YdDTLQ@mail.gmail.com>
Subject: Re: Performance variation in traditional HDDs?
To: Damien Le Moal <dlemoal@kernel.org>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here's another CMR drive (https://pcpartpicker.com/product/6FQcCJ).
Here, two identical drives with same model number and firmware show
about a 10% difference in performance.

Looking at the average full drive write speed we saw the following
results in MB/s:

Drive 1: 153.86, 153.86, 153.86
Drive 2: 140.63, 140.64, 140.65

Again, each individual drive is incredibly consistent in its
performance. But drive 1 is over 9% faster than drive 2. And the
graphs of bandwidth over time for a full write are markedly different:

https://cdna.pcpartpicker.com/static/forever/images/content/684ce1fea285868=
1575fb7666b8b987f.png

Reporting benchmarked performance for HDDs is problematic when there
is variation like this between two of the same drive.

On Sun, Apr 27, 2025 at 12:23=E2=80=AFPM Nick Neumann <nick@pcpartpicker.co=
m> wrote:
>
> On Wed, Apr 23, 2025 at 10:00=E2=80=AFPM Damien Le Moal <dlemoal@kernel.o=
rg> wrote:
> > So these are drive-managed SMR disks, right ?
>
> Yes. I chose these first because they show the largest performance
> difference between two "identical" drives. We do an ATA SECURITY ERASE
> to reset their state/LBA mapping - it takes longer than a full drive
> write.
>
> Here is another set of identical drives
> (https://pcpartpicker.com/product/XtjG3C) that just completed and also
> show a significant performance difference. These are CMR drives with
> the same model number and firmware.
>
> We did three full drive writes on each drive, using the same proper
> horizontal mounting and position.
>
> Looking at the average full drive write speed we saw the following
> results in MB/s:
>
> Drive 1: 162.72, 162.73, 162.73
> Drive 2: 155.69, 155.70, 155.72
>
> Each individual drive is incredibly consistent in its performance. But
> drive 1 is over 4% faster than drive 2.
>
> The difference can be seen in a graph comparing one full write run of eac=
h:
> https://cdna.pcpartpicker.com/static/forever/images/content/221396115ee6b=
ae8fbd35135fbc6441e.png
