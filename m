Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:36444 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbdB0HKG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Feb 2017 02:10:06 -0500
Received: by mail-ua0-f195.google.com with SMTP id j56so6425641uaa.3
        for <fio@vger.kernel.org>; Sun, 26 Feb 2017 23:10:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgJxhLQKBMDCG4Qjcc5W2iDwZ6Uofoyzhz6b2ZxX09bjw@mail.gmail.com>
References: <20170224163523.6608-1-tkusumi@tuxera.com> <CALjAwxgJxhLQKBMDCG4Qjcc5W2iDwZ6Uofoyzhz6b2ZxX09bjw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 27 Feb 2017 07:09:35 +0000
Message-ID: <CALjAwxjKpMPLcfbdysq7eZyGY5YYfJtatqMZ8t3MmtHDSgW0LQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add runtime handlers for 97900ebf for BSDs
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tomohiro Kusumi <tkusumi@tuxera.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 24 February 2017 at 17:23, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> I'm going to guess that NetBSD doesn't behave this way based on the
> result reported by
> https://lists.cairographics.org/archives/cairo/2012-October/023652.html
> . Additionally in
> https://lists.cairographics.org/archives/cairo/2012-October/023652.html
> you can see the configure test cairo uses to determine how the
> platform behaves with regard to attaching to removed segments. FWIW

Oops, that second link should have been
https://lists.cairographics.org/archives/cairo/2012-October/023650.html
("[cairo] [PATCH] xlib/shm: Sync the XShmAttach before removing the
ShmSegment id").

-- 
Sitsofe | http://sucs.org/~sits/
