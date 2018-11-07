Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f41.google.com ([209.85.217.41]:45805 "EHLO
        mail-vs1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730583AbeKHB1L (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Nov 2018 20:27:11 -0500
Received: by mail-vs1-f41.google.com with SMTP id 124so9675797vsp.12
        for <fio@vger.kernel.org>; Wed, 07 Nov 2018 07:56:14 -0800 (PST)
MIME-Version: 1.0
References: <CAFF4W0XipV0ZuAMX9DbXH7P8aVJ0jHP-G+vqmE4o5e0edG79nQ@mail.gmail.com>
 <CALjAwxi0CnZz1SF0U-maHaTpEJUe6k4C4XN6FXxYnZQ42qpcSg@mail.gmail.com> <CAFF4W0W1=oeLsHWb04dxRwp7G1f+PgVzH14PiAU1rspLz2XOrw@mail.gmail.com>
In-Reply-To: <CAFF4W0W1=oeLsHWb04dxRwp7G1f+PgVzH14PiAU1rspLz2XOrw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Nov 2018 15:55:48 +0000
Message-ID: <CALjAwxjCYdpJZAG0S41wC6fkQJqEnFWM4nMWVZvGzMxSjP2iQQ@mail.gmail.com>
Subject: Re: Query Regarding <local-args> in fio <local-args>
 --client=<server> <remote-args> <job file(s)>
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mohanraj B <bmohanraj91@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 7 Nov 2018 at 07:36, Mohanraj B <bmohanraj91@gmail.com> wrote:
>
> Hi,
>
> Also what <remote-args> will that also the options in the link -
> https://fio.readthedocs.io/en/latest/fio_doc.html#command-line-options.

Sorry - I can't work out what you're asking...

> What is purpose of the arguments on the left and right of --client.
> pls explain.

You can have multiple clients (as mentioned
https://fio.readthedocs.io/en/latest/fio_doc.html#client-server ) or
mixtures of local jobs (and options you want to send to the locally
running fio) and jobs you wish to send elsewhere etc.

-- 
Sitsofe | http://sucs.org/~sits/

