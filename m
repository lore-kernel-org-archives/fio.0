Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:38599 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751552AbdKVUxJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Nov 2017 15:53:09 -0500
Received: by mail-vk0-f45.google.com with SMTP id k82so10619159vkd.5
        for <fio@vger.kernel.org>; Wed, 22 Nov 2017 12:53:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DE427767-B386-4D12-9976-28C2646A9AC0@linaro.org>
References: <DE427767-B386-4D12-9976-28C2646A9AC0@linaro.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 22 Nov 2017 20:52:38 +0000
Message-ID: <CALjAwxjSD9Bc4jq3uhih1zj=uMZ+qo0bDTicuqdx-_LfFEkS-Q@mail.gmail.com>
Subject: Re: apparent read bandwidth mismatch
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Paolo Valente <paolo.valente@linaro.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 22 November 2017 at 12:37, Paolo Valente <paolo.valente@linaro.org> wrote:
>
> I've noticed that the read mean bandwidth field (field 45), in fio
> minimal output, is systematically higher than the bandwidth field (7).
> In addition, field 45 is higher than the ratio "total I/O (field 6)" /
> "runtime (field 9)", while field 7 is equal to this ratio.
> Is there a reason for that?

This /may/ be down to how they are calculated. One (I think it's your
field 45 aka read_bw_mean) can be an "average of averages" because
it's based on averaging samples whereas the other (field 7 aka
read_bandwidth) does (total I/O / runtime). It might be easier to
match up which is which in JSON or normal mode...

If you are using write_bw_log and log_avg_msec you might be better
able to check this theory by adding all the samples recorded up and
then dividing by the number of them and seeing if that gives you
read_bw_mean ...

If you find out whether this theory is wrong or right please follow up! :-)

-- 
Sitsofe | http://sucs.org/~sits/
