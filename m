Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:58220 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaCPMML (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 16 Mar 2014 08:12:11 -0400
Received: by mail-ve0-f173.google.com with SMTP id oy12so4678597veb.32
        for <fio@vger.kernel.org>; Sun, 16 Mar 2014 05:12:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53243539.5010405@adon.li>
References: <53243539.5010405@adon.li>
Date: Sun, 16 Mar 2014 20:12:10 +0800
Message-ID: <CACVXFVNbNpwH44DHfN+BU2a7KvF=Ah7As3+UwKHB8eGOX6b7ug@mail.gmail.com>
Subject: Re: correct file size to use
From: Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: jvogt <jvogt@adon.li>
Cc: fio@vger.kernel.org

On Sat, Mar 15, 2014 at 7:10 PM, jvogt <jvogt@adon.li> wrote:
> Hi list
>
> I was wondering:
> When i start
> fio --name=/srv/mail/test --size=10M --direct=1 --runtime=60 --time_based
> --group_reporting --refill_buffer --rw=read --numjobs=1
>
> I get as result:
> read : io=1177.4MB, bw=20093KB/s, iops=5023, runt= 60000msec

From fio/HOWTO:

time_based  If set, fio will run for the duration of the runtime
        specified even if the file(s) are completely read or
        written. It will simply loop over the same workload
        as many times as the runtime allows.

The same 10M file will be read many times(118), so most
of times it is read from page cache instead of the file, and
the result can't be accurate enough.



Thanks,
-- 
Ming Lei
