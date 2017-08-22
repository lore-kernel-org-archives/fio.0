Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35886 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbdHVToq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 Aug 2017 15:44:46 -0400
Received: by mail-vk0-f48.google.com with SMTP id u133so62609997vke.3
        for <fio@vger.kernel.org>; Tue, 22 Aug 2017 12:44:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DE927C68B458BE418D582EC97927A9287FCB1DC7@ORSMSX113.amr.corp.intel.com>
References: <DE927C68B458BE418D582EC97927A9287FCAD035@ORSMSX113.amr.corp.intel.com>
 <FA2D9B8E-F7EB-48EA-A05B-E7F365A8767C@netapp.com> <DE927C68B458BE418D582EC97927A9287FCAD0D5@ORSMSX113.amr.corp.intel.com>
 <DE927C68B458BE418D582EC97927A9287FCADCEC@ORSMSX113.amr.corp.intel.com>
 <DE927C68B458BE418D582EC97927A9287FCB1765@ORSMSX113.amr.corp.intel.com>
 <BN3PR0401MB14574C48E4CBA2612091232C8F870@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxgfN6rS8oLuxfVo868bXYdB_Z_EQNzPTjyD-8_AET6b_A@mail.gmail.com>
 <f1fb2a4a-6c28-0d3a-4c51-d3e3a7fef101@dell.com> <CALjAwxixiMtWAZYkeTP4icOZQs0ziq=4ZmUkqoBGba6Wib162g@mail.gmail.com>
 <DE927C68B458BE418D582EC97927A9287FCB1DC7@ORSMSX113.amr.corp.intel.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 22 Aug 2017 20:44:15 +0100
Message-ID: <CALjAwxiyMScH96iXvpe-VFEDEBDJ23bdz4DjPF_4zEt7naTjNQ@mail.gmail.com>
Subject: Re: IOPS Log Incorrect?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Gruher, Joseph R" <joseph.r.gruher@intel.com>
Cc: Mikhail Terekhov <Mikhail.Terekhov@dell.com>, Jeff Furlong <jeff.furlong@wdc.com>, neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi all,

This one should hopefully be fixed by
https://github.com/axboe/fio/commit/90e2cd1e1cfc6c2bb4c5643b4864347445f9571e
. Thanks to everyone who participated to get this fixed!

[...]
>> >>>>>> On 8/17/17, 2:38 PM, "fio-owner@vger.kernel.org on behalf of
>> >>>>>> Gruher, Joseph R" <fio-owner@vger.kernel.org on behalf of
>> >>>>>
>> >>>>> joseph.r.gruher@intel.com> wrote:
>> >>>>>>
>> >>>>>>      Hi, I'm using FIO 3.0 on Ubuntu 16.10 with 4.12.7 kernel
>> >>>>>> (also reproduced problem with default 4.8.0-59 kernel). I'm
>> >>>>>> running a 4KB random IO pattern against an Intel P3700 400GB NVMe
>> >>>>>> SSD. I'm trying to view the IOPS/BW over time using the
>> >>>>>> write_bw_log and write_iops_log parameters. FIO is writing the
>> >>>>>> logs but the values in the logs don't align with the summary for
>> >>>>>> the run.  Here's a simple example.  Notice FIO reports 398K IOPS
>> >>>>>> for the run overall, but the IOPS log file shows 383K for the
>> >>>>>> first entry and then values around 56K for the rest of the run,
>> >>>>>> so

-- 
Sitsofe | http://sucs.org/~sits/
