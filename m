Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43262 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729949AbfIPGmt (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Sep 2019 02:42:49 -0400
Received: by mail-wr1-f51.google.com with SMTP id q17so32853597wrx.10
        for <fio@vger.kernel.org>; Sun, 15 Sep 2019 23:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <f5e8d9f9-445c-ff9a-5e34-48fcbd81454d@unix-beratung.de>
In-Reply-To: <f5e8d9f9-445c-ff9a-5e34-48fcbd81454d@unix-beratung.de>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 16 Sep 2019 07:42:27 +0100
Message-ID: <CALjAwxhiftJSJFA1=vsOuNoOve7LX87SxeqgipEB9syvjvrSjA@mail.gmail.com>
Subject: Re: porting fio to other OSes
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Robert Urban <urban@unix-beratung.de>
Cc: fio <fio@vger.kernel.org>, Udit agarwal <dev.madaari@gmail.com>

Hi,

On Mon, 16 Sep 2019 at 03:32, Robert Urban <urban@unix-beratung.de> wrote:
>
> Hello,
>
> I would like to port fio to Tru64 UNIX. Looking at the various os/os-*.h files
> it seems some compatibility functions must be implemented for the target OS.
> "blockdev_size()" is one example.
>
> Besides the very general comments in the "Platforms" section of the "README"
> file, are there more detailed guidelines for porting fio to an OS? For example,
> a list of the compatibility functions that must be implemented?

I don't think there's a detailed guide but it's not too hard to do and
there are few examples floating around. I did a hacky port to Minix a
while back (https://github.com/sitsofe/fio/commit/0b0d40b5579784a12ce80042bc0e844edd9d96af
) where I basically only implemented the bare necessities and return
unsupported for everything else. Someone else also did a port to RTEMS
too (https://github.com/madaari/fio/tree/paper ) but unfortunately it
was never merged back.

--
Sitsofe | http://sucs.org/~sits/

