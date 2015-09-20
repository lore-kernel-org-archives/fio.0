Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:32908 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbITHfq (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 20 Sep 2015 03:35:46 -0400
Received: by iofh134 with SMTP id h134so93396393iof.0
        for <fio@vger.kernel.org>; Sun, 20 Sep 2015 00:35:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU406-EAS1200B1366C5B77840349795E0580@phx.gbl>
References: <BLU406-EAS1200B1366C5B77840349795E0580@phx.gbl>
Date: Sun, 20 Sep 2015 08:35:45 +0100
Message-ID: <CALjAwxjwPs0uRAjax0t9-gookh7iRVWSGsKKYv77skVKLQPSvw@mail.gmail.com>
Subject: Re: Latency Output Question
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jon Tango <cheerios123@outlook.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jon

On 19 September 2015 at 18:32, Jon Tango <cheerios123@outlook.com> wrote:
>
> Alos, is there a way to just get one average latency output, instead of a
> separate one for read, and write?

This is more of a question of statistics and is it meaningful to
combine particular results into single scalar result. If my total
throughput over one second for reads of a fixed size is 25MBytes but
for writes (of the same fixed size) I get 1MByte is it meaningful to
say my average throughput is 13MBytes? I think a decision to do
something like that has to be made by postprocessing results and
adding the necessary qualifications...

-- 
Sitsofe | http://sucs.org/~sits/
