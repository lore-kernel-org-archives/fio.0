Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8DBE574
	for <fio@vger.kernel.org>; Wed, 16 Oct 2024 00:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729038952; cv=none; b=KFGI3Gbqn5yZMgqn8gS4PIOgFuypFMzyiLl78OnVnAqjUHJKGNWLmnw/sYpgK1W8QYA0u0my5sq/FC9KUkqLdaCFgPgMxNVmNRvNgS7vGbBNgW85CEZjKdJdJ2zT72BFrAtpm3WGYqg7RZfIiLz/An76I9p282FUSzBFHYe6/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729038952; c=relaxed/simple;
	bh=eDlfqX4xLOzSfDpUrknUIt6cEZbNrGwpel89MZB4agI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Xvf9iDqJ4k6DNx4CdLqGtYxUnJt53leX47MeDZd0e6IgTKiy1Gfb0AKfF4X1nv4ceBURU0F23onV0iW+1qhh98mNJI4th/7mftmStGJ7jTUGSh6zJQyLEjXGRqZPu2pHCFUpvVsstminjeCWEIBn930najdk3jnXYQYrWnSRi6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ashtech.one; spf=pass smtp.mailfrom=ashtech.one; dkim=pass (1024-bit key) header.d=ashtech.one header.i=@ashtech.one header.b=dmDjPHYS; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ashtech.one
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ashtech.one
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ashtech.one header.i=@ashtech.one header.b="dmDjPHYS"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2fb5638dd57so23962511fa.0
        for <fio@vger.kernel.org>; Tue, 15 Oct 2024 17:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ashtech.one; s=google; t=1729038949; x=1729643749; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eDlfqX4xLOzSfDpUrknUIt6cEZbNrGwpel89MZB4agI=;
        b=dmDjPHYSl25RCy6ISJ4Y5nNRrGUqEXfeIfGp9E3AVaAXF+8MT7gsBouzwFMpYW7GkG
         +QubTTt3SxyFjCYTrJUb2Hr0z2T0CzHtQBYxKkA12eH/GrEeubz9iZXsxnYLLMCxBHh8
         mX7PXZzciaBL7+ML4+Hq9BlREIFHHHcu9NhPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729038949; x=1729643749;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eDlfqX4xLOzSfDpUrknUIt6cEZbNrGwpel89MZB4agI=;
        b=W1Qh8gB0ED77OJ9t5AsLQ0T14H3pr34hT5jGSYefgjN9mzLHV6vkBiQckK6zCpU4ky
         ik9XIlRAKm2//TRI5tb7mNV1IMAxmh6B9/GCuN8gYXY2UX+CyheYvttDUu6IRpY9lCmi
         9Bez1o9JaiElaIsxGzIVZpazBGTC+W7Uq04ZXhv/R2Wgb6ydsbga5HL0klbT9BKsqysh
         auOATrUtH63JSYCqX7EVFzGiYSDF5Y0MROtPpHqd6gTeyxPIpeWR6sD4iANC9KdTLxyr
         dCTLC+gEuwTQI3Ru4ZutOW6R7r5CPf7sgO1cPI75ICW+lmWJXYMj32jE1NviY5DzZ6SR
         9P1Q==
X-Gm-Message-State: AOJu0YxVwf+xQzNIi6azCVaX8FYLOdr5+DApjLWQfvMSkuKiM4rXzXEu
	RAmL4WXz4XGtZJpF2N3F0fLS5L11fxgAy8CRKhKogjSIu57fAa7PhMRtI/WHXtq0AxIuJZthZLA
	+t5F7+wPzxrMHTp0DAPbx4k3gK/fqf4FUpzvc+YXgwwZD7raDRaw=
X-Google-Smtp-Source: AGHT+IGcLM8R8Iz3EZymasgtiaQpdAFVRDZ7EYhzMLHYO4L3+TpNOKExamt5whj8s0PQMkEFw/r+AoPTY6h23Nk9+Os=
X-Received: by 2002:a05:651c:1502:b0:2fb:5ac6:90ef with SMTP id
 38308e7fff4ca-2fb61b45d02mr15683241fa.11.1729038948620; Tue, 15 Oct 2024
 17:35:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sean Ashton <sean@ashtech.one>
Date: Wed, 16 Oct 2024 11:35:37 +1100
Message-ID: <CAPLT-aaWhG8u3F_qr9pNCOAQb0XRMW=VgVJKkkwONL6U-4ga6A@mail.gmail.com>
Subject: Documentation Examples for kb_base are incorrect.
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have come across this issue with the description of how kb_base works.

In the documentation it says:
For quantities of data, an optional unit of =E2=80=98B=E2=80=99 may be incl=
uded (e.g.,
=E2=80=98kB=E2=80=99 is the same as =E2=80=98k=E2=80=99).
Whereas Ki and KiB are treated differently, which contradicts the documenta=
tion.

The description of the units has K,M,G,T,P and Ki,Mi,Gi,Ti,Pi whereas
the units that fio uses in __get_mult_bytes in parse.c:217 are
K,M,G,T,P (optional B) and KiB,MiB,GiB,TiB,PiB (mandatory B) and Ki
will be treated as K, Mi as M, etc. per this test file:

[job1]
bs=3D1M
[job2]
bs=3D1MB
[job3]
bs=3D1Mi
[job4]
bs=3D1MiB
returns:

job1: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T=
)
1024KiB-1024KiB, ioengine=3Dposixaio, iodepth=3D1
job2: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T=
)
1024KiB-1024KiB, ioengine=3Dposixaio, iodepth=3D1
job3: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T=
)
1024KiB-1024KiB, ioengine=3Dposixaio, iodepth=3D1
job4: (g=3D0): rw=3Dread, bs=3D(R) 977KiB-977KiB, (W) 977KiB-977KiB, (T)
977KiB-977KiB, ioengine=3Dposixaio, iodepth=3D1

And with kb_base=3D1000:
job1: (g=3D0): rw=3Dread, bs=3D(R) 1000kB-1000kB, (W) 1000kB-1000kB, (T)
1000kB-1000kB, ioengine=3Dposixaio, iodepth=3D1
job2: (g=3D0): rw=3Dread, bs=3D(R) 1000kB-1000kB, (W) 1000kB-1000kB, (T)
1000kB-1000kB, ioengine=3Dposixaio, iodepth=3D1
job3: (g=3D0): rw=3Dread, bs=3D(R) 1000kB-1000kB, (W) 1000kB-1000kB, (T)
1000kB-1000kB, ioengine=3Dposixaio, iodepth=3D1
job4: (g=3D0): rw=3Dread, bs=3D(R) 1049kB-1049kB, (W) 1049kB-1049kB, (T)
1049kB-1049kB, ioengine=3Dposixaio, iodepth=3D1

Also the documentation examples are identical for both values with
some errors in raw numbers (TB):
Examples with kb_base=3D1000:
4 KiB: 4096, 4096b, 4096B, 4ki, 4kib, 4kiB, 4Ki, 4KiB
1 MiB: 1048576, 1mi, 1024ki
1 MB: 1000000, 1m, 1000k
1 TiB: 1099511627776, 1ti, 1024gi, 1048576mi
1 TB: 1000000000, 1t, 1000m, 1000000k

Examples with kb_base=3D1024 (default):
4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
1 MiB: 1048576, 1m, 1024k
1 MB: 1000000, 1mi, 1000ki
1 TiB: 1099511627776, 1t, 1024g, 1048576m
1 TB: 1000000000, 1ti, 1000mi, 1000000ki

Which should read (as it currently works in code):
Examples with kb_base=3D1000:
4 KiB: 4096, 4096b, 4096B, 4kib, 4kiB, 4KiB
1 MiB: 1048576, 1mib, 1024kib
1 MB: 1000000, 1m, 1000k, 1mi, 1mb, 1000ki
1 TiB: 1099511627776, 1tib, 1024gib, 1048576miB
1 TB: 1000000000000, 1t, 1000g, 1000000m

Examples with kb_base=3D1024 (default):
4 KiB: 4000, 4000b, 4000B
1 MiB: 1000000, 1000kib
1 MB: 1048576, 1mi, 1024ki, 1m
1 TiB: 1000000000000, 1000gib, 1000000mib
1 TB: 1099511627776, 1ti, 1048576Mi, 1024g

I can see the Ki vs KiB already has an issue here:
https://github.com/axboe/fio/issues/1618
With that fixed only the examples in the documentation would need to be upd=
ated.

--=20
Regards,

Sean
