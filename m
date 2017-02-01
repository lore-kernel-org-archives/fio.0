Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33126 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbdBATVD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Feb 2017 14:21:03 -0500
Received: by mail-vk0-f44.google.com with SMTP id k127so266082619vke.0
        for <fio@vger.kernel.org>; Wed, 01 Feb 2017 11:21:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxh6X_oMyCrAR43xXwtzQmyEw5Mwf9rX5kCtj09SbeCYJQ@mail.gmail.com>
References: <cd5deac3ce8b4c6da58b3f720f88941c@bowex36c.micron.com> <CALjAwxh6X_oMyCrAR43xXwtzQmyEw5Mwf9rX5kCtj09SbeCYJQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 1 Feb 2017 19:20:31 +0000
Message-ID: <CALjAwxhQottB9wjeUeCLR+5g_R8DFWHghtBgXWFdWjcC0v54Mw@mail.gmail.com>
Subject: Re: not all the jobs running at equal speed
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Prabhu Murugesan (pmurugesan)" <pmurugesan@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Looking a bit closer:

The jobs in the first run have no stonewall so all 4 jobs will run
simultaneously. The jobs in the second run have stonewall so at any
given time only one of the jobs will be running. Does adding stonewall
to the the global of the first run give similar results to the second
run?

On 1 February 2017 at 19:04, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 1 February 2017 at 16:46, Prabhu Murugesan (pmurugesan)
> <pmurugesan@micron.com> wrote:
>>
>> I am trying to run 4 jobs in parallel in order to fill a drive once randomly. The dut that I am using is a 450GB NVMe drive. The problem is, not all the jobs are running at equal speed. You can find iops log file data for all the jobs below
>
> The numjobs run is going to make all four jobs scribble over the
> "same" range compared to your carefully crafted first run. What
> happens if you set the offset to be 0 for all your jobs in your first
> run and let the size be 100%?
>
> PS: it helps if you reduce the the number of parameters to the bare
> minimum that still show the problem as it's less to look through.
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Sitsofe | http://sucs.org/~sits/
