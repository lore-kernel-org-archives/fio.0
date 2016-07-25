Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:32929 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbcGYRN7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 25 Jul 2016 13:13:59 -0400
Received: by mail-vk0-f44.google.com with SMTP id x130so253077600vkc.0
        for <fio@vger.kernel.org>; Mon, 25 Jul 2016 10:13:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nn5git$q4l$1@ger.gmane.org>
References: <nn5git$q4l$1@ger.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 25 Jul 2016 18:13:57 +0100
Message-ID: <CALjAwxgP4k4rRFAgpiJ-oBaBHd0OAyXXJ-dTZg7QxyaD36dO_g@mail.gmail.com>
Subject: Re: fio jobs time_based & runtime scope
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saeed <ionictea@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 25 July 2016 at 18:00, Saeed <ionictea@gmail.com> wrote:
> If a job file contains x number of job declarations ([jobxx]) how does the
> 'time_based" and 'runtime' scoped?
>
> Is it per job declaration or inclusive of all the job declarations in the
> file?  I'm trying to set a limit in run time to have the jobs run until a
> certain amount of time has been reached and the jobs still run over the
> 'runtime' defined limit

Could you give a minimal job file that demonstrates the problem and
just to check are you using time_based too
(https://github.com/axboe/fio/blob/fio-2.13/HOWTO#L1200 )?

-- 
Sitsofe | http://sucs.org/~sits/
