Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C75FC54EE9
	for <fio@archiver.kernel.org>; Thu,  8 Sep 2022 16:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiIHQYs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Sep 2022 12:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiIHQYr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Sep 2022 12:24:47 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9801408D
        for <fio@vger.kernel.org>; Thu,  8 Sep 2022 09:24:40 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id h22so13301887qtu.2
        for <fio@vger.kernel.org>; Thu, 08 Sep 2022 09:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=10qt5A5z8QWla19JU5pzG3qqCwN5VlrTV/Isck8gcrw=;
        b=leNJjShA//Q8DcYy7nqS39zE4cLw/I1pYBqhtlRQnHsecctxqUJOgkqkiptGgDerpI
         Tq70DxQ9sPCPo2Q989TOeYAP1gRTXYJqLExIIuuQ83CdNxxrpJNoUTMzlhTlXz6d4b1U
         8aTpR70VqUHbVwAdGFfhfE4oth8TDbmqz7p+Z+GzH6vXppl/F8yWmcJZ+H4csXF0Q5KX
         +Bdg6hYX7ycryCPz00RfRk4I96nEMJGAn9Z/auQmzAdOQfaEwovCwTmOK5yvrMbisjRn
         Ote/je4PYrCOrj1p+osU+Sg3PBsoHEfrmF2poJLnzSWOYM+VHfFjjn4kq2hBMiR7PPl3
         iPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=10qt5A5z8QWla19JU5pzG3qqCwN5VlrTV/Isck8gcrw=;
        b=KYIuj3TCGinBBdJR8aVgOMUx59g+VP5QIZiopQoiqYhDvJ2MO7RL7s2g6I75efKdEk
         Bko6X6bx2eHAY5nBhAbycg1n5PL5jwjW4lG/ok+Bs8MnHq0xzp62do6xZ3xtoUQZB0vY
         IX7WiKsLsLd8GthsLdMO7d4tLRykkMjdKo2SaFSSrd7Zbp0p8Mh2LDDZBj7+KTBHbvU3
         LJ+6+YLswsE3/+SZ7uEarlohDJ3JS7h8sjFm4fVOThpeOdJP1z+JElp6UiLUI4dui5R3
         yUukYNlqK/EXoqT9xr7EKMdHONgmxFd0Pugsi0QpjvMRjnm/vJJHSS+KCZqk/QlhZJIU
         do3A==
X-Gm-Message-State: ACgBeo1IjMsj0q37QILkwavh/GJYE9bArq1vEXY8LDf8BZFXk0oGwrI0
        xpJXlnN0MA0lMmpX1u6QECNflwrDgAE2pzDomo7y1kem83dRlw==
X-Google-Smtp-Source: AA6agR75ds/lQs734rwR/k4URDRQAQW5OvdFzzrCHx1jboGf1uCubyfU8PlDDnJFfZWWnPNgUhMHmYzDTkkZPmhyyn0=
X-Received: by 2002:ac8:5fd1:0:b0:344:6746:edd8 with SMTP id
 k17-20020ac85fd1000000b003446746edd8mr8650378qta.24.1662654279536; Thu, 08
 Sep 2022 09:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
 <a48796d8-5d66-a39c-caf0-9b83a47664ab@opensource.wdc.com>
In-Reply-To: <a48796d8-5d66-a39c-caf0-9b83a47664ab@opensource.wdc.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Thu, 8 Sep 2022 11:24:27 -0500
Message-ID: <CADqNVTqQLuC6fXsBg6AnCgFWaNiDX=vjOhHvAskm_EP_vD-Q_Q@mail.gmail.com>
Subject: Re: Best practices for handling drive failures during a run?
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Sep 7, 2022 at 4:01 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:

> Unless you are using continue_on_error=io (or "all"), fio will stop if it
> sees an IO error, or at least the job that gets the IO error will stop.
> The IO error will come from the kernel when your drive stops responding
> (IO timeout and is failed and the drive is reset in that case).

Thanks for this info.

> Which behavior ? That fio stops ? You can try continue_on_error=none and
> fio will not stop until it reaches the time or size limit, even if some
> IOs fail.

I would like fio to fail and exit when the I/O error happens. I was
wondering about a way to setup a scenario where an artificial IO error
will occur to make sure it does, if that makes sense.

> The default IO timeout for the kernel is 30s. If your drive stops
> responding for more than that, IOs will be aborted and failed (the user
> sees an error) and drive reset.

Hmm. I had 65 seconds between any I/O; it sounds like that would've
been enough to fail things, but fio returned immediately after that 65
second delayed I/O, and with no error.

I also found the drive timeout error in syslog:
Sep  7 12:37:43 localhost kernel: [ 4354.600211] nvme nvme0: I/O 870
QID 4 timeout, aborting
Sep  7 12:37:43 localhost kernel: [ 4354.615429] nvme nvme0: Abort status: 0x0
Sep  7 12:38:15 localhost kernel: [ 4386.600297] nvme nvme0: I/O 870
QID 4 timeout, reset controller
Sep  7 12:38:17 localhost kernel: [ 4388.050831] nvme nvme0: 7/0/0
default/read/poll queues
Sep  7 12:38:18 localhost kernel: [ 4389.437287]  nvme0n1: AHDI p1 p2 p4
Sep  7 12:38:18 localhost kernel: [ 4389.437347] nvme0n1: p2 start
2240010287 is beyond EOD, truncated
Sep  7 12:38:18 localhost kernel: [ 4389.437350] nvme0n1: p4 start
2472081425 is beyond EOD, truncated

Combining the fio and syslog, the chain of events appears to be:
4332 seconds - drive IO stops
4353 seconds - syslog entry for timeout/abort
4386 seconds - syslog entry for timeout/reset
4387 seconds - read completes and fio exits without error

Thanks,
Nick
