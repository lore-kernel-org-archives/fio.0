Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:34605 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdJKGZW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Oct 2017 02:25:22 -0400
Received: by mail-ua0-f194.google.com with SMTP id d45so283057uag.1
        for <fio@vger.kernel.org>; Tue, 10 Oct 2017 23:25:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171010212710.12526-1-andrzej.jakowski@intel.com>
References: <20171010212710.12526-1-andrzej.jakowski@intel.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 11 Oct 2017 07:24:50 +0100
Message-ID: <CALjAwxjDxn78RrOUxHx_Vs_7eMqt+fHbffz2rQMnkH0OSpvtHQ@mail.gmail.com>
Subject: Re: [PATCH] Fix overflow in percentile calculation for Windows
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 10 October 2017 at 22:27, Andrzej Jakowski
<andrzej.jakowski@intel.com> wrote:
> This patch fixes percentile calculation for Windows where overflow
> on 32 bit type happened while calculating actual percentiles.

Just out of idle curiosity what sort of job showed this up - did the
storage have to be something fast with low latency and did the job
have to run a reasonable length of time?

I have a faint hope that by documenting "problem" jobs in the git
commit logs one day in the distant future some soul will be able to
mine the logs for jobs and add them to the list of jobs that should be
retested (e.g. by running under the undefined,integer sanitizer)...

-- 
Sitsofe | http://sucs.org/~sits/
