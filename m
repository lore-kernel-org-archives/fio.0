Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:38545 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751744AbdJKOgS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Oct 2017 10:36:18 -0400
Received: by mail-vk0-f66.google.com with SMTP id d12so562760vkf.5
        for <fio@vger.kernel.org>; Wed, 11 Oct 2017 07:36:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxjDxn78RrOUxHx_Vs_7eMqt+fHbffz2rQMnkH0OSpvtHQ@mail.gmail.com>
References: <20171010212710.12526-1-andrzej.jakowski@intel.com> <CALjAwxjDxn78RrOUxHx_Vs_7eMqt+fHbffz2rQMnkH0OSpvtHQ@mail.gmail.com>
From: Andrzej Jakowski <andrzej.jakowski@gmail.com>
Date: Wed, 11 Oct 2017 07:36:16 -0700
Message-ID: <CAOmo8DYoVR6P6jCpx9QrvW_5Yh5UJ9=vz4GMDvp-TKPUq6HW=Q@mail.gmail.com>
Subject: Re: [PATCH] Fix overflow in percentile calculation for Windows
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Andrzej Jakowski <andrzej.jakowski@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

> Just out of idle curiosity what sort of job showed this up - did the
> storage have to be something fast with low latency and did the job
> have to run a reasonable length of time?
Simple workload with more than 2^32 IOs executed.

> I have a faint hope that by documenting "problem" jobs in the git
> commit logs one day in the distant future some soul will be able to
> mine the logs for jobs and add them to the list of jobs that should be
> retested (e.g. by running under the undefined,integer sanitizer)...
>
> --
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
