Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:34955 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdGRGMn (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2017 02:12:43 -0400
Received: by mail-ua0-f178.google.com with SMTP id 64so11947138uae.2
        for <fio@vger.kernel.org>; Mon, 17 Jul 2017 23:12:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D2DBB427-CB0C-4959-9266-9940D2254A51@bluestop.org>
References: <68e2387b-4010-aadf-4df8-1f7f434b6258@bluestop.org>
 <CALjAwxik+EZL1WrB01ye_OaiELE44HmCm2NTC_hKX2v2rxvHmw@mail.gmail.com> <D2DBB427-CB0C-4959-9266-9940D2254A51@bluestop.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 18 Jul 2017 07:12:12 +0100
Message-ID: <CALjAwxjvXhsvzoCcQK0RzWYM67YMYoEM+zwkmdQR8kkjMgp-wg@mail.gmail.com>
Subject: Re: pmemblk ioengine broken (pmemblk_bsize unknown)
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 18 July 2017 at 07:10, Rebecca Cran <rebecca@bluestop.org> wrote:
>
> Sent from my iPhone
>> On Jul 18, 2017, at 12:03 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>> Looks like pmemblk_bsize didn't show up until
>> https://github.com/pmem/nvml/commit/463aa6bbae83942ca7819c3eb1a698f3dfcafd59#diff-753ccabb0b5b2cc0453fb0bb1ef10bf8
>> which github says only went into 0.2+b3 and then subsequently
>> 0.3...
>
> Ah, thanks. I hadn't realized how outdated some packages in OpenSUSE Leap 42.2 are.

The API reported by libpmemblk.h seems perpetually stuck at 1.0 so
perhaps everything pre-1.0 was considered unreleased? At any rate, it
might be good to change the configure script to check / use
pmemblk_bsize (e.g. volatile pmemblk_bsize bsize + a comment saying
0.3+) so that "old" versions are quietly rejected...

-- 
Sitsofe | http://sucs.org/~sits/
