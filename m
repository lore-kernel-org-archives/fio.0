Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:37657 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729704AbeGQTuF (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Jul 2018 15:50:05 -0400
Received: by mail-ua0-f173.google.com with SMTP id y10-v6so1391292uao.4
        for <fio@vger.kernel.org>; Tue, 17 Jul 2018 12:16:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3e2d2b0388c994116ee7c8785fa96e8855d7b679.camel@suse.com>
References: <3e2d2b0388c994116ee7c8785fa96e8855d7b679.camel@suse.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 17 Jul 2018 20:15:32 +0100
Message-ID: <CALjAwxgHzS6KdZhaT2UE=b2UaNcKOuCHEaZnK2SzfU9PimbCCg@mail.gmail.com>
Subject: Re: fio, vsync and iovcnt
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: fio <fio@vger.kernel.org>

On 17 July 2018 at 17:34, Martin Wilck <mwilck@suse.com> wrote:
> I hope this question isn't too stupid - how do I make fio use iovcnt >
> 1 with readv() / writev() ? No matter what I tried so far, it seems to
> be using a single iovec entry only.

Do the iodepth_batch_* options over on
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-terse-version
help?

-- 
Sitsofe | http://sucs.org/~sits/
