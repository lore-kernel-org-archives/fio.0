Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FCF16D9C2
	for <fio@vger.kernel.org>; Mon,  5 May 2025 21:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746480837; cv=none; b=R+Gt/R35yoBgujmggjuWVFXy8mYzJ1vJn8zYZiPIEE3Jbi4WA7fDJIXA36lvNuCju+Q2/BXFQZdalEg0dVnvmU2ASIrljLEEjnDOp5WNPyWEZNU5m3etzJVR8WSIgiNFFtQGcLgMuATDUeciZhtqO6xI1VICaIkIVSyzkkaR5N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746480837; c=relaxed/simple;
	bh=5yRoQRJNDJ99fukveWtxh80ROqFYGQXXcvoQ/LWVpcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T/i3HYokpI+JIyYymaUPvQHGWGIZaLwjCJnkCtFgEDx9nfmvoiQj62MvByfC6kfp8WpxyjrnBbvnXaJ5stevXUfIxQC4VQxjp+ibE/nNsiltffs1A4I72RPiVxUVCTVyKW4JBKM/+faKAqT8mAg/1xoYNAE823MOQSZ65zmoICY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vwr9Myw4; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vwr9Myw4"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ff799d99dcso5037067a91.1
        for <fio@vger.kernel.org>; Mon, 05 May 2025 14:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746480835; x=1747085635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqPyCayqDHcXnwge1gK/tM4V8mgR+H69uw4u5kAA5WU=;
        b=Vwr9Myw4NRMuJodYgvcGKE7CmrTUkmUXGQGoRfEriiiu3+wej5g6VirXgjmBiW57s2
         p0cxmckRAY8wTSbuxUz8cEco+kqCu2Utxy5NYisCkVEC1r+MhYrOrx9UGsJQ9Fw9yDu1
         04ZTzIGEbmoWDznoWG/NmtPBwz2yJBNBJeLsa7mHGB7NMmvO6mP3gR+NKO/BzxTC4oYF
         n2umj3gM5383aqEEuwf/oioNJQam4yRNZV974c0bOun2Pjno4atPuRK2b1aUYA11dt0C
         WdwvpJdKEOuL81ROD3f18rA/vM4mUUejP2cJ5UTDdDqfm6b/uhlUNAfZPN7JpHR3N4bW
         5STA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746480835; x=1747085635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pqPyCayqDHcXnwge1gK/tM4V8mgR+H69uw4u5kAA5WU=;
        b=WjIpprl7xGL9YsiBbaaSax/H8KnHjbfriWI2ylniJa0dyEKO1CSf3tz4/b12rCVl5s
         RWcG4jzNOchUqy73jyXk8u9Mk0ojFys5bF/LBtmCJPEQVqg77z6vWf0rdBypeQsmGqkX
         hWtAOgnLhdooxoUydUkALCijDVVFjwbrSraZXzPunY5uLVqGVbu+XU3aGvENzPX5ARLk
         f2Bg610IcMNkbll7TWusBY92talMKy8sFjGA6ub+n5l6VLMEv67adFM8rS2ClfazigHe
         /e9RNb1vo9Sghg36rw1gf9JAZ5LYTEsXBdpej44velXhdOY00YWXL0kEz/UY0rOIMVSv
         SnOw==
X-Gm-Message-State: AOJu0YwYqNBADh+nUjX+8CHJXTy5ebb/ZE4gu2B+iNmwkYf41QCV49pa
	bSg2wQCnP0kIc2zDxbe21puY+LQnn50FpYKKWh4at8dd8SdRnVfXjlBxoDnpRVK9ij95Vv5EGnY
	skpV/ILx1eGVIAB5+NXqNSTgES1M=
X-Gm-Gg: ASbGncvbdpu5Scjqc/C/acn3IMl5NJVHhYSogTc6iIlqiaGgob3RjOEDVcJ/+QDtjb5
	5OmFK0WEDqzclZjdnjMDLMqeIFdmoxc9LczodD7syuTj0OsmQpdesxENCYSr0E6ObkZhWx6/0ec
	I3NiXYoqVxnt9FcqVpXhVJN1KHjjTG1TnhQnqpji5HW9zYVh2rNPwjNw==
X-Google-Smtp-Source: AGHT+IEWOz3BWGHisp0b3fKL3kfjlycdEcQWcj2fccHEg5gaLeiDKCGgIfW+Ms1/+C2Dfz3jADieiPLPSr52fE09Mf4=
X-Received: by 2002:a17:90b:58ce:b0:2ee:53b3:3f1c with SMTP id
 98e67ed59e1d1-30a6196e684mr12189062a91.5.1746480835240; Mon, 05 May 2025
 14:33:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8C4338A1-1AA8-4D3B-B862-DC07F5DB5757@gmx.de> <CALjAwxiN9VDP94L6YQs8c4bzGngPH3jm7H+ThTKOXxaq4-C2Cw@mail.gmail.com>
 <46404378-9707-4EB0-9832-1BB2E37C1F51@gmx.de>
In-Reply-To: <46404378-9707-4EB0-9832-1BB2E37C1F51@gmx.de>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 5 May 2025 22:33:28 +0100
X-Gm-Features: ATxdqUHfKPZfvfZaQ36iOv5gIKVCnAs4BjykOWjgsiFzY9yRNijbkoluUB5Zk6A
Message-ID: <CALjAwxgRZv8mO0yTNxyZ_io6=eLSLdWbdoDsqs7HyKqzZcX+mg@mail.gmail.com>
Subject: Re: Aggregated results too high when using multiple servers via
 "client" command
To: =?UTF-8?Q?Ren=C3=A9_Weber?= <web_rene@gmx.de>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 5 May 2025 at 11:56, Ren=C3=A9 Weber <web_rene@gmx.de> wrote:
>
> You are absolutely right. Lots of details missing indeed=E2=80=A6
>
> fio-3.36 on Ubuntu 24.04.2 LTS
>
> Command:
> fio --client=3Dconfigs/host.list fio-configs/test.job --output=3Dtest.out=
put --output-format=3Djson
>
> cat test.job:
> [global]
> filename=3D/mnt/benchmark/testfile.dat
> group_reporting
> write_bw_log=3Daggregated
>
> [Full Write]
> size=3D25G
> bs=3D512K
> rw=3Dwrite
> ioengine=3Dlibaio
> direct=3D1
> time_based
> runtime=3D60s
>
> cat host.list
> 10.100.12.51
> 10.100.12.52
> 10.100.12.53
> 10.100.12.54
>
> My target is a NAS device mounted via CIFS/SMB under /mnt/benchmark/
> I played around with write_bw_log=3Daggregated and group_reporting, but i=
n the end the summarized Bandwidth  is always higher than my target device =
overall performance.

Is there any difference in performance numbers if you add end_fsync=3D1
to the job file?

--=20
Sitsofe
