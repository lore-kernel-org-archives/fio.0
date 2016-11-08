Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:33479 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbcKHHZS (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2016 02:25:18 -0500
Received: by mail-ua0-f172.google.com with SMTP id 20so140007815uak.0
        for <fio@vger.kernel.org>; Mon, 07 Nov 2016 23:25:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ee28d36c-8fd0-66cd-10c2-817a75f7d9c0@suse.de>
References: <ee28d36c-8fd0-66cd-10c2-817a75f7d9c0@suse.de>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 8 Nov 2016 07:25:16 +0000
Message-ID: <CALjAwxh+8eAF9xSjEi4_J9hZbtt8cFBRQN6SAneeu+fn=c87tQ@mail.gmail.com>
Subject: Re: fio bug report
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Denis Polom <dpolom@suse.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 7 November 2016 at 11:21, Denis Polom <dpolom@suse.de> wrote:
>
> on version fio-2.13-1.25.x86_64 I found following bug:
>
> when fio is executed with options to write to files (etc : --write_iops_log,
> --write_bw_log, --write_lat_log) it creates files with wrong value for one
> of the coordinates. So creating the graphs by gnuplot is not possible.
>
> file context example:
>
> 341692, 0, 1, 1048576
> 342510, 0, 1, 1048576
> 343728, 0, 1, 1048576
> 344551, 0, 1, 1048576
>
> In old fio version fio-2.8-1.34.x86_64 was everything fine:
>
> 339208, 86, 1, 1048576
> 340561, 26, 1, 1048576
> 341692, 54, 1, 1048576
> 342510, 72, 1, 1048576

Could you include a minimal job file that reproduced the problem?
Further do you think it's possible to bisect down to the fio release
that introduced the issue?

-- 
Sitsofe | http://sucs.org/~sits/
