Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f45.google.com ([209.85.217.45]:36067 "EHLO
        mail-vs1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbeJaWUF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Oct 2018 18:20:05 -0400
Received: by mail-vs1-f45.google.com with SMTP id v205so7341941vsc.3
        for <fio@vger.kernel.org>; Wed, 31 Oct 2018 06:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAFF4W0XipV0ZuAMX9DbXH7P8aVJ0jHP-G+vqmE4o5e0edG79nQ@mail.gmail.com>
In-Reply-To: <CAFF4W0XipV0ZuAMX9DbXH7P8aVJ0jHP-G+vqmE4o5e0edG79nQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 31 Oct 2018 13:21:37 +0000
Message-ID: <CALjAwxi0CnZz1SF0U-maHaTpEJUe6k4C4XN6FXxYnZQ42qpcSg@mail.gmail.com>
Subject: Re: Query Regarding <local-args> in fio <local-args>
 --client=<server> <remote-args> <job file(s)>
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mohanraj B <bmohanraj91@gmail.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 31 Oct 2018 at 11:14, Mohanraj B <bmohanraj91@gmail.com> wrote:
>
> Hi all,
>
> https://fio.readthedocs.io/en/latest/fio_doc.html#client-server
>
> Under client/server section, below command is given
> fio <local-args> --client=<server> <remote-args> <job file(s)>
>
> Need to know, what are the arguments we can use for the client side -
> <local-args>.

Won't those be things like
https://fio.readthedocs.io/en/latest/fio_doc.html#command-line-options
?

-- 
Sitsofe | http://sucs.org/~sits/

