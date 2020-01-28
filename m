Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pj1-f51.google.com ([209.85.216.51]:40242 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgA1VYu (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Jan 2020 16:24:50 -0500
Received: by mail-pj1-f51.google.com with SMTP id 12so1672857pjb.5
        for <fio@vger.kernel.org>; Tue, 28 Jan 2020 13:24:49 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: clock setaffinity failed: Invalid argument
From: Michael Green <mishagreen@gmail.com>
In-Reply-To: <CALjAwxh3k_nQTFnbin=swLV5NCfervPnk57YfM_1GV-b4f0EhA@mail.gmail.com>
Date: Tue, 28 Jan 2020 16:24:46 -0500
Content-Transfer-Encoding: 7bit
Message-Id: <2F99582D-0A5E-45E5-80C8-884FAAF65BB8@gmail.com>
References: <CAHEKYV7Hzs_TbhGsAXoFUP55oGQGeDot+c8Dh3RcLjWrxbqO9Q@mail.gmail.com>
 <CALjAwxh3k_nQTFnbin=swLV5NCfervPnk57YfM_1GV-b4f0EhA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, Mauricio Tavares <raubvogel@gmail.com>
Cc: fio <fio@vger.kernel.org>

Or maybe some of the CPU cores are in cpuset (cgroups)?



> On Jan 28, 2020, at 3:30 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> 
> Hii,
> 
> On Mon, 27 Jan 2020 at 18:25, Mauricio Tavares <raubvogel@gmail.com> wrote:
>> 
>> I am seeing a lot of those errors:
>> 
>> run write in 512K(1)][90.3%][w=1942MiB/s][w=7766 IOPS][eta 03m:13s]
>> clock setaffinity failed: Invalid argument
>> clock setaffinity failed: Invalid argument
>> clock setaffinity failed: Invalid argument
>> [...]
>> clock setaffinity failed: Invalid argument
>> Jobs: 1 (f=1): [W(1)][45.2%][w=2010MiB/s][w=4019 IOPS][eta 18m:07s]
>> 
>> According to https://github.com/axboe/fio/issues/46, I would expect to
>> see a bit more descriptive error (I am compiling using source checked
>> out of https://github.com/axboe/fio on Fedora 31 on Intel), but that
>> is not the case. Any suggestions of what I should be looking into?
> 
> Are you doing this in a container or in some sort of sandbox?
> 
> -- 
> Sitsofe | http://sucs.org/~sits/


