Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B106130E58
	for <fio@vger.kernel.org>; Sat,  3 May 2025 16:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746290881; cv=none; b=ABULluW5IOtyD7+B4eDA5comRi7DBCex1nA476HJlyGBMxWBFwgUOvjTlW/TPC+bMGUU0iaN7u36lauF05AzhlDGddRmevPc2ux+bMUjE7MJJBMXSA7+e+8klFCbQNucgAPYVDuqf6SDCiOWCdH01kVOOXaKwC2quER6HuE81BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746290881; c=relaxed/simple;
	bh=EUmdvfdo1yKImXVnt+/r+8WJ2ufKUTDbXceOh3wRcPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mte9ll89XWCjbRbtgiW9sU7TqwMiMWwis5CYA7uldeKNpAB2V9H35Gu5HoswdlAt3uYynBpMBfAg2TwqogkkhRZeWbj3id+S2ueLrhu7Bf+rLQK4HqjNyDG9MHD7Yy/3qObm5XlTVDG0bEeEV6KrHnTWdiXQRpLKHlXdnkAD8fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=fpUIW06X; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="fpUIW06X"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5f8619031f1so546862a12.1
        for <fio@vger.kernel.org>; Sat, 03 May 2025 09:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1746290877; x=1746895677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EUmdvfdo1yKImXVnt+/r+8WJ2ufKUTDbXceOh3wRcPM=;
        b=fpUIW06X1kV0bYcQdc6oCMokqXDaGj9e1/98fX3EOAFhj+yzrdkMUObqU6e8bmM9jH
         MS4kcSRS96hGB97yMFShyNGuaNKoDzF6b4aCOzaDLgkFN9CdBcUllEP60TWSEA2qrk+k
         qTw3c2YUcH2npPyWGYiQ7GWkCb+hfcY9WgGX0PYoZ6Bz5SkuLQHVQ3zkazBqxs3oonDW
         5T2kXV91rXDuF1T8xOpJRnsX47E6enGQvWmSf0x4YZtTZgU4qOt77K8DxAC7cJYN/URL
         Hex54DsKayUd29833o7CGyZAv2QzXQzZQmUGfDgYN0fwfjpUepGlbrLivcP6SNRAPCeB
         Hb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746290877; x=1746895677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EUmdvfdo1yKImXVnt+/r+8WJ2ufKUTDbXceOh3wRcPM=;
        b=oDIeQl8d/bLcfB0J8UFHEPH4HdyOccB50vPzfCBYmmn9SUpA8DAe+nPS8FNsQ8iHYA
         /wC6+VoJ5/BO4zhHNEaDaWwRFIsZL6KJ0gcpLpVzJ/gx9Z1+mKa6Ic/E6+Rks0SuSWaJ
         Fe/BmGzcTV0z7r8zT+modx0i8ryV4CPJEtnFcH08MfrpHqTwSvPMRhkm5GpV/yMi3u4Z
         zBAPNWL+ILitXXL9rd9RcZtoOqZgqfPuKE/K+/zazhFkvWoi6t+Ya63dshLymOAKt35m
         +J2EMNjQJKFCAoDp4VfumlsL4KEpM160WzrkPVpGJmAdJYXKSII4I30I5Xp3aD01zoYu
         HPhA==
X-Gm-Message-State: AOJu0YzXiyB4Dvc0gA2rBqBiJkxtBblWpBkp9GkTHzv1OWTVxTW3KDTh
	BMO5Mi9jA/2Lh5PvD6tnjcQXW7jrZafzE/dOelmtikLQ/ZUk2btUSizmdqJ91FbhfOw/qP0tjNc
	SDa3/ZTQqiRNngnsdLWSLhSBhJeKvsulzsXiopA==
X-Gm-Gg: ASbGncsXBYkczmUf9ZjfflxmaT7s+F6bjskqu+mkNQx91JZGpM9244MNVgmD8VDkWd1
	v4eOgFTmDWQI+1eOZLCGTR6UuGCK6cb3K3uCgpfe7g78MShvzCPjr3KCSfFuBPL5cDEytMOxHL7
	bBgVnTXbcNUoYfu5FCqmjYrw==
X-Google-Smtp-Source: AGHT+IH7qkeYbRWXoNzxPx5GoPmtIbKXEg/tSSxhc4CpBxE91KJCYJ/EjkGBTx7uTf2xtmTxra00neSYIJOoNJm9Omk=
X-Received: by 2002:aa7:cd02:0:b0:5fa:7a36:f9db with SMTP id
 4fb4d7f45d1cf-5fa7a36fbb2mr1376494a12.1.1746290877206; Sat, 03 May 2025
 09:47:57 -0700 (PDT)
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
 <CADqNVTr=172CGUwUGUzDHtONV5YWw2hirKXzebmb0rp2YdDTLQ@mail.gmail.com>
In-Reply-To: <CADqNVTr=172CGUwUGUzDHtONV5YWw2hirKXzebmb0rp2YdDTLQ@mail.gmail.com>
From: Nick Neumann <nick@pcpartpicker.com>
Date: Sat, 3 May 2025 11:47:45 -0500
X-Gm-Features: ATxdqUHsmPNUrUdcDtI0ScGuu3B-7HF23kjn7LnzCDP2S9HONEs-cKCz9L5Jj0I
Message-ID: <CADqNVTqeGBY6+XrXz9-PaCov-Ds8Nh79_JQY+tK4SPtrxmqDAg@mail.gmail.com>
Subject: Re: Performance variation in traditional HDDs?
To: Damien Le Moal <dlemoal@kernel.org>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In the end, my goal is to understand enough about how HDDs work and
perform to know what we can reasonably expect to accomplish/learn with
using fio to benchmark them, and how to appropriately do the
benchmarking.

This last CMR drive has additional interesting performance
characteristics besides the differences between two of the same drive.
Zooming in on the beginning of a full drive write is surprising:

https://cdna.pcpartpicker.com/static/forever/images/content/c4c6d8413eef6ef=
fa17b2220b9414b6d.png

There is a very periodic behavior to bandwidth, with a period on the
order of a few minutes. The period of Drive 1 is actually a bit
shorter than that of drive 2. Drive 2, the slower drive, is faster
than drive 1 for the first 30+ seconds of writing because drive 2
starts at the high point of its periodic oscillation, while drive 1
starts at the low point. For both drives, the difference between high
and low bandwidth over a span of a few minutes is surprisingly large
(initially >25MB/s for drive 1 and > 50MB/s for drive 2), and this
difference gradually decreases over time.

On Fri, May 2, 2025 at 2:33=E2=80=AFPM Nick Neumann <nick@pcpartpicker.com>=
 wrote:
>
> Here's another CMR drive (https://pcpartpicker.com/product/6FQcCJ).
> Here, two identical drives with same model number and firmware show
> about a 10% difference in performance.
>
> Looking at the average full drive write speed we saw the following
> results in MB/s:
>
> Drive 1: 153.86, 153.86, 153.86
> Drive 2: 140.63, 140.64, 140.65
>
> Again, each individual drive is incredibly consistent in its
> performance. But drive 1 is over 9% faster than drive 2. And the
> graphs of bandwidth over time for a full write are markedly different:
>
> https://cdna.pcpartpicker.com/static/forever/images/content/684ce1fea2858=
681575fb7666b8b987f.png
>
> Reporting benchmarked performance for HDDs is problematic when there
> is variation like this between two of the same drive.
>
> On Sun, Apr 27, 2025 at 12:23=E2=80=AFPM Nick Neumann <nick@pcpartpicker.=
com> wrote:
> >
> > On Wed, Apr 23, 2025 at 10:00=E2=80=AFPM Damien Le Moal <dlemoal@kernel=
.org> wrote:
> > > So these are drive-managed SMR disks, right ?
> >
> > Yes. I chose these first because they show the largest performance
> > difference between two "identical" drives. We do an ATA SECURITY ERASE
> > to reset their state/LBA mapping - it takes longer than a full drive
> > write.
> >
> > Here is another set of identical drives
> > (https://pcpartpicker.com/product/XtjG3C) that just completed and also
> > show a significant performance difference. These are CMR drives with
> > the same model number and firmware.
> >
> > We did three full drive writes on each drive, using the same proper
> > horizontal mounting and position.
> >
> > Looking at the average full drive write speed we saw the following
> > results in MB/s:
> >
> > Drive 1: 162.72, 162.73, 162.73
> > Drive 2: 155.69, 155.70, 155.72
> >
> > Each individual drive is incredibly consistent in its performance. But
> > drive 1 is over 4% faster than drive 2.
> >
> > The difference can be seen in a graph comparing one full write run of e=
ach:
> > https://cdna.pcpartpicker.com/static/forever/images/content/221396115ee=
6bae8fbd35135fbc6441e.png
