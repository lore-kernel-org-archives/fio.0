Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:39445 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729370AbfD2VfG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 29 Apr 2019 17:35:06 -0400
Received: by mail-wm1-f42.google.com with SMTP id n25so1150372wmk.4
        for <fio@vger.kernel.org>; Mon, 29 Apr 2019 14:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <E4692EE0-7DAF-4EFF-9291-5E1ACD93249C@suse.com>
In-Reply-To: <E4692EE0-7DAF-4EFF-9291-5E1ACD93249C@suse.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 29 Apr 2019 22:34:37 +0100
Message-ID: <CALjAwxh_0LOfM4-MT7sftUt+1dOhJpftZALBj6KKFFMmm9S5Tw@mail.gmail.com>
Subject: Re: block size definition
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Byte <dbyte@suse.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On Mon, 29 Apr 2019 at 22:24, David Byte <dbyte@suse.com> wrote:
>
> When defining block sizes for I/O, are they truly in MB (base-10)or MiB(b=
inary)?
>
> Given the notation of MB, I am assuming base-10?=EF=BB=BF

It's selectable but non-intuitive and defaults to powers of two with
the "wrong" named units. See the "int" section under parameter types
of the manual (https://fio.readthedocs.io/en/latest/fio_doc.html#parameter-=
types
).

--=20
Sitsofe | http://sucs.org/~sits/

