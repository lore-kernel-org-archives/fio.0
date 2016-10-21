Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33119 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750856AbcJUFzw (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2016 01:55:52 -0400
Received: by mail-vk0-f41.google.com with SMTP id 83so102726143vkd.0
        for <fio@vger.kernel.org>; Thu, 20 Oct 2016 22:55:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOHuL9gEd8VoDuyirSosdTwyQETskOgTvCyEGEPJoDEQS+9K=A@mail.gmail.com>
References: <CAOHuL9gEd8VoDuyirSosdTwyQETskOgTvCyEGEPJoDEQS+9K=A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 21 Oct 2016 06:55:51 +0100
Message-ID: <CALjAwxgw7fH165NOn_AEtax3vOdec2zJw0FGU1x4LXkxHBLdkw@mail.gmail.com>
Subject: Re: Results too good to be true?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tarek <cashew250@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 21 October 2016 at 02:30, Tarek <cashew250@gmail.com> wrote:
> 10 NVME Intel DC P3600 spec'd at 450K Random Read 32QD 4 Jobs
> I ran 128QD, 3 Jobs each and got aggregate total of  iops=7039.3K!
> That's more than
> the spec (granted they didn't spec it for 128QD). Results below and
> Fio File below that
> can you take a look if I am overlooking something?

If you run using only one drive land ook at iostat while the job is
running does that show radically different information?

-- 
Sitsofe | http://sucs.org/~sits/
