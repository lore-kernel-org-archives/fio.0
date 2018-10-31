Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk1-f175.google.com ([209.85.222.175]:41005 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbeKAF2L (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Nov 2018 01:28:11 -0400
Received: by mail-qk1-f175.google.com with SMTP id 189so9561322qkj.8
        for <fio@vger.kernel.org>; Wed, 31 Oct 2018 13:28:32 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
Subject: Re: automated notification for fio releases
References: <0f34b150-5f5f-6f01-9c19-e04830c9d4ee@gmail.com>
 <CALjAwxhSCN+5C9oRG34rdLc6NKnPUkNO+ND7X=p6fTWemuMsMg@mail.gmail.com>
Message-ID: <7dda5da1-bcbd-e338-60ec-aac424784892@gmail.com>
Date: Wed, 31 Oct 2018 16:28:30 -0400
MIME-Version: 1.0
In-Reply-To: <CALjAwxhSCN+5C9oRG34rdLc6NKnPUkNO+ND7X=p6fTWemuMsMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 10/31/18 11:05 AM, Sitsofe Wheeler wrote:
> On Tue, 30 Oct 2018 at 20:26, Vincent Fu <vincentfu@gmail.com> wrote:
>>
>> Does anyone know of a means to be automatically notified of new fio
>> releases?
>>
>> I have seen Jens post announcements via Twitter, but that is not a
>> social media platform I actively use. As far as I can tell, Github does
>> not provide a means to be notified of new releases.
>>
>> Perhaps the solution is to monitor http://brick.kernel.dk/snaps/ for new
>> fio shortlog files.
> 
> I think there are few things that are doing monitoring of this.
> Repology ( https://repology.org/metapackage/fio/packages ) seems to
> have some way of knowing, Fedora seem to use
> https://release-monitoring.org/project/806/ and I think Debian have
> their own watcher (https://qa.debian.org/cgi-bin/watch?pkg=fio ). You
> might also be able to tell via github
> (https://github.com/axboe/fio/releases and I think there are atom
> feeds off that page).
> 

Thanks, Sitsofe. That helps a lot. I am actually seeking to be notified 
via email of new releases.

I signed up to be notified of fio release-monitoring.org changes via 
Fedora notifications (https://apps.fedoraproject.org/notifications), 
although the filter I created only produced example matches with fio-3.8 
and did not pick up any later releases.

I also set up an IFTTT rule to receive email messages when updates are 
made to the github fio release atom feed 
(https://github.com/axboe/fio/releases.atom).

Finally, I signed up to be notified via https://newreleases.io/.

With any luck I should be bombarded with notifications when fio 3.12 is 
tagged.

