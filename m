Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:35958 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751603AbdC1TJx (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Mar 2017 15:09:53 -0400
Received: by mail-vk0-f47.google.com with SMTP id s68so100001902vke.3
        for <fio@vger.kernel.org>; Tue, 28 Mar 2017 12:09:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <020F9C88-1E06-4EC4-A83D-B7CAA1B54F37@cisco.com>
References: <020F9C88-1E06-4EC4-A83D-B7CAA1B54F37@cisco.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 28 Mar 2017 20:09:21 +0100
Message-ID: <CALjAwxifGothL1Sx0PFqYKsQ02sTbX8ur_ZCZpaB8bL=Q5r3gw@mail.gmail.com>
Subject: Re: How does FIO detect write errors when ioengine is libaio
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Scott Forman (scforman)" <scforman@cisco.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I might be mistaken but isn't the result being put into r and r is
later checked: https://github.com/axboe/fio/blob/565e784df05c2529479eed8a38701a33b01894bd/engines/libaio.c#L164
?

On 28 March 2017 at 19:03, Scott Forman (scforman) <scforman@cisco.com> wrote:
> Hi,
>
> I am trying to determine how fio detects write errors when the ioengine is set to libaio.
>
> From a code example on stack overflow, linux-kernel-aio-functionality, it appears that they can be detected by examining the events returned from io_getevents().
>
> But I do not see any code in libaio.c that examines the events returned from io_getevents().
>
> Can you verify that fio does check for write errors for engine libaio, and if so, where that error checking is done?
>
> Thanks in advance!
>
> Sincerely,
>
> Scott Forman
>
>
>



-- 
Sitsofe | http://sucs.org/~sits/
