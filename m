Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:35527 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754257AbdGCSdL (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Jul 2017 14:33:11 -0400
Received: by mail-vk0-f41.google.com with SMTP id 191so99638171vko.2
        for <fio@vger.kernel.org>; Mon, 03 Jul 2017 11:33:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFOWsvuubBs4YOb9BKmpZPRwHo1cV+HGscGWv3TGqKFLis=-Aw@mail.gmail.com>
References: <CAFOWsvt5joru9mNN3VM65spn77VQDvCQp-OPwAXrtfi4SSbEJA@mail.gmail.com>
 <CAFOWsvuubBs4YOb9BKmpZPRwHo1cV+HGscGWv3TGqKFLis=-Aw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 3 Jul 2017 19:32:40 +0100
Message-ID: <CALjAwxhtY12di5pACk=AAJ1_aM=Coryf6OuemsKiHda8nd=ttQ@mail.gmail.com>
Subject: Re: Inverted test in fio ipo_bytes_align()
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Keith Owens <kaos.ocs@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 3 July 2017 at 08:08, Keith Owens <kaos.ocs@gmail.com> wrote:
> Ignore that, fixed in February - Debian/Ubuntu have not picked up the fix.
>
> On 3 July 2017 at 16:39, Keith Owens <kaos.ocs@gmail.com> wrote:
>> ipo_bytes_align() does nothing when replay_align is set, when
>> replay_align is 0 it incorrectly masks all replay offsets to 0. The
>> test is inverted.

Sorry that mistake was my doing. It was found and fixed over in
https://github.com/axboe/fio/pull/302 (commit
https://github.com/axboe/fio/commit/3dd2e8aa0519225da5ccc100aa02e55306bcc2f3
which went into fio-2.18).

-- 
Sitsofe | http://sucs.org/~sits/
