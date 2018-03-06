Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([96.73.9.1]:22741 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753504AbeCFUBt (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Mar 2018 15:01:49 -0500
Subject: Re: Windows: FIO randomly hangs using attached script
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org>
Date: Tue, 6 Mar 2018 13:01:46 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, Rob Scheepens <rob.scheepens@nutanix.com>, David Knierim <knierim@nutanix.com>

On 3/6/2018 9:35 AM, Sitsofe Wheeler wrote:
>
> I tried out the python script but it seemed to be complaining about a
> whitespace issue. After fixing that up it's unclear exactly what fio
> command lines it runs. I think for others to dig in we'd need
> something less fiddly like the raw fio command lines that generate the
> hang. Is there any chance the mystery user could join the mailing list
> so they can answer questions directly? Ideally we'd need a job that
> works on files within a filesystem and ideally nice small files so it
> could go into an AppVeyor job...
>

I've CC'd Rob and David.
You can find the FIO command lines used by running the script in verbose 
mode: it lists them all at the start, then steps through them one by 
one. Unfortunately nobody's had any luck in narrowing down a single run 
that causes the hang.
I forgot to say that the problem has been seen on FIO 3.1 - I never got 
around to trying it on version 3.5, which is now on 
https://bluestop.org/fio .

-- 
Rebecca
