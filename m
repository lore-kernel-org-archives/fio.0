Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4142D231CA3
	for <fio@vger.kernel.org>; Sat,  5 Oct 2024 09:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728120343; cv=none; b=NS38htzUxqvvELZMX/mBtJweXadnf5cDWvUIQvmc1TpH1aPJ/58CqftvhlFWV3Xun/1Hz+Kcxi1d3wunEOwjt9qWuFm4tR56dQEiEsv3dbpadVUZeWNHCL0/YlZoWy0oiFSI96RvOzW/mNLkevYpi4aRcFf4OPnj8x9605M/7K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728120343; c=relaxed/simple;
	bh=bc1EL6qXu200nsa110oP5zMxANYwM/6GN1zrj0t6wpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qZf4LnueAfEJ5McWRJq9dod+WABGrpbHUZRjAn5F9Y89WiwSQi9TyEpNLOaLsxmSmaWJVIPitOTRQzqHykDoO7HOEAloiZ+TnOCoAciqjnVHJ4Z88MtoduF89pgbI53cvzPIZ9gveEzv0JWhdsCUKxdMegK6gAUC7/18Ev5rAvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MsE5Vm0Z; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MsE5Vm0Z"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20b7a4336easo21455795ad.3
        for <fio@vger.kernel.org>; Sat, 05 Oct 2024 02:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728120341; x=1728725141; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bc1EL6qXu200nsa110oP5zMxANYwM/6GN1zrj0t6wpI=;
        b=MsE5Vm0Zzhhdrh/zf7/q2qUqt6YXzMi6eZRTzWFkflXas1nJvXKbWh9+6Ei7750o6S
         m/VE+cMs5nw2Cvr3D6rBxZiIVa2y+ZDmq+KwjkF5RPmwHjygwSEVjMd0P1JRO3/0R7nN
         TaER7V0OaB7rJ6uldfoDkSVstDvbVQZw+Ll/nURuVfDe0o2igXRaM3vF+bpp4d7wC+0n
         YizCmva99eo7R+5EmL9YOu5Au0cqOCKXpl2arjEJUE/DoyNoGQbhBgleYgLHjPVGdjeG
         h92caxx7ZKklVTD0m4lfr4nXsaNZKaOxM9T6FL0/J0waY/F1VaD6kCC7B3x0Q0ksJULT
         23hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728120341; x=1728725141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bc1EL6qXu200nsa110oP5zMxANYwM/6GN1zrj0t6wpI=;
        b=vLQUQfLUkRo2KhwfdrceC0VPlE++Hd9FBLjMfEW8tK8SV6+imGOXkL7I9W/ZmzLxQk
         2qh14kad0sa7UaLppylPegEdf6p7lQrSYoSZyDY+3fW8PmIreWQyQBYEKsKCWY+zE7+O
         pfS76oRQ+FeYYy+aqdGicIyUxuLJrARzNYBDsaDqUx9w/mqqioi+hudzEeK85RnVGmKv
         HbLs1KxOkPYf20PDwp2y0Hnc2Rn1D2Rr/FBlf8/Z6mKzMXMe6Yp/73603nNRr8YdWNk9
         wri7rrEzwFZN1RKfjyeJ9ViY7Lfjt784KXKQnJotDdKWq2gdLhs2yeaYf1u7kVNc7Qib
         FIwA==
X-Gm-Message-State: AOJu0Yw5ft2v/Zv35sLcpWwiP6pfnF1OEMYaFjLqUSnTMdIUBWNDddRC
	Tg0LBw6+TgcSOUsu/4sp699yrsmev0Q/9nPH/9YcayNLO5HldAVroI5r3f2tV5R1lv+rD1C8dlh
	3mi0IgRXiRfCbxijk0t/btoZVk7S7owpU
X-Google-Smtp-Source: AGHT+IH6Zf5TfEHfoc4R4bT9EwqKljMGYcLKY/5lV9bgE7TqB/NbZJM4Lqs5M8YCKpB1rQ0zZ7RiIR7CuZgpWTotVXQ=
X-Received: by 2002:a17:90a:120f:b0:2e0:9d79:4a02 with SMTP id
 98e67ed59e1d1-2e1e626c0b6mr6492099a91.20.1728120341368; Sat, 05 Oct 2024
 02:25:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1727778878-30167-mlmmj-071cdab3@vger.kernel.org>
 <CA+VE31bGvC02vyL_drrEtsRn8t9tURTK9F9H9F+jS0vUw7QStg@mail.gmail.com> <e8f87ac8-4a2c-488c-ad35-cbaa7428d197@gmail.com>
In-Reply-To: <e8f87ac8-4a2c-488c-ad35-cbaa7428d197@gmail.com>
From: Prasad Boddupalli <p.boddupalli@gmail.com>
Date: Sat, 5 Oct 2024 14:55:05 +0530
Message-ID: <CA+VE31adiOwG7mfeu=SoEsKf0WNu_ofTLSPwz+KSK0YvobnwVw@mail.gmail.com>
Subject: Re: Verification errors when write phase is aborted midway
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 5, 2024 at 12:37=E2=80=AFAM Vincent Fu <vincentfu@gmail.com> wr=
ote:
>
> On 10/1/24 06:36, Prasad Boddupalli wrote:
> > Hello All,
> >
> > I am running fio verification in two phases:
> >
> > (1) Write phase, with do_verify=3D0, on the block device /dev/sdb using
> > --direct=3D1 flag. While the write phase is running, the disk is
> > disconnected physically. Since data got written to the block device,
> > the journal (state file) was created. After the disk was disconnected,
> > errors were in-flight writes were reported as follows:
> >
> > fio: io_u error on file /dev/sdb: Input/output error: write
> > offset=3D2112716800, buflen=3D8192
> > fio: io_u error on file /dev/sdb: Input/output error: write
> > offset=3D2112724992, buflen=3D8192
> > fio: io_u error on file /dev/sdb: Input/output error: write
> > offset=3D2112733184, buflen=3D8192
> > fio: io_u error on file /dev/sdb: Input/output error: write
> > offset=3D2112741376, buflen=3D8192
> >
> > (2) When I run the verification phase, the verification fails with the
> > following errors:
> >
> > verify: bad magic header 0, wanted acca at file /dev/sdb offset
> > 2112716800, length 8192 (requested block: offset=3D2112716800,
> > length=3D8192)
> > verify: bad magic header 0, wanted acca at file /dev/sdb offset
> > 2112724992, length 8192 (requested block: offset=3D2112724992,
> > length=3D8192)
> > verify: bad magic header 0, wanted acca at file /dev/sdb offset
> > 2112733184, length 8192 (requested block: offset=3D2112733184,
> > length=3D8192)
> >
> > The offsets reported in the errors in the verification phase
> > correspond more or less to the errors reported in the write phase.
> >
> > I am assuming that information in the state file will correspond to
> > successful writes, writes that were persisted on the disk and
> > acknowledged. If so, why was the verification done for data at offsets
> > whose writes failed in-flight ?
> >
> > Following are the options to write and verification phase:
> >
> > write:
> >
> > ' --rw=3Dwrite'
> > ' --bs=3D8K'
> > ' --direct=3D1'
> > ' --ioengine=3Dlibaio'
> > ' --iodepth=3D16'
> > ' --verify=3Dcrc32c'
> > ' --filename=3D{device_name}'
> > ' --size=3D{disk_size}G'
> > ' --offset=3D{write_offset}'
> > ' --runtime=3D20m'
> > ' --time_based=3D1'
> > ' --do_verify=3D0'
> >
> > verify:
> > ' --rw=3Dread'
> > ' --bs=3D8K'
> > ' --direct=3D1'
> > ' --ioengine=3Dlibaio'
> > ' --iodepth=3D16'
> > ' --verify=3Dcrc32c'
> > ' --filename=3D{device_name}'
> > ' --size=3D{disk_size}G'
> > ' --offset=3D{write_offset}'
> > ' --verify_only=3D1'
> > ' --verify_state_load=3D1'
> > ' --verify_dump=3D1'
> >
>
> When you build fio from source there is a t/fio-verify-state utility to
> display the contents of the verify state file. Are you able to run it to
> display the contents of your verify state file?
>
> Are you running on a big ending platform? This feature was broken on
> such platforms until recently.
>
> https://github.com/vincentkfu/fio-blog/wiki/Testing-on-a-big-endian-platf=
orm

Hello Vincent, thank you for your reply. I was able to run the
`fio-verify-state` tool against the state file recorded by FIO. I see
verification errors (wherein failed writes are also being verified)
only with libaio engine. When I try the same with 'psync' ioengine, I
do not see the same errors (although the throughput is greatly reduced
with 'psync' engine).
