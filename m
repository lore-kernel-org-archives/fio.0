Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f44.google.com ([209.85.166.44]:36572 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbeKGRFQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Nov 2018 12:05:16 -0500
Received: by mail-io1-f44.google.com with SMTP id o19-v6so11225016iod.3
        for <fio@vger.kernel.org>; Tue, 06 Nov 2018 23:36:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxi0CnZz1SF0U-maHaTpEJUe6k4C4XN6FXxYnZQ42qpcSg@mail.gmail.com>
References: <CAFF4W0XipV0ZuAMX9DbXH7P8aVJ0jHP-G+vqmE4o5e0edG79nQ@mail.gmail.com>
 <CALjAwxi0CnZz1SF0U-maHaTpEJUe6k4C4XN6FXxYnZQ42qpcSg@mail.gmail.com>
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Wed, 7 Nov 2018 13:06:07 +0530
Message-ID: <CAFF4W0W1=oeLsHWb04dxRwp7G1f+PgVzH14PiAU1rspLz2XOrw@mail.gmail.com>
Subject: Re: Query Regarding <local-args> in fio <local-args>
 --client=<server> <remote-args> <job file(s)>
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

Also what <remote-args> will that also the options in the link -
https://fio.readthedocs.io/en/latest/fio_doc.html#command-line-options.

What is purpose of the arguments on the left and right of --client.
pls explain.

Thanks and Regards,
Mohan


On 10/31/18, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On Wed, 31 Oct 2018 at 11:14, Mohanraj B <bmohanraj91@gmail.com> wrote:
>>
>> Hi all,
>>
>> https://fio.readthedocs.io/en/latest/fio_doc.html#client-server
>>
>> Under client/server section, below command is given
>> fio <local-args> --client=<server> <remote-args> <job file(s)>
>>
>> Need to know, what are the arguments we can use for the client side -
>> <local-args>.
>
> Won't those be things like
> https://fio.readthedocs.io/en/latest/fio_doc.html#command-line-options
> ?
>
> --
> Sitsofe | http://sucs.org/~sits/
>

