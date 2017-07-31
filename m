Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:34176 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdGaGSV (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jul 2017 02:18:21 -0400
Received: by mail-ua0-f179.google.com with SMTP id q25so167738204uah.1
        for <fio@vger.kernel.org>; Sun, 30 Jul 2017 23:18:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D2D93BA8.1CCD9%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D2D93BA8.1CCD9%Antonio.Jose.Rodrigues.Neto@netapp.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 31 Jul 2017 07:17:50 +0100
Message-ID: <CALjAwxjvjTHOqCzDM5BiABn_EDyf=H1StyuBwD_gY1Kg4cxeRw@mail.gmail.com>
Subject: Re: FIO and replay_redirect
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

(This is one I meant to reply to but didn't get around to for some reason)

On 4 February 2016 at 22:32, neto from Brazil
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>
> 1) The workload that I capture, all DM devices have 200GB size. My devices
> where I want to replay have 100GB. I believe I will need to match the size
> of all disks (where I captured the workload) with the destination where I
> am going to replay. For example: If I capture a workload with 18 LUNs
> 200GB, to replay I need to have 18 LUNs with 200GB minimum.
>
> 2) I need to replay to more than one device. How can I do that with fio?
> Seems to me replay_redirect is for a single specified device.
>
> 3) Any help why I am getting that error? fio: ioengines.c:422:
> td_io_open_file: Assertion `!fio_file_open(f)' failed.

1) You should be able to use replay_scale
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-replay-scale
)..
2) This still can't be done with fio.
3) Should be fixed since
https://github.com/axboe/fio/commit/96d663ad34f1def5c41a8fe656c15d5c312dffe2
(e.g. 2.16 and later).

-- 
Sitsofe | http://sucs.org/~sits/
