Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:32918 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbcGNFW4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jul 2016 01:22:56 -0400
Received: by mail-vk0-f44.google.com with SMTP id x130so95516457vkc.0
        for <fio@vger.kernel.org>; Wed, 13 Jul 2016 22:22:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nlhb66$rd6$1@ger.gmane.org>
References: <nlha7f$a7q$2@ger.gmane.org> <nlhb66$rd6$1@ger.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 14 Jul 2016 06:22:55 +0100
Message-ID: <CALjAwxjnttcDporW3ep6hi7URVUCnD=GCwdYpmR10DHkQPTfEw@mail.gmail.com>
Subject: Re: fio2gnuplot issue
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saeed Tea <ionictea@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, erwan@enovance.com

> On 2016-07-05 21:52:47 +0000, Saeed Tea said:
>
>> I'm trying generate graphs with logs create by fio using fio2gnu and keep
>> getting this error when generating graphs for iops or bandwidth:
>>
>> 1 files Selected with pattern '*_iops.log'
>> |-> 4k.results_iops.log
>>
>> Running gnuplot Rendering
>> "/usr/share/fio//math.gpm", line 25: no datablock named $1
>>
>> "/usr/share/fio//graph2D.gpm", line 25: no datablock named $1
>>
>>
>> Rendering traces are available in the current directory
>>
>> Checking the directory listing only shows this file:
>>
>> $3.png
>>
>> Am I missing something in fio profile??  Here's a snippet:

This happens because you have gnuplot 5 and it dropped support for the
$1 way of passing arguments on the command line (see
http://stackoverflow.com/a/31815067/4513656 ). To get around this both
the .gpm and and fio2gnuplot would have to be rewritten to use a
different means of passing parameters in. I'm not sure any method
beyond using environment variables would work for both old and new
versions of gnuplot...

CC'ing the original author of fio2gnuplot for comment.

-- 
Sitsofe | http://sucs.org/~sits/
