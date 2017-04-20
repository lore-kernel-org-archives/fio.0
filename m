Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:34268 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947885AbdDTWMx (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Apr 2017 18:12:53 -0400
Received: by mail-ua0-f179.google.com with SMTP id h2so66830571uaa.1
        for <fio@vger.kernel.org>; Thu, 20 Apr 2017 15:12:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <625e4fdeac5a68286ce7277718a50be5@pl.sii.eu>
References: <625e4fdeac5a68286ce7277718a50be5@pl.sii.eu>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 20 Apr 2017 23:12:22 +0100
Message-ID: <CALjAwxgLHBn6jPfGf3aW1CcX1Py47BCR0vEJ8ByNdZ2i+tY3-g@mail.gmail.com>
Subject: Re: FIO mmap options dictate a minimum block size of 4096 bytes
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: kjaszczerski <kjaszczerski@pl.sii.eu>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 20 April 2017 at 15:03, kjaszczerski <kjaszczerski@pl.sii.eu> wrote:
>
> I'm trying to run FIO on mmap engine on 4k socket and 4k channel. I'd like
> to use wrokload with blocksize parameter value less than 4k, is it possible
> ?

You didn't give an example jobfile, fio version, operating system
(which are really necessary to answer these types of questions) so the
following is going to be a lot of speculation.

I don't know if you also filed https://github.com/axboe/fio/issues/339
but there's a partial answer there (using direct=1 forces alignment
and size constraints). There's a follow up point which is the message
stems from a desire to catch msync related errors earlier:
https://github.com/axboe/fio/commit/913ea0db12596b735a030a1836bd913497b7120a
. I suppose a filesystem will never have a blocksize smaller than a
page and alignment constraints mean an msync must always start page
aligned (http://man7.org/linux/man-pages/man2/msync.2.html ) so if you
have any type of fsync taking place that will trigger that check.

-- 
Sitsofe | http://sucs.org/~sits/
