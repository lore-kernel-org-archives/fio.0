Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgIRH1c (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Sep 2020 03:27:32 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28724C06174A
        for <fio@vger.kernel.org>; Fri, 18 Sep 2020 00:27:32 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e17so4302891wme.0
        for <fio@vger.kernel.org>; Fri, 18 Sep 2020 00:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAMuVLDNiDM7uA-2H_GiRZSPT2iho=kVTzg_5G9cdttNp_5nb6w@mail.gmail.com>
In-Reply-To: <CAMuVLDNiDM7uA-2H_GiRZSPT2iho=kVTzg_5G9cdttNp_5nb6w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 18 Sep 2020 08:27:05 +0100
Message-ID: <CALjAwxiX3Fqtor0rjostqNMpT3VKMCkeops8ahC_E467JBQ45w@mail.gmail.com>
Subject: Re: client/server mode error handling
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Frank Ritchie <frankaritchie@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Wed, 16 Sep 2020 at 20:03, Frank Ritchie <frankaritchie@gmail.com> wrote:
>
> Hi all,
>
> I am looking for documentation on how fio handles unavailable servers
> in client/server mode. For instance, if I start a client specifying 10
> servers to run tests on and only 5 are immediately available will fio
> retry, block, fail, etc? Is the behavior configurable?

Client connection is done in
https://github.com/axboe/fio/blob/14060ebb90ce5a0a164d0e5e52c13e31b53b282d/client.c#L601
. Reading through the functions it calls (such as fio_client_connect_ip() see
https://github.com/axboe/fio/blob/14060ebb90ce5a0a164d0e5e52c13e31b53b282d/client.c#L529)
they call ultimately connect() and if that fails for any reason (see
https://man7.org/linux/man-pages/man2/connect.2.html ) an error is returned and
the client exits. In the above scenario, if the fio client tries to connect to
a server that is not running but the port is not being firewalled that client
will exit with an error message (and if firewalled it will eventually timeout).
There is nothing that I see in the current code that would allow
retrying/blocking but you could modify the code to do the connect in a loop
until some number of retries had been done / some timeout reached.  After you
had succeeded with the initial change, you could make it an option that
attached to the client struct and then it would be configurable...


--
Sitsofe | http://sucs.org/~sits/

