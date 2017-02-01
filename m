Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:35299 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdBATEz (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Feb 2017 14:04:55 -0500
Received: by mail-ua0-f180.google.com with SMTP id y9so304951787uae.2
        for <fio@vger.kernel.org>; Wed, 01 Feb 2017 11:04:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cd5deac3ce8b4c6da58b3f720f88941c@bowex36c.micron.com>
References: <cd5deac3ce8b4c6da58b3f720f88941c@bowex36c.micron.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 1 Feb 2017 19:04:24 +0000
Message-ID: <CALjAwxh6X_oMyCrAR43xXwtzQmyEw5Mwf9rX5kCtj09SbeCYJQ@mail.gmail.com>
Subject: Re: not all the jobs running at equal speed
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Prabhu Murugesan (pmurugesan)" <pmurugesan@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 1 February 2017 at 16:46, Prabhu Murugesan (pmurugesan)
<pmurugesan@micron.com> wrote:
>
> I am trying to run 4 jobs in parallel in order to fill a drive once randomly. The dut that I am using is a 450GB NVMe drive. The problem is, not all the jobs are running at equal speed. You can find iops log file data for all the jobs below

The numjobs run is going to make all four jobs scribble over the
"same" range compared to your carefully crafted first run. What
happens if you set the offset to be 0 for all your jobs in your first
run and let the size be 100%?

PS: it helps if you reduce the the number of parameters to the bare
minimum that still show the problem as it's less to look through.

-- 
Sitsofe | http://sucs.org/~sits/
